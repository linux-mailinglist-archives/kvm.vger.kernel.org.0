Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264254C1E2B
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 23:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243164AbiBWWFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 17:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbiBWWFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 17:05:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8114DF53;
        Wed, 23 Feb 2022 14:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0A64B81EB2;
        Wed, 23 Feb 2022 22:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EFEC340E7;
        Wed, 23 Feb 2022 22:05:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="p3Fz+yby"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645653908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5pBvrnim267Drxy2tBvWhv9EQxny44tgDJv9yglZOzw=;
        b=p3Fz+ybysAbMGdmdB0sXZ+aF5mGEdageCUkh7PocknvKbNnTB5XjnKEJVZu7hQtIXjUCRV
        +iVQK8XXcFoQulzKc8N8w6u3b5+p0WWAQadYInqvn1YWF84YakUvyrd09f56rG73+9IfzQ
        qfOkaGtHcrR+Y1Y1rmLdap7kDWjWwR4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c269c5a0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 22:05:08 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, adrian@parity.io,
        dwmw@amazon.co.uk, graf@amazon.com, colmmacc@amazon.com,
        raduweis@amazon.com, imammedo@redhat.com, ehabkost@redhat.com,
        ben@skyportsystems.com, mst@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, linux@dominikbrodowski.net, ardb@kernel.org,
        jannh@google.com, gregkh@linuxfoundation.org, tytso@mit.edu
Subject: [PATCH v2 0/2] VM fork detection for RNG
Date:   Wed, 23 Feb 2022 23:04:54 +0100
Message-Id: <20220223220456.666193-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This small series picks up work from Amazon that seems to have stalled
out last year around this time: listening for the vmgenid ACPI
notification, and using it to "do something." Last year, folks proposed
a complicated userspace mmap chardev, which was frought with
difficulty and evidently abandoned. This year, instead, I have something
much simpler in mind: simply using those ACPI notifications to tell the
RNG to reinitialize safely, so we don't repeat random numbers in cloned,
forked, or rolled-back VM instances.

This series consists of two patches. The first one adds the right hooks
into the actual RNG, and the second is a driver for the ACPI
notification.

I had posted an RFC v1 earlier today, thinking I really needed to
request comments, lacking much experience with ACPI drivers. But having
spent all day reworking this driver, and then testing and debugging it
in a variety of circumstances, I feel fairly confident that it works
well, so this is now the real thing. Please review! Here's a little
screencast showing it in action: https://data.zx2c4.com/vmgenid-appears-to-work.gif

As a side note, this series intentionally does _not_ focus on
notification of these events to userspace or to other kernel consumers.
Since these VM fork detection events first need to hit the RNG, we can
later talk about what sorts of notifications or mmap'd counters the RNG
should be making accessible to elsewhere. But that's a different sort of
project and ties into a lot of more complicated concerns beyond this
more basic patchset. So hopefully we can keep the discussion rather
focused here to this ACPI business.

Changes v1->v2:
- [Ard] Correct value of MODULE_LICENSE().
- [Ard] Use ordinary memory accesses instead of memcpy_fromio.
- [Ard] Make module a tristate and set MODULE_DEVICE_TABLE().
- [Ard] Free buffer after using.
- Use { } instead of { "", 0 }.
- Clean up interface into RNG.
- Minimize ACPI driver a bit.

In addition to the usual suspects, I'm CCing the original team from
Amazon who proposed this last year and the QEMU developers who added it
there, as well as the kernel Hyper-V maintainers, since this is
technically a Microsoft-proposed thing, though QEMU now implements it.

Cc: adrian@parity.io
Cc: dwmw@amazon.co.uk
Cc: graf@amazon.com
Cc: colmmacc@amazon.com
Cc: raduweis@amazon.com
Cc: imammedo@redhat.com
Cc: ehabkost@redhat.com
Cc: ben@skyportsystems.com
Cc: mst@redhat.com
Cc: kys@microsoft.com
Cc: haiyangz@microsoft.com
Cc: sthemmin@microsoft.com
Cc: wei.liu@kernel.org
Cc: decui@microsoft.com
Cc: linux@dominikbrodowski.net
Cc: ardb@kernel.org
Cc: jannh@google.com
Cc: gregkh@linuxfoundation.org
Cc: tytso@mit.edu

Jason A. Donenfeld (2):
  random: add mechanism for VM forks to reinitialize crng
  virt: vmgenid: introduce driver for reinitializing RNG on VM fork

 drivers/char/random.c  |  53 ++++++++++++++++++
 drivers/virt/Kconfig   |   9 ++++
 drivers/virt/Makefile  |   1 +
 drivers/virt/vmgenid.c | 120 +++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |   1 +
 5 files changed, 184 insertions(+)
 create mode 100644 drivers/virt/vmgenid.c

-- 
2.35.1

