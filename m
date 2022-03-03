Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68A4CC4B1
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiCCSJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiCCSJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:09:37 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9F6E0A27
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:08:51 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t14so5235293pgr.3
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BTYLb9HBGbhFly2fPG2qXLCkv8yykoYepo3XTTdlldU=;
        b=hMNEn/GbmsMUtg4oxmhbIXRQPVu7NbT/WnAC+/jn+WiRKSM7xs9ti7I+wV1P4R2KS6
         WyVaAQBYn8vI35ur6gZJAJaQMN+WKs4MtDZsOsg3sgrnOB+a+83MvWTlsNKCDHwTbVNs
         AuNKx6JVDpCoQvMOaz4KETYS9boMeymCUkhtZW9QSbQ3vdqakdm//NbGnRRYgYv3Z0lq
         puUAUv3NNNaHd8SeCesRLc/m6vEaOpcbH3NUoLG6sfuyIVCzVUldPEUSFQcO3DYJfflj
         QgUdSyRbbMGqeQvDzGYp75lw3LygYoCXG/K8Uc9iyIT3sBJVfDqdm7XqMMwDJnTAqIMZ
         jMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BTYLb9HBGbhFly2fPG2qXLCkv8yykoYepo3XTTdlldU=;
        b=E+X8JQ9CKTdGvRnp4K9hrm8DztspmghVCdlbwHn2PuV7Ik1R3f6K/CNWDVN9KvhJ8/
         4+kwPQ9oYEik0DZ52gy8iQVl0Mtn1pWbmWN9/UTrSozW4PrmkeQdeOOWNlDtmvWDnlKw
         aJrZeUglX6qEKGPK3KHOy5O3tqQRQ5CNpIqGPhqSxo6SexGdTysuC6laa1nHBG273dko
         rm8tQQwlRQwkb9bEcqFhErYu/T6Xk3v820y5jd0k6rCwo46ZH/8C72GFBIAvwnPDkQBG
         kmQJ+ttD7qaEksrfD8Y3zCu3fYJKMTdV2wtyeU5c4A2U0Io8oGMV8fdN9j/V+I2jRkLZ
         0ftw==
X-Gm-Message-State: AOAM53166c+Asrzphtd+YxHoGt0j+fG+n9/tj13W3hur5NZpafEIIO+s
        d+TzPoBqcjvNcNILL03YwGSQiw==
X-Google-Smtp-Source: ABdhPJwI4iCgO48anf6OIfRvqNpdDFYISkBjKns/9buSsWxjNWb2URbn2Tq6d3Jp3jtY1wj0NOs/Lg==
X-Received: by 2002:a63:1c14:0:b0:36b:28ef:f8ce with SMTP id c20-20020a631c14000000b0036b28eff8cemr31681899pgc.96.1646330930904;
        Thu, 03 Mar 2022 10:08:50 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id 124-20020a621682000000b004f6a2e59a4dsm963540pfw.121.2022.03.03.10.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:08:50 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:08:47 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 08/28] KVM: x86/mmu: Batch TLB flushes from TDP MMU
 for MMU notifier change_spte
Message-ID: <YiEELzrSymLY05zm@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-9-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Batch TLB flushes (with other MMUs) when handling ->change_spte()
> notifications in the TDP MMU.  The MMU notifier path in question doesn't
> allow yielding and correcty flushes before dropping mmu_lock.
nit: correctly
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 848448b65703..634a2838e117 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1203,13 +1203,12 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   */
>  bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -	bool flush = kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
> -
> -	/* FIXME: return 'flush' instead of flushing here. */
> -	if (flush)
> -		kvm_flush_remote_tlbs_with_address(kvm, range->start, 1);
> -
> -	return false;
> +	/*
> +	 * No need to handle the remote TLB flush under RCU protection, the
> +	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
> +	 * shadow page.  See the WARN on pfn_changed in __handle_changed_spte().
> +	 */
> +	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
>  }
>  
>  /*
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
