Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0106362DE3F
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbiKQOeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbiKQOd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:33:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC192AE3B
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 06:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668695573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lbVyA8e03/oayhLH0NTwSULaemKUfym9WQ80/S7gmjE=;
        b=VTOrFJW9dwPJqXi2kbWHTF268BsHTh8O+wpbcNXnmDAfptSkrBMpjofTCdcuLl+PDljpCJ
        5i+y8mA9zBp1leyVrDx5vKWB3W7Tr6cqneogDOwHDbKBQJe7fAUuaYAcXlM8SsYDhUIX8n
        fLndOExkS6Ax3ccfiPyUb2kdP0rlGs0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-IWHx6XvEM62PLM7C-VCOpw-1; Thu, 17 Nov 2022 09:32:48 -0500
X-MC-Unique: IWHx6XvEM62PLM7C-VCOpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AD0F85A5A6;
        Thu, 17 Nov 2022 14:32:47 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCC2A2166B29;
        Thu, 17 Nov 2022 14:32:43 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 00/13] SVM: vNMI (with my fixes)
Date:   Thu, 17 Nov 2022 16:32:29 +0200
Message-Id: <20221117143242.102721-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This is the vNMI patch series from Santosh Shukla with few=0D
small fixes from me:=0D
=0D
1. When a vNMI injection is pending, then to allow to not=0D
  delay for an unbounded time the injection of another NMI that could=0D
  arrive before the first vNMI injection is done, I added the code=0D
  that would intercept IRET/RSM/STGI and then try the injection again.=0D
=0D
2. I slighlty modified the 'KVM: SVM: Add VNMI support in get/set_nmi_mask'=
=0D
   to have WARN_ON in vNMI functions when called without vNMI enabled.=0D
   Also NMI mask/unmask should be allowed regardless if SMM is active,=0D
   to support migration.=0D
=0D
3. I did some refactoring in the code which updates the int_ctl in vmcb12=0D
   on nested VM exit, and updated the patch 'KVM: nSVM: implement nested VN=
MI'=0D
   to use this.=0D
=0D
4. I added my reviewed-by to all the patches which I didn't change.=0D
=0D
I only tested this on a machine which doesn't have vNMI, so this does need=
=0D
some testing to ensure that nothing is broken.=0D
=0D
Another thing I haven't looked at in depth yet is migration, I think there =
is a bug=0D
because with vNMI, now in practise we can have 2 NMIs injected to the guest=
,=0D
one in service, one 'pending injection' but no longer pending from KVM poin=
t of view,=0D
and the KVM doesn't take this in account in kvm_vcpu_ioctl_x86_get_vcpu_eve=
nts,a=0D
and maybe more.=0D
=0D
Best regards,=0D
       Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  KVM: nSVM: don't sync back tlb_ctl on nested VM exit=0D
  KVM: nSVM: don't call nested_sync_control_from_vmcb02 on each VM exit=0D
  KVM: nSVM: rename nested_sync_control_from_vmcb02 to=0D
    nested_sync_int_ctl_from_vmcb02=0D
  KVM: nSVM: clean up copying of int_ctl fields back to vmcb01/vmcb12=0D
  KVM: SVM: allow NMI window with vNMI=0D
=0D
Santosh Shukla (8):=0D
  x86/cpu: Add CPUID feature bit for VNMI=0D
  KVM: SVM: Add VNMI bit definition=0D
  KVM: SVM: Add VNMI support in get/set_nmi_mask=0D
  KVM: SVM: Report NMI not allowed when Guest busy handling VNMI=0D
  KVM: SVM: Add VNMI support in inject_nmi=0D
  KVM: nSVM: implement nested VNMI=0D
  KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI=0D
  KVM: SVM: Enable VNMI feature=0D
=0D
 arch/x86/include/asm/cpufeatures.h |  1 +=0D
 arch/x86/include/asm/svm.h         |  7 +++=0D
 arch/x86/kvm/svm/nested.c          | 84 +++++++++++++++++++++---------=0D
 arch/x86/kvm/svm/svm.c             | 60 ++++++++++++++++++---=0D
 arch/x86/kvm/svm/svm.h             | 70 ++++++++++++++++++++++++-=0D
 5 files changed, 189 insertions(+), 33 deletions(-)=0D
=0D
-- =0D
2.34.3=0D
=0D

