Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3283DC23E
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 03:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhGaBOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 21:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhGaBOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 21:14:24 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97455C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 18:14:18 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id k7-20020ad453c70000b02902f36ca6afdcso7121446qvv.7
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 18:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Z+jBLOwaMHrD3vpQNOpOohSej7/a6ld7rbOxzY8Rd54=;
        b=KWHmbWUtKjbcYcQHomSb4B1ApPywDoaS8s42TLlijLflq4kD2tH8pFsodAT5RfVXdR
         YK0JWLwaaMRXDvEI/gVHQ6ZUswZh8yMStA1+5QeZCm0Po3n3pybFNfl6FzggLoyeY5Iv
         q/w9t0SvdIbOuoZx6uhxSF8YmjrGimgrVRlmpfEgm9MJUGEH1tdd/ywQ4ClR27guHbpe
         KWHEp/5x6YZ73mOuhFsGBYR+7R1MKA7K5qdR4iAMhUd5lBt9RboH+vjJOo8EMHr6QjLM
         cvfZ7eQTq/Hx5wS+ccpyJ/DgYwYTtk3oiJ+9QNbC86GkFU3Rzu5ELC8FfjSGTkhnIAK0
         9gQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Z+jBLOwaMHrD3vpQNOpOohSej7/a6ld7rbOxzY8Rd54=;
        b=oIz+ILvHDEaDTN+JB7mzZMkMEwH68AFITT3E+kNlQJCJWGWKPNXn8+zEEG2g682ILX
         cQ5IGcIXphKJg6Ayc2iXDu/Gv23UHby5sWMUXbS/H7y9HAeLbGHPZ02mim9f0+qBXX57
         LpWtSkaHdrch6/aZ32Ql6s23QyeyBQNRjez2BRw/CGnPX4M5E7sL1qySLuw5K0cES3BU
         m0SS6ZZUpEdnlyYEm3D4YWabvbnopzz/hrptSWWOg3VU71ZQQq9OZOnEYHvjC9NUEbya
         +zhoFDuQFWZ3KrRJuNlgMlIFTVFCEC+eq7O5ia4XtSCATsLI4alqQxEbr0YdjPxHbTJO
         5xMw==
X-Gm-Message-State: AOAM533f3Zy6Mf8kEL1zL6piN7GcB/a6n4AcNgS7H4/t7XalOofq6yDj
        mfz9CqRUieoxDavaG58BHE9fnLBeeoVH
X-Google-Smtp-Source: ABdhPJzpDwuooUXZRIvdINIqPPnA6y1MqnCrAjWz5q0X22yWSn7QhNy6ZFuYNYPqDYYDEqNujWC9e4rza03J
X-Received: from mihenry-linux-desktop.kir.corp.google.com ([2620:15c:29:204:a198:4c3e:b951:58e3])
 (user=mizhang job=sendgmr) by 2002:a0c:ef4f:: with SMTP id
 t15mr5815346qvs.31.1627694057687; Fri, 30 Jul 2021 18:14:17 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri, 30 Jul 2021 18:13:04 -0700
Message-Id: <20210731011304.3868795-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH] KVM: SEV: improve the code readability for ASID management
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM SEV code uses bitmaps to manage ASID states. ASID 0 was always skipped
because it is never used by VM. Thus, ASID value and its bitmap postion
always has an 'offset-by-1' relationship.

Both SEV and SEV-ES shares the ASID space, thus KVM uses a dynamic range
[min_asid, max_asid] to handle SEV and SEV-ES ASIDs separately.

Existing code mixes the usage of ASID value and its bitmap position by
using the same variable called 'min_asid'.

Fix the min_asid usage: ensure that its usage is consistent with its name;
adjust its value before using it as a bitmap position. Add comments on ASID
bitmap allocation to clarify the skipping-ASID-0 property.

Fixes: 80675b3ad45f (KVM: SVM: Update ASID allocation to support SEV-ES guests)
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Alper Gun <alpergun@google.com>
Cc: Dionna Glaze <dionnaglaze@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>
Ce: Peter Gonda <pgonda@google.com>
---
 arch/x86/kvm/svm/sev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8d36f0c73071..e3902283cbf7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -80,7 +80,7 @@ static int sev_flush_asids(int min_asid, int max_asid)
 	int ret, pos, error = 0;
 
 	/* Check if there are any ASIDs to reclaim before performing a flush */
-	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid);
+	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid - 1);
 	if (pos >= max_asid)
 		return -EBUSY;
 
@@ -142,10 +142,10 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
 	 */
-	min_asid = sev->es_active ? 0 : min_sev_asid - 1;
+	min_asid = sev->es_active ? 1 : min_sev_asid;
 	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
-	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
+	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid - 1);
 	if (pos >= max_asid) {
 		if (retry && __sev_recycle_asids(min_asid, max_asid)) {
 			retry = false;
@@ -1854,7 +1854,10 @@ void __init sev_hardware_setup(void)
 	min_sev_asid = edx;
 	sev_me_mask = 1UL << (ebx & 0x3f);
 
-	/* Initialize SEV ASID bitmaps */
+	/*
+	 * Initialize SEV ASID bitmaps. Note: ASID 0 is skipped since it is
+	 * never used by any VM, thus: ASID value == ASID position + 1;
+	 */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
 	if (!sev_asid_bitmap)
 		goto out;
@@ -1904,7 +1907,7 @@ void sev_hardware_teardown(void)
 		return;
 
 	/* No need to take sev_bitmap_lock, all VMs have been destroyed. */
-	sev_flush_asids(0, max_sev_asid);
+	sev_flush_asids(1, max_sev_asid);
 
 	bitmap_free(sev_asid_bitmap);
 	bitmap_free(sev_reclaim_asid_bitmap);
-- 
2.32.0.554.ge1b32706d8-goog

