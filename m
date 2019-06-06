Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79A837AB7
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfFFRP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:15:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40503 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFFRP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:15:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so723083wmj.5
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 10:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rJKb3ys+3XrsC73XTacsY9mg7vmuJe0mZTAMgehDZn8=;
        b=CGdYETWsn+jzTgAfNXoJe/DvzaZ5DrCl7PT+g1dMG5sCrG1zpRU3l1hYR4E6Cp6Ak/
         1/n2SOg7daxmcLJp85T8yE4ZpHzFlUGDWRToiOBcn2VjVpCoQRI8htyr5kPPyxp/WD/X
         rwAe7107bWZaHYh5GKxecKjLKKjicx6BT/k6oWSNP2k2CAwAob5MpoKMHdJEp3XlzrKH
         UgQMhmbY4uq/UXfcYYxRNNS+9HLCy3zjKxQqyUnjFCxnS3MheaczsU+bdKbYyW30lLV9
         Ef/jYZovGXBDOZc07eBA9PN5N0PxhMPfewVJOGz7auoxcIZj/dyHnW5gGWaK/TbJBOeL
         mN4g==
X-Gm-Message-State: APjAAAVvJH1aK8jkCSTRpOTmHQ287pXktkG4BUKkEuYE/5ml4QH0dAEK
        NDWM73PcZdWS4j0qjdqeOiTZelI/SP4=
X-Google-Smtp-Source: APXvYqxUGMiaVq21n8B2GCjYbQ2ujh95gLpnVJb/8K+QU0R/+Zxqg1S1vkGFHvg314jBXGzKf6TuVw==
X-Received: by 2002:a1c:65c3:: with SMTP id z186mr790861wmb.116.1559841325410;
        Thu, 06 Jun 2019 10:15:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id 11sm2339771wmd.23.2019.06.06.10.15.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:15:24 -0700 (PDT)
Subject: Re: [PATCH 10/13] KVM: nVMX: Preset *DT exiting in vmcs02 when
 emulating UMIP
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-11-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e42c29f-63a8-8a5f-b596-4c79ff03fc9d@redhat.com>
Date:   Thu, 6 Jun 2019 19:15:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507191805.9932-11-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 21:18, Sean Christopherson wrote:
> KVM dynamically toggles SECONDARY_EXEC_DESC to intercept (a subset of)
> instructions that are subject to User-Mode Instruction Prevention, i.e.
> VMCS.SECONDARY_EXEC_DESC == CR4.UMIP when emulating UMIP.  Preset the
> VMCS control when preparing vmcs02 to avoid unnecessarily VMWRITEs,
> e.g. KVM will clear VMCS.SECONDARY_EXEC_DESC in prepare_vmcs02_early()
> and then set it in vmx_set_cr4().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e4d363661ae7..4b5be38cfc86 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2057,6 +2057,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		/* VMCS shadowing for L2 is emulated for now */
>  		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
>  
> +		/* Preset *DT exiting when emulating UMIP (vmx_set_cr4()). */
> +		if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated() &&
> +		    (vmcs12->guest_cr4 & X86_CR4_UMIP))
> +			exec_control |= SECONDARY_EXEC_DESC;

I am not sure how used this functionality is, but I guess it's not a big 
price to pay.  However, --verbose is preferred:

                /*
                 * Preset *DT exiting when emulating UMIP, so that vmx_set_cr4()
                 * will not have to rewrite the controls just for this bit.
                 */

Paolo

>  		if (exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
>  			vmcs_write16(GUEST_INTR_STATUS,
>  				vmcs12->guest_intr_status);
> 

