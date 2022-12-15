Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938C264D466
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 01:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLOANx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 19:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiLOAN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 19:13:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C7F264AB
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:11:20 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so996903pjs.4
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 16:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=By2H8KrcS73TgVcFpcBg3X+JL35qHHiqAcd05o2uzfM=;
        b=GAXN/2bmoZkHKTd0ZYUgx9wn6o9YuXABH35nYYEloOMzKYc80wpxlootj2StNok7eG
         IaNNd21+mRxm1kcwbIaaUWm51BQnP/jhq516l2Fdp4jLB5MYwvygRdSk6N/hKOxDlmKM
         FUD4XHMWAMrJ7xrtT26owlWkLss0j9TWh1yQv/aF37no6lMKcydEELIaLWy7KyxDWXoa
         2E/RTImkl3NsrjinkQ9I1Ll/eQVK0aqRmvz0i5SpB3hLmOewP3K3BpoF5GZkl75VH0e7
         yuVtrbVHyTca1zHafJ4Ur9JyIMYt1Q6UpZr4xeORNQWDzJCXYTo/v3eM2CVkPhQ2xW7c
         Re8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=By2H8KrcS73TgVcFpcBg3X+JL35qHHiqAcd05o2uzfM=;
        b=vYKysbq2FxwalcGiacptKXkZZKAU8w1rrloXznDvSGY77mOnbLn7eCvisUeH1bIuuj
         n86GL8SpH0X28cfULj19v6LPq3cs/BsLhc9NElyQYYMoBcT031uQszNBVSOwNxNRkDGa
         Lm711t5U43SdD8xUpy+QaNOaJsSE5zmMa4aBA14ellBWH+BY4lEzx38B030qxW3Ftue1
         naDXwWOj7PVd4gMvgRlxXnkSMSqhffeL/kwuOvh19DihGXXaBpFgVD5ntVEqhWe24ZQB
         Ekjgzg9qyUFBWTEVRuvv9sYc9pCpbBKNRt9tNJFl8idiUdg/knR1GMk/ggaZu3H8nqDP
         P+Sw==
X-Gm-Message-State: ANoB5pl1Pd/fvZ7I04WmMPewtvb/lA6N2nNhDKKSVIbrmSR/dChnw5OP
        T9lYxeLm73OW26SXfqV5Id8w7E+L24Mp9s7y
X-Google-Smtp-Source: AA0mqf4NUM27a7k0zaNJQPsSZvzkFd1XtpJga5zvSGj0zyc48rI6Ngzb2+KIH3GCtWSoS8qQtH9bWw==
X-Received: by 2002:a17:90b:3685:b0:219:d1eb:b8ad with SMTP id mj5-20020a17090b368500b00219d1ebb8admr963836pjb.2.1671063079947;
        Wed, 14 Dec 2022 16:11:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090a520900b00218e8143380sm1955302pjh.28.2022.12.14.16.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 16:11:19 -0800 (PST)
Date:   Thu, 15 Dec 2022 00:11:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH 3/5] KVM: x86/mmu: Re-check under lock that TDP MMU SP
 hugepage is disallowed
Message-ID: <Y5pmI6xwJhvrWXJ8@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
 <20221213033030.83345-4-seanjc@google.com>
 <247fcfc6de8ec08d0667de125e707046dce903fc.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <247fcfc6de8ec08d0667de125e707046dce903fc.camel@linux.intel.com>
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

On Wed, Dec 14, 2022, Robert Hoo wrote:
> On Tue, 2022-12-13 at 03:30 +0000, Sean Christopherson wrote:
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index e2e197d41780..fd4ae99790d7 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1203,7 +1203,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu,
> > struct kvm_page_fault *fault)
> >  		if (fault->huge_page_disallowed &&
> >  		    fault->req_level >= iter.level) {
> >  			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > -			track_possible_nx_huge_page(kvm, sp);
> > +			if (sp->nx_huge_page_disallowed)
> > +				track_possible_nx_huge_page(kvm, sp);
> >  			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> >  		}
> >  	}
> 
> Is this possible?
> The aforementioned situation happened, i.e. before above hunk
> track_possible_nx_huge_page(), the sp is zapped by some other task,
> tdp_mmu_unlink_sp() --> untrack_possible_nx_huge_page(kvm, sp):

It's possible for untrack_possible_nx_huge_page() to be called before the above
snippet, but the stat won't be decremented in that case since the page won't be on
the list of possible NX huge pages, i.e. list_empty() will be true.

  void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
  {
	if (list_empty(&sp->possible_nx_huge_page_link))
		return;

	--kvm->stat.nx_lpage_splits;

And by not calling track_possible_nx_huge_page() (this bug fix), nx_lpage_splits
won't be incorrectly incremented.

> 
> --kvm->stat.nx_lpage_splits;
> 
> But looks like the stat for this sp hasn't been increased yet.
> 
