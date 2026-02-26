Return-Path: <kvm+bounces-71982-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OL19Iz1WoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71982-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:18:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EACE41A75EE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24ED1325C00E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 14:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C05C312824;
	Thu, 26 Feb 2026 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b60309R+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C17B2472A6
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114418; cv=none; b=p2C1zZS3YLnbGHrJS8965leNcFlKqLN6ZiQ3tolikrAZzBFcyKtJV49zL6G8pTD6Yak6r/UPoxed8+HWwEwCEkTjIIxeB6NFYcUKWyrBjh0GhlaPp8dFqK8tmeJ4LOZs2QSOZWqyMfERxBssXIm4QVuzst1UTeRuEXHaFA3123s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114418; c=relaxed/simple;
	bh=byaAHYu5FrHLvxAkXVYFBvyHx3yRKcVOo1lmJL/8cAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KsEisX/lGrKVUH44CPr7nKoI1tCoZg6zQCCos/GitCPwZ9H8Ju/a65S03n/UXJvgRcUD1R7pc5sR5M1NXawXj3R6vjPIM9whexPG/WGJTf/IMlfpI+yZBo9zkBjqN4wxIoFNf8DxG6MBHipdnwy7TxZe6bnhRrTE997VP3CocsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b60309R+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772114409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a4wT0ri5GvGdVnebIamXmnytN6J5FpX06JiH+x3fJhY=;
	b=b60309R+opvX3nBIXQuFTCN/efTHQB35iQPANwqv5lNPSMWQY9bhvj5nxwSiE8sQyCusGZ
	5gjyWIRhyhCBCxljtnov+GmdDiXxbN4j0Q2xGz608Nkd2TeU1b3uTaOIovI1z8KbKeRDgx
	og2+ElNzQ4ufm+x5Hly2HXJtOW0UhBA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-dIeL5E4AMBGVJTSMNWniJg-1; Thu,
 26 Feb 2026 09:00:06 -0500
X-MC-Unique: dIeL5E4AMBGVJTSMNWniJg-1
X-Mimecast-MFC-AGG-ID: dIeL5E4AMBGVJTSMNWniJg_1772114404
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 952C918005B6;
	Thu, 26 Feb 2026 14:00:04 +0000 (UTC)
Received: from localhost (unknown [10.45.242.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BAE01956056;
	Thu, 26 Feb 2026 14:00:02 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: Ben Chaney <bchaney@akamai.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Fabiano Rosas <farosas@suse.de>,
	David Hildenbrand <david@kernel.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Mark Kanda <mark.kanda@oracle.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v3 00/15] Make RamDiscardManager work with multiple sources
Date: Thu, 26 Feb 2026 14:59:45 +0100
Message-ID: <20260226140001.3622334-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71982-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ozlabs.org:url]
X-Rspamd-Queue-Id: EACE41A75EE
X-Rspamd-Action: no action

From: Marc-André Lureau <marcandre.lureau@redhat.com>

Hi,

This is an attempt to fix the incompatibility of virtio-mem with confidential
VMs. The solution implements what was discussed earlier with D. Hildenbrand:
https://patchwork.ozlabs.org/project/qemu-devel/patch/20250407074939.18657-5-chenyi.qiang@intel.com/#3502238

The first patches are misc cleanups. Then some code refactoring to have split a
manager/source. And finally, the manager learns to deal with multiple sources.

I haven't done thorough testing. I only launched a SEV guest with a virtio-mem
device. It would be nice to have more tests for those scenarios with
VFIO/virtio-mem/confvm.. In any case, review & testing needed!

(should fix https://issues.redhat.com/browse/RHEL-131968)

v3: issues found by Cédric
 - fix assertion error on shutdown, due to rcu-defer cleanup
 - fix API doc warnings

v2:
 - drop replay_{populated,discarded} from source, suggested by Peter Xu
 - add extra manager cleanup
 - add r-b tags for preliminary patches

thanks

Marc-André Lureau (15):
  system/rba: use DIV_ROUND_UP
  memory: drop RamDiscardListener::double_discard_supported
  virtio-mem: use warn_report_err_once()
  system/memory: minor doc fix
  kvm: replace RamDicardManager by the RamBlockAttribute
  system/memory: split RamDiscardManager into source and manager
  system/memory: move RamDiscardManager to separate compilation unit
  system/memory: constify section arguments
  system/ram-discard-manager: implement replay via is_populated
    iteration
  virtio-mem: remove replay_populated/replay_discarded implementation
  system/ram-discard-manager: drop replay from source interface
  system/memory: implement RamDiscardManager multi-source aggregation
  system/physmem: destroy ram block attributes before RCU-deferred
    reclaim
  system/memory: add RamDiscardManager reference counting and cleanup
  tests: add unit tests for RamDiscardManager multi-source aggregation

 include/hw/vfio/vfio-container.h            |    2 +-
 include/hw/vfio/vfio-cpr.h                  |    2 +-
 include/hw/virtio/virtio-mem.h              |    3 -
 include/system/memory.h                     |  287 +----
 include/system/ram-discard-manager.h        |  358 ++++++
 include/system/ramblock.h                   |    3 +-
 accel/kvm/kvm-all.c                         |    2 +-
 hw/vfio/cpr-legacy.c                        |    4 +-
 hw/vfio/listener.c                          |   12 +-
 hw/virtio/virtio-mem.c                      |  290 +----
 migration/ram.c                             |    6 +-
 system/memory.c                             |   83 +-
 system/memory_mapping.c                     |    4 +-
 system/physmem.c                            |    2 +-
 system/ram-block-attributes.c               |  279 +----
 system/ram-discard-manager.c                |  612 +++++++++
 tests/unit/test-ram-discard-manager-stubs.c |   48 +
 tests/unit/test-ram-discard-manager.c       | 1234 +++++++++++++++++++
 system/meson.build                          |    1 +
 tests/unit/meson.build                      |    8 +-
 20 files changed, 2361 insertions(+), 879 deletions(-)
 create mode 100644 include/system/ram-discard-manager.h
 create mode 100644 system/ram-discard-manager.c
 create mode 100644 tests/unit/test-ram-discard-manager-stubs.c
 create mode 100644 tests/unit/test-ram-discard-manager.c

-- 
2.53.0


