Return-Path: <kvm+bounces-2844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6117FE837
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 05:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2118D1C2033F
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6A7517991;
	Thu, 30 Nov 2023 04:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQrNILGP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CADD5C
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 20:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701317838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o1gushqAiHQ23GEZEOV13TzTKkCoZS1NFR10zi092Pg=;
	b=HQrNILGPB6YpSwawfGQx7+M8wnGm7voNK17SsFghGJ6WR8v5T3YdxBkS4ETYBtBVcB2H0z
	M+1KFBOLU4XAnxFsfoV6YAvWF+KHIs5UJsLpG0fL1JG+mHAVeD9cVrmPmQZKa8sRfs+vrP
	UnUYpGKsBSb+vGY2OF4BBVOKHhfimkA=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-qN8G9IMWO-WdLd40hbmEMw-1; Wed, 29 Nov 2023 23:17:16 -0500
X-MC-Unique: qN8G9IMWO-WdLd40hbmEMw-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b5119f7263so129973b6e.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 20:17:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701317836; x=1701922636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o1gushqAiHQ23GEZEOV13TzTKkCoZS1NFR10zi092Pg=;
        b=t+TFUV44K2fee18QKFy3yH0K6TOHowMl3l1+cGLHwKg6G9cRMHSg/KJ2BEki2NM8jd
         wKoGRQhAS9JDp3rbVkOsROZXV7d3YRJOZa/2DoL5LxTNsf76UcXJSic35Ir5CvT9oGYv
         v1NsHRK216MVGIf7xM7N8+KNIy4rpgn7PxXG82665esZbak+bj/VcpKwWnRrJufQLOC1
         1WyGEEOiTc0p2WGeV+OscsjAN23Z3dXFMS+Sx3WcQEE7+nZfT3sw1GQtkyZnn1/ra8EM
         RJSLHemmOZBRGuM58wyCapkfA1fV+f0bjYLi1oM4lx7NARkyti5gViF2v04LnyWujBIM
         kQHw==
X-Gm-Message-State: AOJu0YxgJ5BGZ9DDZwJDMdOHD6PK0O/DTjneTh7Mr8uBUZlIh3Pd9Llf
	9JHndB2oO+E9h4PuXF69H2oOkKopyVNyeU8ZYt3rRrSgc7AEl0iJETmtugRGo1IrFAPlW/xrbmx
	+2Y5rtsiTvAZo
X-Received: by 2002:a05:6808:2121:b0:3b8:5fb1:3574 with SMTP id r33-20020a056808212100b003b85fb13574mr19231981oiw.0.1701317836043;
        Wed, 29 Nov 2023 20:17:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFF/I4dHP0NTHDLJ07kE1nSAYz/sN38Hqo2/+sQEmk3lhRLo6bjADuJwRleLPyVTHCunNfFzg==
X-Received: by 2002:a05:6808:2121:b0:3b8:5fb1:3574 with SMTP id r33-20020a056808212100b003b85fb13574mr19231964oiw.0.1701317835768;
        Wed, 29 Nov 2023 20:17:15 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e8-20020aa798c8000000b006cd7d189aa9sm204205pfm.131.2023.11.29.20.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 20:17:15 -0800 (PST)
Message-ID: <926b91b3-4355-ac68-36f3-6352b1ac7285@redhat.com>
Date: Thu, 30 Nov 2023 12:17:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v2 2/3] runtime: arm64: Skip the migration
 tests when run on EFI
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev
Cc: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
 Colton Lewis <coltonlewis@google.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-3-shahuang@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231130032940.2729006-3-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/30/23 11:29, Shaoqin Huang wrote:
> When running the migration tests on EFI, the migration will always fail
> since the efi/run use the vvfat format to run test, but the vvfat format
> does not support live migration. So those migration tests will always
> fail.
> 
> Instead of waiting for fail everytime when run migration tests on EFI,
> skip those tests if running on EFI.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   scripts/runtime.bash | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c73fb024..64d223e8 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -156,6 +156,10 @@ function run()
>   
>       cmdline=$(get_cmdline $kernel)
>       if find_word "migration" "$groups"; then
> +        if [ "{CONFIG_EFI}" == "y" ]; then

I'm stupid. Should be ${CONFIG_EFI} here.

> +            print_result "SKIP" $testname "" "migration tests are not supported with efi"
> +            return 2
> +        fi
>           cmdline="MIGRATION=yes $cmdline"
>       fi
>       if find_word "panic" "$groups"; then

-- 
Shaoqin


