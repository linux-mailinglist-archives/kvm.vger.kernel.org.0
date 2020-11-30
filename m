Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5472D2C85A3
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 14:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgK3Nho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 08:37:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbgK3Nhn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 08:37:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606743377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JaI15Fwv38N9n7wxFz/5+sDT0HAIaiSWwhif2Atz1Yc=;
        b=PwtM3134C40LSexFIBNXvHoDHzNooHIDUxg3FMAltcZR6yjm2FrVP0933nB2CgsnI6rpA5
        JuE+2qXfA2UxE3yCE5Jakh3xEdyTexozxPt/Ex4cqKCfoFKixQHuLJErybPSRzV2cnIGVR
        lFKnkrVo+fQ+OckPpsDb1laTQnqtckk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-9NiJFdElNYeSCtULP1O3pw-1; Mon, 30 Nov 2020 08:36:13 -0500
X-MC-Unique: 9NiJFdElNYeSCtULP1O3pw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32FEA8144E0;
        Mon, 30 Nov 2020 13:36:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6F3860C62;
        Mon, 30 Nov 2020 13:36:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list),
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] RFC: Precise TSC migration
Date:   Mon, 30 Nov 2020 15:35:57 +0200
Message-Id: <20201130133559.233242-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This is the first version of the work to make TSC migration more accurate,=
=0D
as was defined by Paulo at:=0D
https://www.spinics.net/lists/kvm/msg225525.html=0D
=0D
I have a few thoughts about the kvm masterclock synchronization,=0D
which relate to the Paulo's proposal that I implemented.=0D
=0D
The idea of masterclock is that when the host TSC is synchronized=0D
(or as kernel call it, stable), and the guest TSC is synchronized as well,=
=0D
then we can base the kvmclock, on the same pair of=0D
(host time in nsec, host tsc value), for all vCPUs.=0D
=0D
This makes the random error in calculation of this value invariant=0D
across vCPUS, and allows the guest to do kvmclock calculation in userspace=
=0D
(vDSO) since kvmclock parameters are vCPU invariant.=0D
=0D
To ensure that the guest tsc is synchronized we currently track host/guest =
tsc=0D
writes, and enable the master clock only when roughly the same guest's TSC =
value=0D
was written across all vCPUs.=0D
=0D
Recently this was disabled by Paulo and I agree with this, because I think=
=0D
that we indeed should only make the guest TSC synchronized by default=0D
(including new hotplugged vCPUs) and not do any tsc synchronization beyond =
that.=0D
(Trying to guess when the guest syncs the TSC can cause more harm that good=
).=0D
=0D
Besides, Linux guests don't sync the TSC via IA32_TSC write,=0D
but rather use IA32_TSC_ADJUST which currently doesn't participate=0D
in the tsc sync heruistics.=0D
And as far as I know, Linux guest is the primary (only?) user of the kvmclo=
ck.=0D
=0D
I *do think* however that we should redefine KVM_CLOCK_TSC_STABLE=0D
in the documentation to state that it only guarantees invariance if the gue=
st=0D
doesn't mess with its own TSC.=0D
=0D
Also I think we should consider enabling the X86_FEATURE_TSC_RELIABLE=0D
in the guest kernel, when kvm is detected to avoid the guest even from tryi=
ng=0D
to sync TSC on newly hotplugged vCPUs.=0D
=0D
(The guest doesn't end up touching TSC_ADJUST usually, but it still might=0D
in some cases due to scheduling of guest vCPUs)=0D
=0D
(X86_FEATURE_TSC_RELIABLE short circuits tsc synchronization on CPU hotplug=
,=0D
and TSC clocksource watchdog, and the later we might want to keep).=0D
=0D
For host TSC writes, just as Paulo proposed we can still do the tsc sync,=0D
unless the new code that I implemented is in use.=0D
=0D
Few more random notes:=0D
=0D
I have a weird feeling about using 'nsec since 1 January 1970'.=0D
Common sense is telling me that a 64 bit value can hold about 580 years,=0D
but still I see that it is more common to use timespec which is a (sec,nsec=
) pair.=0D
=0D
I feel that 'kvm_get_walltime' that I added is a bit of a hack.=0D
Some refactoring might improve things here.=0D
=0D
For example making kvm_get_walltime_and_clockread work in non tsc case as w=
ell=0D
might make the code cleaner.=0D
=0D
Patches to enable this feature in qemu are in process of being sent to=0D
qemu-devel mailing list.=0D
=0D
Best regards,=0D
       Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: x86: implement KVM_SET_TSC_PRECISE/KVM_GET_TSC_PRECISE=0D
  KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS=0D
=0D
 Documentation/virt/kvm/api.rst  | 56 +++++++++++++++++++++=0D
 arch/x86/include/uapi/asm/kvm.h |  1 +=0D
 arch/x86/kvm/x86.c              | 88 +++++++++++++++++++++++++++++++--=0D
 include/uapi/linux/kvm.h        | 14 ++++++=0D
 4 files changed, 154 insertions(+), 5 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

