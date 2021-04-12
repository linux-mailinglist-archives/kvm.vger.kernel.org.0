Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07F35D1D5
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 22:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhDLUNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 16:13:45 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:56289 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhDLUNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 16:13:41 -0400
Received: by mail-wm1-f42.google.com with SMTP id 12so7518863wmf.5;
        Mon, 12 Apr 2021 13:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4FmfCUwos+gYKl460XcLsjtbMsKijKeI0qPY+c7c14Y=;
        b=dSfI5CPQCTO3SThyNvjPtwESpqEv5WIqauKqG89Fcbe+kvtrjAOHpKXq7DPoHkSTgG
         jzRfwCQIBN9GkUmfPnLldrXjJ3DB3+WhSLnSLVrSC03Ne0QaN+LSDEXImHk0Yzx9Jsvq
         bkZ18wBqC1rGYLEbOy2sv8QwnWFj91cSD0ekcxYjk8+GtZ0B90EWzj9tO8CEgaBAUfzP
         CxisIlL2qLh12LnJqtv6AkaBDwxPocnp63S4FD5bK8sqKD7hnGCGJ0/iX+/RCVPkLvy9
         M6/lK7is5u09dRyPZIE1SG4cm8wYHS6ZIq+6PVJL4Nl7REpM8qdZehastTPTBxW2FvD+
         UMQA==
X-Gm-Message-State: AOAM531qGoGT2C9+09x9JtBxK9jYB6PI2/QXQkv6nZN9XYST6YLGUYQE
        oxGxFnXr2mxB00/hcq/w0q4=
X-Google-Smtp-Source: ABdhPJzCaglxrbu5apcnlbJ/rQcVs+ybDa4Y7T6JmRAG9l0cY7Vfvpd2qLq1VLvU0YRYDNWV6fQEGg==
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr703710wmq.43.1618258402068;
        Mon, 12 Apr 2021 13:13:22 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id w7sm19195963wru.74.2021.04.12.13.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 13:13:21 -0700 (PDT)
Date:   Mon, 12 Apr 2021 20:13:19 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM
 registers
Message-ID: <20210412201319.lnohqg6r54p6embb@liuwe-devbox-debian-v2>
References: <cover.1618244920.git.sidcha@amazon.de>
 <da036c786700032b32e68ebece06fd1a6b6bf344.1618244920.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da036c786700032b32e68ebece06fd1a6b6bf344.1618244920.git.sidcha@amazon.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 07:00:16PM +0200, Siddharth Chandrasekaran wrote:
> +
> +static inline void kvm_hv_hypercall_read_xmm(struct kvm_hv_hcall *hc)

Do you really need inline here? The compiler should be smart enough to
inline this function if necessary.

> +{
> +	int reg;
> +
> +	kvm_fpu_get();
> +	for (reg = 0; reg < KVM_HV_HYPERCALL_MAX_XMM_REGISTERS; reg++)
> +		_kvm_read_sse_reg(reg, &hc->xmm[reg]);
> +	kvm_fpu_put();
> +	hc->xmm_dirty = false;

There is no code that sets xmm_dirty to true? What am I missing? I guess
that's because you haven't implemented the hypercalls that need writing
back to guest?

Wei.
