Return-Path: <kvm+bounces-23217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 355D2947A37
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 13:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 973A9B22148
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340531553B1;
	Mon,  5 Aug 2024 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iDOc+MBi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B241537D9
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 11:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722856005; cv=none; b=eWhtoYE7hgZjMUlLiljmxxfwBXaB6H2j8FpD+2xs9w0vfO77116n3pTXLAwuWdr/fc5zpoFsV0PEnFhJj6YdKEyw7nzF8eX+rhcHjHVXuffyOerWMU3vizuiEA/FdZhei84Qhu78MUKmtNMMdVRhuOL1XgPyrmvARrwazrfiDZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722856005; c=relaxed/simple;
	bh=ZROb3dB2VaVaGsnp5zkOSyH+sb3xDkLcZAhsWX2SuaU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cZeEca676U9Rl1bU79KJWR2uwE8QwQjP7azeXs0131YEpivf5RILpoIsg75eiMPLAz9dDKOWZiKl2W+vPRF4AVjDvlyFWxndN+3mtMNzn7xd+12SWimDhNZKShjqo1Ai+jDdIG6q7gv8DGcW0XgjqSwHksqCFRqsh3s7ZplQB10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iDOc+MBi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722856002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0EuEhaqkma5nF/MDa1ex/CbEv6H+NURzLYv8ieItZpQ=;
	b=iDOc+MBiiQvuTmsT/DPTESxV+ApZy9NgcilY05hm8MtkVeoH4F89sxAp/MmfqTmvWsVMb5
	mwClmVb9guKbTKMAyK4ceYgrXiFWhuCOpIN4I6aU0auumA52w9vrLiLGurAvdDNv/tUqeI
	lNbNjRDRAGMg1pmEvYDOycxdH9/b2m0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-2mPNRhHWN5avDJWDHoWZ0Q-1; Mon, 05 Aug 2024 07:06:39 -0400
X-MC-Unique: 2mPNRhHWN5avDJWDHoWZ0Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3684ea1537fso5293131f8f.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 04:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722855998; x=1723460798;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0EuEhaqkma5nF/MDa1ex/CbEv6H+NURzLYv8ieItZpQ=;
        b=Y2MdO/hYqTj7uOZdnF1YPWRl5QYlciwlI0zolekIcSziOu4FJbASaJgiXzDXuzWs+q
         tj4zOUh4q6nVKU5yqtC5CQwrJv47OXq9/Ug78G73smlk99YV2XzO/Acg/ZrRrvQ8A+ZC
         itRZsF7hSJBAw7wuzLdjySPshUe1bYnVNupQe9vyXvwWt4iNA18aLg9tWkG7kXgfCfU9
         LpvLWF+YoouJHWfwefp6Bs9MM2+htx2MX+0rk4UcCRJbDi4PyLdLyn41cD5W0N7G5de/
         c1Ic1zG8i5VIhdV82h/mUUGpUb+3bUSSd+5E0HjOnyPyFBUw/C4Ic/FUsSVdsHs9WBhB
         c3PA==
X-Forwarded-Encrypted: i=1; AJvYcCXh3VkID1R9IXe3V2dK/B27+n7t6YMnrAzMfDb2Q5XeWvNlcydwOmrma8U7m9Te+pEMS6EFP68Ylsc5o4oEqCKMnoVW
X-Gm-Message-State: AOJu0YzQBHagQIMIxBcjwHMQrwroIpyHGnB0+fdukCjJBPpR40MXry2d
	LS6BWdd/armBPAVrszZxQHIycpKkR4VsJMq0rZYZBQknh0/XYT8GVvPqQUCra8ptrvLmyK4Fi2i
	8BmdjZYUQ6cR5Eke2LKZl6Ra2K3hlyqbNgAiWxG0kbTe6EHYr2Q==
X-Received: by 2002:a5d:518c:0:b0:366:e7aa:7fa5 with SMTP id ffacd0b85a97d-36bbc0f7f87mr7350779f8f.1.1722855997900;
        Mon, 05 Aug 2024 04:06:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6dg7LPJI84OZv+IpNHY8eZR1NrMnc4r04apwnaanq3LD1mnPJZ5UQZpkQV2fYA8faTO8Xtg==
X-Received: by 2002:a5d:518c:0:b0:366:e7aa:7fa5 with SMTP id ffacd0b85a97d-36bbc0f7f87mr7350755f8f.1.1722855997347;
        Mon, 05 Aug 2024 04:06:37 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:778d:5201:3e8a:4c9c:25dd:6ccc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbcf0cc58sm9526157f8f.2.2024.08.05.04.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 04:06:36 -0700 (PDT)
Message-ID: <8f35b524cda53aff29a9389c79742fc14f77ec68.camel@redhat.com>
Subject: Re: [PATCH v2 22/49] KVM: x86: Add a macro to precisely handle
 aliased 0x1.EDX CPUID features
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
 Oliver Upton <oliver.upton@linux.dev>, Binbin Wu
 <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>,
 Robert Hoo <robert.hoo.linux@gmail.com>
Date: Mon, 05 Aug 2024 14:06:35 +0300
In-Reply-To: <ZqKb_JJlUED5JUHP@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-23-seanjc@google.com>
	 <43ef06aca700528d956c8f51101715df86f32a91.camel@redhat.com>
	 <ZoxVa55MIbAz-WnM@google.com>
	 <3da2be9507058a15578b5f736bc179dc3b5e970f.camel@redhat.com>
	 <ZqKb_JJlUED5JUHP@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D1=87=D1=82, 2024-07-25 =D1=83 11:39 -0700, Sean Christopherson =D0=
=BF=D0=B8=D1=88=D0=B5:
> > On Wed, Jul 24, 2024, Maxim Levitsky wrote:
> > > > On Mon, 2024-07-08 at 14:08 -0700, Sean Christopherson wrote:
> > > > > > On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> > > > > > > > On Fri, 2024-05-17 at 10:38 -0700, Sean Christopherson wrot=
e:
> > > > > > > > > > Add a macro to precisely handle CPUID features that AMD=
 duplicated from
> > > > > > > > > > CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.=C2=A0 This wi=
ll allow adding an
> > > > > > > > > > assert that all features passed to kvm_cpu_cap_init() m=
atch the word being
> > > > > > > > > > processed, e.g. to prevent passing a feature from CPUID=
 0x7 to CPUID 0x1.
> > > > > > > > > >=20
> > > > > > > > > > Because the kernel simply reuses the X86_FEATURE_* defi=
nitions from
> > > > > > > > > > CPUID.0x1.EDX, KVM's use of the aliased features would =
result in false
> > > > > > > > > > positives from such an assert.
> > > > > > > > > >=20
> > > > > > > > > > No functional change intended.
> > > > > > > > > >=20
> > > > > > > > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > > > > > > > ---
> > > > > > > > > > =C2=A0arch/x86/kvm/cpuid.c | 24 +++++++++++++++++------=
-
> > > > > > > > > > =C2=A01 file changed, 17 insertions(+), 7 deletions(-)
> > > > > > > > > >=20
> > > > > > > > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.=
c
> > > > > > > > > > index 5e3b97d06374..f2bd2f5c4ea3 100644
> > > > > > > > > > --- a/arch/x86/kvm/cpuid.c
> > > > > > > > > > +++ b/arch/x86/kvm/cpuid.c
> > > > > > > > > > @@ -88,6 +88,16 @@ u32 xstate_required_size(u64 xstate_=
bv, bool compacted)
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(name)=
;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> > > > > > > > > > =C2=A0})
> > > > > > > > > > =C2=A0
> > > > > > > > > > +/*
> > > > > > > > > > + * Aliased Features - For features in 0x8000_0001.EDX =
that are duplicates of
> > > > > > > > > > + * identical 0x1.EDX features, and thus are aliased fr=
om 0x1 to 0x8000_0001.
> > > > > > > > > > + */
> > > > > > > > > > +#define AF(name)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> > > > > > > > > > +({=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0BUILD_BUG_ON=
(__feature_leaf(X86_FEATURE_##name) !=3D CPUID_1_EDX);=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0feature_bit(=
name);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0\
> > > > > > > > > > +})
> > > > > > > > > > +
> > > > > > > > > > =C2=A0/*
> > > > > > > > > > =C2=A0 * Magic value used by KVM when querying userspac=
e-provided CPUID entries and
> > > > > > > > > > =C2=A0 * doesn't care about the CPIUD index because the=
 index of the function in
> > > > > > > > > > @@ -758,13 +768,13 @@ void kvm_set_cpu_caps(void)
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0);
> > > > > > > > > > =C2=A0
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_cpu=
_cap_init(CPUID_8000_0001_EDX,
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(FPU) | F(VME) | F(DE) | F(PSE) |
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(TSC) | F(MSR) | F(PAE) | F(MCE) |
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(CX8) | F(APIC) | 0 /* Reserved */ | F=
(SYSCALL) |
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(PAT) | F(PSE36) | 0 /* Reserved */ |
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(NX) | 0 /* Reserved */ | F(MMXEXT) | =
F(MMX) |
> > > > > > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAGE=
S) | F(RDTSCP) |
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AF(FPU) | AF(VME) | AF(DE) | AF(PSE) |
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AF(TSC) | AF(MSR) | AF(PAE) | AF(MCE) |
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AF(CX8) | AF(APIC) | 0 /* Reserved */ |=
 F(SYSCALL) |
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AF(MTRR) | AF(PGE) | AF(MCA) | AF(CMOV)=
 |
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AF(PAT) | AF(PSE36) | 0 /* Reserved */ =
|
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0F(NX) | 0 /* Reserved */ | F(MMXEXT) | =
AF(MMX) |
> > > > > > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0AF(FXSR) | F(FXSR_OPT) | X86_64_F(GBPAG=
ES) | F(RDTSCP) |
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 /* Reserved */ | X86_64_F(LM) |=
 F(3DNOWEXT) | F(3DNOW)
> > > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0);
> > > > > > > > > > =C2=A0
> > > > > > > >=20
> > > > > > > > Hi,
> > > > > > > >=20
> > > > > > > > What if we defined the aliased features instead.
> > > > > > > > Something like this:
> > > > > > > >=20
> > > > > > > > #define __X86_FEATURE_8000_0001_ALIAS(feature) \
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(feature + =
(CPUID_8000_0001_EDX - CPUID_1_EDX) * 32)
> > > > > > > >=20
> > > > > > > > #define KVM_X86_FEATURE_FPU_ALIAS=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_FPU)
> > > > > > > > #define KVM_X86_FEATURE_VME_ALIAS=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0__X86_FEATURE_8000_0001_ALIAS(KVM_X86_FEATURE_VME)
> > > > > > > >=20
> > > > > > > > And then just use for example the 'F(FPU_ALIAS)' in the CPU=
ID_8000_0001_EDX
> > > > > >=20
> > > > > > At first glance, I really liked this idea, but after working th=
rough the
> > > > > > ramifications, I think I prefer "converting" the flag when pass=
ing it to
> > > > > > kvm_cpu_cap_init().=C2=A0 In-place conversion makes it all but =
impossible for KVM to
> > > > > > check the alias, e.g. via guest_cpu_cap_has(), especially since=
 the AF() macro
> > > > > > doesn't set the bits in kvm_known_cpu_caps (if/when a non-hacky=
 validation of
> > > > > > usage becomes reality).
> > > >=20
> > > > Could you elaborate on this as well?
> > > >=20
> > > > My suggestion was that we can just treat aliases as completely inde=
pendent
> > > > and dummy features, say KVM_X86_FEATURE_FPU_ALIAS, and pass them as=
 is to the
> > > > guest, which means that if an alias is present in host cpuid, it ap=
pears in
> > > > kvm caps, and thus qemu can then set it in guest cpuid.
> > > >=20
> > > > I don't think that we need any special treatment for them if you lo=
ok at it
> > > > this way.=C2=A0 If you don't agree, can you give me an example?
> >=20
> > KVM doesn't honor the aliases beyond telling userspace they can be set =
(see below
> > for all the aliased features that KVM _should_ be checking).=C2=A0 The =
APM clearly
> > states that the features are the same as their CPUID.0x1 counterparts, =
but Intel
> > CPUs don't support the aliases.=C2=A0 So, as you also note below, I thi=
nk we could
> > unequivocally say that enumerating the aliases but not the "real" featu=
res is a
> > bogus CPUID model, but we can't say the opposite, i.e. the real feature=
s can
> > exists without the aliases.
> >=20
> > And that means that KVM must never query the aliases, e.g. should never=
 do
> > guest_cpu_cap_has(KVM_X86_FEATURE_FPU_ALIAS), because the result is ess=
entially
> > meaningless.=C2=A0 It's a small thing, but if KVM_X86_FEATURE_FPU_ALIAS=
 simply doesn't
> > exist, i.e. we do in-place conversion, then it's impossible to feed the=
 aliases
> > into things like guest_cpu_cap_has().

This only makes my case stronger - treating the aliases as just features wi=
ll
allow us to avoid adding more logic to code which is already too complex IM=
HO.

If your concern is that features could be queried by guest_cpu_cap_has()
that is easy to fix, we can (and should) put them into a separate file and
#include them only in cpuid.c.

We can even #undef the __X86_FEATURE_8000_0001_ALIAS macro after the kvm_se=
t_cpu_caps,
then if I understand the macro pre-processor correctly, any use of feature =
alias
macros will not fully evaluate and cause a compile error.



> >=20
> > Heh, on a related topic, __cr4_reserved_bits() fails to account for any=
 of the
> > aliased features.=C2=A0 Unless I'm missing something, VME, DE, TSC, PSE=
, PAE, PGE and
> > MCE, all need to be handled in __cr4_reserved_bits().=C2=A0
> > =C2=A0Amusingly,=20
> > nested_vmx_cr_fixed1_bits_update() handles the aliased legacy features.=
=C2=A0 I don't
> > see any reason for nested_vmx_cr_fixed1_bits_update() to manually query=
 guest
> > CPUID, it should be able to use cr4_guest_rsvd_bits verbatim.

Yep, this should be fixed - this patch series is about to grow even more I =
guess,
or rather let me suggest that you split it into several patch series, which
can be merged and discussed separately.


> >=20
> > > > > > Side topic, if it's not already documented somewhere else, kvm/=
x86/cpuid.rst
> > > > > > should call out that KVM only honors the features in CPUID.0x1,=
 i.e. that setting
> > > > > > aliased bits in CPUID.0x8000_0001 is supported if and only if t=
he bit(s) is also
> > > > > > set in CPUID.0x1.
> > > >=20
> > > > To be honest if KVM enforces this, such enforcement can be removed =
IMHO:
> >=20
> > There's no enforcement, and as above I agree that this would be a bogus=
 CPUID
> > model.=C2=A0 I was thinking that it could be helpful to document that K=
VM never checks
> > the aliases, but on second though, it's probably unnecessary because th=
e APM does
> > say
> >=20
> > =C2=A0 Same as CPUID Fn0000_0001_EDX[...]
> >=20
> > for all the bits, i.e. setting the aliases without the real bits is an
> > architectural violation.

Regardless if this is an architectural violation or not, KVM should allow t=
his
because it allows many architectural violations, like AVX3 with no XSAVE, a=
nd such.

IMHO being consistent is more important than being right in only some cases=
,
and I don't think we want to start enforcing all the CPUID dependencies
(I actually won't object to this).

Best regards,
	Maxim Levitsky


> >=20


