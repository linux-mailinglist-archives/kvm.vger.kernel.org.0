Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711D72DD102
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 13:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgLQMB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 07:01:56 -0500
Received: from foss.arm.com ([217.140.110.172]:60192 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgLQMBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 07:01:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A19BA31B;
        Thu, 17 Dec 2020 04:01:08 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10C3A3F66B;
        Thu, 17 Dec 2020 04:01:07 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 0/1] Don't access PMU when not present
Date:   Thu, 17 Dec 2020 12:00:56 +0000
Message-Id: <20201217120057.88562-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Found this when reviewing the PMU undef patches [1], which will get merged
for 5.11 (Paolo accepted the pull request [2]).

This only happens if we try to run the PMU tests when creating a VCPU
*without* the PMU feature. I think qemu creates the VCPU by default with a
PMU and I don't know if or how that could be disabled. On the other hand,
kvmtool doesn't enable the feature by default, and you need the specify the
--pmu knob on the command line to enable guest PMU. I think this should
only affect kvmtool users.

For reference, this is what happens without the patch when I try to run a
PMU test on a host built from the kvmarm-5.11 tag from the pull request
(the --pmu knob is missing from the kvmtool command line):

$ lkvm run -c1 -m64 -f arm/pmu.flat -p cycle-counter 
  # lkvm run --firmware arm/pmu.flat -m 64 -c 1 --name guest-821
  Info: Placing fdt at 0x80200000 - 0x80210000
chr_testdev_init: chr-testdev: can't find a virtio-console
Unhandled exception ec=0 (UNKNOWN)
Vector: 4 (el1h_sync)
ESR_EL1:         02000000, ec=0 (UNKNOWN)
FAR_EL1: 1de7ec7edbadc0de (not valid)
Exception frame registers:
pc : [<000000008000b058>] lr : [<0000000080000084>] pstate: 00000000
sp : 000000008003ff60
x29: 0000000000000000 x28: 0000000000000000 
x27: 0000000000000000 x26: 0000000000000000 
x25: 0000000000000000 x24: 0000000000000000 
x23: 0000000000000000 x22: 0000000000000000 
x21: 0000000000000002 x20: 0000000080016a10 
x19: 0000000000000000 x18: 0000000000000000 
x17: 0000000000000000 x16: 0000000000000000 
x15: 0000000080040000 x14: 0000000080040000 
x13: 000000008003ff5c x12: 0000000000000058 
x11: 0000000000000064 x10: 000000008003ff0c 
x9 : 0000000000008400 x8 : 0000000000008008 
x7 : 0000000000000001 x6 : 0000000000000004 
x5 : 0000000000000000 x4 : 0000000080050003 
x3 : 0000000000000001 x2 : 0000000080016d38 
x1 : 0000000080016a10 x0 : 0000000000000002 

With the patch applied:

$ lkvm run -c1 -m64 -f arm/pmu.flat -p cycle-counter 
  # lkvm run --firmware arm/pmu.flat -m 64 -c 1 --name guest-1240
  Info: Placing fdt at 0x80200000 - 0x80210000
chr_testdev_init: chr-testdev: can't find a virtio-console
No PMU found, test skipped...
SUMMARY: 0 tests

[1] https://www.spinics.net/lists/kvm-arm/msg43347.html
[2] https://www.spinics.net/lists/kvm/msg231080.html

Alexandru Elisei (1):
  arm: pmu: Don't read PMCR if PMU is not present

 arm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.29.2

