Return-Path: <kvm+bounces-48416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F96ACE194
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A03A7ADD05
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B677A1DF96F;
	Wed,  4 Jun 2025 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="CWJt10XU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CA148832;
	Wed,  4 Jun 2025 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749051018; cv=none; b=b9eWPggKb9+8TkORa1qA2jL94T5LBe7DIi7JUIEYsJGaKWjF/JxfD8BCSZ3eo2c+AIlzCuPX9St/ME+Ny5tEu4yufoDapa+F5sHjC0tUOt97ppWDOpjDm8QjXeGxB65ZFfzqrTED6QQOjgAJKbiXXpTno0iQdKVf6Qu9zZgEePk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749051018; c=relaxed/simple;
	bh=IntO0/FbgwhgBAN77s9LpsP+6ciHFlDY2+k3/nq5G/0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Y2pTv81BJuPKeFdbEm7hrBizyHlqGLt8SevGA1k6MLJGXiWEnZ9HmqnEvw4M7JSFw5anBs08eMd1m21r51Wq1bU1dAO8SeCaJ8KbzyvuA8/xLWLrDXiusj+u68j+1U42ZJFn+Ig4PfQUMoTYtYcOTLn/mFiVDOiHISiXrxV9X7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=CWJt10XU; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 554FTfWR079172
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Jun 2025 08:29:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 554FTfWR079172
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749050983;
	bh=06DGrvhu1rhRSkUp5M4yyd9dVBhB/k8I9ffulUUuiZ4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=CWJt10XUfOPx1/nx9ZCg8yilsk+XhK7WFpAKz7w3Pr/GVmjyx931ADKMUVWGo0Cf9
	 BK9swHAH6bLOv/AKCFf89kclJ1EVrzrOE5ozFO583Wit4qvaHJslPf69jO+Xb10G/y
	 HDSkkCzpr8N1DBmV8tHNlTC8h/mVHLiic7FH6lWq0osexW4hVU8viTdhORNcLc+p/i
	 dwHVhQJyhp+6OyOsKaysK8dMKK1zQmc1U0WCq3uvvRuPwkrwsLOyzkXBvK/6OA+No7
	 f3TRDnipWQlRTtZnqnOhpWwXoiRZ3Q3qSirfp4/fq7x4AzXRpbjWyBI3ueoLvzfcrm
	 Vu0ZiW4gOySHw==
Date: Wed, 04 Jun 2025 08:29:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Sohil Mehta <sohil.mehta@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
CC: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_9/9=5D_x86/nmi=3A_Print_source_inf?=
 =?US-ASCII?Q?ormation_with_the_unknown_NMI_console_message?=
User-Agent: K-9 Mail for Android
In-Reply-To: <31507dc8-b1dc-4df3-bc0c-6958b4218746@zytor.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com> <20250513203803.2636561-10-sohil.mehta@intel.com> <31507dc8-b1dc-4df3-bc0c-6958b4218746@zytor.com>
Message-ID: <CC71F714-803B-44F3-A46D-308B75FB3FD0@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 3, 2025 9:55:32 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 5/13/2025 1:38 PM, Sohil Mehta wrote:
>> +	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
>> +		pr_emerg_ratelimited("NMI-source bitmap is 0x%lx\n", fred_event_data=
(regs));
>
>"0x%04lx"?

Seems unnecessary to me to zero-pad it; it just makes small numbers harder=
 to read=2E We don't even use vector 12+ at this time, do we?

