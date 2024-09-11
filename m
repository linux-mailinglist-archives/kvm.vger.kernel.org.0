Return-Path: <kvm+bounces-26457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DCB0974A24
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F4CD283F83
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C7E762D0;
	Wed, 11 Sep 2024 06:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F9NnJSHK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745F138DE5
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035124; cv=none; b=cXkLFXlUnOfYjUfFEVhGI5llLPiYXeZyBle424JYgVgQD1pj9RR4wtcPHQvf4w66sNGSJsTw260jYr5l8xZ3u0iuqKGpmkeZmnx6nwfnPlQXPMEE/NQKsmJ4+8Zg4ZoJ0L53JPLbJn1IvPNoTZRBWDU+Vmj0Cv13d8oI/lJVGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035124; c=relaxed/simple;
	bh=rJlEf4IObiOvjDlODsgi/ze2ZGvpXn/XlSqSJF64zQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKgg2j9ThuhDvCKmDNHbsHmjPITxSVoiwltmJa3mJb86ZNCKZecSZvdHcdxjgm6XVW1LaAJwxJFGHvecPYK8sGCRovA5/UWR9c2nMnwpUspIprWrYpFOpaFbqHuuOUvwpA/81ESi374CB2TQOgE2279+At7pYuOoBGPW0TUg0qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F9NnJSHK; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d2b4a5bf1so220392466b.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035121; x=1726639921; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+34vrWrHaGMzGum0dUZAL9TUKidQHtpHEuGMkrYa2DA=;
        b=F9NnJSHK+nB9s/ho0Zasy+ya7BxuOPT7M88I8RXr0YeKCcwtLA4xzKEfcLxKINe9GL
         4JI5Lqp9ehVXkBho73n3x4mA6ViTN3VpGkBZV6SoM/YTDNiDns6Jltu0XXeDR8wsz8CY
         K/1o7keR7hXFLQ0j6VhWEsR1e5Py3fzJitTXB5CDTtHGKfljEdrXav9hg5NrlUT1X4ZA
         GzKZyTryJJa9T+33BVVtTEpdc89eWIAOAetwzYeaCclIJmAQTSZkXDWSem5RcaRMbz2o
         kSLztk90l60htF0eDXbneFRSPD3+yTStq0C6U/JCEOG40cz+xjuw3Vj2hQOLfgHsxzam
         DRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035121; x=1726639921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+34vrWrHaGMzGum0dUZAL9TUKidQHtpHEuGMkrYa2DA=;
        b=UJzOb+4eQ7veaiMrmjMzsAtfoFtKK4XrUVN1IH9twZv7hDXZb1HSXSPwQJCislo78t
         D0qNap9Mm8CEAcW3AworZ3VN5nxeEPvUKpHf/vE7eusnhpeU4rW+5nPUWLjDL5/pCiCr
         v8IsbOG69HYCpuHpQqvTVYxQ2j/pD/38v2ODW2ospCrjKjOMVYLXeREvJmTqyiSEup2p
         gNz//yL/RFDahZCBiHN27XHGj2f/g6jK5+53HLdolFHPTi5XMjhEMwDy+Eo/E8rWbw4O
         Mqtm7NsGMe4Gbai/C05y87b7X6uPYoMtkmrZ4tf8p1uT1DRtD3D7aDbkCV4TUD7it5GK
         6pWw==
X-Forwarded-Encrypted: i=1; AJvYcCVqqnitYfIEKGwX0AufksAS0igaHvwDVz5RKbYSby4KOm9yIxsfJvbDa69x2B4buaSujPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6qifazxpIgc6lziDMvzu2fGEmBlcc31E6XoR6ERQbH+z/qSCN
	JFEIqbyxpyhiyvBin2wwNTOMmcXlZg3VXcqrebZ9cvYJhorAmJvHYAEXbnsyWHs=
X-Google-Smtp-Source: AGHT+IH4ooGDdGMRExue4kMMs1ung0TKQVFYie4NWRoJANGnBSzGpgLK0lpNkpt9jkOB2KoDESp7sg==
X-Received: by 2002:a17:907:efcb:b0:a8a:85af:7ae8 with SMTP id a640c23a62f3a-a9004798aa7mr202327666b.11.1726035120608;
        Tue, 10 Sep 2024 23:12:00 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25a25897sm571142466b.87.2024.09.10.23.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:12:00 -0700 (PDT)
Message-ID: <cca80b37-2640-4269-af72-aebccfa47245@linaro.org>
Date: Wed, 11 Sep 2024 08:11:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/39] hw/char: replace assert(0) with
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
 <20240910221606.1817478-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/char/avr_usart.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


