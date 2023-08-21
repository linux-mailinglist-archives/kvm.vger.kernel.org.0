Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC0782F15
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbjHURHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbjHURHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:07:00 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5B0102
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:06:55 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-570b6e1a413so1211461eaf.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692637614; x=1693242414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VcpesrdOKBjIBH3tlZ3q44ls+ILnPyIbnyYqKr2W+dE=;
        b=i6Kb4H1cvgEso7109Gj9Y553yi7GSJelnA0xjnD/VxAY2DUlnrNnvON3JHvIfxm0tM
         Khe2hq6wX6BQKnboV5ic2Ud2ZF/0lJjL/6ybD+FZbFoyBmonG2o8OrcUvSPMJ/E0DU7Q
         Sm9u9VdsJcaR6XJk+XU5WXOCjz+L0eyorS9BupLzbzhhqGPNPdABoJl5zSI+K2C5t8S4
         u/QKDmkT+DtZrqFJ90SuPsJ+b/skNq3EtbseQZWSRoAjpFiXnxmpeykw/PtavxcZvoOH
         uFHR/4KkKRLb8Rh6ptTotGQknfASXOc9KV+D42hlAvVcxAPaSFKn4WI9BrKMAac1JOUh
         mM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692637614; x=1693242414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VcpesrdOKBjIBH3tlZ3q44ls+ILnPyIbnyYqKr2W+dE=;
        b=eK3uTy9/CSSCgw/tWlkjfariSukhKO5lCCAapqPBbWxAhKzfEqJutmpoEleKp9PCFK
         XrKBG/ggm7z7nxNCBlb8uYJvevP4jnIUc2tWfrs2TI4OMJzn+MsslykR19WbbiCsTWZY
         CcHJbFc/PAifNP9k/TDgPcStrMCRK2kVjQvR/HpSVzIQPNyXALP+wn/viXYq8jyDs/Vk
         Szdwbg721ASFY6Zq2uK3skNK4fd8rSTsBYCWuCAiiHjta2LBJ50ejwKT1vd/W5bj+Jau
         K9pR0vUa+CgHqh3Ul6DDrXZ3yGBO0ZHVfjjbJcz2Wc7yQtCyGrnOvrN/xgUYpFJ6x8JM
         5u7w==
X-Gm-Message-State: AOJu0YwD6n16893Akp/AFO4rYnO+PfGb/3oLHmwXtVWiWMkHc98BKAhH
        L5zHRs86PXAxpCir3rHx4XOPWA==
X-Google-Smtp-Source: AGHT+IG8X+l5Motw2UgXh3Pll87HnD6q0vanSSPX/5vtlKoHrD+t0K/F+xFSEdJ9OFLGAZ+9gB3oFw==
X-Received: by 2002:a05:6358:41a3:b0:134:dc90:b7d1 with SMTP id w35-20020a05635841a300b00134dc90b7d1mr5913387rwc.25.1692637614702;
        Mon, 21 Aug 2023 10:06:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id s8-20020a05622a1a8800b004035b79860dsm2455049qtc.81.2023.08.21.10.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 10:06:54 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qY8Mf-00Dv3E-Ob;
        Mon, 21 Aug 2023 14:06:53 -0300
Date:   Mon, 21 Aug 2023 14:06:53 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/11] iommu: Prepare for separating SVA and IOPF
Message-ID: <ZOOZrbb13QjGEJ9c@ziepe.ca>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
 <20230817234047.195194-8-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817234047.195194-8-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 07:40:43AM +0800, Lu Baolu wrote:
> Move iopf_group data structure to iommu.h. This is being done to make it
> a minimal set of faults that a domain's page fault handler should handle.
> 
> Add two new helpers for the domain's page fault handler:
> - iopf_free_group: free a fault group after all faults in the group are
>   handled.
> - iopf_queue_work: queue a given work item for a fault group.
> 
> This will simplify the sequential patches.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h      | 12 ++++++++++
>  drivers/iommu/io-pgfault.c | 49 ++++++++++++++++++++++----------------
>  2 files changed, 41 insertions(+), 20 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
