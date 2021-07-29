Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9603DAE0E
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 23:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhG2VR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 17:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbhG2VRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 17:17:25 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0715C061798
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 14:17:21 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d1so8531977pll.1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 14:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KIFjrjBCZBNta1aQPIC9IIdRRedMm/calMcivWflCR8=;
        b=IXbpigOGv034+BPFdHTh5nWBpOSuoy+RJOgOOHXXBCs3NudbgzAKsQWHlFKOLDU1zm
         X3CIScRE6+lWU9jgRp2OhY+mwoJN3QHNwhkU57w2jAShQFUvi3yxhPy3hVvC4fnRGHWL
         ze050lryO68WPb0CCLy3Mm1XvF60JTOT+dgMSey7555btM4cl+f3R4rjJ7FplQuFgKWc
         F139FIoilaUAJwj5zF8BZE/e1teHbBn7S6vnv2O0VSf8jY1tfB1XLbBYelv1yaBk/U/R
         GL31TAf8DzIPSteeN6fa7Nli2hABDXDebGEz2vIVf0r8QCWuch+e0wFEcGhVTTwam2ID
         jgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KIFjrjBCZBNta1aQPIC9IIdRRedMm/calMcivWflCR8=;
        b=tNoi2ADhrBQAxWW8d4PvQPKZZnZeyYwftVucTAjx3uxIaj6ZvYey0b9QMi96Jwt/+o
         XlqvnhChjTXzNT4CcDgIutN8E42NmXQNOxpQHAW9w7ktPUXqnNLdpswT36n9UK4vPQ7+
         iEUYP0IZvo99C8yzVzuxQCFVi6ej5JzmwLgfzi7HVpd4fUlrJIYmUwHqm8FvMJ3SmALi
         RPqXam+bVtxQzu38oe+5Ir5LTpY8PJxYFyI6RnlHB813fugRm3yLkhDB3C9yLpz58xcI
         PHJZ6vLvaGANmEbHt3C7XQqe4KXgtJbrKzap/zGX496cS7TeC1KfIINqZYF2S3nN2t0W
         2MCQ==
X-Gm-Message-State: AOAM530lF8iXYPmYUmkg4YPEPmeGcTwKToV6dCQG6VpmhvJSW8kd4AFE
        ynHTgu5x0HUuLBYKjBJkSovGmQ==
X-Google-Smtp-Source: ABdhPJwiMHGtwAApoWJJub1wHV/rXIFjlReZXf08aJmnLVL/GQq0q33W99afFvy9vCUJtjQUu9zjHQ==
X-Received: by 2002:a17:902:6b4b:b029:12b:f96f:dc03 with SMTP id g11-20020a1709026b4bb029012bf96fdc03mr6512439plt.14.1627593441149;
        Thu, 29 Jul 2021 14:17:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f15sm4876552pgv.92.2021.07.29.14.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:17:20 -0700 (PDT)
Date:   Thu, 29 Jul 2021 21:17:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V3] KVM, SEV: Refactor out function for unregistering
 encrypted regions
Message-ID: <YQMa3IDQK+DIJiOY@google.com>
References: <20210726195015.2106033-1-pgonda@google.com>
 <20210726195015.2106033-2-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726195015.2106033-2-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prefer "KVM: SVM:" or "KVM: SEV:" in the shortlog, i.e. colon instead of comma
after KVM.

On Mon, Jul 26, 2021, Peter Gonda wrote:
> Factor out helper function for freeing the encrypted region list.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b59c464bcdfa..6cb61d36fd5e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1775,11 +1775,25 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> +static void unregister_enc_regions(struct kvm *kvm,
> +					    struct list_head *mem_regions)

Indentation is wonky.  There's an extra tab and an extra space.

> +{
> +	struct enc_region *pos, *q;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	if (list_empty(mem_regions))
> +		return;
> +
> +	list_for_each_entry_safe(pos, q, mem_regions, list) {
> +		__unregister_enc_region_locked(kvm, pos);
> +		cond_resched();
> +	}
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	struct list_head *head = &sev->regions_list;
> -	struct list_head *pos, *q;
>  
>  	if (!sev_guest(kvm))
>  		return;
> @@ -1803,13 +1817,7 @@ void sev_vm_destroy(struct kvm *kvm)
>  	 * if userspace was terminated before unregistering the memory regions
>  	 * then lets unpin all the registered memory.
>  	 */
> -	if (!list_empty(head)) {
> -		list_for_each_safe(pos, q, head) {
> -			__unregister_enc_region_locked(kvm,
> -				list_entry(pos, struct enc_region, list));
> -			cond_resched();
> -		}
> -	}
> +	unregister_enc_regions(kvm, &sev->regions_list);
>  
>  	mutex_unlock(&kvm->lock);

Is there any reason for taking kvm->lock in this path?  The VM is being destroyed,
there should be no other references, i.e. this is the only task that can be doing
anything with @kvm.

The lock is harmless, it just always gives me pause to see the cond_resched()
while holding kvm->lock.

> -- 
> 2.32.0.432.gabb21c7263-goog
> 
