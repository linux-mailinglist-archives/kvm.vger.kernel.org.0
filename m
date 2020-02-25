Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2734416C378
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgBYOKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:10:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54783 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbgBYOKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582639836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bJJoWuth8QbpTnsnD04jwK92kDVW6k9Hdy8WzY5Xvx4=;
        b=a63RzDQUo0xoFkEOMmAvtbuBtIGisHY6b6gZWBMLjwPvzyJqteBVYh3X+6QDI+ae6Zbikp
        rZWBHO/bbdD8bZddG7JRYML6Y3Ip4fB5AEzddUOfpQDwzmP3ATfGcFvQfNPAet/zicdncK
        CWZhsmXETe+F/WkeGyqUFmjcACcVBs8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-G4oGnPpbN5O1Q8yLgvXzQw-1; Tue, 25 Feb 2020 09:10:34 -0500
X-MC-Unique: G4oGnPpbN5O1Q8yLgvXzQw-1
Received: by mail-wm1-f72.google.com with SMTP id 7so1070557wmf.9
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bJJoWuth8QbpTnsnD04jwK92kDVW6k9Hdy8WzY5Xvx4=;
        b=ScjvUNbeTCM/nbkavD+ffOYVOaxLbbIg4izKxoB8QFF6hKYeydox8bcj4XXvN0kzsk
         MqpX2KMM/F/5kbjpBOAHIpdMwZCeKqbHler1Yvfv84V0DyauxqyM59tEWyXuyqfe5NbK
         j1Z6/raotUvhDZ7dBOaqpln+Rq0IW5Q/PKAOfwW+TUQnPZjiboe/QX/xiaUyWQXqM8ug
         TJplQzCJ23+kpSrtFFjCnf6lD1qD+x8wB28mjzT90ppwf0QcbBMkrYTOK1yY9GifZw1l
         TBz7F8TO55/Klo73Be9j7dCJ3KDzVaEE/10CEU9NKRmzhJ2GlqmXgBnuw1kkFboLQfuH
         6BMg==
X-Gm-Message-State: APjAAAV4d1DBEiHM4hFuZjPLfIBJYHxVwGLFpX0nA6apv1WM8VlG7/Bq
        c5B1Du4gMIAYZD0pWkxJELwOHhEsfJnU0U/jQHnT/Gy1FfWNEYFsYF/Fp6uWD2h/Btl0BWS3zgh
        qb4z2XpdGWOG6
X-Received: by 2002:adf:80cb:: with SMTP id 69mr69878682wrl.320.1582639833817;
        Tue, 25 Feb 2020 06:10:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCkU2zj4QT64VJRCvumUqbgag/wgbT3Dvdebf3V4A+WrmdWNFreecb/1BXJJIvkYPXUEvNkQ==
X-Received: by 2002:adf:80cb:: with SMTP id 69mr69878666wrl.320.1582639833593;
        Tue, 25 Feb 2020 06:10:33 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h13sm23118178wrw.54.2020.02.25.06.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 06:10:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 53/61] KVM: VMX: Directly use VMX capabilities helper to detect RDTSCP support
In-Reply-To: <20200201185218.24473-54-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-54-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 15:10:32 +0100
Message-ID: <87pne2lpuv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use cpu_has_vmx_rdtscp() directly when computing secondary exec controls
> and drop the now defunct vmx_rdtscp_supported().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c3577f11f538..98d54cfa0cbe 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1651,11 +1651,6 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>  	vmx_clear_hlt(vcpu);
>  }
>  
> -static bool vmx_rdtscp_supported(void)
> -{
> -	return cpu_has_vmx_rdtscp();
> -}
> -
>  /*
>   * Swap MSR entry in host/guest MSR entry array.
>   */
> @@ -4051,7 +4046,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  		}
>  	}
>  
> -	if (vmx_rdtscp_supported()) {
> +	if (cpu_has_vmx_rdtscp()) {
>  		bool rdtscp_enabled = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP);
>  		if (!rdtscp_enabled)
>  			exec_control &= ~SECONDARY_EXEC_RDTSCP;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

