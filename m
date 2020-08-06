Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F4F23D46F
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgHFAOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgHFAOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:14:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5CDC061574
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 17:14:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d26so26401163yba.20
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ukHjjWs5WkFtiIo1+uIoaJAHaeV1zsDQLFHCLViDx9A=;
        b=oGOu/f1TAJ6j3p+WWvzitUIbdLGn8Duqb+dycILCf+u/HF87ubz84dGBN4tweHZLK4
         u/azbVeHevh0sZ2wvJIpoDUl/qrx1n/IIVR/aq/ZlkleDhpHq+2TlAD1oaDS/XCiwPdw
         mD5Ep+zfU/1V/JtWSuHyz6kyo1/PLM/D0Hg5nVGQMe9w7ooe/FVBa5bWyWF4EIHusdt1
         ru01c0Yjlkv9p7b29FLi872xUBhf7Ee67Lks1XzQk7qpNBeyUKhv8W/OKZhKdtNHijut
         vpqf7Pxm266TabuQLpw+zirpX3jIUfrWH5do9jKQKAqdILOUSvFPmP5Ta5WC1kjLhpea
         1Meg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ukHjjWs5WkFtiIo1+uIoaJAHaeV1zsDQLFHCLViDx9A=;
        b=IdRf50jPS1QhlbP6RSXnZUfuxdpy7AkbH5sq+WqsDvWDddxZ9rWCtlZSPxJHStS2ZB
         lvabfcErR2JyZWdnH5EKzx6klRyy2zEV/56WKmym4wNS1xcH3qLR8vLHq1N3EuwsU16k
         GXxy9HN5ZJQ6JWkQk/Av4NhnnlMLA6TGaY54YqN+Y2OntXuRSxAiLjXEP9u7JMKq/7A7
         zdFq3am8nqZti8M3rHawBECs1eawzIVAQR/5hnkbwAy0RywX+n50cY2KHQwmIlvGCkY4
         ipFiq+BDHm3o0GUcmPUvggVywdDZYuOYqgzvED9Bjmv3APNfLLv/jmAZO462HnlYDKBv
         +h9w==
X-Gm-Message-State: AOAM533gDrAwCm5iEZL8D8y13ZuN6YWUmEKHnl1x0MAy4hdgSlwkz5E5
        piVIS8BdMtpP8xjpYvkdOt3r09eU1EY=
X-Google-Smtp-Source: ABdhPJx+cPe/ZfGxzR9zdfhIWm8DUg/eVg2ptgtOtQPOFUmRpLc+elP5rUSmOj2N95q5WLDf+3HcontyW5cD
X-Received: by 2002:a25:cf95:: with SMTP id f143mr7894705ybg.126.1596672877936;
 Wed, 05 Aug 2020 17:14:37 -0700 (PDT)
Date:   Wed,  5 Aug 2020 17:14:24 -0700
Message-Id: <20200806001431.2072150-1-jwadams@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 0/7] metricfs metric file system and examples
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To try to restart the discussion of kernel statistics started by the
statsfs patchsets (https://lkml.org/lkml/2020/5/26/332), I wanted
to share the following set of patches which are Google's 'metricfs'
implementation and some example uses.  Google has been using metricfs
internally since 2012 as a way to export various statistics to our
telemetry systems (similar to OpenTelemetry), and we have over 200
statistics exported on a typical machine.

These patches have been cleaned up and modernized v.s. the versions
in production; I've included notes under the fold in the patches.
They're based on v5.8-rc6.

The statistics live under debugfs, in a tree rooted at:

	/sys/kernel/debug/metricfs

Each metric is a directory, with four files in it.  For example, the '
core/metricfs: Create metricfs, standardized files under debugfs.' patch
includes a simple 'metricfs_presence' metric, whose files look like:
/sys/kernel/debug/metricfs:
 metricfs_presence/annotations
  DESCRIPTION A\ basic\ presence\ metric.
 metricfs_presence/fields
  value
  int
 metricfs_presence/values
  1
 metricfs_presence/version
  1

(The "version" field always says '1', and is kind of vestigial)

An example of a more complicated stat is the networking stats.
For example, the tx_bytes stat looks like:

net/dev/stats/tx_bytes/annotations
  DESCRIPTION net\ device\ transmited\ bytes\ count
  CUMULATIVE
net/dev/stats/tx_bytes/fields
  interface value
  str int
net/dev/stats/tx_bytes/values
  lo 4394430608
  eth0 33353183843
  eth1 16228847091
net/dev/stats/tx_bytes/version
  1

The per-cpu statistics show up in the schedulat stat info and x86
IRQ counts.  For example:

stat/user/annotations
  DESCRIPTION time\ in\ user\ mode\ (nsec)
  CUMULATIVE
stat/user/fields
  cpu value
  int int
stat/user/values
  0 1183486517734
  1 1038284237228
  ...
stat/user/version
  1

The full set of example metrics I've included are:

core/metricfs: Create metricfs, standardized files under debugfs.
  metricfs_presence
core/metricfs: metric for kernel warnings
  warnings/values
core/metricfs: expose scheduler stat information through metricfs
  stat/*
net-metricfs: Export /proc/net/dev via metricfs.
  net/dev/stats/[tr]x_*
core/metricfs: expose x86-specific irq information through metricfs
  irq_x86/*

The general approach is called out in kernel/metricfs.c:

The kernel provides:
  - A description of the metric
  - The subsystem for the metric (NULL is ok)
  - Type information about the metric, and
  - A callback function which supplies metric values.

Limitations:
  - "values" files are at MOST 64K. We truncate the file at that point.
  - The list of fields and types is at most 1K.
  - Metrics may have at most 2 fields.

Best Practices:
  - Emit the most important data first! Once the 64K per-metric buffer
    is full, the emit* functions won't do anything.
  - In userspace, open(), read(), and close() the file quickly! The kernel
    allocation for the metric is alive as long as the file is open. This
    permits users to seek around the contents of the file, while
    permitting an atomic view of the data.

Note that since the callbacks are called and the data is generated at
file open() time, the relative consistency is only between members of
a given metric; the rx_bytes stat for every network interface will
be read at almost the same time, but if you want to get rx_bytes
and rx_packets, there could be a bunch of slew between the two file
opens.  (So this doesn't entirely address Andrew Lunn's comments in
https://lkml.org/lkml/2020/5/26/490)

This also doesn't address one of the basic parts of the statsfs work:
moving the statistics out of debugfs to avoid lockdown interactions.

Google has found a lot of value in having a generic interface for adding
these kinds of statistics with reasonably low overhead (reading them
is O(number of statistics), not number of objects in each statistic).
There are definitely warts in the interface, but does the basic approach
make sense to folks?

Thanks,
- Jonathan

Jonathan Adams (5):
  core/metricfs: add support for percpu metricfs files
  core/metricfs: metric for kernel warnings
  core/metricfs: expose softirq information through metricfs
  core/metricfs: expose scheduler stat information through metricfs
  core/metricfs: expose x86-specific irq information through metricfs

Justin TerAvest (1):
  core/metricfs: Create metricfs, standardized files under debugfs.

Laurent Chavey (1):
  net-metricfs: Export /proc/net/dev via metricfs.

 arch/x86/kernel/irq.c      |  80 ++++
 fs/proc/stat.c             |  57 +++
 include/linux/metricfs.h   | 131 +++++++
 kernel/Makefile            |   2 +
 kernel/metricfs.c          | 775 +++++++++++++++++++++++++++++++++++++
 kernel/metricfs_examples.c | 151 ++++++++
 kernel/panic.c             | 131 +++++++
 kernel/softirq.c           |  45 +++
 lib/Kconfig.debug          |  18 +
 net/core/Makefile          |   1 +
 net/core/net_metricfs.c    | 194 ++++++++++
 11 files changed, 1585 insertions(+)
 create mode 100644 include/linux/metricfs.h
 create mode 100644 kernel/metricfs.c
 create mode 100644 kernel/metricfs_examples.c
 create mode 100644 net/core/net_metricfs.c

-- 
2.28.0.236.gb10cc79966-goog

