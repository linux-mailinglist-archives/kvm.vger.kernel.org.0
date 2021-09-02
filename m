Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ED63FF539
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhIBVBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhIBVBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 17:01:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4241C061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 14:00:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so2431417pjq.1
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8fkdHIt1+3BNKFqb98a/8L9VuMWl2vCFSjJjZfHORi0=;
        b=gUvUTtgDwWLxh6DEiBet5qN9Jf5ASf5QnkslelRw3K6yduEfgOf726+efViNuffMOi
         CqLNd6ue1urPA31xTzULGZosorTKqf3gHBAHtRHdFkWgwbhsuyhIMuibck4bF3NO52bq
         sTy4k7eASqzgaDdmBeXMEeLa44f+BaJJovi4lzb+qfh3D++7UVXg/7s7Zqhh8ykgsTO1
         uMtGpL0bA1u9fxPHJVDd1WpiD43Dq9eeqGeKrlqq7whNGAsYTlJpU+jy+Wixj0+ryIZA
         qNGzwWnR/BGD7fZlwQKRkKfl0W7qLrxDKE9m75sH7F3EYAynI6/VVmAjTNopU0hl0lsV
         hqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8fkdHIt1+3BNKFqb98a/8L9VuMWl2vCFSjJjZfHORi0=;
        b=ujw1dpRLLlgLyjjsr76dQ+7/5RRB7xi3ScnxGcV778F/Ybbqk1fAzooLpjo8Fo/Heh
         GB8VUH4zREY/A4qBF4MPkCqPzUiIdSG+hCP5OXsRNcICbKlVmMgEjPOQFroK2gev5YOz
         pq0djhZZ4sszXCj3NMW3kLu863sC0hHrLyJgCDeCll9O3EfYCAubaC3vXUIj8HklH80y
         rvEee7a48nZ4KuWrZVhtCUEcE97dfX/7ffKDnLnoUZoqzfIkM3xIhJz9LKLVNmbLO7e0
         2aoAY0kRWBC3JSmddInNGS5/uI5LUV0U2AdPZ/wOD/SLpiD4+IFFuiLnK83vmYnzUmkS
         KZtA==
X-Gm-Message-State: AOAM533K2TsUozB3NDXPVPQBUoNKRHq6EnCW58I2G5BmdDDVKQx4pFsi
        OdG9nup02W6NWBwz7JxlUxKIQQ==
X-Google-Smtp-Source: ABdhPJz3z1eNM5QauHlFUZdx/fwxZnmsnGR0Bo+8X0nj6efD9oqyH2TSLhCPL+yF+Evv6RFDA5z1Ew==
X-Received: by 2002:a17:902:a385:b0:138:4c9:a39e with SMTP id x5-20020a170902a38500b0013804c9a39emr42011pla.42.1630616409677;
        Thu, 02 Sep 2021 14:00:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q12sm3129921pfj.153.2021.09.02.14.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:00:09 -0700 (PDT)
Date:   Thu, 2 Sep 2021 21:00:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/8] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Message-ID: <YTE7VWJFivPR8Mrh@google.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
 <20210827092516.1027264-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827092516.1027264-5-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Vitaly Kuznetsov wrote:
> Iterating over set bits in 'vcpu_bitmap' should be faster than going
> through all vCPUs, especially when just a few bits are set.
> 
> Drop kvm_make_vcpus_request_mask() call from kvm_make_all_cpus_request_except()
> to avoid handling the special case when 'vcpu_bitmap' is NULL, move the
> code to kvm_make_all_cpus_request_except() itself.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 88 +++++++++++++++++++++++++++------------------
>  1 file changed, 53 insertions(+), 35 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2082aceffbf6..e32ba210025f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -261,50 +261,57 @@ static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
>  	return true;
>  }
>  
> +static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +				  unsigned int req, cpumask_var_t tmp,
> +				  int current_cpu)
> +{
> +	int cpu = vcpu->cpu;

'cpu' doesn't need to be initialized here.  Leaving it uninitialized will also
deter consumption before the READ_ONCE below.

> +
> +	kvm_make_request(req, vcpu);
> +
> +	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
> +		return;
> +
> +	/*
> +	 * tmp can be "unavailable" if cpumasks are allocated off stack as
> +	 * allocation of the mask is deliberately not fatal and is handled by
> +	 * falling back to kicking all online CPUs.
> +	 */
> +	if (!cpumask_available(tmp))
> +		return;
> +
> +	/*
> +	 * Note, the vCPU could get migrated to a different pCPU at any point
> +	 * after kvm_request_needs_ipi(), which could result in sending an IPI
> +	 * to the previous pCPU.  But, that's OK because the purpose of the IPI
> +	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
> +	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
> +	 * after this point is also OK, as the requirement is only that KVM wait
> +	 * for vCPUs that were reading SPTEs _before_ any changes were
> +	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
> +	 */
> +	if (kvm_request_needs_ipi(vcpu, req)) {
> +		cpu = READ_ONCE(vcpu->cpu);
> +		if (cpu != -1 && cpu != current_cpu)
> +			__cpumask_set_cpu(cpu, tmp);
> +	}
> +}
