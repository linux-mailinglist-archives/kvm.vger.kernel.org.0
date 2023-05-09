Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388A86FC30A
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 11:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbjEIJrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 05:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbjEIJq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 05:46:58 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709B749CB;
        Tue,  9 May 2023 02:46:55 -0700 (PDT)
X-UUID: d7a081788efd4b19bc571412c01d7c3f-20230509
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:90058afd-4b39-4e2c-b393-8a509900c318,IP:20,
        URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:6
X-CID-INFO: VERSION:1.1.22,REQID:90058afd-4b39-4e2c-b393-8a509900c318,IP:20,UR
        L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:6
X-CID-META: VersionHash:120426c,CLOUDID:746343c0-e32c-4c97-918d-fbb3fc224d4e,B
        ulkID:230509174649WJ486XEL,BulkQuantity:0,Recheck:0,SF:45|24|17|19|102,TC:
        nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
        I:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: d7a081788efd4b19bc571412c01d7c3f-20230509
X-User: lienze@kylinos.cn
Received: from fedora [(210.12.40.82)] by mailgw
        (envelope-from <lienze@kylinos.cn>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 878831980; Tue, 09 May 2023 17:46:48 +0800
From:   Enze Li <lienze@kylinos.cn>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Subject: Re: [PATCH v9 30/30] LoongArch: KVM: Supplement kvm document about
 LoongArch-specific part
In-Reply-To: <20230509075346.1023386-31-zhaotianrui@loongson.cn> (Tianrui
        Zhao's message of "Tue, 9 May 2023 15:53:46 +0800")
References: <20230509075346.1023386-1-zhaotianrui@loongson.cn>
        <20230509075346.1023386-31-zhaotianrui@loongson.cn>
Date:   Tue, 09 May 2023 17:50:59 +0800
Message-ID: <87bkitomt8.fsf@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for working on this.  Only one small nit, please see below.

On Tue, May 09 2023 at 03:53:46 PM +0800, Tianrui Zhao wrote:

> Supplement kvm document about LoongArch-specific part, such as add
> api introduction for GET/SET_ONE_REG, GET/SET_FPU, GET/SET_MP_STATE,
> etc.
>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  Documentation/virt/kvm/api.rst | 71 +++++++++++++++++++++++++++++-----
>  1 file changed, 62 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index add067793b90..ae7d6a2cd54f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -416,6 +416,12 @@ Reads the general purpose registers from the vcpu.
>  	__u64 pc;
>    };
>  
> +  /* LoongArch */
> +  struct kvm_regs {
> +        unsigned long gpr[32];
> +        unsigned long pc;
> +  };
> +
>  
>  4.12 KVM_SET_REGS
>  -----------------
> @@ -506,7 +512,7 @@ translation mode.
>  ------------------
>  
>  :Capability: basic
> -:Architectures: x86, ppc, mips, riscv
> +:Architectures: x86, ppc, mips, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_interrupt (in)
>  :Returns: 0 on success, negative on failure.
> @@ -592,6 +598,14 @@ b) KVM_INTERRUPT_UNSET
>  
>  This is an asynchronous vcpu ioctl and can be invoked from any thread.
>  
> +LOONGARCH:
> +^^^^^^^^^^
> +
> +Queues an external interrupt to be injected into the virtual CPU. A negative
> +interrupt number dequeues the interrupt.
> +
> +This is an asynchronous vcpu ioctl and can be invoked from any thread.
> +
>  
>  4.17 KVM_DEBUG_GUEST
>  --------------------
> @@ -737,7 +751,7 @@ signal mask.
>  ----------------
>  
>  :Capability: basic
> -:Architectures: x86
> +:Architectures: x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_fpu (out)
>  :Returns: 0 on success, -1 on error
> @@ -746,7 +760,7 @@ Reads the floating point state from the vcpu.
>  
>  ::
>  
> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>    struct kvm_fpu {
>  	__u8  fpr[8][16];
>  	__u16 fcw;
> @@ -761,12 +775,22 @@ Reads the floating point state from the vcpu.
>  	__u32 pad2;
>    };
>  
> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> +  struct kvm_fpu {
> +        __u32 fcsr;
> +        __u32 none;
> +        __u64 fcc;
> +        struct kvm_fpureg {
> +                __u64 val64[4];
> +        }fpr[32];
> +  };
> +
>  
>  4.23 KVM_SET_FPU
>  ----------------
>  
>  :Capability: basic
> -:Architectures: x86
> +:Architectures: x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_fpu (in)
>  :Returns: 0 on success, -1 on error
> @@ -775,7 +799,7 @@ Writes the floating point state to the vcpu.
>  
>  ::
>  
> -  /* for KVM_GET_FPU and KVM_SET_FPU */
> +  /* x86: for KVM_GET_FPU and KVM_SET_FPU */
>    struct kvm_fpu {
>  	__u8  fpr[8][16];
>  	__u16 fcw;
> @@ -790,6 +814,16 @@ Writes the floating point state to the vcpu.
>  	__u32 pad2;
>    };
>  
> +  /* LoongArch: for KVM_GET_FPU and KVM_SET_FPU */
> +  struct kvm_fpu {
> +        __u32 fcsr;
> +        __u32 none;
> +        __u64 fcc;
> +        struct kvm_fpureg {
> +                __u64 val64[4];
> +        }fpr[32];
> +  };
> +
>  
>  4.24 KVM_CREATE_IRQCHIP
>  -----------------------
> @@ -1387,7 +1421,7 @@ documentation when it pops into existence).
>  -------------------
>  
>  :Capability: KVM_CAP_ENABLE_CAP
> -:Architectures: mips, ppc, s390, x86
> +:Architectures: mips, ppc, s390, x86, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_enable_cap (in)
>  :Returns: 0 on success; -1 on error
> @@ -1442,7 +1476,7 @@ for vm-wide capabilities.
>  ---------------------
>  
>  :Capability: KVM_CAP_MP_STATE
> -:Architectures: x86, s390, arm64, riscv
> +:Architectures: x86, s390, arm64, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_mp_state (out)
>  :Returns: 0 on success; -1 on error
> @@ -1460,7 +1494,7 @@ Possible values are:
>  
>     ==========================    ===============================================
>     KVM_MP_STATE_RUNNABLE         the vcpu is currently running
> -                                 [x86,arm64,riscv]
> +                                 [x86,arm64,riscv,loongarch]
>     KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
>                                   which has not yet received an INIT signal [x86]
>     KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
> @@ -1516,11 +1550,14 @@ For riscv:
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
>

> +On LoongArch, the KVM_MP_STATE_RUNNABLE state is only used which reflect the
> +vcpu is runnable.

There seems to be a grammatical error here.  The original sentence uses
"which" to connect two clauses, but lacks a subject to introduce the
second clause.  I think we should correct it like this,

"On LoongArch, the KVM_MP_STATE_RUNNABLE state is only used to reflect
whether the vcpu is runnable."

> +
>  4.39 KVM_SET_MP_STATE
>  ---------------------
>  
>  :Capability: KVM_CAP_MP_STATE
> -:Architectures: x86, s390, arm64, riscv
> +:Architectures: x86, s390, arm64, riscv, loongarch
>  :Type: vcpu ioctl
>  :Parameters: struct kvm_mp_state (in)
>  :Returns: 0 on success; -1 on error
> @@ -1538,6 +1575,9 @@ For arm64/riscv:
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
>


> +On LoongArch, the KVM_MP_STATE_RUNNABLE state is only used which reflect the
> +vcpu is runnable.

Likewise here.

WDYT?

Thanks,
Enze

> +
>  4.40 KVM_SET_IDENTITY_MAP_ADDR
>  ------------------------------
>  
> @@ -2839,6 +2879,19 @@ Following are the RISC-V D-extension registers:
>    0x8020 0000 0600 0020 fcsr      Floating point control and status register
>  ======================= ========= =============================================
>  
> +LoongArch registers are mapped using the lower 32 bits. The upper 16 bits of
> +that is the register group type.
> +
> +LoongArch csr registers are used to control guest cpu or get status of guest
> +cpu, and they have the following id bit patterns::
> +
> +  0x9030 0000 0001 00 <reg:5> <sel:3>   (64-bit)
> +
> +LoongArch KVM control registers are used to implement some new defined functions
> +such as set vcpu counter or reset vcpu, and they have the following id bit patterns::
> +
> +  0x9030 0000 0002 <reg:16>
> +
>  
>  4.69 KVM_GET_ONE_REG
>  --------------------
