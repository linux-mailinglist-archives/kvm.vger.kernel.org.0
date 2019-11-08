Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABC7F3F86
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 06:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfKHFOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 00:14:48 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:36665 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKHFOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 00:14:48 -0500
Received: by mail-pg1-f201.google.com with SMTP id h12so3850241pgd.3
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 21:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XTXOT3PTQaYYqLr+YkwfmLP4vZijQPTV+yL5uM5usc8=;
        b=WAogCnEiNAjEpBBxEA04jsBppJNAzct4MnqswJ4df8s0CHWbVXwLLGkOzH9/XnK78l
         Ztq6FgnCus8aHki7P7WecVfTPt5EYarJ+OQAiWFpAEHZeA6vqBhKIihvLIuriWEKuEaM
         kHQmxUipNGVqi7QpO9OLUeRLrB4S36kGvGRG41JTdBn+Kfno6y0QIcDR+/Gf+JNvKI3O
         hCx61N6poBlNEua4/w6gUjkC1SQBrPkYu5dWVxc1D2XcxFiNk0rcjc3kZkwH8l+ovBaO
         OQ1UVHS4/vDfhNBKp8YpJDayzuChbeQB/xSgZcYTliFrBNdjGIiZ79NDbIPBW8y53xug
         BrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XTXOT3PTQaYYqLr+YkwfmLP4vZijQPTV+yL5uM5usc8=;
        b=aQZXotbWrJdTxXGBAK7/oo+ipvp3pA3Fapocgjp3S9tSNfZVXkNSNNjig9Dt2Rulzk
         MOAktzWI2AgJ29tKms3ummwekh4zo+2kX3Ns7m04XyGu39RkFz3QQ0WboEcBJF+KHZgK
         7ZmK24nYb1GzNqxOCIJk4x5rTXsCbJEPe6C0mUyx5eZX+SFefjD4ADKP7BxqyHxuMOwS
         CjwZSeZTDDtVX0KOuwSecBFaGAIQTbUScgK6Rx3/av/NLcOQx6MMCwkrTwSG+WTh+kqV
         xCyLw5dHy9G0VFISp45Jh9aNSlKsF81000ZhAxZXghieYZpurELuYEcLm+uUHyWhvhNu
         hBcg==
X-Gm-Message-State: APjAAAVuMTjSbMGP+hjDjnLWV37rglIyvJNsHNxrz7cFTU6uCi1zh0HR
        7740D+mKnWC1UqQl/CBhPoOnSIInyiAv1ob8TaCXHuGB/Y5WKNnsbqmmnaIVgrUHc7tloAslrE2
        O9UMUm1eBoAv5fhbKB0nDj7dCa962vpZSUWtrlvOQ85YC5r58p6zgWVO/5mL/3vBB9wQ0
X-Google-Smtp-Source: APXvYqwDF6ec+rIwZYgX2E84SGvt778JBkSQfQtR5T+gmWXNXHdoNP9EMbmLQxvGrjNi/yM9WpCEYhBrBKgEJDpw
X-Received: by 2002:a63:5508:: with SMTP id j8mr9132147pgb.97.1573190087463;
 Thu, 07 Nov 2019 21:14:47 -0800 (PST)
Date:   Thu,  7 Nov 2019 21:14:36 -0800
In-Reply-To: <20191108051439.185635-1-aaronlewis@google.com>
Message-Id: <20191108051439.185635-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191108051439.185635-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v4 1/4] kvm: nested: Introduce read_and_check_msr_entry()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the function read_and_check_msr_entry() which just pulls some code
out of nested_vmx_store_msr().  This will be useful as reusable code in
upcoming patches.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/nested.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e76eb4f07f6c..7b058d7b9fcc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -929,6 +929,26 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return i + 1;
 }
 
+static bool read_and_check_msr_entry(struct kvm_vcpu *vcpu, u64 gpa, int i,
+				     struct vmx_msr_entry *e)
+{
+	if (kvm_vcpu_read_guest(vcpu,
+				gpa + i * sizeof(*e),
+				e, 2 * sizeof(u32))) {
+		pr_debug_ratelimited(
+			"%s cannot read MSR entry (%u, 0x%08llx)\n",
+			__func__, i, gpa + i * sizeof(*e));
+		return false;
+	}
+	if (nested_vmx_store_msr_check(vcpu, e)) {
+		pr_debug_ratelimited(
+			"%s check failed (%u, 0x%x, 0x%x)\n",
+			__func__, i, e->index, e->reserved);
+		return false;
+	}
+	return true;
+}
+
 static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 {
 	u64 data;
@@ -940,20 +960,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 		if (unlikely(i >= max_msr_list_size))
 			return -EINVAL;
 
-		if (kvm_vcpu_read_guest(vcpu,
-					gpa + i * sizeof(e),
-					&e, 2 * sizeof(u32))) {
-			pr_debug_ratelimited(
-				"%s cannot read MSR entry (%u, 0x%08llx)\n",
-				__func__, i, gpa + i * sizeof(e));
+		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
 			return -EINVAL;
-		}
-		if (nested_vmx_store_msr_check(vcpu, &e)) {
-			pr_debug_ratelimited(
-				"%s check failed (%u, 0x%x, 0x%x)\n",
-				__func__, i, e.index, e.reserved);
-			return -EINVAL;
-		}
+
 		if (kvm_get_msr(vcpu, e.index, &data)) {
 			pr_debug_ratelimited(
 				"%s cannot read MSR (%u, 0x%x)\n",
-- 
2.24.0.432.g9d3f5f5b63-goog

