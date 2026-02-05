Return-Path: <kvm+bounces-70348-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JjRGzDGhGk45QMAu9opvQ
	(envelope-from <kvm+bounces-70348-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 17:32:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4DDF5470
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 17:32:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F18B3063A39
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 16:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5570E438FF7;
	Thu,  5 Feb 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2sLjwk00"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794CA438FE5
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 16:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308968; cv=none; b=jLAhpURLjDsdJsfr8ZOwYkiS8tdLYnGihGl6tdoHDh2pahMEbmlZiQvezonOO+p0XnfOK4aUJmGs3dwiwOcPEKdjtli1kWsJB/kElVh3nF+9sTF3KbFuo2X+sW508m1kZh0XGm8zk0pbK0t+51fzwOsDwkINcJWzOcAoPj5LSQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308968; c=relaxed/simple;
	bh=vZO/61lSQobupRA52ism1k91f8SSJ19uGRMSgNVUWDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bq8uUlfy2jxwObMACEMxUMnENzSmEFiufF0kp++tejgOoPRpjkRiwiyhGGFaQr2QN5HVj02gaD0Qq7S2RrMQUwWQh672mbvf/cc1aROeO4DmpumclDs8dN9xwxPMAAMnq092/q2YFsmbxZZjQaQQgl/jc8tVDY9J9x0EVBvYuwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2sLjwk00; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c636238ec57so757278a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 08:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770308968; x=1770913768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=brn1uDcN21+M3nqos+ToSMsJASFwbWfm4IhWvM2xjBA=;
        b=2sLjwk00wAWdzsHxuwsAs3hncPBFDXtxKoscTkTfHzhINtGAWY0IZuzB9jgFcjIAGc
         ddoTck0BGw+PqwpSMT97C8WytmO8+KWF/ek0o+rpCTUaGePv7yBc61soQ9b3U4XmR/xf
         sxgOgeKNzxzZf9BrLWWCfWiNB85135wraEkJhKRbig2fr7VFN8Y9DXGnxAqrTujIE4c6
         xHzFMnsK5sAMC9+Gwr0bb09Q9/sP8XoRLEyptap8nf6qVX8wS9AHv31s5riRdNUuRMP2
         HCAXB0HOaxpHNir4/iSDzR+ywPdxxZ/gSoXm+OHSmYhKkvtTUpdKc/cAMpUb+VmlzleX
         9nNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770308968; x=1770913768;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=brn1uDcN21+M3nqos+ToSMsJASFwbWfm4IhWvM2xjBA=;
        b=k1gcqx8f4vdyY3swv2jUIkX5y6L1GXkKRmQZOLpxGJgVgrL8ZBW31pWfKU8d+Ghn8R
         10DuirSWSmAFyTx78UjAqvfqbr/DySf2dIBjU/7PL4ir633lRVx8XVKkmN+dMrOTshZb
         5ZkmD1qNhyGyPvlCKk0Q6tkTDJiv1TaiVpjDn+IbMHo/OIhQzJ7i8UYUfom7WrK9126D
         v2MpnkVG9lkuKLX84k4nLb8wcWUplSZ2hs8mJ4O9dHLVOwtVoZgK4Artyfkfk7xm2mGh
         HN5ff5l4nS25oj5lpiFzHbNVMmo3jAHU3U/e/pMDRWich9Cg2TV34cTkO42r6ZdS2yp+
         lSGg==
X-Forwarded-Encrypted: i=1; AJvYcCWhFLkwRKjtd9MH3x71qVrW9CvJf6RgHfgXV2/jr6dHMj1P/AIv28ZZXNuG9hJ//fMFGPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxozb7B+Bt/wbHjYf56WuS6zol2ACTWR0dpRwetbvut6T/kocf
	WJRLA2VsDv7/YbFgnUg6VVeJM/xirwytaRqVy9SoLJtdauJi+c65oWr+ZhCh7q23kka2Ett+ZSu
	vZ/poTA==
X-Received: from pgmc27.prod.google.com ([2002:a63:1c5b:0:b0:bc0:ea34:538])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a94:b0:38d:ee68:2c55
 with SMTP id adf61e73a8af0-39372073827mr6943091637.15.1770308967830; Thu, 05
 Feb 2026 08:29:27 -0800 (PST)
Date: Thu, 5 Feb 2026 08:29:26 -0800
In-Reply-To: <aYKKnf7K3lRdUcxl@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123145645.90444-1-chao.gao@intel.com> <20260123145645.90444-8-chao.gao@intel.com>
 <301f8156-bafe-440a-8628-3bf8fae74464@intel.com> <aXywVcqbXodADg4a@intel.com>
 <fedb3192-e68c-423c-93b2-a4dc2f964148@intel.com> <aYHmUCLRYL+JX1ga@intel.com>
 <aYIXFmT-676oN6j0@google.com> <aYKKnf7K3lRdUcxl@intel.com>
Message-ID: <aYTFZv9Mf_FqWM_k@google.com>
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com, 
	dan.j.williams@intel.com, yilun.xu@linux.intel.com, sagis@google.com, 
	vannapurve@google.com, paulmck@kernel.org, nik.borisov@suse.com, 
	zhenzhong.duan@intel.com, rick.p.edgecombe@intel.com, kas@kernel.org, 
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com, 
	Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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
	TAGGED_FROM(0.00)[bounces-70348-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EF4DDF5470
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Chao Gao wrote:
> >On Fri, Jan 30, 2026 at 8:23=E2=80=AFAM Dave Hansen <dave.hansen@intel.c=
om> wrote:
> >> On 1/30/26 00:08, Chao Gao wrote:
> >> > AFAIK, this is a CPU implementation issue. The actual requirement is=
 to
> >> > evict (flush and invalidate) all VMCSs __cached in SEAM mode__, but =
big
> >> > cores implement this by evicting the __entire__ VMCS cache. So, the
> >> > current VMCS is invalidated and cleared.
> >>
> >> But why is this a P-SEAMLDR thing and not a TDX module thing?
> >
> >My guess is that it's because the P-SEAMLDR code loads and prepares the =
new TDX-
> >Module by constructing the VMCS used for SEAMCALL using direct writes to=
 memory
> >(unless that TDX behavior has changed in the last few years).  And so it=
 needs
> >to ensure that in-memory representation is synchronized with the VMCS ca=
che.
> >
> >Hmm, but that doesn't make sense _if_ it really truly is SEAMRET that do=
es the VMCS
> >cache invalidation, because flushing the VMCS cache would ovewrite the i=
n-memory
> >state.
>=20
> My understanding is:
>=20
> 1. SEAMCALL/SEAMRET use VMCSs.
>=20
> 2. P-SEAMLDR is single-threaded (likely for simplicity). So, it uses a _s=
ingle_
>    global VMCS and only one CPU can call P-SEAMLDR calls at a time.
>=20
> 3. After SEAMRET from P-SEAMLDR, _if_ the global VMCS isn't flushed, othe=
r CPUs
>    cannot enter P-SEAMLDR because the global VMCS would be corrupted. (no=
te the
>    global VMCS is cached by the original CPU).
>=20
> 4. To make P-SEAMLDR callable on all CPUs, SEAMRET instruction flush VMCS=
s.
>    The flush cannot be performed by the host VMM since the global VMCS is=
 not
>    visible to it. P-SEAMLDR cannot do it either because SEAMRET is its fi=
nal
>    instruction and requires a valid VMCS.

No, this isn't the explanation.  I found the explanation in the pseudocode =
for
SEAMRET.  The "successful VM-Entry" path says this:

  current-VMCS =3D current-VMCS.VMCS-link-pointer
  IF inP_SEAMLDR =3D=3D 1; THEN
    If current-VMCS !=3D FFFFFFFF_FFFFFFFFH; THEN
      Ensure data for VMCS referenced by current-VMC is in memory
      Initialize implementation-specific data in all VMCS referenced by cur=
rent-VMCS
      Set launch state of VMCS referenced by current-VMCS to =E2=80=9Cclear=
=E2=80=9D
      current-VMCS =3D FFFFFFFF_FFFFFFFFH
    FI;
    inP_SEAMLDR =3D 0
  FI;

I.e. my guess about firmware (probably XuCode?) doing direct writes was cor=
rect,
I just guessed wrong on which VMCS.  Or rather, I didn't guess "all".

> The TDX Module has per-CPU VMCSs, so it doesn't has this problem.
>=20
> I'll check if SEAM ISA architects can join to explain this in more detail=
.

