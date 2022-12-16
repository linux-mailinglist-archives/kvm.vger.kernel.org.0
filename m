Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D6064EEB2
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiLPQMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiLPQMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:12:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055FC9584
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671207039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hiHu37gXvuCkER15x0EivM5VNVlEf5czlwRtK9r2cYM=;
        b=eOOWh2rLSlAxXChkvrXcyINbAfzAI3kCEXUy9R4oUBbXNkgYy9YegE7SxpFJIcsbj0LA2O
        7Sf4xr/Mcqd5k2RWCZ/qOhao2vOEOdARidKatOENJTJ9X6AZ1RVvGrffaJ0dPn1gB2inN8
        HpFoRuq2T+g0u5USK/uW3UOaBK5Qlis=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-8WPYxuMOPVSyNvioacsRNQ-1; Fri, 16 Dec 2022 11:10:38 -0500
X-MC-Unique: 8WPYxuMOPVSyNvioacsRNQ-1
Received: by mail-io1-f72.google.com with SMTP id o22-20020a6b5a16000000b006e2d564944aso1554736iob.7
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:10:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hiHu37gXvuCkER15x0EivM5VNVlEf5czlwRtK9r2cYM=;
        b=bjk2byl1ju7GQCKbi8TKwDOjooxc80zNYDLMt9Bcoqrj0or9vJlFf57nDQiEOh7GV6
         CEzsbEtjTCDKsPrQ4mrlf1Nrt42krz5RKgN2eN9PKAaX9I9aMjKyKw9QSw6WgJ+j18tg
         RPtW+XEONJTOiUzHaudYdAZGGXy2A2IEPLRnpMAr2DOTOmyqaA0lYh8B9JMRfiiUll9Z
         WSnZgmPMz4v/RSJCICoknuZ+K2JlaawdSH201ZuutYaez+Zj7Imo4e0vFRdJ+jAdZrQp
         65ZtHuTTj1awWzvr9ooIMS9UBQTYDpSS3M/3uMHPE11DxmlErsE0xdkesnIlLMPuBMCr
         ez1w==
X-Gm-Message-State: ANoB5pkekpWZvSGhs2ynoEwMS2Ow+3pIXtbQsqRUgpXHbCY1OuaJyZLk
        nLHFViuxj1UKnbHAc/9SK/vTc9b6FhlXNmDIDzBjbSqpaPr3L83kxf7DpiUiALUz5UuFwaShBgA
        pJNCBsPaCOonC
X-Received: by 2002:a05:6e02:b44:b0:300:a953:a263 with SMTP id f4-20020a056e020b4400b00300a953a263mr24480092ilu.21.1671207037629;
        Fri, 16 Dec 2022 08:10:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7LaYhBDQZn5CIQsAHZy9zCYS7ithbMudsXsNhC1Axlvsqae50xL5/szGOTxjKYF8B3HtcGFg==
X-Received: by 2002:a05:6e02:b44:b0:300:a953:a263 with SMTP id f4-20020a056e020b4400b00300a953a263mr24480079ilu.21.1671207037373;
        Fri, 16 Dec 2022 08:10:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b14-20020a92db0e000000b002fc323a2902sm777109iln.62.2022.12.16.08.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:10:36 -0800 (PST)
Date:   Fri, 16 Dec 2022 09:10:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Message-ID: <20221216091034.4c1cac89.alex.williamson@redhat.com>
In-Reply-To: <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
        <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
        <Y5x8HoAEJA7r8ko+@nvidia.com>
        <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Dec 2022 10:42:13 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/16/2022 9:09 AM, Jason Gunthorpe wrote:
> > On Thu, Dec 15, 2022 at 01:56:59PM -0800, Steve Sistare wrote:  
> >> When a vfio container is preserved across exec, the task does not change,
> >> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
> >> mapping, locked_vm underflows to a large unsigned value, and a subsequent
> >> dma map request fails with ENOMEM in __account_locked_vm.
> >>
> >> To avoid underflow, grab and save the mm at the time a dma is mapped.
> >> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> >> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> >>
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
> >>  1 file changed, 10 insertions(+), 7 deletions(-)  
> > 
> > Add fixes lines and a CC stable  
> 
> This predates the update vaddr functionality, so AFAICT:
> 
>     Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> 
> I'll wait on cc'ing stable until alex has chimed in.

Technically, adding the stable Cc tag is still the correct approach per
the stable process docs, but the Fixes: tag alone is generally
sufficient to crank up the backport engines.  The original
implementation is probably the correct commit to identify, exec was
certainly not considered there.  Thanks,

Alex
 
> > The subject should be more like 'vfio/typ1: Prevent corruption of mm->locked_vm via exec()'  
> 
> Underflow is a more precise description of the first corruption. How about:
> 
> vfio/type1: Prevent underflow of locked_vm via exec()
> 
> >> @@ -1687,6 +1689,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>  	get_task_struct(current->group_leader);
> >>  	dma->task = current->group_leader;
> >>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> >> +	dma->mm = dma->task->mm;  
> > 
> > This should be current->mm, current->group_leader->mm is not quite the
> > same thing (and maybe another bug, I'm not sure)  
> 
> When are they different -- when the leader is a zombie?
> 
> BTW I just noticed I need to update the comments about mm preceding these lines.
> 
> - Steve
> 

