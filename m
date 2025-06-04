Return-Path: <kvm+bounces-48414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A13ACE125
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF12B3A831D
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9011940A1;
	Wed,  4 Jun 2025 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="FrpnwNfA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDE32F56;
	Wed,  4 Jun 2025 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749050596; cv=none; b=m3xUZzLG/KKbuUk0A3a4NIIiQFEDDd4KKB4PXMd19xKb3s8V0rIIGy+ESEfU+PiIReSfrgGdZ6Su5rkC5gogY5Ou+UnE8NvWbJzMRl3guy49AAzZU6ccIXa+grsO8Qtq/1DKwbtIQFlAbUO4oNYnb2UQsCTH+eiDrHGsMJNaC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749050596; c=relaxed/simple;
	bh=+lJcxQsjxseXi30qNXRxLB/y4R9OszpeMs9veRimWYg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=S3EuJH0cFS3iFjGR8OuOEgU1Yva3OFQxtqD1qtiKSdwnDPWYCXuFKJ6JXuZKy82LRxvaAlYI6YckCIkndnOBRobAvYtkJgO1OpttS6MIjKD9yVFc3rQZ8RB6MsazK5GeWr4ie2kTklh1NV3HgHFNM7ikjax95iCc+lxWw51VPWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=FrpnwNfA; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 554FMJIY076049
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Jun 2025 08:22:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 554FMJIY076049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749050541;
	bh=NH2ltXtujZBqPJip4ancgNjYxroWFHWZyGX2p6NKPXc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=FrpnwNfA/rikkJwUqKavu+F3qP9DFDYIsBfs2A92z5aoMEvnWjkzfYojMhs98JXRn
	 coeiXRhu75/wIJvdUSGvYY6BwK9I1KouJwNAN9odFoW5uUFHS1MptMWQREGT0rX2f8
	 f6g6Q+cKIDEwQr8ORjzbF/t8oAIDaV9I+VMh75ax64t/EXUvl1y9/YnGNaWTT3lOUj
	 2eXE0GUVgUxeIwkM/KBWkZkei92+bxbvFBLoD15xH8xydiCwjaggxg4UL8HaEoDOUz
	 9ubB5Ku2C0uIWI1JSB4rzj+lfkQJeNqgS7twCkpv4PK+6euX/WeKwfNCvb4OXiSErp
	 ZqMFdhLraiD6A==
Date: Wed, 04 Jun 2025 08:22:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Dave Hansen <dave.hansen@intel.com>, Sohil Mehta <sohil.mehta@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
CC: Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
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
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
User-Agent: K-9 Mail for Android
In-Reply-To: <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com> <20250513203803.2636561-5-sohil.mehta@intel.com> <e978e1fb-d88e-4789-bd33-367281dfa0ad@intel.com>
Message-ID: <31DB6043-44B2-43C1-B312-9B0DEC23C500@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 3, 2025 10:23:42 AM PDT, Dave Hansen <dave=2Ehansen@intel=2Ecom> wr=
ote:
>On 5/13/25 13:37, Sohil Mehta wrote:
>=2E=2E=2E
>> + * Vector 2 is reserved for external NMIs related to the Local APIC -
>> + * LINT1=2E Some third-party chipsets may send NMI messages with a
>> + * hardcoded vector of 2, which would result in bit 2 being set in the
>> + * NMI-source bitmap=2E
>
>This doesn't actually say what problem this causes=2E Is this better?
>
>	Third-party chipsets send NMI messages with a fixed vector of 2=2E
>	Using vector 2 for some other purpose would cause confusion
>	between those Local APIC messages and the other purpose=2E Avoid
>	using it=2E
>
>> + * The vectors are in no particular priority order=2E Add new vector
>> + * assignments sequentially in the list below=2E
>> + */
>> +#define NMIS_VECTOR_NONE	0	/* Reserved - Set for all unidentified sour=
ces */
>> +#define NMIS_VECTOR_TEST	1	/* NMI selftest */
>> +#define NMIS_VECTOR_EXTERNAL	2	/* Reserved - Match External NMI vector=
 2 */
>> +#define NMIS_VECTOR_SMP_STOP	3	/* Panic stop CPU */
>> +#define NMIS_VECTOR_BT		4	/* CPU backtrace */
>> +#define NMIS_VECTOR_KGDB	5	/* Kernel debugger */
>> +#define NMIS_VECTOR_MCE		6	/* MCE injection */
>> +#define NMIS_VECTOR_PMI		7	/* PerfMon counters */
>> +
>> +#define NMIS_VECTORS_MAX	16	/* Maximum number of NMI-source vectors */
>
>Would an enum fit here?
>
>You could also add a:
>
>	NMIS_VECTOR_COUNT
>
>as the last entry and then just:
>
>	BUILD_BUG_ON(NMIS_VECTOR_COUNT >=3D 16);
>
>somewhere=2E
>
>I guess it's a little annoying that you need NMIS_VECTOR_EXTERNAL to
>have a fixed value of 2, but I do like way the enum makes the type explic=
it=2E
>
>
>>  static int __init register_nmi_cpu_backtrace_handler(void)
>>  {
>> -	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_b=
t", 0);
>> +	register_nmi_handler(NMI_LOCAL, nmi_cpu_backtrace_handler, 0, "arch_b=
t", NMIS_VECTOR_BT);
>>  	return 0;
>>  }
>
>=2E=2E=2E Oh you replaced _most_ of the random 0's in this patch=2E That =
helps
>for sure=2E

The "may" here is important=2E *Most* sources are expected to send these a=
s either a programmable MSI or as LINT1, which is programmable in the APIC,=
 but since the vector hasn't mattered, we can't rule out that some hardware=
 might have been built to send an MSI with a hard-coded vector, in which ca=
se it is most likely they send either 0, 2 or 255=2E 0 and 255 will set the=
 unknown source bit (0), but 2 is a legitimate source so it is defensive pr=
ogramming to leave it fallow=2E

Note also that although the current implementation is limited to 15 source=
s (+ the unknown/lost source bit), the architecture allows for up to 63=2E

