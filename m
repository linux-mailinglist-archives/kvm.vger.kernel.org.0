Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6121076D1AB
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 17:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbjHBPTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 11:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbjHBPTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 11:19:24 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1306E35BC
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 08:15:13 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56cf9a86277so83632897b3.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 08:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690989299; x=1691594099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D3LyAPm1LNXozV2RDmYRg8+vON4aRYGJGm2Cl/7lnow=;
        b=XxAyvJEO7IvzK8IYMYZ+WS/J+sA7iCGeO/qEfRRUawL+imOo+d6hkk9tUh5jHbyo4S
         vQGbWg2rHOmo3vI3I8eZsYP1MfuQXLf9tXkE98BN2ljOVo+WO9GF4PRR4fZ1Io64i9rt
         AquHoHU8QjHE3a7+B2EG89Fo8JyzzEgz6ts5yrVgkIAGsaNjBLvqGGKD7sZGTktwjbSp
         PptLKLD7gPBiCT4/8eD89DjQsFM0/odFsivt5nb+kBZwwUbLru7oJo12lu5FUG9wopW7
         KEZDagprbTjCdGzJLcNvieS7/L2XPpLKz8lMisUkuvGdDJn1gDVJWecEDcY1025O5keW
         oHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690989299; x=1691594099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D3LyAPm1LNXozV2RDmYRg8+vON4aRYGJGm2Cl/7lnow=;
        b=Y2OZTMzNekMazCzNwTb8sz8hJqYu8mINdnd2/hFYZV4UvZ6rVZLsTgQPlc2C6VeZuU
         9Rtku/BkiCNV4xgf7bwwVMYC1iup++t4MZhS+nGKd2ESQiPDjKkm88MCSiYb4PNIoJ03
         jdHtWW+jJHZlhnbcOsXR1LGFb+TAxvPcmWCYzMUTQzIMBhHhYR6QTq/ezluJP/oCEAgq
         ZHufkkiqjzsUuqPz6wEJHGIb+xFZt4rQJ4U6zG4VPNbNysdpIJQGUbTc+ul0o0KivZU+
         MocxTbc2Jb2iLqNKYlxnkDzGu5iNZjzGE2I0hcdE9rR9JJ6RYKLGrXr2zuTgNqOpZOlt
         menQ==
X-Gm-Message-State: ABy/qLbdWWo61T39yUkI8RHIRk/HHVZAyD6Em/kqOraP3+WENNSur0i2
        p6hvclSMged9qqCTqNLA4BxRDZ6HPV4=
X-Google-Smtp-Source: APBJJlFe2+t6w0L/91zFwfj+ThLLNQdAgY8DrVCuc0sOklYI7DhI1WhyrzKFNJT/kn6NkoRoeM0hhJO8ghs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac58:0:b0:584:3d8f:a423 with SMTP id
 z24-20020a81ac58000000b005843d8fa423mr143956ywj.8.1690989299390; Wed, 02 Aug
 2023 08:14:59 -0700 (PDT)
Date:   Wed, 2 Aug 2023 08:14:58 -0700
In-Reply-To: <20230802142737.5572-1-wei.w.wang@intel.com>
Mime-Version: 1.0
References: <20230802142737.5572-1-wei.w.wang@intel.com>
Message-ID: <ZMpy8qvKTtAqaDWM@google.com>
Subject: Re: [PATCH v1] KVM: x86/mmu: refactor kvm_tdp_mmu_map
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Wei Wang wrote:
> The implementation of kvm_tdp_mmu_map is a bit long. It essentially does
> three things:
> 1) adjust the leaf entry level (e.g. 4KB, 2MB or 1GB) to map according to
>    the hugepage configurations;
> 2) map the nonleaf entries of the tdp page table; and
> 3) map the target leaf entry.
> 
> Improve the readabiliy by moving the implementation of 2) above into a
> subfunction, kvm_tdp_mmu_map_nonleaf, and removing the unnecessary
> "goto"s. No functional changes intended.

Eh, I prefer the current code from a readability perspective.  I like being able
to see the entire flow, and I especially like that this

		if (iter.level == fault->goal_level)
			goto map_target_level;

very clearly and explicitly captures that reaching the goal leavel means that it's
time to map the target level, whereas IMO this does not, in no small part because
seeing "continue" in a loop makes me think "continue the loop", not "continue on
to the next part of the page fault"

		if (iter->level == fault->goal_level)
			return RET_PF_CONTINUE;

And the existing code follows the patter of the other page fault paths, direct_map()
and FNAME(fetch).  That doesn't necessarily mean that the existing pattern is
"better", but I personally place a lot of value on consistency.

> +/*
> + * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
> + * page tables and SPTEs to translate the faulting guest physical address.
> + */
> +int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> +{
> +	struct tdp_iter iter;
> +	int ret;
> +
> +	kvm_mmu_hugepage_adjust(vcpu, fault);
> +
> +	trace_kvm_mmu_spte_requested(fault);
> +
> +	rcu_read_lock();
> +
> +	ret = kvm_tdp_mmu_map_nonleafs(vcpu, fault, &iter);
> +	if (ret == RET_PF_CONTINUE)
> +		ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);

And I also don't like passing in an uninitialized tdp_iter, and then consuming
it too.

>  
> -retry:
>  	rcu_read_unlock();
>  	return ret;
>  }
> -- 
> 2.27.0
> 
