Return-Path: <kvm+bounces-69617-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKzwNDfRe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69617-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:29:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16229B4B33
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 890823020464
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6733612D3;
	Thu, 29 Jan 2026 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aP8+0eiA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC7364E97
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721958; cv=none; b=eI1LCWDozJ1r8rp/z48BfaN3z/3PKEPurDzT6tfruaeuhjpuRG+C24th6B+RiCy+SAS5Fe73DnewSTFJZJ3VJlHX93k8qndoaRpz27YbmacV0o5iGxWa2/Y8KA7EYrTucsAiXzjT/cCzyadVppFh0rM0CyOuDYd5JrBsdVU5jTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721958; c=relaxed/simple;
	bh=Fptw60PqRkYzWIuTBN2mK+X1wys6jPz6VcpFsR3yJlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5Q5kihq9VKZ4Mgv2I2eDYrZyaEGo5oIC9pCO8QET9gRTLjmG/eKH1fPy5F1OFsAVY1WHdRt3CCkwLrOIlkdkTANYXYIAN7GyaKEiiTP72tKx5bfVi6CSDz+OOwptTXJ918yQxR+NXJW9avnqeVh+yejbImDqhuNm9ftTDUa2LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aP8+0eiA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ec823527eso2331763a91.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721956; x=1770326756; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibCvH5eZEobsLpnry66xHV5xBXd91tAWSqhhlaOXScs=;
        b=aP8+0eiArsIVTvtj7o4LSZBOiYFcpm8isKZLT2N+x+NokzE1S91UrUx2UMIGAt30gw
         5hDPtgzFsLczo/KKP7qTLwA2Ywm/oA/qL2DPBHoiRyFayDjk8RtnzfjRkaJQvgN+5upp
         YgxKRwWUSrtL6Ap+r/ohSX5tDHFa3n8CzRb8Oe4e+ab+S3Nd60Sfowe+tboV5/BPWn93
         0/rruoBRES59bxrvygKvX62Lm31AJAa2z7Ucftv9W1vSlKuIDI04oix8WwVjHMOAeYqe
         XqOTUV++UcionZ9h9ekwVJ5IrqdlvwKDp7lCKnb64VYdBfnLJKKa7oIxufYJId0Uqkao
         fg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721956; x=1770326756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibCvH5eZEobsLpnry66xHV5xBXd91tAWSqhhlaOXScs=;
        b=DZahc18utemhssTqrNPDr9HmHtXUbKPzKcVbxHMhUSWjV/XR9S32oAJiPRwYdR968W
         pEaWRN6B4Es09m8xGkX6a/+6HeP4KwjI23owAnZ2nJ+2XJCQS1z3zGltX67YPi2KrvTo
         zLXLqI6Jk2v9zc9X4ZQxBSYhEch7oaPrKTZTzAcrVnp78vZYvkKxgcycuma1OPB+aY4I
         6h19nsWgYmBZ6OCUiFXLlaDojYzLtndlR47U0NG/LyWjk5rjCuJx7ip3fJagi5h9UgLx
         gB9lfvldBMQVeuZwuhRIVvjVl/wM5U2K3NgngkH0Y6402PIxQdWqW4ENmmAHy0vClreh
         sUHg==
X-Forwarded-Encrypted: i=1; AJvYcCXIG7znQI8a3I18LKzYxnRHMe4CVEmvangCabzLH0AOg8zhXZHqn7cl2AGZq1GLyROGrys=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7tIy5j4DYFpP8pEVOIhokHCD5N67W7IJmBMoYTjpiYjZVC42i
	EkEkQ7etUVnqpK2ne/36mteLUwBh34UN5xxy3oz6ZXBF0X2SK5mixh9dTTI77GGggk+zaHsLkHB
	XJxhdrYpZywgYSA==
X-Received: from pjbpv18.prod.google.com ([2002:a17:90b:3c92:b0:33b:ba24:b207])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ccd:b0:352:bd7c:ddbd with SMTP id 98e67ed59e1d1-3543b38af32mr802532a91.23.1769721955711;
 Thu, 29 Jan 2026 13:25:55 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:58 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-12-dmatlack@google.com>
Subject: [PATCH v2 11/22] docs: liveupdate: Document VFIO device file preservation
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69617-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 16229B4B33
X-Rspamd-Action: no action

Add documentation for preserving VFIO device files across a Live Update,
as well as some generic file preservation documentation. This
documentation will be extended in the future as new types of files are
supported and new dependency/ordering requirements are added.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/userspace-api/liveupdate.rst | 144 +++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index 41c0473e4f16..dbf1e4aeddd7 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -14,6 +14,150 @@ ioctl uAPI
 ===========
 .. kernel-doc:: include/uapi/linux/liveupdate.h
 
+File Preservation
+=================
+
+Files can be preserved across Live Update in sessions. Since only one process
+can open /dev/liveupdate, sessions must be created by a centralized process
+(e.g. "luod") and then passed via UDS to lower privilege processes (e.g. VMMs)
+for them to preserve their own files.
+
+luod::
+
+  luo_fd = open("/dev/liveupdate", ...);
+
+  ...
+
+  // Create a new session with the given name.
+  struct liveupdate_ioctl_create_session arg = {
+          .size = sizeof(arg),
+	  .name = SESSION_NAME,
+  };
+  ioctl(luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &arg);
+
+  // Send session_fd to the VMM over UDS.
+  send_session_fd(..., arg.fd);
+
+VMM::
+
+  // Receive the newly created session from luod over UDS
+  session_fd = create_session(SESSION_NAME);
+
+  ...
+
+  // Preserve a file with a unique token value in the session.
+  struct liveupdate_session_preserve_fd arg = {
+          .size = sizeof(arg),
+          .fd = fd,
+          .token = TOKEN,
+  }
+  ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg);
+
+Files can be unpreserved with the LIVEUPDATE_SESSION_UNPRESERVE_FD ioctl. They
+are also unpreserved once the last reference to the session is dropped.  To
+carry preserved files across a Live Update, references must be kept on the
+session files through the reboot(LINUX_REBOOT_CMD_KEXEC) syscall.
+
+While a file is preserved in a session, the kernel holds an extra reference
+to it to prevent it from being destroyed.
+
+Only the following types of files support LIVEUPDATE_SESSION_PRESERVE_FD. More
+types of files are expected to be added in the future.
+
+ - memfd
+ - VFIO character device files (vfio-pci only)
+
+File Retrieval
+==============
+
+Files that are preserved in a session retrieved after
+reboot(LINUX_REBOOT_CMD_KEXEC).
+
+luod::
+
+  luo_fd = open("/dev/liveupdate", ...);
+
+  ...
+
+  struct liveupdate_ioctl_retrieve_session arg = {
+          .size = sizeof(arg),
+	  .name = SESSION_NAME,
+  };
+  ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg);
+
+  // Send session_fd to VMM over UDS.
+  send_session_fd(..., arg.fd);
+
+VMM::
+
+  // Receive the retrieved session from luod over UDS
+  session_fd = retrieve_session(SESSION_NAME);
+
+  ...
+
+  // Retrieve the file associated with the token from the session.
+  struct liveupdate_session_retrieve_fd arg = {
+          .size = sizeof(arg),
+          .token = TOKEN,
+  };
+  ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+
+  ...
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
+
+A session can only be finished once all of the files within it have been
+retrieved, and are fully restored from the kernel's perspective. The exact
+requirements will vary by file type.
+
+VFIO Character Device (cdev) Files
+==================================
+
+The kernel supports preserving VFIO character device files across Live Update
+within a session::
+
+  device_fd = open("/dev/vfio/devices/X");
+
+  ...
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, { ..., device_fd, ...});
+
+Attempting to preserve files acquired via VFIO_GROUP_GET_DEVICE_FD will fail.
+
+Since the kernel holds an extra reference to files preserved in sessions, there
+is no way for the underlying PCI device to be unbound from vfio-pci while it
+is being preserved.
+
+When a VFIO device file is preserved in a session, interrupts must be disabled
+on the device prior to reboot(LINUX_REBOOT_CMD_KEXEC), or the kexec will fail.
+
+Preserved VFIO device files can be retrieved after a Live Update just like any
+other preserved file::
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+  device_fd = arg.fd;
+
+  ...
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
+
+Prior to LIVEUPDATE_SESSION_FINISH, preserved devices must be retrieved from
+the session and bound to an iommufd. Attempting to open the device through
+its character device (/dev/vfio/devices/X) or VFIO_GROUP_GET_DEVICE_FD will
+fail with -EBUSY.
+
+The eventual goal of these support is to preserve devices running uninterrupted
+across a Live Update. However there are many steps still needed to achieve this
+(see Future Work below). So for now, VFIO will reset and restore the device
+back into an idle state during reboot(LINUX_REBOOT_CMD_KEXEC).
+
+Future work:
+
+ - Preservation of iommufd files
+ - Preservation of IOMMU driver state
+ - Preservation of PCI state (BAR resources, device state, bridge state, ...)
+ - Preservation of vfio-pci driver state
+
 See Also
 ========
 
-- 
2.53.0.rc1.225.gd81095ad13-goog


