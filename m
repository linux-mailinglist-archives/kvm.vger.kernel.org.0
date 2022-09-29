Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58285EF5AD
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 14:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiI2Mre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 08:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiI2Mrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 08:47:31 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6F214A7B6
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 05:47:28 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l8so888615wmi.2
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/jd4X0PoFWLfTb4dd6/XSxqnO/9Pw1JPWNu/UEAiCLs=;
        b=UzJR1/QhrpVoNQ6vx8b8o/LAuxQxzwp9Fvojkzml8Jtqh8nvajBpKK7UBqYIbYvB55
         86K9EZmdHroH1k2CUOcxZTMO/a3jHhqvXobkE1fDEd9o8OXL6zVzky7uvkSM0PhpHQ1a
         Qqf1whTb8vvdcnUsTbTiIA6AL7eWfKB6rd0GPjEdKqIKCcuIfrLjjTSH4S99hzLxy/al
         61uMdpcCczvTrIX8qkjyzGpZ6CtcNE7h3/QMpIaUwLNopvTOCFciWhF34bTduFugRHsD
         MIzi+YYzsAvyAdF/vyTThrlnFxt2eM7bsY1kvHexFAGBUVE2LL31LLoK5yuu95Mr92SV
         5oPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/jd4X0PoFWLfTb4dd6/XSxqnO/9Pw1JPWNu/UEAiCLs=;
        b=b/2aeTchjj1kR5fHhBkiKXouAA+vtcfyVrENwkbwetNRA1ktn0RoZ6/WiGoP4YsT0X
         tl8Zp5ROBSkwe7nTfNLSlHXLWJzAhisMr3Ex/6j0jj+a6l4l0+20Z7GGQgFwZTYBl0zT
         kZXEYJ3O3RcLeBI0JfDQ/REiywG0wk0geJWG4Slc/uq5RCALQxGb18QIjBLrxshyQ4Bi
         8sM9mADQjYuAFRbJKHWnyCCeX02nO5mgfdxJYZb9jv8i0UfcuIxWi/gMtSMOn1uptF9E
         cPGkImgQY+Fudw8rXlplQ32rn1ujjQWvHcGSJRUR+W1A4EuBeRQVTkoPnUc8mIPaokMQ
         8fDg==
X-Gm-Message-State: ACrzQf01S2TbbfGfce9cDzQ3WnzG1Tpm27lESNIZBKZGEb7rGHYkga4P
        emBdNUYvuD5Dc15YVMjOsJuWtQ==
X-Google-Smtp-Source: AMsMyM6lFmmDsnTBsYGsUilgz1qsYoqs/Bj1fKUttIQLqYZ6GsaMUyreS6XVuyHNwrGTHpteA4T6cg==
X-Received: by 2002:a05:600c:268f:b0:3b4:acef:34ab with SMTP id 15-20020a05600c268f00b003b4acef34abmr2158749wmt.176.1664455647433;
        Thu, 29 Sep 2022 05:47:27 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id m67-20020a1c2646000000b003a342933727sm4281494wmm.3.2022.09.29.05.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 05:47:26 -0700 (PDT)
Date:   Thu, 29 Sep 2022 13:47:22 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] KVM: arm64: Introduce pKVM hyp VM and vCPU
 state at EL2
Message-ID: <YzWT2lxN/u4y/YHQ@google.com>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 14, 2022 at 09:34:35AM +0100, Will Deacon wrote:
> Hi folks,
> 
> This is v3 of the series previously posted here:
> 
>   Mega-series: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
>   v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/
> 
> There have been some significant changes since v2, including:
> 
> - Removal of unnecessary backpointer linking a hyp vCPU to its hyp VM in
>   favour of container_of()
> 
> - Removing confusing use of 'shadow' at EL2 in favour of 'pkvm_hyp'
>   (although this was much more work than a simple sed expression!)
> 
> - Simplified vm table lookup and removal of redundant table traversal
> 
> - Rework of the hypervisor fixmap to avoid redundant page-table walks
> 
> - Splitting of memory donations required to create a guest so that the
>   requirement for physically-contiguous pages is reduced
> 
> - Fixed a memory leak when the stage-2 pgd is configured with an
>   unsupported size
> 
> - Dropped rework of 'struct hyp_page' as it is not required by this
>   series
> 
> - Improved commit messages
> 
> - Rebased onto v6.0-rc1
> 
> Oliver -- as discussed in person, I've left the owner ID enumeration
> where it is for now since we will need to track the guest *instance* in
> future and so consolidating this into the pgtable code is unlikely to be
> beneficial.
> 
> As with the previous posting, the last patch is marked as RFC because,
> although it plumbs in the shadow state, it is woefully inefficient and
> copies to/from the host state on every vCPU run. Without the last patch,
> the new structures are unused but we move considerably closer to
> isolating guests from the host.
> 
> Cheers,

Tested on silicon, especially that all the donations are recovered on VM
teardown.

Tested-by: Vincent Donnefort <vdonnefort@google.com>

[...]
