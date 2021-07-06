Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7513BD840
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhGFOfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhGFOfr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625581683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKUrcUoZRPh3vlCTbwVSchVaWqNiyUJJrYB0Hptcx60=;
        b=iLjVK9pg/pofYIDtYNLWFRGQH77l0jAh9Y6dHcMyQcGWQcLRxH4gI748oy3k+vvOU4X+IC
        fRLnuuM6YrifbXuJqk0r84xr5jYDrbApvUdhPjTq2ecEuaM+hloxt5xRCpj3AlVr6jUrg0
        Xrawqf2Z0EXLIH8UiObnL8m0ZWD44qI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-_LLYBuegOFWE6xz97na3HA-1; Tue, 06 Jul 2021 09:57:51 -0400
X-MC-Unique: _LLYBuegOFWE6xz97na3HA-1
Received: by mail-ej1-f71.google.com with SMTP id q14-20020a1709066aceb029049fa6bee56fso5798496ejs.21
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EKUrcUoZRPh3vlCTbwVSchVaWqNiyUJJrYB0Hptcx60=;
        b=OBHbAU3SDwKfqXQZBJVGdqGw949tCdYuEy6TOFkae0j6TokQazaSTk1sKlG15FAorr
         KMT05IEQ5Qqe5Gr9JKvIxT8FEvOYK0ULIQfz69mmWgyjbJ6F5E7+j7KOMcnkKblp/SS/
         F5iZICLq9JZFUWTxLNppfFmN2Luknf+DX2Ug6pALVkMXkp+M2hlBdwcT615RXkxRPiBp
         TtuBRCdgCW28Lqj7WlKmWg9jeWstKLTuOpeziZ4wYDFBPKO3XmAyCDtrWNj0pwAU3uUp
         qVWTkrEZ2Fe/QeOfDMBjbcp9e4unBlXlXatzFXWlTUrWR/oRejQhNtn+3chQl9zXj/wb
         rbFA==
X-Gm-Message-State: AOAM533GE3KUpTSF1zeR3Tnc6NgNZ92u9oJDumqzCveuoK9NRiVuCkaL
        bE5BROGvb7PVEe3+XDS0AumSDQL1bQwd5cLR/kROv7xWAciCGC8rGFnQ8RvIc+J/AwhdDZPlm4W
        REfazHa7Aa5mg
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr23712397edd.124.1625579869842;
        Tue, 06 Jul 2021 06:57:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAJ2tJamj+uOohOlQ6tz0WpswCJAoTzbdSOGDk+teLqVwo1R0UQ6ELupJ0rPb2msysmGXkrQ==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr23712370edd.124.1625579869708;
        Tue, 06 Jul 2021 06:57:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q23sm1720075edt.22.2021.07.06.06.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:57:48 -0700 (PDT)
Subject: Re: [RFC PATCH v2 23/69] KVM: x86: Hoist kvm_dirty_regs check out of
 sync_regs()
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <889017a8d31cea46472e0c64b234ef5919278ed9.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <98f9f005-67c5-39ba-0be8-8a752604fdd1@redhat.com>
Date:   Tue, 6 Jul 2021 15:57:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <889017a8d31cea46472e0c64b234ef5919278ed9.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Move the kvm_dirty_regs vs. KVM_SYNC_X86_VALID_FIELDS check out of
> sync_regs() and into its sole caller, kvm_arch_vcpu_ioctl_run().  This
> allows a future patch to allow synchronizing select state for protected
> VMs.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/x86.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7110d48cbc1..271245ffc67c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9729,7 +9729,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>   		goto out;
>   	}
>   
> -	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
> +	if ((kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) ||
> +	    (kvm_run->kvm_dirty_regs & ~KVM_SYNC_X86_VALID_FIELDS)) {
>   		r = -EINVAL;
>   		goto out;
>   	}
> @@ -10264,9 +10265,6 @@ static void store_regs(struct kvm_vcpu *vcpu)
>   
>   static int sync_regs(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu->run->kvm_dirty_regs & ~KVM_SYNC_X86_VALID_FIELDS)
> -		return -EINVAL;
> -
>   	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
>   		__set_regs(vcpu, &vcpu->run->s.regs.regs);
>   		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

