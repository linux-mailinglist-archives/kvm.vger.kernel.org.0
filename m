Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A130F6CD161
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 07:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjC2FBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 01:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2FBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 01:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC02273E
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 22:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680066021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=We+AZVUP/d8CpVL/j63W3UR9arAJANgsuPfOHKpyQb4=;
        b=NR5ayrsHr6+CBr5SkwmO0Sy5dhkQlGntZAl5BtviSnB2h8rIFyb2qSkok7mYtiveoL4PVa
        I+ue2TeIzw3T1jHGA2O6KdpcM+XcAeXuHJwGJ/yMh8PpmfSZy9jZlOat47kH5aX+sCii3F
        Xsx/Xyacyt6PLkzal5f2DNJaQU5M9rg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-_MErfbT9OuyQqiZ0d4_F-g-1; Wed, 29 Mar 2023 01:00:19 -0400
X-MC-Unique: _MErfbT9OuyQqiZ0d4_F-g-1
Received: by mail-wm1-f71.google.com with SMTP id iv10-20020a05600c548a00b003ee112e6df1so7504632wmb.2
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 22:00:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680066018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=We+AZVUP/d8CpVL/j63W3UR9arAJANgsuPfOHKpyQb4=;
        b=kkQyyAWX64TA0mjtqRuaGZOk+wyikVc/pg3n13Y01C7E+MNNDA7fTQe+ubk1xurnzh
         qejWGkWyOBPFOUSQmeOTCPkhE4pFh6FqN4/oiRzF7z2oJ8TrpdZq/ElFY4HBs1lAgWsI
         YrDTQlasaIDD8Xc8Utvytlgdh332jrnYCnQN+pTL+0q4mz+48mkCiDMcGpMvc7bIRQo1
         UGBzruFeweWXNTMamD6gCH9tY3d48pn46u/ugug/glTS4O3zD9589NjJKxHeO++2Cg82
         mCSsVv6GZekvOvnyvtDHw/R8pJAYFv3muGWnnHY/XCn6S9vEy0YbwamPCeuqxh5G55RT
         CJSA==
X-Gm-Message-State: AAQBX9evWa77kjo+VnhybO1Gdn1Ul9+ryIlPEjEsUBosaSm8Prn6D3O5
        SB8PBC985ZXrLEpTL/URjWYkfO5z5rq9MU54C+f/mZ4ReOjnH3x2oqINpk7gO0w2Rh10+Y8yAOx
        okrOzvbrlwZGt
X-Received: by 2002:a05:6000:7:b0:2cd:e0a8:f2dc with SMTP id h7-20020a056000000700b002cde0a8f2dcmr14955483wrx.7.1680066018334;
        Tue, 28 Mar 2023 22:00:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350YDOk0pvKdBoYaZ8VC7rjX27v+hYK6oK1AhzIPMsliLPfZOypHN1UqK4iziIPJoino86cEe/w==
X-Received: by 2002:a05:6000:7:b0:2cd:e0a8:f2dc with SMTP id h7-20020a056000000700b002cde0a8f2dcmr14955464wrx.7.1680066017945;
        Tue, 28 Mar 2023 22:00:17 -0700 (PDT)
Received: from redhat.com ([2.52.18.165])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d4e8d000000b002ceacff44c7sm29232578wru.83.2023.03.28.22.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 22:00:17 -0700 (PDT)
Date:   Wed, 29 Mar 2023 01:00:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sam Li <faithilikerun@gmail.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, dmitry.fomichev@wdc.com,
        kvm@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        hare@suse.de, Kevin Wolf <kwolf@redhat.com>, qemu-block@nongnu.org
Subject: Re: [PATCH v9 0/5] Add zoned storage emulation to virtio-blk driver
Message-ID: <20230329005755-mutt-send-email-mst@kernel.org>
References: <20230327144553.4315-1-faithilikerun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327144553.4315-1-faithilikerun@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 10:45:48PM +0800, Sam Li wrote:
> This patch adds zoned storage emulation to the virtio-blk driver. It
> implements the virtio-blk ZBD support standardization that is
> recently accepted by virtio-spec. The link to related commit is at
> 
> https://github.com/oasis-tcs/virtio-spec/commit/b4e8efa0fa6c8d844328090ad15db65af8d7d981
> 
> The Linux zoned device code that implemented by Dmitry Fomichev has been
> released at the latest Linux version v6.3-rc1.
> 
> Aside: adding zoned=on alike options to virtio-blk device will be
> considered in following-up plan.
> 
> Note: Sorry to send it again because of the previous incoherent patches caused
> by network error.

virtio bits look ok.

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

merge through block layer tree I'm guessing?


> v9:
> - address review comments
>   * add docs for zoned emulation use case [Matias]
>   * add the zoned feature bit to qmp monitor [Matias]
>   * add the version number for newly added configs of accounting [Markus]
> 
> v8:
> - address Stefan's review comments
>   * rm aio_context_acquire/release in handle_req
>   * rename function return type
>   * rename BLOCK_ACCT_APPEND to BLOCK_ACCT_ZONE_APPEND for clarity
> 
> v7:
> - update headers to v6.3-rc1
> 
> v6:
> - address Stefan's review comments
>   * add accounting for zone append operation
>   * fix in_iov usage in handle_request, error handling and typos
> 
> v5:
> - address Stefan's review comments
>   * restore the way writing zone append result to buffer
>   * fix error checking case and other errands
> 
> v4:
> - change the way writing zone append request result to buffer
> - change zone state, zone type value of virtio_blk_zone_descriptor
> - add trace events for new zone APIs
> 
> v3:
> - use qemuio_from_buffer to write status bit [Stefan]
> - avoid using req->elem directly [Stefan]
> - fix error checkings and memory leak [Stefan]
> 
> v2:
> - change units of emulated zone op coresponding to block layer APIs
> - modify error checking cases [Stefan, Damien]
> 
> v1:
> - add zoned storage emulation
> 
> Sam Li (5):
>   include: update virtio_blk headers to v6.3-rc1
>   virtio-blk: add zoned storage emulation for zoned devices
>   block: add accounting for zone append operation
>   virtio-blk: add some trace events for zoned emulation
>   docs/zoned-storage:add zoned emulation use case
> 
>  block/qapi-sysemu.c                          |  11 +
>  block/qapi.c                                 |  18 +
>  docs/devel/zoned-storage.rst                 |  17 +
>  hw/block/trace-events                        |   7 +
>  hw/block/virtio-blk-common.c                 |   2 +
>  hw/block/virtio-blk.c                        | 405 +++++++++++++++++++
>  hw/virtio/virtio-qmp.c                       |   2 +
>  include/block/accounting.h                   |   1 +
>  include/standard-headers/drm/drm_fourcc.h    |  12 +
>  include/standard-headers/linux/ethtool.h     |  48 ++-
>  include/standard-headers/linux/fuse.h        |  45 ++-
>  include/standard-headers/linux/pci_regs.h    |   1 +
>  include/standard-headers/linux/vhost_types.h |   2 +
>  include/standard-headers/linux/virtio_blk.h  | 105 +++++
>  linux-headers/asm-arm64/kvm.h                |   1 +
>  linux-headers/asm-x86/kvm.h                  |  34 +-
>  linux-headers/linux/kvm.h                    |   9 +
>  linux-headers/linux/vfio.h                   |  15 +-
>  linux-headers/linux/vhost.h                  |   8 +
>  qapi/block-core.json                         |  68 +++-
>  qapi/block.json                              |   4 +
>  21 files changed, 794 insertions(+), 21 deletions(-)
> 
> -- 
> 2.39.2

