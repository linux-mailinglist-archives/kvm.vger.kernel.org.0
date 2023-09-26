Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E27AF6A6
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 01:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjIZXQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 19:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjIZXOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 19:14:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B4EAD11
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 15:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695766572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3J9j9m+j6P1P4M2qp9sCi0IOwoWpws4ikB1Cmd0FSNs=;
        b=iBl30xI1E8s6c2I6Wv/KwWy6TgLgoyzCpoxDgbkdc8QUW7Np/5IG4ItplvloL8KlLTTbI3
        ys5UL66OjXeeNDYEVMTT9h825AmupEzJu8dDD0gcBe9o0JdopczXk4sFWgOoAu+o4UNY02
        yyQAvrZGTi7zHb474qqM6hBRhxfFRVo=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-Al6Ra-aGN4mKIsJBZ-_vxA-1; Tue, 26 Sep 2023 17:45:43 -0400
X-MC-Unique: Al6Ra-aGN4mKIsJBZ-_vxA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3512c238f25so91245465ab.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 14:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695764743; x=1696369543;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3J9j9m+j6P1P4M2qp9sCi0IOwoWpws4ikB1Cmd0FSNs=;
        b=gZX8blSGo8YMH5hC2/TXKqM0wB9sMNLhIeUa5MOWX+Nz6J48zRVeQJTtLizXr5sv+n
         Bm+t67z2Noz9DQNeCFfshifJgjZHoP4eyM2HTTBytADrwFRwIkWSNrGdj3qcYDJVz47l
         KNl4AGuu9hTjC0W+CaxlfwWAotjTx+nYPw/Iyzvl61lBttUDlpxePEBPE0fh1Dg56+Dz
         OlJOBvHhsl2gbx8t+A7YhzjxV1gLaurVuH2ffjNQx7rzvciktg7BIe3gcAsCaq7HtDT6
         2+HZjrHUzXL3U4b+81b7Q5yz9yul5JGNywqJ5o7YhXEeaizbq5jYOJYUjRYy97AebWPn
         gEzw==
X-Gm-Message-State: AOJu0Yy6EOz3lZnmle9LQm5HXJzmVxg/IM2sLCxG4Gk1edMy/wQTHwBx
        PlXe88vTV4Pz2nZ5f/Otkq0Y6WMDRAaaO4YYeWrTw3aH7UZCA3EWHrArboClWHad8Usq/JoihRG
        /yHwujMKYiyQF00Izv2JK
X-Received: by 2002:a05:6e02:df3:b0:351:4b68:ec3a with SMTP id m19-20020a056e020df300b003514b68ec3amr150390ilj.9.1695764742890;
        Tue, 26 Sep 2023 14:45:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/MDiP0pxOC1uauE37FJ41PWNUl50i0CYExghA0WvcIYI5tgjyVOnwOO5RdC5J5thlyRS0pQ==
X-Received: by 2002:a05:6e02:df3:b0:351:4b68:ec3a with SMTP id m19-20020a056e020df300b003514b68ec3amr150378ilj.9.1695764742641;
        Tue, 26 Sep 2023 14:45:42 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id 1-20020a92c641000000b00351500b12c3sm852221ill.21.2023.09.26.14.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 14:45:41 -0700 (PDT)
Date:   Tue, 26 Sep 2023 15:45:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fix for v6.6-rc4
Message-ID: <20230926154538.20a5b2c4.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.6-rc4

for you to fetch changes up to c777b11d34e0f47dbbc4b018ef65ad030f2b283a:

  vfio/mdev: Fix a null-ptr-deref bug for mdev_unregister_parent() (2023-09-22 12:48:04 -0600)

----------------------------------------------------------------
VFIO fixes for v6.6-rc4

 - The new PDS vfio-pci variant driver only supports SR-IOV VF devices
   and incorrectly made a direct reference to the physfn field of the
   pci_dev.  Fix this both by making the Kconfig depend on IOV support
   as well as using the correct wrapper for this access. (Shixiong Ou)

 - Resolve an error path issue where on unwind of the mdev registration
   the created kset is not unregistered and the wrong error code is
   returned. (Jinjie Ruan)

----------------------------------------------------------------
Jinjie Ruan (1):
      vfio/mdev: Fix a null-ptr-deref bug for mdev_unregister_parent()

Shixiong Ou (2):
      vfio/pds: Add missing PCI_IOV depends
      vfio/pds: Use proper PF device access helper

 drivers/vfio/mdev/mdev_sysfs.c  | 3 ++-
 drivers/vfio/pci/pds/Kconfig    | 2 +-
 drivers/vfio/pci/pds/vfio_dev.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

