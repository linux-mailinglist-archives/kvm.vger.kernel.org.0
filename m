Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CB27C4C95
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjJKIDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjJKIDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:03:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2907591
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697011371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/5ZfCpKdUUub9YIdFLIytYqNrIyHV2luln8UTfMJzU=;
        b=e1pAXjtkxV8K91jxZxYYB3pJbqzuynoE/c6VTwtpSQFQnzJUwFFPDYt7YIHaijNamTSHOl
        uAMLSdHGct3s09vR8csn/iBd4GSUGrJIalp4DzA3AiSuJ0QyX7WYr0nyrPPFg1kVDXiV4G
        Z5/E7GSVWVV2JVHU4FcPYwgB4/+YR/4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-C7noLdtUOS60qYRhR35ugA-1; Wed, 11 Oct 2023 04:02:49 -0400
X-MC-Unique: C7noLdtUOS60qYRhR35ugA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-327b5f2235aso4639533f8f.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697011368; x=1697616168;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x/5ZfCpKdUUub9YIdFLIytYqNrIyHV2luln8UTfMJzU=;
        b=l1dnzJtc4lr/33RmuVZTdi16f/LiSAifNEcSIf0o/Zp/0QIUy9gZpf7XuW2k0qw3kh
         4hVdkfJPJdFRexCTnyun/Npk6xlhSiByMHYdQ1ESO/6LnnkZ0n/uTZqZusGjpr589Kah
         nGAnLIRP8S0ml6/V/QMJ2IN2mRlVFR6mfx1aRFsOagaNHxZW9EIq/YdIvsxx6I3v+3ll
         2oaF852utcuqPo0FGUjBHy6sGvFLLlWpgeIxWmVr1+MqseQ1v7kXafc171udvyNNDInu
         8OhaLf4dczGruAn/QwRRg+CiIHrwDuy5vDD6fyA2ixe3tk/3/rMtknAr55uYM2QI7VSz
         fb8A==
X-Gm-Message-State: AOJu0YwaOC2ZziySbzSkFAty38Daz1Mj55wftHFagNmB6fuvk3uBsC2o
        ZBtjY0EmZjIaHczhAxBpcf1HDS0ysl083SUZMOnLsoxbPVpEjSlTzfKQ8Dl6gPZUK5uzhW2ziIN
        91yXZGKNw+AWK
X-Received: by 2002:a5d:40c6:0:b0:31f:dcbb:f81c with SMTP id b6-20020a5d40c6000000b0031fdcbbf81cmr16323206wrq.10.1697011368591;
        Wed, 11 Oct 2023 01:02:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEc+PtozieRIw6o+DBD1V6WfEFPILOnrN/s9ngTuOjBLapZuLH7txPYobLCVofwyoztZA2I/g==
X-Received: by 2002:a5d:40c6:0:b0:31f:dcbb:f81c with SMTP id b6-20020a5d40c6000000b0031fdcbbf81cmr16323179wrq.10.1697011368212;
        Wed, 11 Oct 2023 01:02:48 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id c14-20020adfed8e000000b00317b0155502sm14626861wro.8.2023.10.11.01.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 01:02:47 -0700 (PDT)
Date:   Wed, 11 Oct 2023 04:02:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011035737-mutt-send-email-mst@kernel.org>
References: <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
 <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
 <20231010163914-mutt-send-email-mst@kernel.org>
 <f4247e59-19cd-0d6b-7728-dd1175c9d968@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4247e59-19cd-0d6b-7728-dd1175c9d968@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 10:44:49AM +0300, Yishai Hadas wrote:
> On 10/10/2023 23:42, Michael S. Tsirkin wrote:
> > On Tue, Oct 10, 2023 at 07:09:08PM +0300, Yishai Hadas wrote:
> > > > > Assuming that we'll put each command inside virtio as the generic layer, we
> > > > > won't be able to call/use this API internally to get the PF as of cyclic
> > > > > dependencies between the modules, link will fail.
> > I just mean:
> > virtio_admin_legacy_io_write(sruct pci_device *,  ....)
> > 
> > 
> > internally it starts from vf gets the pf (or vf itself or whatever
> > the transport is) sends command gets status returns.
> > 
> > what is cyclic here?
> > 
> virtio-pci depends on virtio [1].
> 
> If we put the commands in the generic layer as we expect it to be (i.e.
> virtio), then trying to call internally call for virtio_pci_vf_get_pf_dev()
> to get the PF from the VF will end-up by a linker cyclic error as of below
> [2].
> 
> As of that, someone can suggest to put the commands in virtio-pci, however
> this will fully bypass the generic layer of virtio and future clients won't
> be able to use it.

virtio_pci would get pci device.
virtio pci convers that to virtio device of owner + group member id and calls virtio.

no cycles and minimal transport specific code, right?

> In addition, passing in the VF PCI pointer instead of the VF group member ID
> + the VIRTIO PF device, will require in the future to duplicate each command
> once we'll use SIOV devices.

I don't think anyone knows how will SIOV look. But shuffling
APIs around is not a big deal. We'll see.

> Instead, we suggest the below API for the above example.
> 
> virtio_admin_legacy_io_write(virtio_device *virtio_dev,  u64
> group_member_id,  ....)
> 
> [1]

> [yishaih@reg-l-vrt-209 linux]$ modinfo virtio-pci
> filename: /lib/modules/6.6.0-rc2+/kernel/drivers/virtio/virtio_pci.ko
> version:        1
> license:        GPL
> description:    virtio-pci
> author:         Anthony Liguori <aliguori@us.ibm.com>
> srcversion:     7355EAC9408D38891938391
> alias:          pci:v00001AF4d*sv*sd*bc*sc*i*
> depends: virtio_pci_modern_dev,virtio,virtio_ring,virtio_pci_legacy_dev
> retpoline:      Y
> intree:         Y
> name:           virtio_pci
> vermagic:       6.6.0-rc2+ SMP preempt mod_unload modversions
> parm:           force_legacy:Force legacy mode for transitional virtio 1
> devices (bool)
> 
> [2]
> 
> depmod: ERROR: Cycle detected: virtio -> virtio_pci -> virtio
> depmod: ERROR: Found 2 modules in dependency cycles!
> make[2]: *** [scripts/Makefile.modinst:128: depmod] Error 1
> make[1]: *** [/images/yishaih/src/kernel/linux/Makefile:1821:
> modules_install] Error 2
> 
> Yishai

virtio absolutely must not depend on virtio pci, it is used on
systems without pci at all.

