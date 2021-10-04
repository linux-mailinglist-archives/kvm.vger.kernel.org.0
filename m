Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E364218AF
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhJDUvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbhJDUvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:44 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4642DC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l6so752028plh.9
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J/yzxjhCplnRwuqqJdNmkaUNrYxsCF/32ZyLlXk4eKc=;
        b=GlaBqdlaF+f0d/AbTyPKQ21i99aH+dKzhzNhx2Le2t1Os5eIj/q2clsqbsT8NoF1UK
         v+GyXLFVBkZ7ppDMOUE2j65Bl/fn/2mkR62+fzN+9fmeUq8akQVlIUQoNarR6MDXyJZg
         mNqkpA1g+eMCWc6smOXBgOf8qMQEAc2VzyYyWBQuBuHWIz3Cj41u6IGYjMm1c5dH46XL
         aHmcf9BGctZ+cwGyKtwHin2r7cXFSggmDoP1IlloFFOSmaySj6QKzDQ+V3HA77fSpS2T
         XQc6aMVFNQecHhwRYTwkA2QE8YfrilKN5sG0/d+urx8fYiNVsaWy9yR32uvDl8QGI0IX
         jzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J/yzxjhCplnRwuqqJdNmkaUNrYxsCF/32ZyLlXk4eKc=;
        b=z9OP/hL7oTlI6P/PFKsJxetcdY2fLg47DtBQre65WyVfAJCcqMAr3q65ZEvvaNUHOc
         TdFCPtA5ND1t+z0BgF/GirkcvUjnU+klDIS5zpklzfRG2QIXclVNvTxKEzS7+k9WVZ95
         Qe8hJviOhswpz0NUT7lRdQ2KBEhhWbIPX7hL02bZoNEIsLNkb7i+VCz4EVjIroQLOtvF
         tttwkdvIsNGA4fvhqfX7JICmhzH88JmxAaNMQP94YL9dmXDaxsCDvZrZ6IQk8EoasXdu
         t7DOBK9Nfzicf2snu69aMOtD1Jmb6he4ixh+rFLdJ+lNGPvtiqLUegeB0tVMY9+Q6Ecu
         B8Bw==
X-Gm-Message-State: AOAM533BuwEU26pNNCPVEM0/3xxzL+NdAhxtZQJt3yBxJm0nI5/G+8Vc
        aj/oh68vgzvYYnVTf74UK/Pc4h1ncht99A==
X-Google-Smtp-Source: ABdhPJzwmcoB/ZSG3vvrlPknqvZOifvZH7d22D49km16rJ96LSmnyOUOUEov8L0M/UkWOUSFQuSQ5Q==
X-Received: by 2002:a17:903:2283:b0:13e:acd8:86c2 with SMTP id b3-20020a170903228300b0013eacd886c2mr1608247plh.78.1633380594461;
        Mon, 04 Oct 2021 13:49:54 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:53 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 14/17] x86 AMD SEV-ES: Check SEV-ES status
Date:   Mon,  4 Oct 2021 13:49:28 -0700
Message-Id: <20211004204931.1537823-15-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

This commit provides initial start up code for KVM-Unit-Tests to run in
an SEV-ES guest VM. This start up code checks if SEV-ES feature is
supported and enabled for the guest.

In this commit, KVM-Unit-Tests can pass the SEV-ES check and enter
setup_efi() function, but crashes in setup_gdt_tss(), which will be
fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 22 ++++++++++++++++++++++
 lib/x86/amd_sev.h |  7 +++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index b555355..88cf283 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -65,6 +65,28 @@ efi_status_t setup_amd_sev(void)
 	return EFI_SUCCESS;
 }
 
+bool amd_sev_es_enabled(void)
+{
+	static bool sev_es_enabled;
+	static bool initialized = false;
+
+	if (!initialized) {
+		sev_es_enabled = false;
+		initialized = true;
+
+		if (!amd_sev_enabled()) {
+			return sev_es_enabled;
+		}
+
+		/* Test if SEV-ES is enabled */
+		if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
+			sev_es_enabled = true;
+		}
+	}
+
+	return sev_es_enabled;
+}
+
 unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	if (amd_sev_enabled()) {
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 7de12f0..fb51fc2 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -32,12 +32,15 @@
  * AMD Programmer's Manual Volume 2
  *   - Section "SEV_STATUS MSR"
  */
-#define MSR_SEV_STATUS   0xc0010131
-#define SEV_ENABLED_MASK 0b1
+#define MSR_SEV_STATUS      0xc0010131
+#define SEV_ENABLED_MASK    0b1
+#define SEV_ES_ENABLED_MASK 0b10
 
 bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
+bool amd_sev_es_enabled(void);
+
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
 
-- 
2.33.0

