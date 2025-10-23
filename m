Return-Path: <kvm+bounces-60884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D99AC018AE
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 15:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A6674504AB7
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 13:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F2F315D2A;
	Thu, 23 Oct 2025 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="GAojAMkQ"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5E2C11C0;
	Thu, 23 Oct 2025 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761227486; cv=none; b=gYC/F+Bf1jLQc8X4JKX2cVgVe2zTqh/BJ66n/yO2uN8H1w/G8DSwJOX0Jzdlhv+BswTum0whma4TmIznRgk1xoyOFacs0E9QcN6DHYbetRkFEh9OT3UhRe8Glca19ms0HABEDT2sgIC6jmvro9XvasbPHJspyE1m1YIXI3XYCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761227486; c=relaxed/simple;
	bh=n38rpblOs+l0Uh+pRnN15UApR181ML0sIibuGLecbPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fTnVl9NduWTDLOcCO9fekNo4XjmBzsCv6k0ZInloHwaaHd/9ENBS/r/r3IFvqCrEOUyeYPwc2QjP0RHaz8NHRdCukb211HZVh/fmokWHi1UK8MCoGBrMhNIaourTY2gEsucoHWQycmIWjMxSM83N0Vr//fuQOXWhnU5NfrCXx3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=GAojAMkQ; arc=none smtp.client-ip=117.135.210.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=n3
	8rpblOs+l0Uh+pRnN15UApR181ML0sIibuGLecbPY=; b=GAojAMkQUT29pCF11y
	uJWTUHgw+03xw3YVk+6v1tAzeXK6Ppsg0nwLfhAOkAPiJo3FoomdFKDj7+5GKuMC
	1KuaAghb3JihmLffl/0I2TRPlnoVvqKo/0GnmdRwcgJ5gBKgL8Skvl/LEiQjXImW
	YulUfd4eCY2gTXyjRnB5EUAmA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgDnT0PvMfpoOIyWAQ--.32275S4;
	Thu, 23 Oct 2025 21:47:35 +0800 (CST)
From: Jinvas <jinvas@126.com>
To: jgg@nvidia.com
Cc: ajones@ventanamicro.com,
	alex.williamson@redhat.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	atish.patra@linux.dev,
	iommu@lists.linux.dev,
	joro@8bytes.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	robin.murphy@arm.com,
	tglx@linutronix.de,
	tjeznach@rivosinc.com,
	will@kernel.org,
	zong.li@sifive.com
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC access
Date: Thu, 23 Oct 2025 21:47:08 +0800
Message-Id: <20251023134708.1192-1-jinvas@126.com>
X-Mailer: git-send-email 2.28.0.windows.1
In-Reply-To: <20250922235651.GG1391379@nvidia.com>
References: <20250922235651.GG1391379@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-CM-TRANSID:PikvCgDnT0PvMfpoOIyWAQ--.32275S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw17Zry8JFy5Jw1xXw13Arb_yoWkJrc_Zr
	n5Ar42q34xA3Z2vrW8Grs8XrWUKa1UXr43t3y7W3yfA34jkr48JF1vg3Z0vw47Xrs7CrZI
	gFy3JFW3uw17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0Q18PUUUUU==
X-CM-SenderInfo: xmlq4tbv6rjloofrz/1tbi1x7vlmj6HzMJSwABsN

On Mon, 22 Sep 2025 20:56:51 -0300, Jason Gunthorpe wrote:=0D
> We no longer need to support 32 bit builds and we missed this while=0D
> cleaning up.=0D
> Right now the only way to deal with this would be to only use one of=0D
> the S1 or S2 and make that decision when the iommu driver starts. You=0D
> can return the right SW_MSI/HW_MSI based on which PAGING domain style=0D
> the driver is going to use.=0D
=0D
> I recommend if the S2 is available you make the driver always use the=0D
> S2 for everything and ignore the S1 except for explicit two stage=0D
> translation setup by a hypervisor. Thus always return HW_MSI.=0D
> If the iommu does not support S2 then always use S1 and always return=0D
> SW_MSI.=0D
=0D
I strongly agree with this suggestion,=0D
because on one hand, the confusing design of RISC-V =E2=80=94=0D
particularly the translation rules of the msix_table =E2=80=94=0D
leads to different translation behaviors in S1 and S2 modes;=0D
=0D
on the other hand,=0D
designing a proper caching mechanism for the msix_table=0D
in both S1 and S2 modes is quite challenging.=0D
=0D
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>=0D
=0D
Thanks for the patch!=0D
=0D
Best regards,=0D
jinvas=


