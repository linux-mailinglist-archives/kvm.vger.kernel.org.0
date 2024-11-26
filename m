Return-Path: <kvm+bounces-32543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F069D9E39
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 21:07:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8B4166E4B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 20:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD781DF25F;
	Tue, 26 Nov 2024 20:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OV5BfQ1p"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDEC1AAD7;
	Tue, 26 Nov 2024 20:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732651616; cv=none; b=CCRzU9U0Qh2j9Jjn0Onth8WGGG68ZKfdz4BxPzn7BtX+KUmr/gbUqzZngO+M2wFhbxhVHlc3YoPIbXzq2XaAhsLt+IhnzW5w/I5yiCMW5Zkr7EfnGUyqhFduEA+1B1+XopMVN5M83rmhlZf9j+3LDIAjEmF4djirfSNoG0YpsLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732651616; c=relaxed/simple;
	bh=xhpZ4EHs87HsmBu9cO8S8zyqz7DWQNZtGOlnNhZ+X5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOqpcIMgJ880Etk7pXF0eJxMUcskspSHyLA+FN8tiKFUP1y4ZfHAhWVg+FmCr9pzgG2UpVukf92TCFVtGAkwjSIsvLfdEqlh3anr4H/PzxveGEBGIgmdjm2d6dBxGGS6mCKg2m2ot8VmHQRlAgIVGctc4eyJTzoMfdkBYOXy/5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OV5BfQ1p; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 17F3540E01D6;
	Tue, 26 Nov 2024 20:06:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lcGjs7skokuR; Tue, 26 Nov 2024 20:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732651606; bh=FhdnsA3lrKxoRXp7hFNulYIHOOCq0IH8zzLAv3oKKFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OV5BfQ1pcdv/md2J+mN9soJIEJcOokqpX+ebP7CVjfnyaE1AP4pPCNmR0JAQ+lq5v
	 /aSASWjLBNsSgK1C2CX67O6gtshwdTJohSma3ZpyEqiOD9vY/9RMTNIIolkbhZr9ci
	 vBiyyHA3Jro3DdcHviz6s+gaOA0mPONc5sLYRqWiAD1rBsI5U82xLuflvMEBvECJft
	 QYusZJ04ci60H922TngsmPbAGzBZkqUc9O4OJW9heDNrTyebovnt3CIUj9jO+E3M80
	 RzqgtaSIh5dHD8E7XtSz4TrbDlRYwE4py6xHwHGvCu/fGk7JwOkrLHmCAqdnWKKVog
	 y0ANx1Nf9uVkytkS6IUKTCUV/2VcPLoH11Bz2H3cPBfAzQJdHCJ0a+ZCPawExoD4hm
	 miXovY2ofsYIqR8W1eT9q6X0B/QuZTK+/hXBP8aIPY8T/JBMxdvHuspzFmyfrIjkiF
	 QUXpQVlRrSXrMl+dfdH2b5wy6uT7lCn5HSupFO+IXrVEZSNL6WOM0ZCEHCf9kbzDLy
	 TWitnoUfR85NOY6QyXh5Q21zQuwkBOqOmT55LmneOw2Vr1dwAbepFmXAUK8T0MT/nO
	 L94rQaxm5tvfnsyaOgkltO9WCEubMAOjfsLDb9Mgrw+nAsE5CYGdLLFJSMoSQ0DQzJ
	 yOtFgvj1WgJyltXxRlgRGeww=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D61F040E01A8;
	Tue, 26 Nov 2024 20:06:30 +0000 (UTC)
Date: Tue, 26 Nov 2024 21:06:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
Message-ID: <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
 <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>

On Tue, Nov 26, 2024 at 11:22:45AM -0800, Xin Li wrote:
> It's still far from full in a bitmap on x86-64, but just that the
> existing use of MAX_POSSIBLE_PASSTHROUGH_MSRS tastes bad.

Far from full?

It is full:

static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
        MSR_IA32_SPEC_CTRL,
        MSR_IA32_PRED_CMD,
        MSR_IA32_FLUSH_CMD,
        MSR_IA32_TSC,
#ifdef CONFIG_X86_64
        MSR_FS_BASE,
        MSR_GS_BASE,
        MSR_KERNEL_GS_BASE,
        MSR_IA32_XFD,
        MSR_IA32_XFD_ERR,
#endif
        MSR_IA32_SYSENTER_CS,
        MSR_IA32_SYSENTER_ESP,
        MSR_IA32_SYSENTER_EIP,
        MSR_CORE_C1_RES,
        MSR_CORE_C3_RESIDENCY,
        MSR_CORE_C6_RESIDENCY,
        MSR_CORE_C7_RESIDENCY,
};

I count 16 here.

If you need to add more, you need to increment MAX_POSSIBLE_PASSTHROUGH_MSRS.

> A better one?

Not really.

You're not explaining why MAX_POSSIBLE_PASSTHROUGH_MSRS becomes 64.

> Per the definition, a bitmap on x86-64 is an array of 'unsigned long',
> and is at least 64-bit long.
> 
> #define DECLARE_BITMAP(name,bits) \
> 	unsigned long name[BITS_TO_LONGS(bits)]
> 
> It's not accurate and error-prone to use a hard-coded possible size of
> a bitmap, Use ARRAY_SIZE with an overflow build check instead.

It becomes 64 because a bitmap has 64 bits?

Not because you need to add more MSRs to it and thus raise the limit?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

