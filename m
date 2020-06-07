Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5001F0974
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 05:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFGDnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 23:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgFGDns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 23:43:48 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595B2C08C5C2
        for <kvm@vger.kernel.org>; Sat,  6 Jun 2020 20:43:47 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id h7so10942972otr.3
        for <kvm@vger.kernel.org>; Sat, 06 Jun 2020 20:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=s4M639cJJobc0EN9vtx/B4ynyKGwXJyZrO/0uVS5uTA=;
        b=TNqLjUuMQJRyGKb4j6fgdMxE8IJTtTx7yAAB1FsUxGxDn7E6IY8TKYRNcuz/riNisz
         eel+CCeQR4DcofubzLV+KKFcf+P2hh92+l14NVwbW18EPaX6ow+6SyN72nYc/fgpWgns
         rVpeG0YCd3ilG0TlVkJaOoVKyDsmhWyDgnRW+Dghxv/QxPoBBqzrQtru/w/uCeeQ9bWu
         NIAUMCUoPZnoMzOHrxWkqQ5S1yqzH1cGw0tWsTZPp97GPSxDUNFbE8UkDSqFmZqJUBsl
         IFYKbTWZqkYUeliQSM03ledP22mzLG2DTeDwXwkETG3L6SciEeDBKASkC0h0HS/xNKMa
         l4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=s4M639cJJobc0EN9vtx/B4ynyKGwXJyZrO/0uVS5uTA=;
        b=P9BOtBK7SPskqJnHo6nJuFQnxNpv/5lwB1UnEcKy+L/qPxXP/ARp8PTpj8EtsC5Tdx
         wYf4+FtfSO/GmN79KUpKBfDuswGZInmtr+9oaQCV3tLTsw40nijgkh4OZ9yavjpCZcgh
         DsxWTUvOcylged1ouHN6OyyymLhOz1UNi8QEoiCSdWfdcKSYSTZ60XvtL1XjDwNFEs5B
         km3YFP8uwn6DBvYrYofzFetCdqETCGBbnjIf/F6nBe+Hxna1C0DZEUO1Xt+l+b1bC8ml
         98M9nXGrPMR7fn1Qq2AEQhtiJ6VIEW1BH4L6ElbL+pdgxLqYoeLERq8Y+wKygv9VAJMI
         jCHA==
X-Gm-Message-State: AOAM531sFYV5j7CH9FeWWVZkdhJaEFiFHbOdbD1DulfmjzlGbSHp+qMk
        Uuw0AttGm/xVoszHsTuPNBBzxIKXnfCNHnIgbAo=
X-Google-Smtp-Source: ABdhPJwt9PWgKQObiQ0E865KxQ7cPl/oPGE5lAtKLqwd0sN5BpQVBIfod3ReCJC5iEnZlkt0npdPuVE4u/yuGTGRjs4=
X-Received: by 2002:a9d:aaa:: with SMTP id 39mr12316264otq.269.1591501426372;
 Sat, 06 Jun 2020 20:43:46 -0700 (PDT)
MIME-Version: 1.0
From:   Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Date:   Sun, 7 Jun 2020 12:43:36 +0900
Message-ID: <CANR1yOopgAkoT6UmXZjUaFHe2rPBn_R2K=i_WNzFpDRdtR-uDQ@mail.gmail.com>
Subject: What will happen to hugetlbfs backed guest memory when nx_huge_pages
 is enabled?
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recently I noticed a significant performance issue with some of our KVM guests.
It looked like that the ITLB_MULTIHIT mitigation patch had been
backported to the
Ubuntu kernel on which they were running on, and the KVM was trying to do the
mitigation task on the guest memory backed by hugetlbfs 2MB pages.

    perf showed me that the KVM was busy doing tdp_page_fault(), __direct_map(),
    kvm_mmu_get_page() things. Normally, these were called in a short
period of time
    right after the VM got started because the guest soon touched the
whole memory.

The patch explains when a guest attempts to execute on an NX marked huge page,
KVM will break it down into 4KB pages. I understand how this works for
THP backed
guest memory, but what will happen to hugetlbfs backed guest memory?

When a huge amount of system memory is reserved as the hugetlbfs pool and QEMU
is said to use pages from there by the -mem-path option, is it safe to
enable the
nx_huge_pages mitigation?

We can turn it off now because the KVM guests are not from outside, and we only
execute our applications on them.


  UBUNTU: SAUCE: kvm: mmu: ITLB_MULTIHIT mitigation
  https://git.launchpad.net/~ubuntu-kernel/ubuntu/ source/linux/
git/xenial/commit/arch/x86/kvm?id=c6c9a37b564b8b4f7aad099388c55978ef456bb5

  kvm: mmu: ITLB_MULTIHIT mitigation
  https://github.com/torvalds/linux/commit/b8e8c8303ff28c61046a4d0f6ea99aea609a7dc0

  Takuya
