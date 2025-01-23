Return-Path: <kvm+bounces-36391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8496A1A722
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:33:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 473AA188A213
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94750211470;
	Thu, 23 Jan 2025 15:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="ZF2Injrd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A1F4F1;
	Thu, 23 Jan 2025 15:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737646417; cv=none; b=CuC1g1lWQW3ozXDgCrKnnW0Y0qbeACwCeBUKMe3YHoMBWu24ilBMsit/B99yQiAUMdJ1VQ1b3IlYIbjifWllfKR2XdvEVaV6NKTuVrXh8s17XNAA+kehENxoIV2LHnagz5V/yz6xre6EKT5kaaBAdh8fLdf0gUE6ks4EnqR9IeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737646417; c=relaxed/simple;
	bh=5p7xT3po2+F9Cz5BbGOtrlT710KKHhtCw4KbDyKhqUU=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ehdfX/+Ya9wewYZKAtCxL0ATgPDRL41Z4s98WRCO4Hn0NOHIR7nyIXWCiOVv0TyTzzcoDDi9z85MITBzmfakk2Hyn3XxMnjRCsud9UjOtAtgY59WCVaIKFrClLd9fVpSfGmVw5AWzGrcXsIPM6chdHVviQBWnEFkqYuYDpwfE5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=ZF2Injrd; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737646416; x=1769182416;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=j7TtwM9zSLgAQwwFMd+Jd7bZJEHYMcgpXdaIjig8Ny8=;
  b=ZF2Injrdm7oOOMJWX0znR4MQg9kxHlvH41khS4S/b9ktSfV85/rTEcNn
   SkqHGSLXU9HM5eI9kUiuAD3p1D/1jfgPZLyBuQDqLptV72iLJylRtJGNr
   Nox/d3rWDwJnmQsestJS9HMEh05AizThQYvmBF9ZgwxKlLHh5ywZz+DTf
   E=;
X-IronPort-AV: E=Sophos;i="6.13,228,1732579200"; 
   d="scan'208";a="691397891"
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
Thread-Topic: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 15:33:33 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:20210]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.143:2525] with esmtp (Farcaster)
 id 35af9d30-6e91-4daa-8b8d-812c21f29025; Thu, 23 Jan 2025 15:33:31 +0000 (UTC)
X-Farcaster-Flow-ID: 35af9d30-6e91-4daa-8b8d-812c21f29025
Received: from EX19D007EUA003.ant.amazon.com (10.252.50.8) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 15:33:30 +0000
Received: from EX19D007EUA002.ant.amazon.com (10.252.50.68) by
 EX19D007EUA003.ant.amazon.com (10.252.50.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 15:33:30 +0000
Received: from EX19D007EUA002.ant.amazon.com ([fe80::1295:20d9:141e:47cc]) by
 EX19D007EUA002.ant.amazon.com ([fe80::1295:20d9:141e:47cc%3]) with mapi id
 15.02.1258.039; Thu, 23 Jan 2025 15:33:30 +0000
From: "Griffoul, Fred" <fgriffo@amazon.co.uk>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant
	<paul@xen.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AQHbbOj/VmoTG6SZV029AmLhfVoQ7bMjCNaAgACFagCAAMwcAIAAIpxX
Date: Thu, 23 Jan 2025 15:33:30 +0000
Message-ID: <cd8c29bc349244399b84008ef4c9ce7a@amazon.co.uk>
References: <20250122161612.20981-1-fgriffo@amazon.co.uk>
 <87tt9q7orq.fsf@redhat.com>
 <Z5GXxOr3FHz_53Pj@google.com>,<87frl97jer.fsf@redhat.com>
In-Reply-To: <87frl97jer.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thanks for your comments: I will post a new patch following Sean's idea to =
fix the CPUID registers directly in kvm_cpuid().

Br,

--
Fred

________________________________________
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Sent: Thursday, January 23, 2025 1:24:12 PM
To: Sean Christopherson
Cc: Griffoul, Fred; kvm@vger.kernel.org; Paolo Bonzini; Thomas Gleixner; In=
go Molnar; Borislav Petkov; Dave Hansen; x86@kernel.org; H. Peter Anvin; Da=
vid Woodhouse; Paul Durrant; linux-kernel@vger.kernel.org
Subject: RE: [EXTERNAL] [PATCH] KVM: x86: Update Xen-specific CPUID leaves =
during mangling


Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 22, 2025, Vitaly Kuznetsov wrote:
>> > Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
>> > ---
>> >  arch/x86/kvm/cpuid.c | 1 +
>> >  arch/x86/kvm/xen.c   | 5 +++++
>> >  arch/x86/kvm/xen.h   | 5 +++++
>> >  3 files changed, 11 insertions(+)
>> >
>> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> > index edef30359c19..432d8e9e1bab 100644
>> > --- a/arch/x86/kvm/cpuid.c
>> > +++ b/arch/x86/kvm/cpuid.c
>> > @@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *=
vcpu, struct kvm_cpuid_entry2
>> >     */
>> >    kvm_update_cpuid_runtime(vcpu);
>> >    kvm_apply_cpuid_pv_features_quirk(vcpu);
>> > +  kvm_xen_update_cpuid_runtime(vcpu);
>>
>> This one is weird as we update it in runtime (kvm_guest_time_update())
>> and values may change when we e.g. migrate the guest. First, I do not
>> understand how the guest is supposed to notice the change as CPUID data
>> is normally considered static.
>
> I don't think it does.  Linux-as-a-guest reads the info once during boot =
(see
> xen_tsc_safe_clocksource()), and if and only if the TSC is constant and n=
on-stop,
> i.e. iff the values won't change.

Right, the values shouldn't change on the same host. What I was thinking
is what happens when we migrate the guest to another
host. kvm_guest_time_update() is going to be called and we will get
something different (maybe just slightly different, but still) in Xen
TSC CPUIDs. The guest, however, is likely not going to notice at all.

>
>>  Second, I do not see how the VMM is
>> supposed to track it as if it tries to supply some different data for
>> these Xen leaves, kvm_cpuid_check_equal() will still fail.
>>
>> Would it make more sense to just ignore these Xen CPUID leaves with TSC
>> information when we do the comparison?
>
> Another alternative would be to modify the register output in kvm_cpuid()=
.  Given
> that Linux reads the info once during boot, and presumably other guests d=
o the
> same, runtime "patching" wouldn't incur meaningful overhead.  And there a=
re no
> feature bits that KVM cares about, i.e. no reason KVM's view needs to be =
correct.

True, CPUID reading time should not be performance critical.

--
Vitaly


