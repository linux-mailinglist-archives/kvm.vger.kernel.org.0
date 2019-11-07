Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF2AF3BB9
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 23:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfKGWtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 17:49:50 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:55161 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfKGWtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 17:49:50 -0500
Received: by mail-pl1-f202.google.com with SMTP id a11so2730468plp.21
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 14:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XTXOT3PTQaYYqLr+YkwfmLP4vZijQPTV+yL5uM5usc8=;
        b=uixDCo9sWcFrzbbPJ3qwhEF3MglWdyIZbnTF6Z0mmbqtPwdIO33yUMIZf/wB2crjw7
         cSIqj5EFReWyFUHM5VlOKhG/Kmh+bCJBFyFXQ1cASUxnQwtZgc1h8ZKqk/m4OtRN9E3J
         cUkV9FdJv6N1wtnRs1QuaLpofcjngxaqz+GKku21nLbd/7v8LH9P8FB87L4JfA37qP7e
         WvYQ6/UXXZoW4YvuBw44cC3/WEvPLQV7T1FEKmB58UgXG/4PKuQevZybKf7Rjb1N5xkx
         8aGD8D2lspQkbz8Ef65SypE4kQL8/AX8zqHFwS2KhG7ONeTTsjUa/NL4hV6ygFY8DJ5G
         T3hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XTXOT3PTQaYYqLr+YkwfmLP4vZijQPTV+yL5uM5usc8=;
        b=ES/FAJyM1jHc2H4xJwQlzZJi713hsZcFF7QGYpVPlKZ9jAQkhwJqQEXk68YRSBoHVc
         U7ErLXAtivEVAl+1vdmO7GvYtauvpU2QwyrNxmTwe48TybxhL/oe8l2EKsUyi2kBzGcJ
         B106F65TGFAMYMi6RU++1CssBV53calh4RU5hVeTTZZ8jPgiwTPHh4XXgHx3c97R1AGI
         UvZv03RttY2Rksnh+1tk2pYLaXv3dn4m8gVYTvfEQ8fi8VkkE5oZ1yjHIKD5skd73dHb
         irC9TW4Yx/XnnbTvO2/KDZtDh1Hsdkk34JuDOzbQBfotwmLebHFjJjWW7b/2VTFsA3lr
         OxiQ==
X-Gm-Message-State: APjAAAVe4NhbSx0cnqx7JOL4gcAOIqTuOW/InyNDtV9J9X1nI01zsC+v
        OTbVVmCSgEscghCFxDPclSFs0VG3jrUrgf6s/nq96EUGPdzLsHTP8z9Qu7PAHp0ik8HF79363wZ
        yeaGeXmHhwggdTNVReHAC3zFMzPYOaqeXOVBARqz9U6XsnzFdTsMTJYji3zNFCd/oDgLR
X-Google-Smtp-Source: APXvYqzU6VmWxUonRHHAaH5w6SCOh10x1jbiy3PifEFWkuoUi3IQHCdDu5ovhE4kB3aVjpsgws3CmwQKlGqExQJG
X-Received: by 2002:a63:115b:: with SMTP id 27mr7153288pgr.298.1573166989202;
 Thu, 07 Nov 2019 14:49:49 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:49:37 -0800
In-Reply-To: <20191107224941.60336-1-aaronlewis@google.com>
Message-Id: <20191107224941.60336-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191107224941.60336-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v3 1/5] kvm: nested: Introduce read_and_check_msr_entry()
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

