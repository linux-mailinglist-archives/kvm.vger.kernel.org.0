Return-Path: <kvm+bounces-39787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE20EA4A778
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 236017AB4A5
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFC57080C;
	Sat,  1 Mar 2025 01:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHea9+xg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22A71401B
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 01:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740792868; cv=none; b=X1fLx/Bj2tkTn1L3map6kbaZx8cK+Z7xu4qosXQRG6oK/Ux+4W/TK0lyWEBncfWzoIz4OxsCEF9VUOSkfRCwCt1Z6Pnh3o85V7ZhxoDM8yLCVmA8NzlApqo7IV5iKjEBPvOzjFQkHkkmYaH8OaIPnyDLukddXASJebIIwzv4yjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740792868; c=relaxed/simple;
	bh=fnh3fwq5HR0yTHAmHdMT421sbicofsP0HTiVsJhWt6g=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WJ1D/YEuQpELnLwGl3Us9zusoTsW7cLA6f/Ue0TO+mi9rdqIdZ7ikD8+kX1JOjI0QKXX21iQeNQC23DKU+9tPcr4aFjIl5gKqtCP6DlpO4rG9XsTc2UZOQUW6oh/z9+6mUzU9lq543vzh5s/+LEWENPFJmHR/mTqqCP3aQgou00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LHea9+xg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740792865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yL+DXeBooPzKSt9J+mbcjwBug/6vCcWna4sgw9dm4c=;
	b=LHea9+xgdZeblf0dGoMO20rRncgkEcNqSHjSyTQpdDvzwZpgHP9k3s6Gvm8UtvfBRqaehc
	vomHL+g2RgREPdFPmpXaDJVdfyiVvEGzdVs1Srwo/ZV0btt7SQYSUL5ceG/jJdv1B59TvL
	tMZh/3wI9PkHwnaIlrcdSOH+iJ3vWwY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-rkKEuZ5FM0qsV9tzfxvuEQ-1; Fri, 28 Feb 2025 20:34:22 -0500
X-MC-Unique: rkKEuZ5FM0qsV9tzfxvuEQ-1
X-Mimecast-MFC-AGG-ID: rkKEuZ5FM0qsV9tzfxvuEQ_1740792862
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c09d61bf4aso480598485a.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:34:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740792862; x=1741397662;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9yL+DXeBooPzKSt9J+mbcjwBug/6vCcWna4sgw9dm4c=;
        b=urN/f7GlYXvR4zCEL7oLLgS1rXr9nbzQIwjzT9FEWyPV5P37IJnMpn7eKXAHFzwgQw
         8eKRBUNlpPgAWNFSWcHeSQCHi9r1JRW6iOs3lj8YY3fqJBjZhy1LOxzS6JCTEoXcGA2M
         R8U4JOcUyy+f/YAYgpRPatmhMq65lQNlc+QwuESAciRTQsbNTFNLcyBcK+c9bW1vI6cp
         r1IXom7ClxkCssXbHn6P9sbLYi13zK83nUhTo0WjJoCJIVwYNUrttlMc5DGD1/vDKIKw
         1d85MLRXzBP+YnXiSUZsSqP+sr2CEP9ZMxTPJ5KbEWfbKccNbQR/08yl9XMsD4zZrsPb
         b0GA==
X-Gm-Message-State: AOJu0YzTUNCr9wZIMudemz7i3nQ4fdPodnMitEzBxYlVN8ejp1YXqMZ8
	dCKDtTfSUvtzRY92Via433mqmiSrOuUW28eltPOsxu7wncvvd/3a5ptjOWV6F025LZpCfjyWlgk
	xoUsyCpl+yZSvieHNhrMl9/FivIxgqPXA6+dQIAtsTprcQOkWQA==
X-Gm-Gg: ASbGnct3miGcHXwIV+yIx+8HqC0o3XxeCc2EsvuS9GYfZWnJu5+KWa9yXpQnVZfNBuE
	TDLhQZRUO5Qgbrh1jh/2fnA3jrunVVxhaKHFt/rB5jQgVMCByo+zMzZq0Lv7SWLRVf1wbfSwB0u
	z6DCNiGm2u3NuKfd/0R3CzuAnpACa3lBtx5WDuBlSsLoCrKsw6ar+++VdMoiUJk1R9+wIJPp+I6
	Zjf5QSzMrxGU72kNVl13kdghCF4tZnEtTZ2zmNkA7FvaPttOvyS8pgxd7dsGwQLYDPv+Bs1+boH
	qh6iP1sfSCiyyuI=
X-Received: by 2002:a05:620a:6082:b0:7c3:9d34:e666 with SMTP id af79cd13be357-7c39d34e743mr862873585a.15.1740792861796;
        Fri, 28 Feb 2025 17:34:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZOSNDJhIJKTBsRU1jV9sv/N+QSCwUc/hKZOGRqdOLDg5v3mfrAbcVJB8Is74143ja5GmkIg==
X-Received: by 2002:a05:620a:6082:b0:7c3:9d34:e666 with SMTP id af79cd13be357-7c39d34e743mr862872485a.15.1740792861546;
        Fri, 28 Feb 2025 17:34:21 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c378d9e32dsm317624985a.74.2025.02.28.17.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 17:34:21 -0800 (PST)
Message-ID: <de4a5000d03a4697a419231d766f95dfd1cbe7c6.camel@redhat.com>
Subject: Re: [RFC PATCH 03/13] KVM: nSVM: Split
 nested_svm_transition_tlb_flush() into entry/exit fns
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 20:34:20 -0500
In-Reply-To: <20250205182402.2147495-4-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-4-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> The handling for the entry and exit TLB flushes will diverge
> significantly in the following changes. Instead of adding an 'is_vmenter'
> argument like nested_vmx_transition_tlb_flush(), just split the function
> into two variants for 'entry' and 'exit'.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index bbe4f3ac9f250..2eba36af44f22 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -482,7 +482,7 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
>  	vmcb12->control.exit_int_info = exit_int_info;
>  }
>  
> -static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
> +static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
>  {
>  	/* Handle pending Hyper-V TLB flush requests */
>  	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
> @@ -503,6 +503,16 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
>  
> +static void nested_svm_exit_tlb_flush(struct kvm_vcpu *vcpu)
> +{
> +	/* Handle pending Hyper-V TLB flush requests */
> +	kvm_hv_nested_transtion_tlb_flush(vcpu, npt_enabled);
> +
> +	/* See nested_svm_entry_tlb_flush() */
> +	kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> +	kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> +}
> +
>  /*
>   * Load guest's/host's cr3 on nested vmentry or vmexit. @nested_npt is true
>   * if we are emulating VM-Entry into a guest with NPT enabled.
> @@ -645,7 +655,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	u32 pause_count12;
>  	u32 pause_thresh12;
>  
> -	nested_svm_transition_tlb_flush(vcpu);
> +	nested_svm_entry_tlb_flush(vcpu);
>  
>  	/* Enter Guest-Mode */
>  	enter_guest_mode(vcpu);
> @@ -1131,7 +1141,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	kvm_vcpu_unmap(vcpu, &map);
>  
> -	nested_svm_transition_tlb_flush(vcpu);
> +	nested_svm_exit_tlb_flush(vcpu);
>  
>  	nested_svm_uninit_mmu_context(vcpu);
>  

Looks reasonable,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


