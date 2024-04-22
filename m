Return-Path: <kvm+bounces-15494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9498ACCBB
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:23:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADDCD1C20C81
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B3E147C82;
	Mon, 22 Apr 2024 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgzgoQQz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903BB4AEE0
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 12:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713788591; cv=none; b=pP4I1jGDntATAm124HChyYAM1ODQS767UmfRhyN50bQrEoi09WZ+m5v7+p0Yeh+EeH+EjT7NkmdFZL3UvUxeRPytIdrZDyyxA3XPy4FvYhGks/bgsz7NZmYLrWlKOB30oql2kqwjuKf6j1q8Rfo+VL+bx47vlOKiTUEMbAU0T8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713788591; c=relaxed/simple;
	bh=F7obnOZNB7/UePlmQ4/swyiJSlSeyZSBbGTCgkyWlp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NbNBrYZV7Bz1KW72AyQ+2k8hoJ83laczkdZW/7vasQcBQqu1NSbqNQX2ATWCFJ8M1Cawk9L0UcoU/6VX2ozSZUhlKxjl4P1OO815B/VRpDlhQOkfAJzrnZH1ObkHW8ORZaH4+59b1QpBfMLC/iBAqBUXvhCvMHjfBwzhmYE6IZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RgzgoQQz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713788589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A/ezKDbA2HN619P+c1weExzZDrmAB50w8fBX12Fo+H4=;
	b=RgzgoQQzTMOZ7aVHY1hTqMOIbsOX7cPZUIEFkvzihFfkjBCNjmbFTyLnmReYBMVpkCRRoP
	bDwQ30ek7plDHfzRqtNHga9w1bmm4wwuVVdvcndoIiuPuzB+tC4VZsq0WKBNXGg2aTL77O
	+LSfHWrbmYTUkv9fO7zKpX8zkUr6Rck=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-3Y6SVK_HOVanjzPKvzOJWg-1; Mon, 22 Apr 2024 08:23:08 -0400
X-MC-Unique: 3Y6SVK_HOVanjzPKvzOJWg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-343ee356227so2852000f8f.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 05:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713788587; x=1714393387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/ezKDbA2HN619P+c1weExzZDrmAB50w8fBX12Fo+H4=;
        b=qMlf6WEfgIeDj9x1zNDd6FYVrO/L9+qrcyfKVxD6eU1nNGN/cwEJ283jXCACDnlrCf
         pd2RigG8PBNqxMv58yTFdMaJJRacv2tCfkFbh3KJcEcp8JwsUhsEPm5P0hHOVy3BHJRi
         Ee7INbd3kZaeEOaps95K+Rq1AAl40lddUZmBBFG/kSlUV0ZckWrbwzDMhhurvApN+C93
         NMTewPPXLIv4O/+4DyJ0hC1mR8DJq5qcdOv/pFL/1toZozVnpIvEEhMiXrNXZmWR8zKQ
         KtXWvPTWnm8w1XSeP7veaWmttL5UWBASw/AT+LJNzdBVT5DEWarCJ4aPyLrfhY/NsCJZ
         1nlQ==
X-Gm-Message-State: AOJu0YznJLRkI6ZpFCqhiYqkr2tImU9Y39IcZz11a10y3VQYi6gbgfWP
	/qop0c+7iNla4r9Qvmv3GetdR0ddx28cGkvFHenSj6CaN6cJtzDece7MNLj30gTXc9SGUSlNK0x
	xVdxF4r7/bszOSJ5/KSMjsg6nnSGHX1aalKCRO5BXyiY8j/AIt/eiNUYTFpJOn5HcitkRYvKsz6
	4JwkidmhmH57GbZpwqXXlHziJK
X-Received: by 2002:adf:e912:0:b0:34b:4d2e:47d4 with SMTP id f18-20020adfe912000000b0034b4d2e47d4mr500938wrm.24.1713788587150;
        Mon, 22 Apr 2024 05:23:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3h4OmL+jYFXwcCkMIHWemcojF5sGIioXy21Ag0m5VdsfhXioLRiKuxM9attN9d1n5rFQo9UJTzdn+57ydq+I=
X-Received: by 2002:adf:e912:0:b0:34b:4d2e:47d4 with SMTP id
 f18-20020adfe912000000b0034b4d2e47d4mr500928wrm.24.1713788586839; Mon, 22 Apr
 2024 05:23:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418193528.41780-1-dwmw2@infradead.org> <20240418193528.41780-3-dwmw2@infradead.org>
In-Reply-To: <20240418193528.41780-3-dwmw2@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 22 Apr 2024 14:22:54 +0200
Message-ID: <CABgObfa0j34iEh81hhd7-t7ZM1GKAsvJb5xP6EoD2-c-8TnPqQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] KVM: x86: Improve accuracy of KVM clock when TSC
 scaling is in force
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Marcelo Tosatti <mtosatti@redhat.com>, jalliste@amazon.co.uk, sveith@amazon.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 9:51=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>         gpa_t time;
>         struct pvclock_vcpu_time_info hv_clock;
> -       unsigned int hw_tsc_khz;
> +       unsigned int hw_tsc_hz;

Why not change this to u64? 4.3 GHz is scarily close to current
processors, though I expect that it will break a lot more software
than just KVM.

>  static int kvm_guest_time_update(struct kvm_vcpu *v)
>  {
> -       unsigned long flags, tgt_tsc_khz;
> +       unsigned long flags;
> +       uint64_t tgt_tsc_hz;

... especially considering that you did use a 64-bit integer here
(though---please use u64 not uint64_t; and BTW if you want to add a
patch to change kvm_get_time_scale() to u64, please do.

Thanks,

Paolo


