Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B080F7700E0
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 15:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjHDNMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 09:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjHDNMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 09:12:48 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8DF13D
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 06:12:47 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-63d2b7d77bfso12820626d6.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 06:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691154766; x=1691759566;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K5KeRI+SV1FCdpo3Xm/MnSKW39DtNUa4J2xurlzsahs=;
        b=IV7GHcIKmZuxG3dyOGK5NSIu9+sKjxUkR65EvD7EZVUlCnDTUb4zpV0EyPOxAPz4rr
         ZiiX6SmaxndN66cnOxfAgguAT8sXtMb1vIjyN6+sA3+ujAI/i5B9NZHZ21cQK0nTRfby
         JLFJi/j0nePnANK5s73Cp8Sqa6HwTgakv+G5n5K6KxL2pfnrURAhLGBhki6HhKSDPm/1
         bhR5qb9ayVrxTMweB+O7LY/MJ4taGgPFsXA5RLI1a3YmegkVF9/j4R0MG2b5opW4VAAG
         y79Io8bJkai1bWFpk43xD1qdnJfihqFaAekNEfL2CD1y2wktCHlIPFk3GimDB2C+VWaV
         8k5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691154766; x=1691759566;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5KeRI+SV1FCdpo3Xm/MnSKW39DtNUa4J2xurlzsahs=;
        b=b9hErm7o5VBKpB+RlqbuUTVuBpCEqolJ6uVbIhmZLjDee19BcvJ+GRE9Mg9QOIA62m
         OpqD6lU3zhxfnFhWjLUTdv5vuPmLS0H8taTOQ8nnkGaBR0FhpFY7UrQnR3OwXUjS9wlA
         oVAWI9mM7Q4Y6hLhJ/XfPJd4/Q4oM+5rDgz6Le4baSZTlpNgXKrqerINOPPhwsRD8TY9
         EI/qRM/sC3SqN+x+VbVSieJtvS7s6EJm8XHlw5LlGPCMGI1datQeBtg6qgf8v2e+WeGM
         eqji+5vYPxgWuoTkoKtrAkwYjzADv7IMfPvNcOVlUGdPGU3p+WmyjwGH79RrWIXH3z/D
         isAA==
X-Gm-Message-State: AOJu0YzMx+i0yLg3aWjL78UynwE0SFPPdjIY+4wr4F26Cei3yJKElIHx
        pStz1Jua+U+Ycbf3iXAW6rja1PvuU/P9YC3lLDg=
X-Google-Smtp-Source: AGHT+IGI3w7HNaf+cHB70oPi/jS31g9ivt3CUdAgCt2wy35N+pxVe6WQ2Vi5iLY+Mv94CNY4L4Uelg==
X-Received: by 2002:ad4:5945:0:b0:635:e368:1c70 with SMTP id eo5-20020ad45945000000b00635e3681c70mr1975728qvb.43.1691154766271;
        Fri, 04 Aug 2023 06:12:46 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id w19-20020a0cdf93000000b0062de6537febsm656462qvl.58.2023.08.04.06.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 06:12:45 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qRubl-003ial-5v;
        Fri, 04 Aug 2023 10:12:45 -0300
Date:   Fri, 4 Aug 2023 10:12:45 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] iommu: Make pasid array per device
Message-ID: <ZMz5TVrFvGf4jPCa@ziepe.ca>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <ZMplBfgSb8Hh9jLt@ziepe.ca>
 <BN9PR11MB527649D7E79E29291DA1A5538C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZMvFR52o86upAVrp@ziepe.ca>
 <15c6f634-f00a-dfa7-9759-161ec201460a@linux.intel.com>
 <ff357c87-f554-d89c-ce0e-e38886374da5@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff357c87-f554-d89c-ce0e-e38886374da5@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 10:30:12AM +0800, Baolu Lu wrote:
> On 2023/8/4 10:20, Baolu Lu wrote:
> > On 2023/8/3 23:18, Jason Gunthorpe wrote:
> > > On Thu, Aug 03, 2023 at 12:44:03AM +0000, Tian, Kevin wrote:
> > > > > From: Jason Gunthorpe<jgg@ziepe.ca>
> > > > > Sent: Wednesday, August 2, 2023 10:16 PM
> > > > > 
> > > > > On Tue, Aug 01, 2023 at 02:31:23PM +0800, Lu Baolu wrote:
> > > > > > The PCI PASID enabling interface guarantees that the
> > > > > > address space used
> > > > > > by each PASID is unique. This is achieved by checking that the PCI ACS
> > > > > > path is enabled for the device. If the path is not enabled, then the
> > > > > > PASID feature cannot be used.
> > > > > > 
> > > > > >      if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
> > > > > >              return -EINVAL;
> > > > > > 
> > > > > > The PASID array is not an attribute of the IOMMU group. It is more
> > > > > > natural to store the PASID array in the per-device IOMMU data. This
> > > > > > makes the code clearer and easier to understand. No functional changes
> > > > > > are intended.
> > > > > Is there a reason to do this?
> > > > > 
> > > > > *PCI*  requires the ACS/etc because PCI kind of messed up how switches
> > > > > handled PASID so PASID doesn't work otherwise.
> > > > > 
> > > > > But there is nothing that says other bus type can't have working
> > > > > (non-PCI) PASID and still have device isolation issues.
> > > > > 
> > > > > So unless there is a really strong reason to do this we should keep
> > > > > the PASID list in the group just like the domain.
> > > > > 
> > > > this comes from the consensus in [1].
> > > > 
> > > > [1]https://lore.kernel.org/linux-iommu/ZAcyEzN4102gPsWC@nvidia.com/
> > > That consensus was that we don't have PASID support if there is
> > > multi-device groups, at least in iommufd.. That makes sense. If we
> > > want to change the core code to enforce this that also makes sense
> > 
> > In my initial plan, I had a third patch that would have enforced single-
> > device groups for PASID interfaces in the core. But I ultimately dropped
> > it because it is the fact for PCI devices, but I am not sure about other
> > buses although perhaps there is none.
> > 
> > > But this series is just moving the array?
> > 
> > So I took the first step by moving the pasid_array from iommu group to
> > the device. 😄
> 
> In my mind, iommu_group was introduced to solve the PCI alias and P2P
> transactions which bypass IOMMU translation. When we enter the PASID
> world, the architecture should disallow these anymore. Hence, it's safe
> to move pasid_array to device.
> 
> This was the motivation of this series.

I think you should add a protection as well, directly prevent
multi-device groups being used with pasid.

Jason
