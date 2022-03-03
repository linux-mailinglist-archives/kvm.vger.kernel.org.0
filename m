Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB434CC6B0
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiCCUAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 15:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235919AbiCCUAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 15:00:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 072A81A39F5
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646337575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KII+3wpRDYxBkpQXpVqXMzOFERtKv6nriOIaVlE+FgA=;
        b=e4la4o4F/CjnnmOTc5nyzmdjBuqpUZ+5F6CatK2llCme4+kY09mVePKVS0/q8PWZpL9l/V
        b6zCIwEduD9TJBD4JVuxJ/1/LCG4Ad5wrvy8t5o5JDSk0KBVxTcthzwcG/k2vNwqO2aFbk
        UYqCcfjzhW7FZ9PWV2kzyPwvploMVlA=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-3jn-xQl9Pam4hHI-pqJIcw-1; Thu, 03 Mar 2022 14:59:34 -0500
X-MC-Unique: 3jn-xQl9Pam4hHI-pqJIcw-1
Received: by mail-ot1-f70.google.com with SMTP id m24-20020a9d4c98000000b005af3b88a817so4257718otf.14
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 11:59:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KII+3wpRDYxBkpQXpVqXMzOFERtKv6nriOIaVlE+FgA=;
        b=TZ/SdZzE++nL9cLhpWbagTxcWXrbPmJjacbBowqTccyTtVhB73UToWGGi2dB6OOGwQ
         SgeRJJ4VbDo7ug198Sg5JKx/nnp54f2vwnD4j6xQCZWbveBrOfEzjbeqXiv82W1pcdab
         1RJbUzcCdxVBgQCca/buQHlDJiiujdbVWrhL6tkm+49QAA8gnTaqFNmpLEzWvCtMMSK8
         rmrd12KU1eTdaVKovajoTDd6oQkQLpfVTxQ0jFrD7HGD7Myh2iyPBKNItaG6NFo9nm/F
         4/+k2ylp7hLbMxuadOsScLcfJQ3wCJzsMMAFZ7hSbrEQGSgGBMgvi/YpvcCSgxMS5Jet
         EpQw==
X-Gm-Message-State: AOAM530nw65/Ir8grmobQxDMadU08BJk3sPckOtkIYzo6Am5VJ2aSn9w
        tVdx/ukSBj/7C8EIXX9smMshZkPV40LxDpCfhFejA2s/v0+jGphl5uldaqjBJ6mDMDmbdbJkdU8
        hUq2nXZE4/tN7
X-Received: by 2002:a4a:c719:0:b0:2eb:c34a:2ba7 with SMTP id n25-20020a4ac719000000b002ebc34a2ba7mr19498050ooq.98.1646337573200;
        Thu, 03 Mar 2022 11:59:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6XTO+OhibXSv5NZahUVm0cq34tr89yXWaoMFB6Fqiab+SUFF3Phx50x9lVSIdc9AfUbbmhg==
X-Received: by 2002:a4a:c719:0:b0:2eb:c34a:2ba7 with SMTP id n25-20020a4ac719000000b002ebc34a2ba7mr19498041ooq.98.1646337572985;
        Thu, 03 Mar 2022 11:59:32 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u21-20020a056870951500b000d9b9ac69cdsm901630oal.1.2022.03.03.11.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 11:59:32 -0800 (PST)
Date:   Thu, 3 Mar 2022 12:59:30 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol
 with PRE_COPY
Message-ID: <20220303125930.43d9940b.alex.williamson@redhat.com>
In-Reply-To: <0cee64d555624e669028ba17d04b8737@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
        <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
        <20220302133159.3c803f56.alex.williamson@redhat.com>
        <20220303000528.GW219866@nvidia.com>
        <20220302204752.71ea8b32.alex.williamson@redhat.com>
        <20220303130124.GX219866@nvidia.com>
        <20220303082040.1f88e24c.alex.williamson@redhat.com>
        <0cee64d555624e669028ba17d04b8737@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Mar 2022 18:05:53 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: 03 March 2022 15:21
> > To: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; cohuck@redhat.com;
> > mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> > <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> > <prime.zeng@hisilicon.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> > Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol with
> > PRE_COPY
> > 
> > On Thu, 3 Mar 2022 09:01:24 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Mar 02, 2022 at 08:47:52PM -0700, Alex Williamson wrote:  
> > > > On Wed, 2 Mar 2022 20:05:28 -0400
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >  
> > > > > On Wed, Mar 02, 2022 at 01:31:59PM -0700, Alex Williamson wrote:  
> > > > > > > + * initial_bytes reflects the estimated remaining size of any
> > > > > > > + initial mandatory
> > > > > > > + * precopy data transfer. When initial_bytes returns as zero
> > > > > > > + then the initial
> > > > > > > + * phase of the precopy data is completed. Generally initial_bytes  
> > should start  
> > > > > > > + * out as approximately the entire device state.  
> > > > > >
> > > > > > What is "mandatory" intended to mean here?  The user isn't required  
> > to  
> > > > > > collect any data from the device in the PRE_COPY states.  
> > > > >
> > > > > If the data is split into initial,dirty,trailer then mandatory
> > > > > means that first chunk.  
> > > >
> > > > But there's no requirement to read anything in PRE_COPY, so initial
> > > > becomes indistinguishable from trailer and dirty doesn't exist.  
> > >
> > > It is still mandatory to read that data out, it doesn't matter if it
> > > is read during PRE_COPY or STOP_COPY.  
> > 
> > Not really, PRE_COPY -> RUNNING is a valid arc.
> >   
> > > > > > "The vfio_precopy_info data structure returned by this ioctl
> > > > > > provides  estimates of data available from the device during the  
> > PRE_COPY states.  
> > > > > >  This estimate is split into two categories, initial_bytes and
> > > > > > dirty_bytes.
> > > > > >
> > > > > >  The initial_bytes field indicates the amount of static data
> > > > > > available  from the device.  This field should have a non-zero initial  
> > value and  
> > > > > >  decrease as migration data is read from the device.  
> > > > >
> > > > > static isn't great either, how about just say 'minimum data available'  
> > > >
> > > > 'initial precopy data-set'?  
> > >
> > > Sure
> > >  
> > > > We have no basis to make that assertion.  We've agreed that precopy
> > > > can be used for nothing more than a compatibility test, so we could
> > > > have a vGPU with a massive framebuffer and no ability to provide
> > > > dirty tracking implement precopy only to include the entire
> > > > framebuffer in the trailing STOP_COPY data set.  Per my
> > > > understanding and the fact that we cannot enforce any heuristics
> > > > regarding the size of the tailer relative to the pre-copy data set,
> > > > I think the above strongly phrased sentence is necessary to
> > > > understand the limitations of what this ioctl is meant to convey.
> > > > Thanks,  
> > >
> > > This is why abusing precopy for compatability is not a great idea. It
> > > is OK for acc because its total state is tiny, but I would not agree
> > > to a vGPU driver being merged working like you describe. It distorts
> > > the entire purpose of PRE_COPY and this whole estimation mechanism.
> > >
> > > The ioctl is intended to convey when to switch to STOP_COPY, and the
> > > driver should provide a semantic where the closer the reported length
> > > is to 0 then the faster the STOP_COPY will go.  
> > 
> > If it's an abuse, then let's not do it.  It was never my impression or intention
> > that this was ok for acc only due to the minimal trailing data size.  My
> > statement was that use of PRE_COPY for compatibility testing only had been a
> > previously agreed valid use case of the original migration interface.
> > 
> > Furthermore the acc driver was explicitly directed not to indicate any degree
> > of trailing data size in dirty_bytes, so while trailing data may be small for acc,
> > this interface is explicitly not intended to provide any indication of trailing
> > data size.  Thanks,  
> 
> Just to clarify, so the suggestion here is not to use PRE_COPY for compatibility
> check at all and have a different proper infrastructure for that later as Jason
> suggested?
> 
> If so, I will remove this patch from this series and go back to the old revision
> where we only have STOP_COPY and do the compatibility check during the final
> load data operation.

Hi Shameer,

I think NVIDIA has a company long weekend, so I'm not sure how quickly
we'll hear a rebuttal from Jason, but at this point I'd rather not move
forward with using PRE_COPY exclusively for compatibility testing if
that is seen as an abuse of the interface, regardless of the size of
the remaining STOP_COPY data.  It might be most expedient to respin
without PRE_COPY and we'll revisit methods to perform early
compatibility testing in the future.  Thanks,

Alex

