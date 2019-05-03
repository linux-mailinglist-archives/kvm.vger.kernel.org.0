Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07FC13364
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfECRyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:54:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43186 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfECRyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:54:35 -0400
Received: by mail-pg1-f196.google.com with SMTP id t22so3048891pgi.10
        for <kvm@vger.kernel.org>; Fri, 03 May 2019 10:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Jqv/rGfSQ1+f4qF0q1y+ZULEU6IW9pby/CX4s+deALA=;
        b=fglhoRps74SOd1O/bI9SsxZ3RSxfzy6+U7+zrSkVjiWjt0hdPAavi3sokIJlegSHcs
         /E/oJV98DUJshl/Uk4vgPHiqqwqMz6nuCOJUew1MwAd6kr73NtFli4Bl6xOKupxBmlut
         wUql+ynzlzFGJzTfrXdvVDysL6l2BFobZ0JYaAfkrmsw/ZeQnahbNpY/G9nQ/d3KhY9b
         sTNnr2bz50De+q9csVWZd09f9z8WSwxflUCvxzPwpKjcXZGy63SdzXpB/tWIWhRLNS/p
         nRHKgLN2P9PPn7w/wf0dGySXvux+in0agS7f4JV/VNZ3M9AzCNHylkSS7iHfCema4d1x
         rY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jqv/rGfSQ1+f4qF0q1y+ZULEU6IW9pby/CX4s+deALA=;
        b=rzU6AKv59DRd9uF6feTMlOG6PvrP5AxwZCIowufF4aOUeOCwG9Fs3mnpg1qlkMDpic
         uZ8XUgSwOoePMg1hXhuCr8kwSSb+9mlxWyjpPfHqpJRqVgZk1ftt7LqNZHsajpJ+/S0E
         Iu4hwi+epc2P4Vfd2GSxS/3Ldt26RY3eT2W6B7rNX2rhjOgOV+Hk6dy3QBRDoOmzn8zM
         7KpCBv2m3sVsoqD42HTH1yirowBS69PuocZD8H2tpwatbh62tejUWxyi68VksvlRn/CY
         QLd8V0KQz/TxNfAvmnRCW0+qiiLV6LLBqZr0Bm93TvAlXl0X4N2tRF3ltt23MbZTQV1e
         lDzA==
X-Gm-Message-State: APjAAAWuNQ1X9IDYVtQ0t4PFp2ArXphGMIt81K52Me8LEZr3tN93JIW5
        eR5otSk+r7elFc9zOsRXXijQzVjUdYM=
X-Google-Smtp-Source: APXvYqw68N59D/nkLlNtV7V10JlgkzE7xrTZdKaAOrtXn5KjsblNiI7C2HOhEQr+rWvaIYR6VficKA==
X-Received: by 2002:a62:1990:: with SMTP id 138mr12448446pfz.98.1556906074182;
        Fri, 03 May 2019 10:54:34 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id p20sm3717311pgj.86.2019.05.03.10.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:54:33 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v2 0/4] Zero allocated pages
Date:   Fri,  3 May 2019 03:32:03 -0700
Message-Id: <20190503103207.9021-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

For reproducibility, it is best to zero pages before they are used.
There are hidden assumptions on memory being zeroed (by BIOS/KVM), which
might be broken at any given moment. The full argument appears in the
first patch commit log.

Following the first patch that zeros the memory, the rest of the
patch-set removes redundant zeroing do to the additional zeroing.

This patch-set is only tested on x86.

v1->v2:
* Change alloc_pages() as well
* Remove redundant page zeroing [Andrew]

Nadav Amit (4):
  lib/alloc_page: Zero allocated pages
  x86: Remove redeundant page zeroing
  lib: Remove redeundant page zeroing
  arm: Remove redeundant page zeroing

 lib/alloc_page.c         |  4 ++++
 lib/arm/asm/pgtable.h    |  2 --
 lib/arm/mmu.c            |  1 -
 lib/arm64/asm/pgtable.h  |  1 -
 lib/virtio-mmio.c        |  1 -
 lib/x86/intel-iommu.c    |  5 -----
 x86/eventinj.c           |  1 -
 x86/hyperv_connections.c |  4 ----
 x86/vmx.c                | 10 ----------
 x86/vmx_tests.c          | 11 -----------
 10 files changed, 4 insertions(+), 36 deletions(-)

-- 
2.17.1

