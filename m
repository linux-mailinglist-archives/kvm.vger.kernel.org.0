Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E8D433AC5
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhJSPk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbhJSPkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 11:40:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE51C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:38:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id oa4so252025pjb.2
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4R24uiP3AWTPwnTkUy3o4jaYTgjkE8f9tFEPy2wfsfc=;
        b=Z206A9md+kGzg5G31WtDmERS6yZ+AJHUUxywdfU4LCrh0LyH+2ke2Trl4SHK0ysU7l
         jTZTLoxJznK6ham+QaAogE3fCmf3FjDXmMYW1o3SdC4VULQFcOdY4OHEp8514Iq773n0
         fAHLCLfsuvUMPLFvf0nY8yBu7eCRioSCkYUZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4R24uiP3AWTPwnTkUy3o4jaYTgjkE8f9tFEPy2wfsfc=;
        b=0r4KeiikzDBSd5YETtl/N7eYIH2HhmmiLcjzjSYSRBvKbvRkcIBeb7e47+8LmBoeT9
         jnPR6eSgb2fAZza6Fw0WE2SIoIlKZ1bXlTs4xYbi1QVv+F0t7IPJye5v+VB5ZtWAB7b5
         bCDNDVg97hk6R/zuji9SzbQ0c0AQf44R1HqYEUaUHjM6b1f53mN27Oydxh4VtVaN3CC7
         ZkeRAYK32BJWLgkWJNYYHnzKKRZsZ0qU2Nffu0mh+gj8hJw6usNG30UmFAqCXzht46n9
         x7LU7jcV7gnlDqU2GENRdpUNB1aBWPdxyieB3F268IRqLwbW38LJwAutUgTxsYd8Lq0F
         w5Uw==
X-Gm-Message-State: AOAM533hVVxT4Lm/lScnY1AMrFdMDcbXz6az8Dztig1ngAWvcON3Oh2f
        Kc9jqnF1w1C2ZWUmukys6dNX0g==
X-Google-Smtp-Source: ABdhPJxTUXlRdWRfZs59UAiIjI2Eg1rfFSYbgdf3gjWiZkTkefYZ/VTjLY3CJ763AtjDmOA/dJwjzg==
X-Received: by 2002:a17:90b:4b48:: with SMTP id mi8mr675489pjb.13.1634657889765;
        Tue, 19 Oct 2021 08:38:09 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:490f:f89:7449:e615])
        by smtp.gmail.com with ESMTPSA id x7sm16710686pfj.164.2021.10.19.08.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:38:09 -0700 (PDT)
Date:   Wed, 20 Oct 2021 00:38:04 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCHV2 3/3] KVM: x86: add KVM_SET_MMU_PREFETCH ioctl
Message-ID: <YW7mXF9DNLk4fVkQ@google.com>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
 <20211019153214.109519-4-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019153214.109519-4-senozhatsky@chromium.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On (21/10/20 00:32), Sergey Senozhatsky wrote:
>  static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_clock_data data;
> @@ -6169,6 +6189,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	case KVM_X86_SET_MSR_FILTER:
>  		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
>  		break;
> +	case KVM_SET_MMU_PREFETCH: {
> +		u64 val;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&val, argp, sizeof(val)))
> +			goto out;
> +		r = kvm_arch_mmu_pte_prefetch(kvm, val);
> +		break;
> +	}

A side question: is there any value in turning this into a per-VCPU ioctl?
So that, say, on heterogeneous systems big cores can prefetch more than
little cores, for instance.
