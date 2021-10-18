Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0E743235B
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 17:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhJRP4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhJRP4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 11:56:22 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95439C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:54:11 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t7so2235371pgl.9
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4+kbQQwNgL3xxKMT1SpsydyoctcTo7gLQXOCl1EGU/s=;
        b=YcoHj2M0Vy2T8O53TSFA3auuC6arG2WA7KqOlSvF5NCyBq6aBGpDfk/nt7+fJqxMoy
         4SReHE+EQWvseA7j3Pwiz/YkluusZwtNsoBkM0a5gGD9bfzoeh1pj06cyoW4dIgGOg/i
         SkZXzFEaaqO+xo+ifDtEH0scZ1L0sF5FE1nSCkqQCwhRyU8W47PGGrEx7CYJNfKFfK1k
         t0O7PXhmhOSAw583Alz6sAUufSesa7/Zmv5HxR6bcJPcV+0QAvua8+aANViRUZkZMKyA
         IQCP8fT6Nozp/cJP4d3EBH7m8Vu6nX5Yis0dBdkL5A4Kf0r8ucfCDJu7l90Di7LFdWwS
         mWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4+kbQQwNgL3xxKMT1SpsydyoctcTo7gLQXOCl1EGU/s=;
        b=zvtFsn6KGfa1It9P0cCGqdxp989QCp8P2NoYCh/e7xTGPbdiG5yi+fHtVVPXFQWI3F
         AC/hyc+TNsGLsUN+an2quwk1cC59NGxYAf1LeoWFpdglCIwhjP2Ixr7Pz+QFdSbGqUIN
         5sc7xSbplFk22b8qFBvGhzZscdQfIcV0INfJNF41lobGWK7E3iRAb8V7mp6yDhiwMrEL
         aTR4Wk1EWDziYIUdejV2WVLRhgHGM6EvQSdAIEWoZYpM071dax+aDEowS4Lukrp4J9KM
         /uJdsJDU8HEDcXLbYQw90SUS6DhoCWzgbNu4a6a94art4HhwiOz0wxbAtPBy6bRqaCkL
         b89g==
X-Gm-Message-State: AOAM530Sea0pej7E54AxY+Y/RsZPjFnF4yrb4s3torA3k8aY2Yf5vudM
        2wMxitCJrLCLhheCxAzj4z/rsA==
X-Google-Smtp-Source: ABdhPJyMTYj5yFdYSE4vwUtozWa2QKymVt6Ri/Bpfuw14zbzpsRG8cZgBWH3ZF6+tVyWCxfvJ4jBUg==
X-Received: by 2002:a63:b10a:: with SMTP id r10mr19847573pgf.238.1634572450862;
        Mon, 18 Oct 2021 08:54:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q12sm13910538pgv.26.2021.10.18.08.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 08:54:10 -0700 (PDT)
Date:   Mon, 18 Oct 2021 15:54:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH] KVM: SEV-ES: Set guest_state_protected after VMSA update
Message-ID: <YW2YngqTv6//YnD5@google.com>
References: <20211015173448.144114-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015173448.144114-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021, Paolo Bonzini wrote:
> From: Peter Gonda <pgonda@google.com>
> 
> The refactoring in commit bb18a6777465 ("KVM: SEV: Acquire
> vcpu mutex when updating VMSA") left behind the assignment to
> svm->vcpu.arch.guest_state_protected; add it back.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> [Delta between v2 and v3 of Peter's patch, which had already been
>  committed; the commit message is my own. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e672493b5d8d..0d21d59936e5 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -618,7 +618,12 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
>  	vmsa.address = __sme_pa(svm->vmsa);
>  	vmsa.len = PAGE_SIZE;
> -	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
> +	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
> +	if (ret)
> +	  return ret;

Bad indentation.

> +
> +	vcpu->arch.guest_state_protected = true;
> +	return 0;
>  }
>  
>  static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
> -- 
> 2.27.0
> 
