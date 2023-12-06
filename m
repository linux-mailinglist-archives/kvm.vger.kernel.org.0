Return-Path: <kvm+bounces-3694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C47D807110
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 14:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 264F81C20C5D
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 13:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194AF3A8D9;
	Wed,  6 Dec 2023 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8Xo+D1D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD975C7
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 05:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701870233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGbNWein5+1xHR10S1uc1ylcdJmgisND/IaKWA1UWts=;
	b=U8Xo+D1DMdnqNguHr4SCsSKwh4P+KonC6cjmconVFwlb6n2St3ttTfyFoZ20NTfyDGPy1l
	CD2/c4fFLi+sG3abXuzBwI8W60UsXGqdVntLZC2M7xg7//X513glijM1TvJ5Ws+YgdohQx
	eGYxF/MPuj237JyxxGvKXZ89bLFzcz8=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-sEn03FmjOcCHLHfVoWbjkg-1; Wed, 06 Dec 2023 08:43:52 -0500
X-MC-Unique: sEn03FmjOcCHLHfVoWbjkg-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7c41e0d3de3so1829955241.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 05:43:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701870232; x=1702475032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cGbNWein5+1xHR10S1uc1ylcdJmgisND/IaKWA1UWts=;
        b=hlJvaP1aeZXo2QyIXs9PKmDCMJJwElxaA8sqDfmV9iiaSSuzph1LILH0L+wqQ3IQn4
         3Ksnd1ok80EISuJMxRz/rQdHY0HjWglXikdrWP148RE/rp64YQM++nzuxLDyb1FRxKba
         LuW9fAZt8L0raX5hhCWnnY+3FJys21RkiOWs2jEk0IoiyDmWpxoe8mSCqPClWIzInISj
         XW9M8M45T+jhmdVML2RDjeN820L2KoMSRXEbx/M6xTlYTxBIZoz93VjFo43nQtlT9XOi
         ZnmFkSRy+y4+6ZlZzkET78vMmIhlWMGz/VtKl9BOaKVu5z3qM9+fAjLqEzRri3jkJyKq
         MvJA==
X-Gm-Message-State: AOJu0Yz1G+16kXItd401912o/pKgBW2Zvrp5+hFPmdQlH07gexkfmJGm
	5YnvUj6Hu3n+99JyZelAXFkr3nof5t2HfanxmH4E/BXnFXPYGiKJ9uIXf0y7DLHJlpwLBr+f6Et
	yK1MEuuhM+fc6hkYhO854aSPrTr6D
X-Received: by 2002:a05:6122:4e26:b0:4b2:c554:ef03 with SMTP id ge38-20020a0561224e2600b004b2c554ef03mr940412vkb.21.1701870232153;
        Wed, 06 Dec 2023 05:43:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYw/IwMhZjw8QhOHqgPBLvQOT8KiowIQ+XS74Wf/xU6c5/sE8vHDL7fpQ0FUEh8TQE+7xHAguLn5NGS3q/sJ8=
X-Received: by 2002:a05:6122:4e26:b0:4b2:c554:ef03 with SMTP id
 ge38-20020a0561224e2600b004b2c554ef03mr940401vkb.21.1701870231925; Wed, 06
 Dec 2023 05:43:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205222816.1152720-1-michael.roth@amd.com>
 <4e78f214-43ee-4c3a-ba49-d3b54aff8737@linaro.org> <20231206131248.q2yfrrfpfga7zfie@amd.com>
In-Reply-To: <20231206131248.q2yfrrfpfga7zfie@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 6 Dec 2023 14:43:39 +0100
Message-ID: <CABgObfYbBbjXVR6YXBwt9v6Nmy-DNrCm4+kAEmWUJ-wMjjD09A@mail.gmail.com>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
To: Michael Roth <michael.roth@amd.com>
Cc: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org, 
	Lara Lazier <laramglazier@gmail.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 2:13=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
> > This 'Fixes:' tag is misleading, since as you mentioned this commit
> > only exposes the issue.
>
> That's true, a "Workaround-for: " tag or something like that might be mor=
e
> appropriate. I just wanted to make it clear that SEV-ES support is no lon=
ger
> working with that patch applied, so I used Fixes: and elaborated on the
> commit message. I can change it if there's a better way to convey this
> though.

That's fine, Fixes is also for automated checks, like "if you have
this commit you also want this one".

> >
> > Commit d499f196fe ("target/i386: Added consistency checks for EFER")
> > or around it seems more appropriate.
>
> Those checks seem to be more for TCG.

Yes, that's 100% TCG code.

> The actual bug is in the host
> kernel, and it seems to have been there basically since the original
> SEV-ES host support went in in 2020. I've also sent a patch to address
> this in KVM:
>
>   https://lore.kernel.org/lkml/20231205234956.1156210-1-michael.roth@amd.=
com/T/#u

Thanks, looking at it.

Paolo


