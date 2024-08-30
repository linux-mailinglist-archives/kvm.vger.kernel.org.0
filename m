Return-Path: <kvm+bounces-25528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2D0966384
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AA5E286732
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0451B14E2;
	Fri, 30 Aug 2024 13:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3M58Dtm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5791AF4FE
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 13:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026238; cv=none; b=WLIXF+svkso01PQJNyvtTMUfYbHK8TFeROnUjiaOi1DDXFniO13grKehncjvQb14LSTc8MvwaB7twhilMixLMJntO9+A0HXUzyTFGYDW5DbD+KpIP2M+cLb3hNoIBLIYng2r4QDHNPxP22uwSa0oJDP33HenhMHBa7T6TFJyU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026238; c=relaxed/simple;
	bh=NUlKGhIyCsQGFAYIgqP91JPxVHe0dLUWSGpMcalpvoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aJC1Svr0cbgBMm5JEJEXydmcO4MnUFBtGnC0jWcIlH6IwbKhTYd3ysw6BuWQoh9D3hnSSEglrSbiO6dH/gu/8DdLQhLgEQHtfWYhf0h2OrZSvg64h/hKks0Vy2rX3J1PoLMyAb1V1Q68Q+6gXWiVmlbXJ2l1IGuTI77QAefij1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3M58Dtm8; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2052918b4f4so7078615ad.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 06:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725026236; x=1725631036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=58CvTL6COAyoekWQp05GB8r3Lb0Xc+vxoLW2O7LrDWY=;
        b=3M58Dtm8nuNnYELdLnsGKD+ir1BUWYX6KMaWNsdRaZlwUBjlODenA7kthE1jBOAUou
         ImtzeOJ2e68tgG+fdGNq2kPdTJvjZAseXOybzuNqxF93qfmN4/SLr4yPdIQ6YQjPTO/u
         5qNdRvUl1NbK8rrNaEQh5uaG4V5R9zepM163/bERDS7YXIB5c0KextBqXF8tfiw0PKNt
         YfVDSkNCbWkVYkZKVDbbgi6oPi8/QFSiypLGtqE2RsKJ06emUyTlX4ZZA1QwVpIfySex
         3oGLPOfa3iwUQR875Zs4igODpfEJfNtvHOEb0Ol2QUeWNE9rnF/OXm56pVsyIICKf8F8
         zyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725026236; x=1725631036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=58CvTL6COAyoekWQp05GB8r3Lb0Xc+vxoLW2O7LrDWY=;
        b=bI18UC2rClRHnOpYEf9S6ESSLXIpUvdnXAmd1y7wvqDcYOBf+PwfvhOBTxBAAF8QvP
         pJwgNhFUWGP/cfnOb4DN7BojJThgPbzEPPiYLpHiTwkifdFCmS6f6rRKoSt9Y6M2Uq5h
         w377ZjjOPt5JDh5o0apr2WFJUnKHVl5iEBDtvpwTdyAYGl89Q1RI8FS4qBVWjIbYcF6U
         BMsVtbzJEMTiWkfLUsnqHSO5HPBAd2SKmUjG4OgYB2Q3lEdWJFem52a6j3pAGH43XOoZ
         +dDzi8g4sEgfJA2qI06ACZWuZSTMu8m9LuX6AylYZ+DhdB57563tNhDuaeYfhK23ENsZ
         CEjA==
X-Forwarded-Encrypted: i=1; AJvYcCWiCKWg2K94P7mOTb0eZfVWjtAc8greBcqkJh1FhvS3LR5LSo8IvLbYH4ZUX+CRv83bfbo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKMS9nXAJv6kwN5cFKvfkKE7VM6lewEOkdypD8y77KJvZAnCgZ
	aQpD6XBmNvUkFqGRomlDLM9ALVcYGOxdz/jDNMqgoB48spnhDZT9XFjuGKeVKKLNFnsQHB37/oc
	Qmw==
X-Google-Smtp-Source: AGHT+IExGR2RCNKu/4M4z4IiNUcplAydPr67v3iYUD8ZfSJDuu52D1tVexWQwhZuKUP8XxVYEYjpc6MqNEc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f90b:b0:1fd:9d0c:999e with SMTP id
 d9443c01a7336-2052857ddfamr344725ad.9.1725026235523; Fri, 30 Aug 2024
 06:57:15 -0700 (PDT)
Date: Fri, 30 Aug 2024 06:57:14 -0700
In-Reply-To: <1f037b5604deb5f83f05e709b2edf3063372518f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com> <20240830043600.127750-2-seanjc@google.com>
 <1f037b5604deb5f83f05e709b2edf3063372518f.camel@intel.com>
Message-ID: <ZtHPusyTNkQ_a1Y-@google.com>
Subject: Re: [PATCH v4 01/10] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Chao Gao <chao.gao@intel.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 30, 2024, Kai Huang wrote:
> 
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > Acked-by: Kai Huang <kai.huang@intel.com>
> > 
> 
> Hmm I must have done a lot for me to receive two credits (and for most patches
> in this series) :-)
> 
> I think one Reviewed-by tag is good enough :-)

Heh, indeed.  b4 has made me very lazy; I just `b4 am` the patches and let b4
grab all the trailers.  I'm guessing something went awry in that flow (or maybe
you acked a previous version or something?)

Anyways, one of Paolo or I can clean this up when applying, assuming we remember
to do so...

