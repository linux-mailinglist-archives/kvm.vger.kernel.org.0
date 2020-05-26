Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5101C63DE
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 00:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgEEW1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 18:27:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727895AbgEEW1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 18:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588717628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=m7nBhUhZbP+Z+qbn0o5hwDg4WpYxThNrJoLfGxtRcL8=;
        b=cxX7WsqafQqUlT+pbsJ7NKkChxXcSYSCstoHfH4yQDxBCy+OjHkveFrpF5wbOuDTPqJ7XS
        GS5LccRFemKEKNAv7S1JyLoCicrepswEgdaES7Cofd23pUK0gXUS1yUZKJCl17c9yMmLo3
        u8Hs5LSU0Dqv5jNrYhqO5jT74xj1YqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-CkLO7d3-OJqY9olCe8Tm5A-1; Tue, 05 May 2020 18:27:06 -0400
X-MC-Unique: CkLO7d3-OJqY9olCe8Tm5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DD56100A8EA;
        Tue,  5 May 2020 22:27:05 +0000 (UTC)
Received: from gimli.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D88355D9DA;
        Tue,  5 May 2020 22:27:01 +0000 (UTC)
Subject: [PATCH v2] vfio-pci: Mask cap zero
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, cjia@nvidia.com
Date:   Tue, 05 May 2020 16:27:01 -0600
Message-ID: <158871758778.17183.9778359960687348692.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PCI Code and ID Assignment Specification changed capability ID 0
from reserved to a NULL capability in the v1.1 revision.  The NULL
capability is defined to include only the 16-bit capability header,
ie. only the ID and next pointer.  Unfortunately vfio-pci creates a
map of config space, where ID 0 is used to reserve the standard type
0 header.  Finding an actual capability with this ID therefore results
in a bogus range marked in that map and conflicts with subsequent
capabilities.  As this seems to be a dummy capability anyway and we
already support dropping capabilities, let's hide this one rather than
delving into the potentially subtle dependencies within our map.

Seen on an NVIDIA Tesla T4.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 3dcddbd572e6..0d110e268094 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1486,7 +1486,12 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 		if (ret)
 			return ret;
 
-		if (cap <= PCI_CAP_ID_MAX) {
+		/*
+		 * ID 0 is a NULL capability, conflicting with our fake
+		 * PCI_CAP_ID_BASIC.  As it has no content, consider it
+		 * hidden for now.
+		 */
+		if (cap && cap <= PCI_CAP_ID_MAX) {
 			len = pci_cap_length[cap];
 			if (len == 0xFF) { /* Variable length */
 				len = vfio_cap_len(vdev, cap, pos);

