Return-Path: <kvm+bounces-42286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1280A773CC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36B293A6C9E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 05:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4DA1DC9B8;
	Tue,  1 Apr 2025 05:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="kDAtkLct"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEE72111;
	Tue,  1 Apr 2025 05:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743484487; cv=none; b=hBAw7NTPUhfNdr7XVIeWtaQrX1z2t6Hc9jY6au2QNENDzziCJ5/xL1ajM/tY8gXtZM9ajoGapG4J3VXFEkWgwcVIOUslmWV2zTWFd4ayKqDbvB4M71V+j3ect0GtymkKjuVMpGN/UluJuyc00r7TlPdSViPbjq2cNNIfQ5j5DGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743484487; c=relaxed/simple;
	bh=L4FrkKu0168YmHHVcoVFsbWR9Sf3R8pkxT3Lnke5KJM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=kq0BZkUZj+rKs/heVI0z4MoitmLUM28mox3pFFb+vX5ZSVpSDbdu5AP8n2zA4s8WbQ+A77+l4VWlPn3qdUUDUjaRrK1s6gpQA3wBzmYVqMI7zCN7UXOzu1XLdm0L3AWrACoKkoVZL8dZ9QgH/XAmtFSBLCHLUyhmDQbvxiZZgZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=kDAtkLct; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5315DrPW3571921
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 31 Mar 2025 22:13:53 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5315DrPW3571921
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743484436;
	bh=fXArKFGaxt8nFnaWBdSW+pU45Be8cuJJXPIK/BFyt00=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=kDAtkLct4ESsM95J+GAXm6Ip9nS2vCeNnpZd5bqqzetTLzyI1dGpO4FHTdCywuUb7
	 WGNeXx4i+jLpuQrfsgKmAO//REzlRpcJIhlg3BiQafg1GzI6ikQM3j7rveeHHx8qEQ
	 CWx/fzNgtVCbn/YdOsKRTX3+ivqNDh7QpvYGnD8XTDDfehr8TQnDZRQ5T6cB2w2NXq
	 sNL/9PBtrg1oFPYF0fJT9aZRbEjTs4UCCHnnJFtzzQgDFxprnhDKMIRSwjt3dTD6q1
	 Lo7DVLOnslrIY9K+rdbbOdFCWR3dM3o3/+miqBEdIWuSpByt20GZTiNiujHjtNVCBm
	 M4aSJPmJLqUXA==
Date: Mon, 31 Mar 2025 22:13:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-edac@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
CC: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v1_01/15=5D_x86/msr=3A_Re?=
 =?US-ASCII?Q?place_=5F=5Fwrmsr=28=29_with_native=5Fwrmsrl=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <0da43a86-81b0-4388-b47b-3a76b15f2a4c@citrix.com>
References: <20250331082251.3171276-1-xin@zytor.com> <20250331082251.3171276-2-xin@zytor.com> <0da43a86-81b0-4388-b47b-3a76b15f2a4c@citrix.com>
Message-ID: <03874E9B-FAEB-4ACA-B13D-0BED7D54F443@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On March 31, 2025 2:45:43 PM PDT, Andrew Cooper <andrew=2Ecooper3@citrix=2E=
com> wrote:
>On 31/03/2025 9:22 am, Xin Li (Intel) wrote:
>> __wrmsr() is the lowest level primitive MSR write API, and its direct
>> use is NOT preferred=2E  Use its wrapper function native_wrmsrl() inste=
ad=2E
>>
>> No functional change intended=2E
>>
>> Signed-off-by: Xin Li (Intel) <xin@zytor=2Ecom>
>
>The critical piece of information you're missing from the commit message
>is that the MSR_IMM instructions take a single u64=2E
>
>Therefore to use them, you've got to arrange for all callers to provide
>a single u64, rather than a split u32 pair=2E
>
>~Andrew

That being said, there is nothing wrong with having a two-word convenience=
 wrapper=2E

