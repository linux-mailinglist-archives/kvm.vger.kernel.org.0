Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022CF777E8E
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 18:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbjHJQq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 12:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjHJQq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 12:46:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A5A10C4
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 09:46:27 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-686b91c2744so852043b3a.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 09:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691685987; x=1692290787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JMdp77jhwQvRcl315BSI++IxT1Tx9GaLgh40mJ/tAaA=;
        b=XgY1GFMxDZl3teOz42X6UjqkluiZg/uKErMnjqTIM5rvepjjsiaFeJai7WPmjDbm23
         90hN2MYy9mOlOX7CRvcheExTVUo+FDhygE76i/MCEjL0KeQIeEiSgOC92wAkDZ+6oUTj
         kfQj/fws8sgY3uZJbz/rFhRrGAOcg2nCYgH7zRMp6cxhVqtJttBtHiy6/MVpNojdoDJQ
         zy5H6tPr2h9qXphV1DICqMWO3H0RL6zfUsD1ZIM2X18or2uuUykq50tDIUNude51aQV3
         Cwi09gaWtU3Q+0iNV0KOFxyBEhDK3AXf06PV/DKqwJgUebLzFflPgu0UuAVf6DJ42X87
         04cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691685987; x=1692290787;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMdp77jhwQvRcl315BSI++IxT1Tx9GaLgh40mJ/tAaA=;
        b=lq1hGSWUYMqSgbPIs050dq2gmu6WeIJKWKu7B1wAkhHgkoxqRB1eXohRoSHYudOfiY
         nB0l+aGQ4CLhPN+GU7uFpryBGAZ9zCEBaADESPAA0o9LiHgZjSbGdJf1tTU7GNC5lfVp
         3Se8tSh/ekaiL+UfC+EitAQNJ2U6xH0FSX9hOZJLeq4oa9hZA0QNoOhYFXSf1zrRsoJ/
         9FHtd+JQe/cUOGBQcpqxIDkBNomp63zZfrqIOtvwiz1fZ58WUX4EchBOWcKzZIZRj0nA
         SyppsJLspDYezyiqDzE8NIl/CF4KH1EvV/PduoQQqq+3PHhvb7JNBNo1bdibU9rFTNNq
         7HIg==
X-Gm-Message-State: AOJu0Yw5PpWIcb9cvrIw+UzkB7gbzF3U1y1CwNUP1xGJAvYYiuks5Js/
        p5iohXyxsKCXKXWl9hc1UItAmg==
X-Google-Smtp-Source: AGHT+IFF/d8fCJaxRw5PJDuRon+tGXvjwpsZXLOglZ8RskEhE9kyxcV6qwckv9qPdLj+bfxpXnUDgg==
X-Received: by 2002:a05:6a00:2305:b0:668:99aa:3f17 with SMTP id h5-20020a056a00230500b0066899aa3f17mr3362615pfh.16.1691685987356;
        Thu, 10 Aug 2023 09:46:27 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7870f000000b006871bea2eeesm1753718pfo.34.2023.08.10.09.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:46:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qU8np-005H6d-0d;
        Thu, 10 Aug 2023 13:46:25 -0300
Date:   Thu, 10 Aug 2023 13:46:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Message-ID: <ZNUUYR9WGf475Q4L@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
 <ZNPF/nA2JdqHMM10@ziepe.ca>
 <28d86414-d684-b468-d0a9-5c429260e081@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28d86414-d684-b468-d0a9-5c429260e081@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 10:27:21AM +0800, Baolu Lu wrote:
> On 2023/8/10 0:59, Jason Gunthorpe wrote:
> > On Thu, Jul 27, 2023 at 01:48:28PM +0800, Lu Baolu wrote:
> > > The unrecoverable fault data is not used anywhere. Remove it to avoid
> > > dead code.
> > > 
> > > Suggested-by: Kevin Tian<kevin.tian@intel.com>
> > > Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
> > > ---
> > >   include/linux/iommu.h | 70 +------------------------------------------
> > >   1 file changed, 1 insertion(+), 69 deletions(-)
> > Do we plan to bring this back in some form? A driver specific fault
> > report via iommufd?
> 
> I can hardly see the possibility.
> 
> The only necessary dma fault messages are the offending address and the
> permissions. With these, the user space device model software knows that
> "a DMA fault was generated when the IOMMU hardware tried to translate
> the offending address with the given permissions".
> 
> And then, the device model software will walk the page table and figure
> out what is missed before injecting the vendor-specific fault messages
> to the VM guest.

Avoiding walking the page table sounds like a pretty big win if we
could manage it by forwarding more event data..

Jason
