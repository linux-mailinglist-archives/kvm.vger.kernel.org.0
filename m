Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDBC1C1FCC
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 23:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgEAVlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 17:41:32 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAVlc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 May 2020 17:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588369291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=na8QnBz7W2Ii0eveaJBlRsX241pOL+BoPANtqMrwttE=;
        b=XOE7VHvxJxQc4nCQ88aGNprK4Vn3G1piZHMccoF68UoVgQ2qAbZjfJRc4wzupbtD1y0cmU
        5AzyRzirTkLqR/YnNPi2UAnnVT89N7uwzE4peG/Z5JtpCCKjsdiW7PRwwtIVEsnPCzRuog
        0Ymv3oWvLkAMsbAxu8IB4oHUiUrRcwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-3SfWvdkbNrmSPRf_Im86qw-1; Fri, 01 May 2020 17:41:29 -0400
X-MC-Unique: 3SfWvdkbNrmSPRf_Im86qw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DC7A100CCC3;
        Fri,  1 May 2020 21:41:28 +0000 (UTC)
Received: from gimli.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14AE55C1B0;
        Fri,  1 May 2020 21:41:25 +0000 (UTC)
Subject: [PATCH] vfio-pci: Mask cap zero
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com
Date:   Fri, 01 May 2020 15:41:24 -0600
Message-ID: <158836927527.9272.16785800801999547009.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no PCI spec defined capability with ID 0, therefore we don't
expect to find it in a capability chain and we use this index in an
internal array for tracking the sizes of various capabilities to handle
standard config space.  Therefore if a device does present us with a
capability ID 0, we mark our capability map with nonsense that can
trigger conflicts with other capabilities in the chain.  Ignore ID 0
when walking the capability chain, handling it as a hidden capability.

Seen on an NVIDIA Tesla T4.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 87d0cc8c86ad..5935a804cb88 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1487,7 +1487,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 		if (ret)
 			return ret;
 
-		if (cap <= PCI_CAP_ID_MAX) {
+		if (cap && cap <= PCI_CAP_ID_MAX) {
 			len = pci_cap_length[cap];
 			if (len == 0xFF) { /* Variable length */
 				len = vfio_cap_len(vdev, cap, pos);

