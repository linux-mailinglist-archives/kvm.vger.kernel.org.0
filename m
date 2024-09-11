Return-Path: <kvm+bounces-26454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8839749EB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 07:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CE412880BD
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 05:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E6F57CB6;
	Wed, 11 Sep 2024 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evyHXgki"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089BB41C6C
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 05:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726033413; cv=none; b=URxLUIn7/tFCwPCJLbhZYOWl1Rc1Elgvtc7EZHddzw+g3WcHjHH+/MD9njKbzSmegle7v/GIp9h1sBuCpLI0R/LsdYXE/E+/C+YEYo14O/syMVGVDwgFQ25UpiDh0L4sjEcNkdDNnPr5Clh8dtR7dPDFT4V5doTtfnb8lkYC1YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726033413; c=relaxed/simple;
	bh=uq7cL2YP5AHRsxusKo+e+Vww+RDIeQAq9PQ59DupCmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IkjD3G+fZ3dZjNj304wvzEApHUd+PbgQMVmj13ABoIVQjCAiVbJy1vjMdrnB1SluqJTEnl38NUo5YvK6TrGMTGWdGirexG3TM1lRe3VJDAHcGhDtaM4RQD4XxinI6OesZwS4JX1kgSi87C0cFaNWmR+S123LMIafWZaxHBNcj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evyHXgki; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726033410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UK8H6r4Odw9reV2osCokRRcXZu0cJO2gIJAD0UxlifQ=;
	b=evyHXgkiG/jD5ZxS2OBHTp+HfvtppQjEUgs8ow5ihLug3fBzds4eWqY2BYU8nQhlE9vtim
	pJt5CLPhWFnyLPt3rVdCsBRxRH+ZUz8vYSwgzU6r4LWXdHWYDsFwvDOUYCS2qWC5tYYJZI
	DSMQ4tzxe1gEeI5MKYj/jbcHecA+f1M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-Z7KUw-nGNG-UmH5TZg4k5w-1; Wed, 11 Sep 2024 01:43:29 -0400
X-MC-Unique: Z7KUw-nGNG-UmH5TZg4k5w-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5c244732fe0so3672416a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726033408; x=1726638208;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UK8H6r4Odw9reV2osCokRRcXZu0cJO2gIJAD0UxlifQ=;
        b=slh8ZOSx7KfYINUnZH07lgDXCi2aVeeWMyy3TCwtnJ9+NNbkbSXpPiA886IZIufb5A
         wrbRyyV1Dt9xySlxJWBg3j3Tf2zkkzTnriHVpduV4qycbHOXw5sIMdbKe215SlrZgGyb
         lSSNGzTQKnsMQjYJDFMesmsnDmCWZGftcZPq3ueRfro/wAJNccVROs8tp1T/sAyoU5Xq
         I0eKMz18C8gqt636kgoMZzh3tdR9oANV/lUhIZ+ROM0gtF32fiODoC6iuy3fwzps+Rxq
         bV8rWbfjav6iPCq41ZzW5X2CKX2WH56T9AiaS+VL4yRNYBUvOVCqxAv2LdKg3qkwgl2L
         pROw==
X-Forwarded-Encrypted: i=1; AJvYcCVjO0Yd8crdf+jXqGWBz5ofpdTWOoEsP2YbXWeYm9JRxcM2OwlQOBARcrb0cj5VqXe2Y6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO850rfE8XQRnDpM+ryhaPdAFrbJ7PJdmh0MSKcu/Vx9Q1trRP
	bw9v5Lop5OzjfcKmQKqq8y3z5akYVYTbh6I7UIjF9+w0LwNJFIpwBx2NmhO1nUaKZRD8QfxjQ/+
	s2C2oazQqhxM8o8g/ohp5sHUhgmZijTOPP1zRJkJEEt++1/UlWw==
X-Received: by 2002:a05:6402:378c:b0:5c2:75d3:fbf7 with SMTP id 4fb4d7f45d1cf-5c3dc798350mr13364133a12.14.1726033408360;
        Tue, 10 Sep 2024 22:43:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGc5MZwcQRT3DXtntJPztRAM0mTBwU5yIMlVJi/Gh2eKdIUBMZDznADRg/tKPcERJPo77P+jw==
X-Received: by 2002:a05:6402:378c:b0:5c2:75d3:fbf7 with SMTP id 4fb4d7f45d1cf-5c3dc798350mr13364077a12.14.1726033407732;
        Tue, 10 Sep 2024 22:43:27 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-178-122.web.vodafone.de. [109.43.178.122])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd76f32sm4983417a12.73.2024.09.10.22.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 22:43:27 -0700 (PDT)
Message-ID: <19273472-164f-4128-ae31-46c79b9e20c9@redhat.com>
Date: Wed, 11 Sep 2024 07:43:24 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/39] tests/qtest: replace assert(0) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Keith Busch <kbusch@kernel.org>, WANG Xuerui <git@xen0n.name>,
 Hyman Huang <yong.huang@smartx.com>,
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
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
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
 <20240910221606.1817478-13-pierrick.bouvier@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240910221606.1817478-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/09/2024 00.15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   tests/qtest/ipmi-bt-test.c  | 2 +-
>   tests/qtest/ipmi-kcs-test.c | 4 ++--
>   tests/qtest/rtl8139-test.c  | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/qtest/ipmi-bt-test.c b/tests/qtest/ipmi-bt-test.c
> index 383239bcd48..13f7c841f59 100644
> --- a/tests/qtest/ipmi-bt-test.c
> +++ b/tests/qtest/ipmi-bt-test.c
> @@ -251,7 +251,7 @@ static void emu_msg_handler(void)
>           msg[msg_len++] = 0xa0;
>           write_emu_msg(msg, msg_len);
>       } else {
> -        g_assert(0);
> +        g_assert_not_reached();
>       }
>   }
>   
> diff --git a/tests/qtest/ipmi-kcs-test.c b/tests/qtest/ipmi-kcs-test.c
> index afc24dd3e46..3186c6ad64b 100644
> --- a/tests/qtest/ipmi-kcs-test.c
> +++ b/tests/qtest/ipmi-kcs-test.c
> @@ -145,7 +145,7 @@ static void kcs_cmd(uint8_t *cmd, unsigned int cmd_len,
>           break;
>   
>       default:
> -        g_assert(0);
> +        g_assert_not_reached();
>       }
>       *rsp_len = j;
>   }
> @@ -184,7 +184,7 @@ static void kcs_abort(uint8_t *cmd, unsigned int cmd_len,
>           break;
>   
>       default:
> -        g_assert(0);
> +        g_assert_not_reached();
>       }
>   
>       /* Start the abort here */
> diff --git a/tests/qtest/rtl8139-test.c b/tests/qtest/rtl8139-test.c
> index eedf90f65af..55f671f2f59 100644
> --- a/tests/qtest/rtl8139-test.c
> +++ b/tests/qtest/rtl8139-test.c
> @@ -65,7 +65,7 @@ PORT(IntrMask, w, 0x3c)
>   PORT(IntrStatus, w, 0x3E)
>   PORT(TimerInt, l, 0x54)
>   
> -#define fatal(...) do { g_test_message(__VA_ARGS__); g_assert(0); } while (0)
> +#define fatal(...) do { g_test_message(__VA_ARGS__); g_assert_not_reached(); } while (0)
>   
>   static void test_timer(void)
>   {

Reviewed-by: Thomas Huth <thuth@redhat.com>


