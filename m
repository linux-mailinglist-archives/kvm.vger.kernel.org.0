Return-Path: <kvm+bounces-14809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B648A728C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D640282892
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7A7134418;
	Tue, 16 Apr 2024 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yg4y+BaZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619EB133400
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289303; cv=none; b=JKzulBPABg2P+MPt9mbiuND9oQcWY6aOS95FyWi/5QFegPSVxxZHr24+Y/8qLAR22j8jhIN3eEa7wwJGLhhQJh1X2FxU7xaQUMl4oIdHnH/lYttNLvxfBuWsDnLT706+vPsDRrFJf93Krus/TkRL1wIlg+zVhAWQcB2bNrHVOuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289303; c=relaxed/simple;
	bh=Vw0CuoQdG1Izc0eYCH/qYFN7N+2d8J9VLlSakCDBFi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+SVdgqxX2CnfsHnDMSkf0XLidmisuWi6mpHu8ba5gDnEZGEhrbzgfoEPOso0C7eIz6Sa4Bnr9q4+eVRISIfAkcehvCWNtChXu682yF1aTXa824vjCIFLfrOKhHFPbOiiD197+GL0mgaECgrsiUg7Tsnn3YxeU3MforLePx2D6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yg4y+BaZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713289300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEHTIuVZ7IxKlDHHHL8YBjswFPsEcqdIbeYKHCzhGso=;
	b=Yg4y+BaZK28kWUOlybkb8UYbyTkCsa/TlMg9cz7vuTSYiYLwhPxC9i2gaVLfT9uTBTSXPs
	uQVZ/bpwxU1CkOGtib57ix7vhIWBYheJFY8MoctfsFdoEx2QFYlZoKNq1AKaqdcd5oNmcC
	uvxRpRybqphJXt0br7JXPqsD3t21128=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-wzWjMC2-OKmrZux8pYwDnA-1; Tue, 16 Apr 2024 13:41:38 -0400
X-MC-Unique: wzWjMC2-OKmrZux8pYwDnA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-416612274e7so20017315e9.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713289297; x=1713894097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kEHTIuVZ7IxKlDHHHL8YBjswFPsEcqdIbeYKHCzhGso=;
        b=VjMUZnABw6wCCoDXKHdf9bNovosyKH+DQ1PDV5XSWxJ6D0SgOn6JfItQhPsHxLgE3C
         HPf0fKIm4VPJ0255wWTqhfwgmfD4C62Gh8VRQixTMdtX/oFfwgasDDD0YtoDExsgIFX1
         60VlQky/P+Unmu38o5BVYceOK8VjfAZU1MhMgfbKyXm3A+I9mFLCVBzqasCLSSrmfuqb
         Xj8NM0d+z05S340gbbiXs7Ak99Di09GJCJruk30XAf0pWXeIf8XOWZNNZCVmsPElrof+
         wqTY1SoGaE/vs/zKZ65OcZQ0+nV6WpgHwihC9tTOzRhIllBfIqV5c++aHfVZ/iu3o/yr
         263A==
X-Forwarded-Encrypted: i=1; AJvYcCXYt5sBfq3MbLtsHHQJwPJl12DNM7MQjBQazY62a1u/uxk41j8IbvIFzGEDPmqZT0Guj3pXJKZ/rAEOgACMxZKnLKbg
X-Gm-Message-State: AOJu0YxS15t7VxJD1lwL3GEkldyYzHMZ9+h+o73aoqfa9I32+k051ZRI
	nk4wwhWL20i6Yk32ZFeb3yadaNd8L4qkP4BkqEfjm/6BiUzR3vju5XXBEW3LuOn7MTLe9O/3BYj
	DSoekR9odEHrxdhXMzGWX1ds79gDPwu6HrjipluO/aBHOYwK5FH1/Ea8zDVlxc6OHUHO93lJQnL
	gVqs3u6AChnlhGrb3NBD7qRrD1
X-Received: by 2002:adf:e350:0:b0:341:c9d1:eae5 with SMTP id n16-20020adfe350000000b00341c9d1eae5mr8036993wrj.27.1713289297622;
        Tue, 16 Apr 2024 10:41:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyH8MDxjCQbeF4u8/ZnigxwSksZER5MaFWOeKNXzVAniAX9fCqV7NYMCr8Msf/kPf1h3wAmnL54k980D0yUQo=
X-Received: by 2002:adf:e350:0:b0:341:c9d1:eae5 with SMTP id
 n16-20020adfe350000000b00341c9d1eae5mr8036988wrj.27.1713289297303; Tue, 16
 Apr 2024 10:41:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412173532.3481264-1-pbonzini@redhat.com> <20240412173532.3481264-5-pbonzini@redhat.com>
 <Zh0mocWeGCGWmBvA@chao-email>
In-Reply-To: <Zh0mocWeGCGWmBvA@chao-email>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 19:41:25 +0200
Message-ID: <CABgObfaV416+wRoRLJzEU6q5D4CJcLh=Ja-K_OBrf6LBnU=KiA@mail.gmail.com>
Subject: Re: [PATCH 04/10] KVM: x86/mmu: Add Suppress VE bit to EPT shadow_mmio_mask/shadow_present_mask
To: Chao Gao <chao.gao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 3:08=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> >+++ b/arch/x86/include/asm/vmx.h
> >@@ -514,6 +514,7 @@ enum vmcs_field {
> > #define VMX_EPT_IPAT_BIT                      (1ull << 6)
> > #define VMX_EPT_ACCESS_BIT                    (1ull << 8)
> > #define VMX_EPT_DIRTY_BIT                     (1ull << 9)
> >+#define VMX_EPT_SUPPRESS_VE_BIT                       (1ull << 63)
> > #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK =
|       \
> >                                                VMX_EPT_WRITABLE_MASK | =
      \
> >                                                VMX_EPT_EXECUTABLE_MASK)
> >diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> >index 6c7ab3aa6aa7..d97c4725c0b7 100644
> >--- a/arch/x86/kvm/mmu/spte.c
> >+++ b/arch/x86/kvm/mmu/spte.c
> >@@ -413,7 +413,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool ha=
s_exec_only)
> >       shadow_dirty_mask       =3D has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ul=
l;
> >       shadow_nx_mask          =3D 0ull;
> >       shadow_x_mask           =3D VMX_EPT_EXECUTABLE_MASK;
> >-      shadow_present_mask     =3D has_exec_only ? 0ull : VMX_EPT_READAB=
LE_MASK;
> >+      /* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
> >+      shadow_present_mask     =3D
> >+              (has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_=
SUPPRESS_VE_BIT;
>
> This change makes !shadow_present_mask checks in FNAME(sync_spte) and
> make_spte() pointless as shadow_present_mask will never be zero.

It makes them wrong, not pointless. :)

The checks verify that there are "some" bits that are different
between non-present and present PTEs. They need to remove
SHADOW_NONPRESENT_MASK from shadow_present_mask.

Paolo


