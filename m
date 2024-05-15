Return-Path: <kvm+bounces-17469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCA38C6EAC
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36102285468
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E413F9EC;
	Wed, 15 May 2024 22:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HjuM08me"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4F13987D
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715812355; cv=none; b=Jxo14slHVlrlNpBa7wtWk8IJpd6xmQw2HeRZ8PwDcOoEMmyRnbt8OOClKwMsIMIZOrwlozaxGt7mZvCxUyIXGx/WlwOiT/Qrm9uWsqaQCN6cJruewSkImb/kasN2Brkq1MQdLoG4+0S17BXuVfxl22n39HPQ5ZbqpkWiBtgIwE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715812355; c=relaxed/simple;
	bh=yOjcIsfN3tExLZMJ+gVYMWNxgpkty3gq1Ou0c+Au+4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qtE6BxxhN6McYosiklxsmpMVAzy6P5n7wm8DOACEB8OKTKYqZv+e8uN7ynuTeF/X6HWiN2vD7VLKH/L5slURMUilR+VQg7qi9654K9GBKaoJiz3jsVKCsQtYdvMkRfiF3nKT6lzKHiJdjXutdsJGwnVnGHvs1lrBkpFdmJds8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HjuM08me; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-deb45f85880so11935626276.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 15:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715812353; x=1716417153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EPF8PJovrQ185Xix6cPYFe3kIZWChHoK4Bh+g+HJ8+c=;
        b=HjuM08me/bYlXuUfIsafn6e5VUVtmIh7mHzphsBcKcid6xudSln6QDGaf8dn9MnaYz
         /YnNVf1J7HCQ9T46e2NAgXu6Sgnv7yrYAB8wk2jCd9BERQyXdzGm8KX8gmASQehPGyc7
         VHdXkNmARxuA3n7uAZmqenYLJXJ36bb1DwUVA4+tpmooaVb+f5AT7jGkadLpr9mv1Doa
         7vzVLZLGr6zHa+Msi93JQGJuz9Kd/HdZWZQZF8/G6bavRHxReBfa+P5orpHrLxmj+aoq
         GOGF2JAyVGgI2W2Jb3QxUw34jCbB+krfqE7u/4Sxazai5shB22MuvwkxOtbw9/9Yxqtj
         UrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715812353; x=1716417153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPF8PJovrQ185Xix6cPYFe3kIZWChHoK4Bh+g+HJ8+c=;
        b=sU3E3bJ3CStXtdxBgzxvaLbK63BemlMiqPyL1xFW4h+qqJdNPVPO4pVfFBgdbhYLEZ
         daEbfvBOLorAlyUl8lBMfpLBphC0Pc6UoVEACtWOl1aNLMzOYwbppB053mfmlb1t1fS3
         S/FmvcSU3imfaFjue2ChvfHrknUbSKoXz+u/Wr2GnnnAJOooz0n042o0wrX1110nW+vf
         wSlWBgOQxcBNLu6LjkL6P+eTG1TZwgT55jyZPC/SSqF4TfvpGgFktZCpjXLrwiJfAE3e
         IMWwMTP7BZBEPzpO6xdkw6MtlTPwSoPJT1THzNaLMaPyQHcvewGWT2ZvCR0vfDN7Lcpl
         sznw==
X-Forwarded-Encrypted: i=1; AJvYcCWscjeMcskmp+vdPyo4SjaUNI5SluBjtu1MIBd8HkwBrjPjcNIaiHBRGgZDI4txuVKobn/kThcLGJwYRNDk60b38DiB
X-Gm-Message-State: AOJu0Yw+QwsOYSGvDjbPb3bsR+I/gzByAlwcXleHbEEHj8ZxL1guBLYx
	06lJwjoo/3kxlehO4vpCr3ja36VJFk0UxBiveSuN0+iGW3ELbxtZp4nwjaOlTAmE9aQwhoZTd1u
	3gw==
X-Google-Smtp-Source: AGHT+IFyrSGFsluNLkCQT8I57VDLzBgUNxscaZbE7FmztJBfi7DMao3EVnkheoHM7iotSQB2HA5niH7yQao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1025:b0:de5:3003:4b83 with SMTP id
 3f1490d57ef6-dee4f4fbce6mr1542224276.8.1715812352968; Wed, 15 May 2024
 15:32:32 -0700 (PDT)
Date: Wed, 15 May 2024 15:32:31 -0700
In-Reply-To: <20240510211024.556136-14-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <20240510211024.556136-14-michael.roth@amd.com>
Message-ID: <ZkU3_y0UoPk5yAeK@google.com>
Subject: Re: [PULL 13/19] KVM: SEV: Implement gmem hook for invalidating
 private pages
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 10, 2024, Michael Roth wrote:
> Implement a platform hook to do the work of restoring the direct map
> entries of gmem-managed pages and transitioning the corresponding RMP
> table entries back to the default shared/hypervisor-owned state.

...

> +void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
> +{
> +	kvm_pfn_t pfn;
> +
> +	pr_debug("%s: PFN start 0x%llx PFN end 0x%llx\n", __func__, start, end);
> +
> +	for (pfn = start; pfn < end;) {
> +		bool use_2m_update = false;
> +		int rc, rmp_level;
> +		bool assigned;
> +
> +		rc = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
> +		if (WARN_ONCE(rc, "SEV: Failed to retrieve RMP entry for PFN 0x%llx error %d\n",
> +			      pfn, rc))
> +			goto next_pfn;

This is comically trivial to hit, as it fires when running guest_memfd_test on a
!SNP host.  Presumably the correct fix is to simply do nothing for !sev_snp_guest(),
but that's easier said than done due to the lack of a @kvm in .gmem_invalidate().

That too is not a big fix, but that's beside the point.  IMO, the fact that I'm
the first person to (completely inadvertantly) hit this rather basic bug is a
good hint that we should wait until 6.11 to merge SNP support.

