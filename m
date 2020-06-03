Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A351ED9AC
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgFCX4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCX4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE87EC08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k15so6008866ybt.4
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8LGvgjxPtHovpdfipQl4OzIV0OZgS4Psratbe52QpYI=;
        b=VOAX6RwQTnpOzzetJzQKe+GL0dgnwPt0KQLTMKHo6Z+LqlGTg1frUdwKN6qPHZVoZB
         g20JS1pdxSuIFVeWLqLcWnrUqVTJ3jW5Y4euAJerQUAScpvc8WK3ObscO3srbDVMehbS
         0nkuAs1GCcJr4PgdHq9NiDHE1qSMi5l37bJxRgkbCuH1mnnh9F/FQtbBiDL7RfRltgl3
         1S0vCoCPEAMX1uFbv8FomMYFj2NsK0JVETaNE0T8UbRj0kwnWllWW1Ws9gY+4er25Cqd
         GV4KRPRixSaBoncQJBnSV/GbF1OgoG6TEsZVQFu4WrP1jy4G4T3hwiguOCSkQs8VSvSh
         xLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8LGvgjxPtHovpdfipQl4OzIV0OZgS4Psratbe52QpYI=;
        b=f/K8qS8MsfmLmEnQ4kxBRHSHlVXmyd/kLN8cWGoLlJHCMAOUz4VHgB11XqgR4f0ZWb
         UVSyNlGehVDEHgRPC30Bp2gJ+CixI3T4q5njt8NqCbg199MNWr6gMYR5H5ycTItgYn+c
         Sj/23+3f5CDAWRGTRnSk2obl/bLuR7HE1/A1NyO7NHCsVPm0a7aKJeRCB9dYJUdOgHpr
         urDKSwWl83BwAqLb5LDM1AJ1zBraJYiH03Vshe9BK/IZvaEkzSo8yHBth3hbMQuoSX98
         k+bP1D4cRRxjVlPArYsicr6intFq/9Yejotitc7YBgKBtVwa72gfq5P0SrPI35d4hRsj
         BEsw==
X-Gm-Message-State: AOAM532WhzVsDxch1bIBLnXXH0vloWAO2JoiPkh1x4fvurxPHdMAB95Q
        anjcOEuV9WGR9BsD2InQKjMQ7Zh70u4va0XMTa+TMlIxEdNcqZItE2FYtZaT4Hl6j02ACmdZYty
        71FP/7J8k0fCxcy5HXohl6PSVCGS75GxWe1btAXPnlF3kRwyxbfFPkUQEVkjPDIg=
X-Google-Smtp-Source: ABdhPJw6+P/WbcsMdK9Mni+UnFCi7g7O2DHxxrT6Aw2CqAiR/3DIaOvChvumeVuP4v/ctDwRlBSC06yFqWfmIQ==
X-Received: by 2002:a25:6ad5:: with SMTP id f204mr3537546ybc.147.1591228594848;
 Wed, 03 Jun 2020 16:56:34 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:18 -0700
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Message-Id: <20200603235623.245638-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200603235623.245638-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 1/6] kvm: svm: Prefer vcpu->cpu to raw_smp_processor_id()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

