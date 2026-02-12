Return-Path: <kvm+bounces-70954-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOEUAzvYjWng7wAAu9opvQ
	(envelope-from <kvm+bounces-70954-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:40:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C3F12DE38
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:40:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 54F5F3013DEE
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 13:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79EA35C182;
	Thu, 12 Feb 2026 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m79B6R6q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC82C3256
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 13:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770903600; cv=pass; b=lljrF39nwZxB7HrWvaGN/pEF8F/Ow1G4gZGSXEonKK2gW69F7LEirTF8Dl5Y2U/LiwjKVgJl0J3nro2p3PR+IL20HExxQSj6Jhq/TUS1vQa4rgbaJtFzR97RqpFhrGuTUasa9fT5tMBA2lFQOkgHXHLypvKT7drMalXlxGrWIVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770903600; c=relaxed/simple;
	bh=9m8jNJz+xkEuRnarQJnBRAM/+igZhD4KBk+Qsf+tgOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lFRETZZ+oJfmKumVHKaorU3AYuGFUnXnm2VhuS44LG+69VCiAsYF4psrd1S/eXqIT+q54A2foFFqMUBW3iJQJKCVGMVjI/A4kyGSlSyQaCcyQevht/fgKmMJjo2YJel/4jphO1WaCmhO7X/OyAajciaSn1LoRclIyxO5qMXy4dA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m79B6R6q; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38706b63929so14643811fa.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 05:39:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770903597; cv=none;
        d=google.com; s=arc-20240605;
        b=ZX4d3XYUE5zUnICj7OoKFDGCTmHQ8piFwFAhwGGjQwe6juwJfXgZZJCNYJWCS9mlKk
         UGlP161xVQ8kOXOisfwvzOnHBPqEh3oVb8C4rxYgcqSIpLdxAnxHcjqsGhRcG+BM+wHr
         ljZqOmLvjkjWIr43/42IM1netfsbMMSl0A3DhPkBI1RtEZLaK3mRFOifaBrMZtzUBjGm
         uF6pbM5dy6js//ceImxRKyPNVLlhggolURP+D7RuIwsDZaJ57oZGq/5OqyywcG25b4+s
         kvpZiwoZb2V3vX4MdQNm8pNHD+CyvA+p6HMXB521wuTQmwaF4H3dnxM8c/D/AK5oylKI
         nwVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9m8jNJz+xkEuRnarQJnBRAM/+igZhD4KBk+Qsf+tgOk=;
        fh=DTdj6R744nmp0CRybysc2Khf+hJXTaMkJNE+Uf/7nPg=;
        b=hgV5j0brX6NtJWCrSKv3sbyAISu3hDCzVk0UpryMWEqnAVQstzz3n080pBHxvSUDYE
         MLqu8Z5gKWv9dE+sMyXeYv/hw0lbzs1gZDFeW6O6FaIz6KuIx+p4qcCVyoX9Sn8wN8Ij
         q9v0XmmOqd8D5LCvSLJR2C2IGjou3DIzaBO97CdQwLEEZJ3LJ8rkRWA3Ek/28twVzOg8
         EVHbT7j3DYSkCHWiMTJcSwQ7M8FNuAzRidzGHVU8Bv6aeexQeP7oPAXrAYUI/7ob3Lhv
         nPEkq724mQSkxrzxfinh1x+NVWkvcZGopeh2wARw5Bz9xe779yaTs8Z7heV/ebTwrJZI
         o4kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770903597; x=1771508397; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9m8jNJz+xkEuRnarQJnBRAM/+igZhD4KBk+Qsf+tgOk=;
        b=m79B6R6q3s5d7NOlABkWgo+m1gDfQz4CN5ogzqFOiiLJd+kCBA6KOOLFOuZvResS4K
         GfWJhxPcKV1TF8F65Q4MlG+glJRcHzyi6zrNn8GAZz+byokMY3C9VdOVcL4rAXAVC4yV
         cvAMfXVnJvYht1/MxsuirrFZN7++DLQpYOW365dwGzeLUnid5hZXVqQIK1cEmMtSe+qV
         2qDtHh3moLpsaeh3w5Ge6JezklrhnWVqCeFLrJPRDWOPFHCqzVdvCIARveOG+zmzZ9ee
         f6+mugCCsZRYCIx4XAliwd35mwoy5DBc8sr354FvJ7ZrTs5RLEMRzXMQWrdhaNJpJkZR
         57Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770903597; x=1771508397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9m8jNJz+xkEuRnarQJnBRAM/+igZhD4KBk+Qsf+tgOk=;
        b=c4vTWQty4t1E0P2bcTv/eQ+dtpeRRYmVuW9CBh+Z+y/WBfqesH2+zq16zr+wDg4TFS
         5MR9Bk+BxgN80Zuf+Rd0EfidAPTN0qTubXV8NoIkchSSmG0k9ApI6Q/GU52Dfyun8tZG
         c4OuEIbkQ6ydsTQD0vz2axJ+wNtRd9NF9gRWfHRmQaKleTh4/4S7FO05AKsnOqwNksnK
         N2coNVApm4NNAZWwMbN8ry0wrrButUSiKqMvk8pRpltjrP887WbwZVqniCTEu1rMBzgZ
         Bwbw3LsUXoBLRPmIfzlc6iZTd2nm+JTMF3pNKcPWt+JeuvAPcsV3TfAd40gCEOnj1qj2
         TcbQ==
X-Gm-Message-State: AOJu0Yw7R0+JWfJ7LFx+CuJvYHo0t1KhUJ+9JKVgOCzCPdCGPTb0aBWi
	IaN1raxg3NqU4Eg3pLsPwYUgeECI57amanfgUYbLIVg3jy6BM9RNg1DkPqORq9HM76Ec1C2SWsO
	/Ci+VcycxIzzqzOQJwpMhuYkwVw3HnWI=
X-Gm-Gg: AZuq6aIboF1s3ou/2mAzxec6Q5wI81FplCTdga0hcQuc5IGzIuSVpybQxv8Qa32pBgI
	NzU5HoaJlTFtI9UnWbk02SPcIdXRA36sXLeO4YdSkuWnlRuErFWf2r3R8y63p0ln2grcoy+23Jw
	RLdw1hWD4nyuW8zeMyLlyemnyZu5sQNHu7v2Y15QZ8yfWTGyyym4MmYKAvRb34sLeqV2c1RKcFg
	3tbaqKrggC0AgqkRZACYxyQRTeE5Dffobg1mtERxxvl8YxDem43ONgQ+2WxGFdoMNRFrp4+obb2
	pERlitETrh6DKxxTHC4eoUmg7vyhRMyvzcl5V8Y064/CRr6tMQ==
X-Received: by 2002:a05:651c:19a3:b0:385:9b50:91a8 with SMTP id
 38308e7fff4ca-38712ac804emr7148331fa.15.1770903596628; Thu, 12 Feb 2026
 05:39:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212102854.15790-1-ubizjak@gmail.com> <0a1ad845-a15b-4901-a65c-2668580751ed@redhat.com>
In-Reply-To: <0a1ad845-a15b-4901-a65c-2668580751ed@redhat.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Thu, 12 Feb 2026 14:39:44 +0100
X-Gm-Features: AZwV_Qjy-ilu912nCI1gZDdU5Pll4W01zr5AoDRZwYuYXy7GLqBk5vtD_wKCVus
Message-ID: <CAFULd4Yyc=smi+bsY3FPLVd_jZxuHFUYOkH4enPQ=Z=OLe-GOw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix incorrect memory constraint for FXSAVE in emulator
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70954-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ubizjak@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 19C3F12DE38
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 2:05=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 2/12/26 11:27, Uros Bizjak wrote:
> > The inline asm used to invoke FXSAVE in em_fxsave() and fxregs_fixup()
> > incorrectly specifies the memory operand as read-write ("+m"). FXSAVE
> > does not read from the destination operand; it only writes the current
> > FPU state to memory.
> >
> > Using a read-write constraint is incorrect and misleading, as it tells
> > the compiler that the previous contents of the buffer are consumed by
> > the instruction. In both cases, the buffer passed to FXSAVE is
> > uninitialized, and marking it as read-write can therefore create a
> > false dependency on uninitialized memory.
> >
> > Fix the constraint to write-only ("=3Dm") to accurately describe the
> > instruction=E2=80=99s behavior and avoid implying that the buffer is re=
ad.
>
> IIRC FXSAVE/FXRSTOR may (at least on some microarchitectures?) leave
> reserved fields untouched.
>
> Intel suggests writing zeros first, and then the "+m" constraint would
> be the right one because "=3Dm" would cause the memset to be dead.

Please note that the struct is not initialized before fxsave, so if
"+m" is required, the struct should be initialized.

Uros.

