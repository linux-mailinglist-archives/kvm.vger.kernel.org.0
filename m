Return-Path: <kvm+bounces-47800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D638AC52FA
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8699D3BA364
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 16:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DABBB27F727;
	Tue, 27 May 2025 16:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="PwqwmLT7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D84255E26;
	Tue, 27 May 2025 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362942; cv=none; b=hLE1ooDFF3XLgbyREkb/vTpu+N0IEJQy4+cfhoTn59vHnUonTQ+6TCvZc4UH+jS7vI7ACIs8r2UV0hVTh+A+tiXPPoCIHEmkkNj503OTqM/nsfIpvGPW+Aqd4ycgs4zDmD5QVgOhoghEHyHZA5YfBkw2hnXzQOPoTRypD0A+J3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362942; c=relaxed/simple;
	bh=DBfQNXHYjZTnioBGVrpuMQOWxk0gKSRi00zY0Oi1SmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4+kIP5sYRD+ez6gW1EMO/2XYyD+5ZPlZnkjTG6cbkzrUrAZwSWYePN5su1DlW4HB17qCtZGLBt803Es0LdXZwahmLltaLiiOqml1q/WH99UY9wv4yBynSut39N0c5L44+MGMAuztV5LXz/Os/FUkbPZATTXTTEq2aj0ldymBS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=PwqwmLT7; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C8E2740E01B4;
	Tue, 27 May 2025 16:22:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id V3CwDxIHnanD; Tue, 27 May 2025 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1748362927; bh=MXaCOMaubsaIUCduYoHD2Xh1n5Fq4KuVfRn1au7Nm64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PwqwmLT72BexM8Br80mZZtJzUUxVMINZ4k2x2w6JU6LfvKayGBdNv8os1nQFpUW6i
	 9s+DYsKMm2J8lOYT2omFRKIxyxL77MD60gLh3KPVh2a/ZXCFnliVrCyKXiJnkYgAPX
	 WxB5zLysi8ysVEdV5PzvNAgSLLezU0QziKjMt5DIxBNRGEk+fyigUmKBh8n/Jxli1p
	 UW9sHMFCp7e3eXi5IZL+6azNmBbyCWN+9Qn8239UKk1NtLA5BHRp6+1HgjeYoatblI
	 5i7jtf7D9ze89xlG1TxcsXHrv2CLIQTgCFL9PiOs1Ha7SDozlVMm/0tbmRXLL6GeR4
	 l5tyHGzWPtIjw/PXeMdfteOCFSBR06s9TQJb62YEekim7NoYY/HzJfA7aDlzJIxZ2z
	 w6mDrg1IOr7nQO//hJyVbVV0MzuNRQ9JtltL+/22NXmLEipwV7fEznUc5v7q8GZqmr
	 FqEHJvfYi/sn0ZRbtQu5RE8+P2Mgwyg6fJGKGVqtRoAaFD+cP6mmF3iD0rBOrdR5Nh
	 e9IpXrBv4VVe+raTOvbEZ4X+V6bGt4kB0l0v8ml4sVu1F22gGeTVBa4gTo462UXgkP
	 edgA8TH/+11YGuNtRBVZbSEVjZhq0tVCbCikGloJWnkdY8l+fAqvixWKevr/GNe5w9
	 oZtxAPHu0B1NuHSB3ydTbFZs=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0250940E01AD;
	Tue, 27 May 2025 16:21:57 +0000 (UTC)
Date: Tue, 27 May 2025 18:21:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sev/vc: fix efi runtime instruction emulation
Message-ID: <20250527162151.GAaDXmn8O3f_HYgRju@fat_crate.local>
References: <20250527144546.42981-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250527144546.42981-1-kraxel@redhat.com>

On Tue, May 27, 2025 at 04:45:44PM +0200, Gerd Hoffmann wrote:
> In case efi_mm is active go use the userspace instruction decoder which
> supports fetching instructions from active_mm.  This is needed to make
> instruction emulation work for EFI runtime code, so it can use cpuid
> and rdmsr.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/coco/sev/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Can you pls explain what the use cases for this and your next patch are?

We'd like to add them to our test pile.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

