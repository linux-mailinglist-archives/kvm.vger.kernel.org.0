Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B124E63F217
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiLANzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiLANzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:55:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F115AD5C
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DV+7x/PMjwMGa2muQFJVehg4KZtI8Ivqe/KxFr6NJQo=;
        b=XAJ4bnIEBWuQ2+Qcxk5A4rwoxgmlxNwVX7J5T2h3RTnMN/tz8ZlGND06/8OI1YZjHvc1lN
        SCgURKwVjTBs9eH+2T7DYH+mjeNEOx4YVb1OWQvdJmUnEcQGhei9+2sOpTmfIe0rSmc3CJ
        Nuam3NwBNi81AsHbjni9t4ywvkzA5TY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-490-Rc2YeBNMNT-FhBgsUTc0aQ-1; Thu, 01 Dec 2022 08:54:09 -0500
X-MC-Unique: Rc2YeBNMNT-FhBgsUTc0aQ-1
Received: by mail-qt1-f197.google.com with SMTP id cj6-20020a05622a258600b003a519d02f59so4348359qtb.5
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 05:54:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DV+7x/PMjwMGa2muQFJVehg4KZtI8Ivqe/KxFr6NJQo=;
        b=Rg52GTpIvjGnFbfLK87SCLEA5faHdySs/Q87Apq5dY1lvWauM3cv9GPFItP5LMiPyH
         16AXcjXeI8ceT6R0VrMU0lKklBSCL3TRn1YybOI3rQ3JQ8zomVhOd19ZKVYKmMSQ3u0o
         tSmPzojJikS6/lw5E2XXaO2U9WuSIwoRaKnmySkgl74zl93akWfwv/ZcDSk9fJ2Dlqnh
         h2We3ge0d1A3aUXjOVcLFetmPxcDXqSV555qNWIxW+nC70pUvpsOYzpEFTwO93p2ucs3
         rEtkVQswPbeTMOcfziDwMsC2YJ4O3nwnMj5ChwFULi2t/upfxQlY1dhod8hnwl+gWnPF
         /nYA==
X-Gm-Message-State: ANoB5pnUx051Jg1OBQw08bW2y6saN684sVAXYPeCoqpWGxlDlu7DcCNP
        fTNxhx1q/iDAMfazrbSnQBge6ScRC/GUG+mECv0wkTP5gXaHOfOuzCeL97sDL4JDu9Rh6Bo4Aj4
        EW0Me2Ymo+E4N
X-Received: by 2002:a05:622a:1baa:b0:3a6:8be3:301e with SMTP id bp42-20020a05622a1baa00b003a68be3301emr7026019qtb.21.1669902847850;
        Thu, 01 Dec 2022 05:54:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5QoDeOLZjU5DzWzpVRV3CukOhpR/o+Koto592y57YPb8tWFDWVQ1pEF2hY1x5+YX2txBayVw==
X-Received: by 2002:a05:622a:1baa:b0:3a6:8be3:301e with SMTP id bp42-20020a05622a1baa00b003a68be3301emr7025996qtb.21.1669902847502;
        Thu, 01 Dec 2022 05:54:07 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id fg11-20020a05622a580b00b003a57f822157sm2574962qtb.90.2022.12.01.05.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 05:54:07 -0800 (PST)
Message-ID: <d5c54dfa-8dbc-4870-3411-b01ae7a5de0b@redhat.com>
Date:   Thu, 1 Dec 2022 14:54:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 14/27] svm: move svm spec definitions to
 lib/x86/svm.h
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-15-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-15-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> This is first step of separating SVM code to a library
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm.h | 365 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm.h     | 359 +------------------------------------------------
>  2 files changed, 366 insertions(+), 358 deletions(-)
>  create mode 100644 lib/x86/svm.h
> 
> diff --git a/lib/x86/svm.h b/lib/x86/svm.h
> new file mode 100644
> index 00000000..8b836c13
> --- /dev/null
> +++ b/lib/x86/svm.h
> @@ -0,0 +1,365 @@
> +
> +#ifndef SRC_LIB_X86_SVM_H_
> +#define SRC_LIB_X86_SVM_H_
> +
> +enum {
> +	INTERCEPT_INTR,
> +	INTERCEPT_NMI,
> +	INTERCEPT_SMI,
> +	INTERCEPT_INIT,
> +	INTERCEPT_VINTR,
> +	INTERCEPT_SELECTIVE_CR0,
> +	INTERCEPT_STORE_IDTR,
> +	INTERCEPT_STORE_GDTR,
> +	INTERCEPT_STORE_LDTR,
> +	INTERCEPT_STORE_TR,
> +	INTERCEPT_LOAD_IDTR,
> +	INTERCEPT_LOAD_GDTR,
> +	INTERCEPT_LOAD_LDTR,
> +	INTERCEPT_LOAD_TR,
> +	INTERCEPT_RDTSC,
> +	INTERCEPT_RDPMC,
> +	INTERCEPT_PUSHF,
> +	INTERCEPT_POPF,
> +	INTERCEPT_CPUID,
> +	INTERCEPT_RSM,
> +	INTERCEPT_IRET,
> +	INTERCEPT_INTn,
> +	INTERCEPT_INVD,
> +	INTERCEPT_PAUSE,
> +	INTERCEPT_HLT,
> +	INTERCEPT_INVLPG,
> +	INTERCEPT_INVLPGA,
> +	INTERCEPT_IOIO_PROT,
> +	INTERCEPT_MSR_PROT,
> +	INTERCEPT_TASK_SWITCH,
> +	INTERCEPT_FERR_FREEZE,
> +	INTERCEPT_SHUTDOWN,
> +	INTERCEPT_VMRUN,
> +	INTERCEPT_VMMCALL,
> +	INTERCEPT_VMLOAD,
> +	INTERCEPT_VMSAVE,
> +	INTERCEPT_STGI,
> +	INTERCEPT_CLGI,
> +	INTERCEPT_SKINIT,
> +	INTERCEPT_RDTSCP,
> +	INTERCEPT_ICEBP,
> +	INTERCEPT_WBINVD,
> +	INTERCEPT_MONITOR,
> +	INTERCEPT_MWAIT,
> +	INTERCEPT_MWAIT_COND,
> +};
> +
> +enum {
> +	VMCB_CLEAN_INTERCEPTS = 1, /* Intercept vectors, TSC offset, pause filter count */
> +	VMCB_CLEAN_PERM_MAP = 2,   /* IOPM Base and MSRPM Base */
> +	VMCB_CLEAN_ASID = 4,	   /* ASID */
> +	VMCB_CLEAN_INTR = 8,	   /* int_ctl, int_vector */
> +	VMCB_CLEAN_NPT = 16,	   /* npt_en, nCR3, gPAT */
> +	VMCB_CLEAN_CR = 32,	   /* CR0, CR3, CR4, EFER */
> +	VMCB_CLEAN_DR = 64,	   /* DR6, DR7 */
> +	VMCB_CLEAN_DT = 128,	   /* GDT, IDT */
> +	VMCB_CLEAN_SEG = 256,	   /* CS, DS, SS, ES, CPL */
> +	VMCB_CLEAN_CR2 = 512,	   /* CR2 only */
> +	VMCB_CLEAN_LBR = 1024,	   /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
> +	VMCB_CLEAN_AVIC = 2048,	   /* APIC_BAR, APIC_BACKING_PAGE,
> +				    * PHYSICAL_TABLE pointer, LOGICAL_TABLE pointer
> +				    */
> +	VMCB_CLEAN_ALL = 4095,
> +};
> +
> +struct __attribute__ ((__packed__)) vmcb_control_area {
> +	u16 intercept_cr_read;
> +	u16 intercept_cr_write;
> +	u16 intercept_dr_read;
> +	u16 intercept_dr_write;
> +	u32 intercept_exceptions;
> +	u64 intercept;
> +	u8 reserved_1[40];
> +	u16 pause_filter_thresh;
> +	u16 pause_filter_count;
> +	u64 iopm_base_pa;
> +	u64 msrpm_base_pa;
> +	u64 tsc_offset;
> +	u32 asid;
> +	u8 tlb_ctl;
> +	u8 reserved_2[3];
> +	u32 int_ctl;
> +	u32 int_vector;
> +	u32 int_state;
> +	u8 reserved_3[4];
> +	u32 exit_code;
> +	u32 exit_code_hi;
> +	u64 exit_info_1;
> +	u64 exit_info_2;
> +	u32 exit_int_info;
> +	u32 exit_int_info_err;
> +	u64 nested_ctl;
> +	u8 reserved_4[16];
> +	u32 event_inj;
> +	u32 event_inj_err;
> +	u64 nested_cr3;
> +	u64 virt_ext;
> +	u32 clean;
> +	u32 reserved_5;
> +	u64 next_rip;
> +	u8 insn_len;
> +	u8 insn_bytes[15];
> +	u8 reserved_6[800];
> +};
> +
> +#define TLB_CONTROL_DO_NOTHING 0
> +#define TLB_CONTROL_FLUSH_ALL_ASID 1
> +
> +#define V_TPR_MASK 0x0f
> +
> +#define V_IRQ_SHIFT 8
> +#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
> +
> +#define V_GIF_ENABLED_SHIFT 25
> +#define V_GIF_ENABLED_MASK (1 << V_GIF_ENABLED_SHIFT)
> +
> +#define V_GIF_SHIFT 9
> +#define V_GIF_MASK (1 << V_GIF_SHIFT)
> +
> +#define V_INTR_PRIO_SHIFT 16
> +#define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
> +
> +#define V_IGN_TPR_SHIFT 20
> +#define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
> +
> +#define V_INTR_MASKING_SHIFT 24
> +#define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
> +
> +#define SVM_INTERRUPT_SHADOW_MASK 1
> +
> +#define SVM_IOIO_STR_SHIFT 2
> +#define SVM_IOIO_REP_SHIFT 3
> +#define SVM_IOIO_SIZE_SHIFT 4
> +#define SVM_IOIO_ASIZE_SHIFT 7
> +
> +#define SVM_IOIO_TYPE_MASK 1
> +#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
> +#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
> +#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
> +#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
> +
> +#define SVM_VM_CR_VALID_MASK	0x001fULL
> +#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
> +#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
> +
> +#define TSC_RATIO_DEFAULT   0x0100000000ULL
> +
> +struct __attribute__ ((__packed__)) vmcb_seg {
> +	u16 selector;
> +	u16 attrib;
> +	u32 limit;
> +	u64 base;
> +};
> +
> +struct __attribute__ ((__packed__)) vmcb_save_area {
> +	struct vmcb_seg es;
> +	struct vmcb_seg cs;
> +	struct vmcb_seg ss;
> +	struct vmcb_seg ds;
> +	struct vmcb_seg fs;
> +	struct vmcb_seg gs;
> +	struct vmcb_seg gdtr;
> +	struct vmcb_seg ldtr;
> +	struct vmcb_seg idtr;
> +	struct vmcb_seg tr;
> +	u8 reserved_1[43];
> +	u8 cpl;
> +	u8 reserved_2[4];
> +	u64 efer;
> +	u8 reserved_3[112];
> +	u64 cr4;
> +	u64 cr3;
> +	u64 cr0;
> +	u64 dr7;
> +	u64 dr6;
> +	u64 rflags;
> +	u64 rip;
> +	u8 reserved_4[88];
> +	u64 rsp;
> +	u8 reserved_5[24];
> +	u64 rax;
> +	u64 star;
> +	u64 lstar;
> +	u64 cstar;
> +	u64 sfmask;
> +	u64 kernel_gs_base;
> +	u64 sysenter_cs;
> +	u64 sysenter_esp;
> +	u64 sysenter_eip;
> +	u64 cr2;
> +	u8 reserved_6[32];
> +	u64 g_pat;
> +	u64 dbgctl;
> +	u64 br_from;
> +	u64 br_to;
> +	u64 last_excp_from;
> +	u64 last_excp_to;
> +};
> +
> +struct __attribute__ ((__packed__)) vmcb {
> +	struct vmcb_control_area control;
> +	struct vmcb_save_area save;
> +};
> +
> +#define SVM_CPUID_FEATURE_SHIFT 2
> +#define SVM_CPUID_FUNC 0x8000000a
> +
> +#define SVM_VM_CR_SVM_DISABLE 4
> +
> +#define SVM_SELECTOR_S_SHIFT 4
> +#define SVM_SELECTOR_DPL_SHIFT 5
> +#define SVM_SELECTOR_P_SHIFT 7
> +#define SVM_SELECTOR_AVL_SHIFT 8
> +#define SVM_SELECTOR_L_SHIFT 9
> +#define SVM_SELECTOR_DB_SHIFT 10
> +#define SVM_SELECTOR_G_SHIFT 11
> +
> +#define SVM_SELECTOR_TYPE_MASK (0xf)
> +#define SVM_SELECTOR_S_MASK (1 << SVM_SELECTOR_S_SHIFT)
> +#define SVM_SELECTOR_DPL_MASK (3 << SVM_SELECTOR_DPL_SHIFT)
> +#define SVM_SELECTOR_P_MASK (1 << SVM_SELECTOR_P_SHIFT)
> +#define SVM_SELECTOR_AVL_MASK (1 << SVM_SELECTOR_AVL_SHIFT)
> +#define SVM_SELECTOR_L_MASK (1 << SVM_SELECTOR_L_SHIFT)
> +#define SVM_SELECTOR_DB_MASK (1 << SVM_SELECTOR_DB_SHIFT)
> +#define SVM_SELECTOR_G_MASK (1 << SVM_SELECTOR_G_SHIFT)
> +
> +#define SVM_SELECTOR_WRITE_MASK (1 << 1)
> +#define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
> +#define SVM_SELECTOR_CODE_MASK (1 << 3)
> +
> +#define INTERCEPT_CR0_MASK 1
> +#define INTERCEPT_CR3_MASK (1 << 3)
> +#define INTERCEPT_CR4_MASK (1 << 4)
> +#define INTERCEPT_CR8_MASK (1 << 8)
> +
> +#define INTERCEPT_DR0_MASK 1
> +#define INTERCEPT_DR1_MASK (1 << 1)
> +#define INTERCEPT_DR2_MASK (1 << 2)
> +#define INTERCEPT_DR3_MASK (1 << 3)
> +#define INTERCEPT_DR4_MASK (1 << 4)
> +#define INTERCEPT_DR5_MASK (1 << 5)
> +#define INTERCEPT_DR6_MASK (1 << 6)
> +#define INTERCEPT_DR7_MASK (1 << 7)
> +
> +#define SVM_EVTINJ_VEC_MASK 0xff
> +
> +#define SVM_EVTINJ_TYPE_SHIFT 8
> +#define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
> +
> +#define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
> +
> +#define SVM_EVTINJ_VALID (1 << 31)
> +#define SVM_EVTINJ_VALID_ERR (1 << 11)
> +
> +#define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
> +#define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
> +
> +#define SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
> +#define SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
> +#define SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_EXEPT
> +#define SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_SOFT
> +
> +#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
> +#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
> +
> +#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
> +#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
> +#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
> +
> +#define SVM_EXIT_READ_CR0   0x000
> +#define SVM_EXIT_READ_CR3   0x003
> +#define SVM_EXIT_READ_CR4   0x004
> +#define SVM_EXIT_READ_CR8   0x008
> +#define SVM_EXIT_WRITE_CR0  0x010
> +#define SVM_EXIT_WRITE_CR3  0x013
> +#define SVM_EXIT_WRITE_CR4  0x014
> +#define SVM_EXIT_WRITE_CR8  0x018
> +#define SVM_EXIT_READ_DR0   0x020
> +#define SVM_EXIT_READ_DR1   0x021
> +#define SVM_EXIT_READ_DR2   0x022
> +#define SVM_EXIT_READ_DR3   0x023
> +#define SVM_EXIT_READ_DR4   0x024
> +#define SVM_EXIT_READ_DR5   0x025
> +#define SVM_EXIT_READ_DR6   0x026
> +#define SVM_EXIT_READ_DR7   0x027
> +#define SVM_EXIT_WRITE_DR0  0x030
> +#define SVM_EXIT_WRITE_DR1  0x031
> +#define SVM_EXIT_WRITE_DR2  0x032
> +#define SVM_EXIT_WRITE_DR3  0x033
> +#define SVM_EXIT_WRITE_DR4  0x034
> +#define SVM_EXIT_WRITE_DR5  0x035
> +#define SVM_EXIT_WRITE_DR6  0x036
> +#define SVM_EXIT_WRITE_DR7  0x037
> +#define SVM_EXIT_EXCP_BASE	  0x040

Apart from the indent here and below, I did a quick diff and everything
seems fine. So with that fixed:

Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

> +#define SVM_EXIT_INTR	   0x060
> +#define SVM_EXIT_NMI		0x061
> +#define SVM_EXIT_SMI		0x062
> +#define SVM_EXIT_INIT	   0x063
> +#define SVM_EXIT_VINTR	  0x064
> +#define SVM_EXIT_CR0_SEL_WRITE  0x065
> +#define SVM_EXIT_IDTR_READ  0x066
> +#define SVM_EXIT_GDTR_READ  0x067
> +#define SVM_EXIT_LDTR_READ  0x068
> +#define SVM_EXIT_TR_READ	0x069
> +#define SVM_EXIT_IDTR_WRITE 0x06a
> +#define SVM_EXIT_GDTR_WRITE 0x06b
> +#define SVM_EXIT_LDTR_WRITE 0x06c
> +#define SVM_EXIT_TR_WRITE   0x06d
> +#define SVM_EXIT_RDTSC	  0x06e
> +#define SVM_EXIT_RDPMC	  0x06f
> +#define SVM_EXIT_PUSHF	  0x070
> +#define SVM_EXIT_POPF	   0x071
> +#define SVM_EXIT_CPUID	  0x072
> +#define SVM_EXIT_RSM		0x073
> +#define SVM_EXIT_IRET	   0x074
> +#define SVM_EXIT_SWINT	  0x075
> +#define SVM_EXIT_INVD	   0x076
> +#define SVM_EXIT_PAUSE	  0x077
> +#define SVM_EXIT_HLT		0x078
> +#define SVM_EXIT_INVLPG	 0x079
> +#define SVM_EXIT_INVLPGA	0x07a
> +#define SVM_EXIT_IOIO	   0x07b
> +#define SVM_EXIT_MSR		0x07c
> +#define SVM_EXIT_TASK_SWITCH	0x07d
> +#define SVM_EXIT_FERR_FREEZE	0x07e
> +#define SVM_EXIT_SHUTDOWN   0x07f
> +#define SVM_EXIT_VMRUN	  0x080
> +#define SVM_EXIT_VMMCALL	0x081
> +#define SVM_EXIT_VMLOAD	 0x082
> +#define SVM_EXIT_VMSAVE	 0x083
> +#define SVM_EXIT_STGI	   0x084
> +#define SVM_EXIT_CLGI	   0x085
> +#define SVM_EXIT_SKINIT	 0x086
> +#define SVM_EXIT_RDTSCP	 0x087
> +#define SVM_EXIT_ICEBP	  0x088
> +#define SVM_EXIT_WBINVD	 0x089
> +#define SVM_EXIT_MONITOR	0x08a
> +#define SVM_EXIT_MWAIT	  0x08b
> +#define SVM_EXIT_MWAIT_COND 0x08c
> +#define SVM_EXIT_NPF		0x400
> +
> +#define SVM_EXIT_ERR		-1
> +
> +#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
> +
> +#define SVM_CR0_RESERVED_MASK			0xffffffff00000000U
> +#define SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
> +#define SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
> +#define SVM_CR3_PAE_LEGACY_RESERVED_MASK	0x0000000000000007U
> +#define SVM_CR4_LEGACY_RESERVED_MASK		0xff08e000U
> +#define SVM_CR4_RESERVED_MASK			0xffffffffff08e000U
> +#define SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
> +#define SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
> +#define SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
> +
> +
> +#endif /* SRC_LIB_X86_SVM_H_ */
> diff --git a/x86/svm.h b/x86/svm.h
> index 1ad85ba4..3cd7ce8b 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -2,367 +2,10 @@
>  #define X86_SVM_H
>  
>  #include "libcflat.h"
> +#include <x86/svm.h>
>  
> -enum {
> -	INTERCEPT_INTR,
> -	INTERCEPT_NMI,
> -	INTERCEPT_SMI,
> -	INTERCEPT_INIT,
> -	INTERCEPT_VINTR,
> -	INTERCEPT_SELECTIVE_CR0,
> -	INTERCEPT_STORE_IDTR,
> -	INTERCEPT_STORE_GDTR,
> -	INTERCEPT_STORE_LDTR,
> -	INTERCEPT_STORE_TR,
> -	INTERCEPT_LOAD_IDTR,
> -	INTERCEPT_LOAD_GDTR,
> -	INTERCEPT_LOAD_LDTR,
> -	INTERCEPT_LOAD_TR,
> -	INTERCEPT_RDTSC,
> -	INTERCEPT_RDPMC,
> -	INTERCEPT_PUSHF,
> -	INTERCEPT_POPF,
> -	INTERCEPT_CPUID,
> -	INTERCEPT_RSM,
> -	INTERCEPT_IRET,
> -	INTERCEPT_INTn,
> -	INTERCEPT_INVD,
> -	INTERCEPT_PAUSE,
> -	INTERCEPT_HLT,
> -	INTERCEPT_INVLPG,
> -	INTERCEPT_INVLPGA,
> -	INTERCEPT_IOIO_PROT,
> -	INTERCEPT_MSR_PROT,
> -	INTERCEPT_TASK_SWITCH,
> -	INTERCEPT_FERR_FREEZE,
> -	INTERCEPT_SHUTDOWN,
> -	INTERCEPT_VMRUN,
> -	INTERCEPT_VMMCALL,
> -	INTERCEPT_VMLOAD,
> -	INTERCEPT_VMSAVE,
> -	INTERCEPT_STGI,
> -	INTERCEPT_CLGI,
> -	INTERCEPT_SKINIT,
> -	INTERCEPT_RDTSCP,
> -	INTERCEPT_ICEBP,
> -	INTERCEPT_WBINVD,
> -	INTERCEPT_MONITOR,
> -	INTERCEPT_MWAIT,
> -	INTERCEPT_MWAIT_COND,
> -};
> -
> -enum {
> -        VMCB_CLEAN_INTERCEPTS = 1, /* Intercept vectors, TSC offset, pause filter count */
> -        VMCB_CLEAN_PERM_MAP = 2,   /* IOPM Base and MSRPM Base */
> -        VMCB_CLEAN_ASID = 4,       /* ASID */
> -        VMCB_CLEAN_INTR = 8,       /* int_ctl, int_vector */
> -        VMCB_CLEAN_NPT = 16,       /* npt_en, nCR3, gPAT */
> -        VMCB_CLEAN_CR = 32,        /* CR0, CR3, CR4, EFER */
> -        VMCB_CLEAN_DR = 64,        /* DR6, DR7 */
> -        VMCB_CLEAN_DT = 128,       /* GDT, IDT */
> -        VMCB_CLEAN_SEG = 256,      /* CS, DS, SS, ES, CPL */
> -        VMCB_CLEAN_CR2 = 512,      /* CR2 only */
> -        VMCB_CLEAN_LBR = 1024,     /* DBGCTL, BR_FROM, BR_TO, LAST_EX_FROM, LAST_EX_TO */
> -        VMCB_CLEAN_AVIC = 2048,    /* APIC_BAR, APIC_BACKING_PAGE,
> -				      PHYSICAL_TABLE pointer, LOGICAL_TABLE pointer */
> -        VMCB_CLEAN_ALL = 4095,
> -};
> -
> -struct __attribute__ ((__packed__)) vmcb_control_area {
> -	u16 intercept_cr_read;
> -	u16 intercept_cr_write;
> -	u16 intercept_dr_read;
> -	u16 intercept_dr_write;
> -	u32 intercept_exceptions;
> -	u64 intercept;
> -	u8 reserved_1[40];
> -	u16 pause_filter_thresh;
> -	u16 pause_filter_count;
> -	u64 iopm_base_pa;
> -	u64 msrpm_base_pa;
> -	u64 tsc_offset;
> -	u32 asid;
> -	u8 tlb_ctl;
> -	u8 reserved_2[3];
> -	u32 int_ctl;
> -	u32 int_vector;
> -	u32 int_state;
> -	u8 reserved_3[4];
> -	u32 exit_code;
> -	u32 exit_code_hi;
> -	u64 exit_info_1;
> -	u64 exit_info_2;
> -	u32 exit_int_info;
> -	u32 exit_int_info_err;
> -	u64 nested_ctl;
> -	u8 reserved_4[16];
> -	u32 event_inj;
> -	u32 event_inj_err;
> -	u64 nested_cr3;
> -	u64 virt_ext;
> -	u32 clean;
> -	u32 reserved_5;
> -	u64 next_rip;
> -	u8 insn_len;
> -	u8 insn_bytes[15];
> -	u8 reserved_6[800];
> -};
> -
> -#define TLB_CONTROL_DO_NOTHING 0
> -#define TLB_CONTROL_FLUSH_ALL_ASID 1
> -
> -#define V_TPR_MASK 0x0f
> -
> -#define V_IRQ_SHIFT 8
> -#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
> -
> -#define V_GIF_ENABLED_SHIFT 25
> -#define V_GIF_ENABLED_MASK (1 << V_GIF_ENABLED_SHIFT)
> -
> -#define V_GIF_SHIFT 9
> -#define V_GIF_MASK (1 << V_GIF_SHIFT)
> -
> -#define V_INTR_PRIO_SHIFT 16
> -#define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
> -
> -#define V_IGN_TPR_SHIFT 20
> -#define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
> -
> -#define V_INTR_MASKING_SHIFT 24
> -#define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
> -
> -#define SVM_INTERRUPT_SHADOW_MASK 1
> -
> -#define SVM_IOIO_STR_SHIFT 2
> -#define SVM_IOIO_REP_SHIFT 3
> -#define SVM_IOIO_SIZE_SHIFT 4
> -#define SVM_IOIO_ASIZE_SHIFT 7
> -
> -#define SVM_IOIO_TYPE_MASK 1
> -#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
> -#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
> -#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
> -#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
> -
> -#define SVM_VM_CR_VALID_MASK	0x001fULL
> -#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
> -#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
> -
> -#define TSC_RATIO_DEFAULT   0x0100000000ULL
> -
> -struct __attribute__ ((__packed__)) vmcb_seg {
> -	u16 selector;
> -	u16 attrib;
> -	u32 limit;
> -	u64 base;
> -};
> -
> -struct __attribute__ ((__packed__)) vmcb_save_area {
> -	struct vmcb_seg es;
> -	struct vmcb_seg cs;
> -	struct vmcb_seg ss;
> -	struct vmcb_seg ds;
> -	struct vmcb_seg fs;
> -	struct vmcb_seg gs;
> -	struct vmcb_seg gdtr;
> -	struct vmcb_seg ldtr;
> -	struct vmcb_seg idtr;
> -	struct vmcb_seg tr;
> -	u8 reserved_1[43];
> -	u8 cpl;
> -	u8 reserved_2[4];
> -	u64 efer;
> -	u8 reserved_3[112];
> -	u64 cr4;
> -	u64 cr3;
> -	u64 cr0;
> -	u64 dr7;
> -	u64 dr6;
> -	u64 rflags;
> -	u64 rip;
> -	u8 reserved_4[88];
> -	u64 rsp;
> -	u8 reserved_5[24];
> -	u64 rax;
> -	u64 star;
> -	u64 lstar;
> -	u64 cstar;
> -	u64 sfmask;
> -	u64 kernel_gs_base;
> -	u64 sysenter_cs;
> -	u64 sysenter_esp;
> -	u64 sysenter_eip;
> -	u64 cr2;
> -	u8 reserved_6[32];
> -	u64 g_pat;
> -	u64 dbgctl;
> -	u64 br_from;
> -	u64 br_to;
> -	u64 last_excp_from;
> -	u64 last_excp_to;
> -};
> -
> -struct __attribute__ ((__packed__)) vmcb {
> -	struct vmcb_control_area control;
> -	struct vmcb_save_area save;
> -};
> -
> -#define SVM_CPUID_FEATURE_SHIFT 2
> -#define SVM_CPUID_FUNC 0x8000000a
> -
> -#define SVM_VM_CR_SVM_DISABLE 4
> -
> -#define SVM_SELECTOR_S_SHIFT 4
> -#define SVM_SELECTOR_DPL_SHIFT 5
> -#define SVM_SELECTOR_P_SHIFT 7
> -#define SVM_SELECTOR_AVL_SHIFT 8
> -#define SVM_SELECTOR_L_SHIFT 9
> -#define SVM_SELECTOR_DB_SHIFT 10
> -#define SVM_SELECTOR_G_SHIFT 11
> -
> -#define SVM_SELECTOR_TYPE_MASK (0xf)
> -#define SVM_SELECTOR_S_MASK (1 << SVM_SELECTOR_S_SHIFT)
> -#define SVM_SELECTOR_DPL_MASK (3 << SVM_SELECTOR_DPL_SHIFT)
> -#define SVM_SELECTOR_P_MASK (1 << SVM_SELECTOR_P_SHIFT)
> -#define SVM_SELECTOR_AVL_MASK (1 << SVM_SELECTOR_AVL_SHIFT)
> -#define SVM_SELECTOR_L_MASK (1 << SVM_SELECTOR_L_SHIFT)
> -#define SVM_SELECTOR_DB_MASK (1 << SVM_SELECTOR_DB_SHIFT)
> -#define SVM_SELECTOR_G_MASK (1 << SVM_SELECTOR_G_SHIFT)
> -
> -#define SVM_SELECTOR_WRITE_MASK (1 << 1)
> -#define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
> -#define SVM_SELECTOR_CODE_MASK (1 << 3)
> -
> -#define INTERCEPT_CR0_MASK 1
> -#define INTERCEPT_CR3_MASK (1 << 3)
> -#define INTERCEPT_CR4_MASK (1 << 4)
> -#define INTERCEPT_CR8_MASK (1 << 8)
> -
> -#define INTERCEPT_DR0_MASK 1
> -#define INTERCEPT_DR1_MASK (1 << 1)
> -#define INTERCEPT_DR2_MASK (1 << 2)
> -#define INTERCEPT_DR3_MASK (1 << 3)
> -#define INTERCEPT_DR4_MASK (1 << 4)
> -#define INTERCEPT_DR5_MASK (1 << 5)
> -#define INTERCEPT_DR6_MASK (1 << 6)
> -#define INTERCEPT_DR7_MASK (1 << 7)
> -
> -#define SVM_EVTINJ_VEC_MASK 0xff
> -
> -#define SVM_EVTINJ_TYPE_SHIFT 8
> -#define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
> -
> -#define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
> -#define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
> -#define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
> -#define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
> -
> -#define SVM_EVTINJ_VALID (1 << 31)
> -#define SVM_EVTINJ_VALID_ERR (1 << 11)
> -
> -#define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
> -#define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
> -
> -#define	SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
> -#define	SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
> -#define	SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_EXEPT
> -#define	SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_SOFT
> -
> -#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
> -#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
> -
> -#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
> -#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
> -#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
> -
> -#define	SVM_EXIT_READ_CR0 	0x000
> -#define	SVM_EXIT_READ_CR3 	0x003
> -#define	SVM_EXIT_READ_CR4 	0x004
> -#define	SVM_EXIT_READ_CR8 	0x008
> -#define	SVM_EXIT_WRITE_CR0 	0x010
> -#define	SVM_EXIT_WRITE_CR3 	0x013
> -#define	SVM_EXIT_WRITE_CR4 	0x014
> -#define	SVM_EXIT_WRITE_CR8 	0x018
> -#define	SVM_EXIT_READ_DR0 	0x020
> -#define	SVM_EXIT_READ_DR1 	0x021
> -#define	SVM_EXIT_READ_DR2 	0x022
> -#define	SVM_EXIT_READ_DR3 	0x023
> -#define	SVM_EXIT_READ_DR4 	0x024
> -#define	SVM_EXIT_READ_DR5 	0x025
> -#define	SVM_EXIT_READ_DR6 	0x026
> -#define	SVM_EXIT_READ_DR7 	0x027
> -#define	SVM_EXIT_WRITE_DR0 	0x030
> -#define	SVM_EXIT_WRITE_DR1 	0x031
> -#define	SVM_EXIT_WRITE_DR2 	0x032
> -#define	SVM_EXIT_WRITE_DR3 	0x033
> -#define	SVM_EXIT_WRITE_DR4 	0x034
> -#define	SVM_EXIT_WRITE_DR5 	0x035
> -#define	SVM_EXIT_WRITE_DR6 	0x036
> -#define	SVM_EXIT_WRITE_DR7 	0x037
> -#define SVM_EXIT_EXCP_BASE      0x040
> -#define SVM_EXIT_INTR		0x060
> -#define SVM_EXIT_NMI		0x061
> -#define SVM_EXIT_SMI		0x062
> -#define SVM_EXIT_INIT		0x063
> -#define SVM_EXIT_VINTR		0x064
> -#define SVM_EXIT_CR0_SEL_WRITE	0x065
> -#define SVM_EXIT_IDTR_READ	0x066
> -#define SVM_EXIT_GDTR_READ	0x067
> -#define SVM_EXIT_LDTR_READ	0x068
> -#define SVM_EXIT_TR_READ	0x069
> -#define SVM_EXIT_IDTR_WRITE	0x06a
> -#define SVM_EXIT_GDTR_WRITE	0x06b
> -#define SVM_EXIT_LDTR_WRITE	0x06c
> -#define SVM_EXIT_TR_WRITE	0x06d
> -#define SVM_EXIT_RDTSC		0x06e
> -#define SVM_EXIT_RDPMC		0x06f
> -#define SVM_EXIT_PUSHF		0x070
> -#define SVM_EXIT_POPF		0x071
> -#define SVM_EXIT_CPUID		0x072
> -#define SVM_EXIT_RSM		0x073
> -#define SVM_EXIT_IRET		0x074
> -#define SVM_EXIT_SWINT		0x075
> -#define SVM_EXIT_INVD		0x076
> -#define SVM_EXIT_PAUSE		0x077
> -#define SVM_EXIT_HLT		0x078
> -#define SVM_EXIT_INVLPG		0x079
> -#define SVM_EXIT_INVLPGA	0x07a
> -#define SVM_EXIT_IOIO		0x07b
> -#define SVM_EXIT_MSR		0x07c
> -#define SVM_EXIT_TASK_SWITCH	0x07d
> -#define SVM_EXIT_FERR_FREEZE	0x07e
> -#define SVM_EXIT_SHUTDOWN	0x07f
> -#define SVM_EXIT_VMRUN		0x080
> -#define SVM_EXIT_VMMCALL	0x081
> -#define SVM_EXIT_VMLOAD		0x082
> -#define SVM_EXIT_VMSAVE		0x083
> -#define SVM_EXIT_STGI		0x084
> -#define SVM_EXIT_CLGI		0x085
> -#define SVM_EXIT_SKINIT		0x086
> -#define SVM_EXIT_RDTSCP		0x087
> -#define SVM_EXIT_ICEBP		0x088
> -#define SVM_EXIT_WBINVD		0x089
> -#define SVM_EXIT_MONITOR	0x08a
> -#define SVM_EXIT_MWAIT		0x08b
> -#define SVM_EXIT_MWAIT_COND	0x08c
> -#define SVM_EXIT_NPF  		0x400
> -
> -#define SVM_EXIT_ERR		-1
> -
> -#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
> -
> -#define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
> -#define	SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
> -#define	SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
> -#define SVM_CR3_PAE_LEGACY_RESERVED_MASK	0x0000000000000007U
> -#define	SVM_CR4_LEGACY_RESERVED_MASK		0xff08e000U
> -#define	SVM_CR4_RESERVED_MASK			0xffffffffff08e000U
> -#define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
> -#define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
> -#define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
>  
>  #define MSR_BITMAP_SIZE 8192
> -
>  #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
>  
>  struct svm_test {
> 

