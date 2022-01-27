Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393FD49D8CB
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 04:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiA0DJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 22:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiA0DJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 22:09:03 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F39BC06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:03 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id f1-20020a17090a8e8100b001b44bb75678so962664pjo.0
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qQhHuHqO4mFrHPSE8WimHoA11N0d1fYrE1SY2mGY6Qc=;
        b=AeahOZQjcsgIAlBb1KD/OZ8PVPYBQ2ylDADyPOudw4Z4kXmYPJ1MrGdcSVR5uLaI67
         +LrpE7Pm7x8uzhzrkEpct9nGSwUhH+sprWnwFAVs0iZ+iUDWTgBxg+bV+qJ7FuA4I5Hl
         5TJbhQNlDMOuLzuCiQ2uWYF16f0T0pTJWe1ctXitY60ZEW6Zbj08b1baBBDl2Dgc6rnn
         l5vachi7RMN0G0V0sGLeWL+FiFK9io56q3X9SfSbF7O1Q+S4i5jk1316hGU1XPzpIIRo
         h9Zv71Ewj5zg7Mf64bT8zyYz4N1Tx/iAYF8ftqeuZgbvcjNzz473OFeBybIJKB34qsbs
         QBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qQhHuHqO4mFrHPSE8WimHoA11N0d1fYrE1SY2mGY6Qc=;
        b=fGVenrBP5fionz1K3HJu2EzaG8XWVxDb0GVbisQgsroH8G4ossMkfuUAq4mUyYquHh
         ck/Sl1ktpNxrgt05QYxvL008p0mqiix6ugNMN8fO36Va0xpv1KFHTBvIBy6mQ7pEApzV
         xjMK2L2ZUQkCqfKdwDw2YJd10NYWx4nMNhHre+exP+2oHSJJ/faxf6y6jwqr3WBVkWcM
         9CcsC94GylVeCjsNoXoKVOrJHcH0kt5hbUsbWSAlOBPpQbO6zzI4475kfWztdbUKiyxf
         CgGP7PvuzoxjNBd7CPHqaaL7OFZhgn4TPfz8iTlgEW/gQ0k3DEOT+1+EIaquZ3A4pWJM
         L92g==
X-Gm-Message-State: AOAM533rYwjtRqTjjNW4XvxYcxvtwQCn6d3IBB6+mgrbFqu4oAqC0twW
        HBwOhYQYtE/AfyoJ5wFF/mpU6zgFT4MLPN1l8ThO9rLVpK0n+0uOxLOfmiAfnS9XPRhFxcO6awt
        qGnQ00libYd/RWkF02Ft/OgqZVxFeVaux2PTvS97waXWyazFgy8j9Wj1kUBRPZqA=
X-Google-Smtp-Source: ABdhPJwUKp1D8NergYPjzU7Dnd2HDvJg74lXmpzVjlCsIjbC/2nBeb7exjp/OrMe5BZ5inmqkLiTId0amwMHIQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:5292:: with SMTP id
 g140mr1282751pfb.55.1643252942452; Wed, 26 Jan 2022 19:09:02 -0800 (PST)
Date:   Wed, 26 Jan 2022 19:08:53 -0800
Message-Id: <20220127030858.3269036-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 0/5] kvm: selftests: aarch64: some fixes for vgic_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reiji discovered multiple issues with the vgic_irq series [0]:
1. there's an assert that needs fixing.
2. some guest arguments are not set correctly.
3. the failure test in kvm_set_gsi_routing_irqchip_check is wrong.
4. there are lots of comments that use the wrong formatting.
5. vgic_poke_irq() could use a tighter assert check.

The first 3 issues above are critical, the last 2 would be nice to have.  I
haven't hit the failed assert (1.), but just by chance: my compiler is
initializing the respective local variable to 0. The second issue (2.) leads to
not testing one of the injection methods (irqfd). The third issue could be hit
if we tested more intids.

v1 -> v2:
- adding 3 more fixes: 2, 3, 5 above. (Reiji)
- corrected the comments in 4 above. (Andrew)
- dded drjones@ reviewed-by tag.

[0] https://lore.kernel.org/kvmarm/164072141023.1027791.3183483860602648119.b4-ty@kernel.org/

Ricardo Koller (5):
  kvm: selftests: aarch64: fix assert in gicv3_access_reg
  kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
  kvm: selftests: aarch64: fix the failure check in
    kvm_set_gsi_routing_irqchip_check
  kvm: selftests: aarch64: fix some vgic related comments
  kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()

 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 45 +++++++++++--------
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 12 ++---
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  9 ++--
 3 files changed, 38 insertions(+), 28 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

