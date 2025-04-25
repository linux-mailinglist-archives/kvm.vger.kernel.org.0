Return-Path: <kvm+bounces-44341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB74EA9D2C6
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5AA17E08C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 20:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FC821FF35;
	Fri, 25 Apr 2025 20:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LoudM2O5"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF7018DB02;
	Fri, 25 Apr 2025 20:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745612044; cv=none; b=sp91BArNqj6Phs9RWqq1MVLvwgfgUHUJ4KqFkOmKpLEUbAkITnWByLNJz6YiCTxjKGE6I4buakGEE1x8oO6XJPBHsI4wk6rE/QETq/FCSmm1Q7SUHYpkr45s6xS2nvM0Kv81p/v0i0NfL8yLNeVqeBUVx92rAgrwNj6eKEJmii0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745612044; c=relaxed/simple;
	bh=Pgn/TZ1ujuuwbnzguLrmQLLDyPec5k7g882M+f0Gsi8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=M9+r+P3gfZZetmZPbQhgWB/kwEhQGCGOHh6DMLbBvuv28JJuzmumxl9PNeMdB0spGiXuGhjl55np4YEU91C1+fiudletsi2dNvqfI4/I0LQHK7DAkDRM+XiIbBUTghzGQUMTt+PIEkszl1ft79YZ0NKgeLvpx8STCVscfwmNI/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LoudM2O5; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53PKCYWU3252234
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 25 Apr 2025 13:12:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53PKCYWU3252234
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745611957;
	bh=Pgn/TZ1ujuuwbnzguLrmQLLDyPec5k7g882M+f0Gsi8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=LoudM2O5Ggb8UKAE6BloQQgcPc3DDE93Uie4tiM2kEIfkYTDiUipcf8Neu/KvASRD
	 bE9VD4R7oFqzmvtHTCFXcREprEax191bGlgx7zIbx5omdo51jLm5RkfhQX4yDbIVRa
	 GVL5VijALlpGtEZskIkKxZJvEBt7FnMylbJIzjd/5nwjnzxaNo83Yy1fNK7XF6PF8t
	 DnRu+iOKDqlUdSjj+DZ7GCvEpBZIZH9XdMoGw1VbkegsrdCwgEQlt1Pl2oarHuisPj
	 gl4+pko/7dDkS+MuVeY76Vou/tfvTznub+Ylyb0SFF25MRCp2uGdpU5pdOUWL4jNE7
	 1qvVj2z6FqDTA==
Date: Fri, 25 Apr 2025 13:12:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: =?ISO-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, acme@kernel.org,
        andrew.cooper3@citrix.com, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: =?US-ASCII?Q?Re=3A_=5BRFC_PATCH_v2_21/34=5D_x86/msr=3A_Utiliz?=
 =?US-ASCII?Q?e_the_alternatives_mechanism_to_write_MSR?=
User-Agent: K-9 Mail for Android
In-Reply-To: <35979102-2eb2-4566-b32a-f2b02ded8ae6@suse.com>
References: <20250422082216.1954310-1-xin@zytor.com> <20250422082216.1954310-22-xin@zytor.com> <b2624e84-6fab-44a3-affc-ce0847cd3da4@suse.com> <f7198308-e8f8-4cc5-b884-24bc5f408a2a@zytor.com> <37c88ea3-dd24-4607-9ee1-0f19025aaef3@suse.com> <20250425123317.GB22125@noisy.programming.kicks-ass.net> <35979102-2eb2-4566-b32a-f2b02ded8ae6@suse.com>
Message-ID: <D4ADDBA5-D9B8-4DD5-8D83-8CD482700E71@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On April 25, 2025 5:51:27 AM PDT, "J=C3=BCrgen Gro=C3=9F" <jgross@suse=2Eco=
m> wrote:
>On 25=2E04=2E25 14:33, Peter Zijlstra wrote:
>> On Wed, Apr 23, 2025 at 06:05:19PM +0200, J=C3=BCrgen Gro=C3=9F wrote:
>>=20
>>>> It's not a major change, but when it is patched to use the immediate
>>>> form MSR write instruction, it's straightforwardly streamlined=2E
>>>=20
>>> It should be rather easy to switch the current wrmsr/rdmsr paravirt pa=
tching
>>> locations to use the rdmsr/wrmsr instructions instead of doing a call =
to
>>> native_*msr()=2E
>>=20
>> Right, just make the Xen functions asm stubs that expect the instructio=
n
>> registers instead of C-abi and ALT_NOT_XEN the thing=2E
>>=20
>> Shouldn't be hard at all=2E
>
>Correct=2E And for the new immediate form we can use ALTERNATIVE_3()=2E
>
>
>Juergen

Yes; in the ultimate case there are *four* alternatives, but the concept i=
s the same and again we have it implemented already=2E

