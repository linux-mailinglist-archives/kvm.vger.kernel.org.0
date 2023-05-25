Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AFA710E8B
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 16:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbjEYOsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 10:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbjEYOsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 10:48:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46642139
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 07:48:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 833F815BF;
        Thu, 25 May 2023 07:49:18 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B2FD3F67D;
        Thu, 25 May 2023 07:48:32 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 0/2] Fix builds with clang
Date:   Thu, 25 May 2023 15:48:25 +0100
Message-Id: <20230525144827.679651-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When trying to build kvmtool with clang, it warned about two problems,
which are fatal since we use "-Werror".

Patch 1/2 is an easy one fixing an obvious bug (not sure why GCC didn't
warn). Patch 2/2 removes an ugly hack which clang didn't want to let
pass. This patch admittedly implements the most tedious solution to this
problem, but I didn't want to just throw in a "__maybe_unused" (or
"__used", as kvmtool puts it). If that solution is a bit over the top,
let me know, maybe there is better solution which doesn't require to
touch every user of the virtio endianess conversion functions - or
__maybe_unused is OK after all.

Cheers,
Andre

Andre Przywara (2):
  option parsing: fix type of empty .argh parameter
  virtio: sanitise virtio endian wrappers

 arm/include/arm-common/kvm-config-arch.h |  2 +-
 builtin-run.c                            |  2 +-
 include/kvm/parse-options.h              |  7 ++--
 include/kvm/virtio.h                     | 53 ++++++++++++++----------
 virtio/9p.c                              |  2 +-
 virtio/blk.c                             |  8 ++--
 virtio/console.c                         |  6 +--
 virtio/core.c                            | 37 +++++++++--------
 virtio/net.c                             |  6 +--
 virtio/scsi.c                            | 20 ++++-----
 10 files changed, 77 insertions(+), 66 deletions(-)

-- 
2.25.1

