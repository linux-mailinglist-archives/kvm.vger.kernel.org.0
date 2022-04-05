Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F064B4F4556
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 00:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbiDEOtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388989AbiDEOlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 10:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E9F612B74F
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649164635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NPr7NyzPsM6lb9uL4EUAQIbJ/AzbEssi4MJbl6X0Xkw=;
        b=UqeeLfX7gfRUzka8+FoH32CbzyfuuYX45qUx25gtlpUcFc4QHwHDxyxRYo1A5oDXZFy5xh
        lAXBIrEJBKgg9mukK2wqjMehJ53/as0AZ8ghdpS6epyXTOWHPV87ynPsy/3orfXIKUoefH
        s9+0n9HfWl52A2G6/ARNlxAT8mxznes=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-bRZzzKmKPqqgLJNiQL85BA-1; Tue, 05 Apr 2022 09:17:12 -0400
X-MC-Unique: bRZzzKmKPqqgLJNiQL85BA-1
Received: by mail-wr1-f69.google.com with SMTP id z16-20020adff1d0000000b001ef7dc78b23so2450547wro.12
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NPr7NyzPsM6lb9uL4EUAQIbJ/AzbEssi4MJbl6X0Xkw=;
        b=x0VSmS4BeZzlp+dsLRF/8IVh+FJeQvfhRz6ZmQCNWSHwpouOTZHMYRUX1ewAPI3Pux
         dg702Mgj+k6+EXUYwO3o6c6tbO7ZuZ4V5JpzX6gIdjxFGt829Rax2mivK8vUHjmteVOF
         GTEFnFdcXfyRWTPbQvtZFIUSwVxZQ4WmvwIHGKORtTJLu0sJhqtEENcYqKpqk/P755Cq
         Kf2aGf1y96vvOFqu8MNd6/bm2CrgivHKDul8cQOJQdz77qb3bq8m8ptkKz8Zw3Vr5Zn2
         WfuJvWnlXAOJWKG5Ezb/Kpoq0Hd3DItUKTlAR8G6f7O9feIBJReb/H1+2HO1C/xh2a0b
         qbzA==
X-Gm-Message-State: AOAM531tmJKAh0WBPCbdC/bV7oqkM3c6p9XfElMAgnRPGSsfW1+MbHL0
        3qx16Oze4bsxp9S9P/o6eyH10kdUk88qQjbDicicRZWY7qW4FvDVKiYTcwQog50gsEI+D4EmA/U
        caaG5Nbne45DR
X-Received: by 2002:a7b:c0c9:0:b0:38e:7d65:6e7f with SMTP id s9-20020a7bc0c9000000b0038e7d656e7fmr3069455wmh.168.1649164631098;
        Tue, 05 Apr 2022 06:17:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwO1qwBZcVBSXGotEJB514xkNDND8cMVp2SwXHyhGdkT8SjDU5/40/xNvyAtW7gDpIWAk6dQQ==
X-Received: by 2002:a7b:c0c9:0:b0:38e:7d65:6e7f with SMTP id s9-20020a7bc0c9000000b0038e7d656e7fmr3069438wmh.168.1649164630849;
        Tue, 05 Apr 2022 06:17:10 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm2115805wmn.46.2022.04.05.06.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:17:10 -0700 (PDT)
Message-ID: <68e1fd5f-d58b-695b-0fc7-bdc3e5491de7@redhat.com>
Date:   Tue, 5 Apr 2022 15:17:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 036/104] KVM: x86/mmu: Explicitly check for MMIO
 spte in fast page fault
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b0e81b4a4abfbe8bd6d43e4b1c0349a79517dfb0.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <b0e81b4a4abfbe8bd6d43e4b1c0349a79517dfb0.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Explicitly check for an MMIO spte in the fast page fault flow.  TDX will
> use a not-present entry for MMIO sptes, which can be mistaken for an
> access-tracked spte since both have SPTE_SPECIAL_MASK set.
> 
> The fast page fault handles the case of changing access bits without
> obtaining mmu_lock.  For example, clear write protect bit for dirty page
> tracking.  MMIO emulation is handled in a slow path.  So it doesn't affect

"MMIO sptes are handled in handle_mmio_page_fault for non-TDX VMs, so 
this patch does not affect them.  TDX will handle MMIO emulation through 
a hypercall instead".

For this comment, it is not necessary to talk about the slow path, since 
that is just where MMIO sptes are installed.  If the slow path is 
reached, fast_page_fault must not have seen is_mmio_spte(spte).

> @@ -3167,7 +3167,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			break;
>   
>   		sp = sptep_to_sp(sptep);
> -		if (!is_last_spte(spte, sp->role.level))
> +		if (!is_last_spte(spte, sp->role.level) || is_mmio_spte(spte))
>   			break;
>   
>   		/*

I would include the check a couple lines before:

	if (!is_shadow_present_pte(spte) || is_mmio_spte(spte))

This matches what is in the commit message: the problem is that MMIO 
SPTEs are present in the TDX case, so you need to check them even if 
is_shadow_present_pte(spte) returns true.

Paolo

