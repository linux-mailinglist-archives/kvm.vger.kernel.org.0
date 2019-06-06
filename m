Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7272836EED
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 10:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfFFIm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 04:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfFFIm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 04:42:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2FA1E811DC;
        Thu,  6 Jun 2019 08:42:26 +0000 (UTC)
Received: from work-vm (ovpn-116-119.ams2.redhat.com [10.36.116.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B1ED18640;
        Thu,  6 Jun 2019 08:42:25 +0000 (UTC)
Date:   Thu, 6 Jun 2019 09:42:22 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: QEMU/KVM migration backwards compatibility broken?
Message-ID: <20190606084222.GA2788@work-vm>
References: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 06 Jun 2019 08:42:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> Hi,
> 
> Looking at QEMU source code, I am puzzled regarding how migration backwards compatibility is preserved regarding X86CPU.
> 
> As I understand it, fields that are based on KVM capabilities and guest runtime usage are defined in VMState subsections in order to not send them if not necessary.
> This is done such that in case they are not needed and we migrate to an old QEMU which don’t support loading this state, migration will still succeed
> (As .needed() method will return false and therefore this state won’t be sent as part of migration stream).
> Furthermore, in case .needed() returns true and old QEMU don’t support loading this state, migration fails. As it should because we are aware that guest state
> is not going to be restored properly on destination.
> 
> I’m puzzled about what will happen in the following scenario:
> 1) Source is running new QEMU with new KVM that supports save of some VMState subsection.
> 2) Destination is running new QEMU that supports load this state but with old kernel that doesn’t know how to load this state.
> 
> I would have expected in this case that if source .needed() returns true, then migration will fail because of lack of support in destination kernel.
> However, it seems from current QEMU code that this will actually succeed in many cases.
> 
> For example, if msr_smi_count is sent as part of migration stream (See vmstate_msr_smi_count) and destination have has_msr_smi_count==false,
> then destination will succeed loading migration stream but kvm_put_msrs() will actually ignore env->msr_smi_count and will successfully load guest state.
> Therefore, migration will succeed even though it should have failed…
> 
> It seems to me that QEMU should have for every such VMState subsection, a .post_load() method that verifies that relevant capability is supported by kernel
> and otherwise fail migration.
> 
> What do you think? Should I really create a patch to modify all these CPUX86 VMState subsections to behave like this?

I don't know the x86 specific side that much; but from my migration side
the answer should mostly be through machine types - indeed for smi-count
there's a property 'x-migrate-smi-count' which is off for machine types
pre 2.11 (see hw/i386/pc.c pc_compat_2_11) - so if you've got an old
kernel you should stick to the old machine types.

There's nothing guarding running the new machine type on old-kernels;
and arguably we should have a check at startup that complains if
your kernel is missing something the machine type uses.
However, that would mean that people running with -M pc   would fail
on old kernels.

A post-load is also a valid check; but one question is whether,
for a particular register, the pain is worth it - it depends on the
symptom that the missing state causes.  If it's minor then you might
conclude it's not worth a failed migration;  if it's a hung or
corrupt guest then yes it is.   Certainly a warning printed is worth
it.

Dave

> Thanks,
> -Liran
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
