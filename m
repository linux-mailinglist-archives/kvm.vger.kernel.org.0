Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F0F32887A
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 18:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhCARki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 12:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbhCARfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:18 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25843C061756
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 09:34:38 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p5so10358787plo.4
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 09:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MCib3ah8PfyFdlygBn2qq6UVEhaoHtKFn/Hc+G2176o=;
        b=N+x8TZOj5uGCOF5t0Kcq7Fm2m1mg4p8m/BHpiA8MXn0tk7/rgyJFs7KVTjDtpMG6jv
         yP2/uu0WzPMW9CeydEqS5P/B7gd32IqnFZ1XjFqlnLWfKaasWaZmPvLF4aKVLzt3088O
         1dcX5w5opENS3HDA6NC1wni6ryz3Pnqh+p1Uuat+wnwmxhFxQdKURFzixVaQPwjBP+xN
         2b2CJRV+SBsbfOzWjJ53R8rj4dbotHO4oRtEgvPCz+wZ5dPKpr8GlWbf28u4y2xaGoAj
         D+mWk47A1l0l6+97RkXb/5X/UvCD64Ui0LmnZDxBMV4AQP+NnWL5UshuwiFKQKO88Umq
         zlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MCib3ah8PfyFdlygBn2qq6UVEhaoHtKFn/Hc+G2176o=;
        b=laqV+nzjskMW98XQ4B/DjScYt/vrq+WskUtUWBsdqXVCxvQMOP4slDXS6qzdFeijGA
         bNwTiUlBG3/jJzPKow/EmYwNX+yqMsRUMKfnwUuhRCj/pOc0j3W3ubxXpFwQI3ovJVwg
         flayYNQzncUvRYuwnM9bHnbEW+sTHrkSeiRIzwIjYJ7OsZD+ZDpP5yO3FZgrJ/12fmEq
         uAkHzDDlu6d7c1t8C+LI2G4yeoYyMhMQoMIKEkwEvbzAy+XNp3xICx9k28XchO+HWHfy
         t5LUO5vVkTCHlOPXA2zBX9DxVSXihvlbIBeG/vc+qCJnmAvAvnpfJYW6rTuXyxw/yZS/
         k0uw==
X-Gm-Message-State: AOAM531NkArsuDHrzw187D0hk/WJbkWmKtf6r04MHX0M6c2TRCYqjjys
        aRfU8WgSVvIFP1Ryh18QPwEseldU6tQx+A==
X-Google-Smtp-Source: ABdhPJwA42e38blQ6MrKzUk6eRTIWh9wo1PLfLIXaRtGhGYR7PJCYzCXz+peHAt06UOcchUjMQTZJQ==
X-Received: by 2002:a17:902:70c5:b029:e4:4ce3:90f5 with SMTP id l5-20020a17090270c5b02900e44ce390f5mr16151478plt.58.1614620077203;
        Mon, 01 Mar 2021 09:34:37 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id 134sm18717520pfc.113.2021.03.01.09.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:34:36 -0800 (PST)
Date:   Mon, 1 Mar 2021 09:34:30 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: Re: [PATCH 1/2] KVM: x86/xen: Fix return code when clearing
 vcpu_info and vcpu_time_info
Message-ID: <YD0lpr+YspdCsUqE@google.com>
References: <20210301125309.874953-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301125309.874953-1-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When clearing the per-vCPU shared regions, set the return value to zero
> to indicate success. This was causing spurious errors to be returned to
> userspace on soft reset.
> 
> Also add a paranoid BUILD_BUG_ON() for compat structure compatibility.
> 
> Fixes: 0c165b3c01fe ("KVM: x86/xen: Allow reset of Xen attributes")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/xen.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index af8f6562fce4..77b20ff09078 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -187,9 +187,12 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)

To avoid similar issues in the future, might be worth throwing "r = -ENOENT" in
the default case and have "r" be initialized to '0', or uninitialized to trigger
compiler warnings.  For any which way:

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  		/* No compat necessary here. */
>  		BUILD_BUG_ON(sizeof(struct vcpu_info) !=
>  			     sizeof(struct compat_vcpu_info));
> +		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
> +			     offsetof(struct compat_vcpu_info, time));
>  
>  		if (data->u.gpa == GPA_INVALID) {
>  			vcpu->arch.xen.vcpu_info_set = false;
> +			r = 0;
>  			break;
>  		}
>  
> @@ -206,6 +209,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
>  		if (data->u.gpa == GPA_INVALID) {
>  			vcpu->arch.xen.vcpu_time_info_set = false;
> +			r = 0;
>  			break;
>  		}
>  
> -- 
> 2.29.2
> 
