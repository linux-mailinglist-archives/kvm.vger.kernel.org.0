Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BF3437DE
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733066AbfFMPBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732540AbfFMOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:35:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED86D85545;
        Thu, 13 Jun 2019 14:35:31 +0000 (UTC)
Received: from x1w.redhat.com (unknown [10.40.205.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 673F61001B2B;
        Thu, 13 Jun 2019 14:35:25 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: [PATCH v2 03/20] hw/i386/pc: Let e820_add_entry() return a ssize_t type
Date:   Thu, 13 Jun 2019 16:34:29 +0200
Message-Id: <20190613143446.23937-4-philmd@redhat.com>
In-Reply-To: <20190613143446.23937-1-philmd@redhat.com>
References: <20190613143446.23937-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 13 Jun 2019 14:35:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

e820_add_entry() returns an array size on success, or a negative
value on error.

Reviewed-by: Li Qiang <liq3ea@gmail.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/i386/pc.c         | 2 +-
 include/hw/i386/pc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index ff0f6bbbb3..5a7cffbb1a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -872,7 +872,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
     x86_cpu_set_a20(cpu, level);
 }
 
-int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
+ssize_t e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
 {
     unsigned int index = le32_to_cpu(e820_reserve.count);
     struct e820_entry *entry;
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index fc29893624..c56116e6f6 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -289,7 +289,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
 #define E820_NVS        4
 #define E820_UNUSABLE   5
 
-int e820_add_entry(uint64_t, uint64_t, uint32_t);
+ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
 size_t e820_get_num_entries(void);
 bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
 
-- 
2.20.1

