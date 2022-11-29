Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C426E63C89B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiK2TkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbiK2Tj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:39:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7B358BDE
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669750648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tBZ6anhOwTxMVSJuE8Q5eMuTfnMC1c6DPf6ddnr8upA=;
        b=PDWrJIo812395Ha6PGsLrrZBgPe1i/ZPeXeoZR9z332VgCtWgXAkkr3YVf8EHEV7K4fxur
        Jgamd+QgR4m/Bl2UnKXhP5+lPJALdE/UgoMrGeIOnBkSKI8ciMFLfKsClQaEX1oK+KECCq
        YywLsdkJ01L4eA9hA2tDk0CNhtZBQVc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-GQCJg98lOS2L8CozmutRJg-1; Tue, 29 Nov 2022 14:37:23 -0500
X-MC-Unique: GQCJg98lOS2L8CozmutRJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E217802D32;
        Tue, 29 Nov 2022 19:37:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2861D2027064;
        Tue, 29 Nov 2022 19:37:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 00/11] SVM: vNMI (with my fixes)
Date:   Tue, 29 Nov 2022 21:37:06 +0200
Message-Id: <20221129193717.513824-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This is the vNMI patch series based on Santosh Shukla's vNMI patch series.=
=0D
=0D
In this version of this patch series I addressed most of the review feedbac=
k=0D
added some more refactoring and also I think fixed the issue with migration=
.=0D
=0D
I only tested this on a machine which doesn't have vNMI, so this does need=
=0D
some testing to ensure that nothing is broken.=0D
=0D
Best regards,=0D
       Maxim Levitsky=0D
=0D
Maxim Levitsky (9):=0D
  KVM: nSVM: don't sync back tlb_ctl on nested VM exit=0D
  KVM: nSVM: clean up the copying of V_INTR bits from vmcb02 to vmcb12=0D
  KVM: nSVM: explicitly raise KVM_REQ_EVENT on nested VM exit if L1=0D
    doesn't intercept interrupts=0D
  KVM: SVM: drop the SVM specific H_FLAGS=0D
  KVM: x86: emulator: stop using raw host flags=0D
  KVM: SVM: add wrappers to enable/disable IRET interception=0D
  KVM: x86: add a delayed hardware NMI injection interface=0D
  KVM: SVM: implement support for vNMI=0D
  KVM: nSVM: implement support for nested VNMI=0D
=0D
Santosh Shukla (2):=0D
  x86/cpu: Add CPUID feature bit for VNMI=0D
  KVM: SVM: Add VNMI bit definition=0D
=0D
 arch/x86/include/asm/cpufeatures.h |   1 +=0D
 arch/x86/include/asm/kvm-x86-ops.h |   2 +=0D
 arch/x86/include/asm/kvm_host.h    |  24 +++--=0D
 arch/x86/include/asm/svm.h         |   7 ++=0D
 arch/x86/kvm/emulate.c             |  11 +--=0D
 arch/x86/kvm/kvm_emulate.h         |   7 +-=0D
 arch/x86/kvm/smm.c                 |   2 -=0D
 arch/x86/kvm/svm/nested.c          | 102 ++++++++++++++++---=0D
 arch/x86/kvm/svm/svm.c             | 154 ++++++++++++++++++++++-------=0D
 arch/x86/kvm/svm/svm.h             |  41 +++++++-=0D
 arch/x86/kvm/x86.c                 |  50 ++++++++--=0D
 11 files changed, 318 insertions(+), 83 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

