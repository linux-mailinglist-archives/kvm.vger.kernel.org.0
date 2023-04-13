Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262AB6E12E8
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDMQ6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 12:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMQ6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 12:58:04 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1043E10F3
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 09:58:03 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53239D75;
        Thu, 13 Apr 2023 09:58:47 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 128953F6C4;
        Thu, 13 Apr 2023 09:58:01 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool 0/2] Fix virtio/rng handling in low entropy situations
Date:   Thu, 13 Apr 2023 17:57:55 +0100
Message-Id: <20230413165757.1728800-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment kvmtool uses the /dev/random device to back the randomness
provided by our virtio/rng implementation. We run it in non-blocking
mode, so are not affected by the nasty "can block indefinitely"
behaviour of that file. However:
- If /dev/random WOULD block, it returns EAGAIN, and we reflect that by
  adding 0 bytes of entropy to the virtio queue. However the virtio 1.x
  spec clearly says this is not allowed, and that we should always provide
  at least one random byte.
- If the guest is waiting for the random numbers, we still run into an
  effective blocking situation, because the buffer will only be filled
  very slowly, effectively stalling or blocking the guest. EDK II shows
  that behaviour, when servicing the EFI_RNG_PROTOCOL runtime service
  call, called by the kernel very early on boot.

Those two patches fix those problems, and allow to boot a Linux kernel
MUCH quicker when the host lacks good entropy sources. On a particular
system the kernel took 10 minutes to boot because of /dev/random
effectively blocking, this runs now in full speed.

The block is avoided by using /dev/urandom, there is a proper rabbit
hole in the internet out there why this is safe, even for cryptographic
applications.

I am not sure we now really need patch 2 anymore (originally I had this
one before I switched to /dev/urandom). I *think* even a read from
/dev/urandom can return early (because of a signal, for instance), so
a return with 0 bytes read seems possible.

Please have a look!

Cheers,
Andre


Andre Przywara (2):
  virtio/rng: switch to using /dev/urandom
  virtio/rng: return at least one byte of entropy

 virtio/rng.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

-- 
2.25.1

