Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A8A4E454C
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbiCVRm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239786AbiCVRm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DAEF888C8
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647970858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ne0+XLEONvmZcIPI7aFLzd/4MUtOgZ2yVyR/Gh6tcI8=;
        b=dPr+terD6X9+h4GDmrHO+dv+ATFXkpTFkIwWBm+27qeABDrIhfStrY7RxSWSMqozbhsZ+v
        QoVmvejAZrqNmqUtq6xR9j8AAh1FWY5zaDCWep7+Ekvyvvb+azmd3VyK6GHr1yHbQC7zwq
        s25oNFjKiEeaPaJ0+x4IEIAcJCTndEM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-u4bhh9zqM4mPamm6XF5Ptg-1; Tue, 22 Mar 2022 13:40:55 -0400
X-MC-Unique: u4bhh9zqM4mPamm6XF5Ptg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 912733C153A5;
        Tue, 22 Mar 2022 17:40:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E8D0C26EA9;
        Tue, 22 Mar 2022 17:40:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 0/6] nSVM/SVM features
Date:   Tue, 22 Mar 2022 19:40:44 +0200
Message-Id: <20220322174050.241850-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a set of patches for optional SVM nested features.=0D
=0D
V4: rebased on top of kvm/queue + my patch series 'SVM fixes + refactoring'=
=0D
and incorporated all review feedback.=0D
=0D
This was tested with kvm unit test, running on L0,L1, and L2,=0D
and no new failures were seen.=0D
=0D
This time I also tested this with all new features disabled in L1,=0D
and in L2, to avoid repeating an issue I had in nested tsc scaling.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (6):=0D
  KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running=0D
  KVM: x86: nSVM: implement nested LBR virtualization=0D
  KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept=0D
    PAUSE=0D
  KVM: x86: nSVM: implement nested vGIF=0D
  KVM: x86: allow per cpu apicv inhibit reasons=0D
  KVM: x86: SVM: allow AVIC to co-exist with a nested guest running=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |   1 +=0D
 arch/x86/include/asm/kvm_host.h    |   6 ++=0D
 arch/x86/kvm/svm/avic.c            |   7 ++=0D
 arch/x86/kvm/svm/nested.c          |  83 +++++++++++++--=0D
 arch/x86/kvm/svm/svm.c             | 162 +++++++++++++++++++++++------=0D
 arch/x86/kvm/svm/svm.h             |  41 ++++++--=0D
 arch/x86/kvm/x86.c                 |  14 ++-=0D
 7 files changed, 264 insertions(+), 50 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

