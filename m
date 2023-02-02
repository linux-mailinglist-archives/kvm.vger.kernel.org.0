Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86846872EE
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 02:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBBBWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 20:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBBBWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 20:22:45 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C8469505
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 17:22:44 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id be8so342702plb.7
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 17:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzM45qHBq96ZJ2hSF+lU4ajTBxX+YKY5YAqTHcRzYxU=;
        b=aBL9GPUmNZ5oHQFQLCk7hVS9bM5e5pTXr0B1pavSVCpwp+/F7mPmkT+5BzHqonO9jR
         EXCirjGqOoc/NRU6cNJ+xY1a1iyK3NdHf5tjpEzeapqMGgsMlBJTdiFcPeSpJDYJxP9u
         tQ+7gy4xN4RGsf355TkM0gS+I8gNlPtUiQmESqD4YhiofyU6lnKqrBd5xT9uaqhxaiLm
         RkqEUhP5G/BmXnxbxDtGSBdRpksrtoHpEIPjxTJLVLd46Pk9X6Tetx34cK6FJoImE1Hy
         k7HWkUP//Ou8sMGOHMHrgIsfEYbZVTqzD8eme33Gp3mn6Ak/NQGv/oBQR7lNLvkdwkwU
         HzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzM45qHBq96ZJ2hSF+lU4ajTBxX+YKY5YAqTHcRzYxU=;
        b=gChKsWMfnPIwsf4zRHgutpjxgrzX2cC8KeZaxVxiTgvtn/WNBcZGPO3iUyrwvhNR/i
         rF39CWI7gxn6Pb5cboqDq5z4iviVrm1kHut6M6F3vQJbJz6HE0/Wmyd5NrZJjZ4vUxhh
         kCXHeGvkk6AgDFX+rzOErg5aTE3jb5Cr03ERf0VG8VJpvUiIIoeT+kTiC2+huGSO9MV2
         B6uOWKZI+FITSE7FCqnHGMNTtpTn/gGZEF6tG6SMV3ok64+kf2IOIW1G6BmRE7NiNZw5
         GZyhKVnfQwKFw80WOEJDd3vFRSshlCC7wxWhVfdfELeVdijetBxf0+2YpQj40FCKCHq+
         AZpw==
X-Gm-Message-State: AO0yUKUjirArLZPVyzFmW+KWV7kvpiLnrPiiYBOqnXOg2rJI+I7kk6u7
        PhhytiuJk4Rmqn6JYWE3yZsJtqjAbSjVdlh/VJk=
X-Google-Smtp-Source: AK7set+cTqQErNAFPxfmxIZZzBXxv+c8FSNj7q9ODcQP/iIeI335XeTW2hnZSaBIJ8lj359j1wHyKg==
X-Received: by 2002:a17:902:c945:b0:198:af50:e4e7 with SMTP id i5-20020a170902c94500b00198af50e4e7mr143476pla.13.1675300963609;
        Wed, 01 Feb 2023 17:22:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s17-20020a056a00195100b00593ece2046asm4256930pfk.51.2023.02.01.17.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 17:22:43 -0800 (PST)
Date:   Thu, 2 Feb 2023 01:22:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] kvm: x86/mmu: Use kvm_mmu_invalidate_gva() in
 nested_ept_invalidate_addr()
Message-ID: <Y9sQXwQwQxi2Dcr8@google.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
 <20230105095848.6061-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105095848.6061-4-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Use kvm_mmu_invalidate_gva() instead open calls to mmu->invlpg().
> 
> No functional change intended.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c    | 1 +
>  arch/x86/kvm/vmx/nested.c | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b0e7ac6d4e88..ffef9fe0c853 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5719,6 +5719,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  		    VALID_PAGE(mmu->prev_roots[i].hpa))
>  			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
>  }
> +EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
>  
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
>  {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 557b9c468734..daf3138bafd1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -358,6 +358,7 @@ static bool nested_ept_root_matches(hpa_t root_hpa, u64 root_eptp, u64 eptp)
>  static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
>  				       gpa_t addr)
>  {
> +	ulong roots_to_invalidate = 0;

Same thing here.
