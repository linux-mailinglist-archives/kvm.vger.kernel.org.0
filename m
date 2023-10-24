Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF94C7D45D2
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 05:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjJXDKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 23:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjJXDKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 23:10:49 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D9410DE
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 20:10:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53f6ccea1eeso6049265a12.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 20:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698117041; x=1698721841; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hcMR4OV3Qa58zLtXWS6CqD73NZyZ4Zo3HUk8KUykTLs=;
        b=Ka7yG7dW1R6eRp7P14nmBM3K+qJLXX4zgw2wspugMcoJfXYI9nZfMZ8DDiFbXT8cxk
         hWh31bn4OZaMumc/W8OrUtEH1x6tf5am2DxZU0zx/XT0e1l4nY2a4a1JhD9w1g2sM9OH
         KFj/Jhqw99BnxpPqH3lBl61fDcGnr3fJc4UzWbx3prqOrjoNVnui4ciPxwdSgmAZbT05
         oMuK+X1ZrHiQXslOSVC6qLVwBh3QGJkDsWfZ5j6XOp6QTQfcfIrAed6UXSFoOAtO4tM4
         OFwHU53NBFsa+R9tos8+x8xPBj0L6VZoG38TyEuuaIjV1DcF4Cx3PsCBU9F63oIOAECb
         STGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698117041; x=1698721841;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hcMR4OV3Qa58zLtXWS6CqD73NZyZ4Zo3HUk8KUykTLs=;
        b=wav8O1WSYTbdwR/kDBcU304nw31g9DtYsndmJ7A0oxWNSKRUPWt7OO6Zll1q+cexML
         YmwPxlE9riE8QZgK6m8uZ7LpiyBJuNQW5ZxFqgYF+K/VOolAkPjXR3J+uChsOYFA+DXf
         oRzKwH4wJEnhswMZbP66eWsTAYwaeIgz3CAgjgVeXKN37M74Fz1MU3C0FVpftEBCvVNB
         icC5QjP68cPSQd3zmZw1V1nNaBCmLLJl/xESQuRY44cSJIK8nxk2nniH9Xjq1sYuLWAW
         RMQgjBnyo1yxrBc/tIFX/9+hugNUV1hoPIKOvLT+seuspFqxpkMJIHm4CoyprSPt7F2x
         55EQ==
X-Gm-Message-State: AOJu0Yxc6VD7b8ufgj0Q9qhcXnwv+u3RDF8nH47mUZhXZoxo4Bk0K7ad
        2zwCW46Yn7QnUZIVDrJjl2z3fvxrA3RuEOyO41Q=
X-Google-Smtp-Source: AGHT+IG7gC0U08NQqruXCW4WAmMAIYNvyBuE/X3kQm5VqQZDZ8M8LIKlvYfztUlkviQAEDh41pif5QR5DczebOAsq/s=
X-Received: by 2002:a05:6402:274e:b0:53e:3b8f:8a58 with SMTP id
 z14-20020a056402274e00b0053e3b8f8a58mr9224090edd.11.1698117040723; Mon, 23
 Oct 2023 20:10:40 -0700 (PDT)
MIME-Version: 1.0
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Tue, 24 Oct 2023 11:10:28 +0800
Message-ID: <CAKhg4t+QPszSZnWEnAXEVPL6t44syimO3bm43jmgLPZ7jv5gaQ@mail.gmail.com>
Subject: [RFC] vmap virtio descriptor table
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current vhost code uses 'copy_from_user' to copy descriptors from
userspace to vhost. We attempted to 'vmap' the descriptor table to
reduce the overhead associated with 'copy_from_user' during descriptor
access, because it can be accessed quite frequently. This change
resulted in a moderate performance improvement (approximately 3%) in
our pktgen test, as shown below. Additionally, the latency in the
'vhost_get_vq_desc' function shows a noticeable decrease.

current code:
                IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:        vnet0      0.31 1330807.03      0.02  77976.98
0.00      0.00      0.00      6.39
# /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
avg = 145 nsecs, total: 1455980341 nsecs, count: 9985224

kmap:
                IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
rxcmp/s   txcmp/s  rxmcst/s   %ifutil
Average:        vnet0      0.07 1371870.49      0.00  80383.04
0.00      0.00      0.00      6.58
# /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
avg = 122 nsecs, total: 1286983929 nsecs, count: 10478134

We are uncertain if there are any aspects we may have overlooked and
would appreciate any advice before we submit an actual patch.


Thanks,
Liang
