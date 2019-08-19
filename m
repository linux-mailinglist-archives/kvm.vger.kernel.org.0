Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3575D948AB
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfHSPmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 11:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfHSPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 11:42:11 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 882BE5859E
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 15:42:10 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id w11so5420669wru.17
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 08:42:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zVYBxHNdylCUSC38C870FwmXf/G6m4riNwalhyYgVkY=;
        b=tichWyVwqK1ScjFOVVnczq05kj0lRb4EbjMhpyl7NSAn+87l6iDcVh5LyT1nnEfPWS
         t/ThjXCwZ06nxLwsWqMevjVjn6/O78tJjCfuTtZcMssXooxrbM8UDntn+OtbugsMZVI5
         3DnAwwghmpXYH1baLbNjyZEWQ+t0v5HLnHKb/jGTm3loGmUkpkjPS6hXkIIlFHR3h0LQ
         zyBQ1ao3f96UhF8auYQXLMC9B4kW50vmHuUxag0e5HGS2EOJFvt6GyQesw+MZGB85BM8
         efm1mh8hT/ZIXVGBxqBIb+AE797oE05mgQ99r+KlQtQG+M3pCV+ut9qpoekDpwDN01t4
         5KeQ==
X-Gm-Message-State: APjAAAWkZbVpnJot8Nwu5iowqJruOiGOlaiZpHw8tsGHspib/RmvonOW
        KhMBbknped+hSQn1Uve1m0URNrtt+JgRRHOmlFe+/uzWCV3wos96Wew/KFmIVgv8meIkyPmt/dn
        hwMr7UrhJrGNT
X-Received: by 2002:a5d:4644:: with SMTP id j4mr27828240wrs.146.1566229329226;
        Mon, 19 Aug 2019 08:42:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwNhD0DHO6CIBYcODwc0WTpH84mqMLWJzGDbNyGGTpZ00maIx5eJhNRY9qRsDRnuD7FOEQvoA==
X-Received: by 2002:a5d:4644:: with SMTP id j4mr27828209wrs.146.1566229328952;
        Mon, 19 Aug 2019 08:42:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8033:56b6:f047:ba4f? ([2001:b07:6468:f312:8033:56b6:f047:ba4f])
        by smtp.gmail.com with ESMTPSA id j9sm15758601wrx.66.2019.08.19.08.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:42:08 -0700 (PDT)
Subject: Re: [PATCH] KVM: Assert that struct kvm_vcpu is always as offset zero
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Joerg Roedel <joro@8bytes.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190815172237.10464-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <51adb35e-8297-1992-726e-a8e9f4953932@redhat.com>
Date:   Mon, 19 Aug 2019 17:42:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815172237.10464-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/08/19 19:22, Sean Christopherson wrote:
> KVM implementations that wrap struct kvm_vcpu with a vendor specific
> struct, e.g. struct vcpu_vmx, must place the vcpu member at offset 0,
> otherwise the usercopy region intended to encompass struct kvm_vcpu_arch
> will instead overlap random chunks of the vendor specific struct.
> E.g. padding a large number of bytes before struct kvm_vcpu triggers
> a usercopy warn when running with CONFIG_HARDENED_USERCOPY=y.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Note, the PowerPC change is completely untested.
> 
>  arch/powerpc/kvm/e500.c | 3 +++
>  arch/x86/kvm/svm.c      | 3 +++
>  arch/x86/kvm/vmx/vmx.c  | 3 +++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
> index b5a848a55504..00649ca5fa9a 100644
> --- a/arch/powerpc/kvm/e500.c
> +++ b/arch/powerpc/kvm/e500.c
> @@ -440,6 +440,9 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_e500(struct kvm *kvm,
>  	struct kvm_vcpu *vcpu;
>  	int err;
>  
> +	BUILD_BUG_ON_MSG(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0,
> +		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
> +
>  	vcpu_e500 = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
>  	if (!vcpu_e500) {
>  		err = -ENOMEM;
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d685491fce4d..70015ae5fc19 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2137,6 +2137,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
>  	struct page *nested_msrpm_pages;
>  	int err;
>  
> +	BUILD_BUG_ON_MSG(offsetof(struct vcpu_svm, vcpu) != 0,
> +		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
> +
>  	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>  	if (!svm) {
>  		err = -ENOMEM;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42ed3faa6af8..402cf2fe5cdd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6615,6 +6615,9 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  	unsigned long *msr_bitmap;
>  	int cpu;
>  
> +	BUILD_BUG_ON_MSG(offsetof(struct vcpu_vmx, vcpu) != 0,
> +		"struct kvm_vcpu must be at offset 0 for arch usercopy region");
> +
>  	vmx = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>  	if (!vmx)
>  		return ERR_PTR(-ENOMEM);
> 

Queued, thanks.

Paolo
