Return-Path: <kvm+bounces-70676-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKlBMv51immmKgAAu9opvQ
	(envelope-from <kvm+bounces-70676-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:04:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADFA115856
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9140F3028351
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A142AD3D;
	Tue, 10 Feb 2026 00:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T4xwVp77"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66670CA5A
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 00:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770681839; cv=none; b=D0fep2G4lx6Qf6nf4y5qhas/2IjXdKJdtDaO9t1SYY3aUuqSJPtFh9bHj3rJW3KvSs9UAnNH7Ece6ezvEJG3gIF6/vNpUdUvQLS2SWqSkyYESR8K6N1EVZTrExYcBDF3Z6wOoUMriBGRmK19Bln1wtmvdL0orEBeIo21W3Dr8Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770681839; c=relaxed/simple;
	bh=gjWOfh2oXqfUpw2wDeimGs6kjBD+x4vrWr1zYXsf3kY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rx+r/R2ejNrjWL7E8Q+y38WEmfFPswmEZsxCUjWhbano1XmU6+pjilL1+ywI++bZYxXn2KCjcgNpA9YUghUR4v++2OSCXtjyMFDZGNoFctvXR+ET3QtoRuZ7IGX5IhCRM22t6VFAR3lMrNdMRUMKmM+0oFm/BgR8qLLNgasplp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T4xwVp77; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35464d7c539so3762950a91.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 16:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770681837; x=1771286637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8D+wnxBr88OFAdWjFQqFAuUdOy/p9oRL4Mq3hgfPxZ0=;
        b=T4xwVp77zxDfX9U/xW0iB7hugA23wL6mFKTJZTf8odrswrjx5UpVFQvFNnMiVjSjPj
         E06mvZj3Fu8pcWab2U6kijHLr5eX9YtxiJRB9AMO0zc5waAObWJAaXKKMiyK1vn3004/
         WWBfUA2hFYR16mA4t9UeDrEy8VF7bfmF/KjzO+/SwMxA4fIjXGsTopAxLFWxI53g1rC+
         76FBQsZnV8fBhfAvMmy+GvOgZJ/Bp4k7CCcZhi8LtgsoFDVM209aZeRm9wJcqFvQPlKy
         hhsw/uZulZCuIeb0hvOTd6uw3ui4mvvGqD91NhA4J7bz7QgOpA/LARpR6oCQv0NS95Ex
         BrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770681837; x=1771286637;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8D+wnxBr88OFAdWjFQqFAuUdOy/p9oRL4Mq3hgfPxZ0=;
        b=EvFhygFgYWkz9AHJ57d9L9vixDAiMs4X5cK4if4d3tsK5HRl2tqL33Zrlt/46+dGqq
         pSmUVxddS8GZ0ke9jt+JEXzJSW8S1ZhhOIRT6hv2TzAoeG6AgQlFAOZJDalYA0bx+VEr
         sE/7+NuDtUtvf4YtvIsjvhkc5BZjiaJ6j8GmaUySKZWuLy/KJeISa4+SNVsIye+h/9I9
         mNhKPFL7sKEoLEzOdbWPV/KVKcZBB2y6Z1H78nj50VxqKI58lgaou4LhqY2l8Exzfzgo
         2pzmlx6io54xH3h5JLR4cuI+Tlr2MeTnDjJGkv+kg84AsUNNwIL8mBLAkq9R/0ZX5y7B
         vDbw==
X-Forwarded-Encrypted: i=1; AJvYcCWnvR4bRdl6W0WTUjWV9sr4iiNj/VxvvVcuiuryczyq0+fTecZ64qpmgxR4Ya9CANuTj5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMMub9QO7zh7v3ssjqja+zpmNIQ527h8nQinWoHFV1is9jXHnm
	SKKPd+nh0BHBtWim3Trpwf7FHd8SF3QuBZCPrCH5sw4Uv0VM2OmlqPTSMYWzY12qId3e8LOF+KR
	42T6Kxw==
X-Received: from pjbse14.prod.google.com ([2002:a17:90b:518e:b0:356:3562:569c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58cb:b0:340:b572:3b7d
 with SMTP id 98e67ed59e1d1-354b3e2b23amr11589908a91.19.1770681836655; Mon, 09
 Feb 2026 16:03:56 -0800 (PST)
Date: Mon, 9 Feb 2026 16:03:54 -0800
In-Reply-To: <e81151ce-6e67-48e8-a722-da9ff03d686b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-21-seanjc@google.com>
 <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com> <aYYCOiMvWfSJR1AL@google.com> <e81151ce-6e67-48e8-a722-da9ff03d686b@intel.com>
Message-ID: <aYp16kCxBSthwtjf@google.com>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70676-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4ADFA115856
X-Rspamd-Action: no action

On Mon, Feb 09, 2026, Dave Hansen wrote:
> On 2/6/26 07:01, Sean Christopherson wrote:
> >  /* Bump PAMT refcount for the given page and allocate PAMT memory if n=
eeded */
> >  int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
> > @@ -2272,7 +2272,7 @@ int __tdx_pamt_get(u64 pfn, struct tdx_pamt_cache=
 *cache)
> >         if (ret)
> >                 goto out_free;
> > =20
> > -       scoped_guard(spinlock, &pamt_lock) {
> > +       scoped_guard(raw_spinlock_irqsave, &pamt_lock) {
> >                 /*
> >                  * Lost race to other tdx_pamt_add(). Other task has al=
ready allocated
> >                  * PAMT memory for the HPA.
> > @@ -2348,7 +2348,7 @@ void __tdx_pamt_put(u64 pfn)
>=20
> Why does this need to be a raw spinlock? irqsave, sure, but raw?

Huh, TIL.  (And just when I thought I finally had my head wrapped around RT=
 "spinlocks"):

  The hard interrupt related suffixes for spin_lock / spin_unlock operation=
s
  (_irq, _irqsave / _irqrestore) do not affect the CPU=E2=80=99s interrupt =
disabled state.

Ah, and running RCU callbacks from soft IRQ context is straight up disallow=
ed for
PREEMPT_RT.

  /* By default, use RCU_SOFTIRQ instead of rcuc kthreads. */
  static bool use_softirq =3D !IS_ENABLED(CONFIG_PREEMPT_RT);
  #ifndef CONFIG_PREEMPT_RT
  module_param(use_softirq, bool, 0444);
  #endif

So yeah, just spinlock_irqsave should be fine.  Though the way things are t=
rending,
it'll be a moot point if KVM ends up freeing S-EPT page tables from task co=
ntext.

> The page allocator locks are used in this context and aren't raw.



