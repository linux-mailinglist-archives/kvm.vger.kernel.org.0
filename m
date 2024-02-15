Return-Path: <kvm+bounces-8808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF0B856B1D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E031B23A2E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790071369AA;
	Thu, 15 Feb 2024 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtcsuB2m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA1B1339B2
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708018116; cv=none; b=uCKHjfSEWTxX6cSYCI1yJ8VK5Dlyw7yAJbU1DO9Gs4FYPZ5Dv9QjqSGvtL/KqOnmroIKX1Qio5ZdwCi6AJpnzjgQ8YlEVKb8WSk5NS2lUn88BDWqnzVDSrZSS1AklOJcfmkOdBKMqDwTxU1iRjAlo9fxvVvsNHyzj0yq9oV0KN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708018116; c=relaxed/simple;
	bh=dHZd5Ku4cKnaQTeuYbLj3B5g+jqGKkqQ49mVjgl6HnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ae6ghg21wMTkPYdBRZ284ojKxVl8R+ogtI8+Tq5B5ypRXC99sAXPKXNkmyIwjWVwlPkf7e/qSZ/In2LFq9n5liASanmNjmXXSiy0qraXdsqC9mFrh4ZQLGEjP0NQsYVBa0SreQ1LcRP6JMArx30lcL9SbqovYqyxel9nmOVebXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VtcsuB2m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708018114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dHZd5Ku4cKnaQTeuYbLj3B5g+jqGKkqQ49mVjgl6HnE=;
	b=VtcsuB2mzKcEaqozEMdun+1FASo/FSCTRk8o0ycwvtyV1c7ZaauHNOXIdgBS+m3fJmylYl
	31uV+w2VMpW1yKWxJzmyTM7egEPQoHUKVK7jg/gxfsphXh+ctxMdqleIlrS4sYi+fweUra
	Hn7v3abbvSozxVbOHaUPIBQAlXMV0ho=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-C1zC44KYMDK8x1UiAyLcgw-1; Thu, 15 Feb 2024 12:28:32 -0500
X-MC-Unique: C1zC44KYMDK8x1UiAyLcgw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-337a9795c5cso719801f8f.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 09:28:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708018111; x=1708622911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHZd5Ku4cKnaQTeuYbLj3B5g+jqGKkqQ49mVjgl6HnE=;
        b=WNvkBERnzr3t6J/86QRfFFkqmu1kglH8RGuJ7CtnKPmwktIVBI78goBtO/FMNwdpYa
         0wOU1AE1PuuS3bP6hd1/FSo0rf8LiOl7xXe8L2tyoJMiYTDnKfYt6KGiBTgHQMfRESaW
         RBvD5bBJ+1/Y3BICwZM2as9zwMTxN/BuAG0Fwm3HMtajwNkZ1VX/3YSTZnSznhdul6tA
         JCk+M+7MjlbfXlnHL1WVEaDZUomrYXI0kRcEKo3lvTAU97pdr4hBw8mwq289mD+9pSI2
         oJRu9SkCJC93O6ILzT0YsctagmYDYJ7IdMBstAgqFcNXuh4c0z202nt476fKgY/fSIN2
         T/hA==
X-Forwarded-Encrypted: i=1; AJvYcCXu9E6CZBZzM89XREcxBwYfuXWc+zPAu1WgNE6veSGbeeicgPXSZyP0llvZtxVyCmh6W59qDzEjG2326KJ1mUcnCvYv
X-Gm-Message-State: AOJu0YwMEWnvaGligf8A3/WdNWdYBW1glxxjGXnJKFG5y5GKlJ93oh1A
	6eJQWg5qJ2Catvccr2qOv0gQ8H2WLdlGw1aR3n2QUreRC8Rt+RREb0sBOFa8KV7W4dz3x3jhMCG
	KunfyMje4B/0dDdyGEg9b7HA4Rn8ygj71sIciu9v4sI7Qad4YMYVvYZPVnulhoRD15M9MrdGML8
	P45JDm2anGjtVT2MuXGqg4iRyU
X-Received: by 2002:adf:e70a:0:b0:33b:697c:1fc6 with SMTP id c10-20020adfe70a000000b0033b697c1fc6mr1728115wrm.20.1708018111227;
        Thu, 15 Feb 2024 09:28:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFvsu31+8oSt1VvAhl78DRahpkJxHYyoUVkf44jL3ze3T4AcbebuNJqhIs3oFW2TjAkTKdYlKbVjAlBEhbG0g=
X-Received: by 2002:adf:e70a:0:b0:33b:697c:1fc6 with SMTP id
 c10-20020adfe70a000000b0033b697c1fc6mr1728104wrm.20.1708018110911; Thu, 15
 Feb 2024 09:28:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209183743.22030-1-pbonzini@redhat.com> <20240209183743.22030-10-pbonzini@redhat.com>
 <20240215013415.bmlsmt7tmebmgtkh@amd.com> <ddabdb1f-9b33-4576-a47f-f19fe5ca6b7e@redhat.com>
 <20240215144422.st2md65quv34d4tk@amd.com>
In-Reply-To: <20240215144422.st2md65quv34d4tk@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 15 Feb 2024 18:28:18 +0100
Message-ID: <CABgObfb1YSa0KrxsFJmCoCSEDZ7OGgSyDuCpn1Bpo__My-ZxAg@mail.gmail.com>
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	aik@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2024 at 3:44=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> What I mean is that if userspace is modified for these checks, it's
> reasonable to also inform them that only VMSA features present in
> those older kernels (i.e. debug-swap) will be available via KVM_SEV_INIT,
> and for anything else they will need to use KVM_SEV_INIT.
>
> That way we can provide clear documentation on what to expect regarding
> VMSA features for KVM_SEV_INIT and not have to have the "undefined"
> wording: it'll never use anything other than debug-swap depending on the
> module param setting.

Ah, I agree.

> That seems reasonable, but the main thing I was hoping to avoid was
> another round of VMSA features changing out from underneath the covers
> again. The module param setting is something we've needed to convey
> internally/externally a good bit due to the fallout and making this
> change would lead to another repeat. Not the end of the world but would
> be nice to avoid if possible.

The fallout was caused by old kernels not supporting debug-swap and
now by failing measurements. As far as I know there is no downside of
leaving it disabled by default, and it will fix booting old guest
kernels.

Paolo


