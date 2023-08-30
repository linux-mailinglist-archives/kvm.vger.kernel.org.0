Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF178D93D
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbjH3Scj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244270AbjH3Mt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 08:49:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50078185
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 05:49:24 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-31c5c06e8bbso4662783f8f.1
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 05:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693399763; x=1694004563; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=icItx3AAoUpU7OYRWsoDm1Wmtkp4XHu2/zCUAdAv9gQ=;
        b=TXIwL0vczLsOzeT9kYFOIfoIiOUJ4+zDFqAmhxTXWXLQc4LBWY5rbf6udQ/b1SlTeU
         b/I/ZfTRDsq5wN2a6kqhhx68xCGuglwHFqU7Yuogo30bJRALBuQa7BOizre6CEKDut++
         zHW+XnssN7ga+qa0keUmxkZgL4ashpBohmY3wakR8ZmYYJNtsIK08RpJyZPG9dEQkeJp
         FbUPOwgc8KpdjPwUfbDfDFonZaLEMiaDMVRHPJvx1qnaqnigfcl52fdhBUjBZjhZSRsq
         7KN8uOiMiV+BPHIv3SU1sy+i4GcqXVro+9hxkAeClvRPxFHYMQ1AkxZfqtKKoKYD2TSm
         xnSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693399763; x=1694004563;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=icItx3AAoUpU7OYRWsoDm1Wmtkp4XHu2/zCUAdAv9gQ=;
        b=i7HJK74KsIulHJ9b7f3gV3hj1S9nkV2vIWmbwI9IRxFnc3VMryJqDLoYBvXsSPJD9v
         4Tu0B3K83ileMVkdh3gys9SzG5dkqxHyotqYcYnj9c8XZaH1L/pl+LJUZqaUBP3EUd3V
         Q6lnEvzxWjs0IHPpJMvOsDSWITDOaybPi42yKSeOPAOqDejBxECiEnUjo0XFK5HGJydR
         rYVC6XRJOytKM7O2Ww7Q3eYEVIv9g4LPpsnMMOSiU62stTNT7XRppo+J5oxBf0IKicGy
         Dk6WLn+g1KlzsVWu0BZhz5Fb6690KnQxcOm8h688oL5cj9THn3knaeJEb4NyZJkwQnH7
         S2XQ==
X-Gm-Message-State: AOJu0YwworRhfjfcrDNpjLlOHJuGkLmWZ7IX/Or6rdi9OgbcLIKrSYoy
        WJmGeX9JBrstnPV2/8Glaxw71A==
X-Google-Smtp-Source: AGHT+IFlrU3LzNvhPuoIhYIOnZuXm+ouW+s6lNZGIAycwz4s7bnL1qAxU7DUK56J7UtJR+G7QVKLVA==
X-Received: by 2002:adf:efc7:0:b0:319:6d91:28bf with SMTP id i7-20020adfefc7000000b003196d9128bfmr1741339wrp.60.1693399762716;
        Wed, 30 Aug 2023 05:49:22 -0700 (PDT)
Received: from myrica ([2.220.83.24])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d6609000000b0030647449730sm16542269wru.74.2023.08.30.05.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 05:49:22 -0700 (PDT)
Date:   Wed, 30 Aug 2023 13:49:19 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Vasant Hegde <vasant.hegde@amd.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Message-ID: <20230830124919.GA2855675@myrica>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a4fc5fa2-a234-286b-e108-7f54a7c70862@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4fc5fa2-a234-286b-e108-7f54a7c70862@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023 at 04:32:47PM +0530, Vasant Hegde wrote:
> Tian, Baolu,
> 
> On 8/30/2023 1:13 PM, Tian, Kevin wrote:
> >> From: Baolu Lu <baolu.lu@linux.intel.com>
> >> Sent: Saturday, August 26, 2023 4:01 PM
> >>
> >> On 8/25/23 4:17 PM, Tian, Kevin wrote:
> >>>> +
> >>>>   /**
> >>>>    * iopf_queue_flush_dev - Ensure that all queued faults have been
> >>>> processed
> >>>>    * @dev: the endpoint whose faults need to be flushed.
> >>> Presumably we also need a flush callback per domain given now
> >>> the use of workqueue is optional then flush_workqueue() might
> >>> not be sufficient.
> >>>
> >>
> >> The iopf_queue_flush_dev() function flushes all pending faults from the
> >> IOMMU queue for a specific device. It has no means to flush fault queues
> >> out of iommu core.
> >>
> >> The iopf_queue_flush_dev() function is typically called when a domain is
> >> detaching from a PASID. Hence it's necessary to flush the pending faults
> >> from top to bottom. For example, iommufd should flush pending faults in
> >> its fault queues after detaching the domain from the pasid.
> >>
> > 
> > Is there an ordering problem? The last step of intel_svm_drain_prq()
> > in the detaching path issues a set of descriptors to drain page requests
> > and responses in hardware. It cannot complete if not all software queues
> > are drained and it's counter-intuitive to drain a software queue after 
> > the hardware draining has already been completed.
> > 
> > btw just flushing requests is probably insufficient in iommufd case since
> > the responses are received asynchronously. It requires an interface to
> > drain both requests and responses (presumably with timeouts in case
> > of a malicious guest which never responds) in the detach path.
> > 
> > it's not a problem for sva as responses are synchrounsly delivered after
> > handling mm fault. So fine to not touch it in this series but certainly
> > this area needs more work when moving to support iommufd. 😊
> > 
> > btw why is iopf_queue_flush_dev() called only in intel-iommu driver?
> > Isn't it a common requirement for all sva-capable drivers?

It's not needed by the SMMUv3 driver because it doesn't implement PRI yet,
only the Arm-specific stall fault model where DMA transactions are held in
the SMMU while waiting for the OS to handle IOPFs. Since a device driver
must complete all DMA transactions before calling unbind(), with the stall
model there are no pending IOPFs to flush on unbind(). PRI support with
Stop Markers would add a call to iopf_queue_flush_dev() after flushing the
SMMU PRI queue [2].

Moving the flush to the core shouldn't be a problem, as long as the driver
gets a chance to flush the hardware queue first.

Thanks,
Jean

[2] https://jpbrucker.net/git/linux/commit/?h=sva/2020-12-14&id=bba76fb4ec631bec96f98f14a6cd13b2df81e5ce

> 
> I had same question when we did SVA implementation for AMD IOMMU [1]. Currently
> we call queue_flush from remove_dev_pasid() path. Since PASID can be enabled
> without ATS/PRI, I thought its individual drivers responsibility.
> But looking this series, does it make sense to handle queue_flush in core layer?
> 
> [1]
> https://lore.kernel.org/linux-iommu/20230823140415.729050-1-vasant.hegde@amd.com/T/#t
> 
> -Vasant
> 
> 
