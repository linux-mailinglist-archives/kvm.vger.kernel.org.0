Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF13C64E7
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 22:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhGLUZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 16:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhGLUZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 16:25:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0134FC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:23:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id me13-20020a17090b17cdb0290173bac8b9c9so7026pjb.3
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 13:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3qk73zCUaD3AcB+TQJ/HzDOBVDKCjOdwLieI4Qmjkq8=;
        b=lFfYuqaAMzhKn5XJWBDp5PJyVaFbSu6970vXQwmZtpIqztSmLdD/e33UCOeZA5NNny
         P5Xd+OAdhaV/4PKYft0xOjAGcqos3BqQFjfg6T8vtoUsomI3Gt76jZI3gyTMRSMyDnmY
         ss/KYzpGpxFxicG4sHF7RV5WztNVkATrTl3BsRBlYo0l/7w//Em9bCXGobRuJpOrvNg0
         ZCh/hHmRRLxijtZ8duq18M1XhNc/MadWIkMARDdyaAbIcqIZqvI5SDDm3pNjp1ZOgnjK
         w3P0a4+v7/FV6X+mvqzq2MRXAcgM7g5bdhTvtnfMxPjy5clbCvClDKEh0i6yza60hAGu
         WVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3qk73zCUaD3AcB+TQJ/HzDOBVDKCjOdwLieI4Qmjkq8=;
        b=MwyUBIx5b6M17g5OekLz8GIz2wPzvbyn/cp8lnCypp8mKCML4DswVbyYtAtPu+tcLJ
         DPO+7sNcbM7QPxizEwWtshWXiMnou4f39zjUlu6rKT9W/9puAnXElPxVf6f/Zkd8H9AI
         pLVopYH5udCT2/K8upriMnjJtNaYCcJx4XxkdiVwX8y7oZ4D05Vb0hzZOW6/+2BJOswf
         z4jVXAIoWl0rjX1XPtug10UhKGtKYZeKpnXsnnGYAMObTmKhJMo21YuBbXXEJP22wgUj
         Qa6yoSuGNmADJ5smEbKQhlEdVN1Et1bUoQ2yE4IlthbvcpJO71YoZl9N59umDcaBKbfg
         o69A==
X-Gm-Message-State: AOAM533X0ZvsO4x08x1QHUh99YtJ//fy4ZXGmZKjsi42kKnDgQSDTyyf
        yE6Xk2O6V72L1kY835Y8VjUc5rQ6gZUBpQ==
X-Google-Smtp-Source: ABdhPJyDghoKYlMXnLaPVltjEWeRgLDtX6crzcDMdUGF/jV1n2BiYw0KV2yJvCFP3Xsz9W48WsBrGA==
X-Received: by 2002:a17:90a:474f:: with SMTP id y15mr729211pjg.2.1626121389409;
        Mon, 12 Jul 2021 13:23:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 2sm10750757pgh.63.2021.07.12.13.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 13:23:08 -0700 (PDT)
Date:   Mon, 12 Jul 2021 20:23:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Make
 walk_shadow_page_lockless_{begin,end} interoperate with the TDP MMU
Message-ID: <YOykqZGg1eXTxPOi@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630214802.1902448-4-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 30, 2021, David Matlack wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index caac4ddb46df..c6fa8d00bf9f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1513,12 +1513,24 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  	return spte_set;
>  }
>  
> +void kvm_tdp_mmu_walk_lockless_begin(void)
> +{
> +	rcu_read_lock();
> +}
> +
> +void kvm_tdp_mmu_walk_lockless_end(void)
> +{
> +	rcu_read_unlock();
> +}

I vote to make these static inlines.  They're nops in a non-debug build, and it's
not like it's a secret that the TDP MMU relies on RCU to protect its page tables.
