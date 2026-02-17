Return-Path: <kvm+bounces-71157-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHFpLWSIlGmsFQIAu9opvQ
	(envelope-from <kvm+bounces-71157-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:25:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9F414D8CC
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:25:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 64FBA3036EEA
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 15:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A73322B74;
	Tue, 17 Feb 2026 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZsGZtrzG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2754280A29
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771341910; cv=none; b=dSxoE/+vY3KnEROiIeTF+ghtLqXxbuVSdY8SE/0El4Q0pbY4H8paN/uvSmpCnAtNHSSpv3/3d8pl1pi08Jt1TqPE79viymY9C0TV6cyp4wYif66tbE+WHo4PtOJnEX1hUDFNVgQodDkydLvV/8KuTX0blKeoAD/8C8ATgSDu2c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771341910; c=relaxed/simple;
	bh=hZGLZbsUH8EmvpSV7H/wOq9sFZLgXoLqGx+9AUKwexA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l3rRERDPHufERV9FbYZdhNr/js7COgdh4HOuqj/XTBilLiEixfm6LRf3BVrlIB/z0oigZfS1J973YCEIk65XLnOy/dwHNUTPVoZfocTsxreRBN2ACfyfEsFXN1zWGTMsRYA7gMQhOBIuA9xjKvj4IeGq0B1cGGRsVuxvLeYsSz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZsGZtrzG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e74e55d35so1304609a12.3
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 07:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771341908; x=1771946708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2a2DsZQIpKH+b2cksg0NQajbqrk+yeWf7k9R9erIIoo=;
        b=ZsGZtrzGuzeBgdczZTRIurJI5mVUmvciD0a0XQ3pZG8LoiC77yrXrt9kDnULZWdm9w
         rI1oIDX01tJr41lTN+EjkV54gUyQ0duCr292tL7DiYf5S2KTSFA6BGqxs6vZjpRmgeaF
         DF16WGUR+Jt+5fGlxTbejzALLe60ekL4ygSsi6ZamqMhA4RZol3wj1mA5srTf4mutNj4
         lrwdRJwsqIudkycNWsefrtI963vOY+SeZDnFB5/s9/nW57yt3ZmpF3jA5tzb1s0Kuvcf
         6OL+IRama4rNCMT0z5U5RX6KIB+cWcNxvbYx6Ys0Yf9PoQEx8EdFtOhImAx6q24SVBE/
         wEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771341908; x=1771946708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2a2DsZQIpKH+b2cksg0NQajbqrk+yeWf7k9R9erIIoo=;
        b=jpHAPCZTglBRotHUOaQ0tuUXMjfWF64LJNRrKtWMZEamyNFnhraKKSPb5M82hxyLnv
         okzubh23WEp6xWn3FN9N0vJENjMqhZoaDnAK7aabgW+0E0koa4UN6yer91GxaMdNNvuW
         zQEQGNii0eWyJc9EpaI/7JHubxYh2ccmhpMt0bVWmplZcbdkbJfRSySmTgOSE0na49lZ
         n8Wwc5SbQ+LvfObjZd2XX1YFUkAIZEEMjYVAtYJiwrmE+SdPk+X/Ref4l3ojiDVkR36N
         QLOXV/d7RmTD1BaEX0VQWU3iYWExRQy+Mgt7gFabCSOt7ZUAXk8SckMEJrsQYkrIzPbP
         Dsyg==
X-Forwarded-Encrypted: i=1; AJvYcCXymLlyg8ZNwMtwzKIS13rDgUYnfFYWWflcxsQwGFiyjV9J8CFvS1U2Rbgct4KgdL/5LZY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM5ehrduI/sBmPotnNe7g66I4b7XKSwDFSjcLKYsb6ModAPWYs
	bkBa1qG/e9TORoA4b3YprTmvxBV0JqFHsP80T+atFudZEgNhlh2vFZVOPKgAtiOPdR3aqVXGPC3
	HC+vYew==
X-Received: from pgvh6.prod.google.com ([2002:a65:6386:0:b0:c52:a841:c79d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2f98:b0:366:14af:9bd2
 with SMTP id adf61e73a8af0-3946c8f9745mr14478361637.72.1771341907789; Tue, 17
 Feb 2026 07:25:07 -0800 (PST)
Date: Tue, 17 Feb 2026 07:25:04 -0800
In-Reply-To: <4317ad31f4ef883daee264f72f032974c044c0cc.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com> <20260214012702.2368778-11-seanjc@google.com>
 <4317ad31f4ef883daee264f72f032974c044c0cc.camel@intel.com>
Message-ID: <aZSIUJ_NXAMLVWJM@google.com>
Subject: Re: [PATCH v3 10/16] x86/virt/tdx: Drop the outdated requirement that
 TDX be enabled in IRQ context
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tglx@kernel.org" <tglx@kernel.org>, 
	"namhyung@kernel.org" <namhyung@kernel.org>, "acme@kernel.org" <acme@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Dan J Williams <dan.j.williams@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71157-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4F9F414D8CC
X-Rspamd-Action: no action

On Tue, Feb 17, 2026, Kai Huang wrote:
> On Fri, 2026-02-13 at 17:26 -0800, Sean Christopherson wrote:
> > Remove TDX's outdated requirement that per-CPU enabling be done via IPI
> > function call, which was a stale artifact leftover from early versions of
> > the TDX enablement series.  The requirement that IRQs be disabled should
> > have been dropped as part of the revamped series that relied on a the KVM
> > rework to enable VMX at module load.
> > 
> > In other words, the kernel's "requirement" was never a requirement at all,
> > but instead a reflection of how KVM enabled VMX (via IPI callback) when
> > the TDX subsystem code was merged.
> > 
> > Note, accessing per-CPU information is safe even without disabling IRQs,
> > as tdx_online_cpu() is invoked via a cpuhp callback, i.e. from a per-CPU
> > thread.
> > 
> > Link: https://lore.kernel.org/all/ZyJOiPQnBz31qLZ7@google.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > 
> 
> Hi Sean,
> 
> The first call of tdx_cpu_enable() will also call into
> try_init_module_global() (in order to do TDH_SYS_INIT), which also has a
> lockdep_assert_irqs_disabled() + a raw spinlock to make sure TDH_SYS_INIT is
> only called once when tdx_cpu_enable() are called from IRQ disabled context.
> 
> This patch only changes tdx_cpu_enable() but doesn't change
> try_init_module_global(), thus the first call of tdx_cpu_enable() will still
> trigger the lockdep_assert_irqs_disabled() failure warning.
> 
> I've tried this series on my local and I did see such WARNING during
> boot[*].  We need to fix that too.
> 
> But hmm, Chao's "Runtime TDX module update" series actually needs to call
> tdx_cpu_enable() when IRQ disabled, IIUC, since it is called via
> stop_machine_cpuslocked():
> 
> https://lore.kernel.org/kvm/20260212143606.534586-18-chao.gao@intel.com/
> 
> Maybe we can just keep tdx_cpu_enabled() as-is?

Can't we simply delete the lockdep assert there as well?  It should be totally
fine to have a function that can be called from task or IRQ context, so long as
the function is prepared for that possibility.  I.e. just because it _can_ be
called from IRQ context doesn't mean it _must_ be called from IRQ context.

E.g. as a fixup

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index bdee937b84d4..f8f5e046159b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -106,8 +106,7 @@ static __always_inline int sc_retry_prerr(sc_func_t func,
 
 /*
  * Do the module global initialization once and return its result.
- * It can be done on any cpu.  It's always called with interrupts
- * disabled.
+ * It can be done on any cpu, and from task or IRQ context.
  */
 static int try_init_module_global(void)
 {
@@ -116,8 +115,6 @@ static int try_init_module_global(void)
        static bool sysinit_done;
        static int sysinit_ret;
 
-       lockdep_assert_irqs_disabled();
-
        raw_spin_lock(&sysinit_lock);
 
        if (sysinit_done)

