Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C0637404
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfFFMW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:22:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33938 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFMW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:22:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so2221280wrn.1
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dxcsyq4Bff/lXKpOw+sLKPiTCJf2b/8faOSKHkuWZtc=;
        b=nlWnM2KekDgdXawNv6ndEuGvFzG33vghWtFcHBFQPmG6jRSsm/801GTJYxUqFKo+RN
         s7q2Gj2GpRA3RAVryizqrikLYlwPO3bn4KCqruIHbfKSguqJestWcJk/elU34EbtCLod
         lyOaNAXe8ee5K5dGA3KPOhrIwgusiF50bhhruo7b7k546bGVsakCAA1GeqT4KVRLwNdF
         zDI2mCMQubD2thaRhhK0W1oqbOAvJyc/mELJoSXH1KyF1BLwt+GN3kwXVYjZeuu2tHZc
         wOypHuSa9TEvUEwFj5fIISmVwuWhh6YViprBA2RiHmebinI0d96bL1ETQ1ual0m34JfL
         yLag==
X-Gm-Message-State: APjAAAUSXntGnlo0XJxCVZZ2ewc7ZqdturTE3evOSeJJobhmT24obz9p
        CCDEAmV18sEfRcnVji+GubNyygobBLQ=
X-Google-Smtp-Source: APXvYqwW61NLRB0mM3no2DVj8xsCbrfklrypGXf0VdqemaNzLs6LjTmi6pR6tUF/B/YlpkLC2QASVA==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr27867891wrp.149.1559823777460;
        Thu, 06 Jun 2019 05:22:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id c7sm1906883wrp.57.2019.06.06.05.22.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:22:56 -0700 (PDT)
Subject: Re: [PATCH 2/2] Revert "KVM: nVMX: always use early vmcs check when
 EPT is disabled"
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190520201029.7126-1-sean.j.christopherson@intel.com>
 <20190520201029.7126-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40c7c3ee-9c49-1df6-c80b-1bc7811ccf69@redhat.com>
Date:   Thu, 6 Jun 2019 14:22:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520201029.7126-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 22:10, Sean Christopherson wrote:
> @@ -3777,18 +3777,8 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  	vmx_set_cr4(vcpu, vmcs_readl(CR4_READ_SHADOW));
>  
>  	nested_ept_uninit_mmu_context(vcpu);
> -
> -	/*
> -	 * This is only valid if EPT is in use, otherwise the vmcs01 GUEST_CR3
> -	 * points to shadow pages!  Fortunately we only get here after a WARN_ON
> -	 * if EPT is disabled, so a VMabort is perfectly fine.
> -	 */
> -	if (enable_ept) {
> -		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -		__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
> -	} else {
> -		nested_vmx_abort(vcpu, VMX_ABORT_VMCS_CORRUPTED);
> -	}
> +	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> +	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
>  
>  	/*
>  	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs

This hunk needs to be moved to patch 1, which then becomes much easier
to understand...  I'm still missing however the place where
kvm_mmu_new_cr3 is called in the nested_vmx_restore_host_state path.

Paolo
