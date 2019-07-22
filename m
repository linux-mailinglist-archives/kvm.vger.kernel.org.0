Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A836E6FEFA
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfGVLut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 07:50:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40445 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfGVLut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 07:50:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so35036660wmj.5
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 04:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=swsIdjk1/KK2lJCfjS3uejgNTYuy7pWMGo/hVmMGJDI=;
        b=HlIdpC0oDVORl8hQrO5/1lCQ3ALW+z+jRSg3ZpYv6bAuXUKIniv0Rzvq792QxuCzBh
         SIL9eH79oxrYRDBTR+JpnpgfrfP4g1ssVgnYhKBO3vQZwyYJDBh398MheppJ8UjtlGej
         mkaJ2zx4vzoPLW+P/o5FJmfXehn1nnQpSh1pnkOJsXhuPrbDqVT8HisbWWjVDUbapL06
         QG8GE9zcoNlsm1kicEe2xsshLRgE73ezGKbYi9cgZmpDkexCc03+3h84yh4LStL1eI+n
         vDcUjPqmSeMJwPzIDjDp2YMjTtiuvXrx/4wKoglCYy+VI7UpFDinSpVVbsVvKi487QPh
         DLDg==
X-Gm-Message-State: APjAAAWVCIvfjIbVbNX2+L5FoNrM6rslzfDHTSo8OUFSTaBp036eNrQ8
        PUaRaiEGB+lgbvaNyFCMG1+vLQ==
X-Google-Smtp-Source: APXvYqzZuTV90BVyNv3OMyw8IlsWCnh4WG9oAD3jh1iq91o6fJrZYzogzkGWadMfuQRbbHO9M4tqRg==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr66164271wml.175.1563796247019;
        Mon, 22 Jul 2019 04:50:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:10f7:67c8:abb4:8512? ([2001:b07:6468:f312:10f7:67c8:abb4:8512])
        by smtp.gmail.com with ESMTPSA id 32sm32994837wrh.76.2019.07.22.04.50.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 04:50:46 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Set cached_vmcs12 and cached_shadow_vmcs12
 NULL after free
To:     Jan Kiszka <jan.kiszka@web.de>, kvm <kvm@vger.kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>
References: <e48af3c7-c7ac-87b4-3ce1-9b7b775cd6f2@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b31e088d-59cb-bbd7-159f-070e57cc121f@redhat.com>
Date:   Mon, 22 Jul 2019 13:50:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e48af3c7-c7ac-87b4-3ce1-9b7b775cd6f2@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/07/19 16:01, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Shall help finding use-after-free bugs earlier.
> 
> Suggested-by: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4cdab4b4eff1..ced9fba32598 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -234,7 +234,9 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  		vmx->vmcs01.shadow_vmcs = NULL;
>  	}
>  	kfree(vmx->nested.cached_vmcs12);
> +	vmx->nested.cached_vmcs12 = NULL;
>  	kfree(vmx->nested.cached_shadow_vmcs12);
> +	vmx->nested.cached_shadow_vmcs12 = NULL;
>  	/* Unpin physical memory we referred to in the vmcs02 */
>  	if (vmx->nested.apic_access_page) {
>  		kvm_release_page_dirty(vmx->nested.apic_access_page);
> --
> 2.16.4
> 

Queued, thanks.

Paolo
