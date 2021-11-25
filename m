Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1394745D2C6
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353056AbhKYCDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353052AbhKYCBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F2FC0619E1
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:42 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id g14-20020a17090a578e00b001a79264411cso1688074pji.3
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=k8rDEHW4oI9QveoP0Lw9ekRG1NJxuXVCsgMimwWdJ3E=;
        b=cEtO307JtIZxnCAMVL40d6d0QqGHKFfPZGz0Wz4ptezEo/98x7ZVV1KgZMMrKw8cTx
         Qf0A4jeohCigFo06Dg8iqPavSd1u342nHPEmFp9OByK8dgMt+Py7n1BRKUdVXEojo082
         VQlQH7JKFYsD0GgJ8ZKkzot2dia3TWYxEpEmtuJ8MJzX9WL7ayEp8yrAmbQFUohI/R3l
         IT8wmr9la47A3U3uXePaEx5pMh0ivjb5WbeKfdjehQOvWpQgQKl8kCcc5FTsBQM3oAzj
         0zwRiJ+WlQMfCNHNfm59753KU6T2HVr9+sk0snWdNmWEVODEaic8DSTEGTsCDTQjTiDG
         c0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=k8rDEHW4oI9QveoP0Lw9ekRG1NJxuXVCsgMimwWdJ3E=;
        b=6Urvzuaj1qmTT2AWtJpZtFuRvIZT2mJ7aFmzqND9V7jbcsUWittPhv99sGyOSMPHzB
         XVKTGZsQaMndJbjdAXSZxrbz60dPaxXZaYJ8oI+of/QGAfcz/foSy7B0LUVIKI6etBbC
         z0KYVx5ChvdprkaCRNtZLt/OfO0dVx/Pgv59/ImBs9GUKHSPkB/M3wT1OlpaeYqw7r+v
         IbyUxZX51RD4SCjccxpeWG4uoJglbHUhUnFWwUe1RxU92yYGdebyopNfWlcA/L4gKdw1
         8j/AFNP6ExquVBoLO2GYoBivU89nP2VSWmewJwbPMgn2H+mhOLKHy07jtHcJ8ca6M5H8
         NPxw==
X-Gm-Message-State: AOAM533fmY7mBxW2jokijOMOQI6M8Z1WlPsxmX5KATtB+vOKjKMeHNs7
        Bw1c/BooexnEBmW6LekHPJ+GHdOJqp4=
X-Google-Smtp-Source: ABdhPJxxWs1/Y0nlf2APLDypea/xNWhS5fz8lLABJ0sSPyaK5JioPiLYhV62e+4+OL+51SR7SeVe8yiOd88=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b097:b0:141:ec7d:a055 with SMTP id
 p23-20020a170902b09700b00141ec7da055mr25107072plr.3.1637803782176; Wed, 24
 Nov 2021 17:29:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:44 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-27-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 26/39] nVMX: Move EPT capability check helpers
 to vmx.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the EPT capability helpers to vmx.h, ept_vpid is available and
there's no reason to hide the trivial implementations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 30 ------------------------------
 x86/vmx.h | 36 ++++++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 554cc74..eb5417b 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1164,36 +1164,6 @@ void set_ept_pte(unsigned long *pml4, unsigned long guest_addr,
 	pt[offset] = pte_val;
 }
 
-bool ept_2m_supported(void)
-{
-	return ept_vpid.val & EPT_CAP_2M_PAGE;
-}
-
-bool ept_1g_supported(void)
-{
-	return ept_vpid.val & EPT_CAP_1G_PAGE;
-}
-
-bool ept_huge_pages_supported(int level)
-{
-	if (level == 2)
-		return ept_2m_supported();
-	else if (level == 3)
-		return ept_1g_supported();
-	else
-		return false;
-}
-
-bool ept_execute_only_supported(void)
-{
-	return ept_vpid.val & EPT_CAP_WT;
-}
-
-bool ept_ad_bits_supported(void)
-{
-	return ept_vpid.val & EPT_CAP_AD_FLAG;
-}
-
 void vpid_sync(int type, u16 vpid)
 {
 	switch(type) {
diff --git a/x86/vmx.h b/x86/vmx.h
index 0212ca6..0b7fb20 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -785,6 +785,36 @@ extern union vmx_ctrl_msr ctrl_exit_rev;
 extern union vmx_ctrl_msr ctrl_enter_rev;
 extern union vmx_ept_vpid  ept_vpid;
 
+static inline bool ept_2m_supported(void)
+{
+	return ept_vpid.val & EPT_CAP_2M_PAGE;
+}
+
+static inline bool ept_1g_supported(void)
+{
+	return ept_vpid.val & EPT_CAP_1G_PAGE;
+}
+
+static inline bool ept_huge_pages_supported(int level)
+{
+	if (level == 2)
+		return ept_2m_supported();
+	else if (level == 3)
+		return ept_1g_supported();
+	else
+		return false;
+}
+
+static inline bool ept_execute_only_supported(void)
+{
+	return ept_vpid.val & EPT_CAP_WT;
+}
+
+static inline bool ept_ad_bits_supported(void)
+{
+	return ept_vpid.val & EPT_CAP_AD_FLAG;
+}
+
 static inline bool is_invept_type_supported(u64 type)
 {
 	if (type < INVEPT_SINGLE || type > INVEPT_GLOBAL)
@@ -975,12 +1005,6 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
 void clear_ept_ad(unsigned long *pml4, u64 guest_cr3,
 		  unsigned long guest_addr);
 
-bool ept_2m_supported(void);
-bool ept_1g_supported(void);
-bool ept_huge_pages_supported(int level);
-bool ept_execute_only_supported(void);
-bool ept_ad_bits_supported(void);
-
 #define        ABORT_ON_EARLY_VMENTRY_FAIL     0x1
 #define        ABORT_ON_INVALID_GUEST_STATE    0x2
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

