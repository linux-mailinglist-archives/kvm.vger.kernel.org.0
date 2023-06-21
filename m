Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393CA738881
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjFUPLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjFUPLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94B45266
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 08:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687359892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=uMB3ETdHgdD0tMcM81kCwTmy5JB6eW9+tHfNYuJVs80=;
        b=E6GkFbs/KiejNPlplcNcS0S1mOvYWj3rPNcNVNR3I9mi4VB5PEvXk2m89tFJqTPxpeNITX
        eAMHgAdoRLLSIRVTuRNuBf18InLHAulNr6XJRq4N4ujsMnXjUPlfcmD9/XFrJtMx7Bme4n
        WjuB+tm7eSoFn3sFAQ/9SuHSXc02J90=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-jYiJ27skNTGz3ftr59sUbw-1; Wed, 21 Jun 2023 11:04:42 -0400
X-MC-Unique: jYiJ27skNTGz3ftr59sUbw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b46dc4f6faso33392781fa.3
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 08:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687359881; x=1689951881;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMB3ETdHgdD0tMcM81kCwTmy5JB6eW9+tHfNYuJVs80=;
        b=L4pTXdexMAjILTOcSTK0jKRzObb1AhfWFPd08a3hm6wtmGwaeoEpmzsxAP3/WxcX8q
         JicdU8MvYBMp2HHLHqfAw7lzBp4NLHc9w8Qy+hefLbgJrm/HwHtFlYQASUrYS4k7FTDI
         gntgjT0VvakFgcnvRS411KBYyMPsX8d/YPaYIIIF4dY563zGqhxN6/CBrbsE25zloT0h
         Y1xj3XuAwpYqOZKaLxSwCvQPRTJrlCT5fwqWgmyj+W2T5jFN4FcSFVCHnL+mqo/kakWv
         bsDruH84jKXByg1y0mxFgpDTzpkjMIIhZ8gd8Repb4lgXfy7EJaWxYcANjXRRiY4c5oe
         8WyA==
X-Gm-Message-State: AC+VfDzs2A0B/pxSgED6Aydedv2oX8pafu8a9HKWRVjit2K5tk3pulTz
        5W5rnsM1edGOxU8TXp4OdCGF8UP83YqbOzjbKp226B/gHNzum8r/IOGLznooQ2o/T473LtoB0ZN
        ZzH4Z0TBQL74I
X-Received: by 2002:a05:651c:8c:b0:2ad:9783:bca with SMTP id 12-20020a05651c008c00b002ad97830bcamr9809839ljq.27.1687359880943;
        Wed, 21 Jun 2023 08:04:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6vuvyyKGk8qVbIbbO2C0uzdA3jUE5LT/K/8MPLqve8CmK2tHPbnZ1hPdf3acB2DVxep5kd3w==
X-Received: by 2002:a05:651c:8c:b0:2ad:9783:bca with SMTP id 12-20020a05651c008c00b002ad97830bcamr9809823ljq.27.1687359880587;
        Wed, 21 Jun 2023 08:04:40 -0700 (PDT)
Received: from redhat.com ([2.52.159.126])
        by smtp.gmail.com with ESMTPSA id e14-20020a50ec8e000000b0051a5c6a50d4sm2743117edr.51.2023.06.21.08.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 08:04:39 -0700 (PDT)
Date:   Wed, 21 Jun 2023 11:04:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edliaw@google.com, lkp@intel.com, martin.roberts@intel.com,
        mst@redhat.com, suwan.kim027@gmail.com
Subject: [GIT PULL] virtio: last minute revert
Message-ID: <20230621110431-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 45a3e24f65e90a047bef86f927ebdc4c710edaa1:

  Linux 6.4-rc7 (2023-06-18 14:06:27 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to afd384f0dbea2229fd11159efb86a5b41051c4a9:

  Revert "virtio-blk: support completion batching for the IRQ path" (2023-06-21 04:14:28 -0400)

----------------------------------------------------------------
virtio: bugfix

A last minute revert to fix a regression.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      Revert "virtio-blk: support completion batching for the IRQ path"

 drivers/block/virtio_blk.c | 82 +++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 45 deletions(-)

