Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B74644869
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 16:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiLFPvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 10:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiLFPv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 10:51:27 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D37C286FC
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 07:51:26 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q1so13714411pgl.11
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 07:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gqqL0wzb/cn536XtYZtFOaEpIM6uV5P9yYi1coZmPF0=;
        b=jp4VKKZJHmW9e+5o/XYsQYVzCWhlkU6zVHLYGWRQ6mL5NGoTJWhwjrvshgFBiI+mEZ
         hVt7JXaTWLM2BeUl+D0v+YiBr92Tfo/1eDlAmvK8unPQIMLXxTdQcEXHU7VcsOz6MymE
         gRhL84a73vXFw9Kzv8cmUMxo2gVtuR+sr+dL3bKLc50/L/IVfG4X81uc8EdEf2f935mh
         X1AffDI3sVE53IzMXO9e1awFVOLUYoOQV6+I5I7KcekR8ALznMH6UQKfKYU/rqJOs/vw
         kQif/TsZvMyXAftVb/QSfMwuKlHFJRLJHZZsLXPhluYpkqoOQjdNvnxlRGSCe921fY1g
         uZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqqL0wzb/cn536XtYZtFOaEpIM6uV5P9yYi1coZmPF0=;
        b=5guUxrnTom0kmf2D996xFlVqkBdC+7Oxk0Vqx0qj7QtsOp6ES1Wp9Ir5kmgnEG1jRP
         6DsPnAjvfzegyTeNEj3kF0Y2sPGjam8R2HOtbAIqeWbStoMdUc44LLu3/rrWTV0nzaqn
         Nl4DFzfIsAnPU1FKGBd9VkRflsBhxEwYbXoW59aYO9CDscfrNagT5AYNy+DaVeF35c24
         zMdaEFW1TUsh8CGejme4fdLHULhW2Dq4uGXaaZ10v57sA79h4ocZ9+qnFOevy0Idru0z
         jC3yVcIVlujVrJKFHNf2KhEFmBFRqPpcEZwTmF5MBxpiBuwWIbeO0/lzVmqwF96xfTCq
         /dBA==
X-Gm-Message-State: ANoB5pl0rYPKVUury4DzRBY5gRu4b+bqIUZ6098a9i/8sEZNkG5ztoi+
        UwWWCVmQ2udDk8HPTEeizGRFYw==
X-Google-Smtp-Source: AA0mqf5jC2zZ88Ayk24fAnxs48LFANriRWQeqtUtGoqg2h+a9ISznENi3o6AcV6fLePCR9fGgUE6Fg==
X-Received: by 2002:aa7:8207:0:b0:576:7440:2478 with SMTP id k7-20020aa78207000000b0057674402478mr19328949pfi.51.1670341886129;
        Tue, 06 Dec 2022 07:51:26 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id a4-20020a17090a480400b001fe39bda429sm10974521pjh.38.2022.12.06.07.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:51:25 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2aE7-004dDy-Um;
        Tue, 06 Dec 2022 11:51:23 -0400
Date:   Tue, 6 Dec 2022 11:51:23 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y49k++D3i8DfLOLL@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com>
 <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca>
 <20221206135810.GA27689@lst.de>
 <Y49eObpI7QoSnugu@ziepe.ca>
 <20221206153811.GB2266@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206153811.GB2266@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 04:38:11PM +0100, Christoph Hellwig wrote:

> > We have locking issues in Linux SW connecting different SW drivers for
> > things that are not a PF/VF relationship, but perhaps that can be
> > solved.
> 
> And I think the only reasonable answer is that the entire workflow
> must be 100% managed from the controlling function, and the controlled
> function is just around for a ride, with the controlling function
> enabling/disabling it as needed without ever interacting with software
> that directly deals with the controlled function.

That is a big deviation from where VFIO is right now, the controlled
function is the one with the VFIO driver, it should be the one that
drives the migration uAPI components.

Adding another uAPI that can manipulate the same VFIO device from some
unrelated chardev feels wrong.

There are certain things that need to be co-ordinated for eveything to
work. Like you can't suspend the VFIO device unless you promise to
also stop MMIO operations. Stuff like FLR interfers with the migration
operation and has to be co-ordinated. Some migration operation
failures, like load failure, have to be healed through FLR.

It really does not want to be two different uAPIs even if that is
convenient for the kernel.

I'd much rather try to fix the problems PASID brings that try to make
this work :\

Jason
