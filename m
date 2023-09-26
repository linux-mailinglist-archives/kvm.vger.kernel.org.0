Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D627AE530
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 07:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjIZFnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 01:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjIZFnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 01:43:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AADFF3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 22:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695706983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6PTVVGgnSxG292uHCCvsYdfBj5DPcr+BlloC+r5OzIo=;
        b=jOZ5NdNKkfPMq29WMtbSBwdvL4h6eF0nIt/a0ln9aDbEALoy4bbAWkt+T3ZV1UgFuBdZf6
        MzRU25K11JF5l3MyLz5H8e1Zcq3yoHM1YjtU4yKtSstbRo3WRE2l6gNXmU/t0TgHnfydit
        jt0Tq/nFy3bpGSD874vmwnhbvZcrNaU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-RExIcTYVNqyDcgMRU--V9g-1; Tue, 26 Sep 2023 01:42:59 -0400
X-MC-Unique: RExIcTYVNqyDcgMRU--V9g-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50433324cf3so10988387e87.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 22:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695706977; x=1696311777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PTVVGgnSxG292uHCCvsYdfBj5DPcr+BlloC+r5OzIo=;
        b=oFI157Hz5tArAjU4EhAxL2pSWKx7NieAbWvuhMbL7VwLXcZf94Dg0i40wE1XgBaqLt
         21uzTIPRMh+yo1JuLjunthdb1uyerIoByohLAk+FgRdNvnQzkx7na6MHk/Fza9KlFru5
         N1oHZ67obX/W1rprtqxLZXQqdReNuLGTV0My0AoPZydo0R3/8rN1NOdU+r2GUm1CBF/g
         i3TLsCkRhp3S12Zp+kyX8Rbdce+ynXM2Qg7ZvPYVn9gk0oO5n2xoAON7ZikeBwASXv2u
         rv5yZRD4A1XcjzZf0JXL+AnN6kDS6v5eHU9Vl7kgMG1TRbJAdGxw7fjFpSixTdLlbvyr
         1WZw==
X-Gm-Message-State: AOJu0YzLqY9+8t/VBfC66zlBH9lRLXTWeSr21oLiJI2fAuoh/bnC8Xtx
        5tyqEd1iZ3bzJgrKaDmep2JyciZUM2m/h4nleuyAYa2oOb9cVagng5UnbccZKmJrmpdm5Lp1nQH
        nYBrjJ3KrvWbb7Gv8xJauRsQ=
X-Received: by 2002:a05:6512:547:b0:4f8:7513:8cac with SMTP id h7-20020a056512054700b004f875138cacmr6549923lfl.48.1695706977472;
        Mon, 25 Sep 2023 22:42:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3PKzs08RZrdyPVtt6kvBErYsZn9mRO+eRjTXkFSHQF1HStKvm+y1T3gseydhDZJdu84Zd2Q==
X-Received: by 2002:a05:6512:547:b0:4f8:7513:8cac with SMTP id h7-20020a056512054700b004f875138cacmr6549909lfl.48.1695706977143;
        Mon, 25 Sep 2023 22:42:57 -0700 (PDT)
Received: from redhat.com ([2.52.31.177])
        by smtp.gmail.com with ESMTPSA id z15-20020a05640235cf00b00533fa47273fsm2642675edc.42.2023.09.25.22.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 22:42:56 -0700 (PDT)
Date:   Tue, 26 Sep 2023 01:42:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230926014005-mutt-send-email-mst@kernel.org>
References: <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
 <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
 <20230926004059.GM13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926004059.GM13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 09:40:59PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > > VDPA is very different from this. You might call them both mediation,
> > > sure, but then you need another word to describe the additional
> > > changes VPDA is doing.
> > 
> > Sorry about hijacking the thread a little bit, but could you
> > call out some of the changes that are the most problematic
> > for you?
> 
> I don't really know these details.

Maybe, you then should desist from saying things like "It entirely fails
to achieve the most important thing it needs to do!" You are not making
any new friends with saying this about a piece of software without
knowing the details.

-- 
MST

