Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75214E4509
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbiCVR0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbiCVR0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:26:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42E7343ED0
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647969902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=d/udLuXKSWOMorDJxeIAomujXKFt54BD9zHjc4cWDSM=;
        b=Ho8SApxFWXoymdvc9onDwIgMI7+EzMlVzKZ9+zm4/It34RSzGlbmXMnU/vdvSj79WGD6wR
        rDiaepy4b/wcHGzHftVHQjKalJAA21EVeEr1/GVrm7747SSSZ9FEgpOAbYwty/wekeRTms
        fiCxkmGpMjx6Y0sdyvitkkCgGgyO8hI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-6IBAYFBMMQGbGS6vqWS_fw-1; Tue, 22 Mar 2022 13:24:59 -0400
X-MC-Unique: 6IBAYFBMMQGbGS6vqWS_fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91E05802809;
        Tue, 22 Mar 2022 17:24:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E9B72166B44;
        Tue, 22 Mar 2022 17:24:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/8] SVM fixes + refactoring
Date:   Tue, 22 Mar 2022 19:24:41 +0200
Message-Id: <20220322172449.235575-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those are few bug fixes which are in my patch queue,=0D
rebased against current kvm/queue.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (8):=0D
  KVM: x86: avoid loading a vCPU after .vm_destroy was called=0D
  KVM: x86: SVM: use vmcb01 in avic_init_vmcb and init_vmcb=0D
  kvm: x86: SVM: use vmcb* instead of svm->vmcb where it makes sense=0D
  KVM: x86: SVM: fix avic spec based definitions again=0D
  KVM: x86: SVM: move tsc ratio definitions to svm.h=0D
  kvm: x86: SVM: remove unused defines=0D
  KVM: x86: SVM: fix tsc scaling when the host doesn't support it=0D
  KVM: x86: SVM: remove vgif_enabled()=0D
=0D
 arch/x86/include/asm/svm.h |  14 ++-=0D
 arch/x86/kvm/svm/avic.c    |   2 +-=0D
 arch/x86/kvm/svm/nested.c  | 179 +++++++++++++++++++------------------=0D
 arch/x86/kvm/svm/svm.c     |  46 ++++------=0D
 arch/x86/kvm/svm/svm.h     |  23 +----=0D
 arch/x86/kvm/vmx/vmx.c     |   7 +-=0D
 arch/x86/kvm/x86.c         |  14 +--=0D
 7 files changed, 134 insertions(+), 151 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

