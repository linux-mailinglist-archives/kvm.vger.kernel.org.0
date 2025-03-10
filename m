Return-Path: <kvm+bounces-40589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2822EA58D10
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:39:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 959017A2A79
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F21221DAD;
	Mon, 10 Mar 2025 07:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R29FIV8+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532321D432D
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741592379; cv=none; b=Wm3AchTO48IyrjOfusWPASQaZykBiFfpYLbvrgLDsW2Z7WOIAQfx0/AChWjawT+6FeWWaChgRpl1GVjksDOcHgzeFqtbkJfLLqtkviy8OGYt//ZAcfJWSgDrXkLo+6IqTqijRheolLIG+zS9Y9w/nSfc9fRPW0YyIkayavy3n/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741592379; c=relaxed/simple;
	bh=/os74vmnkeTGtSIqGLWOPX/y3VQoXQeD1Sj0doLg930=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWJdReuzDosGvBeAXMlqAUmVqrUG5iEpT9hCz3xCn6ym9S3GY2umAO1z5WxKbVNhBv/mLx2skBdBLmTvTQQ2MZUDxtcTg2366xsZId3SkL7jP+mQchplcwb//7KN6cwNRx9AGsKv8WzNdaWa7EgJ+dlm5mPGVlWNhy1eu+uUX3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R29FIV8+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741592376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XTMuffHWHiP5kKvOAxhPtpCXB0s6ShpH9h7JKGRcOb4=;
	b=R29FIV8+PSATzd8TRhi5EGgrdYZATMnRA1H53eZ9Rwi9QMOsL7HeWLxXRIOKu8MjopoTVT
	XFMB5yIxy+4A31P5bU4aIHeb4Hj5yl5oSxcF9Vdmfxzs1N5DhYb1dj8mZkdoPmI1KK7Pc7
	oGUF7LZGBfRofKCZnIBs3dVdJ4cczg4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-eoIKtT1qN0izNLVqbrzxYg-1; Mon, 10 Mar 2025 03:39:08 -0400
X-MC-Unique: eoIKtT1qN0izNLVqbrzxYg-1
X-Mimecast-MFC-AGG-ID: eoIKtT1qN0izNLVqbrzxYg_1741592347
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf3168b87so3607775e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741592347; x=1742197147;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTMuffHWHiP5kKvOAxhPtpCXB0s6ShpH9h7JKGRcOb4=;
        b=XzS6bXyM+f1hFSBm5QicEwccLtALTaVO8JVj4HbJ6CmVmsI6m2ykbYEpiHftSi1rLA
         F1A/qkkN3AISOM79/kMK3IIymy13xl7XmE6WaL4w3TCy6xjl3aYTXg6dX3a/sOUdN5jj
         c5jmbCPB+q7y21AZ2GLaVHkys3u/Y8EtBktbrSHxRNn7we9oWXYYf/i6YRZSKBAElHRu
         MbCssRtEKIQOYimacNYgxIm5M0zaEt0tMNqzCombqMVrdXU5efA3EtNuq9SKOMe+IYtl
         VAd28PHM8kdsR6yv26CYgHZHguute+quiooeM06ZS76d3hBb5tKjpW2UJO+elCFsZCVH
         c8EA==
X-Forwarded-Encrypted: i=1; AJvYcCW3gTrXfVX9bgcvayht22RZ1bBFTDG7ZF8QGK9p6j283dUYs4uXllKslUhCOsSu85KnhQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBkShsPEZlhur48QNm0lKdf6D7rQWTZLazr0FJaq9H77GqDk/D
	Y2jOS3pU3ARxEXOOAWDQIKdSB651+vlSqsaJlFKvWmsnYP+dlvWslVuuTLKQOLdfMWLGZgjxOH8
	v3+HLf4hUUpVNoxijc15ES4Zg1FKxMG3fpdpnBiIsdCmM45OcjA==
X-Gm-Gg: ASbGncsqdSdXL7g/YMpnKT+8YN3oDA5cWH3hXdKOIWDOfmBKpKRqC271Pk9rxbudSsp
	1MkJcV7nvwDvQRfrRFTa13r+BwWk+Yr+35ox8eifiV9SNg80fItKjzqE3CsT0K7LGMN23ZcPhUk
	E40kYZ8UWVQASZc1U8RTheMVH3fw6DrLX5jLui6lvGYfq+s+kTcfN411oLfZHCjE1WcejtrCoSv
	Uh3kQOjiQ8HgM1l27MXO1rIiKXrHwlvFfo7gA9s98Zoi0HBVk1bm76dQYDisRvtExkv9piDS+Il
	0cLr/kmDOgOhoO/AIR6jsfcNXW4VyhBs2TyHiJ8GAcmollSPRas0hQ==
X-Received: by 2002:a05:6000:18af:b0:391:3b1b:f3b7 with SMTP id ffacd0b85a97d-3913b1bf54amr3943374f8f.28.1741592346892;
        Mon, 10 Mar 2025 00:39:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERVrccxMaDvFHfA/axVTnsG3yvvvqw2jmoYRLjVetnnsjaBmXDpA8DPw1SKqycih64FaQ3eg==
X-Received: by 2002:a05:6000:18af:b0:391:3b1b:f3b7 with SMTP id ffacd0b85a97d-3913b1bf54amr3943345f8f.28.1741592346486;
        Mon, 10 Mar 2025 00:39:06 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cebe3f1e7sm65215175e9.13.2025.03.10.00.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 00:39:05 -0700 (PDT)
Message-ID: <09b501c6-0d7a-4182-a432-2e411db9666c@redhat.com>
Date: Mon, 10 Mar 2025 08:39:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/21] hw/vfio/igd: Compile once
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-14-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250308230917.18907-14-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
> The file doesn't use any target-specific knowledge anymore,
> move it to system_ss[] to build it once.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/meson.build | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 6ab711d0539..21c9cd6d2eb 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -11,13 +11,14 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
>   vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
>   vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
>   vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
> -vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
>   
>   specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
>   
>   system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
>   system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
> -system_ss.add(when: 'CONFIG_VFIO_IGD', if_false: files(
> +system_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files(
> +  'igd.c',
> +), if_false: files(
>     'igd-stubs.c',
>   ))
>   system_ss.add(when: 'CONFIG_VFIO', if_true: files(


