Return-Path: <kvm+bounces-2467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF097F9811
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BD5CB20A16
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 03:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208CD524B;
	Mon, 27 Nov 2023 03:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJ9UN7R0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7483A12D
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 19:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701057580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCO1ba7StEvXUkbZaSH8q8Y/0Tm0SlHov8qnehHodAY=;
	b=hJ9UN7R00hgHi+p5y5UL1LSDBDq00bZg5ckb/Sz6rVO1vqyWPPVIA4ivADz0DAIDeWUmrS
	icuHAbTbr2dsSyN56MeiMU+XENnkQiZa/MUXZvpnGQupVS0xWPpJ4dOXNAreEXDFQv3Vos
	5yahavnWKP/OVYbEumFZ/hZ2PM0Tzs8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-q61HzMOAOF2wpU0Fu84GrQ-1; Sun, 26 Nov 2023 22:59:39 -0500
X-MC-Unique: q61HzMOAOF2wpU0Fu84GrQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6cba754b041so4203398b3a.3
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 19:59:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701057577; x=1701662377;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jCO1ba7StEvXUkbZaSH8q8Y/0Tm0SlHov8qnehHodAY=;
        b=kLQEzNlEiWn96dYljHL+TGHwEDdm31mjhLd4k3MY2jImx86moSYiFypOebWuwoEEq0
         HdrRAahWbxq8vV6blryE8BZYNXeQRFC4URtsQQAXnA8SlcNQVite1tO9GqcN7hivRbWT
         GjoVbjYynUDKQSenienm+ji+iSx9/3wxZJkfYPIDO0laznL2OOxIClgSeb2XNUpBd8Hv
         +H9tQq+/dgLkWbPv9CdKx3v6eaxO5QYUSOuMCKpC5zUy1857Uc6cbYoRzzm0f1J8JV6T
         shRcT57LdNUFgb8WnNSJ79ZYT8XmLTOab2beq1MpvrLC8UNHGDrnYsErAf0PyLoI95jn
         X77Q==
X-Gm-Message-State: AOJu0Ywuz7vzqXplBHjVNzisExGrnHTIOEXGrZ6j8O2Ku+N4ZilUNu9c
	6ao+6zeCLC/LvPjECgOS464jDMzEPlxFflh41j41sxMTYrRREZkWXb88GGddlq3Bt5zRIS5XWhw
	XAzIqBAPTHhWZRoBYaKMm
X-Received: by 2002:a05:6a20:e308:b0:18b:4e39:835 with SMTP id nb8-20020a056a20e30800b0018b4e390835mr10267596pzb.31.1701057577462;
        Sun, 26 Nov 2023 19:59:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFSttmnDmrI9CXz7zKxiGqoR4wLGsgde4Qlv1qUaaSNmGNmFM1u9eGXR+ZjHfeWDjJsA/4cFg==
X-Received: by 2002:a05:6a20:e308:b0:18b:4e39:835 with SMTP id nb8-20020a056a20e30800b0018b4e390835mr10267590pzb.31.1701057577177;
        Sun, 26 Nov 2023 19:59:37 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id 102-20020a17090a09ef00b002800e0b4852sm7502806pjo.22.2023.11.26.19.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 19:59:36 -0800 (PST)
Message-ID: <54e21c86-2ec1-4eb8-9c79-1ae14715beef@redhat.com>
Date: Mon, 27 Nov 2023 14:59:32 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 02/16] target/arm/kvm: Remove unused includes
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-3-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Both MemoryRegion and Error types are forward declared
> in "qemu/typedefs.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm_arm.h | 2 --
>   1 file changed, 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


