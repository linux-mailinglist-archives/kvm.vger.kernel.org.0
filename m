Return-Path: <kvm+bounces-14814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DC58A72AF
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 428A3283185
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB5113441A;
	Tue, 16 Apr 2024 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WUFaBZFr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3F013440B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289944; cv=none; b=im7ZvakAaT5Xo4xN3KSXxEzLkIOU42UQLfraKMavQ0CIaUWxqCG+czIanWFZ2oLFZJvdwdVjo0Dy/tdCqMDE8g3aGxokzQIw7viiB1ort9wRpYdpNfDVEMOlIPU+t0wP93f6CHpyIFHv8zzfrnCT8li6LFMVY4lfnI+a5ZTQGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289944; c=relaxed/simple;
	bh=RL5eJnIJalr+wZY+keQX44XIkYazCOOVBqQCLKNHyck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MtI1HULQypjl+2L5nZ7EzVJQKdmv6R7eva/LOs6+Q5SvFRW8QXLH7aK6y2xsU2KIoASFDnuM2EUEfFj70vwC0hRodckdWIIY9Be6VOY+fuLhRTggRt18ddxYV+hwpjo/ABqzg8FpS4DyoowWsAV8f1SUJbIKAcwmPA6eASdfpNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WUFaBZFr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713289942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SF0Zwul4Q3WHBBYBSPasOP7oJvF1qRnA4BYTQJG/BZI=;
	b=WUFaBZFrA8VR0SQpi4cC1paqKD8ZYfWkod0zzRFxcFiPS0e+IMO42GQ2tZVzbclD67n2mU
	LPp2eDuexKpEwZYp8yOvvArIE+HcctuXSh2cAUw5prwjU34kHMJ/YtoTXL5DUdD98yly9D
	R2x7gBMQcvpGDeqKsl30inzwF5k5uAY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-CzkkAJeePxeDv1eyaukI0A-1; Tue, 16 Apr 2024 13:52:20 -0400
X-MC-Unique: CzkkAJeePxeDv1eyaukI0A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-343ee356227so2889160f8f.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 10:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713289939; x=1713894739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SF0Zwul4Q3WHBBYBSPasOP7oJvF1qRnA4BYTQJG/BZI=;
        b=E8Gy5KSuRRqzB1EbPLu+AK9dEMZBdjw9rZgWmgCblGe7C4mA3jmAvpK7tShMsaK/Bx
         Zc1ESQ1JgsMtjz63y0csaDUu99LS25ZjDRJGCG4QA8WT8IGN/u4ClkhwObTgY5Y8Vjqj
         PkH3ZJG2VEmnegyPu2UOZA+MRqqjMgj4auvb2wNDVWYNYdxoevw5P17/XFM1cfNvQazJ
         LNpDHrBnjb2GuJIWrU/6CQ5cxTlJexUBITX2WGPZuXYSc0uxY/FeaxSV9NMAftaAJHO/
         Ef4SxUZtw6s3FMuaOtOWd10LEXp/tIKQR2x+WTD96yVaOEYl+zPve1j1gNw0sdCbiyA3
         0wLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKMMKgtl1iqlS6OWhG3PaOFcD2fZy675cn+fyKB8xhHM/PGmuzVN/wLH4kVorE+/qooZR3qlvZ3pnHJE6lWxudP4Dr
X-Gm-Message-State: AOJu0Yx6U4jWAd4fLYK3PtmbElW+GCAocEVe9s3f4b+snJXs2pXeLbfH
	UlKC0XqVvNGpFWZD3IWUKEevgZ4rCTgyRURyXyeXkzA3SfVn7Wzjj27Gj6HO6XMZFfVyiVqTlOr
	QXcINrn8Kq8htimNejLEq61Zy+TmyPI2yPjJYj9b0ZQp1QMKjIUNj/a5/AyEF8+7ZQYNHURvxCK
	3tGZMHSPhw1enx4CURtWdQ/UAq
X-Received: by 2002:adf:eb12:0:b0:343:9d4b:d920 with SMTP id s18-20020adfeb12000000b003439d4bd920mr8641689wrn.40.1713289939451;
        Tue, 16 Apr 2024 10:52:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy7ivQXIfAyRYzvSmU//iKgpRiLbz5LJuWHhAqMPpsWN86EtR3FUEfuESD8Ag5BMPC4LO1AHCvyL1UG0bDSfQ=
X-Received: by 2002:adf:eb12:0:b0:343:9d4b:d920 with SMTP id
 s18-20020adfeb12000000b003439d4bd920mr8641674wrn.40.1713289939105; Tue, 16
 Apr 2024 10:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412173532.3481264-1-pbonzini@redhat.com> <20240412173532.3481264-8-pbonzini@redhat.com>
 <Zh0p6Jz5eKBBmWci@chao-email>
In-Reply-To: <Zh0p6Jz5eKBBmWci@chao-email>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Apr 2024 19:52:08 +0200
Message-ID: <CABgObfbsZKRidj7P72suZRAKcNQiRwFb73hi8iELU_g7kvt4Ug@mail.gmail.com>
Subject: Re: [PATCH 07/10] KVM: VMX: Introduce test mode related to EPT
 violation VE
To: Chao Gao <chao.gao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 3:22=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> >
> >-      if (cpu_has_secondary_exec_ctrls())
> >+      if (cpu_has_secondary_exec_ctrls()) {
> >               secondary_exec_controls_set(vmx, vmx_secondary_exec_contr=
ol(vmx));
> >+              if (secondary_exec_controls_get(vmx) &
> >+                  SECONDARY_EXEC_EPT_VIOLATION_VE) {
> >+                      if (!vmx->ve_info) {
>
> how about allocating ve_info in vmx_vcpu_create()? It is better to me bec=
ause:
>
> a. symmetry. ve_info is free'd in vmx_vcpu_free().
> b. no need to check if this is the first call of init_vmcs(). and ENOMEM =
can
> be returned on allocation failure.

There is no need to return ENOMEM however, it is okay to disable the test.

However I agree that doing it in vmx_vcpu_create(), conditional on
vmcs_config.cpu_based_2nd_exec_ctrl, is a bit cleaner.

Paolo


