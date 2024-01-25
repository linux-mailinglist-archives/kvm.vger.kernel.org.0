Return-Path: <kvm+bounces-6960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD2F83B843
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E0711C228BF
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCDB1125D7;
	Thu, 25 Jan 2024 03:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WNlHprzy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416BE8830
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153469; cv=none; b=r8oS6qYe5Xwfcs2PurgYPHzAl5Qn61juaYpofuGhK3b2T4eimwlQFY9VrVIuBBfh5ZsBtGCatO+4+KG4UqDUGeO2V487iKEUbKy1QHBkFrSb5lBqYv1sOrtYQneTKpl6X/TWocSbS+leBFJ1NYaFmtqYwLl/q22DPKrhv/+Uu30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153469; c=relaxed/simple;
	bh=06fQye4ab2G7q75ZKWk8jLhdTnPCEpYY476w3krl16E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sEBVRKOzCiqul3oY8dR5+qHBmVUtY/QLLdbB5+sg5S+NnbDFnOy5XO0GnN+LAqttIM0lDtxo+seh6z7w16WfLKO+C0WCwlIoegRpiK3iL7n2UhgX/m6Y+tLzTFKVxUeETc7oBx7fFnbvNmUEmEa2VV5nClkpSnDbyD1CaL3BatI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WNlHprzy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153468; x=1737689468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=06fQye4ab2G7q75ZKWk8jLhdTnPCEpYY476w3krl16E=;
  b=WNlHprzyDPOBWQhDPVrCvvWRGnytKoGjsJAh0APYXAkmxiw3B6Ic5WUJ
   v9fiQ3qu1uuQW6wKzge3rdk6slbuO4UwNjeWh0JKeJLYT5/+egI+22IL8
   6QoP1ZybeYoH1VNNy+bK7D66ZYC3zQo/HtI4h5A5lHAPtqLMAhtplmucG
   Zb9c39VEuyMnbqZNKI9vxF6g8RFClkrzGmAQqQ1ZAH75dsj2zGNCyNm+q
   NsBqqKS6NNy5FARAKUcCHt+ErfwWOlA63ydcbumYMPzqsroan+zKPd/LX
   1dcKN5/QS0fVHZC1ZzZxfiamJiPVPyvejcV5a/6pDbX8ToL+r118Vc/NL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430379"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430379"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:28:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086449"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:28:50 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 58/66] i386/tdx: Don't allow system reset for TDX VMs
Date: Wed, 24 Jan 2024 22:23:20 -0500
Message-Id: <20240125032328.2522472-59-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX CPU state is protected and thus vcpu state cann't be reset by VMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e36ece874246..0ec0584d22ca 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5686,7 +5686,7 @@ bool kvm_has_waitpkg(void)
 
 bool kvm_arch_cpu_check_are_resettable(void)
 {
-    return !sev_es_enabled();
+    return !sev_es_enabled() && !is_tdx_vm();
 }
 
 #define ARCH_REQ_XCOMP_GUEST_PERM       0x1025
-- 
2.34.1


