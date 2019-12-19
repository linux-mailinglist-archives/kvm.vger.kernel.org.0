Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E83125E98
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfLSKLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 05:11:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41490 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfLSKLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 05:11:30 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so2938558pfw.8
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2019 02:11:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n8yO7xftBIOe1P8sRlvhhOgMt72/4wCK1ls+6BhIkpk=;
        b=ENPxveabQbXoGggTlFPYsygu17dZRDlPLY+Okm7uPe/UtfMbUQvLJ520z1pckWVxt7
         5Wnljrhld/6JI/puUsDd5hFBS8CxrTrKcqHY14SMRJZENIHTfWQo50/2RO6D23t0Mp4M
         KlbziyKMTqUZq9ZheMprWBqLKP9wRKjG8POenKRnwvCRtj2YRmVM+d+Ut4IpPZ61oEXI
         /Ks5R3sTMJUV8kyTrAE+9oJCvpAVU7dZ+fvXv1T24HqoFMFXKN/H2OvCaZhFSVw+a7/Y
         KyiyXrao4K0K8nhc+C1pSaj68y0G47a13USuHEjeleYWW+mA1kp/U/zASF+G+wdCYJW8
         aV7w==
X-Gm-Message-State: APjAAAU6VS2tOSgYMFFgWKf0raKw5Fk0bx0GxqjOGOh1ncrhoMLEhOdH
        Kx/ynaMRokrEDLjjoT0SYrk=
X-Google-Smtp-Source: APXvYqwZJghPYUpd1nNKlYUGYkGIlh34Yk1yg3v4wiBEce/qp78zDdGnBiRP2MV64trdEQ6nr85T2w==
X-Received: by 2002:a62:ed19:: with SMTP id u25mr8995317pfh.173.1576750289708;
        Thu, 19 Dec 2019 02:11:29 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id c184sm7565530pfa.39.2019.12.19.02.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 02:11:28 -0800 (PST)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH 2/2] x86: vmx: Remove max_index tracking in check_vmcs_field()
Date:   Thu, 19 Dec 2019 02:10:06 -0800
Message-Id: <20191219101006.49103-3-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191219101006.49103-1-namit@vmware.com>
References: <20191219101006.49103-1-namit@vmware.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that comprehensive search for maximum VMCS field index is performed,
the tracking of the maximum index in __check_vmcs_field() is no longer
needed. Remove all the related logic accordingly.

Cc: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index a1af59c..8bcb438 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -281,11 +281,10 @@ static void set_vmcs_field(struct vmcs_field *f, u8 cookie)
 	vmcs_write(f->encoding, vmcs_field_value(f, cookie));
 }
 
-static bool check_vmcs_field(struct vmcs_field *f, u8 cookie, u32 *max_index)
+static bool check_vmcs_field(struct vmcs_field *f, u8 cookie)
 {
 	u64 expected;
 	u64 actual;
-	u32 index;
 	int ret;
 
 	if (f->encoding == VMX_INST_ERROR) {
@@ -299,12 +298,6 @@ static bool check_vmcs_field(struct vmcs_field *f, u8 cookie, u32 *max_index)
 	if (ret & X86_EFLAGS_ZF)
 		return true;
 
-	if (max_index) {
-		index = f->encoding & VMCS_FIELD_INDEX_MASK;
-		if (index > *max_index)
-			*max_index = index;
-	}
-
 	if (vmcs_field_readonly(f)) {
 		printf("Skipping read-only field %lx\n", f->encoding);
 		return true;
@@ -330,24 +323,19 @@ static void set_all_vmcs_fields(u8 cookie)
 		set_vmcs_field(&vmcs_fields[i], cookie);
 }
 
-static bool __check_all_vmcs_fields(u8 cookie, u32 *max_index)
+static bool check_all_vmcs_fields(u8 cookie)
 {
 	bool pass = true;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(vmcs_fields); i++) {
-		if (!check_vmcs_field(&vmcs_fields[i], cookie, max_index))
+		if (!check_vmcs_field(&vmcs_fields[i], cookie))
 			pass = false;
 	}
 
 	return pass;
 }
 
-static bool check_all_vmcs_fields(u8 cookie)
-{
-	return __check_all_vmcs_fields(cookie, NULL);
-}
-
 static u32 find_vmcs_max_index(void)
 {
 	u32 idx, width, type, enc;
-- 
2.17.1

