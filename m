Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCFB756C34
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 20:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjGQSg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 14:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjGQSgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 14:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0D0188
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 11:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689618930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7lLouRsAU88eON8j2CGNjFVozkxl67pRtBcpN+x+9w=;
        b=b3Mwml5s5pVD9fTzvfzCNa0gfPlM3RcBbfb2VAtSjxAZNSC0wY1wh1YPwfPP5z7a+asKtQ
        D47OUsWol3M4sNr9N+DMR8BQ8YbB2TgmfoJa40ePcc61g9LjvnAb742TA5uJ9NS+eht3eP
        oMsm8b3ag1miNuI4/3fERi2oTEZF+ts=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-a08UGHKwMOWdf21lLgXQRQ-1; Mon, 17 Jul 2023 14:35:28 -0400
X-MC-Unique: a08UGHKwMOWdf21lLgXQRQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3456b52d504so12953975ab.0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 11:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689618927; x=1692210927;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X7lLouRsAU88eON8j2CGNjFVozkxl67pRtBcpN+x+9w=;
        b=Qla2rXvXPO3WFJP2kxiIOwr70qY+Kdx6QdrSCQFOSO9xINquErsQptqlWv3aYJzQ5D
         CPz0RdEnfGbO+9V5zOuFJeFUl2O6WURT5DuesrNb4tpbDQ2xbxNbT2JxPhU2x+TbzJZO
         LDU2e1iRvCyXBdU17BZQUv9Rkbcc0MVk20WRyfKY8PD5p6eU91GQP/Ns3C/tiEsLMbaT
         lQGsoMXiF3vRernrDuARWcoyTN4S+R2G17rOAU3rAuyXRMU9+weXDLw7K/td9R1WNfCd
         YRd4bUNx4vi+9v8pnAmmgJ7fcYcnygqJCnm0ODwRUaAIN4o+PNb8JZ7zcWH91afpTOm6
         s+bw==
X-Gm-Message-State: ABy/qLb+WCFRHUii3t5YAFpsAKOp2MqfquzHNKpYqlWn/xZjUvGnWHJO
        J1r87LD1TEorRCBY2vZRbMJvrMNRefsfQvO6jWjy2plVCNX86gfmBRMhFZB7RtZo/uOhYHfjHiI
        +5O4g56Q06ppJ
X-Received: by 2002:a05:6e02:156b:b0:345:873d:1102 with SMTP id k11-20020a056e02156b00b00345873d1102mr270368ilu.15.1689618927251;
        Mon, 17 Jul 2023 11:35:27 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGKd0dPxU+CkmAXbq+VKsvbmxGVZ2rrV0eSsjby80iWZntyS3+BBEsMDgTKlmF+oLB55GZOEg==
X-Received: by 2002:a05:6e02:156b:b0:345:873d:1102 with SMTP id k11-20020a056e02156b00b00345873d1102mr270353ilu.15.1689618926963;
        Mon, 17 Jul 2023 11:35:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j2-20020a02cb02000000b0042acf934cbasm10621jap.72.2023.07.17.11.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 11:35:26 -0700 (PDT)
Date:   Mon, 17 Jul 2023 12:35:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
        naoya.horiguchi@nec.com, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Clint Sbisa <csbisa@amazon.com>, osamaabb@amazon.com
Subject: Re: [PATCH v3 1/6] kvm: determine memory type from VMA
Message-ID: <20230717123524.0cefedd0.alex.williamson@redhat.com>
In-Reply-To: <ZLRvf1M3gk4jjPp0@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
        <20230405180134.16932-2-ankita@nvidia.com>
        <86r0spl18x.wl-maz@kernel.org>
        <ZDarrZmLWlA+BHQG@nvidia.com>
        <ZHcxHbCb439I1Uk2@arm.com>
        <67a7374a72053107661ecc2b2f36fdb3ff6cc6ae.camel@kernel.crashing.org>
        <ZLQIDkFysVJ8kzkQ@arm.com>
        <ZLRvf1M3gk4jjPp0@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 16 Jul 2023 19:30:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Sun, Jul 16, 2023 at 08:09:02AM -0700, Catalin Marinas wrote:
> 
> > In terms of security for arm64 at least, Device vs Normal NC (or nc vs
> > wc in Linux terminology) doesn't make much difference with the former
> > occasionally being worse. The kernel would probably trust the DPDK code
> > if it allows direct device access.  
> 
> RDMA and DRM already allow device drivers to map WC to userspace on
> demand, we expect the platform to support this.
> 
> > > So the userspace component needs to be responsible for selecting the
> > > mapping, the same way using the PCI sysfs resource files today allows
> > > to do that by selecting the _wc variant.  
> > 
> > I guess the sysfs interface is just trying to work around the VFIO
> > limitations.  
> 
> I think just nobody has ever asked for VFIO WC support. The main
> non-VM user is DPDK and none of the NIC drivers have wanted this (DPDK
> applications areis more of throughput than latency focused typically)

Yes, QEMU can't know whether the device or driver want a WC BAR
mapping, so we've left it for KVM manipulation relative to VM use
cases.  Nobody has followed through with a complete proposal to enable
it otherwise for direct userspace driver access, but I don't think
there's opposition to providing such a thing.  Thanks,

Alex

> > > This is particularly suited for the case (which used to exist, I don't
> > > know if it still does) where the buffer that wants write combining
> > > reside in the same BAR as registers that otherwise don't.  
> > 
> > IIUC that's still the case for some devices (I think Jason mentioned
> > some Mellanox cards).  
> 
> Right, VFIO will have to allow it page-by-page
> 
> > I think this interface would help KVM when we'll need a cacheable
> > mapping. For WC, we are ok without any VFIO changes.  
> 
> Yes, it may be interesting to map cachable CXL memory as NORMAL_NC
> into userspace for similar reasons.
> 
> Jason
> 

