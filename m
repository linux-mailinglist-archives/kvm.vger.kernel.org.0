Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6C9417C33
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 22:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348391AbhIXUNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 16:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348379AbhIXUNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 16:13:05 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04AEC061760
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:11:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w8so10904672pgf.5
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 13:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JCRlKcDH1E6heG3hBpGVm+QbWLo+xrDV1HsF80udg08=;
        b=IrAFJNuAC26ADdE8UjANELFb5KUK0PuNkR7iXtvRz1gAnQRdNjDJjLyXFkdAjbeMQQ
         4i685yCPJYyfqqiLy+YtVQoq5zIyc+wy1eRsEACrAyHqpXF+M1EzTdPe43MGS21loDG3
         gkAzUCtUWEA2zabShwLgGQ+le1zV1AEfgl9gm+LIQI3973WWbChSEhmYQBw8SmNo8Sy9
         LUQoePVXEceHv2m6TPnQrT00otS84hoVE6Yah42g0i2SPMqNEAquhWAF5ryZzZj9Oofq
         mPjO9Tdx8rJr5ShBK1NXzeLzD6UVFzOeshWC/0+sxIPHzeB463xBALRm7omoeohrMGe1
         DLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JCRlKcDH1E6heG3hBpGVm+QbWLo+xrDV1HsF80udg08=;
        b=M6ynTbVAIZQomN+LdiOjbdYVH3XtcL++R7s6m8Qwu+O7qKw5VkMW+CsRPI65cF0Mvf
         2M7PfBje9W5Fqo1z4z0Fl0GlqdWGIU+mwRr6G0tfFjO+ocvZPkcXC02nAov1ed3MEfUp
         6HsOHtQMc9EgszWJO7cRxrcQ3y2ZXUERoLqXPfoOU8ZwDYpNOcuefMG76eElJd7+AS78
         aQrhhItIInLQPhwXkKD+NQ9Pf2rprLN7syZqfjlD1Vx+Jqypv2LWb1nAO7SYDt4Kmtwi
         qLhTY1lPGAUz7DaXP0MXdDRZI/AnH9J7KDDaVqsRKK+Ho3MegNAQQcKUAvMeGok3eRSL
         p5VA==
X-Gm-Message-State: AOAM531lqerwWYpSRf3qUzeuaf6gkgo2Dzp2Yx6ccUXbO2SZYcRKFRcD
        GG7keLg6v+yZe65i39gruwIfug==
X-Google-Smtp-Source: ABdhPJz8ogTgggIoyq2QRczNpmqXmGEzPKcS2hG6vNIxoLhTfje6dV+puUE+WnL6e0F4G3TrKkkjbw==
X-Received: by 2002:a62:6587:0:b0:44b:5c4b:fe8c with SMTP id z129-20020a626587000000b0044b5c4bfe8cmr4226313pfb.33.1632514290991;
        Fri, 24 Sep 2021 13:11:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c12sm9490807pfc.161.2021.09.24.13.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 13:11:30 -0700 (PDT)
Date:   Fri, 24 Sep 2021 20:11:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v3 3/4] KVM: SVM: Add support for Hypervisor Feature
 support MSR protocol
Message-ID: <YU4w7pLpwSGDfLLK@google.com>
References: <20210913141345.27175-1-joro@8bytes.org>
 <20210913141345.27175-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913141345.27175-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021, Joerg Roedel wrote:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 524d943f3efc..f019da28ff06 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -542,6 +542,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  #define GHCB_VERSION_MAX	1ULL
>  #define GHCB_VERSION_MIN	1ULL
>  
> +#define GHCB_HV_FT_SUPPORTED	0

I'd prefer to keep these SEV-only defines in sev.c.  I also think it should have
KVM somewhere in the name, a la KVM_SUPPORTED_XCR0, e.g. KVM_SUPPORTED_GHCB_FEATURES?
