Return-Path: <kvm+bounces-72590-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIXSAW45p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72590-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:41:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 713AA1F639C
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0331D30CE507
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7B8389119;
	Tue,  3 Mar 2026 19:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GsDBHvJg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBDE3845D0
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566720; cv=none; b=mNsgRYgXIeNjvovaoCd1gw6gNZS1AyNTbx6pky+NaiB2f2XKURDD0b1dKe+GUkqRoJ9i8VLtpQ5sXMKpuJj1EK5itsHVEFhU3dhbMzo/gldle9Hr5D8cN18bRs1TWDt7p6lOOs++04tLvxFTZ+Mb+q9B+v4gGGH7iQSoG7hO3iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566720; c=relaxed/simple;
	bh=Zea1mJb1nV+2ZNc0sYa8z4jFdj6XxBzN4tc0WpNB6wM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D5+pEhesHvoL8zB7dp5P4A2OQzb3y6KkZF7KKj7OkmrULI6YY5mVyoheD8zOO6CDoNpLK1OA/zm8EVlM/wUh8l65pSb5wLe1OVHQ8fL9/Il0IqAOl9KWta+mmJyo9sbyw9lUxquV350FWRObzqZD5pTa3tuqjLMF02wiSwWGSBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GsDBHvJg; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d4c393cc9aso32604192a34.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566715; x=1773171515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zp13jkTAk6bWujFIQ+dHCM/k/mA1jLnbVAVVBxM74mU=;
        b=GsDBHvJg1LDAS2rxgxM+anQMJYvHIBBxPHglAi0Vf8OsSG9Bto8Y+uoh7YkkxQxGOA
         ScEf0KjqvvTgJWX2vx/RcDPCQq1iBNnDd5d5+utCRxPe2ZqtJKHMzxGphIo83FTgxqqY
         9R01swzJep/HwcxGvca+Xq62E4DvgIWxk9DjC9VHv4aTa9c2PTQpt9OvljWjLd0LWa77
         bZQxB3925UE3DMTpzw/iMP1JaUwl2+NY28/R1F4vVJ2qTBp6grkclZLzh4JFseHfyeY/
         jjqQCAKMOqS6aZi6VWoWHceY/JFZFR5AcSju3/zHij088rtmEJM525vjfJxb19PuAKvx
         WCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566715; x=1773171515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zp13jkTAk6bWujFIQ+dHCM/k/mA1jLnbVAVVBxM74mU=;
        b=vt/7tiyMJuAcHGAt6fDy5EHL3/KxxYYaUjgjAsWhQSAM31yO0kJiW2yrUOISC+MLBy
         X8h7MGzZObrx9omAu2ZnSkx2xx0TiKfBiHAZsxi3Rl7RPAPBz2xqJfXjAGZLwCRNnNNT
         HnRl/SKp94BZZaNFIgrSSRKgIUIJxZcluR42NzHLFEM9F+gWY614afTtH+KupEun0tLu
         bjKFSh5xsmsi3ndcjIAO91r4+c1vV48fQA92B89D8DrzSSDFwCRKPjuQxuXSpMYMErx/
         s79NSmft4QtKt1kDKw1IiJoceHEkUElukQKeZoIZl4e3GF5uVIjX92gJJHLkHF154jYG
         8YPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjDBQBQNnqrTxTYe6nCSQUXou8Z7pM4UY/PrP5pquvohyWxGsVcfroE4+drdUAmVvIoBw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdl68QIXH6YrHE5Fc3LDppeB0OwmDgxF2l1N5UJPj8gJLg0hpv
	G3fGyz8NexPX75QWbyYkpKkSOjaDTVcu2YCJFKPGgsgJFB8trbstfV5POcLuBE9AZ1vs2bKVtWC
	FEl2F11r3fg==
X-Received: from ioql7.prod.google.com ([2002:a6b:7f07:0:b0:954:4c52:95e1])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:213:b0:679:c33d:b07a
 with SMTP id 006d021491bc7-679faf001eemr9910418eaf.44.1772566715368; Tue, 03
 Mar 2026 11:38:35 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:21 +0000
In-Reply-To: <20260303193822.2526335-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303193822.2526335-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-8-rananta@google.com>
Subject: [PATCH v6 7/8] vfio: selftests: Add helpers to alloc/free vfio_pci_device
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 713AA1F639C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72590-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add a helper, vfio_pci_device_alloc(), to allocate 'struct
vfio_pci_device'. The subsequent test patch will utilize this
to get the struct with very minimal initialization done.
Internally, let vfio_pci_device_init() also make use of this
function and later do the full initialization.

Symmetrically, add a free variant, vfio_pci_device_free(),
to be used in a similar fashion.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
---
 .../vfio/lib/include/libvfio/vfio_pci_device.h |  2 ++
 .../selftests/vfio/lib/vfio_pci_device.c       | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 4ebdc00e20fca..3eabead717bbd 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -38,6 +38,8 @@ struct vfio_pci_device {
 #define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
+void vfio_pci_device_free(struct vfio_pci_device *device);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 4673b148f8c44..4ff76970e3791 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -419,7 +419,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
@@ -430,6 +430,20 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	device->iommu = iommu;
 	device->bdf = bdf;
 
+	return device;
+}
+
+void vfio_pci_device_free(struct vfio_pci_device *device)
+{
+	free(device);
+}
+
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+{
+	struct vfio_pci_device *device;
+
+	device = vfio_pci_device_alloc(bdf, iommu);
+
 	if (iommu->mode->container_path)
 		vfio_pci_container_setup(device, bdf, NULL);
 	else
@@ -462,5 +476,5 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 	if (device->group_fd)
 		VFIO_ASSERT_EQ(close(device->group_fd), 0);
 
-	free(device);
+	vfio_pci_device_free(device);
 }
-- 
2.53.0.473.g4a7958ca14-goog


