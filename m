Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488447C4CAC
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjJKILx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjJKILx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:11:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1059B
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697011869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lbrBqmqJ7ePTBLmsl9lO89ar2Bi2NjoAUKaJegjcMuQ=;
        b=Mlq6ax1EP0sKIswzleez5HT37zWyj5GN1FChxec5ArfU5s/cMb0WbDxBkqHerISo0wr5TY
        H7dlK3mpf5fYC3BEmUl6KFq/DyP6g65Ioi55b0wq+mWfai4c4y87aV5+QHF13mFKkcZ8YW
        W1WXVght0gW5FgDyONG4hDMzVrTXAq0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-bCbBZau8MvmTjiPwMyNu8Q-1; Wed, 11 Oct 2023 04:11:03 -0400
X-MC-Unique: bCbBZau8MvmTjiPwMyNu8Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32d1ba32c95so928413f8f.3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697011862; x=1697616662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbrBqmqJ7ePTBLmsl9lO89ar2Bi2NjoAUKaJegjcMuQ=;
        b=JIiTVcWKugQcMnCUPu7m6al9w3YgKKdYEhTwiwXThoh6VLgeEXRAGeeFbw/03tD+nO
         +sKkeXOVQQexoL+zRewhMHyZYhB7a5gYcTS6WcVmxMUzuGGmTZazd2xWes3c99WguHnY
         SRAbl32B/ngiLm8rPwCzY7tp2i/hzXEO9qFI9JzNw2djdiJRh5DO4TBp57MEG3GhNvvr
         DLTOcqVkAEURwF3/vhrjE8L9MGXkKaPklFaXxp32Ku8VK27568wG8/zt2oVwiTilJbk+
         XkHx7PSJK93VrnOgttvoeVNoTjcngB64vlr1suNlUAJ2NPPK2A4fEkBfUVcL9xl/mxoS
         lHOQ==
X-Gm-Message-State: AOJu0Ywmz8yYKe8CcA44E0WauUsO1G3JBMLTJwrFxa5+13Z3T4kIIG98
        hoJ/BuwvnCk1R2QrnEDkc5CjqOKZVbcckrGn3+HSihNpuhCGEFWOG/34TmG6N/ZY+eSaBDiQNBZ
        onFKQwWJKf2/B
X-Received: by 2002:adf:eb44:0:b0:323:1887:dd6d with SMTP id u4-20020adfeb44000000b003231887dd6dmr15945094wrn.3.1697011862280;
        Wed, 11 Oct 2023 01:11:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEb99wbGqbCatj6kkdKi4CNVNLIz4pYbPSBAqvLknq9Q8mv7txYpLUIY0T/uaaITi94YyZn2w==
X-Received: by 2002:adf:eb44:0:b0:323:1887:dd6d with SMTP id u4-20020adfeb44000000b003231887dd6dmr15945083wrn.3.1697011861964;
        Wed, 11 Oct 2023 01:11:01 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d4c4a000000b00323287186aasm14697527wrt.32.2023.10.11.01.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 01:11:01 -0700 (PDT)
Date:   Wed, 11 Oct 2023 04:10:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011040331-mutt-send-email-mst@kernel.org>
References: <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 08:00:57AM +0000, Parav Pandit wrote:
> Hi Christoph,
> 
> > From: Christoph Hellwig <hch@infradead.org>
> > Sent: Wednesday, October 11, 2023 12:29 PM
> > 
> > On Wed, Oct 11, 2023 at 02:43:37AM -0400, Michael S. Tsirkin wrote:
> > > > Btw, what is that intel thing everyone is talking about?  And why
> > > > would the virtio core support vendor specific behavior like that?
> > >
> > > It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
> > > that implemented vdpa support and so Zhu Lingshan from intel is
> > > working on vdpa and has also proposed virtio spec extensions for migration.
> > > intel's driver is called ifcvf.  vdpa composes all this stuff that is
> > > added to vfio in userspace, so it's a different approach.
> > 
> > Well, so let's call it virtio live migration instead of intel.
> > 
> > And please work all together in the virtio committee that you have one way of
> > communication between controlling and controlled functions.
> > If one extension does it one way and the other a different way that's just
> > creating a giant mess.
> 
> We in virtio committee are working on VF device migration where:
> VF = controlled function
> PF = controlling function
> 
> The second proposal is what Michael mentioned from Intel that somehow combine controlled and controlling function as single entity on VF.
> 
> The main reasons I find it weird are:
> 1. it must always need to do mediation to do fake the device reset, and flr flows
> 2. dma cannot work as you explained for complex device state
> 3. it needs constant knowledge of each tiny things for each virtio device type
> 
> Such single entity appears a bit very weird to me but maybe it is just me.

Yea it appears to include everyone from nvidia. Others are used to it -
this is exactly what happens with virtio generally. E.g. vhost
processes fast path in the kernel and control path is in userspace.
vdpa has been largely modeled after that, for better or worse.
-- 
MST

