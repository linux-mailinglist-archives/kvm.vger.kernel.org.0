Return-Path: <kvm+bounces-71651-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGTeMKvtnWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71651-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB5D18B5F3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 19D27304F021
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2D93AE6F7;
	Tue, 24 Feb 2026 18:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="08RRW07L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FA63ACA44
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957546; cv=none; b=QY3LMLMLilgJnS3yhT6IPmtFvQ5T0ec5bNmv7/zP6uUpTaTHLrUHn9bnm6MMF+WUVtGlhGKTyuEN8e6Lowmd5LeJvn/isObu72OqyJc6cptNPi43FtO9WdZvVlTYpmGtIrxpdgovV7pNSwkshZnMaTglvLun2/BqdbFD+ogNWOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957546; c=relaxed/simple;
	bh=VmQzJHJCdVhJpl0lXLHmrt7QhBYTiLTqnSuYTYveJt8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K8lMiYXs+Fr6pZFZOacYi1PYoAvWMc6g+YOT7bv4HumEanEFB095wvIGyjdq5fvPbfXT7HFDFImmm9CBG7xbM6ut1yt9V/vaPyRfckahNJLRewpdU8f3juIaiO0A6PUfyo87jXoRFbwGNLdU+71sBmMeF9Y1NlbNWEL20jKLD4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=08RRW07L; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7d4cf783c73so101668218a34.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957544; x=1772562344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X0JgQKedteVjhK5W38tsOG4zN99RY1VmLQMUHBFPZ+M=;
        b=08RRW07LrFxmudD+s2XYwZXTniSH90haA/icWBHqW8to5rmZrnL4qO64EFDPtEItpW
         jCy51vkKWdblRsDMdI95XmLo2u5/Xbduz1T0w6bw/VLFN3rQeHyXcT3dtu8SxO6Xf//R
         885XPThwWLGjTJtfLs0XewX2KIWSVMgJAk4PSURRZq7PRwmVwLW26iRBqMm41iZd/QJg
         LJeBoRa51ylIYK5g8bjPyWXJrn6QimZ+Lnp3h1zRJ7AJvZxQpAKcjD57narmTtedbdBt
         MwYyJi1Gg7+z03XPqKnLllwct8wxFmPQfmoTqGRKKv4O4tsXdI/v+9pFEax2s8SPJZ8d
         BDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957544; x=1772562344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X0JgQKedteVjhK5W38tsOG4zN99RY1VmLQMUHBFPZ+M=;
        b=O2Fh2QBxcBnkAEyc2rLlmhhUCQS/dY3M0dUbDFruqu5VrXQzDd0nqHi1Zib35AjITN
         h8l8PFdzPowLIXHN1+9ILlS99UcJ8+yq4w1DafvWe14z3PCt/kZxOBMqkYtpB3tl3TNL
         1++YvybkPL+Mofn5QFFwR9QAPLjEiiQpHy4ub1JktLdiNb7ANVQO5eqhKYxhoty6XwWY
         a3PcmZHQMlE6PJ8JJwLYP3zIM6bB7Kex2OCNNwpewwtjGXcRLu5o3ta1MfSL4bb4IObH
         vy04yW5j3wtE99+m/leTUyMDe1fOS9hPmsrwWc5Bp5jIoqtm3BLijtTakI8RSL83hK2N
         NH5w==
X-Forwarded-Encrypted: i=1; AJvYcCWXLwklkkB4Au2SUef9a/SnWGF5cVEFl6vd936FPd7R2syddZpscufr6exBdAhBfQ0Z/yQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvFC+sl/cDhjwbAsh/krFJHH/IHJtKamwWY3sE4M/Hp39vrNbq
	Mel5J/q4/U53RbHcl2zkBCPAM6ExqlSbmXqQaUpKrJqQN8yBbb9MjaSRj+IWNSWTBsKJ7k5uLpH
	MYabxM6ySGg==
X-Received: from jajt19.prod.google.com ([2002:a05:6638:2053:b0:5cf:f38:8cf1])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4b18:b0:66e:9d89:d8bf
 with SMTP id 006d021491bc7-679c44ebbaamr6942557eaf.54.1771957543578; Tue, 24
 Feb 2026 10:25:43 -0800 (PST)
Date: Tue, 24 Feb 2026 18:25:31 +0000
In-Reply-To: <20260224182532.3914470-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224182532.3914470-1-rananta@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224182532.3914470-8-rananta@google.com>
Subject: [PATCH v4 7/8] vfio: selftests: Add helpers to alloc/free vfio_pci_device
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71651-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DEB5D18B5F3
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
index f15065f531562..6f3f65021bd6c 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -397,7 +397,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
@@ -408,6 +408,20 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
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
@@ -440,5 +454,5 @@ void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 	if (device->group_fd)
 		VFIO_ASSERT_EQ(close(device->group_fd), 0);
 
-	free(device);
+	vfio_pci_device_free(device);
 }
-- 
2.53.0.414.gf7e9f6c205-goog


