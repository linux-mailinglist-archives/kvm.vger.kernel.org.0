Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0A12CDC16
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgLCRN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:13:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2501942AbgLCRNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607015518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zaqAemO/Fsujg9r8lt/SFqF1ctdGuOQUqsO5lgI9LxY=;
        b=eapRq1a/cEDgA0rlGekknwtGedJqPGEcwuF08WAje/e7/Q0c3mCr2p3nHuSAtCYk7tch61
        vhOX38J70DdI2K/Wv6dDcdeCyaAqbTKitwotK8HCJQAhKsnLYRIYwpARxIw9e4JZ7ETzDm
        LvrKY4WFdLnX03Mxtp+LYPVjFFyfvtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-6I46_4btNSS0GSJXwwek_Q-1; Thu, 03 Dec 2020 12:11:55 -0500
X-MC-Unique: 6I46_4btNSS0GSJXwwek_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51CEC180A089;
        Thu,  3 Dec 2020 17:11:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2475A6F963;
        Thu,  3 Dec 2020 17:11:19 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list),
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Shuah Khan <shuah@kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v2 0/3] RFC: Precise TSC migration
Date:   Thu,  3 Dec 2020 19:11:15 +0200
Message-Id: <20201203171118.372391-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This is the second version of the work to make TSC migration more accurate,=
=0D
as was defined by Paulo at:=0D
https://www.spinics.net/lists/kvm/msg225525.html=0D
=0D
I omitted most of the semi-offtopic points I raised related to TSC=0D
in the previous RFC where we can continue the discussion.=0D
=0D
I do want to raise another thing that I almost forgot.=0D
=0D
On AMD systems, the Linux kernel will mark the guest tsc as=0D
unstable unless invtsc is set which is set on recent AMD=0D
hardware.=0D
=0D
Take a look at 'unsynchronized_tsc()' to verify this.=0D
=0D
This is another thing that IMHO should be fixed at least when=0D
running under KVM.=0D
=0D
Note that I forgot to mention that=0D
X86_FEATURE_TSC_RELIABLE also short-circuits this code,=0D
thus giving another reason to enable it under KVM.=0D
=0D
Changes from V1:=0D
=0D
- added KVM_TSC_STATE_TIMESTAMP_VALID instead of testing ns =3D=3D 0=0D
- allow diff < 0, because it is still better that capping it to 0=0D
- updated tsc_msr_test unit test to cover this feature=0D
- refactoring=0D
=0D
Patches to enable this feature in qemu are in the process of=0D
being sent to qemu-devel mailing list.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: x86: implement KVM_{GET|SET}_TSC_STATE=0D
  KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS=0D
  kvm/selftests: update tsc_msrs_test to cover=0D
    KVM_X86_QUIRK_TSC_HOST_ACCESS=0D
=0D
 Documentation/virt/kvm/api.rst                | 65 +++++++++++++=0D
 arch/x86/include/uapi/asm/kvm.h               |  1 +=0D
 arch/x86/kvm/x86.c                            | 92 ++++++++++++++++++-=0D
 include/uapi/linux/kvm.h                      | 15 +++=0D
 .../selftests/kvm/x86_64/tsc_msrs_test.c      | 79 ++++++++++++++--=0D
 5 files changed, 237 insertions(+), 15 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

