Return-Path: <kvm+bounces-26461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95AB8974A2E
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FADF1F274B3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67621304B0;
	Wed, 11 Sep 2024 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vq7pUTF2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A71781AC8
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035182; cv=none; b=ooJwF64MTZCxbovh0U8/RFfM89gQrcZFhR0Jw6J74l6DkQ10RBvvtz1iqOHG96UM71LzSIkZzIHGjlJOpdEnXVgf/zMFuSrmqCIqXkc7YshCaG2xWZthWB62zfgypeThKkdBMnudZK+9D5FZooxj7YVYCkh0v83zCCC0s/N3FvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035182; c=relaxed/simple;
	bh=ujx1/mKJqjj3B3xa2F31LixPrLaB8Z6icFK7dF5LnXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oueYVquBKm7r6044sJGkgnbkbGmP6FMgz5lIO11UlKHaiWaoxKHaGXaH9GWaWllVOStrj7hrUj1lc/6qkymB299ZIxrHz3Y/zvm9MpgWdNdgx5zzSAePXYdtbcjgrP5buCsSzCMJv6BU2fJywMRhT79MReQ5O6JNwahfuwyxQFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vq7pUTF2; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8d43657255so462043766b.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035179; x=1726639979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nV2GkJj+s4ZXYPHgUeV+FAl58LUFuFK7PRMAYADUeA4=;
        b=Vq7pUTF2uMb6AzskfhOE/2E4IVIcCF9xX/0LQqkXkGypnFRHgRdgBi5JEkJTKXRV9k
         6sS+whREQQf41tU+fZPItgmihvuKx/gTR/n1NuxcawkhVN1Sav0IPL1fJNl1JhugDJ9c
         R/wxf+o6grTxkCBDMOvcYXUg+qq5mHwQGC2paiAjOziHjOanYLm++geMW+s/Bu02uG4S
         M40fBlcjkM9IXy3GEJplBq4Wcxso6FW9/tq61w90bbmMkFued1Y/fatXjUQUs1CKB+23
         HSNOL3fUf8nocjnucuSti/CUb2lyjFLBJG2YgQDdVMseub5fmy2dCtQkoONF5PpTKcLC
         rz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035179; x=1726639979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nV2GkJj+s4ZXYPHgUeV+FAl58LUFuFK7PRMAYADUeA4=;
        b=AfQFfKGUpTdb87oisbWYS7UVMGuyc9CIGZ/hXjVFRoPaf8j6lhOOMkGSgqBiNoPdFO
         A4tEO0nJ+YK3tXYijXFLOGGPBU8Tv1Q23aJ0GkdkdU7MA26ZlGLDK23knGP8wDMdl7ED
         xgSIgsA0iNxqGR3OGBFMfo0VYR6pnnCRUEQrHpT0Rg5/tmTNX8LUUi2dOmYZGvYTxSdB
         xi/R61/2nxz2W7fm5id4o8UmUA8yFjk/UAgGarR5kseb0x3zUytUUnS8wUKBjlMG2ugR
         iZGOTrYT6XFuHzPti0z+XBDGNIfTsAwf6wInoU4LRTTKD8NW3pS42651xGlCQGiO8A35
         Bk6w==
X-Forwarded-Encrypted: i=1; AJvYcCVeCP0ORdJfiQsRcw9bGvQ88y98sxk68RKvuGXEy4WYZlZJmo3/3avhMnCMMmLeh4YHroQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3xpSQLFLid0II3yAYE4c21uiDm2xoZgdu936KXtZB8DVVE7qt
	BQMzsG6+k83eEetoZFI21KhV9zKU5T3ejLwob6p5hXIVtKJL8n1H7kfMLLocUOU=
X-Google-Smtp-Source: AGHT+IHIzipxfmwSPfZxM97+WFZEwa6R0w7t+9K+6gYUNkqckbpC0ixR15l5B9O3GNoKRhN05fLM+g==
X-Received: by 2002:a17:907:72d0:b0:a8b:5dcf:493e with SMTP id a640c23a62f3a-a8ffae04929mr267865666b.58.1726035178494;
        Tue, 10 Sep 2024 23:12:58 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25cefa24sm581411166b.178.2024.09.10.23.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:12:57 -0700 (PDT)
Message-ID: <2b1b2d3b-7991-464c-abc7-5de5cc330297@linaro.org>
Date: Wed, 11 Sep 2024 08:12:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 27/39] hw/gpio: remove break after g_assert_not_reached()
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
 <20240910221606.1817478-28-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-28-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/gpio/nrf51_gpio.c | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


