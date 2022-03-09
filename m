Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1E374D31E5
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 16:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiCIPjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 10:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiCIPjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 10:39:43 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF24DE2E0
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 07:38:44 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z15so2623650pfe.7
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 07:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4858y4BMWr2gJcJLKJUNVqF74EyV3FrLTR/2w1+cBpk=;
        b=sha44opMxj3RxRy1WwA1JpkDf55Ph6UGxBENd7g/pHUz3RNkNLhQ696ctcWQKKbrCc
         Ph5/P5qnN7wFMoI09zqXLC0cBv1lXc3P4fZsszT4Kp0r4TNhJxHha+rniMnjlIPuKKHx
         r4Yg9mKzb9Q3ZfdsUlHzMXHF+pamX86bhZKrWDMgJ+ahtjUNz2m17oIEovvEiIJalukY
         LK7uwa3f9j8WmjH/omLlKjkabB6JznX4XQ9RSwCI8lCtQw3R9LmgjSlZ1iiC5LllmjLK
         nMGeMg5BPMpIrELoVl+NaA5oYAL5lXKIcJIsBb5XERc9j0fCDKQyapApL9kN5DLLQVsU
         JnvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4858y4BMWr2gJcJLKJUNVqF74EyV3FrLTR/2w1+cBpk=;
        b=1UPkcFk4FKyNLyC00ZU7kpQafbrIu2M/Aj+UFsC+za28gpQ6W0WNDk6uDxD67Uzb8F
         mOvkBQdk26ajSogkB+Y6afP2kDce2uzYnoongWD0+2J2HRSortsLNebIonuaj8pUG5oc
         8h6JjrIMeCLBJZyJ5DBna+dnOdhY8UlA+U+ZQkoYQwkZBO29B5MdkDLqjRdncPuFmv25
         s7lpnDKcMDt+3r2qHYjjJuPoNVzLYyNUu6B67DjxPo647DVnFzgg/n0teHBxUjR8/wki
         GbH1W/tWUwPrZP4GaImub7wbYVKx/RhLDE16/6VXjuRBq9QE1hHZziEzajcefYmt0mOm
         zLew==
X-Gm-Message-State: AOAM533inIdoEed0F0LDbd32c/85RheLi4NFi1G7u48d3MhkItP56LIK
        GwZAQ7ZU5+RT6Hv/FqWumcSRIg==
X-Google-Smtp-Source: ABdhPJxDX3EJ+7XUkClySg12OgQg8R10EgeeO15wlTSLQwyFzAFoksxH+R/yN5vzdAt8k6VHTx6ayA==
X-Received: by 2002:a63:ef03:0:b0:374:7286:14d0 with SMTP id u3-20020a63ef03000000b00374728614d0mr248206pgh.552.1646840323625;
        Wed, 09 Mar 2022 07:38:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e6-20020a63aa06000000b00380c8bed5a6sm1226627pgf.46.2022.03.09.07.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 07:38:42 -0800 (PST)
Date:   Wed, 9 Mar 2022 15:38:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 08/25] KVM: x86/mmu: split cpu_mode from mmu_role
Message-ID: <YijJ/3frxdLAsuKV@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-9-pbonzini@redhat.com>
 <YiemuYKEFjqFvDlL@google.com>
 <175b89f0-14a6-2309-041f-69314d9f191a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175b89f0-14a6-2309-041f-69314d9f191a@redhat.com>
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

On Wed, Mar 09, 2022, Paolo Bonzini wrote:
> On 3/8/22 19:55, Sean Christopherson wrote:
> > >   static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
> > > -				    const struct kvm_mmu_role_regs *regs,
> > > -				    union kvm_mmu_role new_role)
> > > +				    union kvm_mmu_role cpu_mode,
> > Can you give all helpers this treatment (rename "role" => "cpu_mode")?  I got
> > tripped up a few times reading patches because the ones where it wasn't necessary,
> > i.e. where there's only a single kvm_mmu_role paramenter, were left as-is.
> > 
> > I think kvm_calc_shadow_npt_root_page_role() and kvm_calc_shadow_mmu_root_page_role()
> > are the only offenders.
> 
> These take struct kvm_mmu_role_regs; they *return* union kvm_mmu_role but
> that is changed later in the series to the base part only.

Doh, sorry, a later patch is what confused me.  Lost track of things when moving
around in the series.

Patch 12, "KVM: x86/mmu: cleanup computation of MMU roles for shadow paging", is
where we end up with

	static union kvm_mmu_role
	kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
					   union kvm_mmu_role role)
	{
		if (!role.ext.efer_lma)
			role.base.level = PT32E_ROOT_LEVEL;
		else if (role.ext.cr4_la57)
			role.base.level = PT64_ROOT_5LEVEL;
		else
			role.base.level = PT64_ROOT_4LEVEL;

		return role;
	}

Can we instead tweak that patch to make it and kvm_calc_shadow_npt_root_page_role() be

	static union kvm_mmu_role
	kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
					union kvm_mmu_role cpu_role)
	{
		union kvm_mmu_role root_role = cpu_role;

		if (!cpu_role.ext.efer_lma)
			root_role.base.level = PT32E_ROOT_LEVEL;
		else if (cpu_role.ext.cr4_la57)
			root_role.base.level = PT64_ROOT_5LEVEL;
		else
			root_role.base.level = PT64_ROOT_4LEVEL;

		return root_role;
	}

This is effectively the same feedback I gave in Patch 15[*], I messed up when
trying to track back where the "union kvm_mmu_role role" param was introduced.

https://lore.kernel.org/all/YieoXYBFyo9pZhhX@google.com
