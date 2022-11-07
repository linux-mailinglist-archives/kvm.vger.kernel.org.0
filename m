Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E92761F7E5
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 16:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiKGPq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiKGPqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 10:46:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F6414097
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 07:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667835958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Z9C0sDjxblfmephVLzlXoeAemawGENuTazfj8SC/H0=;
        b=BI2wV1Wpg5XvxwbWULAwHG2dQNJlKOa0wWiyQAf/LibnFPhqUipkB2JBgrj/hE0yCV06Yq
        J+m8cjC74S2aana/PI8/urYZPcvnzRTOyVEbpQtxsVLArpzJAFvn0T5gUHBwiJx9Fn3NQp
        zST2+1mQbnFYpTl+PsiNhnGIkDTNpxA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-Z3MV26FVNqyOmtXLKPDxPQ-1; Mon, 07 Nov 2022 10:45:29 -0500
X-MC-Unique: Z3MV26FVNqyOmtXLKPDxPQ-1
Received: by mail-wr1-f71.google.com with SMTP id s11-20020adfbc0b000000b0023659af24a8so2946047wrg.14
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 07:45:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Z9C0sDjxblfmephVLzlXoeAemawGENuTazfj8SC/H0=;
        b=q5cV7LjPOJMtwQm/TNOddtnk443SNYinO4iqy+vXCoJH+QFiHUjrwm7rag57VBbNVe
         tRQMeFTCtFxarwAdFfsSPdOMcva5mgrfPB+YCo8u+W5+1n5v6v51k2Ks0V5wli5g8AiC
         QvQy0+2h6QqTW0XXl3pFfVRI8dxpm/VUmUUHVXc81QRiykZeVd7xctwXTajvL5F+dhlX
         Rks/WGagteflKqA8DHvYt6kHrcGaVeQZyuS/wz12sNt3RAVjPnKQS7h7wLmyczo+MFVc
         YQs54htwu9fgz990o7HQCKotKrYzWIXcIFv9vM66aRcd5s+DhZTF2Yi62zKjS5lcXcVN
         PiJg==
X-Gm-Message-State: ACrzQf0gSADGSWtB0pkfOCgH8xnKEjsADlNNkf3Ixaf8XDjhpIZ5fJip
        SblOINjJPTKqJ3gCNC4wBbDv630M26cqFq7cI6s5mxv6w42ydiFaiPKPIsSIhDmPIW+nDJb3T9q
        7+rmFvS+NtfXN
X-Received: by 2002:a05:600c:21a:b0:3cf:6e78:8e89 with SMTP id 26-20020a05600c021a00b003cf6e788e89mr30279091wmi.46.1667835928183;
        Mon, 07 Nov 2022 07:45:28 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7m09qxaNEiHmrsD9T7izTPZcpOxq0dJyTRLDtJ63jqAiJJvzI2gWScWawUwSZStkADRl+dQA==
X-Received: by 2002:a05:600c:21a:b0:3cf:6e78:8e89 with SMTP id 26-20020a05600c021a00b003cf6e788e89mr30279075wmi.46.1667835927934;
        Mon, 07 Nov 2022 07:45:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j15-20020a5d604f000000b00236705daefesm7573368wrt.39.2022.11.07.07.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 07:45:27 -0800 (PST)
Message-ID: <b1238d2e-2a15-1f8c-1349-e2b26d543c62@redhat.com>
Date:   Mon, 7 Nov 2022 16:45:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] tools/kvm_stat: update exit reasons for
 vmx/svm/aarch64/userspace
Content-Language: en-US
To:     Rong Tao <rtoax@foxmail.com>
Cc:     Rong Tao <rongtao@cestc.cn>,
        Dmitry Klochkov <kdmitry556@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <tencent_00082C8BFA925A65E11570F417F1CD404505@qq.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <tencent_00082C8BFA925A65E11570F417F1CD404505@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 15:52, Rong Tao wrote:
> From: Rong Tao <rongtao@cestc.cn>
> 
> Update EXIT_REASONS from source, including VMX_EXIT_REASONS,
> SVM_EXIT_REASONS, AARCH64_EXIT_REASONS, USERSPACE_EXIT_REASONS.
> 
> Signed-off-by: Rong Tao <rongtao@cestc.cn>
> ---
>   tools/kvm/kvm_stat/kvm_stat | 96 +++++++++++++++++++++++++++++++------
>   1 file changed, 82 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index 9c366b3a676d..a34b781a3ce8 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -41,11 +41,14 @@ VMX_EXIT_REASONS = {
>       'EXCEPTION_NMI':        0,
>       'EXTERNAL_INTERRUPT':   1,
>       'TRIPLE_FAULT':         2,
> -    'PENDING_INTERRUPT':    7,
> +    'INIT_SIGNAL':          3,
> +    'SIPI_SIGNAL':          4,
> +    'INTERRUPT_WINDOW':     7,
>       'NMI_WINDOW':           8,
>       'TASK_SWITCH':          9,
>       'CPUID':                10,
>       'HLT':                  12,
> +    'INVD':                 13,
>       'INVLPG':               14,
>       'RDPMC':                15,
>       'RDTSC':                16,
> @@ -65,26 +68,48 @@ VMX_EXIT_REASONS = {
>       'MSR_READ':             31,
>       'MSR_WRITE':            32,
>       'INVALID_STATE':        33,
> +    'MSR_LOAD_FAIL':        34,
>       'MWAIT_INSTRUCTION':    36,
> +    'MONITOR_TRAP_FLAG':    37,
>       'MONITOR_INSTRUCTION':  39,
>       'PAUSE_INSTRUCTION':    40,
>       'MCE_DURING_VMENTRY':   41,
>       'TPR_BELOW_THRESHOLD':  43,
>       'APIC_ACCESS':          44,
> +    'EOI_INDUCED':          45,
> +    'GDTR_IDTR':            46,
> +    'LDTR_TR':              47,
>       'EPT_VIOLATION':        48,
>       'EPT_MISCONFIG':        49,
> +    'INVEPT':               50,
> +    'RDTSCP':               51,
> +    'PREEMPTION_TIMER':     52,
> +    'INVVPID':              53,
>       'WBINVD':               54,
>       'XSETBV':               55,
>       'APIC_WRITE':           56,
> +    'RDRAND':               57,
>       'INVPCID':              58,
> +    'VMFUNC':               59,
> +    'ENCLS':                60,
> +    'RDSEED':               61,
> +    'PML_FULL':             62,
> +    'XSAVES':               63,
> +    'XRSTORS':              64,
> +    'UMWAIT':               67,
> +    'TPAUSE':               68,
> +    'BUS_LOCK':             74,
> +    'NOTIFY':               75,
>   }
>   
>   SVM_EXIT_REASONS = {
>       'READ_CR0':       0x000,
> +    'READ_CR2':       0x002,
>       'READ_CR3':       0x003,
>       'READ_CR4':       0x004,
>       'READ_CR8':       0x008,
>       'WRITE_CR0':      0x010,
> +    'WRITE_CR2':      0x012,
>       'WRITE_CR3':      0x013,
>       'WRITE_CR4':      0x014,
>       'WRITE_CR8':      0x018,
> @@ -105,6 +130,7 @@ SVM_EXIT_REASONS = {
>       'WRITE_DR6':      0x036,
>       'WRITE_DR7':      0x037,
>       'EXCP_BASE':      0x040,
> +    'LAST_EXCP':      0x05f,
>       'INTR':           0x060,
>       'NMI':            0x061,
>       'SMI':            0x062,
> @@ -151,21 +177,45 @@ SVM_EXIT_REASONS = {
>       'MWAIT':          0x08b,
>       'MWAIT_COND':     0x08c,
>       'XSETBV':         0x08d,
> +    'RDPRU':          0x08e,
> +    'EFER_WRITE_TRAP':           0x08f,
> +    'CR0_WRITE_TRAP':            0x090,
> +    'CR1_WRITE_TRAP':            0x091,
> +    'CR2_WRITE_TRAP':            0x092,
> +    'CR3_WRITE_TRAP':            0x093,
> +    'CR4_WRITE_TRAP':            0x094,
> +    'CR5_WRITE_TRAP':            0x095,
> +    'CR6_WRITE_TRAP':            0x096,
> +    'CR7_WRITE_TRAP':            0x097,
> +    'CR8_WRITE_TRAP':            0x098,
> +    'CR9_WRITE_TRAP':            0x099,
> +    'CR10_WRITE_TRAP':           0x09a,
> +    'CR11_WRITE_TRAP':           0x09b,
> +    'CR12_WRITE_TRAP':           0x09c,
> +    'CR13_WRITE_TRAP':           0x09d,
> +    'CR14_WRITE_TRAP':           0x09e,
> +    'CR15_WRITE_TRAP':           0x09f,
> +    'INVPCID':        0x0a2,
>       'NPF':            0x400,
> +    'AVIC_INCOMPLETE_IPI':       0x401,
> +    'AVIC_UNACCELERATED_ACCESS': 0x402,
> +    'VMGEXIT':        0x403,
>   }
>   
> -# EC definition of HSR (from arch/arm64/include/asm/kvm_arm.h)
> +# EC definition of HSR (from arch/arm64/include/asm/esr.h)
>   AARCH64_EXIT_REASONS = {
>       'UNKNOWN':      0x00,
> -    'WFI':          0x01,
> +    'WFx':          0x01,
>       'CP15_32':      0x03,
>       'CP15_64':      0x04,
>       'CP14_MR':      0x05,
>       'CP14_LS':      0x06,
>       'FP_ASIMD':     0x07,
>       'CP10_ID':      0x08,
> +    'PAC':          0x09,
>       'CP14_64':      0x0C,
> -    'ILL_ISS':      0x0E,
> +    'BTI':          0x0D,
> +    'ILL':          0x0E,
>       'SVC32':        0x11,
>       'HVC32':        0x12,
>       'SMC32':        0x13,
> @@ -173,21 +223,26 @@ AARCH64_EXIT_REASONS = {
>       'HVC64':        0x16,
>       'SMC64':        0x17,
>       'SYS64':        0x18,
> -    'IABT':         0x20,
> -    'IABT_HYP':     0x21,
> +    'SVE':          0x19,
> +    'ERET':         0x1A,
> +    'FPAC':         0x1C,
> +    'SME':          0x1D,
> +    'IMP_DEF':      0x1F,
> +    'IABT_LOW':     0x20,
> +    'IABT_CUR':     0x21,
>       'PC_ALIGN':     0x22,
> -    'DABT':         0x24,
> -    'DABT_HYP':     0x25,
> +    'DABT_LOW':     0x24,
> +    'DABT_CUR':     0x25,
>       'SP_ALIGN':     0x26,
>       'FP_EXC32':     0x28,
>       'FP_EXC64':     0x2C,
>       'SERROR':       0x2F,
> -    'BREAKPT':      0x30,
> -    'BREAKPT_HYP':  0x31,
> -    'SOFTSTP':      0x32,
> -    'SOFTSTP_HYP':  0x33,
> -    'WATCHPT':      0x34,
> -    'WATCHPT_HYP':  0x35,
> +    'BREAKPT_LOW':  0x30,
> +    'BREAKPT_CUR':  0x31,
> +    'SOFTSTP_LOW':  0x32,
> +    'SOFTSTP_CUR':  0x33,
> +    'WATCHPT_LOW':  0x34,
> +    'WATCHPT_CUR':  0x35,
>       'BKPT32':       0x38,
>       'VECTOR32':     0x3A,
>       'BRK64':        0x3C,
> @@ -220,6 +275,19 @@ USERSPACE_EXIT_REASONS = {
>       'S390_TSCH':        22,
>       'EPR':              23,
>       'SYSTEM_EVENT':     24,
> +    'S390_STSI':        25,
> +    'IOAPIC_EOI':       26,
> +    'HYPERV':           27,
> +    'ARM_NISV':         28,
> +    'X86_RDMSR':        29,
> +    'X86_WRMSR':        30,
> +    'DIRTY_RING_FULL':  31,
> +    'AP_RESET_HOLD':    32,
> +    'X86_BUS_LOCK':     33,
> +    'XEN':              34,
> +    'RISCV_SBI':        35,
> +    'RISCV_CSR':        36,
> +    'NOTIFY':           37,
>   }
>   
>   IOCTL_NUMBERS = {

Queued, thanks.

Paolo

