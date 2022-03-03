Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5869D4CC112
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 16:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbiCCPVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 10:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiCCPVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 10:21:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 389F1191403
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 07:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646320845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7mpK7pvgTWentIhhiz4yzX872Q3shOMfg+H98YQWYRQ=;
        b=EkLVGRUySxjA9DpuXSX+Q4KaKWVulq9WJchLhT8WpIwD/N5eS4GaibC1nmXx7IDXRsB1Sz
        V3D60lWxZB+LujCmGe9kq7xT7Vapx8yngR+pB+OMCSD0L6dH/ZD/1YedpSEUO6aJGieb6h
        kJYTeUQ7gfDOviPfElk+HeMiWpqQv7o=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-eQJlsEHWNHaRthW5vKPPyw-1; Thu, 03 Mar 2022 10:20:44 -0500
X-MC-Unique: eQJlsEHWNHaRthW5vKPPyw-1
Received: by mail-oo1-f70.google.com with SMTP id c23-20020a4ad217000000b0031bec3c46deso3661387oos.0
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 07:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7mpK7pvgTWentIhhiz4yzX872Q3shOMfg+H98YQWYRQ=;
        b=MAQy6ukYoBP0/exJ/epPzK1LyC1NcxujD9ApQasMcmmqmhYApN2q/VyMlV6Vf8Bpwa
         hwMVDMaGNRcu5SqePMHtB3t7VNI3gYRUpwvAAR1iAx+9X33A9X02xLCM+G9Fhae2m+/u
         7kqDnT5VIi8bvTiRaLSmhAyWDvX+4zCoL4ZmUbfohnKKVsUE/eL6B+H0tCkl9r86eE3K
         t3DEz0b1ylDq5v1GSZqmiRT3+nDcQykzLV+5wuvr1hqE5RWaVXNMBMbm56klkA6YelLJ
         VQwwo+sBkDI0/Ljvy3HLPOPphb0JDP8T0TFcZtDoyTVd9xoUP62dl5WZqAmPIGfHxudQ
         AyXw==
X-Gm-Message-State: AOAM5319scWwlq+5tszQcSMi33P3cKfbjeSG9/fDcOFuTurS0pRKXhB8
        A6IYfWHJxi+ucB7f0WqRwsZlzPKb/xLLzZbc3XaODdahG5IGSDr8fXz1jzRzNoFe8OKhs929Xic
        lngjmQpCcPtBu
X-Received: by 2002:a05:6808:1b12:b0:2d4:51b4:9ee with SMTP id bx18-20020a0568081b1200b002d451b409eemr4911518oib.116.1646320843371;
        Thu, 03 Mar 2022 07:20:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzluCZ5rJ4iivgLRbJGJwM2iBPKA/sEoGqOg0RzNDmXEXdF9xe8GTY8lG06TyJ1/I/6H+GX3Q==
X-Received: by 2002:a05:6808:1b12:b0:2d4:51b4:9ee with SMTP id bx18-20020a0568081b1200b002d451b409eemr4911475oib.116.1646320842746;
        Thu, 03 Mar 2022 07:20:42 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bj27-20020a056808199b00b002d49b02cb41sm1114819oib.22.2022.03.03.07.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 07:20:42 -0800 (PST)
Date:   Thu, 3 Mar 2022 08:20:40 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol
 with PRE_COPY
Message-ID: <20220303082040.1f88e24c.alex.williamson@redhat.com>
In-Reply-To: <20220303130124.GX219866@nvidia.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
        <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
        <20220302133159.3c803f56.alex.williamson@redhat.com>
        <20220303000528.GW219866@nvidia.com>
        <20220302204752.71ea8b32.alex.williamson@redhat.com>
        <20220303130124.GX219866@nvidia.com>
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

On Thu, 3 Mar 2022 09:01:24 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 02, 2022 at 08:47:52PM -0700, Alex Williamson wrote:
> > On Wed, 2 Mar 2022 20:05:28 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Mar 02, 2022 at 01:31:59PM -0700, Alex Williamson wrote:  
> > > > > + * initial_bytes reflects the estimated remaining size of any initial mandatory
> > > > > + * precopy data transfer. When initial_bytes returns as zero then the initial
> > > > > + * phase of the precopy data is completed. Generally initial_bytes should start
> > > > > + * out as approximately the entire device state.    
> > > > 
> > > > What is "mandatory" intended to mean here?  The user isn't required to
> > > > collect any data from the device in the PRE_COPY states.    
> > > 
> > > If the data is split into initial,dirty,trailer then mandatory means
> > > that first chunk.  
> > 
> > But there's no requirement to read anything in PRE_COPY, so initial
> > becomes indistinguishable from trailer and dirty doesn't exist.  
> 
> It is still mandatory to read that data out, it doesn't matter if it
> is read during PRE_COPY or STOP_COPY.

Not really, PRE_COPY -> RUNNING is a valid arc.
 
> > > > "The vfio_precopy_info data structure returned by this ioctl provides
> > > >  estimates of data available from the device during the PRE_COPY states.
> > > >  This estimate is split into two categories, initial_bytes and
> > > >  dirty_bytes.
> > > > 
> > > >  The initial_bytes field indicates the amount of static data available
> > > >  from the device.  This field should have a non-zero initial value and
> > > >  decrease as migration data is read from the device.    
> > > 
> > > static isn't great either, how about just say 'minimum data available'  
> > 
> > 'initial precopy data-set'?  
> 
> Sure
> 
> > We have no basis to make that assertion.  We've agreed that precopy can
> > be used for nothing more than a compatibility test, so we could have a
> > vGPU with a massive framebuffer and no ability to provide dirty
> > tracking implement precopy only to include the entire framebuffer in
> > the trailing STOP_COPY data set.  Per my understanding and the fact
> > that we cannot enforce any heuristics regarding the size of the tailer
> > relative to the pre-copy data set, I think the above strongly phrased
> > sentence is necessary to understand the limitations of what this ioctl
> > is meant to convey.  Thanks,  
> 
> This is why abusing precopy for compatability is not a great idea. It
> is OK for acc because its total state is tiny, but I would not agree
> to a vGPU driver being merged working like you describe. It distorts
> the entire purpose of PRE_COPY and this whole estimation mechanism.
> 
> The ioctl is intended to convey when to switch to STOP_COPY, and the
> driver should provide a semantic where the closer the reported length
> is to 0 then the faster the STOP_COPY will go.

If it's an abuse, then let's not do it.  It was never my impression or
intention that this was ok for acc only due to the minimal trailing
data size.  My statement was that use of PRE_COPY for compatibility
testing only had been a previously agreed valid use case of the
original migration interface.

Furthermore the acc driver was explicitly directed not to indicate any
degree of trailing data size in dirty_bytes, so while trailing data may
be small for acc, this interface is explicitly not intended to provide
any indication of trailing data size.  Thanks,

Alex

