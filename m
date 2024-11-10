Return-Path: <kvm+bounces-31388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0AB89C33CF
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 17:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 665BF281203
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 16:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6293B13698E;
	Sun, 10 Nov 2024 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Ja2il8K2"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F57A25634;
	Sun, 10 Nov 2024 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731256546; cv=none; b=Ph4U0tljUP2fYdc5r9jOYRnLbNzh+0MsWltBs6w9I5BrzRCS/888D6ugHL5wyDAKWLPBtziNCnEo0n9xRw+lmHNA8KQ8tFro0PZTNXsLmNmfe1BFHsBnZmj0N1ZdxKnzpKleDSvDw8CEloelaz5gSNy+c7lab8IpldQJNy5jQZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731256546; c=relaxed/simple;
	bh=TNJaMT1zqxNkdHyroxsxotRyykkxHS6q+UHiCcs3H4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP/WWmgJX555+HtwUJeJwJuf051Mntmtsa6voNxAnZ9pPgWBDkJWSCEzMAoM8ekeUdME14GSgn5nQBUVTjm7K8rvHKs/Te1/Rr2kdpZMjCapBeZy+c78QENlhdHKgqwkZubG0xGkA1YP8oh4YfuHDKzRRb+UIx937lU2YtzfM4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Ja2il8K2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 943D140E0163;
	Sun, 10 Nov 2024 16:35:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id gwzr6Gs2LUTs; Sun, 10 Nov 2024 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731256537; bh=wApLrmap1eGd1HQWqBvQpBXIejNG2H6AgtD++ZkiNWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ja2il8K2JuBanP/bytU3WQphmOLYKNS3ruhpoa7CMkPmVpyw9EzhRKO/v7CQAJyZG
	 AFP3zOcNomPjRsdNbs0RNBSCdLbaYx600sLux95u4M50VVHVUleYGfQBVBkshkdjgA
	 f9l+ujy3j2GY7urmfJZypVeeLeAyh8/K4B13rpKIWhgu17ybZ18I8bAx9w88QmGjYn
	 m/x3f1wkqnicHH0+Er1UEcI70sJIHWBvnViTrGQm5P9jg1gt0eBV7kT1/S09iCznr4
	 16uS3UfEUp5EZ54d63D4oca9zf89sW6TSSnkGMO6xZoN+j2OfB9XWmiXAMkF0f0EMt
	 F2IhmC4CE0mjRhmNsqcnotBYY79EpOEMa97ietu7tdsnnxuB+ubQ8iErpX28ZEJWdH
	 a5Jl/X7j8z2nPDklRfREsuURG9lOu7B9xm9XeiFX4HNQiCXliz5Yu95jXzB1RhAwZa
	 X75nOMyPD35zsZXIgCqHqhdgPOn/7+YOXUOfD6lxw8Vq39lbvB8R9PSWCu7rNH5FSn
	 VIdgdpLDZXradARx0/wO3qei82k2BjgSLf0xGtjPydcECI1DlP4BpOWSyMWDhi2MIM
	 bgKGlMYq9p+/2TL7vlbxIPxE91kr3/nrNvv6MFjnDTO3hZdJNjmNan8yHVKM/Mw9TH
	 kTuWqDG/6T0vBbXdECN70PQU=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E2BB540E015F;
	Sun, 10 Nov 2024 16:35:18 +0000 (UTC)
Date: Sun, 10 Nov 2024 17:34:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [sos-linux-ext-patches] [RFC 05/14] x86/apic: Initialize APIC ID
 for Secure AVIC
Message-ID: <20241110163453.GAZzDgrYY2oO7fKvxl@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
 <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
 <29d161f1-e4b1-473b-a1f5-20c5868a631a@amd.com>
 <20241110121221.GAZzCjJU1AUfV8vR3Q@fat_crate.local>
 <674ef1e9-e99e-45b4-a770-0a42015c20a4@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <674ef1e9-e99e-45b4-a770-0a42015c20a4@amd.com>

On Sun, Nov 10, 2024 at 08:52:03PM +0530, Neeraj Upadhyay wrote:
> If I get your point, unless a corrective action is possible without
> hard reboot of the guest, doing a snp_abort() on detecting mismatch works better
> here. That way, the issue can be caught early, and it does not disrupt the running
> applications on a limping guest (which happens for the case where we only emit
> a warning). So, thinking more, snp_abort() looks more apt here.

Well, sometimes you have no influence on the HV (public cloud, for example).

So WARN_ONCE was on the right track but the error message should be more
user-friendly:

	WARN_ONCE(hv_apic_id != apic_id, 
		  "APIC IDs mismatch: %d (HV: %d). IPI handling will suffer!",
		  apic_id, hv_apic_id);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

