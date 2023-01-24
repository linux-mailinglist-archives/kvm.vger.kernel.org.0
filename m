Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75EF679E97
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjAXQ0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbjAXQ0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:26:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9391B2691
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:26:12 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id z4-20020a17090a170400b00226d331390cso14503491pjd.5
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 08:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WkQDrNHkzQEYlziy8zbZPHrgO5IZjZ5aKuZXPjg7coA=;
        b=mWEMd0E3VSo+2vbyZ9jiYWqigQjgyQjQkehCzOktqTh7FGHTiI7SiZO8Dn/LaD5q6M
         B0Ks3H3j/nNgvmdsIyQ1EPLDq43FXDKoQ/k9rzxMvrXBJ3j1JnNcTzENi3vq/qnkiVDR
         nGs8fkF0zkj1+IwBMa+fNL8o8frZZ6tourUdePnZeKXcEo8nCJLG18Nhb6GBBcK95L8k
         SZq4C+iVaclLb767ipIMNPQmNXacqHf+x7JiLKCCulmX/CB4Cna3rnafW1eUFWEkMP/O
         DM6NeDwZqvlfVuFdA7yzoHEBF0pOAe5HuH5kwq5zYoeI7oa2cGVIkkqJhhamulbHUgEM
         xK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkQDrNHkzQEYlziy8zbZPHrgO5IZjZ5aKuZXPjg7coA=;
        b=A36uXW5d+6HVWDkOKjwy6yNqaVF3Z+LmzzJiKJnQXx9E0S2pLuhEauHj7NYQHxNu99
         HFba6Re3eDxCjBf+/xQqj/xXJ3Z8i/6OUdQ0x+eEIjhEuM+NCdJbFQV4MGHpdaR776KM
         Lak33jKK/8FiC3PcIceN3MtKJ8DSmD6YwQFJjJBtSCBRyLolpV2MY+MCJQXeWu6HxeB5
         pQfQK9unCi+RaAJdvL+nTfqH34xty+YUhx0yx+SR1oZrhbxszVYxyW1MKTKp1gfL3xCk
         hd8mhJ2MKMLM2raxZ/urn6w1NPj2WFvzQ8hyZiJVRSYzdm3bbo2ZNBrbZufO8YGrDhSd
         Df/w==
X-Gm-Message-State: AO0yUKVtsgtAssjXcikIK42nRBnvNndKkJrVD0iF2aOCl7yY7g+eIPaD
        Ju8DJqvtZt0QmlmeAgsheTyYiLDsTkWwNzbRPYKzSg==
X-Google-Smtp-Source: AK7set87Z+xAX+LShw1w7Qvxlm6Z/5hW8cKt7niIXFKSURg7nkilnDsuF3JwTuAv8xQJM5bJcWPomA==
X-Received: by 2002:a05:6a21:998a:b0:b8:c859:7fc4 with SMTP id ve10-20020a056a21998a00b000b8c8597fc4mr275210pzb.1.1674577571942;
        Tue, 24 Jan 2023 08:26:11 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id f23-20020a656297000000b0047063eb4098sm1627708pgv.37.2023.01.24.08.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:26:06 -0800 (PST)
Date:   Tue, 24 Jan 2023 08:26:02 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 4/4] KVM: selftests: aarch64: Test read-only PT memory
 regions
Message-ID: <Y9AGmn0CM/lNX6w/@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-5-ricarkol@google.com>
 <Y88aFBBcsx7v/2qh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88aFBBcsx7v/2qh@google.com>
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

On Mon, Jan 23, 2023 at 11:36:52PM +0000, Oliver Upton wrote:
> On Tue, Jan 10, 2023 at 02:24:32AM +0000, Ricardo Koller wrote:
> > Extend the read-only memslot tests in page_fault_test to test read-only PT
> > (Page table) memslots. Note that this was not allowed before commit "KVM:
> > arm64: Fix handling of S1PTW S2 fault on RO memslots" as all S1PTW faults
> > were treated as writes which resulted in an (unrecoverable) exception
> > inside the guest.
> 
> Do we need an additional test that the guest gets nuked if TCR_EL1.HA =
> 0b1 and AF is clear in one of the stage-1 PTEs?
> 

That should be easy to add. The only issue is whether that's also a case
of checking for very specific KVM behavior that could change in the
future. It's unlikely, but what if KVM emulated the page table walker
behavior to give userspace all the info it needed to fix the fault.
Although it's so unlikely that I think I will add the exception check.

> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../selftests/kvm/aarch64/page_fault_test.c        | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > index 2e2178a7d0d8..2f81d68e876c 100644
> > --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > @@ -831,6 +831,7 @@ static void help(char *name)
> >  {										\
> >  	.name			= SCAT3(ro_memslot, _access, _with_af),		\
> 
> Does the '_with_af' actually belong here? The macro doesn't take such a
> parameter. AFAICT the access flag is already set in all S1 PTEs for this
> case and TCR_EL1.HA = 0b0.

Good catch. That name would have been very confusing when debugging.

> 
> >  	.data_memslot_flags	= KVM_MEM_READONLY,				\
> > +	.pt_memslot_flags	= KVM_MEM_READONLY,				\
> >  	.guest_prepare		= { _PREPARE(_access) },			\
> >  	.guest_test		= _access,					\
> >  	.mmio_handler		= _mmio_handler,				\
> 
> --
> Thanks,
> Oliver
