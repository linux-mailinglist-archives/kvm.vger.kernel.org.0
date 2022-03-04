Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5204CDDE0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiCDUBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiCDUBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:01:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A1E128672C
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 11:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646423775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P9DhVtnRsmc3RlPCIzZyvuWYNlBf0BRlzJacAYcnL5k=;
        b=dOlX/8D3oBAnQOcGa6KKoVokU+mEDdVIzLWEShKe0ms+pcG7/6R3nrprkYRUSI+V5Tg6Tx
        cNqr9cVPNXo7gwW2FW5wjbNEmmCKY+ez8880uPr7/hOJ4T97oPe75qXzfk8XtJiOLss644
        ROU48G/x7emhwgAvDWbNslGlpYG51Do=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-270W0DlINo-tA7VeVQjFJQ-1; Fri, 04 Mar 2022 14:56:14 -0500
X-MC-Unique: 270W0DlINo-tA7VeVQjFJQ-1
Received: by mail-ot1-f69.google.com with SMTP id t3-20020a9d7483000000b005ad2f92e885so6556321otk.21
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 11:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=P9DhVtnRsmc3RlPCIzZyvuWYNlBf0BRlzJacAYcnL5k=;
        b=FsU5rbnVyExrIrAEzO5B+pmyRSf5IxX4OWpG7iqyzlxucochdGq+X/0+PRVTvhptAL
         8rZ0dJ8wEerysc5ilVIbEauFjXiCqHC3WBYYhoiDgMwaCCPAehcA4tcC01yKUwISK2q6
         UbFZrfdylNhLERbDSg7uOer2+R7SBl4TkbvLlw9LVxTQw1i3DZM1VxVYuo2J0tBUELKS
         sQAJv2VwAUCyv6Ckh5k2SDZNZWjGCQ/lvXgDuxcPqjSAGageqbXQn7d78YzR5qEn8KRq
         9MnJ/WtFIR+XjHnL58XHAiZ3aSa8++IVMOHLZ4U52LGBlsJZJZjYGIaIcZIDRaZMJdsd
         vgpQ==
X-Gm-Message-State: AOAM5321rquyOjj8OJxJazMNL5OOLjWv0ViXPVAgCy4IOxfOD9IkI1g7
        H5arKaWLDBUMLfO48xVXN/ycmw2NaSjUVkmkvFLXiraDP8fpksM2snnrqQRDtJEaaXHJ1qJgOwY
        W9suQ3Rkg+cqw
X-Received: by 2002:aca:aa4e:0:b0:2d4:eabf:6c9e with SMTP id t75-20020acaaa4e000000b002d4eabf6c9emr102343oie.45.1646423773347;
        Fri, 04 Mar 2022 11:56:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaDyZjmGDO18UlrzMqzMCLrub8I+E0Ci/YjgAOICgYNLJHKHnp9ckx1d9BYSV5FmaGmN0opw==
X-Received: by 2002:aca:aa4e:0:b0:2d4:eabf:6c9e with SMTP id t75-20020acaaa4e000000b002d4eabf6c9emr102326oie.45.1646423773090;
        Fri, 04 Mar 2022 11:56:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m26-20020a05680806da00b002d797266870sm2981345oih.9.2022.03.04.11.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:56:12 -0800 (PST)
Date:   Fri, 4 Mar 2022 12:56:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
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
Message-ID: <20220304125611.7659eccb.alex.williamson@redhat.com>
In-Reply-To: <20220303234951.GB219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
        <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
        <20220302133159.3c803f56.alex.williamson@redhat.com>
        <20220303000528.GW219866@nvidia.com>
        <20220302204752.71ea8b32.alex.williamson@redhat.com>
        <20220303130124.GX219866@nvidia.com>
        <20220303082040.1f88e24c.alex.williamson@redhat.com>
        <0cee64d555624e669028ba17d04b8737@huawei.com>
        <20220303125930.43d9940b.alex.williamson@redhat.com>
        <20220303234951.GB219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Mar 2022 19:49:51 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Mar 03, 2022 at 12:59:30PM -0700, Alex Williamson wrote:
> 
> > > > If it's an abuse, then let's not do it.  It was never my
> > > > impression or intention  
> 
> So maybe abuse is the wrong word, but I don't want to mess up this
> interface, which is intended to support real pre-copy devices, just
> because devices that don't actually implement true precopy might do
> silly things.

Abuse... silly... either way, you're clearly not comfortable misusing
PRE_COPY for this purpose.  

> The vGPU case you imagine will still work and qemu will switch to
> STOP_COPY with a huge trailer and be slow. That is unavoidable and I
> think it is fine.

It's not really fine, but I think it will require some better defined
interfaces and userspace support to give a clear picture of how data is
partitioned.

> > > > Furthermore the acc driver was explicitly directed not to indicate any degree
> > > > of trailing data size in dirty_bytes, so while trailing data may be small for acc,
> > > > this interface is explicitly not intended to provide any indication of trailing
> > > > data size.  Thanks,   
> 
> Yes, trailing data is not what this is for. This is only to help
> decide when to switch from PRE_COPY to STOP_COPY. If the device can
> execute STOP_COPY in the right time is a completely different
> discussion/interface.
> 
> > > Just to clarify, so the suggestion here is not to use PRE_COPY for compatibility
> > > check at all and have a different proper infrastructure for that later as Jason
> > > suggested?
> > > 
> > > If so, I will remove this patch from this series and go back to the old revision
> > > where we only have STOP_COPY and do the compatibility check during the final
> > > load data operation.  
> > 
> > Hi Shameer,
> > 
> > I think NVIDIA has a company long weekend, so I'm not sure how quickly
> > we'll hear a rebuttal from Jason, but at this point I'd rather not
> > move  
> 
> Yes, company long weekend.
> 
> > forward with using PRE_COPY exclusively for compatibility testing if
> > that is seen as an abuse of the interface, regardless of the size of
> > the remaining STOP_COPY data.  It might be most expedient to respin
> > without PRE_COPY and we'll revisit methods to perform early
> > compatibility testing in the future.  Thanks,  
> 
> Shameerali has talked about wanting this compat check early from the
> start, and done all the work to implement it. I think it is pretty
> extreme to blow up his series over trailing_data.
> 
> To me acc is fine to use it this way until we get a better solution
> for compatability. We all need this, but I expect it to be complicated
> to define.

It was only in v7 that we made this switch to use PRE_COPY for this
purpose, I wouldn't call it blowing up his series to step back and
decide that was a poor choice and clearly v8 exists without this.  This
isn't the end of the discussion regarding early compatibility testing,
but I'm not going to rush a PRE_COPY interface to support that early
compatibility testing if we're not agreed that it's a valid use case,
and not just a marginally acceptable one due to the trailing data being
inconsequential.  Let's focus on v8 and we can talk about further
extensions later.  Thanks,

Alex

