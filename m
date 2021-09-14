Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7283740B5C0
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 19:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhINRRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 13:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhINRRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 13:17:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49688C061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 10:15:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v16-20020a256110000000b005b23a793d77so106988ybb.15
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 10:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=arTh63mKKz2UjJUT7owYdS6q6AzPlBHxrK8LnvU/pPg=;
        b=c8+R69jscaR3LSiuenW4TuKCq+Ntj3ps02aD68vYYywqoXpGq1bt4CEQdSGzH7GFFD
         YA9gvZqm1/wq5XkZsp7V6rmfKP07o9SQSnku9nkDA0ToG2q0nImHP9MHtcvm/SdUSmsa
         kTvmC/b2bjRGVTdPB0v6/hhrQRz6JORTNipxEqdTsdoa4uhvHbZ51txngI1gjm77cyhw
         f4hvw+JzVJSLJYHKSdWWQduiir57mpvGUUDIymzlf0W5i0PK5R5+r8kQ8lqUGZb94Pw7
         D8HkVDLku5SEcigXvdzKfeSmC0EzDKPhQ2fO8vq1lJ5SX4gK4o7eO6MAjXLEUFQV3Jnb
         k7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=arTh63mKKz2UjJUT7owYdS6q6AzPlBHxrK8LnvU/pPg=;
        b=09XKEdFhb0m1SbvIx4Q2N2I5Fw0yafQmXFi8FUaW/kzSR8xYq/V40marPlwzoYq2XV
         xUjnzQ1tIkSTAjkWFGQQaZCB0dQGeZbkOTgP6PmgMqoh79Qx+4c6iaMsU/KaAoa05plR
         +KzdIMHUV+Y0HRvg6t56UmAwypeqASIjAXIjpnWQcfOxOKpF+Qrwt9RN7EBHAm5xEB+A
         1o/FRS/C6HqgMfDW9K6xNb/0BuVDqfqtOr+hQT2z+hnNIUjdMkK1YR+93JL1CrSraRG4
         hXG9lJQg7ILT+SbNOoTBHJygTd1VWltAS8k/HSgMJp35mFLoGBhZX0EkOWbxwHbeLTO/
         hUIQ==
X-Gm-Message-State: AOAM531UEApMvwqUvhNQhB1ylQ/SuzzZ+Lzc4PfpSxTnzuvUGkEx72ou
        7raHSjO7R4gqvgnWksfd8yM2V5KEBmnqxwmUAZ3HTUGdlbpeF5CGXmXtQbb9DAJX0CZsqLVdim0
        TXoWZO2W5cYJJ7bjwGWUHgRl+G6xIuy5kZTybrS6BWp+jgo4gHdrhm3W1/A==
X-Google-Smtp-Source: ABdhPJwVNgP5CvMV+cdVnb5Bnrr1y0ECrwdNlymG78pUyGAiKl1jx17bS7ntg1rn0KjWkBG+R2Q4/I7/7ro=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a25:d804:: with SMTP id p4mr272746ybg.87.1631639754332;
 Tue, 14 Sep 2021 10:15:54 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:15:51 -0700
Message-Id: <20210914171551.3223715-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
SEV-ES guest.

Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Nathan Tempelman <natet@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..8a279027425f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1728,7 +1728,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	source_kvm = source_kvm_file->private_data;
 	mutex_lock(&source_kvm->lock);
 
-	if (!sev_guest(source_kvm)) {
+	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto e_source_unlock;
 	}
-- 
2.33.0.309.g3052b89438-goog

