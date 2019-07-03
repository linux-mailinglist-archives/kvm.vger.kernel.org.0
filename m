Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F605EE36
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 23:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfGCVQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 17:16:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38453 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGCVQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 17:16:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so3851967wmj.3
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2019 14:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cb6cs+J8YgtLbQvkaF4nD0BlhdTGhrZKIXbtXveX9a0=;
        b=HAqygQmOwbYK/XxVD+AoK+rQzC+/5sa9jxlOZlFhRJIDATvSXCkhR07w7eZAXG/yuP
         /DVShsoREuO9gl9wkuOogAvPqK6PzcufgmEoASIgmAZ9XjZqHgMa9uJ95M8KPoRJSJ5g
         HNAv99ukpGwpgbjggMGYu7NuzViDUG5EnPYGMs2zGkjj/AweXDfggukkd3T9VvYfQo5+
         hjDD0ajWSY6DlJUz+nydZv+hy0AspFFai6+KljDi6VN+GxlLEzMYoFmcby9AIvIxlegM
         4hMT24hTxweEKY9MHWnsXCwFbEyu4/ihTYJUyG++dZL3alxOnzvdi5mE69p7B7fLzHu6
         3Bjg==
X-Gm-Message-State: APjAAAVmkteZtuWJNErtPQqGPFPMAhN8xz/KO/YmSQvNZ/xLxMpoRbfi
        2hIpBxXKSwJ84fiorftJVWoGQLNxl+lUsQ==
X-Google-Smtp-Source: APXvYqwQk4FOnYNfUTTlQZmZVProuL9/nRP3ceH5DgB4GJIhMd/A2hZ8UKJXPf7P1xf8IuAEA+BG6Q==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr9758082wmj.44.1562188605235;
        Wed, 03 Jul 2019 14:16:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e5b7:d6bb:ed2d:4d20? ([2001:b07:6468:f312:e5b7:d6bb:ed2d:4d20])
        by smtp.gmail.com with ESMTPSA id v4sm3501094wmg.22.2019.07.03.14.16.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:16:44 -0700 (PDT)
Subject: Re: [PATCH 1/6] KVM: x86: Add callback functions for handling APIC
 ID, DFR and LDR update
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "joro@8bytes.org" <joro@8bytes.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
References: <20190322115702.10166-1-suravee.suthikulpanit@amd.com>
 <20190322115702.10166-2-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <15e1b25c-906a-03dd-cb69-6b99c8c98ff7@redhat.com>
Date:   Wed, 3 Jul 2019 23:16:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190322115702.10166-2-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/19 12:57, Suthikulpanit, Suravee wrote:
> Add hooks for handling the case when guest VM update APIC ID, DFR and LDR.
> This is needed during AMD AVIC is temporary deactivated.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Why not do this later when AVIC is reactivated, in
svm_refresh_apicv_exec_ctrl?

Thanks,

Paolo

> ---
>  arch/x86/include/asm/kvm_host.h | 3 +++
>  arch/x86/kvm/lapic.c            | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a5db4475e72d..1906e205e6a3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1077,6 +1077,9 @@ struct kvm_x86_ops {
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>  	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
>  	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> +	void (*hwapic_apic_id_update)(struct kvm_vcpu *vcpu);
> +	void (*hwapic_dfr_update)(struct kvm_vcpu *vcpu);
> +	void (*hwapic_ldr_update)(struct kvm_vcpu *vcpu);
>  	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
>  	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
>  	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 991fdf7fc17f..95295cf81283 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -262,12 +262,16 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
>  {
>  	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
> +	if (kvm_x86_ops->hwapic_apic_id_update)
> +		kvm_x86_ops->hwapic_apic_id_update(apic->vcpu);
>  	recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
>  static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
>  {
>  	kvm_lapic_set_reg(apic, APIC_LDR, id);
> +	if (kvm_x86_ops->hwapic_ldr_update)
> +		kvm_x86_ops->hwapic_ldr_update(apic->vcpu);
>  	recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
> @@ -1836,6 +1840,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  	case APIC_DFR:
>  		if (!apic_x2apic_mode(apic)) {
>  			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
> +			if (kvm_x86_ops->hwapic_dfr_update)
> +				kvm_x86_ops->hwapic_dfr_update(apic->vcpu);
>  			recalculate_apic_map(apic->vcpu->kvm);
>  		} else
>  			ret = 1;
> 

