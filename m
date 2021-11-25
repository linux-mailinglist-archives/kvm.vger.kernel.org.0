Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2B45D2C1
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353276AbhKYCDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345640AbhKYCBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:09 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC93BC0619DC
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:34 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y124-20020a623282000000b0047a09271e49so2530588pfy.16
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DtLsNUG1mU8KIRQxClZ9QjdX4zKbCeXPIOMPwSqWT4Y=;
        b=hF6qUlLVu+eRN1BhGcuwF41u3qcd4VGUdlZpq7lZrsQbCAg07gjQnp2ahsmcZHeAMz
         odH5nWfcpw63HqE9kgmEojD8gqg/XOwwT7DENk8i0/YaiWrjw8odn9ExzHgvOKSUWTBX
         e3nuy0sGsBeorMXG50a7hq/pnjCoUUyavv3gwG/sV9cXoq7L6aCjKlegbICatEyX+zXX
         zGo6yU2FqmNbaWKxqQWsqUJdL0ELbzoHfvXOZSB7/+2HxdOToV4Tpfv7rhPfhUdAG+TD
         v/DUAen32WQ38j/ZAOeb7XVfoiwNmy9nsUHySu8Un4m4FFH/EWHjcxszedao0GO/RNqc
         ID7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DtLsNUG1mU8KIRQxClZ9QjdX4zKbCeXPIOMPwSqWT4Y=;
        b=20DrTJ+njjvKYndNZt6sWcYjDjOtG13Z0KMeuVqMetmP3A3L9p+Oq700WSGwTDYZvX
         xWPoyPcfGUfI/rkSzeWwGEnuDxjJ6elBVizjXBclQKpQla8SvnVQqznYjbPDrG6RQgTU
         PIDfEKQL11NH9yXXpo0WvBI9duBNZbqN7nzlCIMs6OJXrvnDxWjLz50GzYisSkeintBn
         Bgl/EhLCChNXycOPGvYRe8pk9DS0rd9lWmiGTKnxjNJIt1AVr99HNmzukteztrWAgyXE
         NL1TQUhD8X0ploe11k4FURhw19EiuJ7QRdtlc4IGpTXhI3qo1dB+4g2ImqLy+EPOqQUz
         14Ow==
X-Gm-Message-State: AOAM531D0FRIva+u9b2THYHAwf8lQOgNMT71+BJhl84/HvXIp+PqHcGM
        E1yLWEBWR/coU5EKnaXopD7urGPPG8M=
X-Google-Smtp-Source: ABdhPJzts8t8UItHvMueVFEAU2i+zVIOTkSmj7rsysB2mJbdsVzx9dg02qi5Cfts5QSuSqDUYBaM9Ppvbww=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b7c6:b0:141:9a3a:f213 with SMTP id
 v6-20020a170902b7c600b001419a3af213mr24716982plz.15.1637803774359; Wed, 24
 Nov 2021 17:29:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:39 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-22-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 21/39] nVMX: Skip EPT tests if
 INVEPT(SINGLE_CONTEXT) is unsupported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

EPT can technically be supported without INVEPT(SINGLE_CONTEXT), skip the
EPT tests if SINGLE_CONTEXT isn't supported as it's heavily used (without
the result being checked, yay).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 8 ++++++++
 x86/vmx_tests.c | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index dd869c2..472b28a 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -725,6 +725,14 @@ extern union vmx_ctrl_msr ctrl_exit_rev;
 extern union vmx_ctrl_msr ctrl_enter_rev;
 extern union vmx_ept_vpid  ept_vpid;
 
+static inline bool is_invept_type_supported(u64 type)
+{
+	if (type < INVEPT_SINGLE || type > INVEPT_GLOBAL)
+		return false;
+
+	return ept_vpid.val & (EPT_CAP_INVEPT_SINGLE << (type - INVEPT_SINGLE));
+}
+
 extern u64 *bsp_vmxon_region;
 extern bool launched;
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 97fa8ce..cbf22e3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1148,8 +1148,13 @@ static int ept_init_common(bool have_ad)
 	int ret;
 	struct pci_dev pcidev;
 
+	/* INVEPT is required by the EPT violation handler. */
+	if (!is_invept_type_supported(INVEPT_SINGLE))
+		return VMX_TEST_EXIT;
+
 	if (setup_ept(have_ad))
 		return VMX_TEST_EXIT;
+
 	data_page1 = alloc_page();
 	data_page2 = alloc_page();
 	*((u32 *)data_page1) = MAGIC_VAL_1;
-- 
2.34.0.rc2.393.gf8c9666880-goog

