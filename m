Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B2D76EDE2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 17:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbjHCPSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 11:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbjHCPSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 11:18:41 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDD43581
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 08:18:34 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-63d23473ed5so6418616d6.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 08:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691075913; x=1691680713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SrtWuwZhdNs/bI8zWxTP33Nw+h1qasK2MRKJMmMYr/4=;
        b=E1UK52reFDWJj91FF3IhG6fofZVbBF1CMu5AUmA5P/aBTeF9EmL0e2Ag/uQ5mZtDqB
         vM1ktCfSpCslIJUeRsI5CPu84J+jDsQzMphrSBkYyp3X05AKPm/DhlNTtjREshESZLoY
         /X505RGgObdxBJETvDhXwAqWrs6Y/Zw6pcMSBBDlPnnikOwEY+tYFbugc+CMBzwdzGle
         Eaq+5KQTkPm4awjEV4gjVbPU1TS0hKOMsWitpFbSK9/dJ96r9HIIpOEnYO+zBdUwtda3
         yGQh3rd0OidzYP0sAG5PADUjrdFpKL7F5i8T3iPDnz2i1uf+QS6jkNZ5Yuer9Mb9hcdz
         nsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691075913; x=1691680713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrtWuwZhdNs/bI8zWxTP33Nw+h1qasK2MRKJMmMYr/4=;
        b=Ts+s/g1Iu+8a+ZOwu2JgH+A5sluq5txGrXiZcSrc5bAXBkcHfZhlAGJ8dLlRLrwkjE
         cZAWetY9UfMiTWCIBBR7ceJR+Cjf0ym46m/+11r5HUYVYBx7t0DP7L0IRU2la5q8qdqF
         hiCFPbHqQ35H9DmY3LispsuYfV4OdjMPb4QiP1K5YCP8FK7E+NmkT01dN3t/i/OuDaIQ
         NUTr7QiGOH8wD2oPYcUStOKEypeD6UJOYPhRiFax7q2A5cIqnNw+WR44YnI8SProb3xJ
         tIH6DVCnqvT9/AqtIFz7Jpfo7fh5jil8PCIGsB9QlmbMAxjpvFq6wp4/z02Tp7UBvlWp
         IZsA==
X-Gm-Message-State: ABy/qLbQcqbliryeRnBoA8sOEZBqWgYguvK9YfV4Is7s6UJOBaYgZes1
        wJVX8gB1q0p0TX7MvjTEe0hH/A==
X-Google-Smtp-Source: APBJJlH/rA99J/7CA7uo7xtFqI8WroRHA9x/isWbdJj2w0aHTXtpvbyBT3+lsZq9lWIGy9l3uiwCWw==
X-Received: by 2002:a05:6214:3011:b0:63d:25f:71af with SMTP id ke17-20020a056214301100b0063d025f71afmr20256559qvb.60.1691075913346;
        Thu, 03 Aug 2023 08:18:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id b9-20020a0cc989000000b0063d4890b6cdsm5599822qvk.145.2023.08.03.08.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 08:18:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qRa5v-003YnM-85;
        Thu, 03 Aug 2023 12:18:31 -0300
Date:   Thu, 3 Aug 2023 12:18:31 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
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
Message-ID: <ZMvFR52o86upAVrp@ziepe.ca>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <ZMplBfgSb8Hh9jLt@ziepe.ca>
 <BN9PR11MB527649D7E79E29291DA1A5538C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527649D7E79E29291DA1A5538C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 12:44:03AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Wednesday, August 2, 2023 10:16 PM
> > 
> > On Tue, Aug 01, 2023 at 02:31:23PM +0800, Lu Baolu wrote:
> > > The PCI PASID enabling interface guarantees that the address space used
> > > by each PASID is unique. This is achieved by checking that the PCI ACS
> > > path is enabled for the device. If the path is not enabled, then the
> > > PASID feature cannot be used.
> > >
> > >     if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
> > >             return -EINVAL;
> > >
> > > The PASID array is not an attribute of the IOMMU group. It is more
> > > natural to store the PASID array in the per-device IOMMU data. This
> > > makes the code clearer and easier to understand. No functional changes
> > > are intended.
> > 
> > Is there a reason to do this?
> > 
> > *PCI* requires the ACS/etc because PCI kind of messed up how switches
> > handled PASID so PASID doesn't work otherwise.
> > 
> > But there is nothing that says other bus type can't have working
> > (non-PCI) PASID and still have device isolation issues.
> > 
> > So unless there is a really strong reason to do this we should keep
> > the PASID list in the group just like the domain.
> > 
> 
> this comes from the consensus in [1].
> 
> [1] https://lore.kernel.org/linux-iommu/ZAcyEzN4102gPsWC@nvidia.com/

That consensus was that we don't have PASID support if there is
multi-device groups, at least in iommufd.. That makes sense. If we
want to change the core code to enforce this that also makes sense

But this series is just moving the array?

Jason
