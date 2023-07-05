Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECC2748407
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 14:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjGEMS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 08:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjGEMS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 08:18:26 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CC9D8
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 05:18:24 -0700 (PDT)
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
X-GND-Sasl: alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B47EFC000A;
        Wed,  5 Jul 2023 12:18:22 +0000 (UTC)
Message-ID: <994ae720-b3a1-1e67-ca9c-ca00e6525488@ghiti.fr>
Date:   Wed, 5 Jul 2023 14:18:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] RISC-V: KVM: provide UAPI for host SATP mode
Content-Language: en-US
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>
Cc:     anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com
References: <20230705091535.237765-1-dbarboza@ventanamicro.com>
From:   Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20230705091535.237765-1-dbarboza@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 05/07/2023 11:15, Daniel Henrique Barboza wrote:
> KVM userspaces need to be aware of the host SATP to allow them to
> advertise it back to the guest OS.
>
> Since this information is used to build the guest FDT we can't wait for


The thing is the "mmu-type" property in the FDT is never used: the 
kernel will probe the hardware and choose the largest available mode, or 
use "no4lvl"/"no5lvl" from the command line to restrict this mode. And 
FYI the current mode is exposed through cpuinfo. @Conor Can we deprecate 
this node or something similar?

Just a remark, not sure that helps :)


> the SATP reg to be readable. We just need to read the SATP mode, thus
> we can use the existing 'satp_mode' global that represents the SATP reg
> with MODE set and both ASID and PPN cleared. E.g. for a 32 bit host
> running with sv32 satp_mode is 0x80000000, for a 64 bit host running
> sv57 satp_mode is 0xa000000000000000, and so on.
>
> Add a new userspace virtual config register 'satp_mode' to allow
> userspace to read the current SATP mode the host is using with
> GET_ONE_REG API before spinning the vcpu.
>
> 'satp_mode' can't be changed via KVM, so SET_ONE_REG is allowed as long
> as userspace writes the existing 'satp_mode'.
>
> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>   arch/riscv/include/asm/csr.h      | 2 ++
>   arch/riscv/include/uapi/asm/kvm.h | 1 +
>   arch/riscv/kvm/vcpu.c             | 7 +++++++
>   3 files changed, 10 insertions(+)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index b6acb7ed115f..be6e5c305e5b 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -46,6 +46,7 @@
>   #ifndef CONFIG_64BIT
>   #define SATP_PPN	_AC(0x003FFFFF, UL)
>   #define SATP_MODE_32	_AC(0x80000000, UL)
> +#define SATP_MODE_SHIFT	31
>   #define SATP_ASID_BITS	9
>   #define SATP_ASID_SHIFT	22
>   #define SATP_ASID_MASK	_AC(0x1FF, UL)
> @@ -54,6 +55,7 @@
>   #define SATP_MODE_39	_AC(0x8000000000000000, UL)
>   #define SATP_MODE_48	_AC(0x9000000000000000, UL)
>   #define SATP_MODE_57	_AC(0xa000000000000000, UL)
> +#define SATP_MODE_SHIFT	60
>   #define SATP_ASID_BITS	16
>   #define SATP_ASID_SHIFT	44
>   #define SATP_ASID_MASK	_AC(0xFFFF, UL)
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index f92790c9481a..0493c078e64e 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -54,6 +54,7 @@ struct kvm_riscv_config {
>   	unsigned long marchid;
>   	unsigned long mimpid;
>   	unsigned long zicboz_block_size;
> +	unsigned long satp_mode;
>   };
>   
>   /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 8bd9f2a8a0b9..b31acf923802 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -313,6 +313,9 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>   	case KVM_REG_RISCV_CONFIG_REG(mimpid):
>   		reg_val = vcpu->arch.mimpid;
>   		break;
> +	case KVM_REG_RISCV_CONFIG_REG(satp_mode):
> +		reg_val = satp_mode >> SATP_MODE_SHIFT;
> +		break;
>   	default:
>   		return -EINVAL;
>   	}
> @@ -395,6 +398,10 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>   		else
>   			return -EBUSY;
>   		break;
> +	case KVM_REG_RISCV_CONFIG_REG(satp_mode):
> +		if (reg_val != (satp_mode >> SATP_MODE_SHIFT))
> +			return -EINVAL;
> +		break;
>   	default:
>   		return -EINVAL;
>   	}
