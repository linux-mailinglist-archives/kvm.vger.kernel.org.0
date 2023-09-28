Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D8E7B2062
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjI1PFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjI1PF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:05:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA77D1AE
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695913475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=loADJkQmm3NMp2euPIHq0njfjxsbikdzpGiKHJE7uMw=;
        b=eStoFu/QRPkzv0Tg7gTRAAzOFrUWH29Kp+k9okBX6cz0ySA0uH10BY05nWi6akdCJpODEs
        dcx/MVu5W3XVu9NV4JhbNlHYmBncabYtxWU2C8w3RsyfoSv+vH/Rd0+rl8y5znSFFBlTdf
        poGMS7qvMTVKQyTGSCYXAvhrJY9lfp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-4mc4vLxuPUmwvAq12kDf1A-1; Thu, 28 Sep 2023 11:04:33 -0400
X-MC-Unique: 4mc4vLxuPUmwvAq12kDf1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE131811E7E;
        Thu, 28 Sep 2023 15:04:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2726240C6E76;
        Thu, 28 Sep 2023 15:04:28 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/5] AVIC bugfixes and workarounds
Date:   Thu, 28 Sep 2023 18:04:23 +0300
Message-Id: <20230928150428.199929-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This patch series includes several fixes to AVIC I found while working=0D
on a new version of nested AVIC code.=0D
=0D
Also while developing it I realized that a very simple workaround for=0D
AVIC's errata #1235 exists and included it in this patch series as well.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  x86: KVM: SVM: fix for x2avic CVE-2023-5090=0D
  x86: KVM: SVM: add support for Invalid IPI Vector interception=0D
  x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()=0D
  iommu/amd: skip updating the IRTE entry when is_run is already false=0D
  x86: KVM: SVM: workaround for AVIC's errata #1235=0D
=0D
 arch/x86/include/asm/svm.h |  1 +=0D
 arch/x86/kvm/svm/avic.c    | 55 +++++++++++++++++++++++++++-----------=0D
 arch/x86/kvm/svm/nested.c  |  3 +++=0D
 arch/x86/kvm/svm/svm.c     |  3 +--=0D
 drivers/iommu/amd/iommu.c  |  9 +++++++=0D
 5 files changed, 54 insertions(+), 17 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

