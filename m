Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD344C9877
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 23:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbiCAWp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 17:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238066AbiCAWpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 17:45:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CD5C77AB5
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 14:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646174679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGMUuYb5facBAKE4BWWQblYiu2u5yGmxdG+wUrk0CNE=;
        b=L+JwUzwgTLi3GUjviNXGw5wr/gwszDvyat4luhllF5qjaFn7VpZOPXu2hSyJL14+H+RCAP
        s9xBCZVUB00ewnLIsoQIJ9lwOeCwmX2HsQ6vDaI2pBM8t0SyFmNDZlvHWiwZlS+ApvpU9A
        ZIX74tB5wfBNRxnco8LfOIpoALjsSTQ=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-4LvsaXDzP5-7edusm51mkA-1; Tue, 01 Mar 2022 17:44:34 -0500
X-MC-Unique: 4LvsaXDzP5-7edusm51mkA-1
Received: by mail-ot1-f69.google.com with SMTP id f37-20020a9d2c28000000b005ad366aa68dso46473otb.8
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 14:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mGMUuYb5facBAKE4BWWQblYiu2u5yGmxdG+wUrk0CNE=;
        b=nQEsjsUlPCoLwtyPkh0GNFwYFPEyVg25th+se3HdLHZB3eyVuHhWawPEd6Rh/xwLdg
         CysCXIW9tQTs731ppbkNNZJXVsNHjIe+zQbVbSdg/n1JGF3SgxzLyQcowkR6yFFmY6C+
         xkSTATf9wc69Zj9iNIWxEzFJYXfbSFVtN6eA7XhY+WQ2w4y/zqdpuZMID8/8fy1Fc5nl
         Vz9erqDpNCnOs/IJaf/JYgqHlVefr2rXMdroGmJlaff0DMh2QcikcKWBLq4M/ppy/ep9
         IETmFABCvmfzZ5jVjaBEZAR7ypGrDai3EDRCe8n0bLQ0HXTKwf6iNcrS2kkM3ajPtRML
         0tgQ==
X-Gm-Message-State: AOAM532nfCtQ5piSBmOwROjlPuscFgDULocpBJ/4oK3itjAk/0Wf1N71
        3Zuky0AyyI5fEPA2t6KyhY1kB5GClRBoZXIQQRs6iTcV3jLeGLEiqVLOU6CaWkfDctO5/mELOSj
        ivdnr4tQDnn73
X-Received: by 2002:a05:6870:65a0:b0:d7:547:3c0b with SMTP id fp32-20020a05687065a000b000d705473c0bmr10477958oab.79.1646174673349;
        Tue, 01 Mar 2022 14:44:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0+uzXIFvxXkkhsLvg5Psp36LJMpZFA1kLIP23iFYOblelNGSikei+BKT4/FUoBnmsURZE9Q==
X-Received: by 2002:a05:6870:65a0:b0:d7:547:3c0b with SMTP id fp32-20020a05687065a000b000d705473c0bmr10477943oab.79.1646174673084;
        Tue, 01 Mar 2022 14:44:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f10-20020a9d5e8a000000b0059fa2fa9b4bsm6918556otl.13.2022.03.01.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 14:44:32 -0800 (PST)
Date:   Tue, 1 Mar 2022 15:44:31 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220301154431.42b27278.alex.williamson@redhat.com>
In-Reply-To: <20220301203938.GY219866@nvidia.com>
References: <20220228145731.GH219866@nvidia.com>
        <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
        <20220228180520.GO219866@nvidia.com>
        <20220228131614.27ad37dc.alex.williamson@redhat.com>
        <20220228202919.GP219866@nvidia.com>
        <20220228142034.024e7be6.alex.williamson@redhat.com>
        <20220228234709.GV219866@nvidia.com>
        <20220228214110.4deb551f.alex.williamson@redhat.com>
        <20220301131528.GW219866@nvidia.com>
        <20220301123047.1171c730.alex.williamson@redhat.com>
        <20220301203938.GY219866@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Mar 2022 16:39:38 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 01, 2022 at 12:30:47PM -0700, Alex Williamson wrote:
> > Wouldn't it make more sense if initial-bytes started at QM_MATCH_SIZE
> > and dirty-bytes was always sizeof(vf_data) - QM_MATCH_SIZE?  ie. QEMU
> > would know that it has sizeof(vf_data) - QM_MATCH_SIZE remaining even
> > while it's getting ENOMSG after reading QM_MATCH_SIZE bytes of data.  
> 
> The purpose of this ioctl is to help userspace guess when moving on to
> STOP_COPY is a good idea ie when the device has done almost all the
> work it is going to be able to do in PRE_COPY. ENOMSG is a similar
> indicator.
> 
> I expect all devices to have some additional STOP_COPY trailer_data in
> addition to their PRE_COPY initial_data and dirty_data
> 
> There is a choice to make if we report the trailer_data during
> PRE_COPY or not. As this is all estimates, it doesn't matter unless
> the trailer_data is very big.
> 
> Having all devices trend toward a 0 dirty_bytes to say they are are
> done all the pre-copy they can do makes sense from an API
> perspective. If one device trends toward 10MB due to a big
> trailer_data and one trends toward 0 bytes, how will qemu consistently
> decide when best to trigger STOP_COPY? It makes the API less useful.
>
> So, I would not include trailer_data in the dirty_bytes.

That assumes that it's possible to keep up with the device dirty rate.
It seems like a better approach for userspace would be to look at how
dirty_bytes is trending.  A zero value and a steady state value are
equivalent, there's nothing more to be gained by further iterations.  If
the value is trending down, it might be worthwhile to iterate in
PRE_COPY a while longer.  If the value is trending up, it might be time
to cut to STOP_COPY or abort the migration.

If we exclude STOP_COPY trailing data from the VFIO_DEVICE_MIG_PRECOPY
ioctl, it seems even more of a disconnect that when we enter the
STOP_COPY state, suddenly we start getting new data out of a PRECOPY
ioctl.

BTW, "VFIO_DEVICE" should be reserved for ioctls and data structures
relative to the device FD, appending it with _MIG is too subtle for me.
This is also a GET operation for INFO, so I'd think for consistency
with the existing vfio uAPI we'd name this something like
VFIO_MIG_GET_PRECOPY_INFO where the structure might be named
vfio_precopy_info.

> Estimating when to move on to STOP_COPY and trying to enforce a SLA on
> STOP_COPY are different tasks and will probably end up with different
> interfaces.
> 
> I still think the right way to approach the SLA is to inform the
> driver what the permitted time and data size target is for STOP_COPY
> and the driver can proceed or not based on its own internal
> calculation.

So if we don't think this is the right approach for STOP_COPY, then why
are we pushing that it has any purpose outside of PRECOPY or might be
implemented by a non-PRECOPY driver for use in STOP_COPY?
 
> > useful yet and you don't want to add dead kernel code, then let's
> > define that this ioctl is only available in the PRE_COPY* states and
> > returns -errno in the STOP_COPY state.  
> 
> I'm OK with that, in acc it is done by checking migf->total_bytes >
> QM_MATCH_SIZE during the read fop
> 
> > devices in STOP_COPY and let's also define if there's actually anything
> > userspace can infer about remaining STOP_COPY data size while in
> > PRE_COPY* via this ioctl.  For example, is dirty-bytes zero or the
> > remaining data structure size?  
> 
> If we keep it then I would say it doesn't matter, userspace has to sum
> the two values to get the total remaining length estimate, it is just
> a bit quirky.

For the reasons above, I just can't figure out why wouldn't decide that
use of this outside of PRECOPY is too quirky to bother with.  Thanks,

Alex

