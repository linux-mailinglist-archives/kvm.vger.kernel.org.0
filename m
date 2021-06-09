Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A53A1CC9
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFIScz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:32:55 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:33509 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFIScy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:32:54 -0400
Received: by mail-pl1-f173.google.com with SMTP id c13so13088031plz.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWCJamjydi4hTSNXgKpzZyhuamlyd3VzbdgV4FiksE8=;
        b=H3xx0PBjo7ctHhfap1iFKTNhjhSzQqS2xNOzRiIcSCUtZpUWlbiIIUqTyRjXFMfGzS
         8vw948TXi32AMieI7hfPdOPR36c0J7lwjC//jevYGJ/XIIabIsPUyF8wD2lidvk/n49j
         Vjo2y/6QRpZLduMNB0ZjA3cDfCKozVlGFpmPic7lso5BOC74NPrxKW3GT/cUJgWuq3EQ
         g/gptiounhhEIVp9m5E8lb5GQ6kl6/iERM9RUBLaBnjrqJ5Za+3lacB15cHjjW+qFZR0
         f1U/7bVO3Y9jYeuY0wFfuttAvpG24x4MnLE0U5WBre4J2SjA//lCmFq1Bgm9bHBoRfxo
         04Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWCJamjydi4hTSNXgKpzZyhuamlyd3VzbdgV4FiksE8=;
        b=Rwad9wem6MtKVPR1ml6jyJNTebDCIYPMSEObmEYS91Jv3Q3X+2iNyjXugKSdoXMNxr
         /WTNd3nWnSFPwDVs4ZEWeos6O3yqpERE03aMi/I4/tXl5oJVQE7IUF5+i/WAn3QbjQFP
         oQqxJN9to/M2EowFyns5Cx+UHPRgZeuKvo4nxWbYbgRy3Y971Q6h0oz8VAiFFUDFwUQ+
         lzraD3A4u/Ighfa/Fd9i09mARb/6432T5Zm4FBcSsb77QYkgXpC2QVrF1cbKsus2DBaU
         BVXePxYqu051skawSuxjxGCW6bxwptkTcVZdhzEiwYr7uVESinDwY2ipeoTfxnzq7lhY
         Sh6g==
X-Gm-Message-State: AOAM532lEohGfI0yeVNw+rvC7rvfSNGsMAxu7HBTR2xQbploE229eG5r
        +rCWDHwqAbDxRAaVC5byYVo=
X-Google-Smtp-Source: ABdhPJx2Y6hRvCUYaeC9+OW21FyVa6lnrbY59X7gFiE/D3f2OYdKrAUS4V1+3OnAfLVfzzeLTC0MdA==
X-Received: by 2002:a17:90a:4e4a:: with SMTP id t10mr863172pjl.173.1623263399036;
        Wed, 09 Jun 2021 11:29:59 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:29:58 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 2/8] x86/tsx-ctrl: report skipping tests correctly
Date:   Wed,  9 Jun 2021 18:29:39 +0000
Message-Id: <20210609182945.36849-3-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

When tsx-ctrl tests are skipped due to lack of hardware support, they
are not reported as skipped. Fix it.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/tsx-ctrl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/tsx-ctrl.c b/x86/tsx-ctrl.c
index 079ad59..3b197ca 100644
--- a/x86/tsx-ctrl.c
+++ b/x86/tsx-ctrl.c
@@ -27,15 +27,15 @@ int main(int ac, char **av)
 {
     if (!this_cpu_has(X86_FEATURE_RTM)) {
         report_skip("TSX not available");
-	return 0;
+	return report_summary();
     }
     if (!this_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
         report_skip("ARCH_CAPABILITIES not available");
-	return 0;
+	return report_summary();
     }
     if (!(rdmsr(MSR_IA32_ARCH_CAPABILITIES) & ARCH_CAP_TSX_CTRL_MSR)) {
         report_skip("TSX_CTRL not available");
-	return 0;
+	return report_summary();
     }
 
     report(rdmsr(MSR_IA32_TSX_CTRL) == 0, "TSX_CTRL should be 0");
-- 
2.25.1

