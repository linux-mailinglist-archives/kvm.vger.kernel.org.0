Return-Path: <kvm+bounces-26463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE078974A36
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39C42B25625
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925AD762EF;
	Wed, 11 Sep 2024 06:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ilelmLhs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202C078C9D
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035205; cv=none; b=hP6ZL/pGGhPpwRAHsChS/4L7o1+eoYOflemSHd/VX7689KzL5RhGJil6Q8IINRlvZ3rbPYzthFuCZypZqmMr8D3/LpI6rfaBeeWzbopFrYgzUkrOqL5pt2w/V96nDSPW77HVCNtYHk7kBQKnKPjqjInQwCXlEFXElREKOSuZi/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035205; c=relaxed/simple;
	bh=SOw1t2iQEI0RTchhfcYGx7KzEQfK9Htd7JETYiG+V6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7iVnxlimxEYFLJezY4XZzHUQCpL1D+keP2p+TIWkunLG2wHdtVfGho3INOt3QhKzXjEXhlfKz6q8uWRAsnK2D/Fyn/Eu9mbyDdQLvSZ+qN3xi8geAwkd/L67GwnwUUlUoXPBORNPOIyv6EnXhqd4MxM+pywGE/92Ayh+SquQlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ilelmLhs; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a86e9db75b9so224482466b.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035202; x=1726640002; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8m3YdQ1Yw6tNSF6vZvuujJyxwJoqU3tbxgDnqqqX+iU=;
        b=ilelmLhsYPmg5NTAUU9qi0M8ShOsEwqUlm1GMH5dRBRyRbO+rQ43DrwuhBfzvCKd7o
         E/0CYToTzuFtZx3o3pV6CCmmBiHf3vf8gMBU2ptL8SovLaHxDTTV2tz8BkOkviX+9XLN
         GaSIDmxaTxcs9bZ4l1PEi7IAnNyQ1Dc7WBAJi+3DYCyc9Nek8/u3sSa3r0luewif3cGW
         mO8VYhUFi1cLdLFQRaUihrnIdEWhirz/mzfZW4Vjm4AQhVf459TBzu6dAV7Ua0mIPpn3
         KGSabWkLHhjnj4XPyIAVZD8Uga2OVNH/ghgX7FQ7a2HBTCE39b9oHaB3ROkZ846P7bEn
         O0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035202; x=1726640002;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8m3YdQ1Yw6tNSF6vZvuujJyxwJoqU3tbxgDnqqqX+iU=;
        b=FwgKG9dk12jpRhX9DAdxasPuak29y70VXi/kW7rKCxtqfTdUoeJ+RTQfBuhqPO0Zdk
         wHx5q8LsMLfDWvy3522zvrasK3VU+pWo3syGZd75ldN/ieJuWmtfHhMl7Wp3/FiJfvED
         LZWTMH/1gW6frUl34vDtD99fKXu3Lm/Ct3cdGNXSdGochoKBzzqhoroVnQNqnmdh6IQO
         hhgDy7FYTJmSh5Ghs6MSdi2sYHKF5HEnJ9cC0L5Z+WczUli59N0MN/X+x5I8POTjtOsk
         +pT0zfobp9pS/4IIFlPw/UmHhbCjEKen0W9K70is6Y5c10svLBtoZ5FsjJIi5IumzYwu
         DzmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL7gfrLrdeEeRE99YTaF+HLh/RluDhoyRFEYdzK0eP2I4Xx9mPIrrF3B7trvfeeaSTOd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy46LZfinjwX3dLm1ZaCGOrraLwqCvnKRu2MRGfHbqfccYE7Tna
	0g5MfzUpRvgRyyF8FPMMKz+hn2UAASq+uyTGGcuWbT4mBfWmzc27Fd0BUMyQWVY=
X-Google-Smtp-Source: AGHT+IE68BWI8McnnoxME1op7FLJ8c1uPq9jO1r69jOWkvX8u1v0gwomWUiv15OUhrOaghKJT6dx7w==
X-Received: by 2002:a17:906:d542:b0:a86:a73e:7ec9 with SMTP id a640c23a62f3a-a9004a66525mr186452366b.46.1726035202098;
        Tue, 10 Sep 2024 23:13:22 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25979e90sm573426166b.72.2024.09.10.23.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:13:21 -0700 (PDT)
Message-ID: <54442170-9ae0-4ca6-9ea2-fc80f49ece2c@linaro.org>
Date: Wed, 11 Sep 2024 08:13:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 30/39] hw/pci-host: remove break after
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-31-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-31-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/pci-host/gt64120.c | 2 --
>   1 file changed, 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


