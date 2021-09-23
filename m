Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2EB416148
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbhIWOpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:20 -0400
Received: from foss.arm.com ([217.140.110.172]:35480 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241670AbhIWOpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F9C6D6E;
        Thu, 23 Sep 2021 07:43:48 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B9A13F718;
        Thu, 23 Sep 2021 07:43:46 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 02/10] builtin-run: Warn when ignoring initrd because --firmware was specified
Date:   Thu, 23 Sep 2021 15:44:57 +0100
Message-Id: <20210923144505.60776-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The firmware image is copied into the guest memory with the arch specific
function kvm__load_firmware() in kvm__init(). That function ignores the
initrd file, if the user specified one. Let the user know that the file is
ignored by KVM and the --initrd argument does nothing with --firmware.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 8bb8051680b1..083c7a2abea7 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -516,6 +516,9 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (kvm->cfg.kernel_filename && kvm->cfg.firmware_filename)
 		die("Only one of --kernel or --firmware can be specified");
 
+	if (kvm->cfg.firmware_filename && kvm->cfg.initrd_filename)
+		pr_warning("Ignoring initrd file when loading a firmware image");
+
 	if (!kvm->cfg.kernel_filename && !kvm->cfg.firmware_filename) {
 		kvm->cfg.kernel_filename = find_kernel();
 
-- 
2.31.1

