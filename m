Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCE65289F
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 23:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiLTWAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 17:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLTWAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 17:00:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DE95F4B
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 13:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671573564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMN3gBpViOsEfP9p+goATUiKKGttSUlMRU3hEauqDyA=;
        b=UiDNOtlYZ9XKRfTecGIO2Sa6J0FvCVSJC88QpFhY+C6585oLbRByvJn9JePd53KJFk+8Qu
        JMbKi7rkgFApI7GxHliASPBCD0aeiA+u5Nwvzb6DYD/PrLSptSZoagXwQJN+nTfvpclMcd
        GeqUfUvcK6rOIls0wBLfCqcS1eydCp4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-imTFNFbYPtW-9tanZ9skNA-1; Tue, 20 Dec 2022 16:59:23 -0500
X-MC-Unique: imTFNFbYPtW-9tanZ9skNA-1
Received: by mail-io1-f70.google.com with SMTP id z200-20020a6bc9d1000000b006e003aecf04so6131720iof.16
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 13:59:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMN3gBpViOsEfP9p+goATUiKKGttSUlMRU3hEauqDyA=;
        b=7f7r9ZMNskC4sBp3vpi3axE71faBxq6m1kDSZE8aSKgZY3oyimisRzRKiYdBZGMmOI
         xI/Idb9t60zMv9rh6m2U1F9mFxulUgEFagsnYM4oRq5hout+9zlks5JX9PrVpdrMd99K
         D9YxCBC+PciziFK7gxWTABAlif2PwqApvKdjGb4+7tt2Xlxvnz8ij/1d/wPnohMs1Oeq
         0YgSlKNLEOHn3hx849+5GCLh5qhq+BZTB95W5RbRQXSMvGS4KaH84jt1Zlc8Y7mlBaOH
         YH0jeHQ3cZLHK9hO91j4euWX7eTFlDSeM2aNyf5MNYf1UB0Vz+bVVRUhPtXweah0mcUR
         ok+A==
X-Gm-Message-State: ANoB5pkoZxeu0nwCuLg0LUY8/fGhQFWglaHLgSZF7aus7pIOnvmFZi5a
        LKqcfHpujLmo2pxYteSSSzWDZJV+9FWciq0ImD349NAZCfDqpdJUWzqBE05OfjTq51DP+DR0FAo
        hEEHtMLtxX2uE
X-Received: by 2002:a6b:d911:0:b0:6e4:f785:a8d1 with SMTP id r17-20020a6bd911000000b006e4f785a8d1mr12862836ioc.13.1671573562507;
        Tue, 20 Dec 2022 13:59:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Ri6m6UJQT5wpv28SCpOcY+SstEuxlAnIa0Ln6iaMnH2I76sqYIKfiQDPYOOXF0HGZgr68Yg==
X-Received: by 2002:a6b:d911:0:b0:6e4:f785:a8d1 with SMTP id r17-20020a6bd911000000b006e4f785a8d1mr12862826ioc.13.1671573562303;
        Tue, 20 Dec 2022 13:59:22 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w15-20020a02b0cf000000b0038a8f0b4919sm5032570jah.140.2022.12.20.13.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 13:59:21 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:59:20 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V6 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Message-ID: <20221220145920.6669de59.alex.williamson@redhat.com>
In-Reply-To: <f2af6106-7898-b96c-000e-92e84190ee54@oracle.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
        <1671216640-157935-3-git-send-email-steven.sistare@oracle.com>
        <BN9PR11MB5276E8FEF666B4E7D110DE278CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
        <f2af6106-7898-b96c-000e-92e84190ee54@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 20 Dec 2022 10:01:21 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/19/2022 2:48 AM, Tian, Kevin wrote:
> >> From: Steve Sistare <steven.sistare@oracle.com>
> >> Sent: Saturday, December 17, 2022 2:51 AM
> >> @@ -1664,15 +1666,7 @@ static int vfio_dma_do_map(struct vfio_iommu
> >> *iommu,
> >>  	 * against the locked memory limit and we need to be able to do both
> >>  	 * outside of this call path as pinning can be asynchronous via the
> >>  	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires
> >> a
> >> -	 * task_struct and VM locked pages requires an mm_struct, however
> >> -	 * holding an indefinite mm reference is not recommended,
> >> therefore we
> >> -	 * only hold a reference to a task.  We could hold a reference to
> >> -	 * current, however QEMU uses this call path through vCPU threads,
> >> -	 * which can be killed resulting in a NULL mm and failure in the
> >> unmap
> >> -	 * path when called via a different thread.  Avoid this problem by
> >> -	 * using the group_leader as threads within the same group require
> >> -	 * both CLONE_THREAD and CLONE_VM and will therefore use the
> >> same
> >> -	 * mm_struct.
> >> +	 * task_struct and VM locked pages requires an mm_struct.  
> > 
> > IMHO the rationale why choosing group_leader still applies...  
> 
> I don't see why it still applies.  With the new code, we may save a reference 
> to current or current->group_leader, without error.  "NULL mm and failure in the 
> unmap path" will not happen with mmgrab.  task->signal->rlimit is shared, so it 
> does not matter which task we use, or whether the task is dead, as long as 
> one of the tasks lives, which is guaranteed by the mmget_not_zero() guard.  Am
> I missing something?
> 
> I kept current->group_leader for ease of debugging, so that all dma's are owned 
> by the same task.

That much at least would be a good comment to add since the above
removes all justification for why we're storing group_leader as the
task rather than current.  Ex:

	QEMU typically calls this path through vCPU threads, which can
	terminate due to vCPU hotplug, therefore historically we've used
	group_leader for task tracking.  With the addition of grabbing
	the mm for the life of the DMA tracking structure, this is not
	so much a concern, but we continue to use group_leader for
	debug'ability, ie. all DMA tracking is owned by the same task.

Given the upcoming holidays and reviewers starting to disappear, I
suggest we take this up as a fixes series for v6.2 after the new year.
The remainder of the vfio next branch for v6.2 has already been merged.
Thanks,

Alex

