Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59B1724B00
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbjFFSOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbjFFSOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A687610CE
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686075232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7uLli3yz1DYI1/D8uLJjLkh+ys9q2UvcidB0MAb3VgM=;
        b=CxD/kQMdzDakP17AK/FcSaVDV8hbShnMyG2DpcW7PA69AFMAoPEPOlvBSEnUPgcsibKejJ
        tqZTPwj2aiO8KkhrR+DI5G/9C/3jB9mkAKERQDO0EpIDBS4ZhNRZmGuSYa86AEf2w6DZUj
        JBDoOx77LbjE1eYC4PiS17/IonZBj8Y=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-Vq3pPw4GNhu0DtQOMEeaTg-1; Tue, 06 Jun 2023 14:13:51 -0400
X-MC-Unique: Vq3pPw4GNhu0DtQOMEeaTg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-777a9ffdcd7so194702339f.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 11:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686075231; x=1688667231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uLli3yz1DYI1/D8uLJjLkh+ys9q2UvcidB0MAb3VgM=;
        b=aPm6lx4nTwTxzHEPEvE/YxiDdfYNvETrd52hc6C5+mSmxZelAXGDRzhsntVxqxufmj
         rTL9PfxQoTr1qK19hL0cBtOo1pPAcYn2XPZ0l4fahphS/auGhffuBWGVnu1LiQ+VhbB6
         ZjUlFlPN6XX4CG9+SYWxgJ7IdkBoLKQyJbsyfFoaet+iQ638mz/L1sq62ju3QrbrBuWv
         oM4n6khh40emRg8HAsiQklb4DZS/D1fISRbArYLx6VohVynL3oKfnxXIvDN4dtvYdOMz
         smQLzpBOHcfC+kc3ZktEM6fBfwfOtNam7nAG2meXV3cT/CztBaJOopoZM2lAjwJgV41P
         ncBA==
X-Gm-Message-State: AC+VfDyLnPIpFmDJhV5B61h8dfok1mrHqWhRibRu/632jdfI35xGw9kH
        ogExHNyTgprAlQcwCsspBUHZB9PjkNc45ZeYVhFe168nkThqFIM7cbR4Gnho/DAvGCQXslHEo4k
        cheYfyUSnLvZB
X-Received: by 2002:a05:6e02:128c:b0:331:85fa:74c5 with SMTP id y12-20020a056e02128c00b0033185fa74c5mr2620086ilq.1.1686075231123;
        Tue, 06 Jun 2023 11:13:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7k+blw9vPOLpvg+3qppUSS4w3PTeZqEhsRV5Mhqk3Ou+cjFTQOKYmh9jBA+88W34/P7aBrLg==
X-Received: by 2002:a05:6e02:128c:b0:331:85fa:74c5 with SMTP id y12-20020a056e02128c00b0033185fa74c5mr2620069ilq.1.1686075230879;
        Tue, 06 Jun 2023 11:13:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a22-20020a056638019600b0041abd81975bsm2931075jaq.153.2023.06.06.11.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 11:13:50 -0700 (PDT)
Date:   Tue, 6 Jun 2023 12:13:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230606121348.670229ff.alex.williamson@redhat.com>
In-Reply-To: <ZH9p+giEs6bCYfw8@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
        <20230606083238.48ea50e9.alex.williamson@redhat.com>
        <ZH9RfXhbuED2IUgJ@nvidia.com>
        <20230606110510.0f87952c.alex.williamson@redhat.com>
        <ZH9p+giEs6bCYfw8@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Jun 2023 14:16:42 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 06, 2023 at 11:05:10AM -0600, Alex Williamson wrote:
> 
> > It actually seems more complicated this way.  We're masquerading this
> > region as a BAR, but then QEMU needs to know based on device IDs that
> > it's really not a BAR, it has special size properties, mapping
> > attributes, error handling, etc.    
> 
> This seems like something has gone wrong then. ie the SIGUBS error
> handling stuff should be totally generic in the qemu side. Mapping
> attributes are set by the kernel, qemu shouldn't know, doesn't need to
> know.

You asked me to look at the v1 posting to see why there's so much more
going on here than a quirk.  That's what I read from the first public
posting, a coherent memory region masqueraded as a BAR which requires
different memory mapping and participates in ECC.  I agree that the
actual mapping is done by the kernel, but it doesn't really make a
difference if that's a vfio-pci variant driver providing a different
mmap callback for a BAR region or a device specific region handler.

> The size issue is going to a be a problem in future anyhow, I expect
> some new standards coming to support non-power-two sizes and they will
> want to map to PCI devices in VMs still.

Ok, but a PCI BAR has specific constraints and a non-power-of-2 BAR is
not software compatible with those constraints.  That's obviously not
to say that a new capability couldn't expose arbitrary resources sizes
on a PCI-like device though.  I don't see how a non-power-of-2 BAR at
this stage helps or fits within any spec, which is exactly what's
being proposed through this BAR masquerade.
 
> It seems OK to me if qemu can do this generically for any "BAR"
> region, at least creating an entire "nvidia only" code path just for
> non power 2 BAR sizing seems like a bad ABI choice.

Have you looked at Ankit's QEMU series?  It's entirely NVIDIA-only code
paths.  Also nothing here precludes that shared code in QEMU might
expose some known arbitrary sized regions as a BAR, or whatever spec
defined thing allows that in the future.  It would only be a slight
modification in the QEMU code to key on the presence of a device
specific region rather than PCI vendor and device IDs, to then register
that region as a PCI BAR and proceed with all this NVIDIA specific
PXM/SRAT setup. IMO it makes a lot more sense to create memory-only
NUMA nodes based on a device specific region than it does a PCI BAR.

> > I'm not privy to a v1, the earliest I see is this (v3):
> > 
> > https://lore.kernel.org/all/20230405180134.16932-1-ankita@nvidia.com/
> > 
> > That outlines that we have a proprietary interconnect exposing cache
> > coherent memory which requires use of special mapping attributes vs a
> > standard PCI BAR and participates in ECC.  All of which seems like it
> > would be easier to setup in QEMU if the vfio-pci representation of the
> > device didn't masquerade this regions as a standard BAR.  In fact it
> > also reminds me of NVlink2 coherent RAM on POWER machines that was
> > similarly handled as device specific regions.    
> 
> It wasn't so good on POWER and if some of that stuff has been done
> more generally we would have been further ahead here..

Specifics?  Nothing here explained why masquerading the coherent memory
as a BAR in the vfio-pci ABI is anything more than a hack that QEMU
could assemble on its own with a device specific region.  Thanks,

Alex

