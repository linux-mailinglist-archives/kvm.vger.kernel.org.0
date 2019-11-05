Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254A5EFA61
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbfKEKEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbfKEKEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:04:20 -0500
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 97B49821CC
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:04:19 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id o202so6099035wme.5
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lrDn3WRTg+rwGOnenXl0j0b2dvVQo5Nmi58gDUT8LNE=;
        b=NVerztxMOeS9+1ge/rYCDSSyrSPQyY62OCfs6udRiMpCHd7uFsdm2LS7JLO5Xy6/Ja
         CR6TUg911Cr/hDFHX9xLAL2hh/f2bcKzITBAuOfMGpuveMOT+b1+AR7GEj6dfF1r7iHI
         0B64pIYOq9m6IEF9pYvJc4ApNoK++Blsk+hUIdx8CaEmQb6D01JN3lowP+qBDwiWHcBg
         XNZjJTl+qwyV5KbQ8K64xB9OSH8u6KksnsBnTJTbgmmLFR9K3QOnGkESo4xwVYQHWfMj
         dyhC7FWhUF35X3jP0MIys4axrAiGKT+abUKQizVQjMD7Uhdgyrij0SLK2jJPDoUPC+K8
         Djrg==
X-Gm-Message-State: APjAAAWk8ggnqdL+wx66eVFsoebdoXkixEuAcFpahtmb+IGPWXUi8o3r
        bDd2XbE5ulh0JHd6uXwL5Rwndq9iIgQcJMfzqhnabQiScAr0csb/3b2097bMG5YKcVTqHghjcir
        ifOXouxje5ufw
X-Received: by 2002:a05:6000:12d1:: with SMTP id l17mr13486380wrx.261.1572948258199;
        Tue, 05 Nov 2019 02:04:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjNhFV5qF8IUjCi16O1NoaQu8sSVoDIfgxCmNd9O29UA3q2m/52eCf5DqgEb0rGOHyGFqzUg==
X-Received: by 2002:a05:6000:12d1:: with SMTP id l17mr13486352wrx.261.1572948257905;
        Tue, 05 Nov 2019 02:04:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id t24sm30988243wra.55.2019.11.05.02.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:04:17 -0800 (PST)
Subject: Re: [PATCH 03/13] kvm: monolithic: fixup x86-32 build
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-4-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6ed4a5cd-38b1-04f8-e3d5-3327a1bd5d87@redhat.com>
Date:   Tue, 5 Nov 2019 11:04:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104230001.27774-4-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/19 23:59, Andrea Arcangeli wrote:
> kvm_x86_set_hv_timer and kvm_x86_cancel_hv_timer needs to be defined
> to succeed the 32bit kernel build, but they can't be called.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bd17ad61f7e3..1a58ae38c8f2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7195,6 +7195,17 @@ void kvm_x86_cancel_hv_timer(struct kvm_vcpu *vcpu)
>  {
>  	to_vmx(vcpu)->hv_deadline_tsc = -1;
>  }
> +#else
> +int kvm_x86_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
> +			 bool *expired)
> +{
> +	BUG();
> +}
> +
> +void kvm_x86_cancel_hv_timer(struct kvm_vcpu *vcpu)
> +{
> +	BUG();
> +}
>  #endif
>  
>  void kvm_x86_sched_in(struct kvm_vcpu *vcpu, int cpu)
> 

I'll check for how long this has been broken.  It may be the proof that
we can actually drop 32-bit KVM support.

Paolo
