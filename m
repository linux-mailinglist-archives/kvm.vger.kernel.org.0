Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED55340C79
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhCRSIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:08:11 -0400
Received: from foss.arm.com ([217.140.110.172]:45646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCRSHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 14:07:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C6BB31B;
        Thu, 18 Mar 2021 11:07:54 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87DCD3F70D;
        Thu, 18 Mar 2021 11:07:53 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH v2 0/4] Fix the devicetree parser for stdout-path
Date:   Thu, 18 Mar 2021 18:07:23 +0000
Message-Id: <20210318180727.116004-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This set of patches fixes the way we parse the stdout-path
property in the DT. The stdout-path property is used to set up
the console. Prior to this, the code ignored the fact that
stdout-path is made of the path to the uart node as well as
parameters. As a result, it would fail to find the relevant DT
node. In addition to minor fixes in the device tree code, this
series pulls a new version of libfdt from upstream.

v1: https://lore.kernel.org/kvm/20210316152405.50363-1-nikos.nikoleris@arm.com/

Changes in v2:
  - Added strtoul and minor fix in strrchr
  - Fixes in libfdt_clean
  - Minor fix in lib/libfdt/README

Thanks,

Nikos

Nikos Nikoleris (4):
  lib/string: Add strnlen, strrchr and strtoul
  libfdt: Pull v1.6.0
  Makefile: Remove overriding recipe for libfdt_clean
  devicetree: Parse correctly the stdout-path

 lib/libfdt/README            |   5 +-
 Makefile                     |  16 +-
 arm/Makefile.common          |   2 +-
 lib/libfdt/Makefile.libfdt   |  10 +-
 powerpc/Makefile.common      |   2 +-
 lib/libfdt/version.lds       |  24 +-
 lib/libfdt/fdt.h             |  53 +--
 lib/libfdt/libfdt.h          | 766 +++++++++++++++++++++++++-----
 lib/libfdt/libfdt_env.h      | 109 ++---
 lib/libfdt/libfdt_internal.h | 206 +++++---
 lib/stdlib.h                 |  12 +
 lib/string.h                 |   5 +-
 lib/devicetree.c             |  15 +-
 lib/libfdt/fdt.c             | 200 +++++---
 lib/libfdt/fdt_addresses.c   | 101 ++++
 lib/libfdt/fdt_check.c       |  74 +++
 lib/libfdt/fdt_empty_tree.c  |  48 +-
 lib/libfdt/fdt_overlay.c     | 881 +++++++++++++++++++++++++++++++++++
 lib/libfdt/fdt_ro.c          | 512 +++++++++++++++-----
 lib/libfdt/fdt_rw.c          | 231 +++++----
 lib/libfdt/fdt_strerror.c    |  53 +--
 lib/libfdt/fdt_sw.c          | 297 ++++++++----
 lib/libfdt/fdt_wip.c         |  90 ++--
 lib/string.c                 |  77 ++-
 24 files changed, 2948 insertions(+), 841 deletions(-)
 create mode 100644 lib/stdlib.h
 create mode 100644 lib/libfdt/fdt_addresses.c
 create mode 100644 lib/libfdt/fdt_check.c
 create mode 100644 lib/libfdt/fdt_overlay.c

-- 
2.25.1

