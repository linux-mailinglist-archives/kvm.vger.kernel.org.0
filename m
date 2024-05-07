Return-Path: <kvm+bounces-16897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B608BEA65
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:21:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2ED11F25704
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B6D16C690;
	Tue,  7 May 2024 17:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WgyruFN2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485848F72
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 17:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715102467; cv=none; b=FgKtrfCdPZ25AEftyNTa3NAkP15gxSIk5C6mEQcuERsW6TJwb2Bd2CJEYE/LRpedE3e7fI3a9aAUtk7uYsu20iCWZUqv4QB4z3tLUChEzvkQy9C15Emg1BSP5Ucj97vB6QsCZCCjK0pjPwaRMEom5Qh6sRsEPiwlwfO8IegksIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715102467; c=relaxed/simple;
	bh=Td1SHhWq6Wvpr0je4B4v22NIo5BXgO45S9j6dXvvWc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IV7I/3DmwuOQ3GoHR39Me7u/CUQRkjtc3j6pM3RnXSYhFBX0GFk3J+S729FzIaAJw/0cY/I2WPeELT1iwylbX9K+3op7wQou959q8GQqN45/r4a2yq2S64ESHa4XDOC96bNqvNBU9XQebz0Ytqv4F5wUgOY9Llu0R9cTpcS9FLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WgyruFN2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715102465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvToZ7WqfcgMTwXbVfEgk8KX+0yA+ouGzL56lXRGL64=;
	b=WgyruFN2NabItYQyDsYcOgZyBMM82U4RMCMojAXSj4761U8E2UUUovRsn2PvDipKaoeLtJ
	ZUlPALYeuBNiUIlt7WZkVxdHng8trUfHnwoAdXhfieNpd/4I1Li+wziZNdD+Ynw88oPcpp
	oZTR2tAWl43OMJlWpmbIu5M2z5eb3qM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-7kVL5xRCM0y_CwRCWjuGIg-1; Tue, 07 May 2024 13:21:03 -0400
X-MC-Unique: 7kVL5xRCM0y_CwRCWjuGIg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34d99cc6c3dso2065789f8f.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 10:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715102462; x=1715707262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvToZ7WqfcgMTwXbVfEgk8KX+0yA+ouGzL56lXRGL64=;
        b=gilVQYl7afU5B2C57McRDDHgdAMayNw9L0PRBvuePZjxrivUitY3Nd3DbEGAp//TEq
         zXyMgC7/lC3od5UKveQT1g59Szgvq2CO8VWZaCM64kE5jbPhIMb/lo9B4EtaD+3y9NBD
         F43Hb6bjBEvxJ4WbyK8D6zuspy5p1YJu2SynHDNo9VXeXcO4k7SvQ3DNcHqSxQsOY/Ex
         lRckF2So3gTEVcmLnf3rpCT2FL+1Ed9DZ4MeavhgJ8R4hBa1SpHQBI2xnEuXINWD5D0X
         Dcbss3lsnVkttuufYYc93H/V8iO1eHAeLFHA4H21N1qdBrvx+2nDh5Nil4v/Y0b2Hctl
         OeMw==
X-Forwarded-Encrypted: i=1; AJvYcCW//Sd3el2Y+uAXFOfZ4Gpvyqrif8od20/uC8FUdK/0aM8fZUrf5/3/wMsQ2jloq0B0iWt8Inv4bjUNApS8JSh6tZ3t
X-Gm-Message-State: AOJu0YyRLBzcwmfTTiHk7TzIRpgcARoJkmpB4GzcCRU9kVvD1vZQ9bks
	2K6bC0TZhTlsTKJ1V2q5Csgz2jZ8qxuA4xPJBPqtQJ86PFjCJvBBAZSIv59uTh2+mqOmlG0v6Ln
	N9cL9DFBmgFu9hos+zaGIQlxP5M1J3DYPHSLloYXf7sa/i9pejkoC6ECeJfiudfxH5rrfl2pwSq
	FGtgFNDyb0iTchaPMHImKHLzIl
X-Received: by 2002:adf:ebcf:0:b0:34d:b243:5415 with SMTP id ffacd0b85a97d-34fcb3abdd8mr272810f8f.70.1715102462533;
        Tue, 07 May 2024 10:21:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUEYCOfnDHy/EIoxjKGa949EaCj1vuoCQ08bvHLYnStorLuvGOeo1MfLxqAif12vjZfI5TzpEebQUV0rf5pgA=
X-Received: by 2002:adf:ebcf:0:b0:34d:b243:5415 with SMTP id
 ffacd0b85a97d-34fcb3abdd8mr272797f8f.70.1715102462154; Tue, 07 May 2024
 10:21:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423165328.2853870-1-seanjc@google.com> <4a66f882-12bf-4a07-a80a-a1600e89a103@intel.com>
 <ZippEkpjrEsGh5mj@google.com> <7f3001de041334b5c196b5436680473786a21816.camel@intel.com>
 <ZivMkK5PJbCQXnw2@google.com> <514f75b3-a2c5-4e8f-a98a-1ec54acb10bc@intel.com>
 <Zi_DNaC4FIIr7bRP@google.com>
In-Reply-To: <Zi_DNaC4FIIr7bRP@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 7 May 2024 19:20:51 +0200
Message-ID: <CABgObfYvkT39Msd11uJMZMquOsvNKBa=Z548JQZGfOmCF=TPaA@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
To: Sean Christopherson <seanjc@google.com>
Cc: Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 5:56=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > Perhaps we can make the kvm.ko as a dummy module which only keeps the m=
odule
> > parameters for backward compatibility?
>
> Keeping parameters in a dummy kvm.ko would largely defeat the purpose of =
linking
> everything into vendor modules, i.e. would make it possible for the param=
eters to
> hold a stale value.

We have the following read-write params:

parm:           nx_huge_pages:bool
parm:           nx_huge_pages_recovery_ratio:uint
parm:           nx_huge_pages_recovery_period_ms:uint
parm:           flush_on_reuse:bool
parm:           ignore_msrs:bool
parm:           report_ignored_msrs:bool
parm:           min_timer_period_us:uint
parm:           tsc_tolerance_ppm:uint
parm:           lapic_timer_advance_ns:int
parm:           force_emulation_prefix:int
parm:           pi_inject_timer:bint
parm:           eager_page_split:bool
parm:           halt_poll_ns:uint
parm:           halt_poll_ns_grow:uint
parm:           halt_poll_ns_grow_start:uint
parm:           halt_poll_ns_shrink:uint

Vendor modules do not muck with them (the only one that is exported is
report_ignored_msrs for which permanency is obviously harmless).

And the following read-only params:

parm:           tdp_mmu:bool
parm:           mmio_caching:bool
parm:           kvmclock_periodic_sync:bool
parm:           vector_hashing:bool
parm:           enable_vmware_backdoor:bool
parm:           enable_pmu:bool
parm:           mitigate_smt_rsb:bool

The only really bad one is tdp_mmu, which can change depending on the
ept/npt parameters of kvm-intel/kvm-amd; everything else is okay to
have in a common module.

mitigate_smt_rsb could (should?) move to kvm-amd.ko if the modules
were unified with kvm.ko as a dummy one.

Paolo


