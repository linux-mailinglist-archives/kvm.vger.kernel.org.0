Return-Path: <kvm+bounces-27710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2428998AF77
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 23:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C94D5282B16
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 21:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83380187878;
	Mon, 30 Sep 2024 21:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iK4ctBoL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7256B17798F
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727733413; cv=none; b=ps+Mo+oPZuMLFmiz8kl/hhm1tm0TNu86CXszYIMbTcMD4CE8ljsLLjp9+NR5pDzRcGX3AFG8GRhzV+uOevHIBgPGS26dCBygz6HHmNtY6xFdHvomESn7Q1E88z3TRe8NP+7mojiYf8QMRrWrapv/q2+9lpbZYsyjVRvRJjw+W1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727733413; c=relaxed/simple;
	bh=EI35CoEM1AcSciWaRt5Y7P85pwkoV/1G1OSkpZxfbPg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=YMYMQgxg3flmyzZ+ZGmnOTjTFiCxe1R2fEothVfz28wTkLUl4JSeu7YrYdbz6Qe74Mbu6qs7cmVYknSmNh8TDuKnzDkDtvr4psh8pJr582qHfr/WXXYbiGu1ToZCAGhz1+Z0lIj57MW7HHeyZ3yq/xwH4bnwrbdg/YOAbcTmFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iK4ctBoL; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20b485e3314so44369865ad.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 14:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727733412; x=1728338212; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PntPBodbq4krAqAL/kXN8N5SHx+RiWW9dX81Z4mrKcI=;
        b=iK4ctBoLbfEykS27Sxro0hN4zq6Fsa8D/e4qyRX7VhXIyF1n7JXLwfPLtAr+02SsQF
         asndJZN8oS5fIEiuyL4lY15/Qe8MXx0TKmMJ018v9DK2ltmm900NLN7gCfBtwVdOmFrC
         ujE9k/eLQpDmP097pL4P31lLCQ/DksXqVjD7cNMQQ92Vwi8Zk66qHCaiv8fxl45/lxry
         pBreIysoDq4cgfoPZuW7cUeTTOA/i6sy6Zzgcw28bsgQjFA4kTdp8fnHG72jkG24coZv
         sTJnVOcZ0lUMvMqulPFuiFdzszNgB7RjudMC3dLV3w7Q1ISsB7R3+86/cFTIqjqwapMe
         nJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727733412; x=1728338212;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PntPBodbq4krAqAL/kXN8N5SHx+RiWW9dX81Z4mrKcI=;
        b=fNUgHHdxb+/3MonNTBPHQ4Zk3yJtijqNH5LPy5eeNXZ/xn3rg0xOHNKpLsdtXL4mpY
         21cnjFMuCsf5E7dh+ZF083w1THTVEuA43v52LmoAL4loK+NOObFWe+qmC1BPVdyRzKlW
         PwfG4mF35TxG8TfKIBeD66s0CzmjveCQPqmsFNL7T1BhMBNE3uFuzYX545Ed1FC8HGav
         gubbmXgesU/CWnD/KBlywOqWydr2j9j+RjvGvuUg/aA01u/C5rPNgJ5G3e0ZslekvCrP
         D6mGfva2NdWsgXcLSyy4K+n4JYkHIbdO3DAgZhQFPM5Kfwr4qc3LruaQBaaCV8U192G8
         YqAg==
X-Forwarded-Encrypted: i=1; AJvYcCVINzDfi0oPhBiNScauoJYgI2pOdOslRcZQNme6rj2y8x+GS82XETQcViwPu48wPbWcqSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUp+vlLNh5x/Y94bbj9VN4l3aBWRN3RtHse3vOaoV2AstwYPTf
	R1G+cCjMmFZ5w3E6f8d7wDp2IhsjvhOBqpyvrtRjfKNHkXpOx/rAKPyq/g7kJPJQ/1IumlC2/ZR
	1Aw==
X-Google-Smtp-Source: AGHT+IFa/3NUudFCuE72HcCwi+hM+UVm+5oAl6XGWfqHgohNP2i/0xjhJQmHwp45qjEiLZEOk9HWi9na7w8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f691:b0:20b:aed1:bf77 with SMTP id
 d9443c01a7336-20baed1c097mr62225ad.7.1727733411419; Mon, 30 Sep 2024 14:56:51
 -0700 (PDT)
Date: Mon, 30 Sep 2024 14:56:49 -0700
In-Reply-To: <20240911204158.2034295-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com> <20240911204158.2034295-4-seanjc@google.com>
Message-ID: <ZvseoZLzmaS4MEbc@google.com>
Subject: Re: [PATCH v2 03/13] KVM: selftests: Fudge around an apparent gcc bug
 in arm64's PMU test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 11, 2024, Sean Christopherson wrote:
> Use u64_replace_bits() instead of u64p_replace_bits() to set PMCR.N in
> arm64's vPMU counter access test to fudge around what appears to be a gcc
> bug.  With the recent change to have vcpu_get_reg() return a value in lieu
> of an out-param, some versions of gcc completely ignore the operation
> performed by set_pmcr_n(), i.e. ignore the output param.

Filed a gcc bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=116912

I'll report back if anything interesting comes out of that bug.

