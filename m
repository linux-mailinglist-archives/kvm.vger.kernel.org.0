Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9A133F4A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 11:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgAHK3u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 8 Jan 2020 05:29:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:50536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgAHK3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 05:29:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 13CB7AAC2;
        Wed,  8 Jan 2020 10:29:48 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Chen Wandun <chenwandun@huawei.com>, rkrcmar@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH next] KVM: Fix debugfs_simple_attr.cocci warnings
References: <1577151674-67949-1-git-send-email-chenwandun@huawei.com>
        <4f193d99-ee9b-5217-c2f6-3a8a96bf1534@redhat.com>
Date:   Wed, 08 Jan 2020 11:29:46 +0100
In-Reply-To: <4f193d99-ee9b-5217-c2f6-3a8a96bf1534@redhat.com> (Paolo
        Bonzini's message of "Tue, 7 Jan 2020 15:01:54 +0100")
Message-ID: <87h816nsv9.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 24/12/19 02:41, Chen Wandun wrote:
>> Use DEFINE_DEBUGFS_ATTRIBUTE rather than DEFINE_SIMPLE_ATTRIBUTE
>> for debugfs files.
>> 
>> Semantic patch information:
>> Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
>> imposes some significant overhead as compared to
>> DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().
>> 
>> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
>
> This patch was sent probably already two or three times, and every time
> I've not been able to understand what is this significant overhead.

As you correctly stated below, the overhead is one
kmalloc(sizeof(struct file_operations)) per opened debugfs file
(i.e. one per debugfs struct file instance). struct file_operations is
equivalent to 33 unsigned longs, so it might not be seen as that
"significant", but it isn't small either.


> With DEFINE_DEBUGFS_ATTRIBUTE:
>
> - the fops member is debugfs_open_proxy_file_operations, which calls
> replace_fops so that the fops->read member is debugfs_attr_read on the
> opened file
>
> - debugfs_attr_read does
>
>         ret = debugfs_file_get(dentry);
>         if (unlikely(ret))
>                 return ret;
>         ret = simple_attr_read(file, buf, len, ppos);
>         debugfs_file_put(dentry);
>
> With DEFINE_SIMPLE_ATTRIBUTE:
>
> - the fops member is debugfs_full_proxy_open, and after
> __full_proxy_fops_init fops->read is initialized to full_proxy_read
>
> - full_proxy_read does
>
>         r = debugfs_file_get(dentry);
>         if (unlikely(r))
>                 return r;
>         real_fops = debugfs_real_fops(filp);
>         r = real_fops->name(args);
>         debugfs_file_put(dentry);
>         return r;
>
> where real_fops->name is again just simple_attr_read.
>
> So the overhead is really just one kzalloc every time the file is
> opened.

Yes.


> I could just apply the patch, but it wouldn't solve the main issue,
> which is that there is a function with a scary name
> ("debugfs_create_file_unsafe") that can be used in very common
> circumstances (with DEFINE_DEBUGFS_ATTRIBUTE.

Agreed, the naming is a bit poor. "debugfs_create_file_no_proxy" or the
like would perhaps have been a better choice.


> Therefore, we could
> instead fix the root cause and avoid using the scary API:
>
> - remove from the .cocci patch the change from debugfs_create_file to
> debugfs_create_file_unsafe.  Only switch DEFINE_SIMPLE_ATTRIBUTE to
> DEFINE_DEBUGFS_ATTRIBUTE
>
> - change debugfs_create_file to automatically detect the "easy" case
> that does not need proxying of fops; something like this:
>
> 	const struct file_operations *proxy_fops;
>
> 	/*
> 	 * Any struct file_operations defined by means of
> 	 * DEFINE_DEBUGFS_ATTRIBUTE() is protected against file removals
> 	 * and thus does not need proxying of read and write fops.
> 	 */
> 	if (!fops ||
> 	    (fops->llseek == no_llseek &&
> 	     ((!fops->read && !fops->read_iter) ||
> 	      fops->read == debugfs_attr_read) &&
> 	     ((!fops->write && !fops->write_iter) ||
> 	      fops->write == debugfs_attr_write) &&
> 	     !fops->poll && !fops->unlocked_ioctl)
> 		return debugfs_create_file_unsafe(name, mode, parent,
> 						  data, fops);
>
> 	/* These are not supported by __full_proxy_fops_init.  */
> 	WARN_ON_ONCE(fops->read_iter || fops->write_iter);
> 	return __debugfs_create_file(name, mode, parent, data,
> 				    &debugfs_full_proxy_file_operations,
> 				     fops);
>
> CCing Nicolai Stange who first introduced debugfs_create_file_unsafe.

I'm not strictly against your proposal, but I somewhat dislike the idea
of adding runtime checks for special cases to work around a historic
issue. Also, we'd either have to touch the ~63 existing call sites of
debugfs_create_file_unsafe() again or had to live with inconsistent
debugfs usage patterns.

AFAICT, your approach wouldn't really put a relieve on maintainers
wrt. patch count as the cocci check for the DEFINE_SIMPLE_ATTRIBUTE ->
DEFINE_DEBUGFS_ATTRIBUTE conversion would still be needed.

And then there's grepability: right now it would be possible to find all
fully proxied debugfs files by means of "git grep 'debugfs_file_create('".
I'm not saying I'm about to convert these, but in theory it could be
done easily.

How about introducing a
  #define debugfs_create_attr debugfs_create_file_unsafe
instead to make those
s/DEFINE_SIMPLE_ATTRIBUTE/DEFINE_DEBUGFS_ATTRIBUTE/
patches look less scary?

Ideally, for the sake of additional safety, DEFINE_DEBUGFS_ATTRIBUTE
could be made to wrap the file_operations within something like a
struct debugfs_attr_file_operations and debugfs_create_attr() would
take that instead of a plain file_operations. But again, this would
require touching the existing users of debugfs_create_file_unsafe()...
So I'm not sure it would be worth it.
c

Thanks,

Nicolai

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
