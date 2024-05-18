Return-Path: <kvm+bounces-17725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B52A8C8EC9
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 02:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBB25282A89
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29D41BDDF;
	Sat, 18 May 2024 00:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gLSq9dGa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB362F3E
	for <kvm@vger.kernel.org>; Sat, 18 May 2024 00:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715990694; cv=none; b=qq3PgeJT1/4nFOdJNaLc1kqBmluiaT6/Wv9uwAlodHcwwnpetmgW2WEJBmCiIfNnsg5HZ3iIf4CT2Qc26rJG0XUdOkp79MHX649jsiDOPGZYthbTk4h/NjngbQVJ2kMB/QWfWbuV1MP+uZmHGh++IGRhFp/Ga4p6PcM5fh0EEbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715990694; c=relaxed/simple;
	bh=ectuSuFOojgkLLmjDmKbjYyngGKrMAV7Dv3oP241fUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m31JHeO6WXn/MUtHbmyNH/WnQWBa5JdwkbwPzNGgxU5MDHibGao7wyxHsBxrS4OgUeSfriP4FbNNIqxlGAbxiDK4mCy0B+ZiREaPbbb0Hpq7aYyL3k/67gGwjoqNs0I7Fcc4RbciJ0uvVxdNTjdpynRWAA0ExusiVHMboqpud4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gLSq9dGa; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de604ccb373so16868760276.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715990691; x=1716595491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PmNsMiZYuI21fzAH4xPEmM+x/ygJuUkqhfrSS79CJmk=;
        b=gLSq9dGa52ECmsdav/wAWAWWusX9aMRCf9x2jakCdnSa6yyy0nE0yf8W0+ODQ1y3ih
         AITH4araNa5L9rj+ut55wbxonrcFzcCijBU6RO30aMAVO3BfDXuoZ6bj8gAzCc3d3fCq
         GuxUyDNjVzVwjBJDFnqtc1LuaEoyArEw+hSRHGOQPisM0mK7CxUI2WXnRbGgt2dNfi7c
         MkS74t+vw1k4WwhqlV7O5IPLj9+fSGv6FSY2YikhBXnsyPHVKBa5WXMncKcAhAWNNcGi
         6PjM8vMcqi8q3weCMigX9da32peQbE/LerKZ7tcQx7zblZe5XiD4kLwmjMwZWV6aeTYw
         eOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715990692; x=1716595492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PmNsMiZYuI21fzAH4xPEmM+x/ygJuUkqhfrSS79CJmk=;
        b=NlCpFjaG7g+X/Q6sN0OPk+3UofgM83riunaDsLK982oOzC+cXywggpbazkYtBuIPkW
         7/GE0bCWaDQUwffwv2O/WXL2tJN/acfVvMnlcMdvCYzTNDdIiYm/JtYSXCFjTby+04H8
         IPh8062dOk4Tee7o2XOB0waLwKVW9LROOQwdk2BWFMR1npkdg7fDH5nV5uvMs3zNQ3Fc
         izEO4G1qGPGe6i61qQSwkwe764SUH7iOJXz2T67IVL10VdyjVPRxn2zpMr8VIxXD/+U/
         n2vjzAIrXqM3eyEpOXxUYCPUYVIlRXkgailyDC/VrFQnfnsUGGWIaD4Oj1uNPdLeJo1k
         CEww==
X-Gm-Message-State: AOJu0Yyrw1wwUcIaOCV0mB6QaQ2uMbKcjXp17zVJBwEsSfeN0u1YEud9
	j+uXiCqswEtd6vy7F06KYkd47/k7DN2LF03+dcnwLwB0MrL/N6xXQOigW88w8AZ+ENO3tHVOAkC
	JRA==
X-Google-Smtp-Source: AGHT+IEKsAdKYBFpozQHbHXiVJ/HspTDM2CFInyHubWioj3i50BbfdUhI4/kUioYnKr2iux2sNvJgfiTfs4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:706:b0:dee:63ce:9718 with SMTP id
 3f1490d57ef6-dee63ce9a16mr2061685276.1.1715990691759; Fri, 17 May 2024
 17:04:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 17:04:29 -0700
In-Reply-To: <20240518000430.1118488-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240518000430.1118488-9-seanjc@google.com>
Subject: [PATCH 8/9] KVM: VMX: Enumerate EPT Violation #VE support in /proc/cpuinfo
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Don't suppress printing EPT_VIOLATION_VE in /proc/cpuinfo, knowing whether
or not KVM_INTEL_PROVE_VE actually does anything is extremely valuable.
A privileged user can get at the information by reading the raw MSR, but
the whole point of the VMX flags is to avoid needing to glean information
from raw MSR reads.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmxfeatures.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 266daf5b5b84..695f36664889 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -77,7 +77,7 @@
 #define VMX_FEATURE_ENCLS_EXITING	( 2*32+ 15) /* "" VM-Exit on ENCLS (leaf dependent) */
 #define VMX_FEATURE_RDSEED_EXITING	( 2*32+ 16) /* "" VM-Exit on RDSEED */
 #define VMX_FEATURE_PAGE_MOD_LOGGING	( 2*32+ 17) /* "pml" Log dirty pages into buffer */
-#define VMX_FEATURE_EPT_VIOLATION_VE	( 2*32+ 18) /* "" Conditionally reflect EPT violations as #VE exceptions */
+#define VMX_FEATURE_EPT_VIOLATION_VE	( 2*32+ 18) /* Conditionally reflect EPT violations as #VE exceptions */
 #define VMX_FEATURE_PT_CONCEAL_VMX	( 2*32+ 19) /* "" Suppress VMX indicators in Processor Trace */
 #define VMX_FEATURE_XSAVES		( 2*32+ 20) /* "" Enable XSAVES and XRSTORS in guest */
 #define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* "ept_mode_based_exec" Enable separate EPT EXEC bits for supervisor vs. user */
-- 
2.45.0.215.g3402c0e53f-goog


