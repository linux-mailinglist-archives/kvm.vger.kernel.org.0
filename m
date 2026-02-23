Return-Path: <kvm+bounces-71507-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKyqEfmMnGmdJQQAu9opvQ
	(envelope-from <kvm+bounces-71507-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:23:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B16E17AB86
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8774F303BCC2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0A6330B22;
	Mon, 23 Feb 2026 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgAGk0Bk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0448E330331
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866917; cv=none; b=DVBu3l/hs+1CkyYJibBKUPQ4cfLcDiby4zl5OtnebbAroFt7NUEvfqYq+Mq0VLrX2kIlsHiXZ68k9W+QgohVhS2nQxnNKA+xHDun/shF+vTV32AUXO0kgCFWpEXNoy2+zFK9hBXiDgh5dwAoNhlGOHTFed+6WY4jT8E4uUEVMVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866917; c=relaxed/simple;
	bh=HKwLbvFmJGYEGnpPr7MOM6oLTlNTOu8bfAhYYTRO13E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jSpHCfQbwzrobqar9zaOP0qRN70cEx7ZH7nbsUVZO388KRNOdnZ+5sD6FLkmF3S8jhJb41w4FCJqgfNc+MSIgA8S0fTLZj6OHAcuYAkj+Lk3g4Wk5gz5Q00SRsW6oSHX27AtgfxndAJz7Jt9EO2035zB8vOKCe9DVj5JEQy0APY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WgAGk0Bk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a943e214daso316217645ad.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 09:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771866915; x=1772471715; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qB/D8oykiAjYH+aojy11MUffmbGAGIdMwqBS+z3LBGk=;
        b=WgAGk0Bk55uiejxu96L2NKrxY/yQztTYJ8SjfeOjAsYB7UT2PY82EebeMu4INfNuQ8
         24F1frhdW0Vr57JI/tAe/cCk0U/dEit9Va6WGmeKLxVZAR3pdx3cBZK3r0NM4VJGwqJJ
         Szq3x6FoggeTgB5m33sAm3rxMwMY+ODR9AMGY+KcITBlHxqT5m0w0O2VGEdEmn179oRm
         HADjm7dAr5CwfxOTRwl9izLomLx+v68xPhWio0rzKwRLP1UGNWLMxmJRsnfJESaj7yor
         6DXxIHFxKS+jZ8c3r45dt/NP0itUtxwefT4XNaLp+WqGmprewC88ZCM4mSbtIAzNJCnf
         DyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771866915; x=1772471715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qB/D8oykiAjYH+aojy11MUffmbGAGIdMwqBS+z3LBGk=;
        b=VcEmQs5R1VUHfx5LJUR2c8OBqFto3hvy86fFdKw6nVGOK4FhTv1rJXprMzAdqRmfCN
         H4h0NVtT6VmuAlQI/8IjoNv901hyJVIBWlC26WznzGaGDiV4wo65c8uwK0wndCBNd3JX
         goyv4xBhCQPTknQpSpXc5A/9ZY9eUQPitSPGzq7+G0mctdDTrzqvPFHPw+1R5Bpx9fiJ
         9EtP2tosSrOn0DLbcY5vuUOHJBFbK/WhpLs9VlY+AzxgT3+GyA+K63VFkljqfbyZRPKC
         ZFQVhYr4eqU//A+VICN5aS0wwb8x+/RKoHVR7MPlBMmuiUv3Yq1ShrOwyec9vT9qYKoS
         w/ag==
X-Forwarded-Encrypted: i=1; AJvYcCXQ8yFDtAYI2hNlVPtftvhMoRtKMuXsxk8xbu7eR7rOzFGMoJFpE0K7avRdk/nfLaymUtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdIxPN1hUjAx3N5bdmNJkQcj3koiv7x5mYXHWLehdIVqyuFS0c
	R/zHEZm/kmhOI/VFUoepXDBiptNY3x4hQW7fpdE6wu5neZISwxk+qaOTQprXTOV5fpBCWvA8QZ3
	KEwoO+w==
X-Received: from plpw17.prod.google.com ([2002:a17:902:9a91:b0:2a0:c485:7eed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b90:b0:2a9:411a:c5c6
 with SMTP id d9443c01a7336-2ad74511698mr75532445ad.39.1771866915160; Mon, 23
 Feb 2026 09:15:15 -0800 (PST)
Date: Mon, 23 Feb 2026 09:15:13 -0800
In-Reply-To: <aZyE4zvPtujZ4-6X@tycho.pizza>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
 <aZyCEBo07EHw2Prk@google.com> <aZyE4zvPtujZ4-6X@tycho.pizza>
Message-ID: <aZyLIWtffvEnmtYh@google.com>
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71507-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,amd.com:url]
X-Rspamd-Queue-Id: 9B16E17AB86
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > > +	/*
> > > +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> > > +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> > > +	 * check the underlying firmware error for this case.
> > > +	 */
> > > +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> > > +					 &vcpu);
> > 
> > If there's a legimate reason why an SEV-ES VM can't be created, then that needs
> > to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
> > of ASIDs due to CipherTextHiding or something?
> 
> Newer firmware that fixes CVE-2025-48514 won't allow SEV-ES VMs to be
> started with SNP enabled, there is a footnote (2) about it here:
> 
> https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
> 
> Probably should have included this in the patch, sorry.
> 
> > Throwing a noodle to see if it sticks is not an option.
> 
> Sure, we could do some firmware version test to see if it's fixed
> instead? Or do this same test in the kernel and export that as an
> ioctl?

Uh, no idea what would be ideal, but there absolutely needs to be some way to
communicate lack of effective SEV-ES support to userspace, and in a way that
doesn't break userspace.

Hrm, I think we also neglected to communicate when SEV and SEV-ES are effectively
unusable, e.g. due to CipherTextHiding, so maybe we can kill two birds with one
stone?  IIRC, we didn't bother enumerating the limitation with CipherTextHiding
because making SEV-ES unusable would require a deliberate act from the admin.

"Update firmware" is also an deliberate act, but the side effect of SEV-ES being
disabled, not so much.

