Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E105F3648
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJCT2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJCT2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:28:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD4444577
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:28:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lx7so10766648pjb.0
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 12:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=41feXEgHrBX4E52VYuExyAcYVaTnWKu7S8Hqe2ljK14=;
        b=DZ4sOXFhtUL3xoyg7X8YcDZT/TKW26hxBF0aUw80QG/zz9Emp7ddzriYVhwIuRM+tH
         Riu/kHgQZlxVDiCmfjK3/tkgNe/2tFnn76vXU7bIFOaU0pDNK53f4GAZVHuthCVHU5mW
         7PQgOf8PNyp7w8C9quDBgY8HHRVNzyAgY4MPoT+uFHJ6uwdDhNl66VZCFQbBG62pgoTw
         BT2WAYVBul+oGrnNulEXhvpgiR1mg8t6618U2D98R/MbtdRXlMoR51bO4KPRcNwrEm6u
         5wN+PTN4SIqZA2mejV869X133UioZDNC7pjjG99+LotFyznKdbzETHrd4NyU3CBMfF6p
         rywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=41feXEgHrBX4E52VYuExyAcYVaTnWKu7S8Hqe2ljK14=;
        b=PBuBiVQpu3DBm/UgMynHD5o8HeM+ir5/VpazzIIhk9hcCLVj8+dlwGgQB1tdfUFgVm
         kJ95Iiy8qMvCewuG9bYOip/PcxbWVohhOK680nmv96YHGQl96fASjSJBdahH7Q/0w5JA
         28pA0liTpKGXKUL/HVpyiU1IGk7GzWJbmbTmYxjAhW1N1FvXSEsaOty67dRnOIPDrwue
         C1SKaNBxzkjgCjNepzWjZ6aukci58NpS8T9Fzr/1qI0ik653xP5NA3HR0geLF0ByUtCT
         NdWPgQS9/vhMnPUTLA7mV1JspM8+eD1Sr7jmObIVFRZvo/ZJRzQuEbNhthDt07kn43tM
         q62g==
X-Gm-Message-State: ACrzQf3LfNT9zCswhE0dH4jMNw7YaQwPJ++JJ50XQtyK4BRJmNkvzulL
        XEGfNy/M7+htqOtioQYb6lA=
X-Google-Smtp-Source: AMsMyM4dHPN5q8GSYT+ItkbsaDnO7UVa+GEQxmF0BMpk97km+qFsBqXa3K+u/0LhiIW1sFIMbgDtSA==
X-Received: by 2002:a17:90b:1b10:b0:200:934b:741f with SMTP id nu16-20020a17090b1b1000b00200934b741fmr13985497pjb.212.1664825318235;
        Mon, 03 Oct 2022 12:28:38 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id l8-20020a170902f68800b0017824e7065fsm1256580plg.180.2022.10.03.12.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:28:37 -0700 (PDT)
Date:   Mon, 3 Oct 2022 12:28:36 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 09/10] KVM: x86/mmu: Stop needlessly making MMU pages
 available for TDP MMU faults
Message-ID: <20221003192836.GG2414580@ls.amr.corp.intel.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-10-dmatlack@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 10:35:45AM -0700,
David Matlack <dmatlack@google.com> wrote:

> Stop calling make_mmu_pages_available() when handling TDP MMU faults.
> The TDP MMU does not participate in the "available MMU pages" tracking
> and limiting so calling this function is unnecessary work when handling
> TDP MMU faults.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b36f351138f7..4ad70fa371df 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4343,10 +4343,6 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  	if (is_page_fault_stale(vcpu, fault))
>  		goto out_unlock;
>  
> -	r = make_mmu_pages_available(vcpu);
> -	if (r)
> -		goto out_unlock;
> -
>  	r = kvm_tdp_mmu_map(vcpu, fault);
>  
>  out_unlock:
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
