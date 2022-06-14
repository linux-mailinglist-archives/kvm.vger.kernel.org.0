Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC06054BB35
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357168AbiFNUIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357225AbiFNUIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B027CDB
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:47 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x11-20020aa79acb000000b0051b9d3136fdso4242933pfp.1
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6m++h1TLmwB8cNEM0gWLCTf/lVisfRn3tV3Xo5ZBF2o=;
        b=nWH/hVsCDdNk2ASx5jRA6o8Tna0+54SOB08YEt9isPQyB5OimOPuFRizPtguQSLNIh
         wM+hRGc267ThJtLhSExxvQy9S3xULfRuAhaw6p2s9Iu+bLTEpC+Y1Va6DX0+Su9jThbJ
         /EdkVlTgE1aZGRKWt1soyOy+IkhJrUVhwZ4BXa/qT2MwyjuD9IFuxEUPiCM1467a9Xn8
         SSacTIOVEDUlgMDNZHrL3uVGJ11hu3kXiNefWHKg/HWcKPcA1I06gRBhdkww2RE5X8M2
         P1SvIQQJ5Hana9l/zq+prl8PAmPyUboVk1EvCXar/b6xDzLpq1ncksE1z3wxgNPUFGOx
         eRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6m++h1TLmwB8cNEM0gWLCTf/lVisfRn3tV3Xo5ZBF2o=;
        b=hTyuRmxAgCEztwVgULW0IHh6HM9Lg+X8eRKlwtTGV7ZLTEb3uPSVKxrEOympqatS9n
         6CiEa2cogMmGG/foz4+J3WS3FmEZg8OmH4HVXfmpEvNaasxhfFJEi15HivVShi5hnhGO
         Q8HxiTsK8TsEYoNytP3CyuUVhe0CR16O1GCo3HjA+Sz7YS45L6EwaJnMbL9XsiwZdXF4
         CyK1Ka4E3qsiDeS7BCk1PB0MY8j7l5Nr9kYiOezLluZz8xddBdEW4osPprI9qGJ1Wtuy
         WlvFBTzilqBuhHy645gBI91CJulHTJxPOcO/CFsmVhg4M3x5idY/4ravdLiBTGYYNIpE
         xgoQ==
X-Gm-Message-State: AJIora9nlQcNwneZX6zdk23d4zDzFzwjwPQeObcUjE7OBUjYrfMalmE1
        AmRuKQU052R8t1+uVJ6Lnj1OfbpG7is=
X-Google-Smtp-Source: AGRyM1vt7V/df3fvVEWr9ejSWyNdVhY7D3OL27S/3XkGdZ4iP7evofRU8vS/rOiDkTiD5UeyK3+yiJ+yGSo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr192571pje.0.1655237266602; Tue, 14 Jun
 2022 13:07:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:44 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-20-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 19/42] KVM: selftests: Don't use a static local in vcpu_get_supported_hv_cpuid()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Don't use a static variable for the Hyper-V supported CPUID array, the
helper unconditionally reallocates the array on every invocation (and all
callers free the array immediately after use).  The array is intentionally
recreated and refilled because the set of supported CPUID features is
dependent on vCPU state, e.g. whether or not eVMCS has been enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 55838c603102..7c0363759864 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1288,9 +1288,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 {
-	static struct kvm_cpuid2 *cpuid;
-
-	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
+	struct kvm_cpuid2 *cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 
 	vcpu_ioctl(vcpu, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
-- 
2.36.1.476.g0c4daa206d-goog

