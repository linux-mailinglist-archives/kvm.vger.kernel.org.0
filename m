Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FAF5B0EAF
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 22:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiIGU5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 16:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIGU50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 16:57:26 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC94AD9B9
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 13:57:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m3so5116704pjo.1
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=D3RjQ0ycHa7B/7TKXUqNYyCf5lxoaaHEC6kuhsk3puQ=;
        b=idXPP15TJ7IS7iOdTlcgO/fcRqVHkI5cBChgxzLuZESpPUM6XsRZaDDRlyZt5BL5jA
         NnDWTztN/R3V3J5Z1YZuFWvgmRdivTwGx7C0YTX8U3GFYFDSyYNpSXVfEvPcf6DA88z9
         8kLgdpa7Q4m7CU2vRCW6SLTrKfYckFsVNWOY2H42ZOxS7KeLUcJ7gnpWeG5GGIX+7+U1
         TFWxa2aATU45JtkYWSOrYquLa9hMQdzhjn7oTetBNz+hF31OaKxN3BgxaWlaxzW2WqmT
         wPPWvIoyABeiowfiSdUX1HROmgtTeBq4Kjy6fIipWcmDCYtgsG9s9yt5yytaexuEMaX1
         PSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=D3RjQ0ycHa7B/7TKXUqNYyCf5lxoaaHEC6kuhsk3puQ=;
        b=0oN6212weivh8ibuuE24iU60A2o+aHldcN8f/6T1P3TBHetuGDKX+adL2pmmxpjfEN
         tbGA99oybCRHQla6dQXdLgrlyVtHjyRtRdhUc3ZpQeTeI0OhNsJgTQdddRKoZb2oWI+U
         U9/9mo5OaGDrW+j8m4hdVpiAmGLn/mMWFShtAPxidoc6jb6yvGvSLZQ+MCQjtRGH8fCi
         Z+WrYYaqaWgoCaQep+j4F8FBFrrxaHCHc48OvT6nDtvYBthmWE4xqe7iRafYFJiSMkjK
         cbpEiSO+WJ3FuqTghvn20iGNFOe57f6XuzE5qHOJceiVLrATVkCgUsyMp8ZC6woiYtH6
         kONw==
X-Gm-Message-State: ACgBeo3ZgpYbtmzp5vz822NZmBFcLs4VHy9k6WdA4jsdNgZGoTxK7deO
        oAC6cel5vyHKAoonZ8GQiMPzVA==
X-Google-Smtp-Source: AA6agR4y0YI6Do787IPnCmL86e80gRfI6CK4dTypbO17kG+PMFuHSAWq0jEGksDH17TMqhJ3tnUYKg==
X-Received: by 2002:a17:90b:33c9:b0:200:a0ca:e6c8 with SMTP id lk9-20020a17090b33c900b00200a0cae6c8mr357636pjb.147.1662584244248;
        Wed, 07 Sep 2022 13:57:24 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id v6-20020a1709029a0600b00176a47e5840sm8258330plp.298.2022.09.07.13.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 13:57:22 -0700 (PDT)
Date:   Wed, 7 Sep 2022 13:57:17 -0700
From:   David Matlack <dmatlack@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <YxkFrSmSKdBFEoZp@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-3-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 07:41:20PM +0000, Oliver Upton wrote:
[...]
>  
> +static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +				struct stage2_map_data *data);
> +
>  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  				     kvm_pte_t *ptep,
>  				     struct stage2_map_data *data)
>  {
> -	if (data->anchor)

Should @anchor and @childp be removed from struct stage2_map_data? This
commit removes the only remaining references to them.

> -		return 0;
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
> +	struct kvm_pgtable *pgt = data->mmu->pgt;
> +	int ret;
>  
>  	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
>  		return 0;
>  
> -	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
>  	kvm_clear_pte(ptep);
>  
>  	/*
[...]
>  static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  			     enum kvm_pgtable_walk_flags flag, void * const arg)
> @@ -883,11 +849,9 @@ static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
>  	case KVM_PGTABLE_WALK_LEAF:
>  		return stage2_map_walk_leaf(addr, end, level, ptep, data);
> -	case KVM_PGTABLE_WALK_TABLE_POST:
> -		return stage2_map_walk_table_post(addr, end, level, ptep, data);

kvm_pgtable_stage2_set_owner() still uses stage2_map_walker() with
KVM_PGTABLE_WALK_TABLE_POST.
