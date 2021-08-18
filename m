Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470BB3EF692
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbhHRAKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbhHRAKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:14 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217A6C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:40 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 98-20020aed316b000000b00298da0dd56bso101806qtg.13
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/uvgVOLqijeNwZCX8B/VYd7JcP3Yc91KvYJDNiOtEKY=;
        b=HUhsMMbKSEhQdddPloTIsm3X8xPyuUr72GgWqNKVntVPkv87TlFccFJC0/E7HC4gHu
         gV7TeAucQnoNo7uGX8mwUpwBzl8Opwybk/R6t6PYeqJOOibDUpyodi+ORYQvSydfBIu5
         jFVJZjyB7cy2gwrTntC8tjVAybpNIC9a7Zc9qX6XO6eYpManTVkXb3UOj8BKo3jnS58R
         8GmBc0LzbG7uJJgZuE6iOTKfXw08wAM/+xwHVtJ4ZsvnFiw6EZVIcDEjSJ0dxyXU+vnh
         Q2rC9+AM+t+cJtzavGfC12Z27GFRE/waRbilgc39c1sE+zyfP9QrxjA+FpgqFM641iel
         ltQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/uvgVOLqijeNwZCX8B/VYd7JcP3Yc91KvYJDNiOtEKY=;
        b=S2VpBQqKzJaarZNZ7n3jxUlF2lzceo/q4agZE6yXJX7v09rrJtnIbBsElEEoxjJ2l6
         LOFkPNdMz5v+G4IEpLT+AzfG6R3ae2VjdgArGQvTxWAgG6ntDwB0U34kRaxwiF/TeXpE
         rsWefTXM6ZPoLoSceAF50YGx1DxNwkUwppHj9eOTB+KkV76yPc+typ8JDlXmAjtjJj85
         cTi7ydfDnNI9fJe4S5WwhY7diA2Dd9DM0+w+j2oJEc7EUN5+JNi2+YXOTt+YKCdsekPY
         Xp/x52mJLoTa9uYUw3epNpoQlM78G+edk+dQevOR02/ygJ4JY/ae7YjpO2QqpVBkVTds
         gmow==
X-Gm-Message-State: AOAM530VcnV459UYvAsk0z5VJ2WfXit/SEYzsKQO5Luc3a+aBGOF3wcW
        lx5O3VzoYErZneLyrA1vjF4NwaPheSnnueaflD9H2erVnGBOt8eH6snHDiOK6zpkOUrIe0utoJd
        UMno4aaMoSok+8htBlPmNej7mD3S3Th1YiDlErHdExmv/h1XIi7x2ApR3HLWED0IgvRnU
X-Google-Smtp-Source: ABdhPJxZNDHjCoyzl7YN+p+fGiRMZemEtrNk9DTBRtD24tVradQ806jFvtjVZdX7/svZANayp/OvPqX7iafdGog/
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6214:2b09:: with SMTP id
 jx9mr6008990qvb.54.1629245379256; Tue, 17 Aug 2021 17:09:39 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:09:03 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-15-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 14/16] x86 AMD SEV-ES: Copy UEFI #VC IDT entry
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV-ES introduces a new #VC exception that handles the communication
between guest and host.  UEFI already implements a #VC handler so there
is no need to re-implement it in KVM-Unit-Tests. To reuse this #VC
handler, this commit reads UEFI's IDT, copy the #VC IDT entry into
KVM-Unit-Tests' IDT.

In this commit, load_idt() can work and now guest crashes in
setup_page_table(), which will be fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 10 ++++++++++
 lib/x86/amd_sev.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index c2aebdf..04b6912 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -46,11 +46,21 @@ EFI_STATUS setup_amd_sev(void)
 
 #ifdef CONFIG_AMD_SEV_ES
 EFI_STATUS setup_amd_sev_es(void){
+	struct descriptor_table_ptr idtr;
+	idt_entry_t *idt;
+
 	/* Test if SEV-ES is enabled */
 	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
 		return EFI_UNSUPPORTED;
 	}
 
+	/* Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does
+	 * not have to re-implement a #VC handler
+	 */
+	sidt(&idtr);
+	idt = (idt_entry_t *)idtr.base;
+	boot_idt[SEV_ES_VC_HANDLER_VECTOR] = idt[SEV_ES_VC_HANDLER_VECTOR];
+
 	return EFI_SUCCESS;
 }
 
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 4d81cae..5ebd4a6 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -36,6 +36,11 @@
 #define SEV_ENABLED_MASK    0b1
 #define SEV_ES_ENABLED_MASK 0b10
 
+/* AMD Programmer's Manual Volume 2
+ *   - Section "#VC Exception"
+ */
+#define SEV_ES_VC_HANDLER_VECTOR 29
+
 EFI_STATUS setup_amd_sev(void);
 #ifdef CONFIG_AMD_SEV_ES
 EFI_STATUS setup_amd_sev_es(void);
-- 
2.33.0.rc1.237.g0d66db33f3-goog

