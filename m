Return-Path: <kvm+bounces-67572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E44D0AD60
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 16:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8C88D3018837
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 15:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411D235E555;
	Fri,  9 Jan 2026 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m7RvdlQO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52721311C38
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971861; cv=none; b=BjVoEL3poxN7L8C9GVbrCpEDwoxkB1WhMtimRcswM3ggcHAXVTfFSo/zV9ivxbpQ+zAyXxRJNCK2pZqBpJsRjncCFbQcRrc8ebc37gpcyVRBQt5qAbrw2l6c7ni5ihluxnGzoeTQASB/3rVhsRxZJmiG+6Dw2GD078y3sqQD/VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971861; c=relaxed/simple;
	bh=wraOIqhYG3It7LWinmFmn10g9mlV4E8u7FXmBpUTuh4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=diAPFjytwHmNHzAVZHOY4tpNHPpeG49Mzq/rDKBzIifpCVvG3u21oyGzScvzdCoBxsvXbevXq3Qs1IxVW5+fiw77mJDQW93+d6OummEPfBVYR11jMdL9cLOGJ4NO5UKAC/u0oksyx3NpLq4NoeWKHILslrYFo2Ltn+tepz51nL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m7RvdlQO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so4250806a91.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 07:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767971859; x=1768576659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aO7iUZVQjQuKnzat9kLZMX8yqUCa/gNx/w0Y51hMWjA=;
        b=m7RvdlQOSrkY4GrDcKCcPhL5b9brZuTaG/kJrkT8dYLwyatEfHavcF+snZkUHMCh9h
         gz/NuX5fwRaSHlb9s8f7SM9BZVgc85usIPlqTzXW+5/ryqB/dvsnzBd57fayl70zrywX
         XRyCZ0ZAS2sPuqlBF67JvanSUs/RmSe393PT2S0tf0QOY4tLSnT2To2AZXBmwl0MwyZ0
         DUzZB9WyaVFvuvaYz89zEcMyIyxJOgAUVxKxu66Jhz1zOUSIS9RRG358PaGQyuWbrTS6
         mwvZWoEC/TVPZ4/d3BQY/i4oD8RiDm4a24o1cgp00s6yUkdI4tBKtyfmyzu4Ledkz/se
         VUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767971859; x=1768576659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aO7iUZVQjQuKnzat9kLZMX8yqUCa/gNx/w0Y51hMWjA=;
        b=GkCwzcEoteQ+LnvEQ6rVO9u8XnblDa28cWq4GmGwcfeKOEZzeu6Qtau5zudyQ6QMHM
         XRVmiUBwQNuUGhUFRO59nheQVJh5cDts+RR9uMNASzjdR4wx4Qr4nDt0Wgd4l1/1mPHI
         UBKtRzUR3fmw/k8xEtQqG0EZfXmtRdZlnxnVrqhHQlKEnH5nDrvkRSpy8j7LPTTBmEtl
         ZIpmRrYDlaaUMt2Uz1sGg9wCKiUtKAqLl5vgh6FnUVc5DN/xjEmc45Y/qY3OwXhjybhu
         Gr8uMscOzh6XbD8WPhxnbaaHx/vmzj/yqd+l0qmwCLkWrCj+1iOfT2wTdABr8OMfSe33
         gzVg==
X-Forwarded-Encrypted: i=1; AJvYcCUBngy0vWHU0WugTBmhSTcgfnLcnOESoXa02TpJDWyVRbxSu953C5452GadA80LlXHno/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJydR9y72Xmk0SYbR3gebOmYrLeZlpsfhjzr5f1lkd3otMOIjf
	wwCYAfFTFipHx4b/Ky9/Rv8vnYcAO0HGaxCrrCwzMiTkCSeZ7yJ1PTVUvf0+KgK1MTJXZrPItof
	6E21cVQ==
X-Google-Smtp-Source: AGHT+IHXK1XZ8Pzy5GRMUTozSG8PjfpmZMqxorybDQYnOat3uci8qN9buauGuTt7twFjSq4i86KKQ++6Puc=
X-Received: from pjbgb18.prod.google.com ([2002:a17:90b:612:b0:343:af64:f654])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acb:b0:349:7f0a:381b
 with SMTP id 98e67ed59e1d1-34f68b4c603mr10033722a91.8.1767971859584; Fri, 09
 Jan 2026 07:17:39 -0800 (PST)
Date: Fri, 9 Jan 2026 07:17:37 -0800
In-Reply-To: <aWEUTQeNXugBYAZA@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109041523.1027323-1-seanjc@google.com> <20260109041523.1027323-4-seanjc@google.com>
 <288eaa68-7d4d-4c1b-ae70-419554d1d8f2@intel.com> <aWEUTQeNXugBYAZA@google.com>
Message-ID: <aWEcEQzHFQOeJnU4@google.com>
Subject: Re: [PATCH v3 3/4] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 09, 2026, Sean Christopherson wrote:
> On Fri, Jan 09, 2026, Xiaoyao Li wrote:
> > On 1/9/2026 12:15 PM, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 61113ead3d7b..ac7a17560c8f 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -111,6 +111,9 @@ static void init_vmcs_shadow_fields(void)
> > >   			  field <= GUEST_TR_AR_BYTES,
> > >   			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
> > > +		if (get_vmcs12_field_offset(field) < 0)
> > > +			continue;
> > > +
> > 
> > why shadow_read_only_fields[] doesn't need such guard?
> > 
> > IIUC, copy_vmcs12_to_shadow() will VMWRITE shadowed readonly field even if
> > it doesn't exist on the hardware?
> 
> Because I fixated on the existing checks and didn't look at the first for-loop.
> 
> This time around I'll test by hacking in shadowed fields arbitrary shadow fields.

And with the RO fields handled, the below doesn't explode (I verified there failures
aplenty if either of the RO or RW checks are commented out).

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..7d9bedd06afd 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -262,8 +262,12 @@ enum vmcs_field {
        SHARED_EPT_POINTER              = 0x0000203C,
        PID_POINTER_TABLE               = 0x00002042,
        PID_POINTER_TABLE_HIGH          = 0x00002043,
+       INJECTED_EVENT_DATA             = 0x00002052,
+       INJECTED_EVENT_DATA_HIGH        = 0x00002053,
        GUEST_PHYSICAL_ADDRESS          = 0x00002400,
        GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+       ORIGINAL_EVENT_DATA             = 0x00002404,
+       ORIGINAL_EVENT_DATA_HIGH        = 0x00002405,
        VMCS_LINK_POINTER               = 0x00002800,
        VMCS_LINK_POINTER_HIGH          = 0x00002801,
        GUEST_IA32_DEBUGCTL             = 0x00002802,
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 1ebe67c384ad..7952d58fb2d8 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -157,6 +157,8 @@ static const u16 kvm_supported_vmcs12_field_offsets[] __initconst = {
        FIELD(HOST_S_CET, host_s_cet),
        FIELD(HOST_SSP, host_ssp),
        FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
+       FIELD64(INJECTED_EVENT_DATA, injected_event_data),
+       FIELD64(ORIGINAL_EVENT_DATA, original_event_data),
 };
 
 u16 vmcs12_field_offsets[ARRAY_SIZE(kvm_supported_vmcs12_field_offsets)] __ro_after_init;
@@ -204,6 +206,12 @@ static __init bool cpu_has_vmcs12_field(unsigned int idx)
        case HOST_INTR_SSP_TABLE:
                return cpu_has_load_cet_ctrl();
 
+       case ORIGINAL_EVENT_DATA:
+       case ORIGINAL_EVENT_DATA_HIGH:
+       case INJECTED_EVENT_DATA:
+       case INJECTED_EVENT_DATA_HIGH:
+               return false;
+
        /* KVM always emulates PML and the VMX preemption timer in software. */
        case GUEST_PML_INDEX:
        case VMX_PREEMPTION_TIMER_VALUE:
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 21cd1b75e4fd..56565722f527 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -191,6 +191,9 @@ struct __packed vmcs12 {
        u16 host_gs_selector;
        u16 host_tr_selector;
        u16 guest_pml_index;
+
+       u64 injected_event_data;
+       u64 original_event_data;
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index cad128d1657b..d23ffedaf25b 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -75,5 +75,10 @@ SHADOW_FIELD_RW(HOST_GS_BASE, host_gs_base)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS, guest_physical_address)
 SHADOW_FIELD_RO(GUEST_PHYSICAL_ADDRESS_HIGH, guest_physical_address)
 
+SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA, original_event_data)
+SHADOW_FIELD_RO(ORIGINAL_EVENT_DATA_HIGH, original_event_data)
+SHADOW_FIELD_RW(INJECTED_EVENT_DATA, injected_event_data)
+SHADOW_FIELD_RW(INJECTED_EVENT_DATA_HIGH, injected_event_data)
+
 #undef SHADOW_FIELD_RO
 #undef SHADOW_FIELD_RW

