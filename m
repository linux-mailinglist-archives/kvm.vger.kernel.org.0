Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9BE18D5C6
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCTR2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:28:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33328 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgCTR2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 13:28:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so8532596wrd.0;
        Fri, 20 Mar 2020 10:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E2IiYND+FknzhCQPVdNjH93kzpTnB1CKMjqVcocTcIQ=;
        b=YybtlULqQBimQzFWvImQOs7OvUyY8rLrXbTud11fX1tB8D7S+ZE3Pjvx0uScWO18Q6
         wMfi5syEbv+wmqOkglQKh1SXIbJ4kqhcVwoTp0wCVeB7LPYyP1TjzELfuPga8P/s/Hi9
         p4RiFV+CXGbve/88r8pwRjvZLr3QswxkGjD+kuckmQCqYHBORLP4z8cdjG5p/MKjMQfw
         9hmxtO6vZJH6FUbyo8TKTwvkrPGvhiobNBNptgbKihNcjNdwjMguXscKh9OOnCpml2rT
         8RJsO/sml1zkXTkb6rZfNTBhbfhM2VCVbIABJucn82j+TfC4f2/sjgDNU9k/Bohi8itU
         i22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E2IiYND+FknzhCQPVdNjH93kzpTnB1CKMjqVcocTcIQ=;
        b=WTZMrrJgubfXGUvnv+T+hgWRoqU9ZlvKN+udpckoEr8AlBgw/NxpFUNZrbC6ktrHeb
         ajfANBL2w9yo7zB1uguAJxyHpRxrzfXLM1Vkvc7tXSTD4JCLOYzUPlTdbkRkAMVTAHSX
         U/nAGAR7EZwXcDo7vWOZ2NkDFOVeLXQhOg4rMPAK6CrZnql1mL1NgChKaGfrsRCCAeMc
         cUuMlLC5V/iSwQE4DO7HCqXFRG8h1RfeCFfH6b3k+3vUiJuZ/o6UOLvbHWW4RoPZLlid
         uTrihjkJKjnzS/cWwpfgQUvOrN40N3Zo5teBRiz1yB2Kafv3UyXB4nrJ/A+VwdY1iXQY
         1Trw==
X-Gm-Message-State: ANhLgQ0uiqdThrbkt2FWcakMKZEa4x0/9DNyWeCbWWD2CZ8Q7OiAvaSn
        n3jFZGBGH1FJwtvsD1SLGyREwVjc3Vc=
X-Google-Smtp-Source: ADFU+vsr3VBf8WoqgS4qMh4z+0QFadMVo2eTsNTZeWjC8rE2Y7oYqJapscBPP5B+nqaMkmggqxbm0A==
X-Received: by 2002:adf:afd4:: with SMTP id y20mr13151341wrd.57.1584725330237;
        Fri, 20 Mar 2020 10:28:50 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id q4sm11028333wmj.1.2020.03.20.10.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 10:28:49 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v9 2/6] x86/kvm/hyper-v: Simplify addition for custom cpuid leafs
Date:   Fri, 20 Mar 2020 19:28:35 +0200
Message-Id: <20200320172839.1144395-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320172839.1144395-1-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simlify the code to define a new cpuid leaf group by enabled feature.

This also fixes a bug in which the max cpuid leaf was always set to
HYPERV_CPUID_NESTED_FEATURES regardless if nesting is supported or not.

Any new CPUID group needs to consider the max leaf and be added in the
correct order, in this method there are two rules:
1. Each cpuid leaf group must be order in an ascending order
2. The appending for the cpuid leafs by features also needs to happen by
   ascending order.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 46 ++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a86fda7a1d03..7383c7e7d4af 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1785,27 +1785,45 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
 	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
 }
 
+// Must be sorted in ascending order by function
+static struct kvm_cpuid_entry2 core_cpuid_entries[] = {
+	{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
+	{ .function = HYPERV_CPUID_INTERFACE },
+	{ .function = HYPERV_CPUID_VERSION },
+	{ .function = HYPERV_CPUID_FEATURES },
+	{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
+	{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
+};
+
+static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
+	{ .function = HYPERV_CPUID_NESTED_FEATURES },
+};
+
+#define HV_MAX_CPUID_ENTRIES \
+	ARRAY_SIZE(core_cpuid_entries) +\
+	ARRAY_SIZE(evmcs_cpuid_entries)
+
 int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				struct kvm_cpuid_entry2 __user *entries)
 {
 	uint16_t evmcs_ver = 0;
-	struct kvm_cpuid_entry2 cpuid_entries[] = {
-		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
-		{ .function = HYPERV_CPUID_INTERFACE },
-		{ .function = HYPERV_CPUID_VERSION },
-		{ .function = HYPERV_CPUID_FEATURES },
-		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
-		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
-		{ .function = HYPERV_CPUID_NESTED_FEATURES },
-	};
-	int i, nent = ARRAY_SIZE(cpuid_entries);
+	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
+	int i, nent = 0;
+
+	/* Set the core cpuid entries required for Hyper-V */
+	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
+	       sizeof(core_cpuid_entries));
+	nent += ARRAY_SIZE(core_cpuid_entries);
 
 	if (kvm_x86_ops->nested_get_evmcs_version)
 		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
 
-	/* Skip NESTED_FEATURES if eVMCS is not supported */
-	if (!evmcs_ver)
-		--nent;
+	if (evmcs_ver) {
+		/* EVMCS is enabled, add the required EVMCS CPUID leafs */
+		memcpy(&cpuid_entries[nent], &evmcs_cpuid_entries,
+		       sizeof(evmcs_cpuid_entries));
+		nent += ARRAY_SIZE(evmcs_cpuid_entries);
+	}
 
 	if (cpuid->nent < nent)
 		return -E2BIG;
@@ -1821,7 +1839,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
 			memcpy(signature, "Linux KVM Hv", 12);
 
-			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
+			ent->eax = cpuid_entries[nent - 1].function;
 			ent->ebx = signature[0];
 			ent->ecx = signature[1];
 			ent->edx = signature[2];
-- 
2.24.1

