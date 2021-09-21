Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07EA4135C8
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhIUPFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 11:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbhIUPFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 11:05:23 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FED6C061575
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 08:03:53 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id bk33-20020a05620a1a2100b00432fff50d40so102452177qkb.22
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 08:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GIfCLH5ByXyE5OlyMkygyHkkDqaZzo0Y6ZcGzOkxcjM=;
        b=nVhiK/GpBtOXB21+2y1Z5/mIgNi/PJLMHvMmYkPSJCUONZSiXYTy4R2MYYs8CZlxkW
         CUQwR5cFuCMVxXnfEc61HeMSySMnwFDogvYg5ie3AuBTVk+eWXupS+O5+a8MGvW4qXl0
         +ASR8ngsa5zHO7kvT7V+BVRHyd6gVcP3TVX4QckPchkEq3ry+VUXeXjX+4Y+elhDi91V
         +72WNrD1t+y4O0xgDgvl6PjQjnHsq7TuyvC6eWBSqmMc8hlTUZw5N7UdzHVSvLInrYQF
         d1AQ+skxMoPxuZOqgtm+o4AZqLXq8PTEUgjjNfstsMg/RZbQr/QTu9GI+geMGFJt2GiN
         QIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GIfCLH5ByXyE5OlyMkygyHkkDqaZzo0Y6ZcGzOkxcjM=;
        b=x/SGhsff+/7priukxp/34zBW3K2Hncf1azXd8aGtmYOidFnf2qu+nG/Us4Ml7iI/B7
         1YsUvBXQwdb5y8rQ/bWGQnET/LWbK0idKp7n6pKutrAxVeU/KK6OX5JBgpdk40OtMWvU
         ITM/zUZlzM5/3lJYJXs+77PePaLdhomWz4gNwS7D9xw5z0jpoXzryY8uJ1VyadzjCQS3
         nrwyO0lyFyH77/Am8PvBcmQuGy5jN9GnlJrEcYs+ZdfyUJsXa9vR30oygQVb8ffJRpXd
         fQRUQVTzIj0f32Ny2ujpy6rz4o71X5MYz4H1avagvVcQjPd9AFqktMSpjAzFFjUHnSHs
         Q/gQ==
X-Gm-Message-State: AOAM530pdrRPTQ98Zte8aE8/jubxNPazotQCCVWz+M1qVwEEi0i5P76j
        Ig/GWzMGC6vmLHEp2ttTScU8EZUg7OtqVePpvB7USYYQ1RACUuSlK6+bIqYxCG0XHWru7xZqVhO
        zzfA1EP8R941WaAlQy8anWtfSgYvPO3D37DwpJPXamR1Bw3FcfpZAiU160A==
X-Google-Smtp-Source: ABdhPJwCi+e3ST0kkgoPvto/H7JxNar7/O+1VULp0nXGElHq8yDYFuvofnKtYEs/kkCQjOZvde9gPRCGui4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:784b:c8dc:f1c:ecde])
 (user=pgonda job=sendgmr) by 2002:a25:ae64:: with SMTP id g36mr39999087ybe.26.1632236632524;
 Tue, 21 Sep 2021 08:03:52 -0700 (PDT)
Date:   Tue, 21 Sep 2021 08:03:45 -0700
In-Reply-To: <20210921150345.2221634-1-pgonda@google.com>
Message-Id: <20210921150345.2221634-3-pgonda@google.com>
Mime-Version: 1.0
References: <20210921150345.2221634-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 2/2] KVM: SEV: Allow launch vmsa from mirror VM
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

A mirrored SEV-ES VM will need to call KVM_SEV_LAUNCH_UPDATE_VMSA to
setup its vCPUs and add them to the SEV-ES VM. Since they need to be
measured and their VMSAs encrypted. Also allow the guest status check
and debugging commands since they do not change any guest state.

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
 arch/x86/kvm/svm/sev.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 08c53a4e060e..9cb6e30d6ae4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1501,6 +1501,20 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
+static bool cmd_allowed_from_miror(u32 cmd_id)
+{
+	/*
+	 * Allow mirrors VM to call KVM_SEV_LAUNCH_UPDATE_VMSA to enable SEV-ES
+	 * active mirror VMs. Also allow the debugging and status commands.
+	 */
+	if (cmd_id == KVM_SEV_LAUNCH_UPDATE_VMSA ||
+	    cmd_id == KVM_SEV_GUEST_STATUS || cmd_id == KVM_SEV_DBG_DECRYPT ||
+	    cmd_id == KVM_SEV_DBG_ENCRYPT)
+		return true;
+
+	return false;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1517,8 +1531,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 
 	mutex_lock(&kvm->lock);
 
-	/* enc_context_owner handles all memory enc operations */
-	if (is_mirroring_enc_context(kvm)) {
+	/* Only the enc_context_owner handles some memory enc operations. */
+	if (is_mirroring_enc_context(kvm) &&
+	    !cmd_allowed_from_miror(sev_cmd.id)) {
 		r = -EINVAL;
 		goto out;
 	}
-- 
2.33.0.464.g1972c5931b-goog

