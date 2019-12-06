Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA5611569A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfLFRhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:37:01 -0500
Received: from foss.arm.com ([217.140.110.172]:51704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfLFRhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 12:37:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A52431B;
        Fri,  6 Dec 2019 09:37:00 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E51A03F52E;
        Fri,  6 Dec 2019 09:36:58 -0800 (PST)
Subject: Re: [kvm-unit-tests RFC 01/10] arm64: Provide read/write_sysreg_s
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
References: <20191206172724.947-1-eric.auger@redhat.com>
 <20191206172724.947-2-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <efe2c571-1b69-5cc4-3505-24d092a9f985@arm.com>
Date:   Fri, 6 Dec 2019 17:36:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191206172724.947-2-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/6/19 5:27 PM, Eric Auger wrote:
> From: Andrew Jones <drjones@redhat.com>
>
> Sometimes we need to test access to system registers which are
> missing assembler mnemonics.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm64/asm/sysreg.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index a03830b..a45eebd 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -38,6 +38,17 @@
>  	asm volatile("msr " xstr(r) ", %x0" : : "rZ" (__val));	\
>  } while (0)
>  
> +#define read_sysreg_s(r) ({					\
> +	u64 __val;						\
> +	asm volatile("mrs_s %0, " xstr(r) : "=r" (__val));	\
> +	__val;							\
> +})
> +
> +#define write_sysreg_s(v, r) do {				\
> +	u64 __val = (u64)v;					\
> +	asm volatile("msr_s " xstr(r) ", %x0" : : "rZ" (__val));\
> +} while (0)
> +
>  asm(
>  "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
>  "	.equ	.L__reg_num_x\\num, \\num\n"

That's exactly the code that I wrote for my EL2 series :)

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
