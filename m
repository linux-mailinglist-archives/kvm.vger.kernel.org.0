Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101234135C6
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhIUPFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 11:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbhIUPFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 11:05:19 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D69AC061756
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 08:03:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q8-20020aa79828000000b0043d5595dad4so16125721pfl.13
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2SspZ9TzwoWbKU4jWqktr8ubMLDHgH+xxzPwNA01OLI=;
        b=tDkyvj20ClPf+bnCzg37gjA/DXM2bIXkR4h6uG0DpkudkvVM6PDu77/KCNRRUbQJ3M
         L34Tp2wuWyaTu49ysJqWHklQ9rVPzPoQXnOygBZmY1jWzIYXAjES2+8eLBXtwj4YXZfi
         4M3bqJ+VUgKGLd2A7u/62H8nxzAkdgAR5iVCyLbuSfj36dK0H+Ao3vTKYoXCyQnVi3UR
         oNkmpwzGmww/n3kLehFMtNhRXFGRWetr/95MgcU20eXUMRAXbVW0avu5ggWQmBdF4UpN
         SQ7Cp3zcZNGuPfGZFfS61LL8RDBGwrCvxP6CYahN8SortG9iviLf44KNyXkzx18NZPNG
         KPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2SspZ9TzwoWbKU4jWqktr8ubMLDHgH+xxzPwNA01OLI=;
        b=L/i41PgPSt1oBJ3z4VRYfsmSOY0NQxZYNAR55G+ZBlVVpkQy8RQApWjKvA+fg9TVoY
         A0d5JxFYujdP3rIkGZGCWDcVwLM7TmV/Tg9VwcVBXyigEOe2w3uvpgYc5bekmgALetHR
         T3yS3EnH6zYc1uBXfBlLx6VLnnNGCwC4KYoEBob0kcPY4X4Y7I9+ptawCtCS3IRNcCpO
         91IwJaKdBUDq3yP9XtMhJiMvhq+JoySkpsyfG+zowrXaoJiS4XkSwBitmPUDXsF/giYn
         XBlmG3Wku9zPAEUD9BDHtFBPuqEuIvOjiY31L4pq887oIIZSRXYMOxK8y/uprW08s6FY
         XGaA==
X-Gm-Message-State: AOAM531yMyezAffg7RVd9fRYwNUbE9Kz3Tu45EhOoi2Rmnr24lmQutLO
        LkX1yumjtb8+d+sicZilmXfobW6H9FRavhERpyAcFOLBIBC9cl1hbo0SnMYc8DgOhL2JC0j7oyq
        6odpNtKCwIbJG8e7Z8V4dewvhITfAlZCLmksmEQyijbV886eJ9o+8lJqZZQ==
X-Google-Smtp-Source: ABdhPJx9BrKLBHH0bPtVWwCfvYyiXtPThWjODSxB4mbJWMrVJZNDsfk62pViMpDo3JCjCgAlRlj3rTRMd3k=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:784b:c8dc:f1c:ecde])
 (user=pgonda job=sendgmr) by 2002:a17:902:c643:b0:13c:957d:5604 with SMTP id
 s3-20020a170902c64300b0013c957d5604mr27961802pls.10.1632236630706; Tue, 21
 Sep 2021 08:03:50 -0700 (PDT)
Date:   Tue, 21 Sep 2021 08:03:44 -0700
In-Reply-To: <20210921150345.2221634-1-pgonda@google.com>
Message-Id: <20210921150345.2221634-2-pgonda@google.com>
Mime-Version: 1.0
References: <20210921150345.2221634-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 1/2] KVM: SEV: Update svm_vm_copy_asid_from for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For mirroring SEV-ES the mirror VM will need more then just the ASID.
The FD and the handle are required to all the mirror to call psp
commands. The mirror VM will need to call KVM_SEV_LAUNCH_UPDATE_VMSA to
setup its vCPUs' VMSAs for SEV-ES.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Nathan Tempelman <natet@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steve Rutherford <srutherford@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org 
---
 arch/x86/kvm/svm/sev.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..08c53a4e060e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1715,8 +1715,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct file *source_kvm_file;
 	struct kvm *source_kvm;
-	struct kvm_sev_info *mirror_sev;
-	unsigned int asid;
+	struct kvm_sev_info source_sev, *mirror_sev;
 	int ret;
 
 	source_kvm_file = fget(source_fd);
@@ -1739,7 +1738,8 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 		goto e_source_unlock;
 	}
 
-	asid = to_kvm_svm(source_kvm)->sev_info.asid;
+	memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
+	       sizeof(source_sev));
 
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
@@ -1759,8 +1759,16 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	/* Set enc_context_owner and copy its encryption context over */
 	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
-	mirror_sev->asid = asid;
 	mirror_sev->active = true;
+	mirror_sev->asid = source_sev.asid;
+	mirror_sev->fd = source_sev.fd;
+	mirror_sev->es_active = source_sev.es_active;
+	mirror_sev->handle = source_sev.handle;
+	/*
+	 * Do not copy ap_jump_table. Since the mirror does not share the same
+	 * KVM contexts as the original, and they may have different
+	 * memory-views.
+	 */
 
 	mutex_unlock(&kvm->lock);
 	return 0;
-- 
2.33.0.464.g1972c5931b-goog

