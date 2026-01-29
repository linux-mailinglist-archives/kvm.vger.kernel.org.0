Return-Path: <kvm+bounces-69497-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6A7hMQ+3emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69497-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 646E5AAB20
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:25:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E0FBA305E7C7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E780318B94;
	Thu, 29 Jan 2026 01:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sCG1+xWZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E901220F2C
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649579; cv=none; b=nYb4VxeiYA6zaSXKRo6g/HlWy4Il1VR43tKJS+U/HNx80Irx2Bx6XaklKRGh/j19r5d0kw5jPg88OuI5bFR+LpM2NbzEBtFefseKANBxEzkw/KW7tegYPFmZu1sTFUypuChB2wUXjtqemEys48DwoEoiy9Edzas0sD9JlseI2ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649579; c=relaxed/simple;
	bh=N+QyvnWxDVedfV60nIPXz2BLfDkafQEWajomelBvAfc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MEsuELKgwFUxM/QgjGlYLJ311fgLzPG36tZ/yfIZa+9s/GAZsX1wKQXbxMRPKobwXK+qFJQnzkkVn4+Zn0LbZ73QT8xN+aohW/r31pAODJND3p44yHO0hjLZP5yPu62ixsCuYClvZCIMuRiDH/IqCl/jki2xZ1tLpA7caSJHQVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sCG1+xWZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so3346385ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649577; x=1770254377; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KUWpkf61OLZzwLN40a0cMfTvRxuTXwySwnIOe/Ktyd4=;
        b=sCG1+xWZjLRQB6Fp3R9IKrO6lzPwH09j+xI01+DSdcIQjua3KUP8X+Kz4e69Lzd1AP
         Xf5sGtH/sU5YpZ650LjugE/kynXde2LpVvNsrHSZbfBYTjI3nugQcE6husGxNSrTCGhP
         IESk4s+zDBu27FLRqNzEj2N1i36j71pOtC9Xp0X9Igx9Wrlph7jYVjCyzT3r7IC91ueu
         9b7xMrkxqNYEl82EXw/Etj7NlFkSVJoC54x/+pfz0i46huPSNfrwb810BvMdQwms2Rg3
         znrM74E/mwHz2Pkj/WX0e/0aqGCNvDe4uPu427Bz9SH/NmrqipS3ojPD9cdsGvfnB8oQ
         XRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649577; x=1770254377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUWpkf61OLZzwLN40a0cMfTvRxuTXwySwnIOe/Ktyd4=;
        b=NZkaQVEzwLbguWotgR2PwIruir6gy+0m8JVxdSmHFjiLgFho8YiAJTdimlXKeUrfCE
         xDD5hPvXawnCAsZcmfVBOlJKZOTPMHcz224BVjPYGshR8wPzAuzPMlNvS4UfjYTieIy7
         pw+4F+igpP6l2eoSbWPURgavageRWx4g9WpcwVaZsm21QDwJCUWTKC2hsQIryvRYPmCH
         e8X67MBHVfp78Q+FNsAwHTIjd2Vz72Q2o9SxT81a+p/bfYcMgTmKnn/fpB1rz8rdL5lw
         eZkDb3SuJIkaZ7ok4VreyRdpo4W8DQE4xqlw/lEwjvMMPNqvZeDSiRXdLQIebA+r+GPK
         LZRw==
X-Forwarded-Encrypted: i=1; AJvYcCUbd0qo+h6tlRl6B+FCOSfTjGBM37cFR6gajxiK2P4SBdtE2f2sLGxpwSXzW+KDT5sHS4w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2IeAYxhv9mbzupQoXQ0R1ISqFO13pRVGoSBshAXLV2TUk5uzY
	PLXkHMQNnwh9rh5tXhZMOvQRXCguttSoCheWkZoxTXaGGVq2o8PGVON+qBXHPVBPXUCpfmXhe8T
	OSXGmFw==
X-Received: from pjboj17.prod.google.com ([2002:a17:90b:4d91:b0:34c:2f52:23aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3286:b0:347:6c59:c728
 with SMTP id adf61e73a8af0-38ec624806dmr6538143637.8.1769649577604; Wed, 28
 Jan 2026 17:19:37 -0800 (PST)
Date: Wed, 28 Jan 2026 17:19:36 -0800
In-Reply-To: <67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com> <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
 <67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com>
Message-ID: <aXq1qPYTR8vpJfc9@google.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Binbin Wu <binbin.wu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	Vishal Annapurve <vannapurve@google.com>, Chao Gao <chao.gao@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69497-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 646E5AAB20
X-Rspamd-Action: no action

Gah, forgot to hit "send" on this.

On Wed, Nov 26, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-11-25 at 16:09 +0800, Binbin Wu wrote:
> > On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> > > +/*
> > > + * The TDX spec treats the registers like an array, as they are ordered
> > > + * in the struct. The array size is limited by the number or registers,
> > > + * so define the max size it could be for worst case allocations and sanity
> > > + * checking.
> > > + */
> > > +#define MAX_TDX_ARG_SIZE(reg) (sizeof(struct tdx_module_args) - \
> > > +			       offsetof(struct tdx_module_args, reg))
> > 
> > This should be the maximum number of registers could be used to pass the
> > addresses of the pages (or other information), it needs to be divided by sizeof(u64).
> 
> Oops, right.
> 
> > 
> > Also, "SIZE" in the name could be confusing.
> 
> Yes LENGTH is probably better.
> 
> > 
> > > +#define TDX_ARG_INDEX(reg) (offsetof(struct tdx_module_args, reg) / \
> > > +			    sizeof(u64))

Honestly, the entire scheme is a mess.  Four days of staring at this and I finally
undertand what the code is doing.  The whole "struct tdx_module_array_args" union
is completely unnecessary, the resulting args.args crud is ugly, having a pile of
duplicate accessors is brittle, the code obfuscates a simple concept, and the end
result doesn't provide any actual protection since the kernel will happily overflow
the buffer after the WARN.

It's also relying on the developer to correctly copy+paste the same register in
multiple locations: ~5 depending on how you want to count.

  static u64 *dpamt_args_array_ptr_r12(struct tdx_module_array_args *args)
                                   #1
  {
	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_TDX_ARGS(r12));
                                                            #2

	return &args->args_array[TDX_ARG_INDEX(r12)];
                                               #3


	u64 guest_memory_pamt_page[MAX_TDX_ARGS(r12)];
                                                #4


	u64 *args_array = dpamt_args_array_ptr_r12(&args);
                                                   #5

After all of that boilerplate, the caller _still_ has to do the actual memcpy(),
and for me at least, all of the above makes it _harder_ to understand what the code
is doing.

Drop the struct+union overlay and just provide a helper with wrappers to copy
to/from a tdx_module_args structure.  It's far from bulletproof, but it at least
avoids an immediate buffer overflow, and defers to the kernel owner with respect
to handling uninitialized stack data.

/*
 * For SEAMCALLs that pass a bundle of pages, the TDX spec treats the registers
 * like an array, as they are ordered in the struct.  The effective array size
 * is (obviously) limited by the number or registers, relative to the starting
 * register.  Fill the register array at a given starting register, with sanity
 * checks to avoid overflowing the args structure.
 */
static void dpamt_copy_regs_array(struct tdx_module_args *args, void *reg,
				  u64 *pamt_pa_array, bool copy_to_regs)
{
	int size = tdx_dpamt_entry_pages() * sizeof(*pamt_pa_array);

	if (WARN_ON_ONCE(reg + size > (void *)args) + sizeof(*args))
		return;

	/* Copy PAMT page PA's to/from the struct per the TDX ABI. */
	if (copy_to_regs)
		memcpy(reg, pamt_pa_array, size);
	else
		memcpy(pamt_pa_array, reg, size);
}

#define dpamt_copy_from_regs(dst, args, reg)	\
	dpamt_copy_regs_array(args, &(args)->reg, dst, false)

#define dpamt_copy_to_regs(args, reg, src)	\
	dpamt_copy_regs_array(args, &(args)->reg, src, true)

As far as the on-stack allocations go, why bother being precise?  Except for
paranoid setups which explicitly initialize the stack, "allocating" ~48 unused
bytes is literally free.  Not to mention the cost relative to the latency of a
SEAMCALL is in the noise.

/*
 * When declaring PAMT arrays on the stack, use the maximum theoretical number
 * of entries that can be squeezed into a SEAMCALL, as stack allocations are
 * practically free, i.e. any wasted space is a non-issue.
 */
#define MAX_NR_DPAMT_ARGS (sizeof(struct tdx_module_args) / sizeof(u64))


With that, callers don't have to regurgitate the same register multiple times,
and we don't need a new wrapper for every variation of SEAMCALL.  E.g.


	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];

	...

	bool dpamt = tdx_supports_dynamic_pamt(&tdx_sysinfo) && level == PG_LEVEL_2M;
	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
	struct tdx_module_args args = {
		.rcx = gpa | pg_level_to_tdx_sept_level(level),
		.rdx = tdx_tdr_pa(td),
		.r8 = page_to_phys(new_sp),
	};
	u64 ret;

	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
		return TDX_SW_ERROR;

	if (dpamt) {
		if (alloc_pamt_array(pamt_pa_array, pamt_cache))
			return TDX_SW_ERROR;

		dpamt_copy_to_regs(&args, r12, pamt_pa_array);
	}

Which to me is easier to read and much more intuitive than:


	u64 guest_memory_pamt_page[MAX_TDX_ARGS(r12)];
	struct tdx_module_array_args args = {
		.args.rcx = gpa | pg_level_to_tdx_sept_level(level),
		.args.rdx = tdx_tdr_pa(td),
		.args.r8 = PFN_PHYS(page_to_pfn(new_sp)),
	};
	struct tdx_module_array_args retry_args;
	int i = 0;
	u64 ret;

	if (dpamt) {
		u64 *args_array = dpamt_args_array_ptr_r12(&args);

		if (alloc_pamt_array(guest_memory_pamt_page, pamt_cache))
			return TDX_SW_ERROR;

		/*
		 * Copy PAMT page PAs of the guest memory into the struct per the
		 * TDX ABI
		 */
		memcpy(args_array, guest_memory_pamt_page,
		       tdx_dpamt_entry_pages() * sizeof(*args_array));
	}

