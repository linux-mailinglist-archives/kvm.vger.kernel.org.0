Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026F84E9D4A
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 19:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbiC1RTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 13:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240270AbiC1RTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 13:19:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF84D63BE1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648487848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFq5xIrtlE0LH/UrNTPMMjVa4bF/UcCC/THRar2iFcc=;
        b=gYycaqy+kr9Hgk4v828zE/JcBThfT+uoZrvv0kaLgcncaGTbC6jdv6bWy9VfDdA6XtxBgb
        LA0gjOQ18yfc397IhDhzT7bBQ2kDy4M2dlY9fElaDq0kbauXBSg4PixJDoiaAu3K3Wl/aJ
        PC6uNBXA9JqEvPtlFMUWB9bX9Dkoc4A=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-h-rU1GDRPKi-Q_W234syFg-1; Mon, 28 Mar 2022 13:17:26 -0400
X-MC-Unique: h-rU1GDRPKi-Q_W234syFg-1
Received: by mail-il1-f197.google.com with SMTP id m16-20020a928710000000b002c7be7653d1so8191607ild.4
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kFq5xIrtlE0LH/UrNTPMMjVa4bF/UcCC/THRar2iFcc=;
        b=hHedguECOyCF9biVJDaSIJ1+cmnc6N+uyqoTpZgZFSslSJl8zhmgOd14FxaYGZ1pil
         4c5RJfeOSGeIFXFsPzkeEKTJHb4Z5Nt+BkdOd9iFjJviyFPZ3xxIZi/zjfSEqVW4NbnH
         NqBuGFpLyOTSVvdeL3604czDNeEIk+smSn6R833zXJyBstZSouY7POgr5DJR/V+xvk6x
         0Nz9qz1+GKU4pyQovz91kSr44p8Q7FFwx7TnItTz3rnL7EjxXe5KxXA7LZHGXwVwCM1x
         scQcqvjy9tE8e7jckGlUx4pCBv8vcA5Px0ZsW8q048m2Zvnf5QlvGA1S07KbWg9foznf
         KExg==
X-Gm-Message-State: AOAM530fe9A7TGX3czNAEKcEY4WG3m53nJV4fGkz8icU7i4u8ZFQ4+EJ
        PE/ToUUJypBrR/P+GcDRoc9KqsTVlNWV+BQMGGvnXssOkke+22hSqY2yqIKaSyvDVIzgBWRWAvA
        aMyyN+34/BBV1
X-Received: by 2002:a05:6602:2494:b0:64c:86a7:9fe9 with SMTP id g20-20020a056602249400b0064c86a79fe9mr1305003ioe.171.1648487845630;
        Mon, 28 Mar 2022 10:17:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRWO2iQoEBPA6dqLLt3lHbvXF79rpJ35GLftd2YlzpdVdpYHvZvRm2FU0alz72N0akwN5Zzg==
X-Received: by 2002:a05:6602:2494:b0:64c:86a7:9fe9 with SMTP id g20-20020a056602249400b0064c86a79fe9mr1304982ioe.171.1648487845379;
        Mon, 28 Mar 2022 10:17:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c6-20020a056e020bc600b002c6731e7cb8sm7563658ilu.31.2022.03.28.10.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 10:17:25 -0700 (PDT)
Date:   Mon, 28 Mar 2022 11:17:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220328111723.24fa5118.alex.williamson@redhat.com>
In-Reply-To: <20220324134622.GB1184709@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <20220323131038.3b5cb95b.alex.williamson@redhat.com>
        <20220323193439.GS11336@nvidia.com>
        <20220323140446.097fd8cc.alex.williamson@redhat.com>
        <20220323203418.GT11336@nvidia.com>
        <20220323225438.GA1228113@nvidia.com>
        <BN9PR11MB5276EB80AFCC3003955A46248C199@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220324134622.GB1184709@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Mar 2022 10:46:22 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Mar 24, 2022 at 07:25:03AM +0000, Tian, Kevin wrote:
> 
> > Based on that here is a quick tweak of the force-snoop part (not compiled).  
> 
> I liked your previous idea better, that IOMMU_CAP_CACHE_COHERENCY
> started out OK but got weird. So lets fix it back to the way it was.
> 
> How about this:
> 
> https://github.com/jgunthorpe/linux/commits/intel_no_snoop
> 
> b11c19a4b34c2a iommu: Move the Intel no-snoop control off of IOMMU_CACHE
> 5263947f9d5f36 vfio: Require that device support DMA cache coherence

I have some issues with the argument here:

  This will block device/platform/iommu combinations that do not
  support cache coherent DMA - but these never worked anyhow as VFIO
  did not expose any interface to perform the required cache
  maintenance operations.

VFIO never intended to provide such operations, it only tried to make
the coherence of the device visible to userspace such that it can
perform operations via other means, for example via KVM.  The "never
worked" statement here seems false.

Commit b11c19a4b34c2a also appears to be a behavioral change.  AIUI
vfio_domain.enforce_cache_coherency would only be set on Intel VT-d
where snoop-control is supported, this translates to KVM emulating
coherency instructions everywhere except VT-d w/ snoop-control.

My understanding of AMD-Vi is that no-snoop TLPs are always coherent, so
this would trigger unnecessary wbinvd emulation on those platforms.  I
don't know if other archs need similar, but it seems we're changing
polarity wrt no-snoop TLPs from "everyone is coherent except this case
on Intel" to "everyone is non-coherent except this opposite case on
Intel".  Thanks,

Alex

> eab4b381c64a30 iommu: Restore IOMMU_CAP_CACHE_COHERENCY to its original meaning
> 2752e12bed48f6 iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY with dev_is_dma_coherent()
> 
> If you like it could you take it from here?
> 
> Thanks,
> Jason
> 

