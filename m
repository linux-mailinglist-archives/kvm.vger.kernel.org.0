Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8766FD34D
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 02:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbjEJAcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 20:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjEJAcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 20:32:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422282D7B
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 17:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683678676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AaGvAGLjFXPfpvTNP/bdiZ7J41peMCCPDlY16Vtsnuk=;
        b=I6Pio3IH4I//3GkGh+Gsw9ucigcLx3Jl7k744dReQoXNKVpohqs9JL2PvNiCSDOa6f0QB6
        iNAaflMWw/WYSDvYbIzhPz9u1KRjlT42GffglSDgxbiPbk7qDMaqChiz9OrHqXeCQufIwE
        88mSjyDD2uC7LkKbVSEQspL/wXa/3dQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-37ZuUlGAOT-bhIb3X3rjtQ-1; Tue, 09 May 2023 20:31:14 -0400
X-MC-Unique: 37ZuUlGAOT-bhIb3X3rjtQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33338be98cdso35023675ab.3
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 17:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683678674; x=1686270674;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AaGvAGLjFXPfpvTNP/bdiZ7J41peMCCPDlY16Vtsnuk=;
        b=VNfIpMRtS+whz7sNaWK8zdmtN/qJRd1iD9x4PB/Wmzgb/mduGKQEwWMjiLW8TW6MSc
         /8OCV0dsfdEIx23duhT/6nl5HsoCMQJ953t779Mf69vdD+o+OZnOYaj0QTwq7CXPstxY
         tTiuuUyzKMQZN+sasF0aVioJbivMZx0ZOtLtJ2/JLPoW0eKzZpw5BlfjzX8b9A377kvH
         G27+KvlaDuZ2ANFx0Go4qLCPcMHuF+dpoTebzeJu+MPC79s1CVjNyqjsVQucWCPp9/cr
         egB23bcJklQlXmx0oQEc9/l6MZ53Gtiv4QqwK8gOfIPexE2s/i0uMamnLw50Logz58mD
         Bs2A==
X-Gm-Message-State: AC+VfDxzL+MPWNn3jGmj5bpXopU8/Ww7U1gXj7roN13rd5lmsBauYbHT
        BCrSpLuAle3q4nSwQZ1f4Zfu/3wOCf8SECcuROabFC6svv3jV0YZQOV5f3jk60WzKw4HyCAwzmt
        3IrF0O+Cabu8a
X-Received: by 2002:a92:4a06:0:b0:32b:7df:f753 with SMTP id m6-20020a924a06000000b0032b07dff753mr9869332ilf.11.1683678674073;
        Tue, 09 May 2023 17:31:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ79Yj2G0XIIcmZ/c1KruTGfkagj0u9LrnxFQ/2bXVIs32rC2FuiPnD49eLE6EdbC76r06jWUw==
X-Received: by 2002:a92:4a06:0:b0:32b:7df:f753 with SMTP id m6-20020a924a06000000b0032b07dff753mr9869323ilf.11.1683678673720;
        Tue, 09 May 2023 17:31:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t13-20020a92d14d000000b0033154d10283sm3386377ilg.40.2023.05.09.17.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 17:31:13 -0700 (PDT)
Date:   Tue, 9 May 2023 18:31:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <20230509183111.6a4a7f39.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZFrMneCMKuCtu7JF@nvidia.com>
        <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZFrThMhUnsYOE3WP@nvidia.com>
        <BN9PR11MB52760816DC23D5322A4318228C769@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
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

On Tue, 9 May 2023 23:41:44 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 10, 2023 7:13 AM
> > 
> > On Tue, May 09, 2023 at 10:57:04PM +0000, Tian, Kevin wrote:  
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, May 10, 2023 6:44 AM
> > > >
> > > > On Tue, May 09, 2023 at 08:34:53AM +0000, Tian, Kevin wrote:  
> > > > > According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> > > > >
> > > > >   The PASID configuration of the single non-VF Function representing
> > > > >   the device is also used by all VFs in the device. A PF is permitted
> > > > >   to implement the PASID capability, but VFs must not implement it.
> > > > >
> > > > > To enable PASID on VF then one open is where to locate the PASID
> > > > > capability in VF's vconfig space. vfio-pci doesn't know which offset
> > > > > may contain VF specific config registers. Finding such offset must
> > > > > come from a device specific knowledge.  
> > > >
> > > > Why? Can't vfio probe the cap tree and just find a gap to insert a new
> > > > cap? We already mangle the cap list, I'm not sure I see what
> > > > the problem is?
> > > >  
> > >
> > > PCI config space includes not only caps, but also device specific
> > > defined fields. e.g. Intel IGD defines offset 0xfc as a pointer to
> > > OpRegion. I'm sure Alex can give many other examples.  
> > 
> > Do we even expose those over VIFO? I thought in general we blocked of  
> 
> Yes. I did a quick check:
> 
> /*
>  * Default unassigned regions to raw read-write access.  Some devices
>  * require this to function as they hide registers between the gaps in
>  * config space (be2net).  Like MMIO and I/O port registers, we have
>  * to trust the hardware isolation.
>  */
> static struct perm_bits unassigned_perms = {
> 	.readfn = vfio_raw_config_read,
> 	.writefn = vfio_raw_config_write
> };
> 
> vfio_config_do_rw()
> {
> 	...
> 	if (cap_id == PCI_CAP_ID_INVALID) {
> 		perm = &unassigned_perms;
> 		cap_start = *ppos;
> 	} ...
> }
> 
> vfio_config_init()
> {
> 	...
> 	memset(map, PCI_CAP_ID_BASIC, PCI_STD_HEADER_SIZEOF);
> 	memset(map + PCI_STD_HEADER_SIZEOF, PCI_CAP_ID_INVALID,
>               		 pdev->cfg_size - PCI_STD_HEADER_SIZEOF);
> 	...
> }
> 
> > various parts of the config space. I keep seeing patches to unblock
> > parts of config space?
> > 
> > I'd do the reverse and say devices that want to pass parts of their
> > config space should have a special hook to do it and otherwise we
> > should sanitize and block?  
> 
> This then may break backward compatibility. We don't know how
> many devices have such hidden registers so if anyone misses a hook
> immediately it cannot be assigned after we start blocking as default.
> 
> > 
> > eg we already have a hook to pass the opregion
> >   
> > > So it's easy to find the gap between caps, but not easy to know
> > > whether that gap is actually free to use.  
> > 
> > Because, let's face it, this is a horrible thing to do, and the
> > opregion stuff is just ugly as s sin.
> >   
> 
> It's ugly, but that is the reality. :/

Have a peak at the config space of an NVIDIA GPU and tell me which of
those non-zero fields between capabilities are used as well.  Glass
houses...  ;-)

IIRC we originally needed to enable this for a Broadcom NIC that
stuffed device specific registers in un-architected config space. The
capabilities we're {un}hiding are architected things that we know are
unsupported or unsafe, the gaps, just like device specific
capabilities, we're obliged to expose for functionality.  Thanks,

Alex

