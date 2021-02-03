Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE3F30D05B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 01:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhBCAiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 19:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhBCAiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 19:38:50 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91004C0613D6
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 16:38:10 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g15so16070078pgu.9
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 16:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Sw0Vvtzcz6Tp5ASQ/gatuKuqoHGAQQtnplIYIuWXPQ=;
        b=VV7MMgCIdgHXeVw67dyU/de0/CuHMGaEY/0AIDC8R+C8K+ThhEcNLAHzEYCzHvLMbG
         PgfDeJt1bk5k7tZx9Sz2Te+YAm7wliwXDlmlXwym97EXWelAPbnVXbESIEnOpzOTXze1
         mOfwvY6SDg2hQpGFJZqbZPo+0N1EkHMSkV6uFik/nRhcUVLBlGCLc9IgW5bLP/BzkJzU
         KD0RZqj5itNMuHlJ2MyAlAANswZBOEQjVICsjxeBn6rLlbzdNLZMI1wcdBLiUTgjmOA5
         cahRGd6RArPrAERuLxhsnhkxX8PyyUzl/W+dmOXMpAjmebfrpMKwyPv+xj48sk8r2a70
         uGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Sw0Vvtzcz6Tp5ASQ/gatuKuqoHGAQQtnplIYIuWXPQ=;
        b=f8r3DSj/U+0dV7zZ6/gelo5ApKXEbbZyz9aoYR0uS9OdMAJ8VbC2qCs2P3X1q9lCDB
         5F9WnIGduw2q9FpAny7T/Yfuka+8opO6a54Zitrmd2ETslc+WwLDL8Ng4+wraeTsRJNw
         b0F//c6wjddiL54+XZTPZTjbhTcY0l3iQ8IGrRjcDSubCviM8BU6D3SybxFRgCuMDU13
         bz2FkFIAp9wnxV/a2eVZvvksNke9L/QreY6QYuVCBZFdnMthGdU+Ofa0dT/W6tG0NVt3
         bh9qFOu5eXXJFG8/Ld8V8noCxviG2yXVEf9lrxfiC1MOVnwTCoMsFVE7CE6+tuFk2XbA
         EIlA==
X-Gm-Message-State: AOAM533npXE5BvVYcjQ+g1hKETTQaC4LihCj6lSVbitOSl+hDq6Kfgzu
        3nLSszgl/W+8MommkpdrvXSXZQ==
X-Google-Smtp-Source: ABdhPJxElBeGhuLbpW5OZIWAajiwcgq4/Chf7fDUQUUmUBYq2MeDNxVh46dvwmhvJSPuwh++7AUV4w==
X-Received: by 2002:a63:f20e:: with SMTP id v14mr740665pgh.436.1612312689611;
        Tue, 02 Feb 2021 16:38:09 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id p1sm155681pfn.21.2021.02.02.16.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 16:38:08 -0800 (PST)
Date:   Tue, 2 Feb 2021 16:38:02 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <YBnwaiy8L/O0PCrR@google.com>
References: <20210202190126.2185715-1-michael.roth@amd.com>
 <20210202190126.2185715-2-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202190126.2185715-2-michael.roth@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One quick comment while it's on my mind, I'll give this a proper gander tomorrow.

On Tue, Feb 02, 2021, Michael Roth wrote:
> diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
> index 0c8377aee52c..c2a05f56c8e4 100644
> --- a/arch/x86/kvm/svm/svm_ops.h
> +++ b/arch/x86/kvm/svm/svm_ops.h
> @@ -56,4 +56,9 @@ static inline void vmsave(hpa_t pa)
>  	svm_asm1(vmsave, "a" (pa), "memory");
>  }
>  
> +static inline void vmload(hpa_t pa)

This needs to be 'unsigned long', using 'hpa_t' in vmsave() is wrong as the
instructions consume rAX based on effective address.  I wrote the function
comment for the vmsave() fix so that it applies to both VMSAVE and VMLOAD,
so this can be a simple fixup on application (assuming v5 isn't needed for
other reasons).

https://lkml.kernel.org/r/20210202223416.2702336-1-seanjc@google.com

> +{
> +	svm_asm1(vmload, "a" (pa), "memory");
> +}
> +
>  #endif /* __KVM_X86_SVM_OPS_H */
> -- 
> 2.25.1
> 
