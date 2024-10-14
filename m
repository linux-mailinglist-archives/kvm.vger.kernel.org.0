Return-Path: <kvm+bounces-28824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9BB99DA1B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38B391F23043
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 23:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41971D9A78;
	Mon, 14 Oct 2024 23:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="nlk4zHO6"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFF11D9A57;
	Mon, 14 Oct 2024 23:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948347; cv=none; b=Mm/kHf2zx9QIKkMFO3Y+fB0W8mT/nhJXjmzdLb44UxyeHifcKEqifkBuvwvo6LR5sqd3c5a+cnGR/419NKUks58rLMQpBWZmX/5PcmIv1qZz61rd8bNNV3SQxgXLH3qFZfLYJcVyomgdZ2hTkG/X/wAW7sqx2Ajfb54UQ/OCM4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948347; c=relaxed/simple;
	bh=pjZGoUYp7vaqcVomFTe6266T8/V53nSDlyKTPd6BQ6w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AkqIv5o55IlqhqFOWa/+5i29kl3J5rqBAdlA1Wk4tqkvI93fZauahtEWfkTvxK4a0FGnctUDbNj79XIHikstIr/dvJ5imqL8CZIvJyOcRvyWhYUq439BxsffuaeU/4zaVSF+oBGKbMHoWw++fS7zCxSfqzSkiEc7FIXZuuWdjoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=nlk4zHO6; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1728946444;
	bh=pjZGoUYp7vaqcVomFTe6266T8/V53nSDlyKTPd6BQ6w=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=nlk4zHO69XQlxGYG7f56fXvNdQXCVpoJRNPulXofJbkYbKloOaPzIfpDbT+XJnQva
	 MW3n6KmlI8TuWXjlzmdfpzGAV9+3mA4LQ642uybQR/nHQ+fSc27UdNhvfa5vSOImul
	 gLWl9/mF7Ofjch3QHTpRFoI5mAcZq5BmH2e3rLfg=
Received: by gentwo.org (Postfix, from userid 1003)
	id F25F2409C3; Mon, 14 Oct 2024 15:54:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id EEB94401C9;
	Mon, 14 Oct 2024 15:54:03 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:54:03 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Message-ID: <1c363441-a2c9-98da-a974-a43b4352acd3@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Various versions of this patchset have been extensively tested at Ampere
with numerous benchmarks by our performance testing groups.

Please merge this. We will continue to contribute to this patchset.


