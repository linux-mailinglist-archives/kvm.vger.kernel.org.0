Return-Path: <kvm+bounces-54222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA37B1D41C
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 10:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E4EB727FC2
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 08:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D4E2550D7;
	Thu,  7 Aug 2025 08:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhPmoXBg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E53C24503F
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 08:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754554377; cv=none; b=Lc6HkGeN/f/rR73MVx/u6D5omITLP4nIitdqavRQ/iQ/3DyaaMyeZofcVeGRBaBdqNejmZ20n69X0Or6Xeh1nEo2M60V0gZlA0bxh8BITMMMylLAxF+I3TpHulUMhxhZnOSsV3SElZIBMlIeAaPUQhE4AxoAnvlUvhnai7G6Ydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754554377; c=relaxed/simple;
	bh=k/6tc9NbcaDu74J8Ujd5CIcZNK+IHGpjJSYSQ2uZnMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uavigqyUY8RC9c2XvbRXAzlXC4V0zFPQDPTLphkuZ4oU6KWjvYn3wI77zezI5+//v6sAL4vIUXkPL2IA2qorzXxiM6PiJF72LfITFGLRcXHu4hwjKiZiTR8Xq+vqB3FSifP5pq5hlUT9CNusJ3oVZO36WAJMNlv+hqhcDsrVBDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MhPmoXBg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754554374;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qvbx3D1NwDDjkwzVbaeev/eBkCMCtqgbfvWKeFB+QqE=;
	b=MhPmoXBgJOhYvbSvKRuDerIQoV7mwg0Jz9S8CazkntVgtrv7DzABg+W28bMn59HrzfQZKT
	NR70DCJm6OsSTuiZexoGvvzfhp9Kbw4EtqbRQe/Ziz5fAi5e6jOENy5POtXF1mQBQAPCBl
	M45fuA1lAa8XLLi62jVRHqN7gVxRf20=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-zpcZYDPqNFaSkzCub9I7Ng-1; Thu, 07 Aug 2025 04:12:53 -0400
X-MC-Unique: zpcZYDPqNFaSkzCub9I7Ng-1
X-Mimecast-MFC-AGG-ID: zpcZYDPqNFaSkzCub9I7Ng_1754554373
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-70748301f71so15060946d6.0
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 01:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754554372; x=1755159172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qvbx3D1NwDDjkwzVbaeev/eBkCMCtqgbfvWKeFB+QqE=;
        b=gclbuGq4wSXSsNONTscDUhRsKIaYwKVCbJPnorCT0e0WHARi3+7O/49HRAL/OT90EM
         CduviekhAC4cZjkuyIpMcUlNaAyyWWssLIYaroqSxYAQFLRNivEr4PfNs/CznCvkacco
         OzXrc2bMFnR/vPFaYoi11bd2V1sI7r6owKdBTYPd1aSnwAeym9Kcz7qPjoijd1hEih7Z
         GKo8MCSWgQXuO1wsFkLIjD9jTD0w7WmUDjpn4EYDss85G1F2v4cbq0e7wN3CmP3HteaH
         7eJrliiLsFuMT5LlLg3MCsZuVQ0kLEvjTX9nuHw5FU8hOo0eBrtzvfgtAPLjXuSosfgC
         Hf1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU42kTktUirb+OcWLmy8BrXQiRSPRbwgI9KcEEM+oe9mm7k5CmP+9D2JoyHaJJlRLmU+D8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7wTAbNRCiNt4J1Zd8ktsJ9hFA9inIdiukc2YeowIGj7rZFVUg
	Gz0/uoqZw/QJk2BagbtSAVqPD1EOo9XKovTC610woBvOZJQhyiHoAfsagUwFsRqLDE/BEE885Ni
	ZY340ltmfgledLR5Bna/5xseQA9JncAJWzk7NU390ZqSuFldi56QKNA==
X-Gm-Gg: ASbGnct1sT7lsQYJWIZoJHAkg9R2eyIl0PZLp6M7aQuR5XkrbFzS7RKOQstiozfgoEs
	7AbQwZcq6PWRHiuGPESBTYVpYFpdqgnrdchz5F0PuZQYbds1b00cFuy/sV5Hwzgy6lRQiEBJRBJ
	pRfWrMNJt9Ps+J3z29qwbdia3cgSJb+iUXqqxIuHlmV7JsU2wZj8zmKy16dt52Ag/KRrqqyqXYh
	t41zWlk31fEhdkG2DKE+ldu/grKhfIUlqE/JJCe7NvWfP5fUj6NEsOIuWuCEiksp5Ah8dGJembe
	JyLqIV+Zn1ELtYevyy1TlKxyuW2JcGk/KFV72xb1wog=
X-Received: by 2002:ad4:5cc2:0:b0:707:5ff2:ae87 with SMTP id 6a1803df08f44-709795648f0mr74596706d6.18.1754554372625;
        Thu, 07 Aug 2025 01:12:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwcZYfEQy6iy9UL2xTDhxg8p5mWd43fDI3rjApX13ozfe17GvhEWhlLZCOj6ouaWiLP3Fsdg==
X-Received: by 2002:ad4:5cc2:0:b0:707:5ff2:ae87 with SMTP id 6a1803df08f44-709795648f0mr74596496d6.18.1754554372130;
        Thu, 07 Aug 2025 01:12:52 -0700 (PDT)
Received: from [192.168.43.95] ([37.167.96.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cd56e1csm96276266d6.45.2025.08.07.01.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 01:12:50 -0700 (PDT)
Message-ID: <2cf5aed8-3636-40f3-9ecf-21270ad83f9b@redhat.com>
Date: Thu, 7 Aug 2025 10:12:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 0/2] vfio: Deprecate fsl-mc, platform, and amba
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, clg@redhat.com
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250806170314.3768750-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

On 8/6/25 7:03 PM, Alex Williamson wrote:
> The vfio-fsl-mc driver has been orphaned since April 2024 after the
> maintainer became unresponsive.  More than a year later, the driver
> has only received community maintenance.  Let's take the next step
> towards removal by marking it obsolete/deprecated.
>
> The vfio-platform and vfio-amba drivers have an active maintainer,
> but even the maintainer has no ability to test these drivers anymore.
> The hardware itself has become obsolete and despite Eric's efforts to
> add support for new devices and presenting on the complexities of
> trying to manage and support shared resources at KVM Forum 2024, the
> state of the driver and ability to test it upstream has not advanced.
> The experiment has been useful, but seems to be reaching a conclusion.
> QEMU intends to remove vfio-platform support in the 10.2 release.
> Mark these drivers as obsolete/deprecated in the kernel as well.

for the whole series:
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>
> Thanks,
> Alex
>
> Alex Williamson (2):
>   vfio/fsl-mc: Mark for removal
>   vfio/platform: Mark for removal
>
>  MAINTAINERS                           |  4 ++--
>  drivers/vfio/fsl-mc/Kconfig           |  5 ++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c     |  2 ++
>  drivers/vfio/platform/Kconfig         | 10 ++++++++--
>  drivers/vfio/platform/reset/Kconfig   |  6 +++---
>  drivers/vfio/platform/vfio_amba.c     |  2 ++
>  drivers/vfio/platform/vfio_platform.c |  2 ++
>  7 files changed, 23 insertions(+), 8 deletions(-)
>


