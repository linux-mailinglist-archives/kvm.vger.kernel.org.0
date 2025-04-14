Return-Path: <kvm+bounces-43282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4B8A88D9B
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD629173FF7
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06991DF988;
	Mon, 14 Apr 2025 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JskgDtal"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E87D2DFA4E
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744665534; cv=none; b=fS57rp2Ok+ilFNCPTTuCigZJAOAgzbkK84xP+dBr96Zku0+m+n+FSLk+KyszsJVlWLC2SaXqMCcD/ftBz3AgUdTCfToMCBq9+IepNq6IQeegaJ+idGiCiFeAPRElRYT+9/sLnozS/dM3oebaq3u6LzItAIKq09nUkuHjLScluX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744665534; c=relaxed/simple;
	bh=YQ/06zfvEcF5UMcfQSij1aUf1GFr5wunJW2D9NZOJbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hca1tGTKNw3C0fDQvMECbbFzvIwDiE3KT2kAlTriNS5Iuilvdu3Rvb5RXt6fvlUucnETeTo6v/WlXvvb2EwjK5cABWOh3j2wtWR+SJ0BfX36n5i2fO1oFpHzWg1Z5hocwVZ0hPXOvuS0k2R3uJJnp1EgTPq7bqymcFoT4PokRGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JskgDtal; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744665532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=coS5bIjv+D/gf/yiERTG+K9wJBtK2z0KhS0caIojfFA=;
	b=JskgDtalH8GcQoHQnQZFLACEr0yXbSf57iCbeT+OhY3ezGYgawdSVOEYustqHLl6OnB6uh
	BlSd6b9cKTkK+Kv5DDGE1/d7shbFXzL0wd8RzOPi4aNij1eGGTvJeTcPvyrxz/xtWLPA0O
	Vs6OSPpp7GWYGVfxhvrScCNpaO7namE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-lbrIh1omMAuEXJ--FixISw-1; Mon,
 14 Apr 2025 17:18:48 -0400
X-MC-Unique: lbrIh1omMAuEXJ--FixISw-1
X-Mimecast-MFC-AGG-ID: lbrIh1omMAuEXJ--FixISw_1744665526
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F36CE18608CB;
	Mon, 14 Apr 2025 21:18:35 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 15B4F1809B73;
	Mon, 14 Apr 2025 21:18:29 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: helgaas@kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	naravamudan@nvidia.com,
	bhelgaas@google.com,
	raphael.norwitz@nutanix.com,
	ameynarkhede03@gmail.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	cp@absolutedigital.net,
	stable@vger.kernel.org
Subject: [PATCH] Revert "PCI: Avoid reset when disabled via sysfs"
Date: Mon, 14 Apr 2025 15:18:23 -0600
Message-ID: <20250414211828.3530741-1-alex.williamson@redhat.com>
In-Reply-To: <20250207205600.1846178-1-naravamudan@nvidia.com>
References: <20250207205600.1846178-1-naravamudan@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This reverts commit 479380efe1625e251008d24b2810283db60d6fcd.

The reset_method attribute on a PCI device is only intended to manage
the availability of function scoped resets for a device.  It was never
intended to restrict resets targeting the bus or slot.

In introducing a restriction that each device must support function
level reset by testing pci_reset_supported(), we essentially create a
catch-22, that a device must have a function scope reset in order to
support bus/slot reset, when we use bus/slot reset to effect a reset
of a device that does not support a function scoped reset, especially
multi-function devices.

This breaks the majority of uses cases where vfio-pci uses bus/slot
resets to manage multifunction devices that do not support function
scoped resets.

Fixes: 479380efe162 ("PCI: Avoid reset when disabled via sysfs")
Reported-by: Cal Peake <cp@absolutedigital.net>
Link: https://lore.kernel.org/all/808e1111-27b7-f35b-6d5c-5b275e73677b@absolutedigital.net
Cc: stable@vger.kernel.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4d7c9f64ea24..e77d5b53c0ce 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5429,8 +5429,6 @@ static bool pci_bus_resettable(struct pci_bus *bus)
 		return false;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (!pci_reset_supported(dev))
-			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
@@ -5507,8 +5505,6 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
 			continue;
-		if (!pci_reset_supported(dev))
-			return false;
 		if (dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
 		    (dev->subordinate && !pci_bus_resettable(dev->subordinate)))
 			return false;
-- 
2.48.1


