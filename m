Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB23240ED40
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 00:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbhIPWUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 18:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240917AbhIPWUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 18:20:17 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6E3C061574
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 15:18:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u4so7084362qta.2
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 15:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jg0fjI4mzvpqL26OKbCWQCPKXFmy+FcW+lRA5Qu3IKk=;
        b=QHAKQiGB2K/b8XTJLTLdRdDzwcDFi2l43y7S4X2N5dF72a1otcWInJHcMMxQ3Ls16W
         TaTUYiDEmp8l2T+cS3bknCTa6n3Ua2LiiG8M1aqv/DcLGrJv3IywZC+36eDnWPY2SPyn
         2AW8eyI1ceKG8UrFcGhH2js9h+X+3mS+pADMglyrx6NmNC35nuVp1UcCrDmwwiqnzkNo
         MbEhuX6NBdtTgy5nk3tTg6/CnsIhe4Q5YAQpHhvCkLFZbt7t4JZHw9kB3YfG9HyaoRXJ
         CA79k3hMf9e4+rccpBhqQh9Dh+EGdDW5I425nDarVbx+LQA2E7XsOLWma7O6ouIDwhyo
         NfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jg0fjI4mzvpqL26OKbCWQCPKXFmy+FcW+lRA5Qu3IKk=;
        b=Jz+aSQkz+PHvcXXB6b6UxTUiM95ov4FPJl68jP+ql0Xys3cv+vFMoI0U03zK25A3vO
         GzhejW3AxWUZjLIzyfrbIt0NHt0VexFjL0oAT7L0H9p1UGc4n3WFAWfEG3oIoIrakA3N
         G3aQdM97JF+l3ZT7sTfth41f3hduvgi6xKYXiQIY9Pj9hq/FYivxmGsBiw40iV4u0mtl
         LOldC6ny3/n3bjbb6Ml8pmlQp+zgyvCEx/FqxITQES8AG/4q08OlPCEcdWT9OLMo0MbY
         nJNegZLrGK5158B13r8ltF28IewBwx9tCh4nLHTRrqledQkuUiPHmuj+0yxedvoatzUC
         MW9w==
X-Gm-Message-State: AOAM531dHkEjTqOprFSXBupVTv4drJfotmdPy8e1Uv1qPo24wtpDfHjS
        qst4W76LfKnUFAMb9OGwgeOF1A==
X-Google-Smtp-Source: ABdhPJzClgP2WLrg1toGycJU63Bp0qKrn9vg2BPbmvW5HYeX2aILTcy13XfFqdIpRKeQFsYJ3HdS/Q==
X-Received: by 2002:ac8:7b52:: with SMTP id m18mr7620868qtu.128.1631830735505;
        Thu, 16 Sep 2021 15:18:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id 69sm3875425qke.55.2021.09.16.15.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 15:18:54 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mQziY-001tUD-9l; Thu, 16 Sep 2021 19:18:54 -0300
Date:   Thu, 16 Sep 2021 19:18:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210916221854.GT3544071@ziepe.ca>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-12-hch@lst.de>
 <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 17, 2021 at 01:25:59AM +0530, Kirti Wankhede wrote:
> 
> 
> On 9/13/2021 12:46 PM, Christoph Hellwig wrote:
> > Pass the group flags to ->attach_group and remove the messy check for
> > the bus type.
> > 
> 
> I like the way vfio_group_type is used in this patch, that removes messy way
> to call symbol_get(mdev_bus_type).
> 
> Any thoughts on how VFIO_IOMMU, i.e. IOMMU backed mdev, can be implemented?
> 
> For IOMMU backed mdev, mdev->dev->iommu_group should be same as
> mdev->type->parent->dev->iommu_group or in other words, parent device would
> be DMA alias for the mdev device with the restriction - single mdev device
> can be created for the physical device. Is it possible to link iommu_group
> of these two devices some way?

You just use the new style mdev API and directly call
vfio_register_group_dev and it will pick up the
parent->dev->iommu_group naturally like everything else using physical
iommu groups.

Jason
