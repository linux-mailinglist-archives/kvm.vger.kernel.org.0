Return-Path: <kvm+bounces-71624-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGuhJm3MnWnfSAQAu9opvQ
	(envelope-from <kvm+bounces-71624-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:06:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F192B18987C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB6053112583
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712A43A7828;
	Tue, 24 Feb 2026 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eruSefUa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7E3A4F5E
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949000; cv=none; b=pvpYi81WsCnbJzyqxsxvWJUgpWjH7ervYsdR2NK+f6/UQ6ShjySNHSt6xvWYnhsD5NGFuGob3mIqQY2a0RoS0cfPuNHGbLsTalucgiIkuLQIayacGWREgmQR/YS/nVj4Nbav8AxFH4GB9xahMe31sSlglh4vjcpMQj+Hvmjvycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949000; c=relaxed/simple;
	bh=SOGQy7+puNM/ba13/nSnregfmqZzlkrJ68UTA3YXxRU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kOxyNR89aeguQyroWElkfNxOvGb2Qk2bMesWI8uGbSgq2zeU3/ZluIp1Vv66y3LwBCtUaOqgh6EQDf2+6WZ/CZNNM8PPatbCf2oEOnTJfw6xk4JbKYMoXEKi69hRuId8HBQuZAmkrDsywdvI/t4Y72xtTegAkp8aM/50gx3+KZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eruSefUa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6136af8e06so3563393a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771948998; x=1772553798; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p31fbkWSCceudE7NtBIgU6iz/jD9HBtJctESA+fNTjk=;
        b=eruSefUaFLQaZBlJ5Hp8FGggSqqYOKEYMkK6Wee3IBJ9wkivduEWRVb683N2aeQtTf
         yz8PfcgurQVvbDdgGBiptQ46f5LpV3g5Ug1BLlzcUR1JE+2rJ4uRMJ2Aqdly7L9oa9L/
         sTzXSww2T0r8ozqyQxMhWr14Gc8tUe2S0nJyitjyVvK7W9heoaKntD9snaMBzOI4CjR5
         /8qTBFM6nkfKyPKcipN77GLR2AjWmWNH/zh0sTqareBgldM8v819bKGvgPC2riyxPE6y
         RrdMMl4EwWZX4jvnAjoIQxk3gk2rLxK5yra6H7WXoF+ctmSBb8l3q9LwcxCNdds9hZXh
         yo4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771948998; x=1772553798;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p31fbkWSCceudE7NtBIgU6iz/jD9HBtJctESA+fNTjk=;
        b=tQZxDrBfaZlTJMuMRDNuPGwsN9pn12gz3p6Cs/k2dJe2zNh8Bn3QZ20fTWwQcAlX7J
         8GKZlWoSGpUXBENtoV8auXLjehM1MzOKAtie8YjRi5Lv9+WYAN1bFvJXGEaaIc6KY//p
         8g+ajcK8eZqitZG+6WtoxFwXZ9hwQhfYhS/hA6w93eyJ23D7t6lANWWKRNkDQlBADcU6
         7bHf2J4x66vY79GrVGAAb92wi6Ykk7/28Pbwqddg9X/IvTGtE07mO8sAQ02/7C+UvB/f
         9WKYZ6XUK7fFy8krD87I9/7zrL+ZYbV+X0bnxj18Gmcd9IlzM5VL1NYPyKlWEtSEkF9m
         H0gQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZPRlBUDPfJq8UKguLoVhADlIilqcvq+4WDivSwIKC/RopoO/ujqxXVBeSnHOkq5f+EPk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPTiRkosGaiViOXXCc0DxKLdp9+L+F5yZ5OLbaxfvSm9jgDSBG
	eZMEFEnJ3xFkC5Bm3au9LAcWTeFSnyYQNzIUFDE+nkRNONdnVxx2UbTuhbh/r3CiFg7owTYMcKq
	gNEwbsA==
X-Received: from pgcv16.prod.google.com ([2002:a05:6a02:5310:b0:c16:a39f:5b40])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:898b:b0:394:a026:4c74
 with SMTP id adf61e73a8af0-39545f7d1f2mr10096820637.40.1771948998111; Tue, 24
 Feb 2026 08:03:18 -0800 (PST)
Date: Tue, 24 Feb 2026 08:03:16 -0800
In-Reply-To: <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223214336.722463-1-changyuanl@google.com>
 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com> <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
Message-ID: <aZ3LxD5XMepnU8jh@google.com>
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"changyuanl@google.com" <changyuanl@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Binbin Wu <binbin.wu@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71624-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F192B18987C
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Binbin Wu wrote:
> On 2/24/2026 9:57 AM, Edgecombe, Rick P wrote:
> >> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> >> index 2d7a4d52ccfb4..0c524f9a94a6c 100644
> >> --- a/arch/x86/kvm/vmx/tdx.c
> >> +++ b/arch/x86/kvm/vmx/tdx.c
> >> @@ -172,9 +172,15 @@ static void td_init_cpuid_entry2(struct
> >> kvm_cpuid_entry2 *entry, unsigned char i
> >> =C2=A0	entry->ecx =3D (u32)td_conf->cpuid_config_values[idx][1];
> >> =C2=A0	entry->edx =3D td_conf->cpuid_config_values[idx][1] >> 32;
> >> =C2=A0
> >> -	if (entry->index =3D=3D KVM_TDX_CPUID_NO_SUBLEAF)
> >> +	if (entry->index =3D=3D KVM_TDX_CPUID_NO_SUBLEAF) {
> >> =C2=A0		entry->index =3D 0;
> >> +		entry->flags &=3D ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> >=20
> > There are two callers of this. One is already zeroed, and the other has
> > stack garbage in flags. But that second caller doesn't look at the
> > flags so it is harmless. Maybe it would be simpler and clearer to just
> > zero init the entry struct in that caller. Then you don't need to clear
> > it here. Or alternatively set flags to zero above, and then add
> > KVM_CPUID_FLAG_SIGNIFCANT_INDEX if needed. Rather than manipulating a
> > single bit in a field of garbage, which seems weird.

+1, td_init_cpuid_entry2() should initialize flags to '0' and then set
KVM_CPUID_FLAG_SIGNIFCANT_INDEX as appropriate.

> >> +	} else {
> >> +		entry->flags |=3D KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> >> +	}
> >> =C2=A0
> >> +	WARN_ON_ONCE(cpuid_function_is_indexed(entry->function) !=3D
> >> +		=C2=A0=C2=A0=C2=A0=C2=A0 !!(entry->flags &
> >> KVM_CPUID_FLAG_SIGNIFCANT_INDEX));
> >=20
> > It warns on leaf 0x23 for me.=C2=A0Is it intentional?
>=20
> I guess because the list in cpuid_function_is_indexed() is hard-coded
> and 0x23 is not added into the list yet.

Yeah, I was anticipating that we'd run afoul of leaves that aren't known to
the kernel.  FWIW, it looks like 0x24 is also indexed.

> It's fine for existing KVM code because cpuid_function_is_indexed() is
> only used to check that if a CPUID entry is queried without index, it
> shouldn't be included in the indexed list.
>=20
> But adding the consistency check here would cause compatibility issue.
> Generally, if a new CPUID indexed function is added for some new CPU and
> the TDX module reports it, KVM versions without the CPUID function in
> the list will trigger the warning.

IMO, that's a good thing and working as intended.  WARNs aren't inherently =
evil.
While the goal is to be WARN-free, in this case triggering the WARN if the =
TDX
Module is updated (or new silicon arrives) is desirable, because it alerts =
us to
that new behavior, so that we can go update KVM.

But we should "fix" 0x23 and 0x24 before landing this patch.

