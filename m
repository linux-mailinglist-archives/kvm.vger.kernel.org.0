Return-Path: <kvm+bounces-64483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6DCDC847B9
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D98293A5005
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9CA2FFDCB;
	Tue, 25 Nov 2025 10:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bEXNQbwu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2112F9C37
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764066436; cv=none; b=keC1lPD/r0RWbf+B1U6W1xlCbAu08R5mdpSZ2yZ2OymBAj2786vJU9hYbRG5l96l6fJZ/vxpyc6AVVJl7Tp6/jbPFGMJ/6urcF6nRtTvllUo645PMq0pNm2kFp+ubJSJMVvQUQywykLYR9ZUndbU4lGzlTT2OgwYc74wWQ22xiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764066436; c=relaxed/simple;
	bh=1hQFrkNWwad/yfYVYLGNuNnbxZHhBO2dX9swVeHeZmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EONr1D98uLahVgZ9s0CUPbixxCa4KLyXYMGIxC5ZhNaXkLlGF6uXzqDyuGqsoGW78pHVpzf819JPmt6FDjlbTJGjG+O65GtDVx7YxEtCWWq6K4UF+zI/g+goAQ/lEyX1Pwip61cWsUJZTtjRRRgKkkFXO1P4ApdcPhVYNm+3WYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bEXNQbwu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477a1c28778so58677985e9.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764066433; x=1764671233; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bm82jX7XCCW7aCI+a8dons42tFjRYTNRDP+rtZdOHPw=;
        b=bEXNQbwuQkgynA0HWi66tSC1f/xGR1Ks6TgcSu4JsqawLmCc2N8PkG250BxAkDYhT3
         FaBHZaMwU1J4pRY5b9XYJOu0dZLObZp+z1CleCgSIzn36pGLN3wQbT+r7txBaaxeWwi3
         nVknWxlfEqhWHiQv18hRgGCQ7EblAQaqfy9wytLow1qSOaetOLE6KAPY0t2K4j0ZP/3q
         Nx4KbcFBX92ArVs39MxXQ20J4K+eGwq4GK4KG5yG74Gk1CVNKOpWbSpFKrytFiPCiijQ
         VqVsWgFTmrxAz69MFldCvFsfU5bxtXhHiHcGYmzKPBnYBwr5Y6jCPZw5Mt42mJ6z96S1
         93Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764066433; x=1764671233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bm82jX7XCCW7aCI+a8dons42tFjRYTNRDP+rtZdOHPw=;
        b=orJOam9Aczc09aiLJSnygwwNdpKsV+OI8Y8Yj87gfXb8EQxbFbUtuRK/XLRGVkFUQt
         T77EtSkF+dt1GbSj706fItfabi03E+2/SWip5qluJbGWafEULCe7ezyH63cjQP6FOAz/
         LIzLHAeMau+k8ugCKv9PRRNf/cNACHAEHqcZ8k2yryRjai7g3WpJODM74l7COlXh9NCt
         HmKD1UuG628mrZjTjSdUGUYmfyvy8IHNT3/Uuj7gJcQipJTVZPi+S/b68WP2IdYRs6gb
         zlMt7HtBWR6FUUR1z8uotJDP7Mwss6y2dOoHDmeyARP1vE1/CQAZ3F2YOZqcTuvSucSo
         fF2A==
X-Forwarded-Encrypted: i=1; AJvYcCXOF05OB+Kfry/Uk5Gf860qV9zmkuv8mDvBrT8zP1ILqpODkbZkTNG9EU++ii4tunX7j0s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8z4lbEYC1fPsnVX8QJUYXrccERRDbdpXQ4Dqc5hmBhgwiQyNG
	puDxluhFtonenQzgTr4klBjIrhw5ivOjc3cKLNxGi0gW8v+a5QFKK1BUICMGe2QdG80=
X-Gm-Gg: ASbGncsbjyfnWadsw5Xyf8qvK0fT8sA0uC4MAqh5hcwhXX/Ixdm7M918l3i5aqPnuij
	0EJd/57VnsZfkYlpqKbhKa1tY1I0hYh/W3mTzoGnk+A81U3EuY9WW6IzueC6ATcjXIp4wPh4iS7
	FnabGw7m6WmM8hrt1/2qcjw5wOpmhUyK2jjl7Tni4/5squoNwxYhJUG4wZBgt00q7bEjLojoa/V
	feMYe+c1Ai5XrO7+10w4nPVEKWS+AUM+KgC2+8Pj1lEyLsg8nX4dPzbTi891n3N0tzoNHF+mGth
	N5wZwe6bC1/3dTEx/HhgbZ6U7PbGS8n67WGNa1YScF0b/s/ctafBh7fAepmlK9QDS7uRwE37uft
	q/GN/96tgxkA5Ytaj04pqSKs50O2OeDkjGj+Ak6+uDhqE9JUNHm6ChaE9LyWwuQSulinDthP4X+
	f7e9bFQBN5RtoI7diTURRD0RU4fbJynfuXorfIfWZDncEEIEFbGhBwxQ==
X-Google-Smtp-Source: AGHT+IGhbYTeSSFuslMqXUGJgEAmx4PJmp7EyajaFZpq/LfxEIoU4Z6Qn9frxs4dE4HLknKn1jcfKg==
X-Received: by 2002:a05:600c:3b1a:b0:477:55ce:f3bc with SMTP id 5b1f17b1804b1-47904b12f1dmr17118695e9.19.1764066432928;
        Tue, 25 Nov 2025 02:27:12 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1df392sm246300905e9.1.2025.11.25.02.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:27:12 -0800 (PST)
Message-ID: <79407b6c-1161-4b08-877b-e215d2058a5d@linaro.org>
Date: Tue, 25 Nov 2025 11:27:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/15] hw/usb: Convert to qemu_create() for a better
 error message
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-3-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-3-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Markus,

On 21/11/25 13:14, Markus Armbruster wrote:
> The error message changes from
> 
>      open FILENAME failed
> 
> to
> 
>      Could not create 'FILENAME': REASON
> 
> where REASON is the value of strerror(errno).
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   hw/usb/bus.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/usb/bus.c b/hw/usb/bus.c
> index 8dd2ce415e..714e33989f 100644
> --- a/hw/usb/bus.c
> +++ b/hw/usb/bus.c
> @@ -259,10 +259,9 @@ static void usb_qdev_realize(DeviceState *qdev, Error **errp)
>       }
>   
>       if (dev->pcap_filename) {
> -        int fd = qemu_open_old(dev->pcap_filename,
> -                               O_CREAT | O_WRONLY | O_TRUNC | O_BINARY, 0666);
> +        int fd = qemu_create(dev->pcap_filename,
> +                             O_WRONLY | O_TRUNC | O_BINARY, 0666, errp);
>           if (fd < 0) {
> -            error_setg(errp, "open %s failed", dev->pcap_filename);
>               usb_qdev_unrealize(qdev);

OK, but why not update usb_qdev_realize() in the same patch?

>               return;
>           }

Similarly, I don't get why you updated this (and the following patch),
without also doing the similar:

  - qemu_chr_open_pipe()

  - qmp_chardev_open_file_source() and qmp_screendump()

  - s390_qmp_dump_skeys()

Anyhow, for this patch:
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

