Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1171EB1A8
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgFAWYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 18:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgFAWYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 18:24:39 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838E1C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 15:24:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h129so14284840ybc.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 15:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8LGvgjxPtHovpdfipQl4OzIV0OZgS4Psratbe52QpYI=;
        b=D4EjhKljo66zAmzcE74W2Z6+2+uQP/r15aP1E7YXkTeFsGejV8IN0LAr9ks2Qn79iS
         58Oifvol/eu8k2vKR5YcmX6vx1a5USb1rNTyTO/ksTT4mPKBMe3nhgyHhja5+N2l+GPq
         CaEidxMPzHumpImm8hDSYEGEZeIFeECfLLVks0kGFgYaTi77floy5w0pYpm17enssPbG
         sixq+sMRjGZg37jQ779JWmWp2uSIGea1GYj74IIdPQHxggRkLDdqP3GaHnhiFmP8Cj7e
         c+KpmDrMzyiMccxo3Jp7VuToIQDAeLo+KMGKs45qkO+dvgUvWAfoHEZ5d5H4x+WyvOcY
         2wJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8LGvgjxPtHovpdfipQl4OzIV0OZgS4Psratbe52QpYI=;
        b=HZTLlzWVlYOvkN0dgaEwtmOjsJdF+ujzrOhTXfKUHkSjevUEAs002Dms9xTvEBKPQv
         htmfJGOxdWAzjXa3zZCFRDjmQP2jOqxncRaUbm/kC+Fxf0CgpCg1QPYsZTjGWDvkBn2r
         kRc5227BeQT75rPpXZFQrnEUmSHfQLNDsoERcnXlX7c60J4gjuBii9PqvQ6t/VhwEwvC
         y9OBDBg6pvQ5DcTSMNf6FJimZK72blC6QRm7IDTWP6fF801UdrBrKFePPEZP7ydLF7m/
         uqf3rbV5QoChEjnU8csIJ91fNaubf9Tk3HaRmuyY+UZPWhlgfpQINXX/PHCv8CDjZLIL
         tNgQ==
X-Gm-Message-State: AOAM5332kdU6rG15SGLR6cpdINnErwgwm2tRu2tyXWV8Uq/NC/xunib8
        qN7LKcpHgWnhAXBh3WnqU6tAve7IfQv5xmGDGrX2MBZpzMaZ8wJB8hVwJVEZDEtRO8A/ghV82eG
        NJuYHtr9Igxuyj312d+Kfa5aWhWWGohcURVXJDAdvniC16Jlw7EpCzPck2CrL98c=
X-Google-Smtp-Source: ABdhPJwDJsoqPna/zuF6W+qLXYqSsCNqtDOzJxdnOsvSqE35jPUb+ipOCIUXYKgn+PgPdxRyFeEsRHZU237UGA==
X-Received: by 2002:a25:ab4a:: with SMTP id u68mr13912680ybi.271.1591050277722;
 Mon, 01 Jun 2020 15:24:37 -0700 (PDT)
Date:   Mon,  1 Jun 2020 15:24:13 -0700
In-Reply-To: <20200601222416.71303-1-jmattson@google.com>
Message-Id: <20200601222416.71303-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v3 1/4] kvm: svm: Prefer vcpu->cpu to raw_smp_processor_id()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current logical processor id is cached in vcpu->cpu. Use it
instead of raw_smp_processor_id() when a kvm_vcpu struct is available.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e333b91ff78..f0dd481be435 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2990,21 +2990,18 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 static void reload_tss(struct kvm_vcpu *vcpu)
 {
-	int cpu = raw_smp_processor_id();
+	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	sd->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
 }
 
 static void pre_svm_run(struct vcpu_svm *svm)
 {
-	int cpu = raw_smp_processor_id();
-
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu(svm_data, svm->vcpu.cpu);
 
 	if (sev_guest(svm->vcpu.kvm))
-		return pre_sev_run(svm, cpu);
+		return pre_sev_run(svm, svm->vcpu.cpu);
 
 	/* FIXME: handle wraparound of asid_generation */
 	if (svm->asid_generation != sd->asid_generation)
-- 
2.27.0.rc2.251.g90737beb825-goog

