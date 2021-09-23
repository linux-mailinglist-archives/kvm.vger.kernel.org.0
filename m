Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C49416149
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbhIWOpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:22 -0400
Received: from foss.arm.com ([217.140.110.172]:35492 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241707AbhIWOpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8C4FD6E;
        Thu, 23 Sep 2021 07:43:49 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B537C3F718;
        Thu, 23 Sep 2021 07:43:48 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 03/10] builtin-run: Do not attempt to find vmlinux if --firmware
Date:   Thu, 23 Sep 2021 15:44:58 +0100
Message-Id: <20210923144505.60776-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm->vmlinux is used by symbol.c on x86 to translate a PC address to a
kernel symbol when kvmtool exits unexpectedly. When the --firmware argument
is used, a kernel image is not used for the VM, and the vmlinux file has no
relevance in this case.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 083c7a2abea7..6a55e34ab7f9 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -528,8 +528,10 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 		}
 	}
 
-	kvm->cfg.vmlinux_filename = find_vmlinux();
-	kvm->vmlinux = kvm->cfg.vmlinux_filename;
+	if (kvm->cfg.kernel_filename) {
+		kvm->cfg.vmlinux_filename = find_vmlinux();
+		kvm->vmlinux = kvm->cfg.vmlinux_filename;
+	}
 
 	if (kvm->cfg.nrcpus == 0)
 		kvm->cfg.nrcpus = nr_online_cpus;
-- 
2.31.1

