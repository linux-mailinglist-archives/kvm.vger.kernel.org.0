Return-Path: <kvm+bounces-26488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3354974EA9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 036961C22291
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 09:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D200181BA8;
	Wed, 11 Sep 2024 09:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="d9AmX+0D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0BB1422AB
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047342; cv=none; b=d/YH927t/ei6qbcAVHr+FsNVWzYSrin9XoE8HxHKjlIeUwbLFedq1eZQdn1X7ebLngz50VW67kTcDpgd8M+s5wt1AC2mqbEEAuYmdprFohk3e1IioOJIw9wiiM/DfiNwrIhoEnDoYQJMERQ/6DSdUrPVkItm9+d/7lD6KhbWGqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047342; c=relaxed/simple;
	bh=c15gRWSIFLE66zfuUQ6cFSlghCjFDt2o1cP3Y810ols=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bJYm1HyutLawo4gz8vamncah02Gg0n7h4WuMu+jvN7znQ6fM6HVw3T4npsIFl1DJMsFBuzMBwW+MqAlWYOseCCsjDkY3Ll1AtxdhQhQM0etnPNCiJSn8ZG9IQUq2YPpB6w7hwv7/Mk33v8NI/gucMDgNsMUum2VvMOYUvyoXZDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=d9AmX+0D; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2055136b612so79274525ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 02:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726047340; x=1726652140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1u4hLYLb6JvJyT39AyvjEboo66L18yRm1sqg09O3j9E=;
        b=d9AmX+0Dm8twxEcBAm1DViaZeRznXD/7v9IAOcDRuB7PiisPuqVro/kudSKLMvGVEc
         cNjD+is13OyX8zAJsnC6dOWxETtsdZsOq6QGDzuJqVGsjBcNWRmWRIx0TdxBlp0iWZwa
         xPPySJWHaYsY9n0KjZINEzIH7/LmQ558uB+cJXhst6ic7CzaWfHGOvfKuRiSSKzG+Mpv
         GOtN+zOQ6qAHqYkMIJhChW2gLHD56hqza10cXIYtwhymr+flNMUNHBV+p400C5SnrkNO
         UnVJbFYE++alQUIyxcqHAPs9WHUb+tGNqLt5NFSXAZLhsAx+b1/WWdVxsMMEaDYuUDNw
         e+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047340; x=1726652140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1u4hLYLb6JvJyT39AyvjEboo66L18yRm1sqg09O3j9E=;
        b=VYYhm/g6ICE9fKsrHE5X0//jfbM4bIasTVUXnMKx9q5dUW8achdRB84zmYKqEGLpfD
         UU95wbGD7qAFtBHNb3ijFh8OTK83r1pphKwGey8zprbQaxqXNIo2LiM46yTFapRbSgFc
         Xz8JZnQz6MyOJZzg4jSxrdC8COIAGvyj1G5KgDe7tciX3pJQ382YhVAQSIWXzjWQv0fl
         DEazsHdFh55VSJ51fO6/di443Z3gblVmchZrQLeNosf3UXrWu6bFgvkEX4InTm8oCUCT
         MBCzGYFdTo7t2CQoOBBX3ySIQjDCePlphLNPfB+SDnZicx0a6s4IcfQ69mm0OXH17165
         dAwg==
X-Forwarded-Encrypted: i=1; AJvYcCWvkwNoS+idJdno5QmHLBas5kLzSbqb3pa37x3zh7hUFQD94PHfVeM5LaDqo+VZ0hcKBpM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHkOFA/VctxLGxUK0V/SS17cKowE2Dfr286msk3v/TL0H6Rl7N
	me6AOmFUmh1dydOf3h1UFU/aOI9RtXUV5NeEDn6CkYr53uUX2EpMMlOA/48iCn0=
X-Google-Smtp-Source: AGHT+IFUx/BwHC24gWqvFB3GjiXa6Pwl4/OE8FDUMSu9YsViqYb7FQaE3SBpFeH2lAaF7lGvC5UgZA==
X-Received: by 2002:a17:903:290:b0:207:3a53:fe67 with SMTP id d9443c01a7336-2074c5f7f19mr61649475ad.32.1726047340049;
        Wed, 11 Sep 2024 02:35:40 -0700 (PDT)
Received: from [192.168.68.110] (201-68-240-198.dsl.telesp.net.br. [201.68.240.198])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d8255dc0d4sm6861245a12.64.2024.09.11.02.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 02:35:39 -0700 (PDT)
Message-ID: <769135e9-c377-461e-86ed-e4e1de6ff0cc@ventanamicro.com>
Date: Wed, 11 Sep 2024 06:35:23 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 34/39] target/riscv: remove break after
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
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
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
 <20240910221606.1817478-35-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20240910221606.1817478-35-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/10/24 7:16 PM, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   target/riscv/monitor.c                  | 1 -
>   target/riscv/insn_trans/trans_rvv.c.inc | 2 --
>   2 files changed, 3 deletions(-)
> 
> diff --git a/target/riscv/monitor.c b/target/riscv/monitor.c
> index f5b1ffe6c3e..100005ea4e9 100644
> --- a/target/riscv/monitor.c
> +++ b/target/riscv/monitor.c
> @@ -184,7 +184,6 @@ static void mem_info_svxx(Monitor *mon, CPUArchState *env)
>           break;
>       default:
>           g_assert_not_reached();
> -        break;
>       }
>   
>       /* calculate virtual address bits */
> diff --git a/target/riscv/insn_trans/trans_rvv.c.inc b/target/riscv/insn_trans/trans_rvv.c.inc
> index 3a3896ba06c..f8928c44a8b 100644
> --- a/target/riscv/insn_trans/trans_rvv.c.inc
> +++ b/target/riscv/insn_trans/trans_rvv.c.inc
> @@ -3172,7 +3172,6 @@ static void load_element(TCGv_i64 dest, TCGv_ptr base,
>           break;
>       default:
>           g_assert_not_reached();
> -        break;
>       }
>   }
>   
> @@ -3257,7 +3256,6 @@ static void store_element(TCGv_i64 val, TCGv_ptr base,
>           break;
>       default:
>           g_assert_not_reached();
> -        break;
>       }
>   }
>   

