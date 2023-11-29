Return-Path: <kvm+bounces-2816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 487947FE396
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 23:49:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0173F282005
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F7547A44;
	Wed, 29 Nov 2023 22:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zJLBm2z9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CD7112
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:19 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ca61d84dc3so6269977b3.0
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701298159; x=1701902959; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQGfKgLsWbH5boPzhPSVcXAwo8BdoBCKDSp6PZpEKdw=;
        b=zJLBm2z9mHwup210q5dz0tBNXPFt0BVAYjuuQqQXcvyn5wDKpaNkyDHhcm8MsN4ZnW
         TToqv9GcGtBaHlxh+6jAK3rzvl9VRVMh3feUt9hRwH0+3UqXP7TpNwfm2X0LdNV8yD9Y
         CkbCkxj4nz2so/XBELHFUqK+Zs3vKduGnpY/cvdoRRahwiM5PHexh4sLXRLHTgjZqKP5
         70OR/iS2PqH3tgPmjd3w1VxNehr3Qza4XpGKMsZY6jhCN/CubiK+MkChZ4H/VAfplJoi
         vqsDBgNGTWkpjo3o01RjfQJsXYBvdbnOfS5ZHs14sbrquiUFFuLnTMNLlSg1js4YFIY8
         SA5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701298159; x=1701902959;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQGfKgLsWbH5boPzhPSVcXAwo8BdoBCKDSp6PZpEKdw=;
        b=hkUJOSUjc9u94Z3fk99vzvWfdNS43rX0danwqlJd07Staz/FnHbqvx834ZSp5y5Y9H
         n5nORnhpGbNfmhcRqVpbjNVtT+ZHEraJYsyYNxTISPBfIK5HQoGw73gkqSuLaBMsG0Xr
         aUTBs1iNQi2b8W+JfBb+dWMT9+coiY1apsEwiwer348qv8JFNZgHQtC0b+xEHuatDQGM
         1PY/sAmwbxRz4HY8BvdcOM+Zz+gbPMp8AXlExPyvSedw/Z5+HJYuqehhWRNv7CHAopzS
         MqrdeqY1Vxz4Ut+VgDlF9Vi2DuqFyPMiz4yjxAB6hU67MdrhmfFudGEeXTO7rSQZe5ip
         ModQ==
X-Gm-Message-State: AOJu0Ywf50QlayPwNjkAvc6MaQS2Y7azOe7c6yAlQNBIIuLRpH0NUVql
	mh1RRJ/jQDo79Xrf/xYqDIiZ8CzSjCA=
X-Google-Smtp-Source: AGHT+IGsUSjfvRWUpviDYQXPdAuM4jG73OOk44zgfo4+QQBkUpvCVmZ+QUiwISRihsjSPP2r8hQPZ78ZMSg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3608:b0:5c5:bc62:9734 with SMTP id
 ft8-20020a05690c360800b005c5bc629734mr654018ywb.9.1701298159181; Wed, 29 Nov
 2023 14:49:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Nov 2023 14:49:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231129224916.532431-1-seanjc@google.com>
Subject: [PATCH v2 0/4] KVM: selftests: Annotate guest printfs as such
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Fix a handful of broken guest assert/printf messages, and annotate guest
ucall, printf, and assert helpers with __printf() so that such breakage is
detected by the compiler.

v2:
 - Annotate the relevant helpers. [Maxim]
 - Fix all other warnings (v1 fixed only the MWAIT error message)

v1: https://lore.kernel.org/all/20231107182159.404770-1-seanjc@google.com

Sean Christopherson (4):
  KVM: selftests: Fix MWAIT error message when guest assertion fails
  KVM: selftests: Fix benign %llx vs. %lx issues in guest asserts
  KVM: selftests: Fix broken assert messages in Hyper-V features test
  KVM: selftests: Annotate guest ucall, printf, and assert helpers with
    __printf()

 tools/testing/selftests/kvm/include/test_util.h        |  2 +-
 tools/testing/selftests/kvm/include/ucall_common.h     |  7 ++++---
 tools/testing/selftests/kvm/set_memory_region_test.c   |  6 +++---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c   | 10 +++++-----
 .../testing/selftests/kvm/x86_64/monitor_mwait_test.c  |  6 ++++--
 .../kvm/x86_64/private_mem_conversions_test.c          |  2 +-
 .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c |  4 ++--
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c |  2 +-
 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c   |  8 ++++----
 9 files changed, 25 insertions(+), 22 deletions(-)


base-commit: 6803fb00772cc50cd59a66bd8caaee5c84b13fcf
-- 
2.43.0.rc1.413.gea7ed67945-goog


