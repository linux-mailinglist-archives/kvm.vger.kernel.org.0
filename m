Return-Path: <kvm+bounces-72928-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKYOIEjNqWl+FQEAu9opvQ
	(envelope-from <kvm+bounces-72928-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:36:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD8921707F
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 19:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1CA8D3018415
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 18:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA5B3D5247;
	Thu,  5 Mar 2026 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X59brTXW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345CC3A1E84
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772735810; cv=none; b=sg7f36B4yZyQ5wWoSUMEuZSBs1iebEP015C0I9VKs665GedduTrNNqd/xEQ8RRErelMHfPkF1YqZAXwT+uc4Rxd9G78ArOGjZkTGVh0vx4HrhAhJVjH7aC8ZHocAsaIrZRPdYMWmnmmyIHuFH9aqAdDcxYW2eHk6U3olK2y3q/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772735810; c=relaxed/simple;
	bh=/nCQbIM9WF/udWJhsd5kHZLLjcm5NPQ7KZuVjgfTAQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tFY4QDqpLHIbtClqVy7XT5R4btyT9bDLR+zeSjvVT6quYdD0Y0P5ReZFJQpjjXY9FjBDELPh65j+Wcltx7Y1eDGhqbvOHsfGEZJgV/t/8uCS3e6MbIj+cpevJ4IRVdUQC9R0crg/qijZ/6ch9AxG/DJmeddrzCoOKVYJs3TOtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X59brTXW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae6dd98043so18778775ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 10:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772735808; x=1773340608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8SIBi7LZpDXEzALEhfUg4rA5WlAeQaGU2tPtYlr/3VA=;
        b=X59brTXWvkeP9yGA5NDRQwh8Ho2KBhhdtJHwTbnzc7iTs/Fv+M6CplU9BlK5K8/Ezz
         cvqfxDttg57fiLahuA93ZrpD79L90Hh9hPid59JRwHkCim19pWIw3eZsM9+6O3ywxc7D
         mnUuZNn37UKNL7SmO931MAKh9wUDm1Ika8/+OGvPoJ6UuAu9fn2XoeKuzcrPMFfSOEIp
         4obyHzwJQfXNDMuQ7f0K48JLhZ0/u6X9QCa4qCESKrsJkRETLqVTLEdbnOjDu8Hn6aT+
         Rp5XR+o59EmkVsFE76eIJJhXWxkqMrAJkxxVjOg/XAzgHpMo4HxATt/NrO/hjQrnH+UJ
         x5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735808; x=1773340608;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8SIBi7LZpDXEzALEhfUg4rA5WlAeQaGU2tPtYlr/3VA=;
        b=T94yMg/Fa30qrNLl3Gl4e6LAq8ean1UrxrjXMNqnpGdSE7lO5NVLSIZ5SruFLFu51e
         iaVUfijSEf7iQLZf06+nQlam5ncL9fBQ4ydEfSvqZw/2xvLo76phHmo7YwIeO+2HqdLa
         89lBZ9oD76pzqO3oaGHkm0kB6e3mtHQQeRyjLpDQ5/Ui1OfuQtsAE2F1oVyF4jsQkBe5
         ALxSf+NDgxUY0O1kq9lFWJH7rcgAfwJCzyF/HUnBJi25svE7ZnanICijyVMKBDwIFPjf
         LpvlD6+DDnKRFXZwTG6219s2aXk4WjNIL9VlntHSgTyGGIeybb57nJ0UiDa7kAPSV/db
         mtVw==
X-Forwarded-Encrypted: i=1; AJvYcCUw3srA3wyx7ZoQkyxUMnMjD/UFIKAHRmtkauknbUgpAU5v6GAkxbnBk6EMphhKTr9xm34=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9XMudkXOIGuTEUMU6KZdeHlEapGTSpuw/UDVVPnPgwZ+BaDKp
	JvNRqsek3omIDEKAGHPvOcYouZTM8iH98ja9M9I9W0rlHwFKFo3FvOiFDcFyxLEjBFu0brQJZn9
	lr458dw==
X-Received: from pldq21.prod.google.com ([2002:a17:902:c9d5:b0:2ae:635f:4b2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2443:b0:2ae:7f28:124b
 with SMTP id d9443c01a7336-2ae7f281273mr9581445ad.22.1772735808319; Thu, 05
 Mar 2026 10:36:48 -0800 (PST)
Date: Thu, 5 Mar 2026 10:36:47 -0800
In-Reply-To: <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org>
 <da02314c-e6da-4d9e-a2c8-cd3ee096bc0c@embeddedor.com> <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org>
Message-ID: <aanNPwnH7l-j61Ds@google.com>
Subject: Re: [PATCH] KVM: x86: Fix C++ user API for structures with variable
 length arrays
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, keescook@chromium.org, daniel@iogearbox.net, 
	gustavoars@kernel.org, jgg@ziepe.ca, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EAD8921707F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72928-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[15];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> Commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
> flexible-array members") broke the userspace API for C++. Not just in
> the sense of 'userspace needs to be updated, but UAPI is supposed to be
> stable", but broken in the sense that I can't actually see *how* the
> structures can be used from C++ in the same way that they were usable
> before.
>=20
> These structures ending in VLAs are typically a *header*, which can be
> followed by an arbitrary number of entries. Userspace typically creates
> a larger structure with some non-zero number of entries, for example in
> QEMU's kvm_arch_get_supported_msr_feature():
>=20
>     struct {
>         struct kvm_msrs info;
>         struct kvm_msr_entry entries[1];
>     } msr_data =3D {};
>=20
> While that works in C, it fails in C++ with an error like:
>  flexible array member =E2=80=98kvm_msrs::entries=E2=80=99 not at end of =
=E2=80=98struct msr_data=E2=80=99
>=20
> Fix this by using __DECLARE_FLEX_ARRAY() for the VLA, which is a helper
> provided by <linux/stddef.h> that already uses [0] for C++ compilation.
>=20
> Also put the header fields into a struct_group() to provide (in C) a
> separate struct (e.g 'struct kvm_msrs_hdr') without the trailing VLA.

Unless I'm missing something, this is an entirely optional change that need=
s to
be done separately, especialy since I want to tag this for:

  Cc: stable@vger.kernel.org

I definitely don't hate the __struct_group definitions, but I don't know th=
at I
love them either as they make the code a bit harder to read, and more impor=
tantly
there's a non-zero chance that defining the new structurs could break users=
pace
builds and force an update, e.g. if userspace already concocts its own head=
er
overlay, which would be very unpleasant for a stable@ patch.

If we do define headers, I think I'd want a wrapper around __struct_group()=
 to
prettify the common case and force consistent naming, e.g.

#define kvm_struct_header(NAME, MEMBERS...)				\
	__struct_group(NAME ##_header, h, /* no attrs */, MEMBERS)

struct kvm_msrs {
	kvm_struct_header(kvm_msrs,
		__u32 nmsrs; /* number of msrs in entries */
		__u32 pad;
	);

	__DECLARE_FLEX_ARRAY(struct kvm_msr_entry, entries);
};

But that's likely going to lead to some amount of bikeshedding, e.g. arguab=
ly
kvm_header() would be sufficient and easier on the eyes.  Which is all the =
more
reason to handle it separately.

> Fixes: 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with fle=
xible-array members")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 29 ++++++++++++++++++-----------
>  include/uapi/linux/kvm.h        |  9 ++++++---
>  /* for KVM_GET_PIT and KVM_SET_PIT */
> @@ -397,8 +402,10 @@ struct kvm_xsave {
>  	 * The offsets of the state save areas in struct kvm_xsave follow
>  	 * the contents of CPUID leaf 0xD on the host.
>  	 */
> -	__u32 region[1024];
> -	__u32 extra[];
> +	__struct_group(kvm_xsave_hdr, hdr, /* no attrs */,
> +		__u32 region[1024];
> +	);

This is *very* misleading, as XSTATE itself has a header, but this is somet=
hing
else entirely (just the always-allocated region).

> +	__DECLARE_FLEX_ARRAY(__u32, extra);
>  };

There are several structs that got missed:

  kvm_pmu_event_filter
  kvm_reg_list
  kvm_signal_mask
  kvm_coalesced_mmio_ring
  kvm_cpuid
  kvm_stats_desc

