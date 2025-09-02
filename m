Return-Path: <kvm+bounces-56620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E15FDB40C25
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 19:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CACF5E3DF9
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9923469E0;
	Tue,  2 Sep 2025 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="01HN6vCd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F398345721
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756834394; cv=none; b=ZyQtTaW5Kqgh/OqLSJ7brNW/gI8DGi3yWVFU14eDPbbQMSNhJTFYA3EdhEA7n0u7S0vi3SzfXYgp9bHXnLmVhqX0J8z5Cfsw1QJmlBDaOcwUaYprb+y39xs6YZkulv8F0C7SY+neb1XLT7qmuKH+00LiDYT9nBftXBOyzA9tv9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756834394; c=relaxed/simple;
	bh=zaN0nJKLPtyNMOdWW+MLmd9/wTkW0i0TyuL2AZDeT50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BHMoRApNT/66ek3M/FIO1c1cAi8Vs+Zj+q4kdaTbjtCndyTG9ofc4luBEZiPgb8qHnKN1h+/cTZ263Au/ucaGV3PVNP5lWAxOqmGqrBOTI8I9vyMuZpAKywyAkTdYM3KDqaqxf4YISYdml7AYLQRPGqXOdGz9bMi/I8PEebjMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=01HN6vCd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-248d9301475so77323935ad.0
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 10:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756834392; x=1757439192; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UBr0XXEc+3/ZwTSrGV21TfsCPRB8kmlFqQlQTsqg//g=;
        b=01HN6vCdEWBckhALAsnX/QQ8S0Eh9Sg2BaCtjiaXxmYemDy7ftVQ9RfwviF4EP+FpR
         6mFpMLUsaE1FGW/mVEO6k5418ZRLN+SwFMLnva8ntLdw1LnAUCGREyA3n6PPp5o2gmsq
         M49ktdN3kJfajml6UMzvleoV3068oGpkip4/QencOz3U4NSOeHh/clE1UFE7uI/gmQWV
         4UBgjjvRvHW4IZb9DHDKntGqaEk/OuOfZEnh3wGpkWxOfqihfOk4ac2mXSIpOHFv7nEY
         dF1VYx7cBd+PRPnU5h2yN9L+2WAYfVpsk6A6pFREVb9RBk2s2ibIyqu/Qt2ZeqXmREXa
         qmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834392; x=1757439192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBr0XXEc+3/ZwTSrGV21TfsCPRB8kmlFqQlQTsqg//g=;
        b=hh88gsmESUoW54gnY2Kz13AMuGVEHOYfqHsdlkh87JvkzCWehrPDul8PbtT+GUVobZ
         KyiBhcX9NbqbNIWQXic2zKpHqj5wH9vaVTT7vcAMw55Xqswr520Tw5W0efuWtTEhT3Bp
         cHibYKiycVYxddO38hTd8rrbYxCCd5Y/ZprS4kA+LzRpQhHpXtrQTu0yw3obSBwXfqJL
         D/JHob4H92IkK22hAIVqL77TWX/8fEH3MCi2wAzfGFSZ5X3ddMAggiLVuKK/tpKfYPoY
         LNP826JQ9HSkAXrNPJVt2t1Iu6CFMgJpSuDkc8wwPwJ3pTZAhJA97EIdgSamcZq3P9gl
         JxpA==
X-Forwarded-Encrypted: i=1; AJvYcCUHLc1PUZcMgOjWJLOMfpRJBCN8JnEhJ/jfIJAdlvlqwFPP4QAwwwIrXNy7YaGeJ1infC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWrTR6k6ES9utjyTqXaDVoiIlUObF4FpAfnZmj+rJKctjxuoUo
	cI1iQGIrqovunj648IF3G5refiXIL5UKb9eMTfImk2zVzlppl8XajU5zcpPhsNUAKqNpjrpdDKC
	vQmhhEg==
X-Google-Smtp-Source: AGHT+IHwmuitXxZ6YedCVurRjYCh4gXAu/7FhsnP6E8xId3vuL0zXJB3cs1IaJN+nRHn2/CNa8FpuWXxdS8=
X-Received: from pjer22.prod.google.com ([2002:a17:90a:ad6:b0:329:815c:ea84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2cf:b0:248:9e56:e806
 with SMTP id d9443c01a7336-24944870a36mr187562355ad.12.1756834392295; Tue, 02
 Sep 2025 10:33:12 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:33:10 -0700
In-Reply-To: <aLT2FwlMySKVYP1i@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com> <20250829000618.351013-6-seanjc@google.com>
 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com> <aLT2FwlMySKVYP1i@yzhao56-desk.sh.intel.com>
Message-ID: <aLcqVtqxrKtzziK-@google.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Kai Huang <kai.huang@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 01, 2025, Yan Zhao wrote:
> On Sat, Aug 30, 2025 at 03:53:24AM +0800, Edgecombe, Rick P wrote:
> > On Thu, 2025-08-28 at 17:06 -0700, Sean Christopherson wrote:
> > > From: Yan Zhao <yan.y.zhao@intel.com>
> > > When S-EPT zapping errors occur, KVM_BUG_ON() is invoked to kick off all
> > > vCPUs and mark the VM as dead. Although there is a potential window that a
> > > private page mapped in the S-EPT could be reallocated and used outside the
> > > VM, the loud warning from KVM_BUG_ON() should provide sufficient debug
> > > information.
> ... 
> > Yan, can you clarify what you mean by "there could be a small window"? I'm
> > thinking this is a hypothetical window around vm_dead races? Or more concrete? I
> > *don't* want to re-open the debate on whether to go with this approach, but I
> > think this is a good teaching edge case to settle on how we want to treat
> > similar issues. So I just want to make sure we have the justification right.
> I think this window isn't hypothetical.
> 
> 1. SEAMCALL failure in tdx_sept_remove_private_spte().

But tdx_sept_remove_private_spte() failing is already a hypothetical scenario.

>    KVM_BUG_ON() sets vm_dead and kicks off all vCPUs.
> 2. guest_memfd invalidation completes. memory is freed.
> 3. VM gets killed.
> 
> After 2, the page is still mapped in the S-EPT, but it could potentially be
> reallocated and used outside the VM.
> 
> >From the TDX module and hardware's perspective, the mapping in the S-EPT for
> this page remains valid. So, I'm uncertain if the TDX module might do something
> creative to access the guest page after 2.
> 
> Besides, a cache flush after 2 can essentially cause a memory write to the page.
> Though we could invoke tdh_phymem_page_wbinvd_hkid() after the KVM_BUG_ON(), the
> SEAMCALL itself can fail.

I think this falls into the category of "don't screw up" flows.  Failure to remove
a private SPTE is a near-catastrophic error.  Going out of our way to reduce the
impact of such errors increases complexity without providing much in the way of
value.

E.g. if VMCLEAR fails, KVM WARNs but continues on and hopes for the best, even
though there's a decent chance failure to purge the VMCS cache entry could be
lead to UAF-like problems.  To me, this is largely the same.

If anything, we should try to prevent #2, e.g. by marking the entire guest_memfd
as broken or something, and then deliberately leaking _all_ pages.

