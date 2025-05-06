Return-Path: <kvm+bounces-45611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AD4AACB06
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:32:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6379C1C22379
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC91205E3B;
	Tue,  6 May 2025 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MIzuHMAp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB98E25CC41;
	Tue,  6 May 2025 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549040; cv=none; b=YSiyU9G1TeHxwbQRPcMF7/ELzBFqo+f0hgGzqf/EnRcVhn+e9VeGn/hY/7mYTiRYvx/Va7lsz4k/Q3ZfKNz5AHb1EbeB9eknNp4oCTCcYYjH3fkFI/6hgOc/P3A6MiCv47FIYKU30hz/2Kk2quu1ZmuCx7gO7m7j5Zd5jEH4Wv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549040; c=relaxed/simple;
	bh=sy5+FLBt8V254FwUykIHfEDCfE4L9U2Cpnole7yVjV8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=NFTrV2ct9HZFjrA9ZJ2NupWi0f44t+QLN+tdLoaeF6+YQHUo13X2TZd++NPXlJQ31qS6QKLTM5yLXSjGB5Ki2iPf8OlOq41iOSPaW+HfttA+w+eERTY1oAOc13l45LgknDV6CMUkWRv9jgfEx37IFBux8ux2VMoJiZwabZBjP9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MIzuHMAp; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 546GThAV971224
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 6 May 2025 09:29:43 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 546GThAV971224
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1746548984;
	bh=v6XPEFSGKokl1nFOIN3pFv6ErpYGqIeLKYtQQ53aKkA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=MIzuHMApNdjpQ5ZILL8ZOPep8vI7WxRjiUiWPmXLr7AzDzOJeAGF2Mg3Bs+LAbbwx
	 607Qn0HNOUl8WsbZ4SrOxTt3IdOUq3CoaVSLbP4fgukVo/lHgJX/w60kJhrOIv+Eo3
	 EtnpOGnOuJCfsrahyDVkm/2FpCQnFbwHzfvd5yf9xafnZ8uVrGGS9Q/Iu79cmfdGtZ
	 Vz83BgaoYBBM4TWQhw4lZtxPxUN5TrlgmjN4OPVBEOoz3Qn0dlROG0rcLV017k47bh
	 Gp+ab6aHjmc5mWQcCMrcJK6tZAPb5n/0ZJvsLL+Sxd7HRUAbVbByKg3hbRG9U84j1x
	 uAAqsuKmpoD0A==
Date: Tue, 06 May 2025 09:29:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@kernel.org>, Sean Christopherson <seanjc@google.com>
CC: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, xin@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 2/6] x86/kvm: Rename the KVM private read_msr() function
User-Agent: K-9 Mail for Android
In-Reply-To: <aBo1w0tRoM2JUtW_@gmail.com>
References: <20250506092015.1849-1-jgross@suse.com> <20250506092015.1849-3-jgross@suse.com> <aBoUdApwSgnr3r9V@google.com> <aBo1w0tRoM2JUtW_@gmail.com>
Message-ID: <55944DEC-0129-4052-BBA4-7298B16326BD@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 6, 2025 9:16:03 AM PDT, Ingo Molnar <mingo@kernel=2Eorg> wrote:
>
>* Sean Christopherson <seanjc@google=2Ecom> wrote:
>
>> On Tue, May 06, 2025, Juergen Gross wrote:
>> > Avoid a name clash with a new general MSR access helper after a futur=
e
>> > MSR infrastructure rework by renaming the KVM specific read_msr() to
>> > kvm_read_msr()=2E
>> >=20
>> > Signed-off-by: Juergen Gross <jgross@suse=2Ecom>
>> > ---
>> >  arch/x86/include/asm/kvm_host=2Eh | 2 +-
>> >  arch/x86/kvm/vmx/vmx=2Ec          | 4 ++--
>> >  2 files changed, 3 insertions(+), 3 deletions(-)
>> >=20
>> > diff --git a/arch/x86/include/asm/kvm_host=2Eh b/arch/x86/include/asm=
/kvm_host=2Eh
>> > index 9c971f846108=2E=2E308f7020dc9d 100644
>> > --- a/arch/x86/include/asm/kvm_host=2Eh
>> > +++ b/arch/x86/include/asm/kvm_host=2Eh
>> > @@ -2275,7 +2275,7 @@ static inline void kvm_load_ldt(u16 sel)
>> >  }
>> > =20
>> >  #ifdef CONFIG_X86_64
>> > -static inline unsigned long read_msr(unsigned long msr)
>>=20
>> Ewwww=2E  Eww, eww, eww=2E  I forgot this thing existed=2E
>>=20
>> Please just delete this and use rdmsrq() directly (or is it still rdmsr=
l()? at
>> this point?)=2E
>
>Both will work, so code-in-transition isn't build-broken unnecessarily:
>
>  arch/x86/include/asm/msr=2Eh:#define rdmsrl(msr, val) rdmsrq(msr, val)
>
>:-)
>
>Thanks,
>
>	Ingo

But for forward-looking code, rdmsrq()=2E

