Return-Path: <kvm+bounces-16078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA34A8B4048
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 21:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBF7D1C20C1A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725582032A;
	Fri, 26 Apr 2024 19:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mXycdzs5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E318C19
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 19:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714160804; cv=none; b=cmJW9nT750neCcApCF53G/o4IVM25s+xL3l4ScFTSAZtWINg2c9DveleEiFWaxFzpfyD7Dxfw0CYJ1vA+xk74GtW4+HIVL5Hz5BfvDHDdpnoDb5bORk63dEik9nWMA997H2eZxV6KNShQrOY4ZUT85Fj4I2MD/y1vqe2739ZYC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714160804; c=relaxed/simple;
	bh=9I8HrINcXcCO7t7LJcar7hS2Q+p9H5CASNC/aDQUKMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GAgFtOSDWS2n4fpsnhsY4RRtaSOeyaZc9bHWKRx5oLsOgm1QnuQ/lEUj+S7mGb1dBEvP9DhEzNUBP3r1qLEthk3zhEILi0YEKbkdvIVA12cfKGy+WXULvlWTTY88+7JKdfYCbbHNBYB2EnfFQkMjhxO3CF8zEAKhE8KqcyyUiZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mXycdzs5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1e63ff880f5so29601475ad.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 12:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714160803; x=1714765603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UncIq/RGO14yVQciI7tDs0Z5rk8USO8ElIwfA/pf054=;
        b=mXycdzs52JZgKvK+1qRtbnRqM2p66EpEVGfbbWFerUXl6+llSsBx8UEtkeKELu7T+l
         xOBtnZTWM7ZDfA64snsnwOW87xaU0QqtNCm1A+tqfzN0IMiLTe9nA3cCxFiXRqIGqwIN
         2nq2A+e6nopbko8k9IrwsJk0iFxD64+upTdxa7hFmFzHLZDrwkYGxRUfnGBDs06ysHUZ
         aueUfpwATJU2tm4CkgZMF3viFj/VWPw+80r45iuDtVYRfbJs6XiqtukXyTtj7R/rz9ef
         638PdFyORnBlU70EK3rrggpXVNDSW0UuyCq+hQuXrwf+50790zPS99UBKzSzLwMgSfFP
         FiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714160803; x=1714765603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UncIq/RGO14yVQciI7tDs0Z5rk8USO8ElIwfA/pf054=;
        b=gqVnSM4Vd714zkKfHMwjAtAALyDLijsxNfWkD71nnH/62sC3jnOTg+79BwWxx7HesJ
         T0oCDFVed9Ba20WlSO1Iv8CihneVDIeukRntFMeC4XDhpMmpQMre6OsC2skIO5riCL41
         TBf2/T5BkT2X19DoXqNMvT+uW8pUF6bGVRLS3y7P2aqPHlv+EG2u8nTJcL1dOEBRuZNn
         zvQypIJOMaIiRCBk7B2Ysz6TBqglL0cEjKMYANYawCAEzxDMKW8C060G43xdf4iVMrmB
         In7mx2WAEsbhoxu3ltMUbfBvMxNVnR0V3pufQA6+3J2dtU6wnqwfYhiTPTK4osbdEgHM
         Ge1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV2f+u1mKnENNrtXhtP/8O3NAnPgpPW45Ti7oxfabTbkhh/lECjG7OESNqKHqDQvANQg+mHsPO1IftIFOCLqERSkoPX
X-Gm-Message-State: AOJu0Yxn7GuE/Dsl7y038U3WkdWjh3q03gbSaPVOUD2qPiKvb8o7YmOi
	k0QTBa2UCD6eVZZTD+5SScAKtccH6x8ZI7jTDNDsqVRbtxjcntN4bN7g51Gm8HvYnJBIH+YOUPe
	D3g==
X-Google-Smtp-Source: AGHT+IGaUfhZhK/DdQDcWa43ivFUYwQoU9AvuYZ1w4SqevbuUQY8dRRZ0emewUCx336TqglcAcxA8N5Zh30=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d488:b0:1e3:ff3a:7a07 with SMTP id
 c8-20020a170902d48800b001e3ff3a7a07mr294264plg.6.1714160802676; Fri, 26 Apr
 2024 12:46:42 -0700 (PDT)
Date: Fri, 26 Apr 2024 12:46:41 -0700
In-Reply-To: <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com> <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com> <ZirPGnSDUzD-iWwc@google.com>
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com> <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com> <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
 <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com>
Message-ID: <ZiwEoZDIg8l7-uid@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: Kan Liang <kan.liang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	maobibo <maobibo@loongson.cn>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Kan Liang wrote:
> > Optimization 4
> > allows the host side to immediately profiling this part instead of
> > waiting for vcpu to reach to PMU context switch locations. Doing so
> > will generate more accurate results.
> 
> If so, I think the 4 is a must to have. Otherwise, it wouldn't honer the
> definition of the exclude_guest. Without 4, it brings some random blind
> spots, right?

+1, I view it as a hard requirement.  It's not an optimization, it's about
accuracy and functional correctness.

What _is_ an optimization is keeping guest state loaded while KVM is in its
run loop, i.e. initial mediated/passthrough PMU support could land upstream with
unconditional switches at entry/exit.  The performance of KVM would likely be
unacceptable for any production use cases, but that would give us motivation to
finish the job, and it doesn't result in random, hard to diagnose issues for
userspace.
 
> > Do we want to preempt that? I think it depends. For regular cloud
> > usage, we don't. But for any other usages where we want to prioritize
> > KVM/VMM profiling over guest vPMU, it is useful.
> > 
> > My current opinion is that optimization 4 is something nice to have.
> > But we should allow people to turn it off just like we could choose to
> > disable preempt kernel.
> 
> The exclude_guest means everything but the guest. I don't see a reason
> why people want to turn it off and get some random blind spots.

