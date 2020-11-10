Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107442ADC9F
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 18:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730530AbgKJRIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 12:08:30 -0500
Received: from foss.arm.com ([217.140.110.172]:58770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJRI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 12:08:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A367031B;
        Tue, 10 Nov 2020 09:08:29 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5ACA3F7BB;
        Tue, 10 Nov 2020 09:08:28 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 2/2] arm: Add support for the
 DEVICE_nGRE and NORMAL_WT memory types
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, drjones@redhat.com
References: <20201110144207.90693-1-nikos.nikoleris@arm.com>
 <20201110144207.90693-3-nikos.nikoleris@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b638943e-df85-0b8f-c360-fb4e59465c5a@arm.com>
Date:   Tue, 10 Nov 2020 17:09:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201110144207.90693-3-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

On 11/10/20 2:42 PM, Nikos Nikoleris wrote:
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm64/asm/pgtable-hwdef.h | 2 ++
>  arm/cstart64.S                | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
> index c31bc11..48a1d1a 100644
> --- a/lib/arm64/asm/pgtable-hwdef.h
> +++ b/lib/arm64/asm/pgtable-hwdef.h
> @@ -153,5 +153,7 @@
>  #define MT_DEVICE_GRE		2
>  #define MT_NORMAL_NC		3	/* writecombine */
>  #define MT_NORMAL		4
> +#define MT_NORMAL_WT		5
> +#define MT_DEVICE_nGRE		6
>  
>  #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 6610779..0428014 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -154,6 +154,8 @@ halt:
>   *   DEVICE_GRE         010     00001100
>   *   NORMAL_NC          011     01000100
>   *   NORMAL             100     11111111
> + *   NORMAL_WT          101     10111011
> + *   DEVICE_nGRE        110     00001000
>   */
>  #define MAIR(attr, mt) ((attr) << ((mt) * 8))
>  
> @@ -184,7 +186,9 @@ asm_mmu_enable:
>  		     MAIR(0x04, MT_DEVICE_nGnRE) |	\
>  		     MAIR(0x0c, MT_DEVICE_GRE) |	\
>  		     MAIR(0x44, MT_NORMAL_NC) |		\
> -		     MAIR(0xff, MT_NORMAL)
> +		     MAIR(0xff, MT_NORMAL) |	        \
> +		     MAIR(0xbb, MT_NORMAL_WT) |         \
> +		     MAIR(0x08, MT_DEVICE_nGRE)

Compared the values with ARM DDI 0487F.b, pages D13-333{5,6}. 0xbb matches Normal
memory, Inner and Outer Write-Through Non-transient (where RW=0b11). 0x08 matches
with Device nGRE memory:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
