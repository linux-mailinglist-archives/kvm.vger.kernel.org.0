Return-Path: <kvm+bounces-3647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D69CB806398
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 01:43:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 925182821F1
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 00:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE2F81C;
	Wed,  6 Dec 2023 00:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QvTjp1Kl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511D8D3
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 16:43:16 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso2663a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 16:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701823395; x=1702428195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CGpNMJzqHfBBmrth6e1MGteUUzf7hdy/lyzvmA95dY=;
        b=QvTjp1KlEWSQySGsfIuBlHX2OhzZ6h7tYxCZcNM+Q5LS9XTLc0ChHEP78AUt0qDsha
         KzixpmwLIzoF87f0S/AoLpsnp3LagWd5hlzSmCBmZ4Dw7ue7yV2SsNUDinmhi91UaEqY
         8jjcA6sHmEHiJ07S7M6cfZrsPSJxd8BHReJzbYeWpWUsnu3W08X63VDzMp3V71dyYscr
         O+j7rB71uGXBloj74qhq+PoWiOzG+VN9/+ZDY2MQD4s9HCYElr/npFtHMpBVng5I0L55
         K0bd062uyRJH9q3y1MudQyAQpIo78DkObbrDvs0kPHiSJ9GfPAwhO/QiolkD+PrLn4Io
         mo5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701823395; x=1702428195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0CGpNMJzqHfBBmrth6e1MGteUUzf7hdy/lyzvmA95dY=;
        b=hghzs0mlRAWW0a1Mri7HEn0P9/4yRK/FihD+LC8vSNzmL8m02JU1Z04TwBLqplVsJS
         9tRT3neO2q+1UiaEJOpVh4BfGF86O9Z190+rhV9DcmfIFWVQpNAuQ23/45iNmP3oJji0
         J6JlrsdoHCpGS9t9z555VIxNBZPr9ECdGTuaIJPzwJeJAdeuCgW9/WgmyTwLagEwOpgH
         LYc+f8gXFKr+OFR+s2xyHxuUQJPgQFo7Kjm29vkKs2RdCARcozakVKF5LOhqGBo8C11C
         VztmZfP5nrkT0blweCVaJEtiHnQzJN7yBRQOIbNipJYsix7vHg/zsamJl9y99TW7c9ZI
         Pqlw==
X-Gm-Message-State: AOJu0Yw6XFF7/ZnS+l0SQNSxqMGNEayiXMSnHqaSNMMoh7y9ydPpabzw
	hJ4cpZGZYRJ5ggFa+aOVaKVj76oFwtZq7vYBpe3dKg==
X-Google-Smtp-Source: AGHT+IHnxQI+DCFCxmScTp7bseun1ubBzYz2vloVjxDiicjaclByuyc4HtX+jd86aOQ5xnHQeVkN+gBTvB5g8n8nI7I=
X-Received: by 2002:a50:c35d:0:b0:54c:79ed:a018 with SMTP id
 q29-20020a50c35d000000b0054c79eda018mr44800edb.2.1701823394564; Tue, 05 Dec
 2023 16:43:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <20231110220756.7hhiy36jc6jiu7nm@amd.com>
 <ZU6zGgvfhga0Oiob@google.com> <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
 <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
 <CAAH4kHb7cfMetpC=AYy=FjTTve6g0W8NZdeSwQ8uVxkqi2491Q@mail.gmail.com>
 <656f82b4b1972_45e012944e@dwillia2-xfh.jf.intel.com.notmuch>
 <CAAH4kHb9O9FeaTmNuNAkhrdrDLJPo8qgD5vNow3w-sY-DA4Ung@mail.gmail.com> <656fae221bf90_45e01294d2@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <656fae221bf90_45e01294d2@dwillia2-xfh.jf.intel.com.notmuch>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 5 Dec 2023 16:43:03 -0800
Message-ID: <CAAH4kHY0Bcq+nCLhX6XrqkR=Jb7eYcC+61n6F1J5qamOZxn4bA@mail.gmail.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com, 
	luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com, 
	pgonda@google.com, peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Brijesh Singh <brijesh.singh@amd.com>, dan.middleton@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> So it's not only SBOM that you are concerned about, but instead want to
> have a one stop shop for auxiliary evidence and get the vendors agree on
> following the same GUID+blob precedent that is already there for the AMD
> cert chain? That sounds reasonable, but I still feel it should be
> limited to things that do not fit into an existing ABI namespace.
>

The tl;dr is I want something simple for a hard problem and I'll
probably lose this argument.

The unfortunate state of affairs here is that it is "vendor dependent"
whatever pathway they choose to provide reference material for
attestations. Even with the RATS framework, "reference value provider"
is just a bubble in a diagram and not a federated service protocol
that we've all agreed on. TCG's recommendation for delivering the RIM
in the efi volume doesn't quite work in the cloud setting, since
images own that and not us as the firmware provider. There's no
standard for how to inform a user where to get a RIM other than that
:(

> ...unless its evidence / material that only a TVM would ever need.

There's the rub. Evidence may be provided to the TVM to forward to
verifiers, but really it's the verifiers that are tasked with
gathering all this attestation collateral. The TVM doesn't have to do
anything, even provide machine-specific certificates. That's pretty
dreadful system design though, since you end up with global services
in your hot path rather than getting cached data from the machine
you're getting an attestation from. My first stab at it is to just
have a storage bucket with objects named based on expected measurement
values, so you just construct a URL and download the endorsement if
you need it. I'd really rather just make that part of what the guest
can get from auxblob since they pay the bandwidth of forwarding it to
verifiers rather than my cost center paying for the storage bucket
bandwidth (is this the real reason I'm pushing on this? I'm unsure).

If you're instead asking if this information would need to get piped
to a non-TVM (say, a non-confidential VM with a virtual TPM), then the
answer is maa~aaa~aaybe but probably not. PCR0 in the cloud really
needs its own profile, since the TCG platform firmware profile (PFP)
is unsuitable. There's not a whole lot of point delivering a signed
endorsement of a firmware measurement that we don't include in the
event log anyway for stability reasons, even if that's against the PFP
spec. So probably not. I think we're pretty clear that host-cached
data would only need to be for TVMs.

If you ask the folks I've been talking to at Intel or NVIDIA, they'd
probably say to put a service in your dependencies and be done with
it; it's the vendor's responsibility to provide an available enough
service to provide all the evidence that an attestation verifier may
want. That's quite unfriendly to the smaller players in the field, but
maybe it's easy to integrate with something like Veraison's
endorsement provisioning API [1] or Intel's Trust Authority (n=C3=A9e
Project Amber). I haven't done it.

[1] https://github.com/veraison/docs/tree/main/api/endorsement-provisioning

--=20
-Dionna Glaze, PhD (she/her)

