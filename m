Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95160720750
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbjFBQUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236809AbjFBQTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2010D134
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8a5cbb012so2948562276.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722791; x=1688314791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/V1kGubGBkIfoXYJDQ07ubxHVuJGyyAsuFFc2aDgLOw=;
        b=dAmbCS03qFxxsMaqx8qnLOWwCpo8ZGOtPMgwn3xK6ba4mFWhcxkmmVOrM/FFp4vhCG
         csYUKDWxijMqxcej2K6vKAkSVdr2i2aogv33PON1lYkKZLilkwuVkkR5tkmDZYOw2NmB
         f+bWPC9zJepmJqMfdpUYS26chQ2GYQ4WbogfMcxI6nATZ4UF7ahlzhczQ2Mc1lAMmSar
         AvyR4mqbb58ZbeIeZp7LIQgxVPReaza5QvbgaJqSHiv/IgMFZsQj8va70pdSNEQxNGbQ
         AcetQeLdV65lMsliQni+9gRTp6dhl4iApuCCXFlTgOQE3m5wyp3HYTDLfS300bpYHSEi
         2OHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722791; x=1688314791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/V1kGubGBkIfoXYJDQ07ubxHVuJGyyAsuFFc2aDgLOw=;
        b=OJdFBbavNR+zQMK/J7FJ/9krm7SbA1g/8v9Cn6R0uCIhTgzZ+oTEC9BsywIP6kU18I
         ghILT2Y0yNVCpU8nmcae/blL9STO8cT46C2gU3wtqE9+Nwba5QNwxlkvrV2lNUNVQ6Pv
         eugDT0HF21l8f0PPbpUBAkL4ZlJeXXcsS3reRQT3JThV8ZY1YWBDHri1KBXye9xw6P78
         VT6fIHSGN1FTEsACdnA85nxTeX9f+zXjxJ3VAQypW/Ck5NCzX228VxUVswDy9/FbUo9U
         b07qH4g7DLUNUs0MMsXIEMsEhuEnlqerLmKcEE61l/1TlmS0XBJJOtT1/Bewb09V756N
         o1Ug==
X-Gm-Message-State: AC+VfDwwGZ3UTJ0gnj0LjYXhK2yw3gXGRy2iVFiMFbBcb6es6jNrh3pM
        p43gs0vAVNZqaHh9j8L3aFWNLSiC4HVOBA==
X-Google-Smtp-Source: ACHHUZ4+4GemqH/Mjtd/gPSOa8r1fMjiXMzCqKk+FgepMOQ0q53LG6ACHpD2OnBz7aqhvf26Wx2mOHHyWhAn0g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1021:b0:bb1:35e6:6c4 with SMTP
 id x1-20020a056902102100b00bb135e606c4mr1245366ybt.9.1685722791063; Fri, 02
 Jun 2023 09:19:51 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:07 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-3-amoorthy@google.com>
Subject: [PATCH v4 02/16] KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN
  at the start of KVM_RUN
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Give kvm_run.exit_reason a defined initial value on entry into KVM_RUN:
other architectures (riscv, arm64) already use KVM_EXIT_UNKNOWN for this
purpose, so copy that convention.

This gives vCPUs trying to fill the run struct a mechanism to avoid
overwriting already-populated data, albeit an imperfect one. Being able
to detect an already-populated KVM run struct will prevent at least some
bugs in the upcoming implementation of KVM_CAP_MEMORY_FAULT_INFO, which
will attempt to fill the run struct whenever a vCPU fails a guest memory
access.

Without the already-populated check, KVM_CAP_MEMORY_FAULT_INFO could
change kvm_run in any code paths which

1. Populate kvm_run for some exit and prepare to return to userspace
2. Access guest memory for some reason (but without returning -EFAULTs
    to userspace)
3. Finish the return to userspace set up in (1), now with the contents
    of kvm_run changed to contain efault info.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e..a7725d41570a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11163,6 +11163,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (r <= 0)
 		goto out;
 
+	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
 	r = vcpu_run(vcpu);
 
 out:
-- 
2.41.0.rc0.172.g3f132b7071-goog

