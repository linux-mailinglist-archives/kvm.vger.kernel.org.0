Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682FD686B21
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 17:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjBAQHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 11:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjBAQHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 11:07:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F4A49940
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 08:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675267607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ds+bcOZr5heYmlSzGupYn5r7OWFEs+A7chvOhxHR7is=;
        b=RnDRKjlxzP48Wu1zOz6UQ4Z8ZK9yLwYK2ejdjfJItrSIRTrjTwf2AaD5S7CEOaCBqe55ce
        oJjXIoAyw4/1bUrLO9nCtlhO8OYiayCrDcYXdAecq9jHoxli/GO4wHRoz5JobgU8lhxoBV
        +rI+3FtDleyN+tiYUYsy9WzBlrcXmXA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-214-CMxQ4xz0OomULDbwhGU3qg-1; Wed, 01 Feb 2023 11:06:46 -0500
X-MC-Unique: CMxQ4xz0OomULDbwhGU3qg-1
Received: by mail-wm1-f72.google.com with SMTP id ay19-20020a05600c1e1300b003dc54daba42so5834488wmb.7
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 08:06:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ds+bcOZr5heYmlSzGupYn5r7OWFEs+A7chvOhxHR7is=;
        b=Y451P7BYlJ/p2ZDugRJrDXiqX0OooxX60SVtNiDqkc9ZAbNdM+jqhINNpW16nzWGWO
         q1BYBJVreSFuH5I+LbnOvF7znOwh1nh62KzDj792pETW/DBx/8Yb+ro2uCi0BSR5dN4s
         JzCOkTCDZ6C/fBRFRuaK9r06qNTslXjZdMUd4vpQ7NwCw2+OzVNtwVrVcAK46BW8DAfP
         tEJZcj9vHcbYF1Uips98GkGMc88HEtNq2fpoF9a57TtyIMeZByhKni6I2hDpbZF8NXTU
         EDaiVrbPTSYVTg3991tNhO7xyuKU7VjfG2x+Lt4mSwrCYg12f0j5usLrOFX5kMOu4Czn
         TCaQ==
X-Gm-Message-State: AO0yUKXl1QF9zSv+G4/U60tCQLry0xjwjr3HDVbyjtfAskx3C6UYCCRJ
        CpkLUveWfNyHlQ0gE+VLOhsbLR359wz/xGcapljPFXmvkceYzL5solgYrTa3srYBqWcungPak2w
        ceC/26Qb+WXYx
X-Received: by 2002:a7b:c85a:0:b0:3d2:392e:905f with SMTP id c26-20020a7bc85a000000b003d2392e905fmr2555818wml.24.1675267604393;
        Wed, 01 Feb 2023 08:06:44 -0800 (PST)
X-Google-Smtp-Source: AK7set/jVf+CtAKaPX7i2XRfI1mq5BUZBWlGIqJzw98LsyTbSpvTi0jhWMgxZEzgBzcbZq6TokPTHg==
X-Received: by 2002:a7b:c85a:0:b0:3d2:392e:905f with SMTP id c26-20020a7bc85a000000b003d2392e905fmr2555797wml.24.1675267604200;
        Wed, 01 Feb 2023 08:06:44 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id m13-20020a05600c3b0d00b003dc51c48f0bsm2433516wms.19.2023.02.01.08.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:06:43 -0800 (PST)
Date:   Wed, 1 Feb 2023 11:06:40 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        007047221b@gmail.com, bcodding@redhat.com, eric.auger@redhat.com,
        jasowang@redhat.com, lingshan.zhu@intel.com, mie@igel.co.jp,
        mst@redhat.com, nab@linux-iscsi.org, viro@zeniv.linux.org.uk
Subject: [GIT PULL] virtio,vhost,vdpa: fixes
Message-ID: <20230201110640-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 2241ab53cbb5cdb08a6b2d4688feb13971058f65:

  Linux 6.2-rc5 (2023-01-21 16:27:01 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6b04456e248761cf68f562f2fd7c04e591fcac94:

  vdpa: ifcvf: Do proper cleanup if IFCVF init fails (2023-01-27 06:18:41 -0500)

----------------------------------------------------------------
virtio,vhost,vdpa: fixes

Just small bugfixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eric Auger (1):
      vhost/net: Clear the pending messages when the backend is removed

Jason Wang (1):
      vhost-scsi: unbreak any layout for response

Shunsuke Mie (1):
      tools/virtio: fix the vringh test for virtio ring changes

Tanmay Bhushan (1):
      vdpa: ifcvf: Do proper cleanup if IFCVF init fails

 drivers/vdpa/ifcvf/ifcvf_main.c  |  2 +-
 drivers/vhost/net.c              |  3 +++
 drivers/vhost/scsi.c             | 21 +++++++++++++++++----
 drivers/vhost/vhost.c            |  3 ++-
 drivers/vhost/vhost.h            |  1 +
 tools/virtio/linux/bug.h         |  8 +++-----
 tools/virtio/linux/build_bug.h   |  7 +++++++
 tools/virtio/linux/cpumask.h     |  7 +++++++
 tools/virtio/linux/gfp.h         |  7 +++++++
 tools/virtio/linux/kernel.h      |  1 +
 tools/virtio/linux/kmsan.h       | 12 ++++++++++++
 tools/virtio/linux/scatterlist.h |  1 +
 tools/virtio/linux/topology.h    |  7 +++++++
 13 files changed, 69 insertions(+), 11 deletions(-)
 create mode 100644 tools/virtio/linux/build_bug.h
 create mode 100644 tools/virtio/linux/cpumask.h
 create mode 100644 tools/virtio/linux/gfp.h
 create mode 100644 tools/virtio/linux/kmsan.h
 create mode 100644 tools/virtio/linux/topology.h

