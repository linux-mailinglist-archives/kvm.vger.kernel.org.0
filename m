Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C060E7AA5AA
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 01:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjIUXeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 19:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjIUXeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 19:34:11 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAEBF7
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:34:04 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-6562330d68dso7998616d6.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 16:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695339243; x=1695944043; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GedEWxpKSzrGPRM6lMkTBIu3LFHKqvL1k9LSqu1VR6k=;
        b=nymOKQgkXMA6woRCS2H0juZvdrRpL3SW+Hf1u5ftOTpQecml4IebiIRPBVClQsXPed
         BNFiaS8IXnJIGWImNlm3WRQbQ0SyOTk+GXmdwOXUxgtWo6JhmLZGYYCBj4KN+hkTjuwg
         ildXGaYheLJ77IQq9L1kRtLhQzT0rT9M+D9pfQpirThrq6zXeLXuquifT3nn1MsD+V9s
         jRMGUdiu+5VFar6X+EBXMxtyqbkNhNUgYcHDZy19wPQYEK40oOowu68Z60kbhjyQw7vQ
         Fr99DnK7xfniqJMmiVLOITqDycMPhaJ+nq+jv7uyecRAXuyhzBzXPY81RoMH0v04nOZT
         NPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695339243; x=1695944043;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GedEWxpKSzrGPRM6lMkTBIu3LFHKqvL1k9LSqu1VR6k=;
        b=L8BjePHCCjanTpQoyIhmOy7bfEj41+CdynCHptcywC+3Rws4+KBGgX743xglTaP2LU
         7WRGtwmdw14ljUNBSO3GvAEuQjiW+hlTrTfZ8QbgerKPPfZQk+epifFTXWKOytUNPVHL
         +gos1QgKDUDfIoi7OtBVc0iq1P8o2TmKbguL/lMgY0wqsf5LEIXCZ6v+x6BQxkNYmc3R
         O4xcIfLHwNpuq3qEnGyHNcbVBVtfSu+xM97/rvXv2orAv1oN2a0ZDWA/J0NPu5iblSY0
         9t+IOboSNyci9PzO5DHgLcynTiOsBVG4m9EvxPdgb2y/SFBR0pM/lRs0QyjTmVhBx0Ot
         nhKQ==
X-Gm-Message-State: AOJu0Yw+wBqRGk/MClWOdKUeLflUvRULe54FDThQXkiX6bG4F1wI+6F8
        XYdMi0Uj8v5j3ol4sth3QN7olQ==
X-Google-Smtp-Source: AGHT+IGyPvvaH53YFg/+nfLkgh+wJ6GTD1U2RciFZyYgWxuFiG/EgPxEd0ck5941lJVaQIWktR+A+g==
X-Received: by 2002:a05:6214:4602:b0:658:310c:f6ca with SMTP id oq2-20020a056214460200b00658310cf6camr7598389qvb.42.1695339243709;
        Thu, 21 Sep 2023 16:34:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id o3-20020a0ce403000000b006263a9e7c63sm947595qvl.104.2023.09.21.16.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 16:34:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qjTBK-000Uup-Kq;
        Thu, 21 Sep 2023 20:34:02 -0300
Date:   Thu, 21 Sep 2023 20:34:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Liu, Jingqi" <jingqi.liu@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/12] iommu: Make iommu_queue_iopf() more generic
Message-ID: <20230921233402.GC13795@ziepe.ca>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-10-baolu.lu@linux.intel.com>
 <f20b9e78-3a63-ca3e-6c04-1d80ec857898@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f20b9e78-3a63-ca3e-6c04-1d80ec857898@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 11:25:56PM +0800, Liu, Jingqi wrote:
> 
> On 9/14/2023 4:56 PM, Lu Baolu wrote:
> > Make iommu_queue_iopf() more generic by making the iopf_group a minimal
> > set of iopf's that an iopf handler of domain should handle and respond
> > to. Add domain parameter to struct iopf_group so that the handler can
> > retrieve and use it directly.
> > 
> > Change iommu_queue_iopf() to forward groups of iopf's to the domain's
> > iopf handler. This is also a necessary step to decouple the sva iopf
> > handling code from this interface.
> > 
> > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > ---
> >   include/linux/iommu.h      |  4 ++--
> >   drivers/iommu/iommu-sva.h  |  6 ++---
> >   drivers/iommu/io-pgfault.c | 49 ++++++++++++++++++++++++++++----------
> >   drivers/iommu/iommu-sva.c  |  3 +--
> >   4 files changed, 42 insertions(+), 20 deletions(-)
> > 
> ......
> 
> > @@ -112,6 +110,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
> >   {
> >   	int ret;
> >   	struct iopf_group *group;
> > +	struct iommu_domain *domain;
> >   	struct iopf_fault *iopf, *next;
> >   	struct iommu_fault_param *iopf_param;
> >   	struct dev_iommu *param = dev->iommu;
> > @@ -143,6 +142,19 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
> >   		return 0;
> >   	}
> > +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
> > +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
> > +	else
> > +		domain = iommu_get_domain_for_dev(dev);
> > +
> > +	if (!domain || !domain->iopf_handler) {
> 
> Does it need to check if 'domain' is error ?  Like below:
> 
>          if (!domain || IS_ERR(domain) || !domain->iopf_handler)

Urk, yes, but not like that

The IF needs to be moved into the else block as each individual
function has its own return convention.

Jason
