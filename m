Return-Path: <kvm+bounces-26458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 372BC974A25
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:12:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69AF91C21476
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB62762D0;
	Wed, 11 Sep 2024 06:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wHlGRf9g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE0F433D2
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035138; cv=none; b=twTv8IJpV2Cug+aG+NpfxKB8tVHEqb3D4pOzUqVeeRRt3UxLxAN2ocMfHU+MDthMZ92UNFyTB9vvNSnZm6FuL/GRW7soJpvPloNFAO+7OIF3Lmo6LJYFVFskAw4ABL9RoAzNETMVp+XRxYusI79JgmaJyCNWcy10Af8wXn52KQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035138; c=relaxed/simple;
	bh=Cxo42Salvr9VIK+YvfEOQru38lqRux4A6nSuvZ3x7tY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jubwp8/h8d8Mpmm9HBxYizncHN6xrK1wYSwJMGW6QycGrYF8AQM62YpQwcEPjVX/ATvvj18VQKnG++V0pO03lRPQKUHEr7dTl0lfPiNf20bVDPjVZ6i7l3FOkszuViUZgx0SQsAgYOzInZ5fNO3IjqavU4+Rwr+WBUCONh+amNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wHlGRf9g; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a8d3cde1103so541443266b.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035135; x=1726639935; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BkkcEu3n5L9MgsVNa4TxrfrxWX5AiHsFze3voBImFgc=;
        b=wHlGRf9gwUsDfBRFD8sufjlzFMaR/zU6NpWgIccy72h7Lrb4VVWFQx2XZoGwHCwyVA
         KxU1p7CDTgOENOFfWjkJqCm3VRC6uAQdy7z+6CLG3plexgNPxko7TbIIlwaOg0EOoPJX
         X264CluOhZofujUtPpECwsKD/T9SgFfRYOPgp/YE+2kSVtE8k5Qm4xieqQ9K/wXYbZLj
         ax0nX+lXddKepE857rulzlWwWMd3RCJSLm0Cguc+DPg9dj4rImwvfJWmqN/eqbLEvzQ2
         cwubuWkJX7c+5nrf+fk/OHQqNt4QnEfAFvHARIT+i9HlwOPkQDTmJTUfNKrGwmCBXqXh
         hKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035135; x=1726639935;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BkkcEu3n5L9MgsVNa4TxrfrxWX5AiHsFze3voBImFgc=;
        b=wbBe64aYmLbkE1sk8AvT0L7rfO6/MhoyD0JJ6bf39mX3ULvy4O8w+SyCHM6yskcW2b
         Bagqr4p28khjtmoXjwPY4NYul4TJz+QGbeD5d+fUkHJCAHCUq5bygFqNzx1RTL7dyaqp
         Bu68LFvkiVuKfHtQM1Uf/rNXzXtMqjNWMzqt1C0Y9hagy5slRFQa+HwcL0DfgLoOZWUz
         ZfObMVw3DU/HZFeSLcjf1EzMNz4t8fI2+/F9eQRupLDYj5ok2uC1fZwxj/Y/NyXPaEza
         za5wBVircvcL+M6AmKVyMt6/SBCTLO1Q9ebKASF/mK8X5YHLw9sE/s0xze0eteO+s0I3
         Z6hg==
X-Forwarded-Encrypted: i=1; AJvYcCVJSGfdqfW69gL/IGivOyxsade+w9NSfqLOTgsAhn8nXLamsrUmgtXA/pgMGlUjXPJCBto=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbwlQ07vaJsAL/hULmh0NIpCRf9xfI+WhTpUHGWiQBmLS5y/Wm
	DBpyc8WEL6M/5AE75FqHFXXfbuiZsDuYr96SHFsbrKBzNWBHii9HmARgtHSWXwQ=
X-Google-Smtp-Source: AGHT+IFEXCrfWvrxzcO/DkYqqT8ecNuaQdjylbt707JncAPQlkhPq1X3u4Intu8OV587nz4vFB5lzQ==
X-Received: by 2002:a17:907:6088:b0:a8d:1142:1d68 with SMTP id a640c23a62f3a-a8ffaaa54c5mr357151466b.2.1726035135459;
        Tue, 10 Sep 2024 23:12:15 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25835d97sm574179666b.4.2024.09.10.23.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:12:14 -0700 (PDT)
Message-ID: <2f25e433-ffbc-414f-a52a-5af1edf356b4@linaro.org>
Date: Wed, 11 Sep 2024 08:12:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/39] hw/core: replace assert(0) with
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
 <20240910221606.1817478-6-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-6-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/core/numa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


