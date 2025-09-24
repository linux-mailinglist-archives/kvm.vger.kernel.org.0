Return-Path: <kvm+bounces-58646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE58B9A2C4
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C186322CA8
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EE83054F6;
	Wed, 24 Sep 2025 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="MhZiNGUE"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D7F1A841C;
	Wed, 24 Sep 2025 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.158.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723054; cv=none; b=r+oup9eV9teJ3++Wal4oMHIqeIUoSQTKQ2gE3VDu5B7qB602CSRPInv4r+jDhvsxibOJMsXe+OCBAZOKLpxbPWML9fIN3PqhbMaMl9GmdciU8PXCIxq2HuRnr4YnsSxAX7EfWf8ZXpkE09s5FZ3nogwJleUtJMJny12fssE3FJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723054; c=relaxed/simple;
	bh=jLXnfsqIeqhrtK/x7cXFctB9Va2q5E5qnUz17W6qVHM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P7n6P03sHC+vTJfGy0WE21UfPA4noesJ3YUs0ynBPFatsNq32dGGQczg11cv8rmrWsd1KOdzBzTn1PKwhi7aiwSiprEERwCTfuXFFgOJL6YYrhaReYq+mgQWxGD1Db6mS6VBK6UsvAxOVII5ZBmvzCD3fa4H2nrCajwlr7xEf/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=MhZiNGUE; arc=none smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723052; x=1790259052;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H7PQoekK6EZVFPK1EEOcN5aVmt5xxxRbI8vlCeS8OXI=;
  b=MhZiNGUEPB+Kb3v6NPno7AZC8CjpU2V5OmdcEIyChSF+GZS931pUjpUh
   gYCZJ1K0l9YnNdsDwBddX4rpn8kjh3rWIjugsq10sjhsvKU8YTvFari23
   cWoksGDSfNm5EfqNvA35NPZe4FcIW6m/rHhTj+vXdv9G5b1G5wX/Ci8iP
   rYCdPCQsz1QbcTsitnetMMjb9ZwOnL4UNioZS9Vjvb8XiMljP11db2lIA
   vVY8SWI7gaDuQ1r9BgP5cOanvMyEf5Kqf/khCwO0SlVbphPZHkRxqR/CX
   cz/oczCNvGaLQKJhLZ2nkc6r/qUma0ezPoOecUlyXdgj/pEFXojRXU7CA
   Q==;
X-CSE-ConnectionGUID: fvRnR7vKS5OGElbsbq+4JQ==
X-CSE-MsgGUID: pKMy4jDkRBmVJC9sCjDl3Q==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2614389"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:10:40 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:24653]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.71:2525] with esmtp (Farcaster)
 id c28bd279-d355-4d29-a440-08b9384e1c55; Wed, 24 Sep 2025 14:10:40 +0000 (UTC)
X-Farcaster-Flow-ID: c28bd279-d355-4d29-a440-08b9384e1c55
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:10:40 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:10:37 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/7] vfio: Add alias region uapi for device feature
Date: Wed, 24 Sep 2025 16:09:51 +0200
Message-ID: <20250924141018.80202-1-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This RFC proposes a new uapi VFIO DEVICE_FEATURE to create per-region
aliases with selectable attributes, initially enabling write-combine
(WC) where supported by the underlying region. The goal is to expose a
UAPI for userspace to request an alias of an existing VFIO region with
extra flags, then interact with it via a stable alias index through
existing ioctls and mmap where applicable.

This proposal is following Alex's suggestion [1]. This uapi allows
creating a region alias where the user could specify to enable certain
attributes through the alias. And then could use the alias index to
get the region info and grab the offset to operate on.

One example is to create a new Alias for bar 0 or similar BAR with WC
enabled. Then you can use the alias offset to mmap to the region with
WC enabled.

The uapi allows the user to request a region index to alias and the
extra flags to be set. Users can PROBE to get which flags are
supported by this region. The flags are the same to the region flags
in the region_info uapi.

This adds two new region flags:
- VFIO_REGION_INFO_FLAG_ALIAS: set on alias regions.
- VFIO_REGION_INFO_FLAG_WC: indicates WC is in effect for that region.

Then this series implement this uapi on vfio-pci. For vfio-pci, Alias
regions are only (for now) possible for mmap supported regions. There
could be future usages for these alias regions other than mmaps (like
I think we could use it to also allow to use read & write on
pci_iomap_wc version of the region?). In case if similar alias region
already exist return the current alias index to the user.

To mmap the region alias, we use the mmap region ops. Through that we
translate the vm_pgoff to its aliased region and call vfio_device mmap
with the alias pgoff. This enables us to mmap the original region then
update the pgrot for WC afterwards.

The call path would be:
vfio_pci_core_mmap (index >= VFIO_PCI_NUM_REGIONS)
 vfio_pci_alias_region_mmap (update vm_pgoff)
  vfio_pci_core_mmap

This series also adds required locking for region array
accessing. Since now regions are added after initial setup.

[1]: https://lore.kernel.org/kvm/20250811160710.174ca708.alex.williamson@redhat.com/

references:
https://lore.kernel.org/kvm/20250804104012.87915-1-mngyadam@amazon.de/
https://lore.kernel.org/kvm/20240731155352.3973857-1-kbusch@meta.com/
https://lore.kernel.org/kvm/lrkyq4ivccb6x.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com/

Mahmoud Adam (7):
  vfio/pci: refactor region dereferences for RCU.
  vfio_pci_core: split krealloc to allow use RCU & return index
  vfio/pci: add RCU locking for regions access
  vfio: add FEATURE_ALIAS_REGION uapi
  vfio_pci_core: allow regions with no release op
  vfio-pci: add alias_region mmap ops
  vfio-pci-core: implement FEATURE_ALIAS_REGION uapi

 drivers/vfio/pci/vfio_pci_core.c | 289 +++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_igd.c  |  34 +++-
 include/linux/vfio_pci_core.h    |   1 +
 include/uapi/linux/vfio.h        |  24 +++
 4 files changed, 301 insertions(+), 47 deletions(-)

-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


