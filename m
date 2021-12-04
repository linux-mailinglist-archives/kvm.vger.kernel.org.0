Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09660468166
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 01:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383821AbhLDAoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 19:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383829AbhLDAoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 19:44:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9516C061353;
        Fri,  3 Dec 2021 16:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=RhO2eM2iBD51XAcs3FHaTn4vdZjIjPBsjygX6aDTNlY=; b=eSHMLB1xRxjDVw9DKqlPBAR9yp
        Yqrx75FNRoT77RKI0dF0PD6De0YW42GbJPUreFYgi2To8XprXRC6VqU9prtBhiwbiue1Iq5HBWr3t
        3F8XNkmkECLouyBz8C3AnNxX2RC8v7QBycpZ0UFBsUVcGQBX5+YzFQ+I5xtAsdQlEPtjxB53RU4dU
        oqe2CCJyKi7VD/1ofD6evkbAvF4xqc/ebajcsWIBImVoKPtSPK5dAb6mI2L3MyjWN0QeZulNIE/zs
        SV0YEODhajuqd16opZXTesJp2A3+eC4goG2qt1FKMtwBOrm66MR8/8ctxm8K6qdvc2lSXJjOhFRP/
        F8O11i8Q==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mtJ6O-00Awrp-Kc; Sat, 04 Dec 2021 00:40:33 +0000
Message-ID: <d88c18e4-b2d6-e071-7007-bb5f2b5a042c@infradead.org>
Date:   Fri, 3 Dec 2021 16:40:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 5/6] RISC-V: Move spinwait booting method to its own config
Content-Language: en-US
To:     Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
References: <20211204002038.113653-1-atishp@atishpatra.org>
 <20211204002038.113653-6-atishp@atishpatra.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20211204002038.113653-6-atishp@atishpatra.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi--

On 12/3/21 16:20, Atish Patra wrote:
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 821252b65f89..4afb42d5707d 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -403,6 +403,20 @@ config RISCV_SBI_V01
>  	  This config allows kernel to use SBI v0.1 APIs. This will be
>  	  deprecated in future once legacy M-mode software are no longer in use.
>  
> +config RISCV_BOOT_SPINWAIT
> +	bool "Spinwait booting method"
> +	depends on SMP
> +	default y
> +	help
> +	  This enables support for booting Linux via spinwait method. In the
> +	  spinwait method, all cores randomly jump to Linux. One of the core

	                                                                cores

> +	  gets chosen via lottery and all other keeps spinning on a percpu

	                                  others keep

> +	  variable. This method can not support cpu hotplug and sparse hartid

	                        cannot support CPU hotplug and sparse hartid

> +	  scheme. It should be only enabled for M-mode Linux or platforms relying
> +	  on older firmware without SBI HSM extension. All other platform should

	                                                         platforms

> +	  rely on ordered booing via SBI HSM extension which gets chosen

	                  booting

> +          dynamically at runtime if the firmware supports it.

	  dynamically at runtime if the firmware supports it.

(Last line should be indented with tab + 2 spaces, not 10 spaces.)


-- 
~Randy
