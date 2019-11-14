Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4F7FC744
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 14:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKNNXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 08:23:01 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:34949 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfKNNXB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 08:23:01 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iVF5L-0003Wl-Qy; Thu, 14 Nov 2019 14:22:55 +0100
To:     Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when  =?UTF-8?Q?CONFIG=5FKVM=5FCOMPAT=3Dn?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Nov 2019 13:22:55 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
In-Reply-To: <e781ec19-1a93-c061-9236-46c8a8f698db@redhat.com>
References: <20191113160523.16130-1-maz@kernel.org>
 <2b846839-ea81-e40c-5106-90776d964e33@de.ibm.com>
 <CAFEAcA8c3ePLXRa_-G0jPgMVVrFHaN1Qn3qRf-WShPXmNXX6Ug@mail.gmail.com>
 <20191114081550.3c6a7a47@why>
 <5576baca-458e-3206-bdc5-5fb8da00cf6d@de.ibm.com>
 <e781ec19-1a93-c061-9236-46c8a8f698db@redhat.com>
Message-ID: <4a9380afe118031c77be53112d73d5d4@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, borntraeger@de.ibm.com, peter.maydell@linaro.org, kvm@vger.kernel.org, rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org, frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-14 12:12, Paolo Bonzini wrote:
> On 14/11/19 09:20, Christian Borntraeger wrote:
>>
>>
>> On 14.11.19 09:15, Marc Zyngier wrote:
>>> On Wed, 13 Nov 2019 21:23:07 +0000
>>> Peter Maydell <peter.maydell@linaro.org> wrote:
>>>
>>>> On Wed, 13 Nov 2019 at 18:44, Christian Borntraeger
>>>> <borntraeger@de.ibm.com> wrote:
>>>>> On 13.11.19 17:05, Marc Zyngier wrote:
>>>>>> On a system without KVM_COMPAT, we prevent IOCTLs from being 
>>>>>> issued
>>>>>> by a compat task. Although this prevents most silly things from
>>>>>> happening, it can still confuse a 32bit userspace that is able
>>>>>> to open the kvm device (the qemu test suite seems to be pretty
>>>>>> mad with this behaviour).
>>>>>>
>>>>>> Take a more radical approach and return a -ENODEV to the compat
>>>>>> task.
>>>>
>>>>> Do we still need compat_ioctl if open never succeeds?
>>>>
>>>> I wondered about that, but presumably you could use
>>>> fd-passing, or just inheriting open fds across exec(),
>>>> to open the fd in a 64-bit process and then hand it off
>>>> to a 32-bit process to call the ioctl with. (That's
>>>> probably only something you'd do if you were
>>>> deliberately playing silly games, of course, but
>>>> preventing silly games is useful as it makes it
>>>> easier to reason about kernel behaviour.)
>>>
>>> This was exactly my train of thoughts, which I should have made 
>>> clear
>>> in the commit log. Thanks Peter for reading my mind! ;-)
>>
>> Makes sense. Looks like this is already in kvm/master so we cannot 
>> improve
>> the commit message easily any more. Hopefully we will not forget :-)
>
> A comment in the code would probably be better than the commit 
> message,
> to not forget stuff like this.  (Hint! :))

Hint received. How about this?

         M.

 From 34bfc68752253c3da3e59072b137d1a4a85bc005 Mon Sep 17 00:00:00 2001
 From: Marc Zyngier <maz@kernel.org>
Date: Thu, 14 Nov 2019 13:17:39 +0000
Subject: [PATCH] KVM: Add a comment describing the /dev/kvm no_compat 
handling

Add a comment explaining the rational behind having both
no_compat open and ioctl callbacks to fend off compat tasks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
  virt/kvm/kvm_main.c | 7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1243e48dc717..722f2b1d4672 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -120,6 +120,13 @@ static long kvm_vcpu_compat_ioctl(struct file 
*file, unsigned int ioctl,
  				  unsigned long arg);
  #define KVM_COMPAT(c)	.compat_ioctl	= (c)
  #else
+/*
+ * For architectures that don't implement a compat infrastructure,
+ * adopt a double line of defense:
+ * - Prevent a compat task from opening /dev/kvm
+ * - If the open has been done by a 64bit task, and the KVM fd
+ *   passed to a compat task, let the ioctls fail.
+ */
  static long kvm_no_compat_ioctl(struct file *file, unsigned int ioctl,
  				unsigned long arg) { return -EINVAL; }

-- 
2.20.1


-- 
Jazz is not dead. It just smells funny...
