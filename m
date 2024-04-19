Return-Path: <kvm+bounces-15324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F628AB2A3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:58:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9189D2836FB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC344130E31;
	Fri, 19 Apr 2024 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X57mlf5j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EB0130AF7
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542292; cv=none; b=DN26qk6zum6iZVn6HsEkxN1WJuUNmws6zjfCciA03aT8yIBG9Ye0Bqibxe8TjL4VNwkVef8Woyu76ilKXTe4h6qpq6OoPr51ISI4sE0fByLk3a2t92C3bUzDMVVl4DSSS8GZksfNmv546G/O8H17vf7sCrWYVD0CJ17Z/Y4xzqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542292; c=relaxed/simple;
	bh=j6b6QG8HnX4Cn+WfIW+BG9Bp2mDbxqytU6EcMIEFrDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lp+b6PtCn+AHrQnq5eEyaEKHb96b7M8bYUiAMM8IQYcYkLf+ejOfAWG6+739JDx14NnzLLcJZi7PSfLhxJz46Pp+uS+HSPRpXQF+cx4uwTmh44asHd22nKqcx38XX2oaX7o9hkG0685aqgE2xEenvBp8Haej/zqXXronEOksF9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X57mlf5j; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-ddaf2f115f2so3717787276.3
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713542289; x=1714147089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fWiZrGAjVFQzRmGgPcSYpuKvkOXtBojlJhZpooqeoIg=;
        b=X57mlf5jKbfO4rwkL53FNtp242QGlLPcEc01TNqZRPM9NDlOdg0HozW/K2SZpWmMoV
         rzNE838LhZ16515r89SGRHHY4wF7jaUINpRIFg+BifN82GvDidcNu3+QvF3UoxeE6aAK
         ku8eMJqqkQ5AbZE8dYEtH26/HPB8Qs1++DfpOjs6OjJZIKyT5vMgZYR7wNvq3CM6/sZP
         7iBYX4Rbz+YriS1+7MN9Or6nuAK1H9Y0C1WrdOg6+yK8npH6I8TYCPPdH7LfpoZKS4MU
         IXMxE7Er5LWvhksWji70z6Nafnvcs+Di5UvJtDUqOIY2L/6PjQ86JiSRmjk6Ogc3g04L
         h+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713542289; x=1714147089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fWiZrGAjVFQzRmGgPcSYpuKvkOXtBojlJhZpooqeoIg=;
        b=lt3kLU69EbkgETm+E+sNK1Aom3tF8z9l28vBP0iFoDuTxTP4QQOYxHDZl+0okfGTi0
         FY/Xm0WQIqqO+O1KDnB0ZuXvIxSmLX3Ns0V3WlZU32KRttPDxBgkCWOaQ8F/DHSGmujo
         /pA3nAL4QqAZ6Yvv4RlpopQHREUrUxbB+Kst2OeEgxqomPzpRagA2/o/CIh3/6reeM3c
         fnwGELXY+ftZvo1eMwUoBTBkhjfMOfHyUwUXSbj2qc2SuKhMelL2gqHYAjsMgzyrTNnt
         Y4qFNhpc84Os4babSI/7vbCeZA8KhB3/kTBg4jlmccvfUqow9YWT3pYmNlePf96hfzRM
         HQuw==
X-Forwarded-Encrypted: i=1; AJvYcCVcRNXkDRAtyW+oFU0D2oKlfIDoe2muEVV0ng5aelsEzDqhuK8utP9v1go/t/+ITeEHNl6oyPplMxkWJ22hzMw2g8wb
X-Gm-Message-State: AOJu0YyooFV6FaH7QlfnBJ8gQa9mSO6TaEgN+NO45Oa3ZLRSKzGFTI8+
	ZDTVvG8IgjDFadf5NieESqj23Wu+s9dCDB5rjnyf0KgcrvTKwjw4BETxIMKkrsv1HALykDgEfoU
	hBw==
X-Google-Smtp-Source: AGHT+IFW2ky1SPK7f/pxpi+Hn0rcIyvwlKlbPLBHypeEskqOEkZ75tvGKrkE6cXBAEQEzkvOsqK8ieIXVU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c1:b0:dd9:20fb:20a1 with SMTP id
 w1-20020a05690210c100b00dd920fb20a1mr251076ybu.10.1713542289670; Fri, 19 Apr
 2024 08:58:09 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:58:08 -0700
In-Reply-To: <DS0PR11MB6373D059F2BB9F196AA9D503DC0D2@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419112952.15598-1-wei.w.wang@intel.com> <20240419112952.15598-5-wei.w.wang@intel.com>
 <ZiJ0mjZxlRsLwl3E@google.com> <DS0PR11MB6373D059F2BB9F196AA9D503DC0D2@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZiKNWM0XyMqbKrD2@google.com>
Subject: Re: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
From: Sean Christopherson <seanjc@google.com>
To: Wei W Wang <wei.w.wang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, Wei W Wang wrote:
> On Friday, April 19, 2024 9:42 PM, Sean Christopherson wrote:
> > On Fri, Apr 19, 2024, Wei Wang wrote:
> > > KVM_X86_OP and KVM_X86_OP_OPTIONAL were utilized to define and
> > execute
> > > static_call_update() calls on mandatory and optional hooks, respectively.
> > > Mandatory hooks were invoked via static_call() and necessitated
> > > definition due to the presumption that an undefined hook (i.e., NULL)
> > > would cause
> > > static_call() to fail. This assumption no longer holds true as
> > > static_call() has been updated to treat a "NULL" hook as a NOP on x86.
> > > Consequently, the so-called mandatory hooks are no longer required to
> > > be defined, rendering them non-mandatory.
> > 
> > This is wrong.  They absolutely are mandatory.  The fact that static_call()
> > doesn't blow up doesn't make them optional.  If a vendor neglects to
> > implement a mandatory hook, KVM *will* break, just not immediately on the
> > static_call().
> > 
> > The static_call() behavior is actually unfortunate, as KVM at least would prefer
> > that it does explode on a NULL point.  I.e. better to crash the kernel (hopefully
> > before getting to production) then to have a lurking bug just waiting to cause
> > problems.
> > 
> > > This eliminates the need to differentiate between mandatory and
> > > optional hooks, allowing a single KVM_X86_OP to suffice.
> > >
> > > So KVM_X86_OP_OPTIONAL and the WARN_ON() associated with
> > KVM_X86_OP
> > > are removed to simplify usage,
> > 
> > Just in case it isn't clear, I am very strongly opposed to removing
> > KVM_X86_OP_OPTIONAL() and the WARN_ON() protection to ensure
> > mandatory ops are implemented.
> 
> OK, we can drop patch 4 and 5.
> 
> Btw, may I know what is the boundary between mandatory and optional hooks?
> For example, when adding a new hook, what criteria should we use to determine
> whether it's mandatory, thereby requiring both SVM and VMX to implement it (and
> seems need to be merged them together?)
> (I searched a bit, but didn't find it)

It's a fairly simple rule: is the hook required for functional correctness, at
all times?

E.g. post_set_cr3() is unique to SEV-ES+ guests, and so it's optional for both
VMX and SVM (because SEV-ES might not be enabled).

All of the APICv related hooks are optional, because APICv support isn't guaranteed.

set_tss_addr() and set_identity_map_addr() are unique to old Intel hardware.

The mem_enc ops are unique to SEV+ (and at some point TDX), which again isn't
guaranteed to be supported and enabled.

For something like vcpu_precreate(), it's an arbitrary judgment call: is it
cleaner to make the hook optional, or to have SVM implement a nop?  Thankfully,
there are very few of these.

Heh, vm_destroy() should be non-optional, we should clean that up.

