Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30036486B3A
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243857AbiAFUeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243793AbiAFUeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:34:13 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070DFC061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:34:13 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n16so3320973plc.2
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 12:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GF5XskFDvb9G6tJ/Fl01Yh2xZZgm3OVtf6yY9f8rMB8=;
        b=eqDpYFFeW+V1P784B9njiwEjCDOlv6cdg0EL0Q70Dg68z0aguZE+LV7z7E7hXBomvX
         ZsW7fjo0Kxjr+gBMaVHX+FNCE7wtEgWugIhGxWJoGx0lkB/euCuYFFzf+rbh1gKZPlWL
         AzSsdCLZ/REwpoP381shEVhQM9PUFwSnyG0ebS2EbN0YlATQhJC0McFm4YCQ/AOFhO2y
         QkPIJl5WJqydEjiFNC8a5etYV6eo8qFONwV6fZQwnAY+cnyQw1DRT2duXrApoRWF8PJF
         GQxNYz3gxBXOFM5naWKzu6BJdbqk2+dXhM7yvc8oCpzhf/U78A1oW6bWMlKkkU1QApMC
         y3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GF5XskFDvb9G6tJ/Fl01Yh2xZZgm3OVtf6yY9f8rMB8=;
        b=GXZmXQ81c+GNv1anqvrAyn3UvnT0BgWJxrfpiHsgFfajp9OuJ/vJIwxOkraCkPmECk
         qjMLA5Ho/GO+vZmPLMk2pW5IQ+6j6XaKIqlORqwhP8JkwGzChYQQVhYxv7d+FwWBbPq3
         +5Ls1JVwS8jlTdhc9q+FISbaOv9Js0P7J+NRgnONGNwdbwv29NOOtI1PolmiFl4+zPWa
         3vhY2Es21X1DRvi+9Hv1EAHh8J05BDGC6x1YSddqiVVLEgjGm0A5Er4mdOk8N1yTXoh2
         n39pnnOQwzdc4310BaXJzGc9z8G6/9qTd1lQrLtV+bJqS3B6r9aOYqtooLj6fzS7q6k/
         jptQ==
X-Gm-Message-State: AOAM530bR5Nnuf/sHeWYj9HG5z9MtwE5loh3GanQoV7SOimZV7GzMTK4
        C6+MP52tS9mn8NlZmnABmWiZ1A==
X-Google-Smtp-Source: ABdhPJxdDZpoMAX8GUuos+LOsICIgM/Gp5cpEPo83+FJQwcybKPZC8qoitDuCT/528sYdIaP/oHQHQ==
X-Received: by 2002:a17:902:e541:b0:149:b747:acbe with SMTP id n1-20020a170902e54100b00149b747acbemr23538525plf.26.1641501252337;
        Thu, 06 Jan 2022 12:34:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p22sm3462105pfo.57.2022.01.06.12.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:34:11 -0800 (PST)
Date:   Thu, 6 Jan 2022 20:34:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 06/13] KVM: x86/mmu: Refactor tdp_mmu iterators to
 take kvm_mmu_page root
Message-ID: <YddSQNlPGyRDtk41@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-7-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> Instead of passing a pointer to the root page table and the root level
> separately, pass in a pointer to the kvm_mmu_page that backs the root.
> This reduces the number of arguments by 1, cutting down on line lengths.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_iter.c |  5 ++++-
>  arch/x86/kvm/mmu/tdp_iter.h | 10 +++++-----
>  arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++---------
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index b3ed302c1a35..92b3a075525a 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -39,9 +39,12 @@ void tdp_iter_restart(struct tdp_iter *iter)
>   * Sets a TDP iterator to walk a pre-order traversal of the paging structure
>   * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
>   */
> -void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> +void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>  		    int min_level, gfn_t next_last_level_gfn)
>  {
> +	u64 *root_pt = root->spt;
> +	int root_level = root->role.level;

Uber nit, arch/x86/ prefers reverse fir tree, though I've yet to get Paolo fully
on board :-)

But looking at the usage of root_pt, even better would be

  void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
		      int min_level, gfn_t next_last_level_gfn)
  {
	int root_level = root->role.level;

	WARN_ON(root_level < 1);
	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);

	iter->next_last_level_gfn = next_last_level_gfn;
	iter->root_level = root_level;
	iter->min_level = min_level;
	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
	iter->as_id = kvm_mmu_page_as_id(root);

	tdp_iter_restart(iter);
  }

to avoid the pointless sptep_to_sp() and eliminate the motivation for root_pt.
