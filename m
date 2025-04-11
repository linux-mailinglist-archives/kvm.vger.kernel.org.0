Return-Path: <kvm+bounces-43168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA65A860F2
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 16:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C5DD4C40FF
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 14:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D898B1F8BBD;
	Fri, 11 Apr 2025 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Kh985gsF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79631F3FC8;
	Fri, 11 Apr 2025 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744382689; cv=none; b=j0MvYDfP/+hZ8xlB8RNCIpN/JnnLuTVRJx5Atev7doAd0ByvTBWWd/t/XRJzIb336auX9DWEovWE2eSG2CGBpLzOhrNKUFApW1nia/amF0vM7MTfNpMgAJAbs+mBcoDUQ5bZHSkrWdIzrQ2KKqy44T/igekt3iyblzcogB8uhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744382689; c=relaxed/simple;
	bh=moJkFvxmDLSlg7bE86nF/UtfRBSbMAU4i1sEVO7w/tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qlK6iVlVp4ef5+JzZWcDZtrlmQLxbG4EQKq6YPrU2lqwNnEEfRWuQ8npDaUQX6E9Kd8YciHGVOmQMiF/Ao4Fhl36UxMGuJGAIM/fYMbeMZhv6z0FFl4Yd+dUqNDFynVT8divyBp8fVBUUj5ouSm9/TALUWmyvbFRjYyZKTDDYs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Kh985gsF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5825440E0243;
	Fri, 11 Apr 2025 14:44:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BysSy3cu9pay; Fri, 11 Apr 2025 14:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1744382681; bh=mFNh+LpoNmxlu8MowZwGxWARUs4p/TjL0rA9QBfgh70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kh985gsFNZX2InNFg03tb5lj7pmSlu4tSbx2awWMZBYoVQ7HEpy3Lxepu6u76jheG
	 lDriAoiagjDaIHe6uiq0sJSyR1BYOoGB5ApbN+2pev00WzV4PSCdnM6vIt0veE8Zm1
	 9aPc32NnEKsR0wJnXsYAwgBr2Rxq/KUaXVjzZyFrdaxKwXtg02OLSZfHX+7u92shKz
	 JMvlwZszSF6l3DI7N+B0aQgP8O/0JSmxPuGZAGGkDfpZV39QedIAxoqUaRxvMYkmhs
	 DEFjfSDBdkPwEd8iCJb3gB7fhxx5uYZj3SJPFzh4kCZbVTd725z68+vE2hWiIM2fjG
	 +Jq8bO7FfJcoF30250Kk7T60oEBlslFWjROyzhy6PoHzhCmFP/tO7uOVFuvJzEfVSy
	 yF21b8Zm0Rq7uUQXWm92AyKuztSvwl3jTLvcfcWvPQarqjVzmdfH5K7U3hcGjaLA/y
	 RtH7BafFvhCvMfK7Bc8X3S7WTNCn7YDz6RcgKvNAtRg7X+Nl2sPyqWWz9quJjGuz26
	 tHjtgaZ5uOa03xiNAupUDbXqZruvUkv2OyhlSMggRw53Rd/8IZ/jcfFTDjkp8KgoGM
	 kY2RAb3OUmoGZd+UQiz15ppw3uuISzPmJNl7L5Ksml4Dzrg25HsyulB+proY57ieCc
	 tkw3nBMhfStN9fRqf8Wqq3/c=
Received: from zn.tnic (p579690ee.dip0.t-ipconnect.de [87.150.144.238])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 240B140E0242;
	Fri, 11 Apr 2025 14:44:29 +0000 (UTC)
Date: Fri, 11 Apr 2025 16:44:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Maksim Davydov <davydov-max@yandex-team.ru>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, babu.moger@amd.com,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, jmattson@google.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to
 userspace
Message-ID: <20250411144422.GFZ_kqxnqO65es2xPs@fat_crate.local>
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
 <20241204134345.189041-2-davydov-max@yandex-team.ru>
 <20250411094059.GIZ_jjq0DxLhJOEQ9B@fat_crate.local>
 <Z_keAsy09KU0kDFj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z_keAsy09KU0kDFj@google.com>

On Fri, Apr 11, 2025 at 06:49:54AM -0700, Sean Christopherson wrote:
> KVM should still explicitly advertise support for AMD's flavor.  There are KVM
> use cases where KVM's advertised CPUID support is used almost verbatim, in which

So that means the vendor differentiation is done by the user and KVM shouldn't
even try to unify things...?

> case not advertising AMD_FSRC would result it the features not be enumerated to
> the guest.  Linux might cross-pollinate, but KVM can't rely on all software to do
> so.

Sure.

The AMD feature flags are called the same:

  CPUID_Fn80000021_EAX [Extended Feature 2 EAX] (Core::X86::Cpuid::FeatureExt2Eax)
  
  11 FSRC. Read-only. Reset: Fixed,1. Fast Short Repe Cmpsb supported.
  10 FSRS. Read-only. Reset: Fixed,1. Fast Short Rep Stosb supported.

just the CPUID leaf is different.

But I guess KVM isn't exporting CPUID *names* but CPUID *leafs* so the
internal naming doesn't matter.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

