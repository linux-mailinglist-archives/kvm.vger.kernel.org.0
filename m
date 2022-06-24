Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6858F55A067
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiFXRdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiFXRdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:33:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17025676E
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:33:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id go6so3469410pjb.0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wnfPKujGVoYbURscVTrmuUN9OKz52+48fIZergG9500=;
        b=dHomln6XLNm+Rim4++kBb7puRRJ7FIAkPypG7ZVqjWPF0O0N0teW4KBLsOl9EFSWLG
         0h1VO4Z9sk6KdG8cWCqx5+jHpYjLfkM4D1TRTFPYTKz/kfmEYNnPuc7BTFcrvsxbW4h3
         I3Ex8gzOIJvaZ8edND1PIMaThqOnPZgZhrlCEc8qFRVi9hztX65/I1UnmKCm5UHYYVcY
         1BIy4X41FalQtPQd8GkkokHJ4s9EKJkpEpfrcGbg2G/BbK/KGz76ohzb7MQpjUUEpBj9
         MmDOyNAtpguj+91GL/GSJ0cSkvN210Fa+xsl/y8fZiMlG+ekG4kNYq3bx5St+SPpDw5f
         Q1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wnfPKujGVoYbURscVTrmuUN9OKz52+48fIZergG9500=;
        b=efQwDL62kW4WntTQCXRuIB4LjhMziBhlBNwQxbjVqfCD25PH1nD8wO7+nmHlzAAcTx
         0fE2Osjxv3PpIAvuxBBM8uwTzsG9/CXtv/xP12YNVEfCd+ypvfM36da2llxqmGa1i4Mi
         3WlRH82SiCFw0+0kBNEJTyzxDy0JUdy/b82a+mCT3LdAMm+zozthKKyT/6JBg1q+ORqu
         Ha4j0SYWJX4IxTCpWmVXbyKF+fD+it4M/gyiiZ2vkjCgk/g62kUvFZlAG1YyhQi/Y0aM
         DM+f4ns0hLuWSVWp0tbLhv6jJ5bH9C9VoTar8fs+phydq7m0tm+0ozDSUsCm8o10OXtm
         ohzA==
X-Gm-Message-State: AJIora9j2TSC7hHjmDDatpf2q6I3asqj0vpX5chQNs/zB2e3n6UkxRhI
        Aq7chzO7cBTnAqcuI+aAWwHz/w==
X-Google-Smtp-Source: AGRyM1sLQ9gc4+2NWgmV6NNY4iQfcSJcElFyeC3FYsQYipL6qbJGuUvPtNKWEGl8Lj/UGQHyfRsbCw==
X-Received: by 2002:a17:903:286:b0:16a:1590:bffd with SMTP id j6-20020a170903028600b0016a1590bffdmr149006plr.47.1656091998113;
        Fri, 24 Jun 2022 10:33:18 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id e21-20020a170902d39500b0016a565febdfsm2071632pld.252.2022.06.24.10.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 10:33:17 -0700 (PDT)
Date:   Fri, 24 Jun 2022 17:33:12 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Avoid subtle pointer arithmetic in
 kvm_mmu_child_role()
Message-ID: <YrX1WB1FZzXiR+Io@google.com>
References: <20220624171808.2845941-1-seanjc@google.com>
 <20220624171808.2845941-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624171808.2845941-2-seanjc@google.com>
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

On Fri, Jun 24, 2022 at 05:18:06PM +0000, Sean Christopherson wrote:
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2168,7 +2168,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>  	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
>  }
>  
> -static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsigned int access)
> +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
> +						  unsigned int access)
>  {
>  	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
>  	union kvm_mmu_page_role role;
> @@ -2195,13 +2196,19 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsig
>  	 * uses 2 PAE page tables, each mapping a 2MiB region. For these,
>  	 * @role.quadrant encodes which half of the region they map.
>  	 *
> -	 * Note, the 4 PAE page directories are pre-allocated and the quadrant
> -	 * assigned in mmu_alloc_root(). So only page tables need to be handled
> -	 * here.
> +	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
> +	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
> +	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
> +	 * quadrant is assigned in mmu_alloc_root().   A 4-byte PTE consumes
> +	 * bits 21:12, while an 8-byte PTE consumes bits 20:12.  To consume
> +	 * bit 21 in the PTE (the child here), KVM propagates that bit to the
> +	 * quadrant, i.e. sets quadrant to '0' or '1'.  The parent 8-byte PDE
> +	 * covers bit 21 (see above), thus the quadrant is calculated from the
> +	 * _least_ significant bit of the PDE index.
>  	 */
>  	if (role.has_4_byte_gpte) {
>  		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
> -		role.quadrant = (sptep - parent_sp->spt) % 2;
> +		role.quadrant = ((unsigned long)sptep / sizeof(*sptep)) & 1;
>  	}

I find both difficult to read TBH. And "sptep -> sp->spt" is repeated in
other places.

How about using this oppotunity to introduce a helper that turns an
sptep into an index to use here and clean up the other users?

e.g.

static inline int spte_index(u64 *sptep)
{
        return ((unsigned long)sptep / sizeof(*sptep)) & (SPTE_ENT_PER_PAGE - 1);
}

Then kvm_mmu_child_role() becomes:

        if (role.has_4_byte_gpte) {
        	WARN_ON_ONCE(role.level != PG_LEVEL_4K);
        	role.quadrant = spte_index(sptep) & 1;
        }
