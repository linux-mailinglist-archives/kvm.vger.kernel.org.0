Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B152938B25F
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbhETPCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 11:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236902AbhETPCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 11:02:03 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C745DC06175F
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 08:00:41 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z4so7022454plg.8
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 08:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CnY1DaODY1KdvjYw0LW7D3f0fKDMgCmLJnm1zDiKSUI=;
        b=ab7LuI/VOP1Z54R67M2+iv2RGFlALWRugOvhEc0+NLf3E4agUDZaRbfjbACRc2L6uh
         lBX2jApowtjM+V3ZAvRsV8B5QxFC5h75XVlAjSpYFp1W2PHCaXwbAPHyof4aRe9TccBF
         VrfybKZW/e9mBI6IKAwBO+MEujxsKP06MsV9uBB30niwX+Nf7tDIssOFp41BjMhcSacu
         V+3/FYLC7XHKUndxADgtilyA1uZ2PY2P3D8k5XqOLOL005iseP6MQ7FBM9DPxJIUzaq9
         hVj0QMw1Qaew0rH/ZH+3GT2DkVS8KnvYRpaWi1xi51Gj7RRlAo+IpKnN8+/ZBSeXulqv
         Ncvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CnY1DaODY1KdvjYw0LW7D3f0fKDMgCmLJnm1zDiKSUI=;
        b=Z1v3ePvPYqxGPxCruiN+tmTUctr8CorV/T9GAxvjbBbrR2yXaWDLtHUmy2hrYPh0LJ
         nHgSD+gxhLUZNSlCknEyE5Hccx/rtoK8/KufKxpcau7EDy45hccDNDkvGlu5JvW8RAaD
         wdks4jr0EZkRos4FKKyglFRHppYIJVWQKkvnrvVAhuyydFDvXOq1psUWZHAUdP2K+Mbd
         RgiV9bmYuzljK1GgHtb1OnYsLGmMgvkcGcj5/6W2oWkEhvv2Rr6VyY01+Ga6Rj4Lmf8m
         xYerHomNaeQKqqbnzSOPevmGLa4MLyAabOqIFKvec9+SjtmESPAeS8670jb3gvMWn5IF
         Svlg==
X-Gm-Message-State: AOAM532RVQBJO3PbYVmA+FnN9FXh1ASkguWGPvODXCoWnXBVPYmIVI48
        dHybGyPXOWl+qxAjPLb4thgdPQ==
X-Google-Smtp-Source: ABdhPJzHy3kTsYIsImOr9kmMKBz7qN1P29o4C4JT+2pmZeztdVYcsxy3r62y72Hd6Pc+8K3Ej+6lhA==
X-Received: by 2002:a17:902:dac6:b029:f3:16f3:d90d with SMTP id q6-20020a170902dac6b02900f316f3d90dmr6489328plx.42.1621522841059;
        Thu, 20 May 2021 08:00:41 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z19sm2125231pjn.0.2021.05.20.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 08:00:40 -0700 (PDT)
Date:   Thu, 20 May 2021 15:00:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/4 v2] KVM: nVMX: Reset 'nested_run_pending' only in
 guest mode
Message-ID: <YKZ5lNpbA7ck+/of@google.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520005012.68377-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Krish Sadhukhan wrote:
> Currently, vmx_vcpu_run() resets 'nested_run_pending' irrespective of whether
> it is in guest mode. 'nested_run_pending' matters only to guest mode and
> hence reset it only in guest mode.
> 
> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f2fd447eed45..af2be5930ba4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6839,7 +6839,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	kvm_load_host_xsave_state(vcpu);
>  
> -	vmx->nested.nested_run_pending = 0;
> +	if (is_guest_mode(vcpu))
> +		vmx->nested.nested_run_pending = 0;

This patch does not stand on its own, checking is_guest_mode() is likely more
expensive than unconditionally clearing the flag.  If we end up with conditional
stats code then I've no objection to clearing this conditionally, but that can
be done opportunstically.

Also, the check should be against vmx->nested.nested_run_pending itself, not
against is_guest_mode().  E.g. the stats patch adds a check on that, too.

> +
>  	vmx->idt_vectoring_info = 0;
>  
>  	if (unlikely(vmx->fail)) {
> -- 
> 2.27.0
> 
