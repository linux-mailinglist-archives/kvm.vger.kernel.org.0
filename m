Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDCA34F75A
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 05:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhCaDTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 23:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbhCaDTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 23:19:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC15C061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k189so773429ybb.17
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VqSy53IyDnNL/CdQDhT4nMQIBeIb4g0Xh5NCqPSTxiY=;
        b=L3vxRku6tHP9GMz0/JT4UHLAicdp9dcZ+g2J1/dysm0wZpJgxaAjfxTZRGvOqRDoJ5
         5GG5sUkB9HTsjhb7ZcW+2cqWXHS02dQP1cU9Jq70424h6LdhCvBWTWi2Qkb61lFbCmHO
         QF6c6Ih9rAr2eQdCd2pJtRZYC0dBaI0kSCdr+sMMgAg5/lzXj6+0d07tR1OA1a34arnU
         0DF79I759sgJdeCnkcU7kKJCHSg3fuFJRaVtnpmrXCuZnuaRW3w4dGNmlSBalHYxoaW9
         BhI2lgbinJfb1IVflxdD8n2URlBSoiGN/Kq7x1JDvwfuCVb0nwKe97+7cLSKniU4BIdS
         E+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VqSy53IyDnNL/CdQDhT4nMQIBeIb4g0Xh5NCqPSTxiY=;
        b=SP32Lk8AKf2UMaqNSJZV4HMbzup++f89Fhu8LsEkjQBPfUe+bvo/daxbTJ50xglTzI
         8zOuh++kPoleuNFfN5Pd5ueuK6sBz+TDQT4WqiISHhYVBLdWY5rLV3m2SA6BHHrGd3fr
         6HfkhDqAG2KqjDu+/ClZZvCZygQlscaz3sdcSzxOYlFlG5tN1tQxHuJcfy/XuOzkwLgx
         cSNrXzdBsgRkwinUZMUea9FQAm92mmTqmKiMEnt0GmJPb5HjKw2DUgyfPske0ywgQ5n6
         PgP3LP09iulKLwI750TyrvFqpUzSqxfA8f2bs9DRTlM96g9shw00uvWKhX4+c2Re+z2B
         MdQg==
X-Gm-Message-State: AOAM531Rex02CDk/DGgevJruoksRF6pVOis3q8PXfmERhXzArMwdpmDV
        TUJDryvvjy0NIS/HNIAk/gRn6s327V8=
X-Google-Smtp-Source: ABdhPJwPfX1ZIe9KPSZ+B/9YfLJdMnVqXzEt0iRHW7WxV7gQCnqgXa6cZFbf1Pufpv66ADvtJZu7i2zqXv8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a25:9ac6:: with SMTP id t6mr1707731ybo.287.1617160784800;
 Tue, 30 Mar 2021 20:19:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 20:19:34 -0700
In-Reply-To: <20210331031936.2495277-1-seanjc@google.com>
Message-Id: <20210331031936.2495277-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210331031936.2495277-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 1/3] KVM: SVM: Use online_vcpus, not created_vcpus, to iterate
 over vCPUs
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

Use the kvm_for_each_vcpu() helper to iterate over vCPUs when encrypting
VMSAs for SEV, which effectively switches to use online_vcpus instead of
created_vcpus.  This fixes a possible null-pointer dereference as
created_vcpus does not guarantee a vCPU exists, since it is updated at
the very beginning of KVM_CREATE_VCPU.  created_vcpus exists to allow the
bulk of vCPU creation to run in parallel, while still correctly
restricting the max number of max vCPUs.

Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e524513..6481d7165701 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -564,6 +564,7 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa *vmsa;
+	struct kvm_vcpu *vcpu;
 	int i, ret;
 
 	if (!sev_es_guest(kvm))
@@ -573,8 +574,8 @@ static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!vmsa)
 		return -ENOMEM;
 
-	for (i = 0; i < kvm->created_vcpus; i++) {
-		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
 
 		/* Perform some pre-encryption checks against the VMSA */
 		ret = sev_es_sync_vmsa(svm);
-- 
2.31.0.291.g576ba9dcdaf-goog

