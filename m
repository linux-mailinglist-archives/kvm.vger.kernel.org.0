Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F134C8DE4
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiCAOiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiCAOh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA014A1BEF
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 06:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646145434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iTnAspy8mRZ1PXFlseCpednK9lC18HGbtY4WBKKEUMI=;
        b=XtwEcENoMWStJTm9vVFQ6CJICw9liCn3V/1RgJmyiOPxzDFEwgMG0/bi0/6baqqvmZiVTz
        EVfyLgAdT+T38mMq6yCswraZIRF/9FsP+pCrVJmBS6ebEA7bknWojMD0PGgKLc1i3bkGIS
        ScPAZbEQfMB0Lts0jNnMfDU7ZaRcxTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217--mA9aegkOYW3IVC5eZ67iw-1; Tue, 01 Mar 2022 09:37:09 -0500
X-MC-Unique: -mA9aegkOYW3IVC5eZ67iw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB6221091DA8;
        Tue,  1 Mar 2022 14:37:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C89EB842C9;
        Tue,  1 Mar 2022 14:36:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 0/7] nSVM/SVM features
Date:   Tue,  1 Mar 2022 16:36:43 +0200
Message-Id: <20220301143650.143749-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is set of patches for SVM nested features rebased on top of kvm/queue,=
=0D
all of them were already posted before.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (7):=0D
  KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running=0D
  KVM: x86: nSVM: implement nested LBR virtualization=0D
  KVM: x86: nSVM: implement nested VMLOAD/VMSAVE=0D
  KVM: x86: nSVM: support PAUSE filter threshold and count when=0D
    cpu_pm=3Don=0D
  KVM: x86: nSVM: implement nested vGIF=0D
  KVM: x86: SVM: allow to force AVIC to be enabled=0D
  KVM: x86: SVM: allow AVIC to co-exist with a nested guest running=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |   1 +=0D
 arch/x86/include/asm/kvm_host.h    |   7 +-=0D
 arch/x86/kvm/svm/avic.c            |   6 +-=0D
 arch/x86/kvm/svm/nested.c          | 101 +++++++++++++---=0D
 arch/x86/kvm/svm/svm.c             | 177 +++++++++++++++++++++++------=0D
 arch/x86/kvm/svm/svm.h             |  39 ++++++-=0D
 arch/x86/kvm/x86.c                 |  15 ++-=0D
 7 files changed, 290 insertions(+), 56 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

