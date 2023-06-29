Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D486742ACF
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 18:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjF2Qsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 12:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjF2Qsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 12:48:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A125E30DD;
        Thu, 29 Jun 2023 09:48:44 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-666eba6f3d6so594505b3a.3;
        Thu, 29 Jun 2023 09:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688057324; x=1690649324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bSki35S0PvYwPqAK7/2pZgtomNRuxO2llKu0zknsBnk=;
        b=IK+Pu7ifwtQliKRnlj7Nn0eRKL7I9Mv61uWrAaYBBeZPmZxyj2Ylq0fHe/hNc8Qta7
         +g2uEiGK268PijWCOTVsvTKUvA+M0aMyMQtFji356Rjm5+dteYzfddK/RcCqnMSv3qYi
         9haTTQEfVNYrmH60/crg+3qwUN8NNDdTVEaaHTWO0m7ImgyJrRknPymq2UaxzCDvNUEG
         x+FBxXw+/1F6EREqw8ZdTahpzV7WnthvKOk7jCx/VuudswbAWudta+SN2dFunv0W8BdE
         57Lxf1Ho/3Is0Cprcb+XoAIZ0DUjrKlPe3vPv7oqfJ4jZX8/lywCQ4W+zjg7NMuL2CNz
         IsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688057324; x=1690649324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bSki35S0PvYwPqAK7/2pZgtomNRuxO2llKu0zknsBnk=;
        b=WtDGBLt44+Ltpl9eXEn5u8iN0qiMXNkRGD0wfp+W2pY43NGxib87nIqZya6I8y9N7s
         Mrrxh5l8HKEdWlhaHw8HHDz3AEE75ZhFYZCoYabWqmNgK2NGsJlo9JfQ0ZnKDTwSSxGP
         fCNo4DGtIc8QrPKslCxn5cPVksu4hP+m4sLDoTwJA1yToex5htHgQxOPXHS1GHQCNbHa
         2znaEdC6OE4oGhuX7+EljS5KAbMEPRC4gyBkpkCeO6wJCtOvuA2D0wFbq79J5C3pLA8q
         oJAphfGyS4E1dyvAKqrp34zoYZZGIo935IQEPE6FGXYeVELkYVlkTQYzJFNxULJEH2Lu
         2B0A==
X-Gm-Message-State: ABy/qLZeQD+/N5QYy3/EIWpZrg2OvI3X6HMtzsFaRB0bxIocMMzKjQs5
        sdCY+ITHvGrAOXf1u740kYA=
X-Google-Smtp-Source: APBJJlFLalmrW00cv9nDfJaWZuxENtV9pNZdmFCIw6hOxO1KZHGUQnax8YXliaHN1g7SEU5Mf0q1ng==
X-Received: by 2002:a05:6a00:b92:b0:680:fa5f:4ed6 with SMTP id g18-20020a056a000b9200b00680fa5f4ed6mr545799pfj.27.1688057323982;
        Thu, 29 Jun 2023 09:48:43 -0700 (PDT)
Received: from localhost.localdomain ([114.84.30.247])
        by smtp.gmail.com with ESMTPSA id k6-20020aa78206000000b0064aea45b040sm8557339pfi.168.2023.06.29.09.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 09:48:42 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/tsc: Update guest tsc_offset again before vcpu first runs
Date:   Fri, 30 Jun 2023 00:48:38 +0800
Message-Id: <20230629164838.66847-1-likexu@tencent.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When a new vcpu is created and subsequently restored by vcpu snapshot,
apply kvm_vcpu_write_tsc_offset() before vcpu runs for the first time.

Before a vcpu runs for the first time, the user space (VMM) sets the guest
tsc as it wants, which may triggers the time synchronization mechanism with
other vcpus (if any). In a scenario where a vcpu snapshot is used to
restore, like the bugzilla report [*], the newly target guest tsc (e.g.
at the time of vcpu restoration) is synchronized with its the most
primitive guest timestamp initialized at the time of vcpu creation.

Furthermore, the VMM can actually update the target guest tsc multiple
times before the vcpu actually gets running, which requires the tsc_offset
to be updated every time it is set. In this scenario, it can be considered
as unstable tsc (even this vcpu has not yet even started ticking to follow
the intended logic of KVM timer emulation).

It is only necessary to delay this step until kvm_arch_vcpu_load() to
catch up with guest expectation with the help of kvm_vcpu_has_run(),
and the change is expected to not break any of the cumbersome existing
virt timer features.

Reported-by: Yong He <alexyonghe@tencent.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423 [*] 
Tested-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 439312e04384..616940fc3791 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4818,7 +4818,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (tsc_delta < 0)
 			mark_tsc_unstable("KVM discovered backwards TSC");
 
-		if (kvm_check_tsc_unstable()) {
+		if (kvm_check_tsc_unstable() || !kvm_vcpu_has_run(vcpu)) {
 			u64 offset = kvm_compute_l1_tsc_offset(vcpu,
 						vcpu->arch.last_guest_tsc);
 			kvm_vcpu_write_tsc_offset(vcpu, offset);

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 
2.32.0

