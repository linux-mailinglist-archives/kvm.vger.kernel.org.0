Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77156AD17
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 22:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbiGGU7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 16:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiGGU7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 16:59:47 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D1E1F612
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 13:59:46 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 23so20651800pgc.8
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 13:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A5MhBcXf8LVQ9gbV4fE8wcZW4gjzBdDH9411SgBm9nA=;
        b=JZQC6m6xR5sT0Jada7pN2ctPDZoVBgPNmsmVFV9xaOD0K1VcjdaDGI+Dbb9m6z+j0M
         HQZao2MwdnxdUCyFyWlgXqE0vhn5k0x3cFJEqeUSkVEsaLaami6rP5dYbVbdIFtecFK0
         bszrtlQ/BBq6HtrtoG8nU1E+PvhE0lLr6U7Movo+h1ZN1VwhTvdz1ZHCpBxehT1XrGLp
         ldw665ro4GytFHnalr0o9hUTUOKVZe4kPdeCD4oNOEE/cifAyBR7BH7HyjVvjpbMGLv/
         wuBFBMUf1JFMK20mDchKuifuX9NzhPRD+zMlfMD3Uo00M9pihW0RWuo1fPBLXJlg8Qnc
         EHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A5MhBcXf8LVQ9gbV4fE8wcZW4gjzBdDH9411SgBm9nA=;
        b=JVp7Ue+ZOmMwr8ohPeyGswwXdMLI4nZOVD+s+0qyFlRnAQEAJUtDrf7NGr1m2EA6Ef
         aPxWfpMXGbYLpfgSAIdm5PtjPpKQFoisltPwIURVlmk9b5KcXbysZF7cu/89Rz6Oo/tA
         UVCj1MCbfPw6kn2QO5S7NM6oELsNva37OJdrXVgXB5BQOGClcDsncbzt3uPEhCqzBg7+
         bmM5YTfV2dozOG8OzWJ93h+Kbevb+QpzH+nRsELbMlaKw2QHLeZ5N7LUr9vLX8W0IJWK
         /yq+hx8CS3uuqzUtnebrVYrxB6Wf0328wTnWrYNYejvkt3+2+2q2BqIQolYZ/9/wZPq3
         xpYQ==
X-Gm-Message-State: AJIora8pmRxGgylfVmSyicbmctwkWafpn390TdgKGacdxVfnb7NcsrwU
        XdwBZJ0AL9QIPjiLWahOlHgpLw==
X-Google-Smtp-Source: AGRyM1sARh3FSc0YJzBOfjfu9tVk8n9I1lJXGq5XAEdqRD+A3gMvMxGVzqr9kHPYDPOxaQ6woa23oA==
X-Received: by 2002:a63:4756:0:b0:412:88b5:2a23 with SMTP id w22-20020a634756000000b0041288b52a23mr11516pgk.442.1657227585430;
        Thu, 07 Jul 2022 13:59:45 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id rt5-20020a17090b508500b001ef8ac4c681sm22733pjb.0.2022.07.07.13.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 13:59:44 -0700 (PDT)
Date:   Thu, 7 Jul 2022 20:59:41 +0000
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
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <YsdJPeVOqlj4cf2a@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-2-yosryahmed@google.com>
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

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> We keep track of several kernel memory stats (total kernel memory, page
> tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> per-memcg, etc). These stats give insights to users to how much memory
> is used by the kernel and for what purposes.
> 
> Currently, memory used by kvm mmu is not accounted in any of those

Nit, capitalize KVM (mainly to be consistent).

> @@ -1085,6 +1086,9 @@ KernelStack
>                Memory consumed by the kernel stacks of all tasks
>  PageTables
>                Memory consumed by userspace page tables
> +SecPageTables
> +              Memory consumed by secondary page tables, this currently
> +	      currently includes KVM mmu allocations on x86 and arm64.

Nit, this line has a tab instead of eight spaces.  Not sure if it actually matters,
there are plenty of tabs elsewhere in the file, but all the entries in this block
use only spaces.

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index aab70355d64f3..13190d298c986 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -216,6 +216,7 @@ enum node_stat_item {
>  	NR_KERNEL_SCS_KB,	/* measured in KiB */
>  #endif
>  	NR_PAGETABLE,		/* used for pagetables */
> +	NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */

Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
is messy, so I totally understand why you included it, but in this case it's unnecessary
and potentially confusing.

And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
(using IS_ENABLED() because KVM can be built as a module)?  That could be removed
if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
stats the depend on a single feature seems to be the status quo for this code.

>  #ifdef CONFIG_SWAP
>  	NR_SWAPCACHE,
>  #endif
