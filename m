Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E27E9136
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 22:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfJ2VGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 17:06:13 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50580 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2VGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 17:06:13 -0400
Received: by mail-pf1-f201.google.com with SMTP id y191so12370959pfg.17
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 14:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=W9TmDvzIpvVvMh9ub0E4eq3Yi9eArcf8ZO+zuv8WQrQ=;
        b=dnwnfKnb9LznXfooKlHBCD3nDnHj7i29u4P50wfU8RS1Z6IcHtJL8+pyAO0+NzVNPz
         h1C3ez6pqwVDSJiuIOaHvDOBXRw6MwohdqK96V7KrL3IeIERwx6OifF0bLo2D+1//iey
         viubex1XFg6kK3g1F0/uD3w8mSfnu95jJrxB3Jv+75njyRG2GKF/uaTDqGP/gs3U/3PL
         aCBtxIOtnmgiNZmxmjvFZ1h4At8bH3LI3+E81V5+/ZknVsZS60uy8sPsoyohjnG8kmqv
         EwPmH0o6LlQZc8JpVQJBMx2d5u/Yusw+cMXvjRG66qWtIBIRFv5pig09bIQ0Ay7P2nLm
         Y3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=W9TmDvzIpvVvMh9ub0E4eq3Yi9eArcf8ZO+zuv8WQrQ=;
        b=LrQj8sskM5f6x/EZAmsS4sg9Ctx4V3Ap20GbJq6ngWCAYoZ+LHO3YlCLRTCVULlJdW
         g9+YEOHCcfsYqYE0q/CZ7JtEtwTEWpUAhzIvW+NQlMg/uRytzySwVMqUXzdz+KyGRVE5
         xX3nnxFszXmVTQiMUCWrIhxfTCqPADwta2ZRNCWimbYnN00egqsyML3O6bg2agrX0QPc
         t5d+Eoh+lvBzPoI9T49J+St5SGN9FCHqXci2+Spa9iGruwYEh0870n1vKj3DOVS3NR/s
         f2YrS5ejjtfH8LKUI0iKPlmOAKjOQbJ5YR3QsoaCwH4Ll0sLTcv5pNQTR9dHMuVE8FXX
         tBgg==
X-Gm-Message-State: APjAAAVluBEpnHgUr+kD2ePt9tT95LwF8O/qM0M/Kkh6MWU/22wUyAOR
        UuTz0pl/l3ZRFh0BNUt2TiifS5zqqbHRE4Hiu8ACjyBuLeks+UtN+sVYK6hNZ5LZMqiqV0HZDXf
        oHC3QKO/bMhEN4sUYfc5lidyFBb7pzDCyRl7QCzoH8eimb8+o/Ka/9dMOYKXgtIoHh2p7
X-Google-Smtp-Source: APXvYqw6qwdYZn2QAO9KRRcHT9+jwhmrkdZyYbz/rpIZlb5i3BWHg+po/FEv5+Zk74fdNg3wFoe5xrOWH4x+w8KG
X-Received: by 2002:a63:4a50:: with SMTP id j16mr26630256pgl.308.1572383170907;
 Tue, 29 Oct 2019 14:06:10 -0700 (PDT)
Date:   Tue, 29 Oct 2019 14:05:52 -0700
In-Reply-To: <20191029210555.138393-1-aaronlewis@google.com>
Message-Id: <20191029210555.138393-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 1/4] kvm: nested: Introduce read_and_check_msr_entry()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the function read_and_check_msr_entry() which just pulls some code
out of nested_vmx_store_msr() for now, however, this is in preparation
for a change later in this series were we reuse the code in
read_and_check_msr_entry().

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: Iaf8787198c06674e8b0555982a962f5bd288e43f
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
2.24.0.rc0.303.g954a862665-goog

