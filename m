Return-Path: <kvm+bounces-9343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 552B485E9D1
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 22:18:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7F5D1F22379
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 21:18:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71342C18E;
	Wed, 21 Feb 2024 21:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RNrQIhvL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DD283CDF
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708550279; cv=none; b=T5MHdeAEXsjlQqnWVnToBRVxGmTtleDJZagJA0/fkD40hoOPQl3ZrPZut7/obf7v/pj/h514/Lh9KUPikXHtDQCngC9v1nh1/VKe7zW8Uv6npXYkUl3y1X7Y2Ae1/TD71QEd4bWdaSY6SPdgqLTwn9V2Wpd0GixoDxjIRqy4++w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708550279; c=relaxed/simple;
	bh=o0fEQPQnb7IOqfmYNPhGWv9TAqdi+gJASP9aDTjS1KE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FnwfEtpAAEc53ZwN5U4i2QYwynwwblObo6GWgHFIxj7Lcg3qxvZfMyDV43luzBe7QfrXgLzzvtKeRGf1eMj9AJqP5vd/OvQldm6H3Z9x2jIX6sp6kXhZ5POxZTqoodI8RHPKXp4Z9SNmIMmjbicPT4Ih5esYcaVW6iA6476TdnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RNrQIhvL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-412698cdd77so1284695e9.1
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 13:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708550276; x=1709155076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eeX4i0DK4SphSxibAwB75cUwYg+pHr9ZvM93pY2qrKc=;
        b=RNrQIhvL9LeQCT8jz9H/0Eh+r+4/QzLsBRbqyEoWG1p0S7w9Qouzj7m4PMx3NlPfhK
         KmcRiU9jAzWdB1k49jsTaVULjPT/qszmF9Sn5gBQ8erazQYQejWH3Z6bddVuWmNGEMAq
         bwjHL0gL6lbEZ3z/m0MhCpckMoqfSPaeGqas8svPgP3ukaeXOqAGkhiyGLH9vQXClS0M
         8zZektPWVIrq53V/duXX0zFU/RP2PE0OXAst8owNCIJ5/mBc97Rho3/v+hCvd2eyRAQw
         L1IYCIf3bAoSTzymuFwo6xoMclzECuQ99TZtt4mEv3l/sdG6aQZES9NsQ9lnmljzHx5h
         tnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708550276; x=1709155076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeX4i0DK4SphSxibAwB75cUwYg+pHr9ZvM93pY2qrKc=;
        b=EjTAKMl9J3Z9TywZkRX9aBGw3c0iOp6rqx2YfkCBz+HiaXusbIBpVQIUT++5NJkPqC
         raHDz2DfilCjqEtuc5wFzC1StFtYfFl0dti53t12CYY0GuusQac2kmkXlocPEqmeUDsT
         DwKzO5fqL56hGmnlnfC2SYaB5vhl4I/e1iXJhDEVpNPQXmdSLn9YCK67IZ4aQs9ZyZwP
         2woWH2S9vxXwk65kTFHWKd8HHk1Ra4PfDKOuM5FrX191LqOBKjYwB82oHnPhSg7f640A
         Xe7ohyCcMa3Ur5MAfAt6YvGGewU10yvl8/lri855yNZrJwgPQIKVOSB4OXOS0tXyFxD/
         3LqA==
X-Forwarded-Encrypted: i=1; AJvYcCVGGS39t5ZqYIDoU+adbjm/W3I04vXu0o5hGkd6ueWM43xBkrLO011NAcJ+ZeuinTMvhq+9b6HYlauLJTU/dLm58/3u
X-Gm-Message-State: AOJu0Yz3c4tjeAQQGzRKgay80PTvmcEkofqGGYQ13JK1o3iMjWX9uPZH
	JN+Bkc65JFZ5hK4JV1604DtT5SgGdwZlyG+zqtsxgETqtXRkAETTt3o3+YQhYrI=
X-Google-Smtp-Source: AGHT+IFOj7PyKzNFCqo+SYS30UxmV+sSq12WHe/P4LXDe7KdIc+6yJB5mBYlVdXE29jZtMYzAiF4lQ==
X-Received: by 2002:a05:600c:4686:b0:412:568b:50b5 with SMTP id p6-20020a05600c468600b00412568b50b5mr614541wmo.14.1708550275864;
        Wed, 21 Feb 2024 13:17:55 -0800 (PST)
Received: from [192.168.69.100] ([176.187.211.34])
        by smtp.gmail.com with ESMTPSA id u7-20020a05600c00c700b0040fb783ad93sm18906438wmm.48.2024.02.21.13.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 13:17:54 -0800 (PST)
Message-ID: <a38ae499-a5a3-4fb7-81c5-1380ecb965a1@linaro.org>
Date: Wed, 21 Feb 2024 22:17:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] hw/i386: Move SGX under KVM and use QDev API
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20240215142035.73331-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240215142035.73331-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/2/24 15:20, Philippe Mathieu-Daudé wrote:
> - Update MAINTAINERS
> - Move SGX files with KVM ones
> - Use QDev API
> 
> Supersedes: <20240213071613.72566-1-philmd@linaro.org>
> 
> Philippe Mathieu-Daudé (3):
>    MAINTAINERS: Cover hw/i386/kvm/ in 'X86 KVM CPUs' section
>    hw/i386: Move SGX files within the kvm/ directory
>    hw/i386/sgx: Use QDev API

Ping?


