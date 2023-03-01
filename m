Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AF36A74C8
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 21:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCAUKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 15:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCAUKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 15:10:47 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0793742BDC
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 12:10:47 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y2so14521409pjg.3
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 12:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rN8abvDcV5GsYYafJC+S1EERF45eL84JoIpdxecRuYs=;
        b=s0d1TdpOcrkpwZTXxew9tjgl6JiFa2y9h9rkcNyoBHubX7KNY7tCQFQCKZ3qzbuQxY
         OZBzg8RdOllTC1vZ3otW3JxQNaQmXE2vX7uaKk2yVJYMrzc2gj7eL/NDTFLrvz8ZYLb5
         G62bDd7dI7WSN3BFicBfAjXQ4sj2BKugVVYZsu6yXriUIm51qgjDSIBY7Cn+L5vHM4IL
         mF+Q8JlusgA5gRSVbVRH+mt6cWiwisQHk2bJUeI5rM+FpQN4xo2rCP3TzTja3uFjU8M4
         M8bLIxbCf5Bq5u5XIqJCk/Os5TUrhIMMP2ngzLTCqec0D67uxHgbG9exIYR3vTV71C6L
         hyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rN8abvDcV5GsYYafJC+S1EERF45eL84JoIpdxecRuYs=;
        b=04XVDGANRBgzX9XWVSiqwXUw0quJahz1pZoCGmLoWf/mbTo6FNMY4ZCdSmpajesxei
         4KDP4+520vTZuw/kZ+e49VAgoInBMy4/xy0uidC5ISEhInsKCKgrYf9HGG5IPkB18o/l
         h/OPvh7NBP2ePM3GGmzAo7srMSCtVAt/W92QyqI5TEKRLoC7gB46//gJzjc4Ua/dRBIR
         PjzO/AG5t9aov7xLUyLMfSGCZRD55kdxpHZOGw5il2+0XjzZp9ohKYrjlLr7zj71DlAu
         cHmijRInGPIxM+g7wvj8w50JlYUpzfwoptanzBdkJOjZsIWSrMHA5l0v3vQSdU0GymDm
         4nyg==
X-Gm-Message-State: AO0yUKV0FZ5Gji1ikSar5y0v9AsFlCRVGn9pw1X/o05rnlJ5fXiZ7H5Q
        xzT9s/1+NFwFz0XuqwG8uJRV8Q==
X-Google-Smtp-Source: AK7set9hHt/VgPzr7hloURb8t3YPAtUhN3+d2AS57/RrcK0tqXPu0gnqnzpkibcTuTsonMXKW/xchA==
X-Received: by 2002:a17:903:746:b0:19c:d96b:b904 with SMTP id kl6-20020a170903074600b0019cd96bb904mr26367plb.3.1677701446263;
        Wed, 01 Mar 2023 12:10:46 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id jh20-20020a170903329400b0019ccded6a46sm8824224plb.228.2023.03.01.12.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 12:10:45 -0800 (PST)
Date:   Wed, 1 Mar 2023 12:10:42 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Subject: Re: [PATCH v4 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <Y/+xQjqzXStIiBmO@google.com>
References: <20230218032314.635829-1-ricarkol@google.com>
 <20230218032314.635829-4-ricarkol@google.com>
 <e62b4495-3e99-d3da-8fc3-e40246ccb498@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e62b4495-3e99-d3da-8fc3-e40246ccb498@redhat.com>
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

On Mon, Feb 20, 2023 at 02:35:46PM +0800, Shaoqin Huang wrote:
> Hi Ricardo,
> 
> On 2/18/23 11:23, Ricardo Koller wrote:
> > Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> > creating unlinked tables (which is the opposite of
> > kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> > useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
> > PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
> > creating a fully populated tree, and then use it to replace the PUD in
> > a single step.  This will be used in a subsequent commit for eager
> > huge-page splitting (a dirty-logging optimization).
> > 
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
> >   2 files changed, 74 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index dcd3aafd3e6c..b8cde914cca9 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -460,6 +460,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >    */
> >   void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +/**
> > + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @phys:	Physical address of the memory to map.
> > + * @level:	Starting level of the stage-2 paging structure to be created.
> > + * @prot:	Permissions and attributes for the mapping.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > + *		page-table pages.
> > + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> > + *
> > + * Create an unlinked page-table tree under @new. If @force_pte is
> The @new parameter has been deleted, you should update the comments too.
> 
> Thanks,
> Shaoqin
>

Right. Sending a v5 in a bit.

Thanks,
Ricardo
