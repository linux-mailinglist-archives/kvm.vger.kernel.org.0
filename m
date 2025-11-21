Return-Path: <kvm+bounces-64110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB15C78FF1
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:17:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A72E04EAA86
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5FD34BA49;
	Fri, 21 Nov 2025 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aqcn6V/d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DEC26A0C7
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763727293; cv=none; b=ku+4bOP9I8TkpyOwr6yDClBQuVpeQta/tvIER3bDNS242t2WYTKfRj80PXgvFQW8sWWc131xrMyE5U2t/YKRBvD8k+gUNAEYSugCY2e2cSfARbSljaOkngrM0/NfT50H2oD+NQbU1q7QrGno5vxKwVBGw9P7aXlqjE0D0OGGAUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763727293; c=relaxed/simple;
	bh=Rl9hZjnqUzXd5Q6bTL91tEDG1aRmgMTpzPUhsvDXoKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qYevCt0v9RjJpYNvJcFA0VnW2Tj+FrJEvoUUGWkFEjlqf9D3D1DF1WxkuA7jE/7yyJmeycl7xwvHAgMjc96uMWFI5gzl0Uo2cCxXVZxs1o2nqcugVPYxqHS+MICPeiBPqiOm/M3OWsrMv3zCgMJ/qAZZOqgMnkRtcY2bXR1eUtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aqcn6V/d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763727290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SakLJGJj0LkA1a6qNyCMYZNSthSDHMhyUkRA4qcArBA=;
	b=aqcn6V/dV6je1tgZpSWkcR/xMlSbfO5CVPkoxesY8LdBYOA1bmGSKbWEl+8w6inMk1lKfY
	DhB1h292hbKagn9fTcuoEr2qZbHvFyig7Cz66OTqxSoPYQjRYgKGfH37/4ExnIxBpGWEUW
	4/IDKmANCx1CTAUBm/SEORfjfE6nzjY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362--3aJYg8QO7mowt-5VMm9DQ-1; Fri,
 21 Nov 2025 07:14:49 -0500
X-MC-Unique: -3aJYg8QO7mowt-5VMm9DQ-1
X-Mimecast-MFC-AGG-ID: -3aJYg8QO7mowt-5VMm9DQ_1763727284
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 384951956059;
	Fri, 21 Nov 2025 12:14:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1C871940E82;
	Fri, 21 Nov 2025 12:14:40 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 7FBC221E6A27; Fri, 21 Nov 2025 13:14:38 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com,
	zhenwei.pi@linux.dev,
	alistair.francis@wdc.com,
	stefanb@linux.vnet.ibm.com,
	kwolf@redhat.com,
	hreitz@redhat.com,
	sw@weilnetz.de,
	qemu_oss@crudebyte.com,
	groug@kaod.org,
	mst@redhat.com,
	imammedo@redhat.com,
	anisinha@redhat.com,
	kraxel@redhat.com,
	shentey@gmail.com,
	npiggin@gmail.com,
	harshpb@linux.ibm.com,
	sstabellini@kernel.org,
	anthony@xenproject.org,
	paul@xen.org,
	edgar.iglesias@gmail.com,
	elena.ufimtseva@oracle.com,
	jag.raman@oracle.com,
	sgarzare@redhat.com,
	pbonzini@redhat.com,
	fam@euphon.net,
	philmd@linaro.org,
	alex@shazbot.org,
	clg@redhat.com,
	peterx@redhat.com,
	farosas@suse.de,
	lizhijian@fujitsu.com,
	dave@treblig.org,
	jasowang@redhat.com,
	samuel.thibault@ens-lyon.org,
	michael.roth@amd.com,
	kkostiuk@redhat.com,
	zhao1.liu@intel.com,
	mtosatti@redhat.com,
	rathc@linux.ibm.com,
	palmer@dabbelt.com,
	liwei1518@gmail.com,
	dbarboza@ventanamicro.com,
	zhiwei_liu@linux.alibaba.com,
	marcandre.lureau@redhat.com,
	qemu-block@nongnu.org,
	qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org,
	qemu-riscv@nongnu.org
Subject: [PATCH v2 00/15] Error message improvements
Date: Fri, 21 Nov 2025 13:14:23 +0100
Message-ID: <20251121121438.1249498-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

v2:
* PATCH 02: New, replacing old PATCH 02 [Dave]
* PATCH 03: New, replacing one of old PATCH 09's hunks
* PATCH 12: Fix patch splitting mishap [Dave]
* PATCH 13: Fix lost argument [Dave]

Markus Armbruster (15):
  error: Strip trailing '\n' from error string arguments (again)
  hw/usb: Convert to qemu_create() for a better error message
  ui: Convert to qemu_create() for simplicity and consistency
  tap-solaris: Use error_setg_file_open() for better error messages
  qga: Use error_setg_file_open() for better error messages
  hw/scsi: Use error_setg_file_open() for a better error message
  hw/virtio: Use error_setg_file_open() for a better error message
  net/tap: Use error_setg_file_open() for a better error message
  blkdebug: Use error_setg_file_open() for a better error message
  error: Use error_setg_file_open() for simplicity and consistency
  net/slirp: Improve file open error message
  error: Use error_setg_errno() to improve error messages
  error: Use error_setg_errno() for simplicity and consistency
  qga/commands-win32: Use error_setg_win32() for better error messages
  block/file-win32: Improve an error message

 backends/cryptodev-lkcf.c   |  2 +-
 backends/spdm-socket.c      |  4 ++--
 backends/tpm/tpm_emulator.c | 13 +++++--------
 block/blkdebug.c            |  2 +-
 block/file-win32.c          |  2 +-
 hw/9pfs/9p-local.c          |  2 +-
 hw/9pfs/9p.c                |  3 +--
 hw/acpi/core.c              |  5 ++---
 hw/audio/es1370.c           |  2 +-
 hw/core/loader.c            |  2 +-
 hw/intc/openpic_kvm.c       |  3 +--
 hw/intc/xics_kvm.c          |  5 +++--
 hw/pci-host/xen_igd_pt.c    |  2 +-
 hw/ppc/spapr.c              |  6 +++---
 hw/remote/vfio-user-obj.c   | 18 +++++++++---------
 hw/scsi/vhost-scsi.c        |  3 +--
 hw/sensor/emc141x.c         |  4 ++--
 hw/sensor/tmp421.c          |  4 ++--
 hw/smbios/smbios.c          |  4 ++--
 hw/usb/bus.c                |  5 ++---
 hw/vfio/migration-multifd.c |  5 +++--
 hw/virtio/vdpa-dev.c        |  4 ++--
 hw/virtio/vhost-vsock.c     |  3 +--
 migration/postcopy-ram.c    | 10 +++++-----
 migration/rdma.c            |  3 +--
 monitor/hmp-cmds-target.c   |  2 +-
 net/dump.c                  |  2 +-
 net/l2tpv3.c                |  6 ++----
 net/slirp.c                 |  9 ++++++---
 net/tap-bsd.c               |  6 +++---
 net/tap-linux.c             |  2 +-
 net/tap-solaris.c           |  6 +++---
 net/tap.c                   |  3 +--
 qga/commands-linux.c        | 11 ++++++-----
 qga/commands-posix-ssh.c    | 23 +++++++++++++----------
 qga/commands-win32.c        | 16 ++++++++--------
 system/vl.c                 |  2 +-
 target/i386/sev.c           |  6 ++----
 target/ppc/kvm.c            |  5 ++---
 target/riscv/kvm/kvm-cpu.c  | 11 ++++++-----
 ui/gtk.c                    |  2 +-
 ui/ui-qmp-cmds.c            |  4 +---
 util/vfio-helpers.c         |  5 ++---
 43 files changed, 114 insertions(+), 123 deletions(-)

-- 
2.49.0


