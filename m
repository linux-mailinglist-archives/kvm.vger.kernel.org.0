Return-Path: <kvm+bounces-43198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52540A87036
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 01:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 228BD8A121D
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 23:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E82230BF9;
	Sat, 12 Apr 2025 23:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="lMBig7n3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B68B38385;
	Sat, 12 Apr 2025 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744499495; cv=none; b=TXPgZ9muWRN+Mm+EKUEy1M+jnFzLdHI3EB1Px7usmziRebLEL1dDI6T+THRhPMgiOiF/BIooaWVVxVMtV8pZZAJieC6FWYe0SzfvnZZPV9qccjCXidEePrYMTc3bdTtmoDloaKqDBuBqRm+3s352k7fTr9HSGjZQFSvBZ33NLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744499495; c=relaxed/simple;
	bh=Z8ANyn5BO+4YSxFMj2ZIePI2Es9dy8Hv6toZ4ucWxdY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=oxV3o//yquRg90stwy5WFdPY7nwqVebyJ0TO1q6PLe9ttFBhflg9Q37Jt3dB3ncPBAf/hm/OFIloiJoRHVmgCPgzFaB0fW07aWiRXGUJe9zPyegDrzbOTFNqPn19lndi212o1n2vrj5VzKYurEs20ZOBOwcMV3q246un7E1N5/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=lMBig7n3; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53CNA8tE1265382
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sat, 12 Apr 2025 16:10:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53CNA8tE1265382
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1744499412;
	bh=Z8ANyn5BO+4YSxFMj2ZIePI2Es9dy8Hv6toZ4ucWxdY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=lMBig7n3wyGQ77xYpn5pnxKVN4QM3Vkq6hDZcLvPaFwS2PWF/n09rzmm4i6ZIrSlX
	 ldJKqqxh7XGdq6n0fK1xSbkbF0eDIoNvUz2LhiGL+7mwgnCfFlBgBbxU3imjGP8GwY
	 zTU8dvf1jWNkf6+mSxkledPR0XPGAcZA1I9f+5+YiIA5YgCTj3M0isuBNWaO1BHck1
	 A5Uh/ZdjOxEnzIwdlikBQnfr1jA4LYpMjCETWZHP0OeiOO0PyexivLyItY7m/buoB1
	 Qlv5YTi1XbrFcCf8wBQrrImS7wL6ntMIDtBYRTjjMB9jzG1ZKHtxezcpa9pVk9CqYV
	 YnyFnuF53LDCw==
Date: Sat, 12 Apr 2025 16:10:06 -0700
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
In-Reply-To: <fa16949e-7842-45f7-9715-1bdda13b762a@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-11-xin@zytor.com> <Z_hTI8ywa3rTxFaz@google.com> <CALMp9eRJkzA2YXf1Dfxt3ONP+P9aTA=WPraOPJPJ6C6j677+6Q@mail.gmail.com> <fa16949e-7842-45f7-9715-1bdda13b762a@zytor.com>
Message-ID: <EAB44BB2-99BB-4D4A-8306-0235D2931E72@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 11, 2025 9:32:32 PM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 4/11/2025 2:12 PM, Jim Mattson wrote:
>> Surely, any CPU that has WRMSRNS also supports "Virtualize
>> IA32_SPEC_CTRL," right? Shouldn't we be using that feature rather than
>> swapping host and guest values with some form of WRMSR?
>
>Good question, the simple answer is that they are irrelevant=2E

Also, *in this specific case* IA32_SPEC_CTRL is architecturally nonseriali=
zing, i=2Ee=2E WRMSR executes as WRMSRNS anyway=2E

