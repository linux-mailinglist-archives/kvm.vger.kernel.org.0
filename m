Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5A84C13A6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbiBWNNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiBWNNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:13:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8DA5FF17;
        Wed, 23 Feb 2022 05:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6478B6117F;
        Wed, 23 Feb 2022 13:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533DEC340F0;
        Wed, 23 Feb 2022 13:12:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="p2uLwLyr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645621971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yDH6L5SfKXyei5pTTzcAk9yjz7NgT/Zl7Px1eWnwpqQ=;
        b=p2uLwLyrNMQ8HTaqGPewS3XX209s7oJqJ9miRcoY1DtAZT8hviF4SxAj5On0Im2pbnBr3p
        qozPAZOFG4amHtvVOWAclMD5HdWA5Oi9z78mYqPXXrH2JsBBaqdcZS4CZ649Pcqn51y//z
        udUOOwgOLtSyOIgtQw8+TrDExV8xsig=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 57f5dfd0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 13:12:50 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, adrian@parity.io
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, dwmw@amazon.co.uk,
        acatan@amazon.com, graf@amazon.com, colmmacc@amazon.com,
        sblbir@amazon.com, raduweis@amazon.com, jannh@google.com,
        gregkh@linuxfoundation.org, tytso@mit.edu
Subject: [PATCH RFC v1 0/2] VM fork detection for RNG
Date:   Wed, 23 Feb 2022 14:12:29 +0100
Message-Id: <20220223131231.403386-1-Jason@zx2c4.com>
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
out later year around this time: listening for the vmgenid ACPI
notification, and using it to "do something." Last year, that something
involved a complicated userspace mmap chardev, which seems frought with
difficulty. This year, I have something much simpler in mind: simply
using those ACPI notifications to tell the RNG to reinitialize safely,
so we don't repeat random numbers in cloned, forked, or rolled-back VM
instances.

This series consists of two patches. The first is a rather
straightforward addition to random.c, which I feel fine about. The
second patch is the reason this is just an RFC: it's a cleanup of the
ACPI driver from last year, and I don't really have much experience
writing, testing, debugging, or maintaining these types of drivers.
Ideally this thread would yield somebody saying, "I see the intent of
this; I'm happy to take over ownership of this part." That way, I can
focus on the RNG part, and whoever steps up for the paravirt ACPI part
can focus on that.

As a final note, this series intentionally does _not_ focus on
notification of these events to userspace or to other kernel consumers.
Since these VM fork detection events first need to hit the RNG, we can
later talk about what sorts of notifications or mmap'd counters the RNG
should be making accessible to elsewhere. But that's a different sort of
project and ties into a lot of more complicated concerns beyond this
more basic patchset. So hopefully we can keep the discussion rather
focused here to this ACPI business.

Cc: dwmw@amazon.co.uk
Cc: acatan@amazon.com
Cc: graf@amazon.com
Cc: colmmacc@amazon.com
Cc: sblbir@amazon.com
Cc: raduweis@amazon.com
Cc: jannh@google.com
Cc: gregkh@linuxfoundation.org
Cc: tytso@mit.edu

Jason A. Donenfeld (2):
  random: add mechanism for VM forks to reinitialize crng
  drivers/virt: add vmgenid driver for reinitializing RNG

 drivers/char/random.c  |  58 ++++++++++++++++++
 drivers/virt/Kconfig   |   8 +++
 drivers/virt/Makefile  |   1 +
 drivers/virt/vmgenid.c | 133 +++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |   1 +
 5 files changed, 201 insertions(+)
 create mode 100644 drivers/virt/vmgenid.c

-- 
2.35.1

