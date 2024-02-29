Return-Path: <kvm+bounces-10382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F223A86C0F4
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 938A2B268A9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0218F4CE00;
	Thu, 29 Feb 2024 06:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kb3T8j8i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27EB44C8F
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188832; cv=none; b=rVewRki7SU/zmAan2jMfEOwMBf+uaEBlTKS/EEdjoMEfDflRXddViG8OSXBZ+NEHIQgoCOgX7Vzr3zCy+aynmEzhxgpx2TLF5SKGdpKBFhhS7l2BJE4cNMyeY8ARSuhwfMnD6FaDjQWAaKKP9PKxiwn8A2770xybPhUhXpjFi/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188832; c=relaxed/simple;
	bh=KgGvDoYjulZa9KIa+uPzie2x7EG+Tf77DFx6csW1Tk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSsmQ5ORBDYL51WAVg0UIg+1ZdDy+1MonABxcr2tdnAyIzex7+JiQDidEco+dzJVZE5PLTp9PdHlKzdr1HYUs3S1AlwP/XtE6YcGYdEUp4AuBlkWsgSrV3wHypcW2+stC7tFWyNoMprLjxbDpPPXuhqQ74HvEzQEN5UywmgLS+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kb3T8j8i; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188830; x=1740724830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KgGvDoYjulZa9KIa+uPzie2x7EG+Tf77DFx6csW1Tk4=;
  b=Kb3T8j8i/VpzQaVckDSAjmr6T9PRCtlJS1SgUNS5rNtYov6TsJvhT6IN
   ygutEvFg5W7LcCP9M6VA0ffCVVRYHtWASd8Z7udYXE9juLPrYOixY3pZT
   VprAV+Ne1pUkk/6xyaBWDuyBjOX/muWOnToCtGKfxsTSzHoq7Nyq4ixn+
   V8ef8raSHQfkf9ExTL9/EvT4uQgwq42UqSa93NdOA+ewSdG6Vi3aVM0EW
   k0bbLElicL7NVoO265qxukDnYmy3m6K3ikewawMHhlY2rGs1UzhkFFeYY
   jZ/53lsWwUbp37kxSHlTzaKOW/DELumzJzlQsuDNMmrFrbLZ97PTCbc4z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802748"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802748"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:40:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8075516"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:40:19 -0800
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
Subject: [PATCH v5 26/65] i386/tdx: Make sept_ve_disable set by default
Date: Thu, 29 Feb 2024 01:36:47 -0500
Message-Id: <20240229063726.610065-27-xiaoyao.li@intel.com>
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

For TDX KVM use case, Linux guest is the most major one.  It requires
sept_ve_disable set.  Make it default for the main use case.  For other use
case, it can be enabled/disabled via qemu command line.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 target/i386/kvm/tdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 806192158c9d..b6295a644566 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -548,7 +548,7 @@ static void tdx_guest_init(Object *obj)
 
     qemu_mutex_init(&tdx->lock);
 
-    tdx->attributes = 0;
+    tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
 
     object_property_add_bool(obj, "sept-ve-disable",
                              tdx_guest_get_sept_ve_disable,
-- 
2.34.1


