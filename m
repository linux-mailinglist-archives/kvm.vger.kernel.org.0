Return-Path: <kvm+bounces-3208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC7B80189B
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C84FB21149
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9F2A946;
	Sat,  2 Dec 2023 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yi3mtKeS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5A52119
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:05:07 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-db547d41413so1101727276.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475507; x=1702080307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IhZ3de9k1HjNH/Bu/XjK12LAbUtP2nz//8sjZrcxVFU=;
        b=yi3mtKeSyuMTg2ekZ+/+KHt6dGdM8458RVwREftQmbGtrJYq7406KdRABl9PcTb+CL
         BxDGHqeC1gn6RyA1uK6n92dx8yT844WisuaPX0XC3v0byK1djW/n+hIvhjq+z4CGh4ZP
         oKG6hErIloQ3LrBOiDqurHnpbbOy/Q5fmfvgJ6DbEu2DysHogYB5+A9NBkiYC0TG7F+K
         7CHKIpg9igtAgW1T2+NzZo2dPu5gTAamE5DaEzqQyWFB6gYxhSv9GRsfWhXi5sZ+G3gp
         Q6p9DDpr32sc0PTPe06Ra+TtDRrtQdi6OjXaIAnHab1Df1GufCC6HEGsGz5smCm+d1Hf
         rJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475507; x=1702080307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IhZ3de9k1HjNH/Bu/XjK12LAbUtP2nz//8sjZrcxVFU=;
        b=gAZSD7AHvuMIORdjaCZnsb6kFPw4pJX5LgXjd7PVOX0RpFhA63p0EcV/4uukKPS7yc
         9sfq+NvcwcP1ew9SZNOvu1M7/BpfNWD9HnKlpSiRbHNa4MOEGfmN6thfdtU79MhNxp99
         +OGp8UNf0SgrAR2vPG3k7via4cPvYUgpaULCahYSahzsKB1puQzHiOZPxL7VPPXLmR0B
         W0QPohyhTuO/1AhFVjP1hcw2G1HWbqLcLVd1acctCSuBg6009Dh4+id4OolS7MxVwFhQ
         nwzdVXCisbzLH/w2lUtxjPHuaWX+eBPA+v+ZwYJtnlJ0Y3hFh9e/eUE4G/TG6ONfV/kg
         ECaw==
X-Gm-Message-State: AOJu0YwNw0rx3dV+4FFkU+8tq5uF5Ds5pH/mQ6CuGwYG952nE3IF7MGZ
	yGU8rMtRHAupXz7Q45GkgKAehbUIkhY=
X-Google-Smtp-Source: AGHT+IF7EvbF+32/WpDow2GN0LC+RJVYaIxYrl/y8e1tQA4IoCLx/a9NVjw2ndyWlMFBlrsBZDrM/VqVii8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:33c2:0:b0:da0:6216:7990 with SMTP id
 z185-20020a2533c2000000b00da062167990mr1090050ybz.3.1701475507021; Fri, 01
 Dec 2023 16:05:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:13 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-25-seanjc@google.com>
Subject: [PATCH v9 24/28] KVM: selftests: Move KVM_FEP macro into common
 library header
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Move the KVM_FEP definition, a.k.a. the KVM force emulation prefix, into
processor.h so that it can be used for other tests besides the MSR filter
test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h       | 3 +++
 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index d211cea188be..6be365ac2a85 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -23,6 +23,9 @@
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 
+/* Forced emulation prefix, used to invoke the emulator unconditionally. */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+
 #define NMI_VECTOR		0x02
 
 #define X86_EFLAGS_FIXED	 (1u << 1)
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 9e12dbc47a72..ab3a8c4f0b86 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -12,8 +12,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-/* Forced emulation prefix, used to invoke the emulator unconditionally. */
-#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 static bool fep_available;
 
 #define MSR_NON_EXISTENT 0x474f4f00
-- 
2.43.0.rc2.451.g8631bc7472-goog


