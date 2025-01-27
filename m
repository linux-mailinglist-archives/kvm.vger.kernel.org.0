Return-Path: <kvm+bounces-36689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E30DAA1F6BD
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D23C16564F
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE1A198E91;
	Mon, 27 Jan 2025 21:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pDOqq240"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4707194A67
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012339; cv=none; b=GYgF5M+3Rfy6JtqecoaxvaVK+G3LtyGXy/M6GUE7uZyAUeCS20wBC+SWrALuWDHwqlbku5i2bMUJL6S5oGM+shfB+a+CU9l4zmmJsP/zeNAencaNPiKETKRW7xlODgkYIk/6jLzOl6BVBAv/14ErjxVKDRXoSaYOsbAaUhHRVUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012339; c=relaxed/simple;
	bh=QIUlCdDDgNKC8e57Y3+feDkX5uLyeyfTJ0A0n34JkIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K1LxB2nDJO6N/AhT20O5BFW4r63P/iZ2hczHvjvPEPzHaGQVNQBnkobFnC3JQ+twd2tUNNEcFHMfzgBCgMQtcagvf5qYxfsgPSq4LwXn4KSuvAXJKaBn0dLlbeDdgr5iyoQNRVR0k+hKmjr3VTgdSB7OqGkmsrlBvBTL5dQhc/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pDOqq240; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166e907b5eso87265695ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 13:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738012336; x=1738617136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6hZefyXL2l96pWmeGJw77FS+9rwDaTak9GYI9pCtzA=;
        b=pDOqq240FmwonOMwNSeDQryDJWs1PZN5mD2ExqzAAtzpE4kTj8NPyComxyDeV+Y24j
         8maE47AQBLv5/gh8a+147Aeqx5MTkeNgCChNtRmq4txrg4Hlda0fE7smZTBgXNJkGQ4O
         ZZ7+Qv0RcYDjMDowTBRa427T9jyxItwVbKxGuMAieTG0gitNvJZBrdnXC1gDMB+j+gsU
         h0yQ/bepPdx9kTrs1B2qP8Adsm3mOX9LDGblsMbvO77UouhQqtdC/E/542pnLZA58hZM
         ymXbRHEtc/KZ7K1rmXeUuWnE0MaoSE5Gx+zzb4c0RoYAYDQNoIbCelnRcIb8GzZmiwUk
         64fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738012336; x=1738617136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6hZefyXL2l96pWmeGJw77FS+9rwDaTak9GYI9pCtzA=;
        b=moKmEz/RfIzEkwNUi3JQHWleFjTWz8+XNX8vtePNS74IiPSGGgwfreza85fSYuV06E
         B4UBxyPqFtNam95OZo9hbzzCyRpYX+WQnfCNawicb72ze6GBFBb6dfWkanAuhxlb+Kma
         HAMueUTbn+XZHRRJZPgyY1D6/sXgvNbi/9toOu0CMpIUyRawiRMQ6N+DGz30e5s72/G3
         CKZL+W5LppQK3YiUbqdAX2y8tCw2kgqPyz5u0jSwkfReuwtMntmxd9cqWwome+vZZabv
         0vDfljOS921SXh6hOuR9/PPlSDex4o/KuxconZ6vTPdvwEd8uu8NHnhcIIuQr7QiVeqY
         XwJw==
X-Forwarded-Encrypted: i=1; AJvYcCXDDa/1eLj3YA4nJRO815JH4yXlvtr0+p31D5rXRcGOMGH22y62DmajFhwxjpIudbjueJM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGhx6/P7TgaqJ6JUjQ6dYtSZxTJXXJGrBBvxiewxLXCmIQVLQp
	25UExdP23GJt5vK+2IUNL47l+3VfeA7+aZRjhhDjYAt7DgAv7p2AYUbobmKqueSlEE0R4dzb9xs
	UEw==
X-Google-Smtp-Source: AGHT+IEwgayOURYSvjY7e6XLYoI71UjcKramt48qbeELOlKyudPYpVmcvakyD5Op74xYsySjMiHHABxL/+s=
X-Received: from pfbcb5.prod.google.com ([2002:a05:6a00:4305:b0:725:936f:c305])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8d1:b0:725:f153:22d5
 with SMTP id d2e1a72fcca58-72dafb9e674mr61995080b3a.18.1738012335920; Mon, 27
 Jan 2025 13:12:15 -0800 (PST)
Date: Mon, 27 Jan 2025 13:12:14 -0800
In-Reply-To: <e23a94f0-c35f-4d50-b348-4cd64b5ebb67@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1737505394.git.ashish.kalra@amd.com> <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com> <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
 <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com> <Z5QyybbSk4NeroyZ@google.com> <e23a94f0-c35f-4d50-b348-4cd64b5ebb67@amd.com>
Message-ID: <Z5f2rnMyBAjK88dP@google.com>
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org, 
	robin.murphy@arm.com, michael.roth@amd.com, dionnaglaze@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 27, 2025, Ashish Kalra wrote:
> Hello Sean,
> 
> On 1/24/2025 6:39 PM, Sean Christopherson wrote:
> > On Fri, Jan 24, 2025, Ashish Kalra wrote:
> >> With discussions with the AMD IOMMU team, here is the AMD IOMMU
> >> initialization flow:
> > 
> > ..
> > 
> >> IOMMU SNP check
> >>   Core IOMMU subsystem init is done during iommu_subsys_init() via
> >>   subsys_initcall.  This function does change the DMA mode depending on
> >>   kernel config.  Hence, SNP check should be done after subsys_initcall.
> >>   That's why its done currently during IOMMU PCI init (IOMMU_PCI_INIT stage).
> >>   And for that reason snp_rmptable_init() is currently invoked via
> >>   device_initcall().
> >>  
> >> The summary is that we cannot move snp_rmptable_init() to subsys_initcall as
> >> core IOMMU subsystem gets initialized via subsys_initcall.
> > 
> > Just explicitly invoke RMP initialization during IOMMU SNP setup.  Pretending
> > there's no connection when snp_rmptable_init() checks amd_iommu_snp_en and has
> > a comment saying it needs to come after IOMMU SNP setup is ridiculous.
> > 
> 
> Thanks for the suggestion and the patch, i have tested it works for all cases
> and scenarios. I will post the next version of the patch-set based on this
> patch.

One thing I didn't account for: if IOMMU initialization fails and iommu_snp_enable()
is never reached, CC_ATTR_HOST_SEV_SNP will be left set.

I don't see any great options.  Something like the below might work?  And maybe
keep a device_initcall() in arch/x86/virt/svm/sev.c that sanity checks that SNP
really is fully enabled?  Dunno, hopefully someone has a better idea.

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 0e0a531042ac..6d62ee8e0055 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3295,6 +3295,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
                ret = state_next();
        }
 
+       if (ret && !amd_iommu_snp_en)
+               cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+
        return ret;
 }

