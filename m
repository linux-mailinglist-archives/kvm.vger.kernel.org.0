Return-Path: <kvm+bounces-29399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7FE9AA1E9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1578282AC4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2E519D880;
	Tue, 22 Oct 2024 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrThVlAN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0648199938
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729599032; cv=none; b=g5Ob/u/mFK5dlnj8YEoP7j1HVBEY8x3mZmqHvbPQsaQxTIK8k8NodxQct3tZ+cRtw6Z1dXpmXCmTXIyoeRIE3rEQWS4S7PZ/bSjcskn5CUAq2RPT26N3gIOarkCI+xJ0TmiSObmNcauTZbjLI1HBlnwrfZZwK0W0gVbx2LgciCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729599032; c=relaxed/simple;
	bh=rkEM2LEKQaYY17K5UvDKFkrqBzMmTrnyQdSd0lWR/0I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mYLfJTEtV5H75gztWpOAoiM7NDP83jjVx1DLqtEW9fOc63EuB2DHIzLfW6psoSFHgKTWaH+qlY4sWuVULgIfKa+CUNrv4nIqOoGVJF2s+LGXQ/RHJg90hmC4eNk7fC5zXKwm8YfPY7WGzhMF/ngXuQi6OXHluN7uKPNqrvEbMc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrThVlAN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729599029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlZj3gYulImDNcPsctHRReteO7wMtRodjn9n2tXEDiM=;
	b=RrThVlANrYTIqUVyqnNcTssFMk7kbz9Jf1i7hwHWPICNV8wAb4YIZApWzO12cX98QDfX2S
	zzBe9pftGhNyPE6rhE6n06WeJpTW9tA1kxcke8BlHBNwNK1n8Y8h3vzMenBlo4+20rt8KQ
	yQ/CRSm0/+AC8M1d7N56MqrgKS/qrnQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-Bshi7vWkOCeYiDwKzJizzw-1; Tue, 22 Oct 2024 08:10:28 -0400
X-MC-Unique: Bshi7vWkOCeYiDwKzJizzw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d5ca5bfc8so2781763f8f.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 05:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729599027; x=1730203827;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JlZj3gYulImDNcPsctHRReteO7wMtRodjn9n2tXEDiM=;
        b=oegZ2mhc/1WlTF1ztrh2rE7ggDfvs5HCzBMSQ3foU5W/FqLsSJayiYmOzVROxnToPV
         pLwe4X1tq26LYjstIGvXJQeOaFqVxrG/LVNrn8odL9mpJSfCvA8t0dsJQg8MtaiB9hXO
         n5JMiyD0r4U8oXM/m4FhMtvwhEb3nTVOWHizc+Bt9NdYt/yxOqeFYLuMjaekToQ15xuG
         N3Sfj873RjL1tqQU8sOZcXIT92nq9OboA8OAieWPfdhuNgxVTAUGxPpLkpbTDJL0a5y4
         pMJog2pq1hKiovO/1Bt6k3pInmXA+exOIvyYYR1/zwRzMnPFHZghASf2fTh6VwNzxL4e
         9kDA==
X-Gm-Message-State: AOJu0Yz8FWTMTwd41AnLcsV+6CL85hh7MnZOi+fGgrm+qRXbBnJ576bI
	lyAa3TGnYe5eCKGXzh5Du86WdF+2HgOMUClNMLe02ndrlu7DSI9zWShmowWP3ge7OT1QQGCImP2
	FEJjBj16Ft43tG33K21jHKgU06jNXJrZ5TqTbwBOvJq2uboWmtw==
X-Received: by 2002:adf:f2c6:0:b0:37d:4afe:8c98 with SMTP id ffacd0b85a97d-37ef2169dd9mr1768372f8f.26.1729599027091;
        Tue, 22 Oct 2024 05:10:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IED2FwISsMS71RBCGO/niVCIqDBAj3+5LFK2ahqHe+l8fm/8jy8UTt1bgGQW98rnQRzbkpnUg==
X-Received: by 2002:adf:f2c6:0:b0:37d:4afe:8c98 with SMTP id ffacd0b85a97d-37ef2169dd9mr1768345f8f.26.1729599026629;
        Tue, 22 Oct 2024 05:10:26 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0a37b5asm6477896f8f.10.2024.10.22.05.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 05:10:26 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Mark Brown <broonie@kernel.org>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Shuah
 Khan <shuah@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: selftests: Fix build on on non-x86 architectures
In-Reply-To: <20241021-kvm-build-break-v1-1-625ea60ed7df@kernel.org>
References: <20241021-kvm-build-break-v1-1-625ea60ed7df@kernel.org>
Date: Tue, 22 Oct 2024 14:10:25 +0200
Message-ID: <87ttd4tk26.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org> writes:

> Commit 9a400068a158 ("KVM: selftests: x86: Avoid using SSE/AVX
> instructions") unconditionally added -march=3Dx86-64-v2 to the CFLAGS used
> to build the KVM selftests which does not work on non-x86 architectures:
>
>   cc1: error: unknown value =E2=80=98x86-64-v2=E2=80=99 for =E2=80=98-mar=
ch=E2=80=99
>
> Fix this by making the addition of this x86 specific command line flag
> conditional on building for x86.
>
> Fixes: 9a400068a158 ("KVM: selftests: x86: Avoid using SSE/AVX instructio=
ns")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index e6b7e01d57080b304b21120f0d47bda260ba6c43..156fbfae940feac649f933dc6=
e048a2e2926542a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -244,11 +244,13 @@ CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitializ=
ed -O2 -g -std=3Dgnu99 \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>  	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> -	-march=3Dx86-64-v2 \
>  	$(KHDR_INCLUDES)
>  ifeq ($(ARCH),s390)
>  	CFLAGS +=3D -march=3Dz10
>  endif
> +ifeq ($(ARCH),x86)
> +	CFLAGS +=3D -march=3Dx86-64-v2
> +endif
>  ifeq ($(ARCH),arm64)
>  tools_dir :=3D $(top_srcdir)/tools
>  arm64_tools_dir :=3D $(tools_dir)/arch/arm64/tools/
>
> ---
> base-commit: d129377639907fce7e0a27990e590e4661d3ee02
> change-id: 20241021-kvm-build-break-495abedc51e0
>
> Best regards,

I see this patch is already in Linus' tree, but anyway

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for the quick fixup!

--=20
Vitaly


