Return-Path: <kvm+bounces-43327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E702A89450
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 08:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 583C83AA635
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 06:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438122797A8;
	Tue, 15 Apr 2025 06:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YCTksIhB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95CE18DB2F;
	Tue, 15 Apr 2025 06:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744700271; cv=none; b=OSz7f2Odq+Ge9h0XuAFBFSxLbP4ZEAFNtbiiE0HQcyaplQY433rygBqM6kiB/LXqPAZ1bppTvOJ2QrgfncPDd3WOo+TZj7BdaEOZMi1uzoJfvdqSWq3CN3o0pXqMZ1KRtHBjUL6bTUZjJ6LO/mMq0UlP22l0MVhImz+Cpx29KRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744700271; c=relaxed/simple;
	bh=tEL///cSukVzcGZZ+2nvW1x1tC0cDrQQQifctHJH11o=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=EJnZD9txx1Hr5BYWgGsO+m3VtFHIpbVUakQ5AsrG0vRUYGDXl0ugxohBY+Xa5fANwsdkoN5MxWb9GB/HkVsiLjlx5kvRU644DINu0nTv8NxX8pSEoOESyeogBbERHMRbORSnLj6ammLceC6DULPK13+QquCNN8HfwUNq9H8Q9tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YCTksIhB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53F6unIB2639618
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 14 Apr 2025 23:56:50 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53F6unIB2639618
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744700212;
	bh=tEL///cSukVzcGZZ+2nvW1x1tC0cDrQQQifctHJH11o=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=YCTksIhBMy5xplKGhKrpvDh+Gt4mtL5UACeLF4lslUD1VbrgQuefYVuMy0mei/Q60
	 vdGgLY87TG/KgIIPPcUrpz6SBT/6R3SCkZ+mQgyRjw0lb2t8Z6V/DQuBdKKBVkDe+6
	 dRzEAkOrIYGAMUNvTt4/aZ57QFtr4kcQPeum8uV8El7RCdX3ykwKs8rLpr1awvDFX1
	 umsqFcRaAuHx6n2uvOGXI6BLdb5fvTagOGQLqqGtBW5qmxwGylfYFOFTGabqO9jMtD
	 +PmCyVIUbPX92wEig0ZdnACF2Cws0xiPBLd5Sq9WMGFTT/VPR9E/iDGKXpwNHIR5BM
	 tHMRkCne6bI6g==
Date: Mon, 14 Apr 2025 23:56:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
CC: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com, haiyangz@microsoft.com,
        decui@microsoft.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v1_10/15=5D_KVM=3A_VMX=3A_Use_WR?=
 =?US-ASCII?Q?MSRNS_or_its_immediate_form_when_available?=
User-Agent: K-9 Mail for Android
In-Reply-To: <0cad1e0b-2bfd-4258-90cd-8d319bf0e74a@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-11-xin@zytor.com> <Z_hTI8ywa3rTxFaz@google.com> <CALMp9eRJkzA2YXf1Dfxt3ONP+P9aTA=WPraOPJPJ6C6j677+6Q@mail.gmail.com> <fa16949e-7842-45f7-9715-1bdda13b762a@zytor.com> <EAB44BB2-99BB-4D4A-8306-0235D2931E72@zytor.com> <0cad1e0b-2bfd-4258-90cd-8d319bf0e74a@zytor.com>
Message-ID: <D212FABE-38FE-45D3-A082-CA819CCFFF95@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 14, 2025 10:48:47 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 4/12/2025 4:10 PM, H=2E Peter Anvin wrote:
>> Also,*in this specific case* IA32_SPEC_CTRL is architecturally nonseria=
lizing, i=2Ee=2E WRMSR executes as WRMSRNS anyway=2E
>
>While the immediate form WRMSRNS could be faster because the MSR index
>is available *much* earlier in the pipeline, right?

Yes, but then it would be redundant with the virtualization support=2E

