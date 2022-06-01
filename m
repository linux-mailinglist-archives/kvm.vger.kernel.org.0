Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170D453AB50
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbiFAQww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236357AbiFAQwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:52:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D003D1B797
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:52:45 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41155ED1;
        Wed,  1 Jun 2022 09:52:45 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F3143F66F;
        Wed,  1 Jun 2022 09:52:44 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: [PATCH kvmtool 0/4] Fix some undefined behaviour
Date:   Wed,  1 Jun 2022 17:51:34 +0100
Message-Id: <20220601165138.3135246-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

triggered by some integer overflow issues, discovered through Alex' "set
RAM base address" series, I enabled "-fsanitize=undefined
-fsanitize=address" in the Makefile, and enjoyed the fireworks.
This series is cheekily just picking the lowest hanging fruits:
Some needlessly unaligned accesses in the virtio-mmio code, and signed
shifts in the x86 CPUID code.
There are more issues, but they take more time fixing.

Please have a look!

Cheers,
Andre

Andre Przywara (4):
  virtio/mmio: avoid unaligned accesses
  virtio/mmio: access header members normally
  virtio/mmio: remove unneeded virtio_mmio_hdr members
  x86/cpuid: fix undefined behaviour

 include/kvm/virtio-mmio.h | 12 ++----------
 virtio/mmio.c             | 19 +++++++++++++++----
 x86/cpuid.c               |  6 +++---
 3 files changed, 20 insertions(+), 17 deletions(-)

-- 
2.25.1

