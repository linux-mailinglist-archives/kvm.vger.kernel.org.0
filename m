Return-Path: <kvm+bounces-25335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7DDC963EB5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 10:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2FB51C243C5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 08:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF7418C90D;
	Thu, 29 Aug 2024 08:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="cah3Mpc5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51450189912;
	Thu, 29 Aug 2024 08:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724920518; cv=none; b=cFk8bM3MDnMU6lnfPzhh4UDVeN1iukY8wCsPmQNQ7DjHt+fUxkiqWJ1KaFjwpcncUSgHlECx+1OlUUlGfsy0mYX0qN67xB+lwLjhOik8xOBIh4qYrosl7Wbtwwi+Hsj0QVYiXAli+HP8Y9qSHPrbjJe139tYN7CRbiIYgHgBLGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724920518; c=relaxed/simple;
	bh=6iZ8iIGBRLFC4519kTdXtS0rAGmtcKBdcw8S6IFTyEI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=N+ZlqV4xezEliP6zfKTCqhKerU7hvP1fnHgM/EmIHDmzmccP+nH5BkO9cKmbJKtg8NeDB797hu9K89JhLMsvcude07wVj/r+1P6jzIjq1FT1V29ThgL99e+qzFUZX1H/TDfMqCAP9Xx/pGEDeBF46iAj53SfHHDPhW6F1bcaDA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=cah3Mpc5; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 07C2540E01C5;
	Thu, 29 Aug 2024 08:35:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id g_I6YJdYLlmn; Thu, 29 Aug 2024 08:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1724920509; bh=CPJhcm4WSc5DpBeeH7qgshS/p1SRpirWBGGJlu0SQk4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=cah3Mpc5nSYpGQMyejkNsp95hkl/X+s6B5xBrgHTfPCNNQHp02ZSXOUI3HjjX9DhW
	 vEjexwCY727LS3YMNoK0hQUMyonR7aCZ6D039tIZEc0OGBucSwndlYqbguDZ5gi4V1
	 qhZLMvXyyeZMQu6daP0guN8Y1oKm6wakJjFYxPGOxJLNxtRkK+Z+Ex/igPHquHI7Wj
	 Ddds+DrEZRos0kyn+w1xjqjEOWO/CswZhHip6siwbkvvkLWV5HCiPMzsqyHYzuUJoT
	 L5qAqTd7VSvRgD2Z1lZm5t9usfqnAZaWvE1uVf4Va1N3vBI82FN068qKydf+GuJidM
	 XA1OKDiXNXqX6CU65lFshs7FVcU81qS2symUlsmgah/jJijv/Tf0+WDNXM80jUmtfG
	 Nlfq/D7c6dvsjCzZq6aRE4X0n+UsndkhJQiIm0XIRUG9GGVUW/RgrPl5RQ3h7s4yoL
	 3HIXB4MRZm3S3Yac4tzt6ibF8iW4XM+Ll3t856HohJIhipSd1Bm0aYJr6hm2CmI2vW
	 WVddYO2iPSadIGgueMUoLwBneHPNBouJQPv+xtq6+hv0CCXnB9obYO8ytEQsrQei75
	 OGA2vtzuB2ZuJwSvSswy6ChUfr7Bf8mfj7ZWYX5nRoa/YrU7DDUXMabC788QCRKSqU
	 s0hrlESh+O3tj6sHBKJoGii4=
Received: from [127.0.0.1] (business-24-134-159-81.pool2.vodafone-ip.de [24.134.159.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 51BEC40E016A;
	Thu, 29 Aug 2024 08:34:53 +0000 (UTC)
Date: Thu, 29 Aug 2024 10:34:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com, pbonzini@redhat.com,
 dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
 x86@kernel.org
CC: hpa@zytor.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com,
 kexec@lists.infradead.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
User-Agent: K-9 Mail for Android
In-Reply-To: <20240827203804.4989-1-Ashish.Kalra@amd.com>
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
Message-ID: <87475131-856C-44DC-A27A-84648294F094@alien8.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 27, 2024 10:38:04 PM GMT+02:00, Ashish Kalra <Ashish=2EKalra@amd=
=2Ecom> wrote:
>From: Ashish Kalra <ashish=2Ekalra@amd=2Ecom>
>
>With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers cause=
s
>crashkernel boot failure with the following signature:

Why would SNP_SHUTDOWN be allowed *at all* if there are active SNP guests =
and there's potential to lose guest data in the process?!

I don't think you want to be on the receiving end of those customer suppor=
t calls at your cloud provider=2E=2E=2E

--=20
Sent from a small device: formatting sucks and brevity is inevitable=2E 

