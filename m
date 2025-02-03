Return-Path: <kvm+bounces-37145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57279A26220
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 19:22:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 502DB7A27C0
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691BE20E338;
	Mon,  3 Feb 2025 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EoSSEJ2S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F389520A5CB
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738606924; cv=none; b=KONrfyt++Exy5joXoUQOBqtcemUhp9QhBZu/2w//aV0CQuOlrLH2JjoXd9MTzq5s5gggtNYsotVDzBf2bCQ3ajshB0Pm8iDRq5U3JEhSAwXupDmGMwDqM+oyGMK0BJ8yzb8N6QTjLTs8d8soqI8e5g4JII/1RgCWW/BNQ6sl2Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738606924; c=relaxed/simple;
	bh=28LdHPYUIggbRJom5lYWWfHr3ToftE4xYha+OX3oJpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n6zziWoDefsljLMuSl/AzC0SVptgRjwvkYMEQvcYJO60Ap3f3L6VU2Osq2OD3v2v28ugitWCmXkZmkbrgJhDmhPimzfRb5rDxS4HcWJrPE1EoOLMGqnpZ6uJ2w01FMKb5jCCYeCKy1JXqRFA5NsuChKPE6AR00T1VDCc1wSvhec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EoSSEJ2S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738606922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2nlFOMn1lH29kDa2Jrx7xgjpzbwJvO/qQCiLXJ/5Xg=;
	b=EoSSEJ2SzGb4FRZN48UE6TAw1Eu032cp8ZzfQAUy9JOX0G9A48938zEg9DHKzt2S4vBLi3
	lAiT/xGIcklvr1ngE9qcL7mAGeOBAQEtHGvJOo94DNNjG541LM38KiI/+km44uq3yCr+hm
	FCZa7gYtFc1FM8EoiJHmbybAH10FHIo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-Du_gCgcTNP2zWva3AXhfFw-1; Mon, 03 Feb 2025 13:22:00 -0500
X-MC-Unique: Du_gCgcTNP2zWva3AXhfFw-1
X-Mimecast-MFC-AGG-ID: Du_gCgcTNP2zWva3AXhfFw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43626224274so24730715e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 10:22:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738606919; x=1739211719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2nlFOMn1lH29kDa2Jrx7xgjpzbwJvO/qQCiLXJ/5Xg=;
        b=VsFJBOnr5QMRELFoFc5taC5+Eh5Rf2QySsXs1Hk77siIfikkzkJR6UHOW5IZWsXGVI
         zwio564MlxTdW1haALdDjvloCgTi34ufCWv+6OiC3levW0272Me5ViwFhgoSc1h+tEr3
         kGSjKy0FQj5qCCMvqAr5srDYRh7r31XNqzf0AnW98X9CdmhxjNLk1HBln4rsGpARMQgU
         rMytZasf4fgpGfIPEqHBQoDnyWMRyC2X2oYYl5gMdS7QMHkr+6HytcxmeXVE2pQHHSXZ
         DrK+/6UwN+U0bDodImnatBwaiQljTuJRvMZC87FI43TKpWai5yBPC68P8HnZC9UJIdA3
         Zmew==
X-Forwarded-Encrypted: i=1; AJvYcCVjmCyXC2FxGPcFbipbsfSue9cbc9NZRGDaEXIvBjLDBqXMU6Is3TzpRicnLkegLFU5VG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOOynR2vklUhI+l0EkaQ1VUCsLpx0LiMZycsNeCgPwmY/myGzI
	yjDge+u6Uxk27w1ts0ovo45aJhWJyNrPSdrpzVQEuYKsw7H4GqZQ38DELXHhuSl+h3uegOS9VhU
	MZB3n383idEvRGb0PUDWfC6CgPHtFVQlxHB6cYLWPUtBwYD0Y1WgX6S8+2kgTNk11D/EVuLgsLG
	lNK1HyB8fzsqS7rn6UvMJALzPc
X-Gm-Gg: ASbGncvfdm+bxcv1FyAv6PEXh2vVz93xQZHUtfZsfIeKGYA/rPRZqLQscCaOKOwaDND
	BYzdNHndvonnjd9bLTbcosp20y6PUcYJmFEeQrgGCRPQjCgQCl/T1g0in/da9
X-Received: by 2002:a05:600c:35d3:b0:438:d9f1:f5cc with SMTP id 5b1f17b1804b1-438dc3c3983mr208354685e9.8.1738606919492;
        Mon, 03 Feb 2025 10:21:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHz7WFFlkh702aL2lV+rs/ZKODFLjI/rvxvV7aVp0t9rlFGn4otyohrTVaegFBxoOtK19Bv6wDrLLCiUaiWHss=
X-Received: by 2002:a05:600c:35d3:b0:438:d9f1:f5cc with SMTP id
 5b1f17b1804b1-438dc3c3983mr208354385e9.8.1738606919110; Mon, 03 Feb 2025
 10:21:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADH9ctD1uf_yBA3NXNQu7TJa_TPhLRN=0YZ3j2gGhgmaFRdCFg@mail.gmail.com>
 <c3026876-8061-4ab2-9321-97cc05bad510@redhat.com> <CADH9ctBivnvP1tNcatLKzd8EDz8Oo6X65660j8ccxYzk3aFzCA@mail.gmail.com>
 <CABgObfZEyCQMiq6CKBOE7pAVzUDkWjqT2cgfbwjW-RseH8VkLw@mail.gmail.com>
 <CADH9ctA_C1dAOus1K+wOH_SOKTb=-X1sVawt5R=dkH1iGt8QUg@mail.gmail.com>
 <CABgObfZrTyft-3vqMz5w0ZiAhp-v6c32brgftynZGJO8OafrdA@mail.gmail.com>
 <CADH9ctBYp-LMbW4hm3+QwNoXvAc5ryVeB0L1jLY0uDWSe3vbag@mail.gmail.com>
 <b1ddb439-9e28-4a58-ba86-0395bfc081e0@redhat.com> <CADH9ctCFYtNfhn3SSp2jp0fzxu6s_X1A+wBNnzvHZVb8qXPk=g@mail.gmail.com>
 <CADH9ctB0YSYqC_Vj2nP20vMO_gN--KsqOBOu8sfHDrkZJV6pmw@mail.gmail.com>
 <Z2IXvsM0olS5GvbR@google.com> <CABgObfadZZ5sXYB0xR5OcLDw_eVUmXTOTFSWkVpkgiCJmNnFRQ@mail.gmail.com>
 <CADH9ctAGt_VriKA7Ch1L9U+xud-6M54GzaPOM_2sSA780TpAYw@mail.gmail.com>
In-Reply-To: <CADH9ctAGt_VriKA7Ch1L9U+xud-6M54GzaPOM_2sSA780TpAYw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Feb 2025 19:21:47 +0100
X-Gm-Features: AWEUYZkfTYWUXYOngTDyrNZ6kf3UUSURUuAlnD5-9-ZGJoFpmKmFYKS0QywhxK0
Message-ID: <CABgObfb3Ttfg6H+_RpNQGSYKw9BLEwx3+EysXdL-wbpd1pkGHQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Add support for VMware guest specific hypercalls
To: Doug Covelli <doug.covelli@broadcom.com>
Cc: Sean Christopherson <seanjc@google.com>, Zack Rusin <zack.rusin@broadcom.com>, 
	kvm <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Joel Stanley <joel@jms.id.au>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, linux-kernel@vger.kernel.org, 
	linux-kselftest <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 3, 2025 at 5:35=E2=80=AFPM Doug Covelli <doug.covelli@broadcom.=
com> wrote:
> OK.  It seems like fully embracing the in-kernel APIC is the way to go
> especially considering it really simplifies using KVM's support for neste=
d
> virtualization.  Speaking of nested virtualization we have been working o=
n
> adding support for that and would like to propose a couple of changes:
>
> - Add an option for L0 to handle backdoor accesses from CPL3 code running=
 in L2.
> On a #GP nested_vmx_l0_wants_exit can check if this option is enabled and=
 KVM
> can handle the #GP like it would if it had been from L1 (exit to userleve=
l iff
> it is a backdoor access otherwwise deliver the fault to L2).  When combin=
ed with
> enable_vmware_backdoor this will allow L0 to optionally handle backdoor a=
ccesses
> from CPL3 code running in L2.  This is needed for cases such as running V=
Mware
> tools in a Windows VM with VBS enabled.  For other cases such as running =
tools
> in a Windows VM in an ESX VM we still want L1 to handle the backdoor acce=
sses
> from L2.

I think this makes sense and could be an argument to KVM_ENABLE_CAP.

> - Extend KVM_EXIT_MEMORY_FAULT for permission faults (e.g the guest attem=
pting
> to write to a page that has been protected by userlevel calling mprotect)=
.  This
> is useful for cases where we want synchronous detection of guest writes s=
uch as
> lazy snapshots (dirty page tracking is no good for this case).  Currently
> permission faults result in KVM_RUN returning EFAULT which we handle by
> interpreting the instruction as we do not know the guest physical address
> associated with the fault.

Yes, this makes sense too, though you might want to look into
userfaultfd as well.

We had something planned using attributes, but I don't see any issue
extending it to EFAULT. Maybe it would have to be yet another
KVM_ENABLE_CAP; considering that it would break your existing code,
there might be someone else in the wild doing it.

Paolo


