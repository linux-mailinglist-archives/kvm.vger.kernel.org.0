Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2655E185
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiF0QUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiF0QUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:20:10 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219BF2660
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:20:09 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id v126so5390278pgv.11
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l6X68KuyBDU81KFCllZcPJCpgvdaKM9lp1nYP5LV1kY=;
        b=QYuHqx8JmD3fGZhFw9UuYiMUgaHHG5YjGJZr+BhXEcVvOKmxYAAHNIYT4pML0YKcd9
         UOpJZM3FxgCDYFkMEGVBOlFqLEi8hSMYRQnc+e7vRrYWrYSatKpLhI/fy9hbjAzv1Pnb
         Fzbk/A5QTs7U7PdF27OM5n8DIpWN30JeOZDLCACOEVdlNkDU2Q35PBJKkpYSbiWrD6Tw
         wUqWe7xVXLUA8Y8WFwrTpTXlCat4Ci9KWWfxvDWzzZ/KX8yqgOjmViXM2APbm4qweJdE
         PTl/Ci9fvhKr/8UGP8qNqQ7aXyTDMrVnpzr/DD4SM5yQhjeV+eXwvVZzqlB5dla5a1gv
         MANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l6X68KuyBDU81KFCllZcPJCpgvdaKM9lp1nYP5LV1kY=;
        b=NC/eGb45z4AcRpiK6+1hi5VrXUl8c8Cuheq7UWKnL2/qAqf08BYUPYC0ASFZ6njyrA
         3Qr2/eSb8gvnYVtKK/16WLRZEtKSFBpRd6OvoZn2wRnRJZbmPVBq7JuZsVGcf+RCfFGz
         7tcEj81OicLS6KI1NU0O6IDbsCUaA9jLm/BVKksBRb4rH1gher44VC2ybrsya5Plkb8W
         r/MB7FgI9cTEM8RucvbCLkczmDymQ2Xdm5dcOyb9COuHAV3zRPOdTzlXbsdq+axKGaq+
         Vly/tYbsCvpLmlS5rG0770h0cFgxHApCMBKFfkWidkN8/LU/V2H8JLuC2QNZR6dgP5Es
         oXJA==
X-Gm-Message-State: AJIora92z1GS8tpP+V0TqTv5T/xUsHcyknxgAGBEX3GfvXbylJNI3P65
        zZ0pF37I5c9dQVqzs1p19Iqafg==
X-Google-Smtp-Source: AGRyM1sm+8Ne4/LREAP1BhpBHmHl7sHKXi5L+eGvKtbQn5emgnCoxtJdYUMElvkncDMjnmXaWe/0bg==
X-Received: by 2002:a63:710c:0:b0:40c:adcf:ce72 with SMTP id m12-20020a63710c000000b0040cadcfce72mr13747246pgc.310.1656346808483;
        Mon, 27 Jun 2022 09:20:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a174a00b001ec84049064sm7538417pjm.41.2022.06.27.09.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 09:20:08 -0700 (PDT)
Date:   Mon, 27 Jun 2022 16:20:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v5 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Message-ID: <YrnYtMGmGDxCrwdv@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-3-yosryahmed@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Add a helper to account pages used by KVM for page tables in secondary
> pagetable stats. This function will be used by subsequent patches in
> different archs.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 883e86ec8e8c4..645585f3a4bed 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2246,6 +2246,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * If nr > 1, we assume virt is the address of the first page of a block of

But what if @nr is -2, which is technically less than 1?  :-)

> + * pages that were allocated together (i.e accounted together).

Don't document assumptions, document the rules.  And avoid "we", pronouns are
ambiguous, e.g. is "we" the author, or KVM, or something else entirely?

/*
 * If more than one page is being (un)accounted, @virt must be the address of
 * the first page of a block of pages what were allocated together.
 */


> + */
> +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> +{
> +	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
