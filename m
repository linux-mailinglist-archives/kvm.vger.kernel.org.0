Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12D964D156
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLNUg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLNUfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:35:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA9F2A95A
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671049788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XW3XE5pnM3onBMQ2lA6Y6O2hCukV7+ehGECEC5UFzy0=;
        b=Bokvk/hQWLlLuRyAtC0aRnORxLiOIOlZdo099s4ZwFFSlFg5v3f10uKTb8a/wEcHEe07yn
        F26ECzbvMi16Yx5RJJL+bOpEweU9/P69AmEosg82/wibdLD3pcjCkLFM0WWO51GjYcxy0c
        3H8C8140ogPY3F7v/d7MHJ9KlSFDrXk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-mab_FhmNNv-ZhfKjGhN7gA-1; Wed, 14 Dec 2022 15:29:39 -0500
X-MC-Unique: mab_FhmNNv-ZhfKjGhN7gA-1
Received: by mail-il1-f197.google.com with SMTP id n15-20020a056e021baf00b0030387c2e1d3so10364810ili.5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:29:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XW3XE5pnM3onBMQ2lA6Y6O2hCukV7+ehGECEC5UFzy0=;
        b=OyDIqya73YBifpJd4ftJNKmgyfvPr2RMByTg1WMFBKn4+RHQM/fwcDlbQAiaQqVxvd
         BW1PMULfHn3+b8yLdqSv8bIt/HKjIxZArFlPkMG98NJGvxMAMSZEiD5sTjEIIi1pkERl
         L4zcKH6KWmw1pQ5WMTe9vA5wEMa7XJMUtZugqPYIBRpBhvqF4RoEUX0LdJ5+BEwj42H3
         mtCpQlsSOD3Lo5Dc1rbQItrDYTcXo2drAzKQYv3XjlDHc5I/V4YcJsc1rlZXB5t5IfjS
         XrRiTXA1Y3+pohmzIypFUlDZ0o2UR0drjAtK7dL2j7Vt9d5v4maz92BfUXctf2AMuNTC
         Wsrg==
X-Gm-Message-State: ANoB5pkhPvStBulbOAspWRi63CgOoAsso9W3S8mRc88uKlPOrIVs5875
        ZyJJ5Ag5jv5sTe5Ot4yKMWEOdcGavR7OgV7YXhNHPV2MgfgRES7MUKd17imseX9zRku16akX+O4
        1YrcZNMGWJIZ4
X-Received: by 2002:a5d:81d2:0:b0:6bc:d71a:2b47 with SMTP id t18-20020a5d81d2000000b006bcd71a2b47mr13797433iol.8.1671049777044;
        Wed, 14 Dec 2022 12:29:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7lBcYHhAZAxeUDI4vKghA8ewqJ0hV3cIF2aYjF3hKsuETHbyH7IaARoFh+7SNQ78OQahIqAw==
X-Received: by 2002:a5d:81d2:0:b0:6bc:d71a:2b47 with SMTP id t18-20020a5d81d2000000b006bcd71a2b47mr13797425iol.8.1671049776809;
        Wed, 14 Dec 2022 12:29:36 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q44-20020a027b2c000000b003755a721e98sm2038876jac.107.2022.12.14.12.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 12:29:36 -0800 (PST)
Date:   Wed, 14 Dec 2022 13:29:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V3 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <20221214132934.28bf308b.alex.williamson@redhat.com>
In-Reply-To: <e03a0787-4bd3-de21-9439-a91db71bd05a@oracle.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
        <1671045771-59788-2-git-send-email-steven.sistare@oracle.com>
        <20221214124015.36c1fd52.alex.williamson@redhat.com>
        <5a06aaea-cd53-01cb-bb4e-08a3a543fa6f@oracle.com>
        <e03a0787-4bd3-de21-9439-a91db71bd05a@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Dec 2022 15:20:44 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/14/2022 3:03 PM, Steven Sistare wrote:
> > On 12/14/2022 2:40 PM, Alex Williamson wrote:  
> >> On Wed, 14 Dec 2022 11:22:47 -0800
> >> Steve Sistare <steven.sistare@oracle.com> wrote:
> >>> @@ -3080,6 +3112,11 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> >>>  	size_t offset;
> >>>  	int ret;
> >>>  
> >>> +	if (iommu->vaddr_invalid_count) {
> >>> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
> >>> +		return -EIO;
> >>> +	}  
> >>
> >> Same optimization above, but why are we letting the code iterate this
> >> multiple times in the _chunk function rather than testing once in the
> >> caller?  Thanks,  
> > 
> > An oversight, I'll hoist it.  
> 
> It's actually a little nicer to leave the test here.  The first call to
> here returns failure, and the caller exits the loop.  
> 
> Hoisting it requires jumping to an out label that releases the iommu lock.
> 
> Which do you prefer?

The failure might exit on the first chunk, but non-failure incurs
overhead per chunk.  I suspect we're not often iterating multiple
chunks, but I don't mind the goto in order to avoid that possibility.
Thanks,

Alex

