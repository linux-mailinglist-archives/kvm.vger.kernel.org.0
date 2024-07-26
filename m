Return-Path: <kvm+bounces-22328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C86B93D5AA
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 17:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 528B41F2110B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 15:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D07C178CFA;
	Fri, 26 Jul 2024 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S29JwfED"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC7B1EB31
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722006522; cv=none; b=LtpNFh+lzeP0Ehse0nqSTfqU4Yk0DH/QYNfwQOqpORGxFqV6w0F6xBq6LtQ/sE0vwMdkY+aAxwR/bmbET6z2yeurxEZ4nM12WEt9bV87g7DV4xeWqADmwNSXKU9OFWpgIU/CHQYBOYxWR4QADcrFDQGqGQqRMW8Y4Nu9DuncJu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722006522; c=relaxed/simple;
	bh=qm3vU5nlloSg/ckVtbTdCryyu1KFiz5UN+yO3AfyJYo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dTWLyaeDRnPce5yN5OghLejmPd/MdbhjvXG9jCCGH7yLu+NaY+vMOAlN609lkQnkS2LchnraWFL/+7SYwGFyol1jfNWl3s7EwM745+47Y65ba/JqqLnzDgCJ6c461fk4xOl7kj3xVIUnLzXex3prXdRzCrCyO/kk+OaH97je7F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S29JwfED; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722006519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGRQZ4wr7LLIP7BKv1iB3m/r2GyqQ2Ga7dGyzSXW5lM=;
	b=S29JwfEDVQXljG202ytwTo3xTyvLp5kXHSN0vVk+GZue4sFDQ6JGf6XL9KsETynVCwoFfM
	ndnLd1KsakJKZ88+CImXNUSKTTggk2MPoDcjbOxjijrVaIfqzkSWCyddr5kd8n9xITHx3j
	mPd461aSNOmzAoiqgm02YmQ8/C38cKw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-msSrfipkOXm6zeO0VDb2YQ-1; Fri, 26 Jul 2024 11:08:38 -0400
X-MC-Unique: msSrfipkOXm6zeO0VDb2YQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1dab8a2eeso105344085a.1
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 08:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722006518; x=1722611318;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BGRQZ4wr7LLIP7BKv1iB3m/r2GyqQ2Ga7dGyzSXW5lM=;
        b=MwyE9JnRtdiPKncSTzru0A+fhqK7gaAnF/pVylSXFJRCzWtVhzk+45KHy9h+wO0XCW
         dbv8GNz4b7KerVOMglhe92j+j3NF73SmCLoEiRVvUH8C5mTIyNDFXM1WcLjIR3Z5nUjO
         ECi5p9aIOn2lDS7D9bYa2KxesZ3ECFXnS8ZYqh81UtpLk9f/zT5DCdIosm6jfHJ0wmv4
         lsZMhM493PN6OvzlIgVBDTtqEkFE/JXpKa490PiAg+86OZNr3D4Q1tNtc+DgS6TsL9BA
         KMiAaEqezImbsjolzvGAO8cHXBDub8czIg17yDrpkARhHtgzj23+BEFlLzExEYLgEViW
         vVhQ==
X-Gm-Message-State: AOJu0YyKQBPmwBvQlZBCDtzBL7pwHzh2yS613fsSYgkW3q+vVGIjReNc
	ttQpq59hnA7R2XuPwTgw6c7LS/wjWX+RWputjGrjVyUK/4IFWnfFzOAv1m0aL5eC8DWvlIRG2jf
	r280lmMq9R9eCS4ASDVb6+YhWai4GstWf88hvhTkiYfWN/TKH2Q==
X-Received: by 2002:a05:620a:4110:b0:79f:a6c:f422 with SMTP id af79cd13be357-7a1e524c7admr2016585a.24.1722006518005;
        Fri, 26 Jul 2024 08:08:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUiwxqcyDGZfvkFCWqbc+Wgbu8OYxfgn/GiDpD2EKcoW5u8PS9sn5wkGn0rs+kl3OlopLfBA==
X-Received: by 2002:a05:620a:4110:b0:79f:a6c:f422 with SMTP id af79cd13be357-7a1e524c7admr2013485a.24.1722006517641;
        Fri, 26 Jul 2024 08:08:37 -0700 (PDT)
Received: from intellaptop.lan (pool-173-34-154-202.cpe.net.cable.rogers.com. [173.34.154.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1d73b226csm184612385a.40.2024.07.26.08.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 08:08:37 -0700 (PDT)
Message-ID: <91c7727f66afa7c1f424fb08958579dfa3dc708c.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: relax canonical checks for some x86
 architectural msrs
From: mlevitsk@redhat.com
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Sean
 Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Thomas
 Gleixner <tglx@linutronix.de>,  x86@kernel.org,
 linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 26 Jul 2024 11:08:36 -0400
In-Reply-To: <ZqNHGBZyiHKvQKj1@chao-email>
References: <20240725150110.327601-1-mlevitsk@redhat.com>
	 <20240725150110.327601-2-mlevitsk@redhat.com> <ZqNHGBZyiHKvQKj1@chao-email>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D0=BF=D1=82, 2024-07-26 =D1=83 14:50 +0800, Chao Gao =D0=BF=D0=B8=
=D1=88=D0=B5:
> On Thu, Jul 25, 2024 at 11:01:09AM -0400, Maxim Levitsky wrote:
> > Several architectural msrs (e.g MSR_KERNEL_GS_BASE) must contain
> > a canonical address, and according to Intel PRM, this is enforced
> > by #GP on a MSR write.
> >=20
> > However with the introduction of the LA57 the definition of
> > what is a canonical address became blurred.
> >=20
> > Few tests done on Sapphire Rapids CPU and on Zen4 CPU,
> > reveal:
> >=20
> > 1. These CPUs do allow full 57-bit wide non canonical values
> > to be written to MSR_GS_BASE, MSR_FS_BASE, MSR_KERNEL_GS_BASE,
> > regardless of the state of CR4.LA57.
> > Zen4 in addition to that even allows such writes to
> > MSR_CSTAR and MSR_LSTAR.
>=20
> This actually is documented/implied at least in ISE [1]. In Chapter 6.4
> "CANONICALITY CHECKING FOR DATA ADDRESSES WRITTEN TO CONTROL REGISTERS AN=
D
> MSRS"
>=20
> =C2=A0 In Processors that support LAM continue to require the addresses w=
ritten to
> =C2=A0 control registers or MSRs to be 57-bit canonical if the processor =
_supports_
> =C2=A0 5-level paging or 48-bit canonical if it supports only 4-level pag=
ing
>=20
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/671368

I haven't found this in the actual PRM, but mine is relatively old,
(from September 2023, I didn't bother to update it because 5 level paging i=
s
quite an old feature)

>=20
> >=20
> > 2. These CPUs don't prevent the user from switching back to 4 level
> > paging with values that will be non canonical in 4 level paging,
> > and instead just allow the msrs to contain these values.
> >=20
> > Since these MSRS are all passed through to the guest, and microcode
> > allows the non canonical values to get into these msrs,
> > KVM has to tolerate such values and avoid crashing the guest.
> >=20
> > To do so, always allow the host initiated values regardless of
> > the state of CR4.LA57, instead only gate this by the actual hardware
> > support for 5 level paging.
> >=20
> > To be on the safe side leave the check for guest writes as is.
> >=20
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > arch/x86/kvm/x86.c | 31 ++++++++++++++++++++++++++++++-
> > 1 file changed, 30 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a6968eadd418..c599deff916e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1844,7 +1844,36 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, =
u32 index, u64 data,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_KERNEL_GS_BASE=
:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_CSTAR:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_LSTAR:
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (is_noncanonical_address(data, vcpu))
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Both AMD and Intel cpus tend to allow values which
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * are canonical in the 5 level paging mode but are no=
t
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * canonical in the 4 level paging mode to be written
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * to the above msrs, regardless of the state of the C=
R4.LA57.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Intel CPUs do honour CR4.LA57 for the MSR_CSTAR/MSR=
_LSTAR,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * AMD cpus don't even do that.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Both CPUs also allow non canonical values to remain=
 in
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * these MSRs if the CPU was in 5 level paging mode an=
d was
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * switched back to 4 level paging, and tolerate these=
 values
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * both in native MSRs and in vmcs/vmcb fields.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * To avoid crashing a guest, which manages using one =
of the above
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * tricks to get non canonical value to one of
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * these MSRs, and later migrates, allow the host init=
iated
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * writes regardless of the state of CR4.LA57.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 *
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * To be on the safe side, don't allow the guest initi=
ated
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * writes to bypass the canonical check (e.g be more s=
trict
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * than what the actual ucode usually does).
>=20
> I may think guest-initiated writes should be allowed as well because this=
 is
> the architectural behavior.

Note though that for MSR_CSTAR/MSR_LSTAR I did set #GP, depending on CR.LA5=
7.
Ah, I see it, KVM intercepts these msrs on VMX (but not on SVM) and I was u=
nder=C2=A0
the impression that it doesn't, that is why I get #GP depending on CR4.LA57=
....

I do wonder why we intercept these msrs on VMX and not on SVM.

It all makes sense now, thanks a lot for the explanation!

>=20
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (!host_initiated && is_noncanonical_address(data, v=
cpu))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return=
 1;
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (!__is_canonical_address(data,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0boot_c=
pu_has(X86_FEATURE_LA57) ? 57 : 48))
>=20
> boot_cpu_has(X86_FEATURE_LA57)=3D1 means LA57 is enabled. Right?
>=20
> With this change, host-initiated writes must be 48-bit canonical if LA57 =
isn't
> enabled on the host, even if it is enabled in the guest. (note that KVM c=
an
> expose LA57 to guests even if LA57 is disabled on the host, see
> kvm_set_cpu_caps()).


Sorry about this - we indeed need to use kvm_cpu_cap_has(X86_FEATURE_LA57) =
because
it is forced based on host raw CPUID.

I remember I wanted to do exactly this but forgot somehow.

Also I need to update this for nested VMX - these msrs are also checked the=
re based
on CR4.LA57.

Thanks for the clarification, and it all makes sense. I'll send v2 with all=
 of this
when I get back from a vacation (next Wednesday).


Best regards,
	Maxim Levitsky


>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
return 1;
>=20


