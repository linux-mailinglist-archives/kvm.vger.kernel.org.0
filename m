Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A691C34F75D
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 05:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhCaDUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 23:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhCaDTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 23:19:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9704C06175F
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o129so745102ybg.23
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=AxjHjFrYfKI0arB2F1ZWltZrEdR0g/4Qm9dbdrZzkxk=;
        b=LKQVUEz7W1hc1V11sLG/5o9F1h5djL8UVdiWgm2BJ4XSNQXtcBrgZ5NVoEUNtKU+wl
         V+mf1ZEX5NA4i9zJnPvje9Kkx0yg/Ag1ppVoKFk+B5TR+/hlh6SqPvjhjyTmY/5rZTe/
         Y1Cx+BrzkWXpQ6kyjrbc/fgjjmR4TAJPmv37ZXE36/byW9TUXDrjHdqcV0aIEJzYPnMJ
         xp9TtdADSwQLgeQp/EQHlji+TnzWlZ3IEcwlU73/crBG59StMp1e5lAXgNzVYO25R0hY
         mDIDisw5ERtFfPVsT9kZO06WR6qNv6ZOloumT7jW4vbNgYjM2wnJypJNkor70gT1TAvB
         EAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=AxjHjFrYfKI0arB2F1ZWltZrEdR0g/4Qm9dbdrZzkxk=;
        b=iOvzzuxN3hpRGfJVnLr0yn2Ey4w74ZP/qhLPaCmhyHBp2DS9gCN8DknE3/bjTj+lwE
         tdY31jyTxysAZs7tEB+Vgc9KU5FP3zKipl4jDSaiISvgE4uMPk9FpgPHtIVF+WV6tmJy
         BTp9xLxycbv0Q4em5nqQZg7bZHfOWwDYh4DocphiFZfKdvtujWaNKKOqG+c8r7iVviqt
         FrXLGKCkhYwTS1MXSr9H3AzXZOaKS/7DGqRCs7yCjDEbCvlIvC/RLUf3nG98D9PbbIBw
         Vfb7wLIFOOODY3sGLUfQdw/8qQZ4Mi1o6G0oGkCkSkRT2dPwzXD2zp+Ly1osKZ/igCfE
         xjXQ==
X-Gm-Message-State: AOAM5326FgG3d2H2C4agSsSi9w5wgjTRYT8ULtK17JQLuTR/og8eYAJg
        pRlbPMJv/xyogDpcIRj99BFHvRgRsyw=
X-Google-Smtp-Source: ABdhPJwMmyDI3xSTPxYqu+BbEtNr9UbWLJdYEeyFVIvBJrYrEWnpDSyGGibBiSxulYkloZvi2w2/pV6SgTM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a25:850a:: with SMTP id w10mr1756273ybk.402.1617160786960;
 Tue, 30 Mar 2021 20:19:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 20:19:35 -0700
In-Reply-To: <20210331031936.2495277-1-seanjc@google.com>
Message-Id: <20210331031936.2495277-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210331031936.2495277-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 2/3] KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set sev->es_active only after the guts of KVM_SEV_ES_INIT succeeds.  If
the command fails, e.g. because SEV is already active or there are no
available ASIDs, then es_active will be left set even though the VM is
not fully SEV-ES capable.

Refactor the code so that "es_active" is passed on the stack instead of
being prematurely shoved into sev_info, both to avoid having to unwind
sev_info and so that it's more obvious what actually consumes es_active
in sev_guest_init() and its helpers.

Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6481d7165701..97d42a007b86 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -87,7 +87,7 @@ static bool __sev_recycle_asids(int min_asid, int max_asid)
 	return true;
 }
 
-static int sev_asid_new(struct kvm_sev_info *sev)
+static int sev_asid_new(bool es_active)
 {
 	int pos, min_asid, max_asid;
 	bool retry = true;
@@ -98,8 +98,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
 	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
 	 */
-	min_asid = sev->es_active ? 0 : min_sev_asid - 1;
-	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
+	min_asid = es_active ? 0 : min_sev_asid - 1;
+	max_asid = es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
 	pos = find_next_zero_bit(sev_asid_bitmap, max_sev_asid, min_asid);
 	if (pos >= max_asid) {
@@ -179,13 +179,14 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	bool es_active = argp->id == KVM_SEV_ES_INIT;
 	int asid, ret;
 
 	ret = -EBUSY;
 	if (unlikely(sev->active))
 		return ret;
 
-	asid = sev_asid_new(sev);
+	asid = sev_asid_new(es_active);
 	if (asid < 0)
 		return ret;
 
@@ -194,6 +195,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 
 	sev->active = true;
+	sev->es_active = es_active;
 	sev->asid = asid;
 	INIT_LIST_HEAD(&sev->regions_list);
 
@@ -204,16 +206,6 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
-static int sev_es_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
-{
-	if (!sev_es)
-		return -ENOTTY;
-
-	to_kvm_svm(kvm)->sev_info.es_active = true;
-
-	return sev_guest_init(kvm, argp);
-}
-
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
 {
 	struct sev_data_activate *data;
@@ -1128,12 +1120,15 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (sev_cmd.id) {
+	case KVM_SEV_ES_INIT:
+		if (!sev_es) {
+			r = -ENOTTY;
+			goto out;
+		}
+		fallthrough;
 	case KVM_SEV_INIT:
 		r = sev_guest_init(kvm, &sev_cmd);
 		break;
-	case KVM_SEV_ES_INIT:
-		r = sev_es_guest_init(kvm, &sev_cmd);
-		break;
 	case KVM_SEV_LAUNCH_START:
 		r = sev_launch_start(kvm, &sev_cmd);
 		break;
-- 
2.31.0.291.g576ba9dcdaf-goog

