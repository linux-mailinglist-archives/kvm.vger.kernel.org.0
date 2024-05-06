Return-Path: <kvm+bounces-16617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94DD68BC6CC
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9700CB2120F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384CC4F1FE;
	Mon,  6 May 2024 05:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sdOeWRuL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3721E4DA15
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973438; cv=none; b=MD92fIfzg54uFEGp5pt4GJamBl3mHaUJWy7SDWhklvH41Dp0SzYePZZUYMGLBSQArAGSGx41L4VkWjDVqZqT8oFE7CpkgmK5ZegjNkbm9cz7aIG5milQS3z0wj+NK11C3QaK+wBUamgRnMaTT7uyNs+Z1pErRRFCmdawp6T3fCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973438; c=relaxed/simple;
	bh=p1/mWwBDHge0aaoxvafwfz7+X3yWihUIGs8MvmL7VfU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MvgQXgXcfyPXgnQJF9GM6g9y2sOCSUnsVWr4AKMugTcEnqDlki9xTK46AHRiF/CTUt8MdLtFjDDnU2O39G6YWAo8sW8rK+Wb8es7DVNzgaKvBXfIjPD8r/endBgmwDDuJ5sB/GnfV15y2AVaiT1lzKut17BgZX7fbKrJ2s+X9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sdOeWRuL; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ee089eedb7so2129488b3a.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973436; x=1715578236; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ro4DfA6A8QKxJZDclKEMPi7BoRrzJeCZo4M/Bj5PgnU=;
        b=sdOeWRuLfDnmIS1M1dwIa42YzGzT9O5+XfMdgM0ceRS3uHvz4YlCo+BicBG8a8AdnE
         mmKNwVFHUcLbBSp6ihzqGMXBIi6onWWy9c1q0fCNv/W+Adujmgs2rP5Ndr/O4wb6xXNo
         WN9fF/8r1+ipRRkLZkWJD+/brkgn6I0nZ3so+g9Q6IMiPWsfb2r9A8qbQP6Gl8a91/uX
         ExNFZ0zIuj4kLstqX/AKtuLh1NbrSZaroofiSHi/QT7BsM+2Hl0W0krYRB92kJAPF6kJ
         XFFctc09z0LGfrpt7jzLTHO8yuuKXHsTYfDdlPj6IBG2IW/mtMsx2mH4/As2MplCFKjW
         lZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973436; x=1715578236;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ro4DfA6A8QKxJZDclKEMPi7BoRrzJeCZo4M/Bj5PgnU=;
        b=NO4WJmhg9VqNQCdaspG93CftcJACBIdlClpFsw1YIGbFSDNVvajqbvDakw3yIgpbPs
         yvqMrelCUUQllEw3ZbQDtGiOeFRpv2hPQ7T0MPEU/vBh3EoXUB8OWF4e0P7OOp0UqAIw
         O3EXWezk/ur4FM36CXVphOdcKneVQkelP8jG2O3QN2Vyhw9Exqhf8iBlMSjSw+Vys7fu
         yYB746/vyaqh34FFWWyI/nq8cLFiAkz0tYAxj7zMjtZrcLrndMaSZuhRHvTgKWTf9oM5
         l4rUHol/VOdO8QceDkBuls2LlzYNCBjxcrIvNGeTBxKbT7b4XpC4MX5MPRfMnK/Utmyr
         1s2A==
X-Forwarded-Encrypted: i=1; AJvYcCVwGAnnXYV5CqWEWnJbW4XOf2DwDYD0q2MGJjbqH4956LTS9Vr5/A8xCgiABkWwvMDCOPYQpQD7dVF2C3z9EffpGenr
X-Gm-Message-State: AOJu0YwzFh3A6tRFPdhl+HFnTqG9WGtx4RWsy0Zr39rszdiSIxfRRp5/
	xgfN/c4q2+oyCGA9Ql0D7wqCQXfaG3BDZIW5V1UOIGCR3Mp+be1VRrAjFn9SUXH1PKyAVQ2xZyp
	qzjbffA==
X-Google-Smtp-Source: AGHT+IEflzQyVA/s91GJeohwmAyYBIOJ+aUtHa/6hbR3WMlALelEVrdGk/rk5z41cq9v0+BuYE1IIr+nlit/
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:2e84:b0:6ea:c43c:a666 with SMTP id
 fd4-20020a056a002e8400b006eac43ca666mr434167pfb.6.1714973436393; Sun, 05 May
 2024 22:30:36 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:30 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-6-mizhang@google.com>
Subject: [PATCH v2 05/54] x86/msr: Introduce MSR_CORE_PERF_GLOBAL_STATUS_SET
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Add additional PMU MSRs MSR_CORE_PERF_GLOBAL_STATUS_SET to allow
passthrough PMU operation on the read-only MSR IA32_PERF_GLOBAL_STATUS.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ed9e3e8a57d6..a1281511807c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1107,6 +1107,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


