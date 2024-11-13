Return-Path: <kvm+bounces-31726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 875709C6E36
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BCAC282FE2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2FF200BA2;
	Wed, 13 Nov 2024 11:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HI5k9OkE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA422003AD
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498768; cv=none; b=Utc3aXgvkC0ipB2tlda9lg8IoFMD/8f/j6iI7ytMkGvLFpG4wtRj4+tkSZ5cTJNgNPd8wN74h3lKagUAkcuvG5iROsh8btqPa8Gpw6Z4Bk+6OT7aRPM4LH4etWxm6i6L7BMkQ8GJxW0lenw42JvoiGCosyQfhuJTn91gmkERejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498768; c=relaxed/simple;
	bh=KoA7aneSXx3ZKIU7Ayorly39vcdZxYjy3Uy8mUAR7DA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f0OsajTjBI2pAd4PaAXfB9TngwdcBEiZEGPa8xyGr36lSMnJVteyU5nztw1kkzbJaUOmfguPdJLWJDf3zbIgWRPVLEkJHxDNarQaAOs99L3PSlTQiatD/Y7d6f3FfmTWsDIEBsnrCF+bBtC9g3jr3MM3WMQoe4cakxxgYnsKkhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HI5k9OkE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731498765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8GG3bgFV940PzUISamo/3voobg8H2uooMahXAdxS9M=;
	b=HI5k9OkED8iRMz4QCE6XLrCCyz/4vcsfm7+hVZLDrO/BMs75vAKvz062NlzDH61mVI+7Bl
	/krOxao7CAbtduR7PvOrbOQ8fnp98hlG3byx6n+BdSEA/0EyWzhTcNb5oxwmV4M1IdxcN7
	s/ArXG1Y3jftSxe+Kls55yNOSZl/pA8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-rOIxs7KfMNWk_NJGE4-XaA-1; Wed, 13 Nov 2024 06:52:44 -0500
X-MC-Unique: rOIxs7KfMNWk_NJGE4-XaA-1
X-Mimecast-MFC-AGG-ID: rOIxs7KfMNWk_NJGE4-XaA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d67fe93c6so3906974f8f.0
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 03:52:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731498763; x=1732103563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H8GG3bgFV940PzUISamo/3voobg8H2uooMahXAdxS9M=;
        b=koBmjl+Er9MUomd9YYWUxahUts00TQWKGF8xiJp8oSKrbPbdfu87EzG8+5dfNrKLhj
         MNqDTGq7306Dldc/PKldLY5D06GcLBwdoTyDRl7mJg6QIM0qxX1I2CjZalqjXpwZl9uZ
         vIVq4+tsj9PXJSzW1a3HD5GlKRPvH+CYTVgtGGMvvVV/n4577iRuB000kjvgGTl+ikm6
         bhHEoyX5moBwykgBeRxexv32R5iNPJMyNABjgdnXWre7ALqypJYszF5LXBvM2AFIycSl
         jawk1rM/XruqrHoTmkV1SY6ByC2MjPfRNXVceRZE1In0lYw0ZJ3ti3QnJbLrJ4puCGPz
         YBFQ==
X-Gm-Message-State: AOJu0Ywq05Cx2yeglqkGgpMr8v66MMlxwn+Q9KpqFE+RstBA+a2wT3Rl
	VcnARvTU5TNVFJ7OZ5VM/rWyFWtva8oskFA9DmBJvfQlqO7UwdFKu/arzVpb/wI9YGDEr22OiZJ
	HwBEQBsNW8TJyxq2/D67AQ4rC1eX0YoWp25rEWVtIh/yadxg9zfClBZHqlXzOaUtfrmtMVMUYqs
	WUTfxUBF/0W7AYjo2rhxdBE3zuVk7wik7IxdzUKw==
X-Received: by 2002:a05:6000:2a1:b0:381:b1b4:8ba1 with SMTP id ffacd0b85a97d-3820df886a5mr2194431f8f.39.1731498762737;
        Wed, 13 Nov 2024 03:52:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHInjjzc0odTC4+ABONcZUhIrP/Zbe+sjnc1EcFafsE/fBoawG4vrSRffP0crV4iPGugIA1AbuHWmrXbW/5lHw=
X-Received: by 2002:a05:6000:2a1:b0:381:b1b4:8ba1 with SMTP id
 ffacd0b85a97d-3820df886a5mr2194417f8f.39.1731498762454; Wed, 13 Nov 2024
 03:52:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112193335.597514-1-seanjc@google.com> <20241112193335.597514-3-seanjc@google.com>
In-Reply-To: <20241112193335.597514-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 13 Nov 2024 12:52:31 +0100
Message-ID: <CABgObfbxwac1kpECfFp0MA9Fmtje4ddFR7W=psCGjx=Trra7PA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.13
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 8:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a variety of misc x86 changes.  The highlight is Maxim's
> overhaul of the non-canonical logic to (try to) better follow hardware
> behavior when LA57 is supported.
>
> The STUFF_FEATURE_MSRS quirk might also be worth a second glance?

Yeah, it looks good but MSR_PLATFORM_INFO should be exposed as a
feature MSR (otherwise userspace has no clue what are the valid
values).  I'll send a patch.

Can I ask you for a review of the prepared bitmap series
(https://lore.kernel.org/kvm/20241108155056.332412-1-pbonzini@redhat.com/)
and possibly https://lore.kernel.org/kvm/20241108130737.126567-1-pbonzini@r=
edhat.com/
(this one is not a huge deal though, as it's mostly deleting code)?

Paolo


