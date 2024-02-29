Return-Path: <kvm+bounces-10318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3814886BD07
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 01:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A648B1F2422A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 00:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D508329CEF;
	Thu, 29 Feb 2024 00:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OPMzu0ZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A08B1EB22
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 00:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168024; cv=none; b=AUxujXFH7/9P2j9b0eWTgbVCrqXOpevxfjH6ymiyjXu29FGXyI4We0Xu2NAxLIOazV4NvqyGyDaB6WFdERbfE2+Gefppkcm/1xkw2hcH8FHJIn42dMnJQSC7yPLn4EM2LnYZTpIN4jtAV+JeZiEEsAkHTmEQmccR8tSjcu7SpeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168024; c=relaxed/simple;
	bh=ixPn/WA/IkkMHbVj9xbnA+a/EFMiv0ErX3XQ1lo3UFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sWwY+2l7KSTBvq1WNeWtTPeN6XI6lpN+zNaHap25PT9KA5WF7/cn+BP6Xv9rC01pyGN5K4ZgJagEChz7FPEkdA0gMThyaRzBEBYkJwzDb55nV25vMybIhIltuvbk70E9vkp2A1ZEQStT2gopswmm+Uazdb0BvaAcD3QAX88npN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OPMzu0ZA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-29a5bae5b3fso197314a91.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 16:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709168021; x=1709772821; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1fAxVxcSGJDtvwC4OA6vg9SQpipa+6cd4wlsruGTgI=;
        b=OPMzu0ZAHxAiycSPECv0MUQt7f0j6ydg0SWk0sEWy/eTAluC396YCKvQ93hX08OHlG
         aSWScuyyd3y2QyMIjRIPRU33yjMnjm+LBIM0+tiyJSiieYtKXhB9KfgMposHmfybmCis
         6QssU/odGd6wEA2nbMgIs/wNN+cHmevK+KS966B3uuIITEng4/TTEyVQRgTD+tVz0W9o
         tQ+hzvCFH8Iiim3oZK4A9v/qle9/mMUKC//21cJZ8DH2UnLljCMBW009Ki85JYrRm+qe
         FGzOpBjhk1U7wRiFL+cEV6mZmtg8K6YBkc2lQ3ut7F+FtbnJ210STWpsxAiVh0ntSVBi
         Nblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709168021; x=1709772821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1fAxVxcSGJDtvwC4OA6vg9SQpipa+6cd4wlsruGTgI=;
        b=wO0JI+tPEmmBeApof4BHpR+VqckeeBDjGXLJkMvDwMvNOVotkviFzHPVSzCWe0S3G2
         qA1V7i/NB4MqJbI/maCDEjnKSktmDigoxwWTYvk5Fk5yIEWIgeBzHFnd3YcjkDK7P0IF
         QkTl1ZaRt5OCtekTnE1D2ST+d6r7WOObN+zP8GH1tMfGOB/6wVcgZh7BCsyE+g185QsY
         kr/qk72rnQFLO0WNfgLMpyxcTx8RycxhgASeT5tGZkBNmKctrU696DLePf5Wn62wI2r0
         dXXh6eOvTSITa7nsWsmtBidRX+wtSWqm55gCoXGMR5AqdhW8+F7LLZRTMevhoQZN4E7G
         tjog==
X-Forwarded-Encrypted: i=1; AJvYcCWt6bBwosS10JakaqCBQ3ED3R0WHyeY3WcWFvM3V/Ovzg0K/kbh77v3PVm3w4DbF+HD+FMmMSTafV+XLbCHGRj0i39X
X-Gm-Message-State: AOJu0YxJJv1lSvMjS30J0DMnO2lOWnYoIUMlc5s+TF4pYRH3qibmOQZj
	FEPKAW8gTq9/3LFhlZjve1a0sihZ94JT2oMoW1F1wimijYQY+H/tVEdPXh77JvkAv4VUSfvT1kN
	Njg==
X-Google-Smtp-Source: AGHT+IEGDx9KNnQuVlFL1a+o7VDJ3fqoKiHSZ9fod3C0H0yXTT9TpbbqlundidtZGFnRpu3hKNN8Sj3g9iY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f44:b0:29a:c5e6:c5f1 with SMTP id
 pj4-20020a17090b4f4400b0029ac5e6c5f1mr15628pjb.6.1709168021232; Wed, 28 Feb
 2024 16:53:41 -0800 (PST)
Date: Wed, 28 Feb 2024 16:53:39 -0800
In-Reply-To: <Zd6Wo0hQu11L4aPc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com> <20240223004258.3104051-8-seanjc@google.com>
 <75d37243-e2a3-421a-b74f-ccbe307fef96@intel.com> <Zd6Wo0hQu11L4aPc@google.com>
Message-ID: <Zd_Vk1dlpLNjUzQD@google.com>
Subject: Re: [PATCH v9 07/11] KVM: selftests: Allow tagging protected memory
 in guest page tables
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Carlos Bilbao <carlos.bilbao@amd.com>, Peter Gonda <pgonda@google.com>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 27, 2024, Sean Christopherson wrote:
> On Wed, Feb 28, 2024, Xiaoyao Li wrote:
> > On 2/23/2024 8:42 AM, Sean Christopherson wrote:
> > ...
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> > > new file mode 100644
> > > index 000000000000..218f5cdf0d86
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
> > > @@ -0,0 +1,7 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > +#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> > > +#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
> > 
> > Since the file name is changed from kvm_host.h (in v7) to kvm_util_arch.h,
> > we need to update it as well.
> > 
> > Ditto for other archs
> 
> Ugh, nice catch.  I'll fixup and force push (likely tomorrow).

Here's the diff of my fixup:

diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
index 218f5cdf0d86..e43a57d99b56 100644
--- a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 struct kvm_vm_arch {};
 
-#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
index c8280d5659ce..e43a57d99b56 100644
--- a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 struct kvm_vm_arch {};
 
-#endif  // _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
index 4c4c1c1e4bf8..e43a57d99b56 100644
--- a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_S390_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 struct kvm_vm_arch {};
 
-#endif  // _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
index 205ed788aeb8..9f1725192aa2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _TOOLS_LINUX_ASM_X86_KVM_HOST_H
-#define _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#ifndef SELFTEST_KVM_UTIL_ARCH_H
+#define SELFTEST_KVM_UTIL_ARCH_H
 
 #include <stdbool.h>
 #include <stdint.h>
@@ -20,4 +20,4 @@ static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
 #define vm_arch_has_protected_memory(vm) \
        __vm_arch_has_protected_memory(&(vm)->arch)
 
-#endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#endif  // SELFTEST_KVM_UTIL_ARCH_H

