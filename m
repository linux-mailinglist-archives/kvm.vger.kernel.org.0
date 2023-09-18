Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BAB7A55D7
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 00:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjIRWkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 18:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIRWkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 18:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E24C91
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 15:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695076761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F62gKhewIRopQDAF3fGeRizM+WnsSf5e1dSIl2Kdrrs=;
        b=OUwU+jFR8qeYm8iDV2z3bGalgALRkkOzXWTKXDVvFkaj1OR9RVL+fbEmi+BrDqfqRcmNtE
        ToNNNLJUHg5tCCotc2etEInxQXFrkaRFW95kG0ZRFm/P8vbIbtrS291TjrhP6+myv1p51y
        C+UGdcWFj7nWpKFkOYd68IERkwopT+o=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-WfJ-aTOJOsOZIVa5MHCkow-1; Mon, 18 Sep 2023 18:39:19 -0400
X-MC-Unique: WfJ-aTOJOsOZIVa5MHCkow-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-34ffcb18cf7so4484195ab.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 15:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695076759; x=1695681559;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F62gKhewIRopQDAF3fGeRizM+WnsSf5e1dSIl2Kdrrs=;
        b=rLI33HFOW7FWWmS0cjoZ8Uft/9F/nZqpWdRi6NoAHuIcYMgTMJmyirCd3WFz36VuGE
         nCcd6TrHSuv3uf5cinf17g9kWTjBFVFhU1D3CEB/OGlW7KSYHIEDqJn/SPV60N8oudV0
         wYgiUO4KlvNiAqRwhCHIzqAsZUQiPSSmwXjV80FxQQAUT7W8Xgo3CSxwN5rcv26PaMIL
         ywuEKLoVlxik+y+rlkQSx/+dLCigxnqZYTmAtv/FAz2HzLrUmDpt91ZCsDlUwJ5oLB6h
         7PjeKusqphrIkEmWxAOpTj1ofHX2OMR4MtxoB8bsm42FszREIMtQyO+3KTGYOxmLCmrY
         ZmMQ==
X-Gm-Message-State: AOJu0YyZhYYe7041SBLFzqP3xZNNW1bZYEcwP0u4nsNWPDsu4xM+0Uno
        7/iYmmpRb2IzlRCrQuki3qWBZWqRpgKHWuCA500yljhotQqnB5z+zOyFuG8+J4SgQaPtMZIwdpB
        H3gxNvZbnV0gQ871TqIT6
X-Received: by 2002:a05:6e02:1069:b0:34f:d945:23b0 with SMTP id q9-20020a056e02106900b0034fd94523b0mr6140355ilj.30.1695076758801;
        Mon, 18 Sep 2023 15:39:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjOpV4VLeNeHO4FY/OSDfU2TbAPpfMDYAGDz77ijLLcXEsc/BvzoNmAU9ysRg8UT0gTVNZBA==
X-Received: by 2002:a05:6e02:1069:b0:34f:d945:23b0 with SMTP id q9-20020a056e02106900b0034fd94523b0mr6140349ilj.30.1695076758560;
        Mon, 18 Sep 2023 15:39:18 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id o3-20020a056e02068300b0034fda29890asm1604449ils.10.2023.09.18.15.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 15:39:18 -0700 (PDT)
Date:   Mon, 18 Sep 2023 16:39:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     <kvm@vger.kernel.org>, <kwankhede@nvidia.com>, <kraxel@redhat.com>,
        <cjia@nvidia.com>
Subject: Re: [PATCH 0/3] vfio: Fix the null-ptr-deref bugs in samples of
 vfio-mdev
Message-ID: <20230918163916.539716f4.alex.williamson@redhat.com>
In-Reply-To: <20230909070952.80081-1-ruanjinjie@huawei.com>
References: <20230909070952.80081-1-ruanjinjie@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 9 Sep 2023 15:09:49 +0800
Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> There is a null-ptr-deref bug in strchr() of device_add(), if the kstrdup()
> fails in kobject_set_name_vargs() in dev_set_name(). This patchset fix
> the issues.
> 
> Jinjie Ruan (3):
>   vfio/mdpy: Fix the null-ptr-deref bug in mdpy_dev_init()
>   vfio/mtty: Fix the null-ptr-deref bug in mtty_dev_init()
>   vfio/mbochs: Fix the null-ptr-deref bug in mbochs_dev_init()
> 
>  samples/vfio-mdev/mbochs.c | 4 +++-
>  samples/vfio-mdev/mdpy.c   | 4 +++-
>  samples/vfio-mdev/mtty.c   | 4 +++-
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 

These all target the wrong goto label, aiui we can't call put_device()
if we haven't called device_initialize(), so I think there needs to be
an intermediate label added before class_destroy().  Thanks,

Alex

