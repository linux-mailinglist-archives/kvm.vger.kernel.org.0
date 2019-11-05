Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C5F05CE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390865AbfKETTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:19:19 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:51978 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390846AbfKETTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:19:19 -0500
Received: by mail-pl1-f202.google.com with SMTP id h7so8752092pll.18
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zuF7sKZCPT+TK1RMBRSi/baQpV2Rh8fSC5oFHVCBvvc=;
        b=fxRm2S13cZxdOTIxyNOX/QX1BC3mC1jd1AMzjYxWmsN8JVfMmr5CP49gwlzXCU6q/T
         i08VeQ1tm9bObGKhWQvtZiGFSJQI4L8+lkAbQzTecRmB1y9jJEWb7EeBwyEUtG/lYi4c
         589gPdN6JGID9VFgompDh/r1cg8edoX2/1JHpTjHr039iGBpoON9rjFkrIU7P4Bo7AGm
         LU9gH8mLPQYzphKZpqAcymmsuHAv7udPXKH579lfWtARxY3kLnV0VQCSaxJzXIyCscIp
         eMu3BbbC03rHbkpqqKqAAdtFq7e1SZDFufUkDYCu7igGbC/L3YUByty572pSg/PRV+Ly
         NQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zuF7sKZCPT+TK1RMBRSi/baQpV2Rh8fSC5oFHVCBvvc=;
        b=lxlA3vKT4V8YL7B9fpmUE7irpdPlLwC/13IU0gV5o/j2Y1DIFPfwdx3AeE46HfzGZB
         +lfiU++aUzg3OitB9V1q4Z5RM9ph8lkAQ9YDaJHl6BJv0AkxS9eZw46ra0C8pA249D3p
         m2cPVm5rs8NITrA0TLP/06yP2IuIGnHcBpHbCTo2wc2nlH9H/xsnwjSQyFuD7QuiBwCV
         AauGog6MxyvJ5nXjZbWnUznVQDDh7reS+u0DvY4hBh43Ir2UkvI6VGaadXUD8jqhePqk
         wFbElxMrMF2sfpiN6vawg518RWeoPc6ljonEiPobiJ4OBUV6xCFPKqLbGzOsfEBSgBv4
         FjiQ==
X-Gm-Message-State: APjAAAXNDJBkDV0JTPm2J5xIs5/8EI+q1LxW67arFb9VCyNj4ncuUbCV
        pxKXaIxT65ib14VSRRKjiBP+/95vsxMxcQLZdcdiY3jSLr0iNIiSzBUdlgldYtaZOl6JyQgKc1I
        OEUsthvskwjVYB8ZOCmA5B7lE89jlgzztzC0aJsmHPTj6Yh1eBGZJJ9KXk/J04As4gv5u
X-Google-Smtp-Source: APXvYqzcPLdhfbgNu8QkgzNk9uVEb7eZdeeZ16LOp9wb1vAHAgFnP7+7QePdZNT9XSkCU+4dIo+tGQ70f7UiC//G
X-Received: by 2002:a63:d44a:: with SMTP id i10mr38553263pgj.105.1572981557994;
 Tue, 05 Nov 2019 11:19:17 -0800 (PST)
Date:   Tue,  5 Nov 2019 11:19:07 -0800
In-Reply-To: <20191105191910.56505-1-aaronlewis@google.com>
Message-Id: <20191105191910.56505-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v2 1/4] kvm: nested: Introduce read_and_check_msr_entry()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the function read_and_check_msr_entry() which just pulls some code
out of nested_vmx_store_msr() for now, however, this is in preparation
for a change later in this series were we reuse the code in
read_and_check_msr_entry().

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
2.24.0.rc1.363.gb1bccd3e3d-goog

