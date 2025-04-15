Return-Path: <kvm+bounces-43356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70474A8A502
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 19:08:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82FB34428EB
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 17:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4F3218EB9;
	Tue, 15 Apr 2025 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WhE95lEV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BF22DFA4F;
	Tue, 15 Apr 2025 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744736890; cv=none; b=KyHL87JWKokV0W0b5lKliSUtx4R+KInGhsUzj8ghuFJUYerTM1oc5GB4oaoIjZw/sWePE5jfQIbYvUZhnyPzLqfuJ5pgz8K7bgH5KvwzlOfP0uAof/NFpQ24KJ93w2RVQAQuqwVcg2aJ94iiDbHzIeeP8bQebAqD1XQzdRDrOvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744736890; c=relaxed/simple;
	bh=ks0jrFHArrBhG+gklxA2J2EYohMH9zdshNRVwNuGI7o=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=jh0GNSXhyNutn+5FSldYC/4aYN2ksWMJOyuPIypIgj14Jg3ee4NJ/VzuqY4qz1MLynSKLvVbrTqFwsxOOl1kUNVgM5bwrtveCzXM3JmOoEJ/Yy0uHaSsXOZgV7a81AMMhv3qYKBa5CEJavkkJsjEbQKR85gkdUFsei6+TQv866E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WhE95lEV; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53FH73ta2925188
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 15 Apr 2025 10:07:04 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53FH73ta2925188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744736825;
	bh=ks0jrFHArrBhG+gklxA2J2EYohMH9zdshNRVwNuGI7o=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=WhE95lEVDeqFGhmykheloCvIa6ec/L8hMkhyTQr4nggCQ2MNaB7hQEnWWqckSYu1M
	 FE/9lDKGBEsoxf1Fo/4TYjWfKG76tlO1rnm1kp56okVOdII9+UvHjC6xjsPgkldKF/
	 /Q1USB71Bg7FETpP89gzIM+/TSWjQPfMrln6Vm6Fs3trJnlHEknKcSEVnAn35LwL3B
	 BtdNdByM7Ug96H+fmgHGlD77jXZNMMvnEE6HU+LJ8nK+7UhdSrlyP9wLK8cDaKhR1R
	 9aDa46yO3/W/rBR4d9umQD8jDcaEpM7DfRECTnLjrbzw2a/RBUSJ+b/LP4FJciRNSQ
	 WUVFIq1GFqr6w==
Date: Tue, 15 Apr 2025 10:07:01 -0700
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
In-Reply-To: <c4fcb208-ee5d-4781-85ce-3b75e651d047@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-11-xin@zytor.com> <Z_hTI8ywa3rTxFaz@google.com> <CALMp9eRJkzA2YXf1Dfxt3ONP+P9aTA=WPraOPJPJ6C6j677+6Q@mail.gmail.com> <fa16949e-7842-45f7-9715-1bdda13b762a@zytor.com> <EAB44BB2-99BB-4D4A-8306-0235D2931E72@zytor.com> <0cad1e0b-2bfd-4258-90cd-8d319bf0e74a@zytor.com> <D212FABE-38FE-45D3-A082-CA819CCFFF95@zytor.com> <c4fcb208-ee5d-4781-85ce-3b75e651d047@zytor.com>
Message-ID: <B2461564-F050-463D-8679-122724559D07@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 15, 2025 10:06:01 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 4/14/2025 11:56 PM, H=2E Peter Anvin wrote:
>>> arlier in the pipeline, right?
>> Yes, but then it would be redundant with the virtualization support=2E
>>=20
>
>So better to drop this patch then=2E

Yeah, if it gets pulled in as a consequence of a global change that is OK =
but the local change makes no sense=2E

