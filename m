Return-Path: <kvm+bounces-33229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 332C39E7A03
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 21:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E786628394D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 20:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9F81FFC4B;
	Fri,  6 Dec 2024 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="f7VX+n4E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378FA1C548A;
	Fri,  6 Dec 2024 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733516899; cv=none; b=ewWaCJ4Q4lQwt77V7N7I92yCwfI4ABIzlhyM1kaXhazwZE0WnI/bBl65A8ziNBJWVs7Lx3AUVWZ6pd8y31jx1LVcSIVx+0MOa7WT2kSFZ022iMulsp7oHcHA4ESq0fjkCQx5ApTSdDMZRvB1l4DMeTPRKwd/K7EctJRVHXsDnOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733516899; c=relaxed/simple;
	bh=SomSZKv0MwR1KXTanKaXnnJoD8VX4U54jA9imBeh7Tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=re1PSEnhiEUJobu1TPoNqzdTQ1OyX4PUt6Dqk/Kd8Mi2f1cYqWwjCIUuNmzM11lrEjp9YUYicuCsm1QdObyZLDJPCH/8SXFsxcUAUVwyMP52zukme9daTz5AFl02UUgkBx4gNbntrbM+w6u/VAE6Pu6oX2msdX1fc1+tThQxuws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=f7VX+n4E; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7F10740E0269;
	Fri,  6 Dec 2024 20:28:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gvEgViPukMSw; Fri,  6 Dec 2024 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733516889; bh=QyoHy6hkI+XssNKuiGZPsocO+ThZzyXeOYQClqjNDlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f7VX+n4E9WtsGab6VK49A55+w9FgVA4l2Mh4YP+en7KylO25svgCltdfzQu3EWngB
	 R6x+mze+OO+3PLBw9OUxO33IikYCHqekn8OvU6MPUJKfCO+/sMa5PQBe7KXFLyF+59
	 siGdVlZI12DrnmExO1zU6eUQLEhNSq/Je7xBTVPDdMdLTzQGmt7aox8P7AooWQqHqO
	 XBMgUHmA/Ez2JF/aYtbidhnNM8tbGN10LHwBQi86Sd8NDn73R7x/26eC0AK5MqfFW+
	 CL6o71Z6bgdVBZFc7WNsdcMPuiQKjl2mwy+94Rlg37VjPG2LelsV/lvZrIfNXk3jhx
	 9QSG6WlOe8CvcMVaYaP7gz1ZU03awoMk0sCY5lfZVqZ21UuWyVRwjc38X2PdFwgXbr
	 pBBjtvBiIXIX9UaPgj8RB0jK8SD9/bLcO451a2h0ggT2V5BFckZqeHPdpLAJ8qK3aS
	 jJG6JZOHFPNn5aJPLV2cQycTqHNymHjvXQRTC9aWfeMPKbYYlMvrJ2DDr3MTri4mrK
	 NGlgDjQDungI9hSQQUfeYX0nH2/VNjIZFt1HNtox5GPTEQwUr3jZmQUPW9zdV1DrgM
	 fEGCUry8/PwwnvNIMIDMmKTunaNhVON9bVh8YHCR8KLDkMTyTrMbIwsVW8cH+8ihv9
	 h8m8WW0qreWz4mame6E7c1Bo=
Received: from zn.tnic (p200300Ea971f939c329C23FFFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:939c:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 37B0640E01A2;
	Fri,  6 Dec 2024 20:27:58 +0000 (UTC)
Date: Fri, 6 Dec 2024 21:27:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
Message-ID: <20241206202752.GCZ1NeSMYTZ4ZDcfGJ@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
 <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>

On Thu, Dec 05, 2024 at 11:53:53AM +0530, Nikunj A. Dadhania wrote:
> > * get_report - I don't think so:
> > 
> >         /*      
> >          * The intermediate response buffer is used while decrypting the
> >          * response payload. Make sure that it has enough space to cover the
> >          * authtag.
> >          */
> >         resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
> >         report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
> > 
> > That resp_len is limited and that's on the guest_ioctl path which cannot
> > happen concurrently?
> 
> It is a trusted allocation, but should it be accounted as it is part of
> the userspace ioctl path ?

Well, it is unlocked_ioctl() and snp_guest_ioctl() is not taking any locks.
What's stopping anyone from writing a nasty little program which hammers the
sev-guest on the ioctl interface until the OOM killer activates?

IOW, this should probably remain _ACCOUNT AFAICT.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

