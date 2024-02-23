Return-Path: <kvm+bounces-9556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 882498618D9
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FD19B2310C
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794A012BE98;
	Fri, 23 Feb 2024 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2j2ss7E"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914972E3EB;
	Fri, 23 Feb 2024 17:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708051; cv=none; b=lt05ypba2S6MV7mARYEDE3qHrCa03j23Z6ejakNdV0kVw+K8/keot2G/59p1iG2/GoWBhNQnpXqCraAzsjRYYMBUg5hQRERf4uRpZhx7M010mQ5oambGXJW/6vb+9D+pZOmTFNcsqG0De/LClnQHDLNuWk+IeI1kHU1tS7dQzp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708051; c=relaxed/simple;
	bh=6O1eMZbVgw3dOMVLlXiV+gwVN4SvOehqC98EVTWNLHE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oRV3hKVC3kZFVOE1+AF1UHhEt0gYADn5CU2PXQGMTr4YAd6eP8QkS0qtjqfSElP30ohvyH28hx3k0ybDn+Dw8Y90/aSBdglcYaBHxcXDFQHEK29XCSoAExqzYPAAdE82ThjTexL2X7xpD/2M4L/WBC3P011RzFhJtPTkVLKNggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2j2ss7E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6048DC433F1;
	Fri, 23 Feb 2024 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708708051;
	bh=6O1eMZbVgw3dOMVLlXiV+gwVN4SvOehqC98EVTWNLHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r2j2ss7EHgRl7YB5/iFJFuOP9o7G4SSMGFqDDXddcYEjtHlmJISDa2qC0/nQxdDg1
	 JvV02hbCtKtCAeqULd+0UEucfVmCQl1Q+sbk45UPFigsa627OrroqaIzeBJTKs946W
	 /WTNF+NAOIaVuj4kVBvPlE9OFFndl4dG7gX9nTlC1Y5Cf2/+sVsJYE0t1/s74O0rnl
	 E3UhoGhdeGBMumK1ihaQokJqj60KNqPbHiBIulXaKoqV+XB3fYLQhRhe2L9SxSQSuC
	 Ngrmb5jP1co6zWwFwRagrp6MBPj+8QOXw1gge80BGbX/5Jm+4bQ5590FCKw4KM9JU+
	 fng3SLZ+mLnYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rdZ1E-006AIj-Tv;
	Fri, 23 Feb 2024 17:07:29 +0000
Date: Fri, 23 Feb 2024 17:07:28 +0000
Message-ID: <86il2f2jov.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>,
	<oliver.upton@linux.dev>,
	<james.morse@arm.com>,
	<suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>,
	<reinette.chatre@intel.com>,
	<surenb@google.com>,
	<stefanha@redhat.com>,
	<brauner@kernel.org>,
	<catalin.marinas@arm.com>,
	<will@kernel.org>,
	<mark.rutland@arm.com>,
	<alex.williamson@redhat.com>,
	<kevin.tian@intel.com>,
	<yi.l.liu@intel.com>,
	<ardb@kernel.org>,
	<akpm@linux-foundation.org>,
	<andreyknvl@gmail.com>,
	<wangjinchao@xfusion.com>,
	<gshan@redhat.com>,
	<shahuang@redhat.com>,
	<ricarkol@google.com>,
	<linux-mm@kvack.org>,
	<lpieralisi@kernel.org>,
	<rananta@google.com>,
	<ryan.roberts@arm.com>,
	<david@redhat.com>,
	<linus.walleij@linaro.org>,
	<bhe@redhat.com>,
	<aniketa@nvidia.com>,
	<cjia@nvidia.com>,
	<kwankhede@nvidia.com>,
	<targupta@nvidia.com>,
	<vsethi@nvidia.com>,
	<acurrid@nvidia.com>,
	<apopple@nvidia.com>,
	<jhubbard@nvidia.com>,
	<danw@nvidia.com>,
	<kvmarm@lists.linux.dev>,
	<mochs@nvidia.com>,
	<zhiw@nvidia.com>,
	<kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 3/4] kvm: arm64: set io memory s2 pte as normalnc for vfio pci device
In-Reply-To: <20240220072926.6466-4-ankita@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
	<20240220072926.6466-4-ankita@nvidia.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: ankita@nvidia.com, jgg@nvidia.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com, brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, alex.williamson@redhat.com, kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org, andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com, shahuang@redhat.com, ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com, ryan.roberts@arm.com, david@redhat.com, linus.walleij@linaro.org, bhe@redhat.com, aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 20 Feb 2024 07:29:25 +0000,
<ankita@nvidia.com> wrote:
> 
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> To provide VM with the ability to get device IO memory with NormalNC
> property, map device MMIO in KVM for ARM64 at stage2 as NormalNC.
> Having NormalNC S2 default puts guests in control (based on [1],
> "Combining stage 1 and stage 2 memory type attributes") of device
> MMIO regions memory mappings. The rules are summarized below:
> ([(S1) - stage1], [(S2) - stage 2])
> 
> S1           |  S2           | Result
> NORMAL-WB    |  NORMAL-NC    | NORMAL-NC
> NORMAL-WT    |  NORMAL-NC    | NORMAL-NC
> NORMAL-NC    |  NORMAL-NC    | NORMAL-NC
> DEVICE<attr> |  NORMAL-NC    | DEVICE<attr>
> 
> Still this cannot be generalized to non PCI devices such as GICv2.
> There is insufficient information and uncertainity in the behavior
> of non PCI driver. A driver must indicate support using the
> new flag VM_ALLOW_ANY_UNCACHED.
> 
> Adapt KVM to make use of the flag VM_ALLOW_ANY_UNCACHED as indicator to
> activate the S2 setting to NormalNc.
> 
> [1] section D8.5.5 of DDI0487J_a_a-profile_architecture_reference_manual.pdf
> 
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Since people have asked for various commit message updates, I'll add
my own: for the KVM/arm64 tree, the convention for the subject line is
"KVM: arm64: Something starting with a capital".

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

