Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9AC7CA877
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjJPMso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjJPMsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:48:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EFF9B
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697460467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=68f8uygD7D3VgCe0T94vks2l9145aaskhk30nk41qbI=;
        b=Ses7kY/wKuLm1Y0jxPMLa1YYb7BhYIby1Vhcba4nsZzH6FGdBKAAELXuppYGNLONJWSLBp
        CW0jOO6lAJsJ155nQ+1hdmEc4JLF/YnQMBUfnA1SCUPUmMw8fOoF9WaFz8C3V+fR/JjYuJ
        1NqOUl6zZsDhZjNxx/rdVq0HwtCm0Xo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-sVP6q7MIPDSzr64uQkPK7Q-1; Mon, 16 Oct 2023 08:47:46 -0400
X-MC-Unique: sVP6q7MIPDSzr64uQkPK7Q-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-41981d2dc9aso54133181cf.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697460465; x=1698065265;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=68f8uygD7D3VgCe0T94vks2l9145aaskhk30nk41qbI=;
        b=ws+yiME75MJLsI2m6kCh4wfgePiosSAzNH1q08L0xW17Psp1pFJm0SB5zwNHpLAFyQ
         +vhEJZ4KgsgdOydhu0hmkWVGeNnUzcZ8d2x1KaMI5y15v1fCdB7rdOCrLcdUi6cyUozd
         BE7PPNWdkTedLBEV/K6U5zyB2I3DS6UpfnD6I+BWLBX1GzOtBMEAIo9nMEyfJOH7Uz2P
         KH2RnshUlhVUoGqsSblpC6hns1BMXyFDI/XiTNjQbj0gK9kR0b5Da+/szy4ayeSU1nwO
         fqC+Y+jT86CCxF+IoakNlXk0u2V88Y7ulIacbccyb6F831AapbRMR4hw+A2Udx0qU3Ei
         89Xw==
X-Gm-Message-State: AOJu0YwpXyjR1AlyEAw/yTY1zf9MQt+fuXerI2lfSjEu+sb6piEyOoln
        0rc2CX31Dy3aq/cOzDQgxzodgpRYbj+cTO22Oym+x3vC1r+/xLahnMRAKom2cfXbqE8IUsgPJ2v
        Dr3iIBggYbyNs
X-Received: by 2002:a05:622a:1453:b0:418:1588:2653 with SMTP id v19-20020a05622a145300b0041815882653mr44158756qtx.12.1697460465552;
        Mon, 16 Oct 2023 05:47:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGghJbHEgZwoj1jbrRubWqGto6t9exeC1QnfNsIBiWS6xgUXRqvwKF5dHPOZfYmnxC7VuV13g==
X-Received: by 2002:a05:622a:1453:b0:418:1588:2653 with SMTP id v19-20020a05622a145300b0041815882653mr44158734qtx.12.1697460465089;
        Mon, 16 Oct 2023 05:47:45 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id jt39-20020a05622aa02700b0041abcc69050sm2986251qtb.95.2023.10.16.05.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:47:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 06/11] KVM: VMX: Split off hyperv_evmcs.{ch}
In-Reply-To: <bc104d65b6b12264b999a5874843766bac0b84be.camel@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
 <20231010160300.1136799-7-vkuznets@redhat.com>
 <bc104d65b6b12264b999a5874843766bac0b84be.camel@redhat.com>
Date:   Mon, 16 Oct 2023 14:47:42 +0200
Message-ID: <87jzrm91jl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> =D0=A3 =D0=B2=D1=82, 2023-10-10 =D1=83 18:02 +0200, Vitaly Kuznetsov =D0=
=BF=D0=B8=D1=88=D0=B5:
>> Some Enlightened VMCS related code is needed both by Hyper-V on KVM and
>> KVM on Hyper-V. As a preparation to making Hyper-V emulation optional,
>> create dedicated 'hyperv_evmcs.{ch}' files which are used by both.
>>=20
>
> I think it might be a good idea, to put this comment at the start of the=
=20
> hyperv_evmcs.h and/or hyperv_evmcs.c, explaining the fact that this file
> has code that is common for kvm on hyperv and for hyperv on kvm.
>
>
>> No functional change intended.
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/Makefile           |   2 +-
>>  arch/x86/kvm/vmx/hyperv.c       | 308 -------------------------------
>>  arch/x86/kvm/vmx/hyperv.h       | 163 +----------------
>>  arch/x86/kvm/vmx/hyperv_evmcs.c | 311 ++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/vmx/hyperv_evmcs.h | 162 +++++++++++++++++
>>  arch/x86/kvm/vmx/vmx_onhyperv.h |   3 +-
>>  6 files changed, 477 insertions(+), 472 deletions(-)
>>  create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.c
>>  create mode 100644 arch/x86/kvm/vmx/hyperv_evmcs.h
>>=20
>> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
>> index a99ffc3f3a3f..8ea872401cd6 100644
>> --- a/arch/x86/kvm/Makefile
>> +++ b/arch/x86/kvm/Makefile
>> @@ -23,7 +23,7 @@ kvm-$(CONFIG_KVM_XEN)	+=3D xen.o
>>  kvm-$(CONFIG_KVM_SMM)	+=3D smm.o
>>=20=20
>>  kvm-intel-y		+=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>> -			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o
>> +			   vmx/hyperv.o vmx/hyperv_evmcs.o vmx/nested.o vmx/posted_intr.o
>>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+=3D vmx/sgx.o
>>=20=20
>>  ifdef CONFIG_HYPERV
>> diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
>> index de13dc14fe1d..fab6a1ad98dc 100644
>> --- a/arch/x86/kvm/vmx/hyperv.c
>> +++ b/arch/x86/kvm/vmx/hyperv.c
>> @@ -13,314 +13,6 @@
>>=20=20
>>  #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
>>=20=20
>> -#define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
>> -#define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] =3D \
>> -		{EVMCS1_OFFSET(name), clean_field}
>> -
>> -const struct evmcs_field vmcs_field_to_evmcs_1[] =3D {
>> -	/* 64 bit rw */
>> -	EVMCS1_FIELD(GUEST_RIP, guest_rip,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(GUEST_RSP, guest_rsp,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> -	EVMCS1_FIELD(GUEST_RFLAGS, guest_rflags,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> -	EVMCS1_FIELD(HOST_IA32_PAT, host_ia32_pat,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_IA32_EFER, host_ia32_efer,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_CR0, host_cr0,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_CR3, host_cr3,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_CR4, host_cr4,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_IA32_SYSENTER_ESP, host_ia32_sysenter_esp,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_RIP, host_rip,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(IO_BITMAP_A, io_bitmap_a,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP),
>> -	EVMCS1_FIELD(IO_BITMAP_B, io_bitmap_b,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP),
>> -	EVMCS1_FIELD(MSR_BITMAP, msr_bitmap,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP),
>> -	EVMCS1_FIELD(GUEST_ES_BASE, guest_es_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_CS_BASE, guest_cs_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_SS_BASE, guest_ss_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_DS_BASE, guest_ds_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_FS_BASE, guest_fs_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_GS_BASE, guest_gs_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_LDTR_BASE, guest_ldtr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_TR_BASE, guest_tr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_GDTR_BASE, guest_gdtr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_IDTR_BASE, guest_idtr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(TSC_OFFSET, tsc_offset,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> -	EVMCS1_FIELD(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> -	EVMCS1_FIELD(VMCS_LINK_POINTER, vmcs_link_pointer,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_IA32_PAT, guest_ia32_pat,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_IA32_EFER, guest_ia32_efer,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_PDPTR0, guest_pdptr0,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_PDPTR1, guest_pdptr1,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_PDPTR2, guest_pdptr2,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_PDPTR3, guest_pdptr3,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exception=
s,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(CR0_GUEST_HOST_MASK, cr0_guest_host_mask,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(CR4_GUEST_HOST_MASK, cr4_guest_host_mask,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(CR0_READ_SHADOW, cr0_read_shadow,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(CR4_READ_SHADOW, cr4_read_shadow,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(GUEST_CR0, guest_cr0,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(GUEST_CR3, guest_cr3,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(GUEST_CR4, guest_cr4,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(GUEST_DR7, guest_dr7,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> -	EVMCS1_FIELD(HOST_FS_BASE, host_fs_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> -	EVMCS1_FIELD(HOST_GS_BASE, host_gs_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> -	EVMCS1_FIELD(HOST_TR_BASE, host_tr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> -	EVMCS1_FIELD(HOST_GDTR_BASE, host_gdtr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> -	EVMCS1_FIELD(HOST_IDTR_BASE, host_idtr_base,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> -	EVMCS1_FIELD(HOST_RSP, host_rsp,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> -	EVMCS1_FIELD(EPT_POINTER, ept_pointer,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT),
>> -	EVMCS1_FIELD(GUEST_BNDCFGS, guest_bndcfgs,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(XSS_EXIT_BITMAP, xss_exit_bitmap,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> -	EVMCS1_FIELD(ENCLS_EXITING_BITMAP, encls_exiting_bitmap,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> -	EVMCS1_FIELD(TSC_MULTIPLIER, tsc_multiplier,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> -	/*
>> -	 * Not used by KVM:
>> -	 *
>> -	 * EVMCS1_FIELD(0x00006828, guest_ia32_s_cet,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	 * EVMCS1_FIELD(0x0000682A, guest_ssp,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> -	 * EVMCS1_FIELD(0x0000682C, guest_ia32_int_ssp_table_addr,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	 * EVMCS1_FIELD(0x00002816, guest_ia32_lbr_ctl,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	 * EVMCS1_FIELD(0x00006C18, host_ia32_s_cet,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	 * EVMCS1_FIELD(0x00006C1A, host_ssp,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	 * EVMCS1_FIELD(0x00006C1C, host_ia32_int_ssp_table_addr,
>> -	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	 */
>> -
>> -	/* 64 bit read only */
>> -	EVMCS1_FIELD(GUEST_PHYSICAL_ADDRESS, guest_physical_address,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(EXIT_QUALIFICATION, exit_qualification,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	/*
>> -	 * Not defined in KVM:
>> -	 *
>> -	 * EVMCS1_FIELD(0x00006402, exit_io_instruction_ecx,
>> -	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> -	 * EVMCS1_FIELD(0x00006404, exit_io_instruction_esi,
>> -	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> -	 * EVMCS1_FIELD(0x00006406, exit_io_instruction_esi,
>> -	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> -	 * EVMCS1_FIELD(0x00006408, exit_io_instruction_eip,
>> -	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> -	 */
>> -	EVMCS1_FIELD(GUEST_LINEAR_ADDRESS, guest_linear_address,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -
>> -	/*
>> -	 * No mask defined in the spec as Hyper-V doesn't currently support
>> -	 * these. Future proof by resetting the whole clean field mask on
>> -	 * access.
>> -	 */
>> -	EVMCS1_FIELD(VM_EXIT_MSR_STORE_ADDR, vm_exit_msr_store_addr,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(VM_EXIT_MSR_LOAD_ADDR, vm_exit_msr_load_addr,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -
>> -	/* 32 bit rw */
>> -	EVMCS1_FIELD(TPR_THRESHOLD, tpr_threshold,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> -	EVMCS1_FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC),
>> -	EVMCS1_FIELD(EXCEPTION_BITMAP, exception_bitmap,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN),
>> -	EVMCS1_FIELD(VM_ENTRY_CONTROLS, vm_entry_controls,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY),
>> -	EVMCS1_FIELD(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT),
>> -	EVMCS1_FIELD(VM_ENTRY_EXCEPTION_ERROR_CODE,
>> -		     vm_entry_exception_error_code,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT),
>> -	EVMCS1_FIELD(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT),
>> -	EVMCS1_FIELD(HOST_IA32_SYSENTER_CS, host_ia32_sysenter_cs,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1),
>> -	EVMCS1_FIELD(VM_EXIT_CONTROLS, vm_exit_controls,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1),
>> -	EVMCS1_FIELD(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1),
>> -	EVMCS1_FIELD(GUEST_ES_LIMIT, guest_es_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_CS_LIMIT, guest_cs_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_SS_LIMIT, guest_ss_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_DS_LIMIT, guest_ds_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_FS_LIMIT, guest_fs_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_GS_LIMIT, guest_gs_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_LDTR_LIMIT, guest_ldtr_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_TR_LIMIT, guest_tr_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_GDTR_LIMIT, guest_gdtr_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_IDTR_LIMIT, guest_idtr_limit,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_ES_AR_BYTES, guest_es_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_CS_AR_BYTES, guest_cs_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_SS_AR_BYTES, guest_ss_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_DS_AR_BYTES, guest_ds_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_FS_AR_BYTES, guest_fs_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_GS_AR_BYTES, guest_gs_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_LDTR_AR_BYTES, guest_ldtr_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_TR_AR_BYTES, guest_tr_ar_bytes,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_ACTIVITY_STATE, guest_activity_state,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -	EVMCS1_FIELD(GUEST_SYSENTER_CS, guest_sysenter_cs,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> -
>> -	/* 32 bit read only */
>> -	EVMCS1_FIELD(VM_INSTRUCTION_ERROR, vm_instruction_error,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(VM_EXIT_REASON, vm_exit_reason,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(VM_EXIT_INTR_INFO, vm_exit_intr_info,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -	EVMCS1_FIELD(VMX_INSTRUCTION_INFO, vmx_instruction_info,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> -
>> -	/* No mask defined in the spec (not used) */
>> -	EVMCS1_FIELD(PAGE_FAULT_ERROR_CODE_MASK, page_fault_error_code_mask,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(CR3_TARGET_COUNT, cr3_target_count,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(VM_EXIT_MSR_STORE_COUNT, vm_exit_msr_store_count,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(VM_EXIT_MSR_LOAD_COUNT, vm_exit_msr_load_count,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -	EVMCS1_FIELD(VM_ENTRY_MSR_LOAD_COUNT, vm_entry_msr_load_count,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> -
>> -	/* 16 bit rw */
>> -	EVMCS1_FIELD(HOST_ES_SELECTOR, host_es_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_CS_SELECTOR, host_cs_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_SS_SELECTOR, host_ss_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_DS_SELECTOR, host_ds_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_FS_SELECTOR, host_fs_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_GS_SELECTOR, host_gs_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(HOST_TR_SELECTOR, host_tr_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> -	EVMCS1_FIELD(GUEST_ES_SELECTOR, guest_es_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_CS_SELECTOR, guest_cs_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_SS_SELECTOR, guest_ss_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_DS_SELECTOR, guest_ds_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_FS_SELECTOR, guest_fs_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_GS_SELECTOR, guest_gs_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_LDTR_SELECTOR, guest_ldtr_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(GUEST_TR_SELECTOR, guest_tr_selector,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> -	EVMCS1_FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id,
>> -		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT),
>> -};
>> -const unsigned int nr_evmcs_1_fields =3D ARRAY_SIZE(vmcs_field_to_evmcs=
_1);
>> -
>>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
>> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
>> index 9401dbfaea7c..d4ed99008518 100644
>> --- a/arch/x86/kvm/vmx/hyperv.h
>> +++ b/arch/x86/kvm/vmx/hyperv.h
>> @@ -2,170 +2,9 @@
>>  #ifndef __KVM_X86_VMX_HYPERV_H
>>  #define __KVM_X86_VMX_HYPERV_H
>>=20=20
>> -#include <linux/jump_label.h>
>> -
>> -#include <asm/hyperv-tlfs.h>
>> -#include <asm/mshyperv.h>
>> -#include <asm/vmx.h>
>> -
>> -#include "../hyperv.h"
>> -
>> -#include "capabilities.h"
>> -#include "vmcs.h"
>> +#include <linux/kvm_host.h>
>>  #include "vmcs12.h"
>>=20=20
>> -#define KVM_EVMCS_VERSION 1
>> -
>> -/*
>> - * Enlightened VMCSv1 doesn't support these:
>> - *
>> - *	POSTED_INTR_NV                  =3D 0x00000002,
>> - *	GUEST_INTR_STATUS               =3D 0x00000810,
>> - *	APIC_ACCESS_ADDR		=3D 0x00002014,
>> - *	POSTED_INTR_DESC_ADDR           =3D 0x00002016,
>> - *	EOI_EXIT_BITMAP0                =3D 0x0000201c,
>> - *	EOI_EXIT_BITMAP1                =3D 0x0000201e,
>> - *	EOI_EXIT_BITMAP2                =3D 0x00002020,
>> - *	EOI_EXIT_BITMAP3                =3D 0x00002022,
>> - *	GUEST_PML_INDEX			=3D 0x00000812,
>> - *	PML_ADDRESS			=3D 0x0000200e,
>> - *	VM_FUNCTION_CONTROL             =3D 0x00002018,
>> - *	EPTP_LIST_ADDRESS               =3D 0x00002024,
>> - *	VMREAD_BITMAP                   =3D 0x00002026,
>> - *	VMWRITE_BITMAP                  =3D 0x00002028,
>> - *
>> - *	TSC_MULTIPLIER                  =3D 0x00002032,
>> - *	PLE_GAP                         =3D 0x00004020,
>> - *	PLE_WINDOW                      =3D 0x00004022,
>> - *	VMX_PREEMPTION_TIMER_VALUE      =3D 0x0000482E,
>> - *
>> - * Currently unsupported in KVM:
>> - *	GUEST_IA32_RTIT_CTL		=3D 0x00002814,
>> - */
>> -#define EVMCS1_SUPPORTED_PINCTRL					\
>> -	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> -	 PIN_BASED_EXT_INTR_MASK |					\
>> -	 PIN_BASED_NMI_EXITING |					\
>> -	 PIN_BASED_VIRTUAL_NMIS)
>> -
>> -#define EVMCS1_SUPPORTED_EXEC_CTRL					\
>> -	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> -	 CPU_BASED_HLT_EXITING |					\
>> -	 CPU_BASED_CR3_LOAD_EXITING |					\
>> -	 CPU_BASED_CR3_STORE_EXITING |					\
>> -	 CPU_BASED_UNCOND_IO_EXITING |					\
>> -	 CPU_BASED_MOV_DR_EXITING |					\
>> -	 CPU_BASED_USE_TSC_OFFSETTING |					\
>> -	 CPU_BASED_MWAIT_EXITING |					\
>> -	 CPU_BASED_MONITOR_EXITING |					\
>> -	 CPU_BASED_INVLPG_EXITING |					\
>> -	 CPU_BASED_RDPMC_EXITING |					\
>> -	 CPU_BASED_INTR_WINDOW_EXITING |				\
>> -	 CPU_BASED_CR8_LOAD_EXITING |					\
>> -	 CPU_BASED_CR8_STORE_EXITING |					\
>> -	 CPU_BASED_RDTSC_EXITING |					\
>> -	 CPU_BASED_TPR_SHADOW |						\
>> -	 CPU_BASED_USE_IO_BITMAPS |					\
>> -	 CPU_BASED_MONITOR_TRAP_FLAG |					\
>> -	 CPU_BASED_USE_MSR_BITMAPS |					\
>> -	 CPU_BASED_NMI_WINDOW_EXITING |					\
>> -	 CPU_BASED_PAUSE_EXITING |					\
>> -	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
>> -
>> -#define EVMCS1_SUPPORTED_2NDEXEC					\
>> -	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
>> -	 SECONDARY_EXEC_WBINVD_EXITING |				\
>> -	 SECONDARY_EXEC_ENABLE_VPID |					\
>> -	 SECONDARY_EXEC_ENABLE_EPT |					\
>> -	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
>> -	 SECONDARY_EXEC_DESC |						\
>> -	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
>> -	 SECONDARY_EXEC_ENABLE_INVPCID |				\
>> -	 SECONDARY_EXEC_ENABLE_XSAVES |					\
>> -	 SECONDARY_EXEC_RDSEED_EXITING |				\
>> -	 SECONDARY_EXEC_RDRAND_EXITING |				\
>> -	 SECONDARY_EXEC_TSC_SCALING |					\
>> -	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
>> -	 SECONDARY_EXEC_PT_USE_GPA |					\
>> -	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
>> -	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
>> -	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
>> -	 SECONDARY_EXEC_ENCLS_EXITING)
>> -
>> -#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
>> -
>> -#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
>> -	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> -	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
>> -	 VM_EXIT_ACK_INTR_ON_EXIT |					\
>> -	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
>> -	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
>> -	 VM_EXIT_SAVE_IA32_PAT |					\
>> -	 VM_EXIT_LOAD_IA32_PAT |					\
>> -	 VM_EXIT_SAVE_IA32_EFER |					\
>> -	 VM_EXIT_LOAD_IA32_EFER |					\
>> -	 VM_EXIT_CLEAR_BNDCFGS |					\
>> -	 VM_EXIT_PT_CONCEAL_PIP |					\
>> -	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
>> -
>> -#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
>> -	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> -	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
>> -	 VM_ENTRY_IA32E_MODE |						\
>> -	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
>> -	 VM_ENTRY_LOAD_IA32_PAT |					\
>> -	 VM_ENTRY_LOAD_IA32_EFER |					\
>> -	 VM_ENTRY_LOAD_BNDCFGS |					\
>> -	 VM_ENTRY_PT_CONCEAL_PIP |					\
>> -	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
>> -
>> -#define EVMCS1_SUPPORTED_VMFUNC (0)
>> -
>> -struct evmcs_field {
>> -	u16 offset;
>> -	u16 clean_field;
>> -};
>> -
>> -extern const struct evmcs_field vmcs_field_to_evmcs_1[];
>> -extern const unsigned int nr_evmcs_1_fields;
>> -
>> -static __always_inline int evmcs_field_offset(unsigned long field,
>> -					      u16 *clean_field)
>> -{
>> -	unsigned int index =3D ROL16(field, 6);
>> -	const struct evmcs_field *evmcs_field;
>> -
>> -	if (unlikely(index >=3D nr_evmcs_1_fields))
>> -		return -ENOENT;
>> -
>> -	evmcs_field =3D &vmcs_field_to_evmcs_1[index];
>> -
>> -	/*
>> -	 * Use offset=3D0 to detect holes in eVMCS. This offset belongs to
>> -	 * 'revision_id' but this field has no encoding and is supposed to
>> -	 * be accessed directly.
>> -	 */
>> -	if (unlikely(!evmcs_field->offset))
>> -		return -ENOENT;
>> -
>> -	if (clean_field)
>> -		*clean_field =3D evmcs_field->clean_field;
>> -
>> -	return evmcs_field->offset;
>> -}
>> -
>> -static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
>> -				 unsigned long field, u16 offset)
>> -{
>> -	/*
>> -	 * vmcs12_read_any() doesn't care whether the supplied structure
>> -	 * is 'struct vmcs12' or 'struct hv_enlightened_vmcs' as it takes
>> -	 * the exact offset of the required field, use it for convenience
>> -	 * here.
>> -	 */
>> -	return vmcs12_read_any((void *)evmcs, field, offset);
>> -}
>> -
>>  #define EVMPTR_INVALID (-1ULL)
>>  #define EVMPTR_MAP_PENDING (-2ULL)
>>=20=20
>> diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.c b/arch/x86/kvm/vmx/hyperv_e=
vmcs.c
>> new file mode 100644
>> index 000000000000..57a2e0470ac8
>> --- /dev/null
>> +++ b/arch/x86/kvm/vmx/hyperv_evmcs.c
>> @@ -0,0 +1,311 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include "hyperv_evmcs.h"
>> +
>> +#define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
>> +#define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] =3D \
>> +		{EVMCS1_OFFSET(name), clean_field}
>> +
>> +const struct evmcs_field vmcs_field_to_evmcs_1[] =3D {
>> +	/* 64 bit rw */
>> +	EVMCS1_FIELD(GUEST_RIP, guest_rip,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(GUEST_RSP, guest_rsp,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> +	EVMCS1_FIELD(GUEST_RFLAGS, guest_rflags,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> +	EVMCS1_FIELD(HOST_IA32_PAT, host_ia32_pat,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_IA32_EFER, host_ia32_efer,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_CR0, host_cr0,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_CR3, host_cr3,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_CR4, host_cr4,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_IA32_SYSENTER_ESP, host_ia32_sysenter_esp,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_IA32_SYSENTER_EIP, host_ia32_sysenter_eip,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_RIP, host_rip,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(IO_BITMAP_A, io_bitmap_a,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP),
>> +	EVMCS1_FIELD(IO_BITMAP_B, io_bitmap_b,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP),
>> +	EVMCS1_FIELD(MSR_BITMAP, msr_bitmap,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP),
>> +	EVMCS1_FIELD(GUEST_ES_BASE, guest_es_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_CS_BASE, guest_cs_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_SS_BASE, guest_ss_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_DS_BASE, guest_ds_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_FS_BASE, guest_fs_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_GS_BASE, guest_gs_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_LDTR_BASE, guest_ldtr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_TR_BASE, guest_tr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_GDTR_BASE, guest_gdtr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_IDTR_BASE, guest_idtr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(TSC_OFFSET, tsc_offset,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> +	EVMCS1_FIELD(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> +	EVMCS1_FIELD(VMCS_LINK_POINTER, vmcs_link_pointer,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_IA32_PAT, guest_ia32_pat,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_IA32_EFER, guest_ia32_efer,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_IA32_PERF_GLOBAL_CTRL, guest_ia32_perf_global_ctrl,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_PDPTR0, guest_pdptr0,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_PDPTR1, guest_pdptr1,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_PDPTR2, guest_pdptr2,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_PDPTR3, guest_pdptr3,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_PENDING_DBG_EXCEPTIONS, guest_pending_dbg_exception=
s,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_SYSENTER_ESP, guest_sysenter_esp,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_SYSENTER_EIP, guest_sysenter_eip,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(CR0_GUEST_HOST_MASK, cr0_guest_host_mask,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(CR4_GUEST_HOST_MASK, cr4_guest_host_mask,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(CR0_READ_SHADOW, cr0_read_shadow,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(CR4_READ_SHADOW, cr4_read_shadow,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(GUEST_CR0, guest_cr0,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(GUEST_CR3, guest_cr3,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(GUEST_CR4, guest_cr4,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(GUEST_DR7, guest_dr7,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR),
>> +	EVMCS1_FIELD(HOST_FS_BASE, host_fs_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> +	EVMCS1_FIELD(HOST_GS_BASE, host_gs_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> +	EVMCS1_FIELD(HOST_TR_BASE, host_tr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> +	EVMCS1_FIELD(HOST_GDTR_BASE, host_gdtr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> +	EVMCS1_FIELD(HOST_IDTR_BASE, host_idtr_base,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> +	EVMCS1_FIELD(HOST_RSP, host_rsp,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER),
>> +	EVMCS1_FIELD(EPT_POINTER, ept_pointer,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT),
>> +	EVMCS1_FIELD(GUEST_BNDCFGS, guest_bndcfgs,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(XSS_EXIT_BITMAP, xss_exit_bitmap,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> +	EVMCS1_FIELD(ENCLS_EXITING_BITMAP, encls_exiting_bitmap,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> +	EVMCS1_FIELD(TSC_MULTIPLIER, tsc_multiplier,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2),
>> +	/*
>> +	 * Not used by KVM:
>> +	 *
>> +	 * EVMCS1_FIELD(0x00006828, guest_ia32_s_cet,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	 * EVMCS1_FIELD(0x0000682A, guest_ssp,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> +	 * EVMCS1_FIELD(0x0000682C, guest_ia32_int_ssp_table_addr,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	 * EVMCS1_FIELD(0x00002816, guest_ia32_lbr_ctl,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	 * EVMCS1_FIELD(0x00006C18, host_ia32_s_cet,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	 * EVMCS1_FIELD(0x00006C1A, host_ssp,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	 * EVMCS1_FIELD(0x00006C1C, host_ia32_int_ssp_table_addr,
>> +	 *	     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	 */
>> +
>> +	/* 64 bit read only */
>> +	EVMCS1_FIELD(GUEST_PHYSICAL_ADDRESS, guest_physical_address,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(EXIT_QUALIFICATION, exit_qualification,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	/*
>> +	 * Not defined in KVM:
>> +	 *
>> +	 * EVMCS1_FIELD(0x00006402, exit_io_instruction_ecx,
>> +	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> +	 * EVMCS1_FIELD(0x00006404, exit_io_instruction_esi,
>> +	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> +	 * EVMCS1_FIELD(0x00006406, exit_io_instruction_esi,
>> +	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> +	 * EVMCS1_FIELD(0x00006408, exit_io_instruction_eip,
>> +	 *		HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE);
>> +	 */
>> +	EVMCS1_FIELD(GUEST_LINEAR_ADDRESS, guest_linear_address,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +
>> +	/*
>> +	 * No mask defined in the spec as Hyper-V doesn't currently support
>> +	 * these. Future proof by resetting the whole clean field mask on
>> +	 * access.
>> +	 */
>> +	EVMCS1_FIELD(VM_EXIT_MSR_STORE_ADDR, vm_exit_msr_store_addr,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(VM_EXIT_MSR_LOAD_ADDR, vm_exit_msr_load_addr,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +
>> +	/* 32 bit rw */
>> +	EVMCS1_FIELD(TPR_THRESHOLD, tpr_threshold,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(GUEST_INTERRUPTIBILITY_INFO, guest_interruptibility_info,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC),
>> +	EVMCS1_FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC),
>> +	EVMCS1_FIELD(EXCEPTION_BITMAP, exception_bitmap,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN),
>> +	EVMCS1_FIELD(VM_ENTRY_CONTROLS, vm_entry_controls,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY),
>> +	EVMCS1_FIELD(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT),
>> +	EVMCS1_FIELD(VM_ENTRY_EXCEPTION_ERROR_CODE,
>> +		     vm_entry_exception_error_code,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT),
>> +	EVMCS1_FIELD(VM_ENTRY_INSTRUCTION_LEN, vm_entry_instruction_len,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT),
>> +	EVMCS1_FIELD(HOST_IA32_SYSENTER_CS, host_ia32_sysenter_cs,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1),
>> +	EVMCS1_FIELD(VM_EXIT_CONTROLS, vm_exit_controls,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1),
>> +	EVMCS1_FIELD(SECONDARY_VM_EXEC_CONTROL, secondary_vm_exec_control,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1),
>> +	EVMCS1_FIELD(GUEST_ES_LIMIT, guest_es_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_CS_LIMIT, guest_cs_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_SS_LIMIT, guest_ss_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_DS_LIMIT, guest_ds_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_FS_LIMIT, guest_fs_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_GS_LIMIT, guest_gs_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_LDTR_LIMIT, guest_ldtr_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_TR_LIMIT, guest_tr_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_GDTR_LIMIT, guest_gdtr_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_IDTR_LIMIT, guest_idtr_limit,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_ES_AR_BYTES, guest_es_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_CS_AR_BYTES, guest_cs_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_SS_AR_BYTES, guest_ss_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_DS_AR_BYTES, guest_ds_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_FS_AR_BYTES, guest_fs_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_GS_AR_BYTES, guest_gs_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_LDTR_AR_BYTES, guest_ldtr_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_TR_AR_BYTES, guest_tr_ar_bytes,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_ACTIVITY_STATE, guest_activity_state,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +	EVMCS1_FIELD(GUEST_SYSENTER_CS, guest_sysenter_cs,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1),
>> +
>> +	/* 32 bit read only */
>> +	EVMCS1_FIELD(VM_INSTRUCTION_ERROR, vm_instruction_error,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(VM_EXIT_REASON, vm_exit_reason,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(VM_EXIT_INTR_INFO, vm_exit_intr_info,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(VM_EXIT_INTR_ERROR_CODE, vm_exit_intr_error_code,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(IDT_VECTORING_INFO_FIELD, idt_vectoring_info_field,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(IDT_VECTORING_ERROR_CODE, idt_vectoring_error_code,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(VM_EXIT_INSTRUCTION_LEN, vm_exit_instruction_len,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +	EVMCS1_FIELD(VMX_INSTRUCTION_INFO, vmx_instruction_info,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE),
>> +
>> +	/* No mask defined in the spec (not used) */
>> +	EVMCS1_FIELD(PAGE_FAULT_ERROR_CODE_MASK, page_fault_error_code_mask,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(PAGE_FAULT_ERROR_CODE_MATCH, page_fault_error_code_match,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(CR3_TARGET_COUNT, cr3_target_count,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(VM_EXIT_MSR_STORE_COUNT, vm_exit_msr_store_count,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(VM_EXIT_MSR_LOAD_COUNT, vm_exit_msr_load_count,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +	EVMCS1_FIELD(VM_ENTRY_MSR_LOAD_COUNT, vm_entry_msr_load_count,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL),
>> +
>> +	/* 16 bit rw */
>> +	EVMCS1_FIELD(HOST_ES_SELECTOR, host_es_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_CS_SELECTOR, host_cs_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_SS_SELECTOR, host_ss_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_DS_SELECTOR, host_ds_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_FS_SELECTOR, host_fs_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_GS_SELECTOR, host_gs_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(HOST_TR_SELECTOR, host_tr_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1),
>> +	EVMCS1_FIELD(GUEST_ES_SELECTOR, guest_es_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_CS_SELECTOR, guest_cs_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_SS_SELECTOR, guest_ss_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_DS_SELECTOR, guest_ds_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_FS_SELECTOR, guest_fs_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_GS_SELECTOR, guest_gs_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_LDTR_SELECTOR, guest_ldtr_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(GUEST_TR_SELECTOR, guest_tr_selector,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2),
>> +	EVMCS1_FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id,
>> +		     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT),
>> +};
>> +const unsigned int nr_evmcs_1_fields =3D ARRAY_SIZE(vmcs_field_to_evmcs=
_1);
>> diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_e=
vmcs.h
>> new file mode 100644
>> index 000000000000..11d96975e7cc
>> --- /dev/null
>> +++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
>> @@ -0,0 +1,162 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __KVM_X86_VMX_HYPERV_EVMCS_H
>> +#define __KVM_X86_VMX_HYPERV_EVMCS_H
>> +
>> +#include <asm/hyperv-tlfs.h>
>> +
>> +#include "capabilities.h"
>> +#include "vmcs12.h"
>> +
>> +#define KVM_EVMCS_VERSION 1
>> +
>> +/*
>> + * Enlightened VMCSv1 doesn't support these:
>> + *
>> + *	POSTED_INTR_NV                  =3D 0x00000002,
>> + *	GUEST_INTR_STATUS               =3D 0x00000810,
>> + *	APIC_ACCESS_ADDR		=3D 0x00002014,
>> + *	POSTED_INTR_DESC_ADDR           =3D 0x00002016,
>> + *	EOI_EXIT_BITMAP0                =3D 0x0000201c,
>> + *	EOI_EXIT_BITMAP1                =3D 0x0000201e,
>> + *	EOI_EXIT_BITMAP2                =3D 0x00002020,
>> + *	EOI_EXIT_BITMAP3                =3D 0x00002022,
>> + *	GUEST_PML_INDEX			=3D 0x00000812,
>> + *	PML_ADDRESS			=3D 0x0000200e,
>> + *	VM_FUNCTION_CONTROL             =3D 0x00002018,
>> + *	EPTP_LIST_ADDRESS               =3D 0x00002024,
>> + *	VMREAD_BITMAP                   =3D 0x00002026,
>> + *	VMWRITE_BITMAP                  =3D 0x00002028,
>> + *
>> + *	TSC_MULTIPLIER                  =3D 0x00002032,
>> + *	PLE_GAP                         =3D 0x00004020,
>> + *	PLE_WINDOW                      =3D 0x00004022,
>> + *	VMX_PREEMPTION_TIMER_VALUE      =3D 0x0000482E,
>> + *
>> + * Currently unsupported in KVM:
>> + *	GUEST_IA32_RTIT_CTL		=3D 0x00002814,
>> + */
>> +#define EVMCS1_SUPPORTED_PINCTRL					\
>> +	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> +	 PIN_BASED_EXT_INTR_MASK |					\
>> +	 PIN_BASED_NMI_EXITING |					\
>> +	 PIN_BASED_VIRTUAL_NMIS)
>> +
>> +#define EVMCS1_SUPPORTED_EXEC_CTRL					\
>> +	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> +	 CPU_BASED_HLT_EXITING |					\
>> +	 CPU_BASED_CR3_LOAD_EXITING |					\
>> +	 CPU_BASED_CR3_STORE_EXITING |					\
>> +	 CPU_BASED_UNCOND_IO_EXITING |					\
>> +	 CPU_BASED_MOV_DR_EXITING |					\
>> +	 CPU_BASED_USE_TSC_OFFSETTING |					\
>> +	 CPU_BASED_MWAIT_EXITING |					\
>> +	 CPU_BASED_MONITOR_EXITING |					\
>> +	 CPU_BASED_INVLPG_EXITING |					\
>> +	 CPU_BASED_RDPMC_EXITING |					\
>> +	 CPU_BASED_INTR_WINDOW_EXITING |				\
>> +	 CPU_BASED_CR8_LOAD_EXITING |					\
>> +	 CPU_BASED_CR8_STORE_EXITING |					\
>> +	 CPU_BASED_RDTSC_EXITING |					\
>> +	 CPU_BASED_TPR_SHADOW |						\
>> +	 CPU_BASED_USE_IO_BITMAPS |					\
>> +	 CPU_BASED_MONITOR_TRAP_FLAG |					\
>> +	 CPU_BASED_USE_MSR_BITMAPS |					\
>> +	 CPU_BASED_NMI_WINDOW_EXITING |					\
>> +	 CPU_BASED_PAUSE_EXITING |					\
>> +	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
>> +
>> +#define EVMCS1_SUPPORTED_2NDEXEC					\
>> +	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
>> +	 SECONDARY_EXEC_WBINVD_EXITING |				\
>> +	 SECONDARY_EXEC_ENABLE_VPID |					\
>> +	 SECONDARY_EXEC_ENABLE_EPT |					\
>> +	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
>> +	 SECONDARY_EXEC_DESC |						\
>> +	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
>> +	 SECONDARY_EXEC_ENABLE_INVPCID |				\
>> +	 SECONDARY_EXEC_ENABLE_XSAVES |					\
>> +	 SECONDARY_EXEC_RDSEED_EXITING |				\
>> +	 SECONDARY_EXEC_RDRAND_EXITING |				\
>> +	 SECONDARY_EXEC_TSC_SCALING |					\
>> +	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
>> +	 SECONDARY_EXEC_PT_USE_GPA |					\
>> +	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
>> +	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
>> +	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
>> +	 SECONDARY_EXEC_ENCLS_EXITING)
>> +
>> +#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
>> +
>> +#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
>> +	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> +	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
>> +	 VM_EXIT_ACK_INTR_ON_EXIT |					\
>> +	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
>> +	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
>> +	 VM_EXIT_SAVE_IA32_PAT |					\
>> +	 VM_EXIT_LOAD_IA32_PAT |					\
>> +	 VM_EXIT_SAVE_IA32_EFER |					\
>> +	 VM_EXIT_LOAD_IA32_EFER |					\
>> +	 VM_EXIT_CLEAR_BNDCFGS |					\
>> +	 VM_EXIT_PT_CONCEAL_PIP |					\
>> +	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
>> +
>> +#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
>> +	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
>> +	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
>> +	 VM_ENTRY_IA32E_MODE |						\
>> +	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
>> +	 VM_ENTRY_LOAD_IA32_PAT |					\
>> +	 VM_ENTRY_LOAD_IA32_EFER |					\
>> +	 VM_ENTRY_LOAD_BNDCFGS |					\
>> +	 VM_ENTRY_PT_CONCEAL_PIP |					\
>> +	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
>> +
>> +#define EVMCS1_SUPPORTED_VMFUNC (0)
>> +
>> +struct evmcs_field {
>> +	u16 offset;
>> +	u16 clean_field;
>> +};
>> +
>> +extern const struct evmcs_field vmcs_field_to_evmcs_1[];
>> +extern const unsigned int nr_evmcs_1_fields;
>> +
>> +static __always_inline int evmcs_field_offset(unsigned long field,
>> +					      u16 *clean_field)
>> +{
>> +	unsigned int index =3D ROL16(field, 6);
>> +	const struct evmcs_field *evmcs_field;
>> +
>> +	if (unlikely(index >=3D nr_evmcs_1_fields))
>> +		return -ENOENT;
>> +
>> +	evmcs_field =3D &vmcs_field_to_evmcs_1[index];
>> +
>> +	/*
>> +	 * Use offset=3D0 to detect holes in eVMCS. This offset belongs to
>> +	 * 'revision_id' but this field has no encoding and is supposed to
>> +	 * be accessed directly.
>> +	 */
>> +	if (unlikely(!evmcs_field->offset))
>> +		return -ENOENT;
>> +
>> +	if (clean_field)
>> +		*clean_field =3D evmcs_field->clean_field;
>> +
>> +	return evmcs_field->offset;
>> +}
>> +
>> +static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
>> +				 unsigned long field, u16 offset)
>> +{
>> +	/*
>> +	 * vmcs12_read_any() doesn't care whether the supplied structure
>> +	 * is 'struct vmcs12' or 'struct hv_enlightened_vmcs' as it takes
>> +	 * the exact offset of the required field, use it for convenience
>> +	 * here.
>> +	 */
>> +	return vmcs12_read_any((void *)evmcs, field, offset);
>> +}
>> +
>> +#endif /* __KVM_X86_VMX_HYPERV_H */
>> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhy=
perv.h
>> index 11541d272dbd..eb48153bfd73 100644
>> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
>> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
>> @@ -4,11 +4,12 @@
>>  #define __ARCH_X86_KVM_VMX_ONHYPERV_H__
>>=20=20
>>  #include <asm/hyperv-tlfs.h>
>> +#include <asm/mshyperv.h>
>>=20=20
>>  #include <linux/jump_label.h>
>>=20=20
>>  #include "capabilities.h"
>> -#include "hyperv.h"
>> +#include "hyperv_evmcs.h"
>>  #include "vmcs12.h"
>>=20=20
>>  #define current_evmcs ((struct hv_enlightened_vmcs *)this_cpu_read(curr=
ent_vmcs))
>
>
> This patch fails the build because of vmx_has_valid_vmcs12() in nested.h =
which uses EVMPTR_INVALID.
>
> vmx/nested.h includes vmx/vmx.h which includes vmx_ops.h, it includes vmx=
_onhyperv.h which used to include hyperv.h but not anymore.
>
> We can either add hyperv.h to vmx/nested.h, or we can move the code in
> vmx_has_valid_vmcs12 to hyperv_evmcs.h.

That's weird as I'm pretty sure I've tested all 4 option states for
CONFIG_KVM_HYPERV/CONFIG_HYPERV before sending this out but I'll retest.

>
>
> Besides the build error,
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
> Best regards,
> 	Maxim Levitsky
>
>
>

--=20
Vitaly

