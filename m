Return-Path: <kvm+bounces-56533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 144FEB3F63B
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FB0D17468C
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 07:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65EFA2E6CA1;
	Tue,  2 Sep 2025 07:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPXixlpU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BB62E090A
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 07:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756797092; cv=none; b=XTOg33hFqdwtJY5GP4U27qa59KPEL/gJYyPngHHZlEXdIgtAKRi2bal6yiigpkRygyX+yJOZMnx8AUZjg1BPUaoedhRcesU1PHzLplkyx8I82UmxnfAebw/z+ZKIgtHFy97jO+KDHPiDNEnOiK7Y7NZd92TLGbFVD3gBrADisMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756797092; c=relaxed/simple;
	bh=IqLMwKkkt59SYd9Cy2XUMqz7cADLh+Lyy2fNTI3v6Uk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsbRAmr2bhpHINsy07lDdzDG+xK+Ut455WsNuLHyYvjfb+m/G3mGklbMY304lE/H1Fox0ZlV8K6HA9hWKuYZOlILSH8HLXCGkA0AtnDZqF98DHQveLDe7cukLnKblxqN3IGcfzIr94nj0rrXST6Fjw689kFPAqhNeE42CmzlYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPXixlpU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756797090;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/q3Or7FAMzqs9ZCwxniYPcM3YtbJGBMo6/RbTDPCPPg=;
	b=aPXixlpUlRwfnSzV0XNka8Blm1sX8fOFE6k8kXacSZkoz2BLr+wjwmumjZ0raHDRuWoH7X
	/C79XCs0Xov9xxS4ds7ykk2TyXUSonyDmMvAXn2Lyo74lTwh/hQ1WC0Ztc6NBhVTx2jfBw
	DkJv3uMEP3Fb5F/SOhsp8WKfbXA9Vsg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-YZeMbkpAPcqD6q_YHpOOyQ-1; Tue, 02 Sep 2025 03:11:29 -0400
X-MC-Unique: YZeMbkpAPcqD6q_YHpOOyQ-1
X-Mimecast-MFC-AGG-ID: YZeMbkpAPcqD6q_YHpOOyQ_1756797088
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-70de6f22487so91666966d6.3
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 00:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756797088; x=1757401888;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/q3Or7FAMzqs9ZCwxniYPcM3YtbJGBMo6/RbTDPCPPg=;
        b=tQRVtdgUCj21YemGL3Fh7gEclXUxS2Us1kVWcp8MDipc2INZy2ATfp441g6bRJCm1d
         33uN4XaeS9QU0Ywn8y6K5X0IQHAN8ZZRSSzn/6uVduf1UVjXE8wg+RGrIf+oDCEeK35W
         STEPIRW3Q0p9DbktMAlSaO7fULgbGYv7wGfOJi3kC6MgRnr+pK+uEabeYVZhuyF4ti5R
         lyP2PUTSsLB3rMN9zSvxFe1olehi9Dr7h8Pbj0uLu2cSecxiXwjmaDvDS2BSmDZCkvn/
         0UKuHccTfRg8g/Gu7zIEgu46fX/VkjDF1SA+FMJrbg2gGySiwKbUNM4XkT6/M3IX969q
         Bg2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkB9YUSoxvcWzZEENPCGEsP/VT6FXBse5g7+QSXX6ATvAx0hTVKJpCnyRStv671cMwDVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtHho3lHhEGOFQONNQ+hE4DOyPMXzXmcD25VVQMUcM6M25Y1yO
	Cw2p5dqt8KFtC+ggU/5t4oV0aaUF7f4KysITF9ijP+btiuveW3x4/3Nsf5hU+DNHbYTHII9F2pe
	3nmTMcHWQKJmmUSRNG9rrrJF5r6oUFd2cwXfucOA8lk/p9nT+H0hkS9Xs7ax/+U1j
X-Gm-Gg: ASbGncuV/fqCsBw0oxgdUoeidIdsG6fWqSChgm7VVPumcouvZhEw9RuKBOWGRXL2fR0
	yBcLwIS9xsM2MeUt+OjFWC1lGh3jT8hO6cf7dlJhGsAD8LlzTGp58jXz3T49AKOTjPvWF5FN2sS
	l6H+hubGZqmXfN0H+nXJV69P+4VC+Kf7Pb/QmdCK4q6DidWpTlBFdaHZwg28k9uGUv2eSbCIMqd
	QnPNyndX4hp2MUrjtWMJYQub293xLxm3MwMUoYEfzzZtxezxnT1sbZeiOdUuWMOp+OlUnmIV+OD
	U0LmZ46bsgy2yvvWTFHqOoZgvOm0QMol+lCB2HQqGXc43vJpSrLRU7dfhbGZld29Mcr2QS6WDqy
	t52eo6SALa9M=
X-Received: by 2002:a05:6214:496:b0:70d:fce5:e977 with SMTP id 6a1803df08f44-70fac78f374mr110447976d6.27.1756797088285;
        Tue, 02 Sep 2025 00:11:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG15EB+jbkVn3ZVi16tBlTJvm6GsH+57MS134IuEwF3OJ5dBPiG8SFU6VO5RFsxz1li1KEbXQ==
X-Received: by 2002:a05:6214:496:b0:70d:fce5:e977 with SMTP id 6a1803df08f44-70fac78f374mr110447796d6.27.1756797087787;
        Tue, 02 Sep 2025 00:11:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720add63b87sm7609876d6.29.2025.09.02.00.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 00:11:27 -0700 (PDT)
Message-ID: <16e575e4-215e-4611-a9ea-be44aa1ecb58@redhat.com>
Date: Tue, 2 Sep 2025 09:11:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] MAINTAINERS: Add myself as VFIO-platform reviewer
Content-Language: en-US
To: Pranjal Shrivastava <praan@google.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>, clg@redhat.com,
 Mostafa Saleh <smostafa@google.com>
References: <20250901191619.183116-1-praan@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250901191619.183116-1-praan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/1/25 9:16 PM, Pranjal Shrivastava wrote:
> While my work at Google Cloud focuses on various areas of the kernel,
> my background in IOMMU and the VFIO subsystem motivates me to help with
> the maintenance effort for vfio-platform (based on the discussion [1])
> and ensure its continued health.
>
> Link: https://lore.kernel.org/all/aKxpyyKvYcd84Ayi@google.com/ [1]
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 840da132c835..eebda43caffa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26464,6 +26464,7 @@ F:	drivers/vfio/pci/pds/
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  R:	Mostafa Saleh <smostafa@google.com>
> +R:	Pranjal Shrivastava <praan@google.com>
>  L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/


