Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3117668A5A
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjAMDox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjAMDos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:44:48 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6AE1DF20
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:44:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z4-20020a17090a170400b00226d331390cso23131566pjd.5
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4oRV9JDfOgkyA//zYsWLGmWXmqofSnQQ80rC6HMhzw=;
        b=qC7eHjKK0+1rkgrY4flbpuQ2Gn3x8fT9r2804GDecvxWkSjplomS1Amjqvhi0j+XyS
         VfLZxQmWc9rVqLALMFTeeczwxFjywNYRToV7d53Q7MtMtaHg7Y/9LdmRdV4BCWweDxXE
         idqsH31ct5JJF9PVDxA9G7ybandl+Jif01yGsC9DlBcYx0vcnv9Obqv1NOLsMK4UylL9
         WMRuqTLQNMN2anFK/bg+wBKxIbWC27TXq/KrtQctdJTZWFjp+Na3Wc02TUyjcVqykFxl
         rsVTMYraMTbpXb6kb/o+Eu0URzr7LJ5fhBeApCcluVzxN6cwHiIx8YxD+sj/bK7ntsZT
         TnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4oRV9JDfOgkyA//zYsWLGmWXmqofSnQQ80rC6HMhzw=;
        b=JdpJ5q5cONR01bow8eCEIIlu3Bjv5Phra4D6ZpJJuMP6OEIQOk+AXdhtOhXlymP00q
         BN6mzpHzHzU/M389yxHUvhS9P0V3zk/8DeLHkI2BidMqeXBhyWgTorOMEFxFp3vriyv/
         DL4HMOcWXOVnWg2gaKerFErHkdVypcT3FgnFfsLUhL3qm30MaClTTOkNARAug4dl+Ke8
         eySEGb136PMjJ0fHEFJozFP+sqFH78P6AiqlA/viw14+jn0lt+9AwTCXgn372gEIYfDw
         +d1pA6BeR56oR6bpTX4IJ2/Y2zjM9VKwAq2PA1N99OhBmD5C7VzbtNsq/7gPNcI9mqWM
         pC3w==
X-Gm-Message-State: AFqh2krdgoU6biAyGwyB7MOi9Bo+EDdrv5uRDSTH1WROIk6dbOkdMAlk
        55jQqVahrhJI/1glie/5BtbwMA==
X-Google-Smtp-Source: AMrXdXuAnFXhZM0FTFiqIljYeLNe5lkdqTnd84rfecdRSjYAQv64CfFah2yZZMqjqdoBRgxybGH9Iw==
X-Received: by 2002:a17:902:c189:b0:191:1543:6b2f with SMTP id d9-20020a170902c18900b0019115436b2fmr1315193pld.3.1673581486910;
        Thu, 12 Jan 2023 19:44:46 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b00186985198a4sm12961654plh.169.2023.01.12.19.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 19:44:46 -0800 (PST)
Date:   Thu, 12 Jan 2023 19:44:43 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
        qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        ricarkol@gmail.com
Subject: Re: [RFC PATCH 02/12] KVM: arm64: Allow visiting block PTEs in
 post-order
Message-ID: <Y8DTqxdY/h4f0q4a@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-3-ricarkol@google.com>
 <Y3KNZCLVqnFeg7hi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3KNZCLVqnFeg7hi@google.com>
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

On Mon, Nov 14, 2022 at 06:48:04PM +0000, Oliver Upton wrote:
> On Sat, Nov 12, 2022 at 08:17:04AM +0000, Ricardo Koller wrote:
> > The page table walker does not visit block PTEs in post-order. But there
> > are some cases where doing so would be beneficial, for example: breaking a
> > 1G block PTE into a full tree in post-order avoids visiting the new tree.
> > 
> > Allow post order visits of block PTEs. This will be used in a subsequent
> > commit for eagerly breaking huge pages.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  4 ++--
> >  arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
> >  arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++-------------
> >  3 files changed, 15 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index e2edeed462e8..d2e4a5032146 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -255,7 +255,7 @@ struct kvm_pgtable {
> >   *					entries.
> >   * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
> >   *					children.
> > - * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
> > + * @KVM_PGTABLE_WALK_POST:		Visit leaf or table entries after their
> >   *					children.
> 
> It is not immediately obvious from this change alone that promoting the
> post-order traversal of every walker to cover leaf + table PTEs is safe.
> 
> Have you considered using a flag for just leaf post-order visits?
> 

Not using this commit in v1. There's no (noticeable) perf benefit from
avoiding visiting the new split tree.

Thanks,
Ricardo

> --
> Thanks,
> Oliver
