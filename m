Return-Path: <kvm+bounces-16666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 719E08BC702
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 279A51F23CCD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16481145323;
	Mon,  6 May 2024 05:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N6fvUmSQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2157A144D38
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973530; cv=none; b=d/4MYFu5EiAJGU+w+6PwyeOGDWT4eOYdKhfyKM44Bgbfg1TH+6pcdb7qu2bjdVvb+tHlX3UKwZI670BnnJIrizp5WBIy+AGVGjVmMw0LcrMKNBlvtwI6miVEPuArFgnUF5ADa5Rz6L/kTuzk0+dv3Azs/f+8eb6LzUMVIrNdmKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973530; c=relaxed/simple;
	bh=BVEc3GheAMrvPPEiSDpTNWaEswxhgD9hvN+mtoDq/PE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YIldMBDQ+E/3Ow6fAA/v308ms116PtPbd08i9b9jOwqILIWMH93A1xFH65dGu+Yo+9bxy/l8boxvNbi17Vez5eL/paZ5pdMYWf71fFNDO6hUEDiJPuk39XvJWK9FbJpq86rW3a1y45G/ToHUpt7JnLGpnSyxbeL1/gzLQw9SNOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N6fvUmSQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b38f8cac9dso2811502a91.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973528; x=1715578328; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=r0dMbpLuPkp27Z0NYeXAfwk+uuX6GzkvFCu4OKzkqfg=;
        b=N6fvUmSQJpIJ9NdwabWFmQ08m2n8dwgniGZuQCGQmXt377YDWpFBmO1VGsBKljv3KV
         xgUfBfNpY20u7vZ3eXUquxpTh6wwWnBUYjszn2mb5mydbMULMaFD/zDMZRkN8XNJh2vU
         TgpkSXgE6lyFA3ehjuW3p+x+earEG7+SFjNxR3Dfctwr/oQepr9rkiYe4nLtRI+jlJ2N
         EYVAPMJB4FaU7fSFC2sYOpEoUkvHkJ9eaexvcylENcL3LWYEUrOOAX0B5uXdIyFxf7gN
         0TwvvKsITy+c1TOixU8Dz2tfnuJz5oYJoUZmNOsRjtVMpNEMu3dzGa4o9TjwTWcqRTP1
         A39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973528; x=1715578328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0dMbpLuPkp27Z0NYeXAfwk+uuX6GzkvFCu4OKzkqfg=;
        b=QlAq8R1jpvnMUGTtKbWNqRQ+MT7gp49PIKsXiWjZgvf1//jEkAdmPLswyKzuzCfpV7
         WgEuF5mFne9SxGiwxEh6/iuI38WslZCJzzdPI5flr7ebpxZ9+O6YqdL4WdFjH5TVFPoB
         U6rV6nW7POfAzkn03BPV9+d2Eywlidmn0EeTqrODMcQgHvXhB2UwhtVe/UNAFSibO4Ue
         ikBCTD75FxoRzPvRtK//VRXxddVikbBs6BrFFmP+7MQJwP72n+8PLjgjujMIbRKl1Sex
         Y2pO88le7anzfRdfJRyEEdlOMxuNkB9l32GdMJ0ljs/exR/3p9RvEONqKqRUSay3eniu
         b4IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpy/AYRomZe+ZV0WhZx+aMT3PK1PAqip6bJ1tYEiUWjRsACyefopTi3ESKvJuDATChacPJ+1Fx/0c8/pAgliFROGOP
X-Gm-Message-State: AOJu0Yx5Q4s3xOQGQbdLVbRJ7buOadNAJquUC/3d9R6opHK1CnFKzC6/
	DooDH5aPKPZypctZiQ0dNIFFLa1VPuW6GbvZVACjeeOTg1TE8ijwwr2V49ygWd8/g3bN/tp4UQX
	SKpFPHw==
X-Google-Smtp-Source: AGHT+IHEVIsC3OzLcKPgw25unnky+n+wjQaLNtSetm/7/zKes1bE9kZoM4IWaLd7BdgQxrlqRoWjj60+LZyI
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:9f83:b0:2b2:7ca7:a217 with SMTP id
 o3-20020a17090a9f8300b002b27ca7a217mr53260pjp.4.1714973528312; Sun, 05 May
 2024 22:32:08 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:19 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-55-mizhang@google.com>
Subject: [PATCH v2 54/54] KVM: x86/pmu/svm: Wire up PMU filtering
 functionality for passthrough PMU
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

From: Manali Shukla <manali.shukla@amd.com>

With the Passthrough PMU enabled, the PERF_CTLx MSRs (event selectors) are
always intercepted and the event filter checking can be directly done
inside amd_pmu_set_msr().

Add a check to allow writing to event selector for GP counters if and only
if the event is allowed in filter.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/svm/pmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 9629a172aa1b..cb6d3bfdd588 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -166,6 +166,15 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
 			if (is_passthrough_pmu_enabled(vcpu)) {
+				if (!check_pmu_event_filter(pmc)) {
+					/*
+					 * When guest request an invalid event,
+					 * stop the counter by clearing the
+					 * event selector MSR.
+					 */
+					pmc->eventsel_hw = 0;
+					return 0;
+				}
 				data &= ~AMD64_EVENTSEL_HOSTONLY;
 				pmc->eventsel_hw = data | AMD64_EVENTSEL_GUESTONLY;
 			} else {
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


