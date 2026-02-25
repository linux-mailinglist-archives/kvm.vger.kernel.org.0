Return-Path: <kvm+bounces-71820-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QIMBBKflnmkCXwQAu9opvQ
	(envelope-from <kvm+bounces-71820-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:05:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E6A196F77
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 13:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B0EA3032CD7
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 12:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2243ACF19;
	Wed, 25 Feb 2026 12:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyroccrk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565063ACEFA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772021106; cv=none; b=tcTsVuqNyhEpO0bybBKyUXAFcUIva5u4+zQsVdSAyYBouYLv2wcJ3fnNZwH/BTgN7gRdoAd1Pp8huLUtZwfSRnXDuZQZ5ZyRSDbjPiArCXaI2tst0Ni/AkLNLb/ICvBB1CgF3t5xy8Yv/bwC7AqRMPohGkwVz2PNnECl+AzbXrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772021106; c=relaxed/simple;
	bh=XY/1XjaTGOUKpSTeHGjr3mekvT4/lcXZHjiMOrl+KRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dMuf+Q08qnEGePstxZdrD3v5hhsOurAXNRDZNsLjYqF1hISXSweK8GqS35F/YQr091XE0+l8FGorF/GUWXaw+LsxAnF2UliptIv2KzBV2DB4TI+JvJFPnpYbWghQp/DGvzJs+eJBXRPzktPmSUV2RNM0mIeX+Z0KWp8i2qCx1iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyroccrk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772021104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DGfNgZNFDLRMIJxlJNW+u95AO1+LmpPR1wOLNF34j1g=;
	b=hyroccrkqjNElqn7EC429O9zq+hP8gJ+cLZAkfDRVv49c2sRAyuggUkr8RZuip18hF8gUG
	MY4BpqGvK7TDTuIKai71uYyr+stXWsOpA/qSOIfEvMgZq7c+bbH9WeBXKnn2fvSJnFDCbD
	9QVIPqUI8Dek3yxtSPB7jPzm6jBPOk4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-8Z9mnVqDPzeTZ63qUbcPnw-1; Wed,
 25 Feb 2026 07:05:01 -0500
X-MC-Unique: 8Z9mnVqDPzeTZ63qUbcPnw-1
X-Mimecast-MFC-AGG-ID: 8Z9mnVqDPzeTZ63qUbcPnw_1772021099
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CA991800451;
	Wed, 25 Feb 2026 12:04:59 +0000 (UTC)
Received: from localhost (unknown [10.48.1.67])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B54751800465;
	Wed, 25 Feb 2026 12:04:57 +0000 (UTC)
From: marcandre.lureau@redhat.com
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Mark Kanda <mark.kanda@oracle.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Ben Chaney <bchaney@akamai.com>,
	Fabiano Rosas <farosas@suse.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH v2 00/14] Make RamDiscardManager work with multiple sources
Date: Wed, 25 Feb 2026 13:04:41 +0100
Message-ID: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71820-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 62E6A196F77
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

v2:
 - drop replay_{populated,discarded} from source, suggested by Peter Xu
 - add extra manager cleanup
 - add r-b tags for preliminary patches

thanks

Marc-André Lureau (14):
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
  system/memory: add RamDiscardManager reference counting and cleanup
  tests: add unit tests for RamDiscardManager multi-source aggregation

 include/hw/vfio/vfio-container.h            |    2 +-
 include/hw/vfio/vfio-cpr.h                  |    2 +-
 include/hw/virtio/virtio-mem.h              |    3 -
 include/system/memory.h                     |  285 +----
 include/system/ram-discard-manager.h        |  358 ++++++
 include/system/ramblock.h                   |    3 +-
 accel/kvm/kvm-all.c                         |    2 +-
 hw/vfio/cpr-legacy.c                        |    4 +-
 hw/vfio/listener.c                          |   12 +-
 hw/virtio/virtio-mem.c                      |  290 +----
 migration/ram.c                             |    6 +-
 system/memory.c                             |   83 +-
 system/memory_mapping.c                     |    4 +-
 system/ram-block-attributes.c               |  279 +----
 system/ram-discard-manager.c                |  612 +++++++++
 tests/unit/test-ram-discard-manager-stubs.c |   48 +
 tests/unit/test-ram-discard-manager.c       | 1234 +++++++++++++++++++
 system/meson.build                          |    1 +
 tests/unit/meson.build                      |    8 +-
 19 files changed, 2359 insertions(+), 877 deletions(-)
 create mode 100644 include/system/ram-discard-manager.h
 create mode 100644 system/ram-discard-manager.c
 create mode 100644 tests/unit/test-ram-discard-manager-stubs.c
 create mode 100644 tests/unit/test-ram-discard-manager.c

-- 
2.53.0


