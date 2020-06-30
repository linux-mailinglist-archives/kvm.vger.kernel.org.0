Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2B20F835
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 17:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389409AbgF3PZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 11:25:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57636 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389347AbgF3PZh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 11:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593530736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pkHq4gPyon4ryzXtokU1cdea5U+e9AA/sfN4Eo2sSPA=;
        b=Xnkdy9NijQNwDl4vRLk0AY6UIh9FHkIzdG6EwHUS2uyaWTTrxqf6vuqVFMSZ3vWPejZn8k
        BzTy6Db5CWb5hErWURLuGanrgPl5vvEimm5f+a6fzGKaSos+VOfuoO32Yzjuk+cMQjB5mz
        WKYJKtaKuDnspjvrkSmf/oLoE8Iw53M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-OKnOWfhXPnW6MNtVWQiEYA-1; Tue, 30 Jun 2020 11:25:34 -0400
X-MC-Unique: OKnOWfhXPnW6MNtVWQiEYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03D1C464;
        Tue, 30 Jun 2020 15:25:33 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-245.rdu2.redhat.com [10.10.113.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E35AB5DC1E;
        Tue, 30 Jun 2020 15:25:29 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6B048220C58; Tue, 30 Jun 2020 11:25:29 -0400 (EDT)
Date:   Tue, 30 Jun 2020 11:25:29 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault
 error
Message-ID: <20200630152529.GC322149@redhat.com>
References: <20200625214701.GA180786@redhat.com>
 <87lfkach6o.fsf@vitty.brq.redhat.com>
 <20200626150303.GC195150@redhat.com>
 <874kqtd212.fsf@vitty.brq.redhat.com>
 <20200629220353.GC269627@redhat.com>
 <87sgecbs9w.fsf@vitty.brq.redhat.com>
 <20200630145303.GB322149@redhat.com>
 <87mu4kbn7x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu4kbn7x.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 30, 2020 at 05:13:54PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Jun 30, 2020 at 03:24:43PM +0200, Vitaly Kuznetsov wrote:
> 
> >> 
> >> It's probably me who's missing something important here :-) but I think
> >> you describe how it *should* work as I'm not seeing how we can leave the
> >> loop in kvm_async_pf_task_wait_schedule() other than by 
> >> "if (hlist_unhashed(&n.link)) break;" and this only happens when APF
> >> completes.
> >
> > We don't leave loop in kvm_async_pf_task_wait_schedule(). It will happen
> > before you return to user space.
> >
> > I have not looked too closely but I think following code path might be taken
> > after aync PF has completed.
> >
> > __kvm_handle_async_pf()
> >   idtentry_exit_cond_rcu()
> >     prepare_exit_to_usermode()
> >       __prepare_exit_to_usermode()
> >         exit_to_usermode_loop()
> > 	  do_signal()
> >
> > So once you have been woken up (because APF completed),
> 
> Ah, OK so we still need to complete APF and we can't kill the process
> before this happens, that's what I was missing.
> 
> >  you will
> > return to user space and before that you will check if there are
> > pending signals and handle that signal first before user space
> > gets a chance to run again and retry faulting instruction.
> 
> ...
> 
> >
> >> 
> >> When guest receives the 'page ready' event with an error it (like for
> >> every other 'page ready' event) tries to wake up the corresponding
> >> process but if the process is dead already it can do in-kernel probing
> >> of the GFN, this way we guarantee that the error is always injected. I'm
> >> not sure if it is needed though but in case it is, this can be a
> >> solution. We can add a new feature bit and only deliver errors when the
> >> guest indicates that it knows what to do with them.
> >
> > - Process will be delivered singal after async PF completion and during
> >   returning to user space. You have lost control by then.
> >
> 
> So actually there's no way for kernel to know if the userspace process
> managed to re-try the instruction and get the error injected or if it
> was killed prior to that.

Yes. 

> 
> > - If you retry in kernel, we will change the context completely that
> >   who was trying to access the gfn in question. We want to retain
> >   the real context and retain information who was trying to access
> >   gfn in question.
> 
> (Just so I understand the idea better) does the guest context matter to
> the host? Or, more specifically, are we going to do anything besides
> get_user_pages() which will actually analyze who triggered the access
> *in the guest*?

When we exit to user space, qemu prints bunch of register state. I am
wondering what does that state represent. Does some of that traces
back to the process which was trying to access that hva? I don't
know.

I think keeping a cache of error gfns might not be too bad from
implemetation point of view. I will give it a try and see how
bad does it look.

Vivek

