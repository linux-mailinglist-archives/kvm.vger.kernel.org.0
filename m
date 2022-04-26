Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82B251075E
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 20:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345243AbiDZStE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 14:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352386AbiDZStC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 14:49:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38C5189309
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650998753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iu5LkZeNebV7ZZD2/4JfhEX4w8qXaBt2S80lON09i0M=;
        b=Bsbnotg+fnAvsnvVCyKbCEzu4J8VxNc7vDoMExmoE9W7StWCBwT4oSCBC4lOkGeE6zBzz6
        S8e6GW6ls+Uh4ipoQ9DFQpuwWF1RwN/DFsoNZftvhLLvnQKA+x58Hl1NY41g3lklirqDUE
        VQkjPyPeqbfaj4rHjbBUCbTsTTvfLBw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-l9yM8tNSPR-fsssvIW17RA-1; Tue, 26 Apr 2022 14:45:44 -0400
X-MC-Unique: l9yM8tNSPR-fsssvIW17RA-1
Received: by mail-io1-f72.google.com with SMTP id n9-20020a056602340900b006572c443316so13932668ioz.23
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 11:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iu5LkZeNebV7ZZD2/4JfhEX4w8qXaBt2S80lON09i0M=;
        b=yXbJ8AEpOtWqotSkvegCk5jynwzapIoSgeejiXm0FM5CiEKlE21Fm/1XvB8y8B2EZ6
         QHR1QRUIj3/Ewy+WlJByRsdIOT+MV5upih41JaKjwC9Zd3TSg/ZET7wFOUnyqT4sNmtF
         3uHEitxtF2rZzzdHbwtHo4b6zlYGNyvVr4dcbo0c4SebQCP20pIyJxi1vU7iGIJ856JG
         inBxX0tuZZ1rn2PQqBv9muKV+gb3AUY6bfRzkCB0rv+vDlWOCkCSyfYb6TZhVs7uOMuz
         1ZW8B/8A6zJZIZhUI5HIRMt1KejIdAT78Vhlux7wpvwPKH4/lK9W7u/1PHow682h2q3R
         XNnw==
X-Gm-Message-State: AOAM533ynnVsOHeZwPUK56l99RQ3Z8n0p1DDQwr+trIwnFgRspJvjqRE
        fcJYxEzLdfGfIqKI1IWZtQQxebHlTmk+YSw3cAF3459gz4rxNfssHbxhRluKQedwaER8PfMFljE
        opSHN5eFnexEj
X-Received: by 2002:a05:6638:16d2:b0:323:7285:474b with SMTP id g18-20020a05663816d200b003237285474bmr11369312jat.61.1650998743550;
        Tue, 26 Apr 2022 11:45:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIJFnLBCJRxvz2uN9ezQ1TKeJbab3Wz+HxEWH2jg4/Y7GJ7GIu68+l8IH3yRCrQsAmSBg+OQ==
X-Received: by 2002:a05:6638:16d2:b0:323:7285:474b with SMTP id g18-20020a05663816d200b003237285474bmr11369292jat.61.1650998743322;
        Tue, 26 Apr 2022 11:45:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e17-20020a5d8ad1000000b00644d51bbffcsm10179822iot.36.2022.04.26.11.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:45:42 -0700 (PDT)
Date:   Tue, 26 Apr 2022 12:45:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220426124541.5f33f357.alex.williamson@redhat.com>
In-Reply-To: <20220426141156.GO2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220414104710.28534-16-yi.l.liu@intel.com>
        <20220422145815.GK2120790@nvidia.com>
        <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
        <BN9PR11MB5276AD0B0DAA59A44ED705618CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220426134114.GM2125828@nvidia.com>
        <79de081d-31dc-41a4-d38f-1e28327b1152@intel.com>
        <20220426141156.GO2125828@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Apr 2022 11:11:56 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 26, 2022 at 10:08:30PM +0800, Yi Liu wrote:
> 
> > > I think it is strange that the allowed DMA a guest can do depends on
> > > the order how devices are plugged into the guest, and varys from
> > > device to device?
> > > 
> > > IMHO it would be nicer if qemu would be able to read the new reserved
> > > regions and unmap the conflicts before hot plugging the new device. We
> > > don't have a kernel API to do this, maybe we should have one?  
> > 
> > For userspace drivers, it is fine to do it. For QEMU, it's not quite easy
> > since the IOVA is GPA which is determined per the e820 table.  
> 
> Sure, that is why I said we may need a new API to get this data back
> so userspace can fix the address map before attempting to attach the
> new device. Currently that is not possible at all, the device attach
> fails and userspace has no way to learn what addresses are causing
> problems.

We have APIs to get the IOVA ranges, both with legacy vfio and the
iommufd RFC, QEMU could compare these, but deciding to remove an
existing mapping is not something to be done lightly.  We must be
absolutely certain that there is no DMA to that range before doing so.
 
> > > eg currently I see the log messages that it is passing P2P BAR memory
> > > into iommufd map, this should be prevented inside qemu because it is
> > > not reliable right now if iommufd will correctly reject it.  
> > 
> > yeah. qemu can filter the P2P BAR mapping and just stop it in qemu. We
> > haven't added it as it is something you will add in future. so didn't
> > add it in this RFC. :-) Please let me know if it feels better to filter
> > it from today.  
> 
> I currently hope it will use a different map API entirely and not rely
> on discovering the P2P via the VMA. eg using a DMABUF FD or something.
> 
> So blocking it in qemu feels like the right thing to do.

Wait a sec, so legacy vfio supports p2p between devices, which has a
least a couple known use cases, primarily involving GPUs for at least
one of the peers, and we're not going to make equivalent support a
feature requirement for iommufd?  This would entirely fracture the
notion that iommufd is a direct replacement and upgrade from legacy
vfio and make a transparent transition for libvirt managed VMs
impossible.  Let's reconsider.  Thanks,

Alex

