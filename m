Return-Path: <kvm+bounces-26455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 677FE9749F2
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 07:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256EA288044
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 05:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0120D54F8C;
	Wed, 11 Sep 2024 05:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tMkAJC9s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F10E2AE69
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 05:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726033834; cv=none; b=J4HQfDQuXug+giOCRefkk6Qtfwq/STdGOXEWqnVVs8vUakqHIlJQxVzEuKDcxJJAnwKAoN1m4QYzE18UeumGwSM/2uzIjawax8bC66SY7t2cbBNYGEHbzGTJCDlGnl4LFSvhYEK42CoWSo4wp52hH7FFtWCfJCVxIJ5ggLjKG9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726033834; c=relaxed/simple;
	bh=0dI+G1KtdkYBNxS8bqeMwI3CXbiv3RCSNT6JvxQ9A+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3w+OsbidKBjmozSwlE3nRFBY56XkNXc03IuGFvcntRMTpjdASDCUNQCxYhCEHNQ2leiSVXUVWCj4KYPVVSU13lDXRVGTlVOEpR1bc5elDRp8kNeTZU6mUuSLRC02h1ZDcLIG2QUj1af/2ug+wkt2ksRJ19O7943tu2AayMNu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tMkAJC9s; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5bef295a45bso2904799a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726033829; x=1726638629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JRpJ0yC+pw08bpum2VqRCaGzVKgHygWh66dJBO5C4+I=;
        b=tMkAJC9s+MgWi8OJc+pLWj8YclSwaFIp20UyfmMtgHwsURImXTi/elGhxk+528PPX4
         XcuxsW0JeMZLNnWVQ0LRkzm3FueI/mxIISBkHkP8rcKqXRhTVfniZT2kj464EMIwwzxK
         16fCo+gfhwaea2VV7qrPeNlibfdwZMcbx6d1coIUnQ8bFyLQkfLrH+Gju5YOB0b5F7Rd
         BCphWciJxGvE6LwGqqu1SJ6ryDKgi7giQqd86mzKXFNcVRWVDjeOgDsQFcMPGE8ZqXhU
         nVywqn1a0NP9IeiExaV6eWUwETICsErwo58E/Q5egO68gXc/bV2sLyW1YoTV0ZO/lQL1
         mMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726033829; x=1726638629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRpJ0yC+pw08bpum2VqRCaGzVKgHygWh66dJBO5C4+I=;
        b=kIDhNuUZ3E3mayf5JojaP/gsPxe1NNiU9yQN2z0Ji6U0tQiImjyyCaLZzMxUiYBStI
         wZ/KFk8Ni3AUzr/wv4kVYPINtvlF1A7T8Q7VR46v1srFKtMZjcWyIMcAPuQIeSw80l4p
         ysdVLR45W/FzG40vLPcwtRUGM+nfyWfpx/cTGlmAsodUtsFIA+Hagpitf9CTsijdGFbz
         ktve9MyWl6p0KnjUIFJrleXrGi5nPCqeEMfQsRXhuWoozQm9izmvYPhPWXnwDyBDGBFi
         sgZeJrj3z+uRq5JMMHdieeNeZPYUoA/HCpeazOoDaWow39lnrZxzoUY9IUJxOKBk2VPW
         17Xw==
X-Forwarded-Encrypted: i=1; AJvYcCW/lEX/mRCx+88Q7LqSb0UXD4j2WxwqgZwtaqBHM55Gyp6FzLljJ7ixEeE8Wky6pAVu7t4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXhGvNOTSXNHDUernM/CdFaYfOORw1m0fSsgUQO1KX30siXJ3j
	AlhZxJS6D8W80o1+1Q0S0JDhU8UY0j/bmWbDYB2bGhPCnUgs+JOp1SDRMKhPZ4U=
X-Google-Smtp-Source: AGHT+IHtNdz3JGktS1H6wUw6Ej9fupOVxu56YnjbGwav8RYfVLrdhTufWQK43MuqJkz8VsNhlc+DKQ==
X-Received: by 2002:a05:6402:35d5:b0:5c2:70a2:9418 with SMTP id 4fb4d7f45d1cf-5c3dc77adc4mr16028699a12.6.1726033829158;
        Tue, 10 Sep 2024 22:50:29 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd8cc1dsm5033853a12.94.2024.09.10.22.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 22:50:28 -0700 (PDT)
Message-ID: <3a7fc1f2-1468-46a8-9075-7b1bf1bd6149@linaro.org>
Date: Wed, 11 Sep 2024 07:50:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/39] hw/pci: replace assert(false) with
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
 <20240910221606.1817478-20-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-20-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pierrick,

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/pci/pci-stub.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/pci/pci-stub.c b/hw/pci/pci-stub.c
> index f0508682d2b..c6950e21bd4 100644
> --- a/hw/pci/pci-stub.c
> +++ b/hw/pci/pci-stub.c
> @@ -46,13 +46,13 @@ void hmp_pcie_aer_inject_error(Monitor *mon, const QDict *qdict)
>   /* kvm-all wants this */
>   MSIMessage pci_get_msi_message(PCIDevice *dev, int vector)
>   {
> -    g_assert(false);
> +    g_assert_not_reached();
>       return (MSIMessage){};

The tail of this series remove the unreachable 'break' lines.
Why 'return' lines aren't problematic? Is that a GCC TSan bug?

>   }
>   
>   uint16_t pci_requester_id(PCIDevice *dev)
>   {
> -    g_assert(false);
> +    g_assert_not_reached();
>       return 0;
>   }
>   


