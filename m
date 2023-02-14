Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A8A695949
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 07:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjBNGi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 01:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbjBNGiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 01:38:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C284F12F;
        Mon, 13 Feb 2023 22:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 755C8B81BE7;
        Tue, 14 Feb 2023 06:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90736C433D2;
        Tue, 14 Feb 2023 06:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676356691;
        bh=k2hApELG0n0PIUC6rX/dhhz1ONPNcDWoNIMjZyxg/eE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a9e3Nx/UjLOgeGIbQwDbavWoqkr58W10P+9C+FTL6OFhYF+DK6rknTvWVicTo1qLa
         0MV1L4nd3RqjUb6egrVUeopyPa040MLp3Ps5Cxna58LB52gcxbsvBXHpy7FY6cJ5GW
         SuZkFbOqlLGgw/hYPunPgCJ5y89zdECkN4iaOWhE=
Date:   Tue, 14 Feb 2023 07:38:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH v1 01/24] LoongArch: KVM: Implement kvm module related
 interface
Message-ID: <Y+ssT+W27GxDRAAZ@kroah.com>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
 <20230214025648.1898508-2-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214025648.1898508-2-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 10:56:25AM +0800, Tianrui Zhao wrote:
> 1. Implement loongarch kvm module init, module exit interface,
> using kvm context to save the vpid info and vcpu world switch
> interface pointer.
> 2. Implement kvm hardware enable, disable interface, setting
> the guest config reg to enable virtualization features.
> 3. Add kvm related headers.

Shouldn't this be 3 different patches instead?

> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/include/asm/cpu-features.h |  22 ++
>  arch/loongarch/include/asm/kvm_host.h     | 257 ++++++++++++++++++++++
>  arch/loongarch/include/asm/kvm_types.h    |  11 +
>  arch/loongarch/include/uapi/asm/kvm.h     | 121 ++++++++++
>  arch/loongarch/kvm/main.c                 | 152 +++++++++++++
>  include/uapi/linux/kvm.h                  |  15 ++
>  6 files changed, 578 insertions(+)
>  create mode 100644 arch/loongarch/include/asm/kvm_host.h
>  create mode 100644 arch/loongarch/include/asm/kvm_types.h
>  create mode 100644 arch/loongarch/include/uapi/asm/kvm.h
>  create mode 100644 arch/loongarch/kvm/main.c
> 
> diff --git a/arch/loongarch/include/asm/cpu-features.h b/arch/loongarch/include/asm/cpu-features.h
> index b07974218..23e7c3ae5 100644
> --- a/arch/loongarch/include/asm/cpu-features.h
> +++ b/arch/loongarch/include/asm/cpu-features.h
> @@ -64,5 +64,27 @@
>  #define cpu_has_guestid		cpu_opt(LOONGARCH_CPU_GUESTID)
>  #define cpu_has_hypervisor	cpu_opt(LOONGARCH_CPU_HYPERVISOR)
>  
> +#define cpu_has_matc_guest	(cpu_data[0].guest_cfg & (1 << 0))
> +#define cpu_has_matc_root	(cpu_data[0].guest_cfg & (1 << 1))
> +#define cpu_has_matc_nest	(cpu_data[0].guest_cfg & (1 << 2))
> +#define cpu_has_sitp		(cpu_data[0].guest_cfg & (1 << 6))
> +#define cpu_has_titp		(cpu_data[0].guest_cfg & (1 << 8))
> +#define cpu_has_toep		(cpu_data[0].guest_cfg & (1 << 10))
> +#define cpu_has_topp		(cpu_data[0].guest_cfg & (1 << 12))
> +#define cpu_has_torup		(cpu_data[0].guest_cfg & (1 << 14))
> +#define cpu_has_gcip_all	(cpu_data[0].guest_cfg & (1 << 16))
> +#define cpu_has_gcip_hit	(cpu_data[0].guest_cfg & (1 << 17))
> +#define cpu_has_gcip_secure	(cpu_data[0].guest_cfg & (1 << 18))

Why not use BIT() for all of those "<<" statements?

> +#define KVM_GET_CSRS		_IOWR(KVMIO, 0xc5, struct kvm_csrs)
> +#define KVM_SET_CSRS		_IOW(KVMIO,  0xc6, struct kvm_csrs)

Why does this arch need new ioctls?

thanks,

greg k-h
