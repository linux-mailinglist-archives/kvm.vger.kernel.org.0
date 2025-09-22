Return-Path: <kvm+bounces-58382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18752B9194E
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6A9F17BCA6
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 14:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC5D1A9FB6;
	Mon, 22 Sep 2025 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IqInX6e7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0354319CD1D
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758550069; cv=none; b=guISRm/k6ZzNnSKqoAGP0EDVhfywn14K48h/hgMyGkwz5lxqwwCJt5BcsF+U4GL9PQN6S2f4i8YhCHk22qu5MrrwQHF8FjCvmjFNpe1pZ9F87A5Ji3qeopSY7KHxUWSDK776PeYe7ZS0+KZXS7lF+yybBTbYn+cX2dBtkE46uGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758550069; c=relaxed/simple;
	bh=tyVaKuWfBFWx5BCJG3YHH2FqroIs/me67hugzU/cs1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RcKlywORLW+4814ry/venCR8SG4mGud/wgC+02oHa8MrCysGKxar7KqF3x7bLXTLOLaGWRFNj2OymXQwobleG7vWvZX4Nn6PgCgfMQeoLTMfgTu6yiwvRIyWTe5Qm7nvOPFyyA/aHwB8oQS0Jc8onTET8n6XQobMPReAGsWAdu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IqInX6e7; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77f3feba79cso1370653b3a.2
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 07:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758550067; x=1759154867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3dmlNt4jLc1yhAOfhdIXu4MYWVCnFVgG6lvtlLOwUWU=;
        b=IqInX6e7CChcpmarSsZ+sKol2IkJJ7uyTnHJjiJ0CpoLIlCcupUSjso5/cjtMhLyhC
         ECzNHtdeMbbKRl6Zr9DwWgS17Ejnw06Cvv/vdjV7UHrdTOSnFSJzSpEy6yagBPbsVkmV
         TrYu3lFv98JOrVideQPhDPeLZO/Q6UZvcfh3qLQUr5zV9CMtiURVwKX7X56X8Ef1T31B
         Wmyflvt9iNdXElT15lvw/M+F3HOe5zd8PrXpgM5evygzVBzbf6r661ngyCYCTrAUosWb
         24tzmJg1tovehKMRLKzPlh81gzNjJYjqSf7gDOnvFyJRGuw+0Lm9ncxmad4uZH8fnt0I
         YsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758550067; x=1759154867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3dmlNt4jLc1yhAOfhdIXu4MYWVCnFVgG6lvtlLOwUWU=;
        b=pKuiJB0KfztTxxZP8qY1lIW3MybCQjudAsrxoTuikDWS6BBzYpO7I1ZsqAcbgQCkt6
         YDzs2Rpyi6mji+92v4aN/UAmKl8bacmRePGmlI84rfGnk5ElyfSS2B5jFPuRNYHgyVjU
         JxNKR9+i87uIrmdn6O7cu7zqZkPJeKk4rpdsf6awXpXiSBBqgJ/5vI5bcqmrkzAhyBsp
         M/kYqXB5p1YrSBh5UHA1kpkAL5H/QcHsXRHu/TJ00tPutAr1IQRQyG8QVTuPd+nXnOot
         H2qpy729m8iP9T+sNKpfRphfrWw3sGti0sPZlHB8zLNVNsJ33GpbSB99PQGuWT3So0fn
         4CkA==
X-Forwarded-Encrypted: i=1; AJvYcCXyjSBbvY31KIV25RrGifdlKyXXvqyN/RUzMog6vzRahT5CXY+Igljl6OzWsx4V5SYQVdw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3aIB5S0xjAiIpb/m2UOYqc2ybN5Mwm8ULaqM7shD3FS5QvjzQ
	Z3l9BFly+nyxeUv6YHGY0ed/STcNQgtO2mFjuMjxElUYmoMSAd6ktTzRqjsGn1i2OEI8OPvP8jz
	l9J4aPA==
X-Google-Smtp-Source: AGHT+IEQgl2gi//t5TMBNwdIo1/6h8UVZtuDwgvBJmY3sChy40TPMSAvclGNeiDctfhD/fxxvR5QJK4JDjI=
X-Received: from pfbei54.prod.google.com ([2002:a05:6a00:80f6:b0:77f:4904:b672])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1907:b0:771:fdd9:efa0
 with SMTP id d2e1a72fcca58-77e4e5c5576mr13905425b3a.15.1758550066926; Mon, 22
 Sep 2025 07:07:46 -0700 (PDT)
Date: Mon, 22 Sep 2025 07:07:43 -0700
In-Reply-To: <aNEAtqQXyrXUPPLc@archie.me>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909003952.10314-1-bagasdotme@gmail.com> <aNEAtqQXyrXUPPLc@archie.me>
Message-ID: <aNFYL2Os3rbfMbh6@google.com>
Subject: Re: [PATCH] KVM: x86: Fix hypercalls docs section number order
From: Sean Christopherson <seanjc@google.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux KVM <kvm@vger.kernel.org>, 
	Linux Documentation <linux-doc@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 22, 2025, Bagas Sanjaya wrote:
> On Tue, Sep 09, 2025 at 07:39:52AM +0700, Bagas Sanjaya wrote:
> > Commit 4180bf1b655a79 ("KVM: X86: Implement "send IPI" hypercall")
> > documents KVM_HC_SEND_IPI hypercall, yet its section number duplicates
> > KVM_HC_CLOCK_PAIRING one (which both are 6th). Fix the numbering order
> > so that the former should be 7th.
> 
> Paolo, Sean, would you like to apply this patch on KVM tree or let Jon
> handle it through docs-next?

I'll take it.

