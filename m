Return-Path: <kvm+bounces-48415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B66FACE18E
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1935D7AD7D2
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134DD1C8601;
	Wed,  4 Jun 2025 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AOA9SBIM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB3D18DF8D;
	Wed,  4 Jun 2025 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749050962; cv=none; b=rQQZgWcC3ytY38eLbEbMuiL+dZanbWhlpK+LNv1gKJYynaNiOSmS1Rw9dMKHAYv9BHvAsWeonmt84kcsjSAbERBA07XkPy7M/o2nNcMRFXO7Yp1WnwIznm8QXTwz+by28INw/Kq/XR2CEQ0G5T5uvKU+tUkYjWskSxsFQhTcGuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749050962; c=relaxed/simple;
	bh=yOPlVwOdBaCxv/hYR1dfCxac+RC2Px2OphoTFgWqb08=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=VEJz2S1UnVhvz2JrZqY/xQ6ZR/kV8klWoU2ozBsyi4BwzDG2kQDbHa5ZZUU75AebvaMhRHlqARBIls0aeVTTXNnwmu6EMaqP0LN+ymmOwNFBU4S+wf/jYfBT1UKkyGlPjUxRAHtXevlCrg2a/oAAIQ/KU7/6r9zfqpRA89ra7mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AOA9SBIM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 554FSkr1079064
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Jun 2025 08:28:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 554FSkr1079064
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749050928;
	bh=dE+jTKIPauF7hwDHqLlJtFcIx6waYjcvh/bfpQweklA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=AOA9SBIMpV8B5nRKyCCcF42qOBFrO+8k0vN9qoDjZqjtEJap6hFo0LhTZS28bE/Bb
	 Wdh6AwjD6S1uI0CTBHoTrK0o7fy1mU1SGcwmdH3CwAMpXEM+xlL9F7d7hBl3gue0jx
	 LGD0+ZboRARuYz5po+uN8knuH7T39lKBDro+UtUF1MZLOMmrzcJ7oh/CcZAZQsDNGl
	 6FcVlAE3xVjnOT86xexXlRMx+DTETf2s7RICbhkP8dREiwrzcudYan+zUiFUvzGexR
	 4JITeXdoKs6HFOl4Q1nazWoCV4a85a07PmW4IPSM96eIcS5Wfv3KEewuITNBXnysCq
	 KaAJ0qRtIFAiw==
Date: Wed, 04 Jun 2025 08:28:47 -0700
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
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
User-Agent: K-9 Mail for Android
In-Reply-To: <9950dc5a-05ab-4a7c-a4e8-34012ef98549@zytor.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com> <20250513203803.2636561-5-sohil.mehta@intel.com> <9950dc5a-05ab-4a7c-a4e8-34012ef98549@zytor.com>
Message-ID: <FEE77392-D778-4412-B4B7-583EF58955EB@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On June 3, 2025 9:34:27 AM PDT, Xin Li <xin@zytor=2Ecom> wrote:
>On 5/13/2025 1:37 PM, Sohil Mehta wrote:
>> Prior to NMI-source support, the vector information was ignored by the
>> hardware while delivering NMIs=2E With NMI-source, the architecture
>> currently supports a 16-bit source bitmap to identify the source of the
>> NMI=2E Upon receiving an NMI, this bitmap is delivered as part of the F=
RED
>> event delivery mechanism to the kernel=2E
>>=20
>> Assign a vector space of 0-15 that is specific to NMI-source and
>> independent of the IDT vector space of 0-255=2E Being a bitmap, the
>> NMI-source vectors do not have any inherent priority associated with
>> them=2E The order of executing the NMI handlers is up to the kernel=2E
>
>I'm thinking should we mention that the bitmap could be extended more
>than 16 bits in future?  Or we just don't emphasize 16-bit or 0~15?
>
>
>>=20
>> Existing NMI handling already has a priority mechanism for the NMI
>> handlers, with CPU-specific (NMI_LOCAL) handlers executed first,
>> followed by platform NMI handlers and unknown NMI (NMI_UNKNOWN) handler=
s
>> being last=2E Within each of these NMI types, the handlers registered w=
ith
>> NMI_FLAG_FIRST are given priority=2E
>>=20
>> NMI-source follows the same priority scheme to avoid unnecessary
>> complexity=2E Therefore, the NMI-source vectors are assigned arbitraril=
y,
>> except for vectors 0 and 2=2E
>>=20
>> Vector 0 is set by the hardware whenever a source vector was not used
>> while generating an NMI or the originator could not be reliably
>> identified=2E Do not assign it to any handler=2E
>>=20
>> Vector 2 is reserved for external NMIs corresponding to Local APIC -
>> LINT1=2E Some third-party chipsets may send NMI messages with a hardcod=
ed
>> vector of 2, which would result in vector 2 being set in the NMI-source
>> bitmap=2E To avoid confusion, do not assign vector 2 to any handler=2E
>>=20
>> NMI-source vectors are only assigned for NMI_LOCAL type handlers=2E
>> Platform NMI handlers have a single handler registered per type=2E They
>> don't need additional source information to differentiate among them=2E
>>=20
>> Use the assigned vectors to register the respective NMI handlers=2E War=
n
>> if the vector values are unexpected=2E
>>=20
>> A couple of NMI handlers, such as the microcode rendezvous and the cras=
h
>> reboot, do not use the typical NMI registration interface=2E Leave them
>> as-is for now=2E
>>=20
>> Originally-by: Jacob Pan <jacob=2Ejun=2Epan@linux=2Eintel=2Ecom>
>> Signed-off-by: Sohil Mehta <sohil=2Emehta@intel=2Ecom>
>
>Reviewed-by: Xin Li (Intel) <xin@zytor=2Ecom>

The architectural maximum* is 63 sources (plus the error bit), although th=
e current version only supports 1-15=2E If extended to be wider, we would p=
resumably add a new cpuid bit=2E

However, we should make sure there is nothing in the implementation that l=
imits us to 16 or 32 bits; when manipulating the bitmask we should use a 64=
 bit type=2E=20

   -hpa

* If we were to use the additional error reporting fields in the FRED fram=
e at some future point it could be extended as far as 207, but since we at =
this point don't have anyone clamouring for more than 15 this seems like a =
very remote possibility=2E

