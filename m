Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3635121E8
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiD0TCO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 15:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiD0TBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 15:01:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C87B1CFC2
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:17 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id c194-20020a6335cb000000b0039d9a489d44so1309434pga.6
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 11:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=W31J+NXrVsC6+MO2Lwj0kB41xQsk0gH6sl8VC4G0Hhw=;
        b=FESEaVxAwhhRxp009/PbfkU87OUhtLSXa32rvs7Sy1rWU0fM9GFCw5A3ulYIQlSwgF
         hsymoNj32M8/ZLy0y54HR9w9x8Z8oYHlYOc0TmBwHpeLJMLwgeHs3TrV4FNvGbDFuvvt
         XyvHEn41GBYC5Du+JHk4EFcMGoFQiDHuJOMoVzdMKfOgGPEzRvEsue/01R49rkbM/9b2
         RsqFZzJB4cMmtGJr2G0U7BwT80PFoVDwDn1/xsPOmbDYYxzUItfAlrxrmCwTvp2kWy6w
         HdDHBWxWkNAJHhmxBAAC/mV4UanmAA5bkIU9Bz5iiqMiMDyFkUFAYoE7dxNKPPvZSk48
         S0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=W31J+NXrVsC6+MO2Lwj0kB41xQsk0gH6sl8VC4G0Hhw=;
        b=cXwRQcun2LR0N1sJs88YkU/VEJn9y2f5AZdHRrO9AEZQK6TsTo4LRTpuynXZnPl/W5
         q6mIaL7uHO9ZZ4XnmkqOE5f59Io3Pr5UT9L18/+h1FP2Hdccgw/m886lvkZJkeOTnUpu
         dsgzUlnmzWooW0o+ZIBBORekGQDGyYWa5fWM2ilBa3jPLHuIS1e/6jPk0xw39pF4b6To
         mO43+UfNzUAVBa2G65ghHOEQolTVsayceYILHB8qfLLLFElgiI0Y0S6aRm1GDdGS9if1
         U1WDjM3nPjX5er5jvSAZ32vmSuQ3HviP8vhgQJRm+T/oSsqThau3e8SHFk9FC3ouFbwB
         dpfw==
X-Gm-Message-State: AOAM531P8DVgUcEfpDzI8pCyp0in/co0PvO0QU4pV+B5+N1lj3Z/w/st
        +nRKoQa3C6AaQp1JsdzLl06l3P8ZRaJh+5pItwWoGl6WDZ/a0a5y0I1ifPmS8DaCI41P7gGfrGU
        DDAdIaJnY7iYi38keuxU5t+BbbmlAFIiy5HlSy/VnHZ7O/3LyCsZ1xOM+C7AM7wQ=
X-Google-Smtp-Source: ABdhPJwPe8FNq1K7NbxdZ9TP/wTRtiQjsYQUJ4+BrlzwseokJPagTVD2W3Cq84m7PQ7pNxDPRSa8a14AiQHXxg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:2742:0:b0:505:89a5:2023 with SMTP id
 n63-20020a622742000000b0050589a52023mr31612943pfn.18.1651085296858; Wed, 27
 Apr 2022 11:48:16 -0700 (PDT)
Date:   Wed, 27 Apr 2022 11:48:10 -0700
Message-Id: <20220427184814.2204513-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 0/4] KVM: arm64: vgic: Misc ITS fixes
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, andre.przywara@arm.com,
        drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        pshier@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The purpose of this series is to help debugging failed ITS saves and
restores.  Failures can be due to misconfiguration on the guest side:
tables with bogus base addresses, or the guest overwriting L1 indirect
tables. KVM can't do much in these cases, but one thing it can do to help
is raising errors as soon as possible. Here are a couple of cases where
KVM could do more:

- A command that adds an entry into an ITS table that is not in guest
  memory should fail, as any command should be treated as if it was
  actually saving entries in guest memory (KVM doesn't until saving).  KVM
  does this check for collections and devices (using vgic_its_check_id),
  but it doesn't for the ITT (Interrupt Translation Table). Commit #1 adds
  the missing check.

- Restoring the ITS tables does some checks for corrupted tables, but not
  as many as in a save.  For example, a device ID overflowing the table
  will be detected on save but not on restore.  The consequence is that
  restoring a corrupted table won't be detected until the next save;
  including the ITS not working as expected after the restore. As an
  example, if the guest sets tables overlapping each other, this would most
  likely result in some corrupted table; and this is what we would see from
  the host point of view:

	guest sets bogus baser addresses
	save ioctl
	restore ioctl
	save ioctl (fails)

  This failed save could happen many days after the first operation, so it
  would be hard to track down. Commit #2 adds some checks into restore:
  like checking that the ITE entries are not repeated.

- Restoring a corrupted collection entry is being ignored. Commit #3 fixes
  this while trying to organize the code so to make the bug more obvious
  next time.

Finally, failed restores should clean up all intermediate state. Commit #4
takes care of cleaning up everything created until the restore was deemed a
failure.

v1: https://lore.kernel.org/kvmarm/20220425185534.57011-1-ricarkol@google.com/
v1 -> v2:
- moved alloc_collection comment to its respective commit. [marc]
- refactored check_ite to reuse some code from check_id. [marc]
- rewrote all commit messages. [marc]

Tested with kvm-unit-tests ITS tests.

Ricardo Koller (4):
  KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
  KVM: arm64: vgic: Add more checks when restoring ITS tables
  KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
  KVM: arm64: vgic: Undo work in failed ITS restores

 arch/arm64/kvm/vgic/vgic-its.c | 112 +++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 25 deletions(-)

-- 
2.36.0.464.gb9c8b46e94-goog

