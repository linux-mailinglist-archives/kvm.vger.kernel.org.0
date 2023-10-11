Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D087C59F3
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346971AbjJKREX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346967AbjJKREU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9B4A4
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697043811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vQwaI6qzCKHaJR2pCcBdNfGrnFseeUjFkznqcANewvA=;
        b=ImvOrzbhsvv/gYq3gDqJ0zrowNEudqE4iP1Yaws6TfjLv2b+csXTXhrSMJPgWlCTNU0ASv
        5rlUORmPDx9kWrYogW64KiOoZ9ZlZwxYOkwTLPAxzfnUqzBqdFKZJG5wmCgNwClmYs/J/k
        wZ1+SFv/FXOp+6ZOzVKXOq5fnIc1w3A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-QiH1sQP7M_Oa3wLPF3MTyA-1; Wed, 11 Oct 2023 13:03:14 -0400
X-MC-Unique: QiH1sQP7M_Oa3wLPF3MTyA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fef3606d8cso725775e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697043793; x=1697648593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQwaI6qzCKHaJR2pCcBdNfGrnFseeUjFkznqcANewvA=;
        b=HgBwnHkCvMUqjKFaNBOmuuLt3nj5U/5LyZYkf/UN+voaDyDBtGfLUGWa5nE32FEQuH
         4Rnz0FRd19nQINfaRmTKISbUNch4E+1vgV6TxI2cztL2e1pCjg0Lr+Zjj7WFNh19f+00
         7CLq+ZFsxYZh06M6yK+GJKmgRQB+dhtgH2003b/MzMIhFYa9xm4u1gBsqFsauGRuRh/W
         oIIFCFVrunCyX1flYVzsuukD1itOn4StfZuO8YFAnttog+TykZSrUl82dJAcsh3r5GeE
         alj1EYjTtSjPXrGfQZXdJc4qMIuuux0JErNJxSnixDDsBbX2CdtTRpCYyxbnDbP6dwEH
         9PrQ==
X-Gm-Message-State: AOJu0YyHecFpPtRr4oBsrobvPoXKVaAPm4XSLMIBPhBfwsKJ4eKWbPBU
        INI/rIdPOXTVNBuF/AEksP38N8VMHN9TIlvsFAOU9nT8anCFUXbtwMij2wNrDthUeZEDsxOkvf5
        c+kctcnP+iQ1N
X-Received: by 2002:a05:6000:613:b0:329:6d09:61ff with SMTP id bn19-20020a056000061300b003296d0961ffmr16729094wrb.62.1697043793734;
        Wed, 11 Oct 2023 10:03:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEoqjIfx0YMUmsiEqzUF6aUikcBac9FEtKjQD1Evi5nTkjChgZ9sJaB9Sh0FuZqZOrByFhCQ==
X-Received: by 2002:a05:6000:613:b0:329:6d09:61ff with SMTP id bn19-20020a056000061300b003296d0961ffmr16729072wrb.62.1697043793440;
        Wed, 11 Oct 2023 10:03:13 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id c14-20020adfed8e000000b00317b0155502sm15903900wro.8.2023.10.11.10.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 10:03:11 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:03:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <20231011130018-mutt-send-email-mst@kernel.org>
References: <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231011040331-mutt-send-email-mst@kernel.org>
 <20231011121849.GV3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011121849.GV3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 09:18:49AM -0300, Jason Gunthorpe wrote:
> The simple way to be sure is to never touch the PCI function that has
> DMA assigned to a VM from the hypervisor, except through config space.

What makes config space different that it's safe though?
Isn't this more of a "we can't avoid touching config space" than
that it's safe? The line doesn't look that bright to me -
if there's e.g. a memory area designed explicitly for
hypervisor to poke at, that seems fine.

-- 
MST

