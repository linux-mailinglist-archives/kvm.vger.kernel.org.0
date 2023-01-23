Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2722678470
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 19:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbjAWSVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 13:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjAWSVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 13:21:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C07E83CA
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 10:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674498058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7W3OhQFxDq6zqpMtU8wiqsGIhCfIgwM85fzOwnjEcTA=;
        b=a8b1A5ZgxGcPbf2WWqvSFaLcZsUwhqqPhU4txBRDSteoZwxZecGh66uyE39B1Uhu/mvSk6
        pkiGxbUmgdLFu6KfKAeWPHwVquzYT60H1gBJUtpbIzhcasU/zCBlKRQcGc2Si3kMDnmU8K
        BboZhy9+KpRNhtCCnYzLEN6nUf5OH+M=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-19-PUq-7AmYO76JzgmbAlcLcA-1; Mon, 23 Jan 2023 13:20:57 -0500
X-MC-Unique: PUq-7AmYO76JzgmbAlcLcA-1
Received: by mail-il1-f199.google.com with SMTP id s12-20020a056e021a0c00b0030efd0ed890so8765835ild.7
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 10:20:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7W3OhQFxDq6zqpMtU8wiqsGIhCfIgwM85fzOwnjEcTA=;
        b=yQagvwn6WEAohuPu+5bGVSzzJ6CR2fnLB5//FCKTL3MQgaa8Ace7ofUTMHbmItLukB
         ayg/Yi1JgbdOQLLlhCXpvfICoUfYeOSqkhxtXeKVRZcd/MogXA9okJgzqWheYq4RNK4c
         m+NJYc8yc+4MidsfhLMhBt9rwyD6upIxW0F9HauXtQlfZCuiJQZmQc1AJHYMJ8P1kkJL
         JPf5W0jDCY7dUbm2yBV2kMM71WbTnKvHtPk8vLi07gRJ09kBkypUXJCivZaxODx/rK84
         o2GjLvTrcqA1qfFkgFVzhFP002IsMIs/XOib0rDMWhzTUaaB7G/w0jTidydRtXPb6jQd
         Affw==
X-Gm-Message-State: AFqh2kreNS6tZXv0Pqops7RZ7aHREgJ5TVuPqGI+xiwFlWMBawCXphKK
        VSkdwAHz8IOcxxbiUUGXpqehklPnKPxouOiDtolZ9JjnX05FtuzYYBU8cDG4/08pFIvbzUDEG72
        WsjgspMwfAxVn
X-Received: by 2002:a92:6a07:0:b0:30f:3b60:ba50 with SMTP id f7-20020a926a07000000b0030f3b60ba50mr11516177ilc.21.1674498056323;
        Mon, 23 Jan 2023 10:20:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuwyMuZ5ByIWQvrteD+fManzk00K1f9tJ/vzFoFzckZNo/UdoxOTo54064l6efCtDaIISGBMg==
X-Received: by 2002:a92:6a07:0:b0:30f:3b60:ba50 with SMTP id f7-20020a926a07000000b0030f3b60ba50mr11516162ilc.21.1674498056101;
        Mon, 23 Jan 2023 10:20:56 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z19-20020a05663822b300b003a2b9bcec56sm8573574jas.67.2023.01.23.10.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 10:20:55 -0800 (PST)
Date:   Mon, 23 Jan 2023 11:20:53 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fixes for v6.2-rc6
Message-ID: <20230123112053.173232a7.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:

  Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.2-rc6

for you to fetch changes up to 51cdc8bc120ef6e42f6fb758341f5d91bc955952:

  kvm/vfio: Fix potential deadlock on vfio group_lock (2023-01-20 08:50:05 -0700)

----------------------------------------------------------------
VFIO fixes for v6.2-rc6

 - Honor reserved regions when testing for IOMMU find grained super
   page support, avoiding a regression on s390 for a firmware device
   where the existence of the mapping, even if unused can trigger
   an error state. (Niklas Schnelle)

 - Fix a deadlock in releasing KVM references by using the alternate
   .release() rather than .destroy() callback for the kvm-vfio device.
   (Yi Liu)

----------------------------------------------------------------
Niklas Schnelle (1):
      vfio/type1: Respect IOMMU reserved regions in vfio_test_domain_fgsp()

Yi Liu (1):
      kvm/vfio: Fix potential deadlock on vfio group_lock

 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++-----------
 virt/kvm/vfio.c                 |  6 +++---
 2 files changed, 23 insertions(+), 14 deletions(-)

