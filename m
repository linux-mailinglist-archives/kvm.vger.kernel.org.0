Return-Path: <kvm+bounces-40975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274A7A5FF15
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 19:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D6A0173D75
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B871EFF85;
	Thu, 13 Mar 2025 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KnUvfprI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9BA1ACED1
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741889895; cv=none; b=j+VzMPz1lgkatHsmC3io10IFjkDxnPvXDP0XZ3AJyicjToA06vJX7d4YcK9rrncuxoPsfs5HzFbV0O5LvtCuo/akMHnByTFuoJV469O8afVd+aoxEMjl3EeQhKOjo/rSqBVs+zStkGUkMz5xSiB5ouvHDDSAqkEkptQ1eddRV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741889895; c=relaxed/simple;
	bh=YDK1UnGTu5tKXMAT6GFEDBy3mzaOn2JOJ7gYdpgf/eY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CgmRdHKyiXbeoY9Uy/WHuebc8JjAzl7AB1zELdzmoFlVo++5KUwCryw9tYAL4O87dV8APrxZlRIwCaKjAqWFcVH9ds1omrFJGU9cUUPrqhxl/88OT6MXduC4iOp7UloJuItMW9jiJjpD6SIoruRvcttNfRUNmn0bobr8Da3VkwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KnUvfprI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741889892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PdQ16etKuay8/M8ZeflAa/ny4zk3TfOP1l0ObABhMrk=;
	b=KnUvfprIbDuPj4LnScN8q3eYsVFkCTmH/P0Inm0hM2ouPnFGpX2zSvsubcVrfYQltc/mv0
	7uiz3JyzeS3i6+BI40z/sBKefnb8N9GIMiLHathd9fGbPd5IO5Ad8wAToAoDnw/pD7Ng1D
	p5NQUlM0GwfqAa4qxnmGGYTLOttDIw8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-QLpmmn0kNKWeJRWtADg7Yw-1; Thu, 13 Mar 2025 14:18:09 -0400
X-MC-Unique: QLpmmn0kNKWeJRWtADg7Yw-1
X-Mimecast-MFC-AGG-ID: QLpmmn0kNKWeJRWtADg7Yw_1741889888
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3913f546dfdso742096f8f.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 11:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741889888; x=1742494688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PdQ16etKuay8/M8ZeflAa/ny4zk3TfOP1l0ObABhMrk=;
        b=vm4ijzATkNSPlHeB7TzbRcmPX2awFxZwRAZn7kmeK6tcApQBNZ/WQVE3FCdenn/YQI
         ybV2S1btZSQcUyxxxihZ1ExLGsZDjbShmCbEtJ0DYj7rfPbIYAOevVbWwR5kqgP7/wva
         7liRRprhTsKPilAq6r4uAdablVg0Kgf3Qnq9i/Fvy622WkaiMTpE5ElIwbdaZ7fmZJFm
         64f3CzOKxYYyEKHwoB+N2bqA/77w324nYZDM+qVhU5ja49Uob+vzXYnOqmneU3B8tN4w
         WitzVtYEfjeLiFSU/VGBQm8+n5Xx5ph160r2r9n6Jm6YNa0Dtwwr4g2OzrUhCERuc0vu
         ViaA==
X-Forwarded-Encrypted: i=1; AJvYcCUt0zx6om7/4rSn9UBRKvfnWj8QTxKsAKg1QfzDphv6ZKNAhD3vPUy3eMOrpFjZVpYBwsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsQOp0FY+7bzhgBhOgeKsFHEsi7Voz4LrTGxNB4WGLpAHi1qyd
	ooCFsEbyQhGi91oWZGl7Qqwg3cxCbJ3CqLyH6nJnPtYDCAT5Wghd+nQ4oCZ/yn8uhei36jDWmal
	53jpRNEZ5Oo0+X+PgdJf9ScOF83uubpKLzxyGp+rpF78NaSH+uJsSEtMxYrXNIWnewwD+c6jQ25
	P7hQRrUvXbHSYs5MLLNerlutPV
X-Gm-Gg: ASbGnctVU42VB8m3Mh6zHj5+WXgQssvEeshYXADlkdZmHV9asN3ImiY5xQCQbg0fEV4
	7DXu0cvE9XF28wudgm4GTL1zt9CrIeYuREgv5g1NJ806mBOPX5zbup4ADaV770PoC6pPOKbI6
X-Received: by 2002:a5d:6dac:0:b0:38d:d0ca:fbad with SMTP id ffacd0b85a97d-392641bd284mr13164385f8f.14.1741889887914;
        Thu, 13 Mar 2025 11:18:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn9uBT3IvkVOhIdiFhj/VXarkQD69iABYBq66Zxni+59eGj+sxJz3YR9nw6jw3mk1ZsbIyl2zzBh8ze+xcYvU=
X-Received: by 2002:a5d:6dac:0:b0:38d:d0ca:fbad with SMTP id
 ffacd0b85a97d-392641bd284mr13164362f8f.14.1741889887561; Thu, 13 Mar 2025
 11:18:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307212053.2948340-1-pbonzini@redhat.com> <20250307212053.2948340-6-pbonzini@redhat.com>
 <405c30e9-73be-4812-86dc-6791b08ba43c@intel.com> <CABgObfZOhNtk0DKq+nB2UC+FFhsEkyiysngZoovoJP-vF43bYA@mail.gmail.com>
 <91208627-74a6-4d19-9eef-cc8da7b0a4dc@intel.com>
In-Reply-To: <91208627-74a6-4d19-9eef-cc8da7b0a4dc@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 13 Mar 2025 19:17:53 +0100
X-Gm-Features: AQ5f1JrZCM2rJqjJTTEzsnzrQOtrlcSbz__RxA5gYQFOWhjv4PSLeDpmeqbE1lY
Message-ID: <CABgObfb50fyDXnQawQQregR6UzH5mZukjX9iADtcrv1VemrVXg@mail.gmail.com>
Subject: Re: [PATCH v3 05/10] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, adrian.hunter@intel.com, 
	seanjc@google.com, rick.p.edgecombe@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 4:17=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 3/12/2025 7:36 PM, Paolo Bonzini wrote:
> > On Mon, Mar 10, 2025 at 8:24=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.co=
m> wrote:
> >>
> >> On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> >>> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>>
> >>> On exiting from the guest TD, xsave state is clobbered; restore it.
> >>
> >> I prefer the implementation as this patch, which is straightforward.
> >> (I would be much better if the changelog can describe more)
> >
> > Ok:
> >
> > Do not use kvm_load_host_xsave_state(), as it relies on vcpu->arch
> > to find out whether other KVM_RUN code has loaded guest state into
> > XCR0/PKRU/XSS or not.  In the case of TDX, the exit values are known
> > independent of the guest CR0 and CR4, and in fact the latter are not
> > available.
>
> In fact, I expected some description of how xsave state is clobbered and
> what value of them after TD exit.
>
>    After return from TDH.VP.ENTER, XCR0 is set to TD's user-mode feature
>    bits of XFAM and MSR_IA32_XSS is set to TD's supervisor-mode feature
>    bits of XFAM. PKRU keeps unchanged if the TD is not exposed with PKU
>    in XFAM or PKRU is set to 0 when XFAM.PKE(bit 9) is 1.

Ah, I didn't include that because it's just information from the TDX
module documentation.

Paolo


