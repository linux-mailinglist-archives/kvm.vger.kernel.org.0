Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8CC6872E8
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 02:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjBBBVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 20:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjBBBVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 20:21:44 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E268106
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 17:21:43 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id m13so316015plx.13
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 17:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=753ouVD8XxqzOxsXpdcU2aCNNLKmWT+9btm+ox4R9c8=;
        b=LcPXvAIEkRshnD+hGItasRTF5vGvBYIQV+O4TDeqs4kipFT9VlokcfDFrVwYKLifJ9
         ocLA7nkuoHyMCO6qqLsk58p9/sRJt3eau+otUdnbu+U57ZmW6bk5QnVwgeU16xjmqdUQ
         p8zsBkKjOVFDQ4LZg12BtJB48D7phuxcF+24ILslGPxrfARMgvJN8FF3LUeJE49yl9RB
         LwjD75Nm2YLcPuHCTjcxaVWVILorDsy1OK+yg2cbbnoWdil0OmlP0c497F47hXtSSuN1
         zLfBkoSeOTNNF9JGjWiBW2/Kp90SjysN6hFotRtaByl39a8iY4utUHH8B8P9Ni7H6PP+
         VaSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=753ouVD8XxqzOxsXpdcU2aCNNLKmWT+9btm+ox4R9c8=;
        b=qa6OPHqAklSMN9zNhGvoD/F17yHM0d8yVYjnh3KukceJhT7Ie0wxNxU9Ad4sjfBPnA
         C4dsMH6US26Fp7oJ2MFdOA0xHK/iy/hCU9N2Sdn6hmWC8BQ6oe+w7BzgX/3K16wg5yoa
         gorqKHdrHAxtBcq4Cj8b/WpEXphsTjKjYptTKISQTomrEi+aJZxQLIN9meaZZiACj7PU
         D9ACIcIRsX00mR8z5bEkpbAwAc+FYlg9u+LSeGveUKJDABLqDVqID2HfD5XN7y+sdilZ
         smaCuG75P2NZgsL35iCR3TJY0ISarvcOTAfwNS0ZFbuWgnwOBOfegPQ5n9ITfJXlUz6U
         za1Q==
X-Gm-Message-State: AO0yUKWbBzW3LCF13wqks2r6WMiVvB9G8SZvHvcIEdPFvRPQYAlWIRkY
        zdXjtazWQY8rYHXa3y+Oak8g7NAj5E22YlYQsiw=
X-Google-Smtp-Source: AK7set+Wy79yPowMC6yeHwAK0eRzuh4Y6A0GJxrJxkQURZ+TUvQgmCcMvm2Z1VNZ/50anGtnVOxn1A==
X-Received: by 2002:a17:903:1cb:b0:198:af50:e4e4 with SMTP id e11-20020a17090301cb00b00198af50e4e4mr156431plh.10.1675300902364;
        Wed, 01 Feb 2023 17:21:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t26-20020aa7947a000000b0058bbe1240easm444441pfq.190.2023.02.01.17.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 17:21:41 -0800 (PST)
Date:   Thu, 2 Feb 2023 01:21:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] kvm: x86/mmu: Use kvm_mmu_invalidate_gva() in
 kvm_mmu_invpcid_gva()
Message-ID: <Y9sQIqzEghgcsPt7@google.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
 <20230105095848.6061-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105095848.6061-3-jiangshanlai@gmail.com>
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

On Thu, Jan 05, 2023, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Use kvm_mmu_invalidate_gva() instead open calls to mmu->invlpg().
> 
> No functional change intended.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 90339b71bd56..b0e7ac6d4e88 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5742,27 +5742,20 @@ EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	bool tlb_flush = false;
> +	ulong roots_to_invalidate = 0;

"unsigned long roots" again, unless someone has a better idea.
