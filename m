Return-Path: <kvm+bounces-10390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C02786C103
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D155B26BBF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B30F446D3;
	Thu, 29 Feb 2024 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AM9COpoj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD77446AC
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188879; cv=none; b=q0sziHDoz7E1q/GF1FiXthL4pHWfe1iQ2RharEnTdGE3Hd2TXwqF0IYSuGA3CYvahNOuqVKrpe3Ef00TvH0/gAVPTked704UPPbWXqgUQOjkDFqa69PCWuax5+8b2CYA6T6WnJNTF6visVPxxytuszgMxn/ZW7WZKPjGw8YMDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188879; c=relaxed/simple;
	bh=uZvEeQRwcg5hfdsq1aVm4Uu/EiX+YrSVEsATsRjn5FQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YAvwsqs9ukFpCRGz9RcRrD8pc8b/YAQJPZqDBmjHPCQnQflwXPhz+sjGxd0QL4a/gkCilJ2rpld0b6OreDYFxlx6xoxfqrdMVvugbXPXoW9ie7U4VpxoMdCemDymzShHj9dubdbVJJEaj6y9zRERwFrENK/vLvDfgFCkK9r6k04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AM9COpoj; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188878; x=1740724878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uZvEeQRwcg5hfdsq1aVm4Uu/EiX+YrSVEsATsRjn5FQ=;
  b=AM9COpojXywBROuRsMWPXg6FWiq6A0OHXgRu4fazuGyNLcRo0+otEV7x
   sPuhrozNeWZ6N0yQTL+8q8uIm5sqQpCIAIc86ii5/s2dFmNsnuQs6QaPe
   ceiOAi6G8Qtv3ms+1/gP00E1eT1ASN43KDaRh4j+hE1hbWKWmfUGIULHQ
   BndtqeMLnN9cyuN+BNRXRtXlzp0Y06TfhVa+5vxpsRWps4q7x7inBC49Z
   20xdPJSIvEu4eQhzAYayv1NQnwL6acLEwB90vrZUyLBKSPbcC30uxa1BF
   Qcj6IEw+bHEcf2YegUEhIv0zZ8puEq8gXJx+kUJeaQFGrQgr8Mh9jXdTd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802873"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802873"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:41:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075640"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:41:11 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 34/65] kvm/tdx: Ignore memory conversion to shared of unassigned region
Date: Thu, 29 Feb 2024 01:36:55 -0500
Message-Id: <20240229063726.610065-35-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires vMMIO region to be shared.  For KVM, MMIO region is the region
which kvm memslot isn't assigned to (except in-kernel emulation).
qemu has the memory region for vMMIO at each device level.

While OVMF issues MapGPA(to-shared) conservatively on 32bit PCI MMIO
region, qemu doesn't find corresponding vMMIO region because it's before
PCI device allocation and memory_region_find() finds the device region, not
PCI bus region.  It's safe to ignore MapGPA(to-shared) because when guest
accesses those region they use GPA with shared bit set for vMMIO.  Ignore
memory conversion request of non-assigned region to shared and return
success.  Otherwise OVMF is confused and panics there.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d533e2611ad8..9dc17a1b5f43 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2953,6 +2953,18 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     section = memory_region_find(get_system_memory(), start, size);
     mr = section.mr;
     if (!mr) {
+        /*
+         * Ignore converting non-assigned region to shared.
+         *
+         * TDX requires vMMIO region to be shared to inject #VE to guest.
+         * OVMF issues conservatively MapGPA(shared) on 32bit PCI MMIO region,
+         * and vIO-APIC 0xFEC00000 4K page.
+         * OVMF assigns 32bit PCI MMIO region to
+         * [top of low memory: typically 2GB=0xC000000,  0xFC00000)
+         */
+        if (!to_private) {
+            return 0;
+        }
         return -1;
     }
 
-- 
2.34.1


