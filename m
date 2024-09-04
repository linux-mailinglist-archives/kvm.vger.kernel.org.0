Return-Path: <kvm+bounces-25856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E8D96BA48
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22D311C20A83
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922DB1DA115;
	Wed,  4 Sep 2024 11:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ig75jF5i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2DD1D0965
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448737; cv=none; b=cgy1Fdj11hzWq40nhxKn07R/CX11qRggjhpSWchC5J7SppeAbOMNGBEMNa0KjfE20OoRllX8kqErkcm+Gi5bHoY9aGRnfZVrJP1pKLZiRkkGYunbTdgLdSZi+3n5X87sZKnIBbObQzS5SGZHsFXHYnAhAzczMgiqtEy3osFRsHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448737; c=relaxed/simple;
	bh=oUxNlC8AOpcmsC9qZnBMVkjQSPFsx3xCtYkWbIXjyqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JeujUrQfbF9CwCRe3KGQVXhJOqTWqhVytQDHa6RFqQZgTFaMmetmvp6N12R5TbMeuV0HYdEaVMxUH+8IMuFZ5ldypbT7jFX4yyvGdpbDNeOc7Oxlg4b/pS+GrMZbAtVXk9gOSGknqwDnHblbym79gnAsi0qqzWfFf97ObzH0vu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ig75jF5i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Oj50cX47ZUUAPXZ4RaZWe5IBh9JPe1rg3vGEm4x1p00=;
	b=Ig75jF5iNCUYEmNU3HSgzzlEu2HCW3iQnXso9sF2ZC2uBJU1Erjgo7rtvhRYwrNcjD03Mk
	rYiFUpN+Uz/ZkXwuHuRI9ZD0zUfCtp/Euh5yeHnO5zJLo1N3F3Rjgojw8UpaUjTv5ute24
	NnhcYW36dxoFO/zG/UawSiLuYAmOID0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584--Z0rh6IuPzelXwf7F63SzA-1; Wed,
 04 Sep 2024 07:18:51 -0400
X-MC-Unique: -Z0rh6IuPzelXwf7F63SzA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D65811953943;
	Wed,  4 Sep 2024 11:18:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 977801956056;
	Wed,  4 Sep 2024 11:18:38 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8B3F221E6A28; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	avihaih@nvidia.com
Subject: [PATCH v2 00/19] qapi: Reduce use of 'prefix'
Date: Wed,  4 Sep 2024 13:18:17 +0200
Message-ID: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

We use 'prefix' for a number of reasons:

* To override an ugly default.

* To shorten the prefix.

* To work around name clashes.

This series attacks the first two.  It additionally improves a number
of ugly prefixes we don't override.

PATCH 01 improves the default prefix, and drops 'prefix' where it is
now redundant.  The patch adds temporary 'prefix' to not change
generated code.

PATCH 02-08 revert the temporary 'prefix'.

PATCH 10,17 drop 'prefix' where the default is now better.

PATCH 09,11-15,18,19 rename QAPI types, and drop their 'prefix'.  I'm
prepared to adjust the renames according to maintainers' preference.

PATCH 16 renames a non-QAPI type for consistency.

v2:
* PATCH 01: Fix camel_to_upper() to avoid '__' and leading '_'.
* PATCH 01+07: Actually add a 'prefix' to HmatLBMemoryHierarchy in
  PATCH 01, as the commit message advertizes.  Remove it in PATCH 07,
  and adjust the commit message.
* PATCH 09: Keep pragma documentation-exceptions sorted.
* PATCH 04+09+18: Fix commit message typos.
* PATCH 19: New.

Markus Armbruster (19):
  qapi: Smarter camel_to_upper() to reduce need for 'prefix'
  tests/qapi-schema: Drop temporary 'prefix'
  qapi/block-core: Drop temporary 'prefix'
  qapi/common: Drop temporary 'prefix'
  qapi/crypto: Drop temporary 'prefix'
  qapi/ebpf: Drop temporary 'prefix'
  qapi/machine: Drop temporary 'prefix'
  qapi/ui: Drop temporary 'prefix'
  qapi/machine: Rename CpuS390* to S390Cpu*, and drop 'prefix'
  qapi/crypto: Drop unwanted 'prefix'
  qapi/crypto: Rename QCryptoHashAlgorithm to *Algo, and drop prefix
  qapi/crypto: Rename QCryptoCipherAlgorithm to *Algo, and drop prefix
  qapi/crypto: Rename QCryptoIVGenAlgorithm to *Algo, and drop prefix
  qapi/crypto: Rename QCryptoAkCipherAlgorithm to *Algo, and drop prefix
  qapi/crypto: Rename QCryptoRSAPaddingAlgorithm to *Algo, and drop
    prefix
  qapi/crypto: Rename QCryptoAFAlg to QCryptoAFAlgo
  qapi/cryptodev: Drop unwanted 'prefix'
  qapi/cryptodev: Rename QCryptodevBackendAlgType to *Algo, and drop
    prefix
  qapi/vfio: Rename VfioMigrationState to Qapi*, and drop prefix

 qapi/block-core.json                     |   4 +-
 qapi/crypto.json                         |  56 ++++------
 qapi/cryptodev.json                      |   7 +-
 qapi/machine-common.json                 |   5 +-
 qapi/machine-target.json                 |  11 +-
 qapi/machine.json                        |   9 +-
 qapi/migration.json                      |   1 +
 qapi/pragma.json                         |   6 +-
 qapi/ui.json                             |   1 +
 qapi/vfio.json                           |   9 +-
 crypto/afalgpriv.h                       |  14 +--
 crypto/akcipherpriv.h                    |   2 +-
 crypto/blockpriv.h                       |   6 +-
 crypto/cipherpriv.h                      |   2 +-
 crypto/hashpriv.h                        |   2 +-
 crypto/hmacpriv.h                        |   4 +-
 crypto/ivgenpriv.h                       |   6 +-
 include/crypto/afsplit.h                 |   8 +-
 include/crypto/block.h                   |   2 +-
 include/crypto/cipher.h                  |  18 ++--
 include/crypto/hash.h                    |  18 ++--
 include/crypto/hmac.h                    |   6 +-
 include/crypto/ivgen.h                   |  30 +++---
 include/crypto/pbkdf.h                   |  14 +--
 include/hw/qdev-properties-system.h      |   2 +-
 include/hw/s390x/cpu-topology.h          |   2 +-
 include/sysemu/cryptodev.h               |   2 +-
 target/s390x/cpu.h                       |   2 +-
 backends/cryptodev-builtin.c             |  52 ++++-----
 backends/cryptodev-lkcf.c                |  36 +++----
 backends/cryptodev-vhost-user.c          |   6 +-
 backends/cryptodev.c                     |  12 +--
 block.c                                  |   6 +-
 block/crypto.c                           |  10 +-
 block/parallels-ext.c                    |   2 +-
 block/qcow.c                             |   2 +-
 block/qcow2.c                            |  10 +-
 block/quorum.c                           |   4 +-
 block/rbd.c                              |   4 +-
 crypto/afalg.c                           |   8 +-
 crypto/afsplit.c                         |   6 +-
 crypto/akcipher.c                        |   2 +-
 crypto/block-luks.c                      | 128 +++++++++++------------
 crypto/block-qcow.c                      |   6 +-
 crypto/block.c                           |   8 +-
 crypto/cipher-afalg.c                    |  36 +++----
 crypto/cipher.c                          |  72 ++++++-------
 crypto/hash-afalg.c                      |  40 +++----
 crypto/hash-gcrypt.c                     |  20 ++--
 crypto/hash-glib.c                       |  20 ++--
 crypto/hash-gnutls.c                     |  20 ++--
 crypto/hash-nettle.c                     |  18 ++--
 crypto/hash.c                            |  30 +++---
 crypto/hmac-gcrypt.c                     |  22 ++--
 crypto/hmac-glib.c                       |  22 ++--
 crypto/hmac-gnutls.c                     |  22 ++--
 crypto/hmac-nettle.c                     |  22 ++--
 crypto/hmac.c                            |   2 +-
 crypto/ivgen.c                           |  18 ++--
 crypto/pbkdf-gcrypt.c                    |  36 +++----
 crypto/pbkdf-gnutls.c                    |  36 +++----
 crypto/pbkdf-nettle.c                    |  32 +++---
 crypto/pbkdf-stub.c                      |   4 +-
 crypto/pbkdf.c                           |   2 +-
 crypto/secret_common.c                   |   2 +-
 ebpf/ebpf_rss.c                          |   2 +-
 hw/core/numa.c                           |   4 +-
 hw/core/qdev-properties-system.c         |   6 +-
 hw/misc/aspeed_hace.c                    |  16 +--
 hw/pci-bridge/cxl_upstream.c             |   4 +-
 hw/s390x/cpu-topology.c                  |   6 +-
 hw/vfio/migration.c                      |   2 +-
 hw/vfio/pci.c                            |  10 +-
 hw/virtio/virtio-crypto.c                |  24 ++---
 io/channel-websock.c                     |   2 +-
 system/vl.c                              |   2 +-
 target/i386/sev.c                        |   6 +-
 tests/bench/benchmark-crypto-akcipher.c  |  28 ++---
 tests/bench/benchmark-crypto-cipher.c    |  22 ++--
 tests/bench/benchmark-crypto-hash.c      |  10 +-
 tests/bench/benchmark-crypto-hmac.c      |   6 +-
 tests/unit/test-crypto-afsplit.c         |  10 +-
 tests/unit/test-crypto-akcipher.c        |  54 +++++-----
 tests/unit/test-crypto-block.c           |  58 +++++-----
 tests/unit/test-crypto-cipher.c          |  66 ++++++------
 tests/unit/test-crypto-hash.c            |  42 ++++----
 tests/unit/test-crypto-hmac.c            |  16 +--
 tests/unit/test-crypto-ivgen.c           |  38 +++----
 tests/unit/test-crypto-pbkdf.c           |  44 ++++----
 tests/unit/test-qobject-input-visitor.c  |   4 +-
 tests/unit/test-qobject-output-visitor.c |   4 +-
 ui/dbus.c                                |   8 +-
 ui/egl-context.c                         |   2 +-
 ui/egl-headless.c                        |   2 +-
 ui/egl-helpers.c                         |  12 +--
 ui/gtk.c                                 |   4 +-
 ui/sdl2-gl.c                             |   8 +-
 ui/sdl2.c                                |   2 +-
 ui/spice-core.c                          |   2 +-
 ui/vnc.c                                 |   6 +-
 util/hbitmap.c                           |   2 +-
 crypto/akcipher-gcrypt.c.inc             |  44 ++++----
 crypto/akcipher-nettle.c.inc             |  56 +++++-----
 crypto/cipher-builtin.c.inc              |  18 ++--
 crypto/cipher-gcrypt.c.inc               |  56 +++++-----
 crypto/cipher-gnutls.c.inc               |  38 +++----
 crypto/cipher-nettle.c.inc               |  58 +++++-----
 crypto/rsakey-builtin.c.inc              |   4 +-
 crypto/rsakey-nettle.c.inc               |   4 +-
 scripts/qapi/common.py                   |  42 ++++----
 scripts/qapi/schema.py                   |   2 +-
 tests/qapi-schema/alternate-array.out    |   1 -
 tests/qapi-schema/comments.out           |   1 -
 tests/qapi-schema/doc-good.out           |   1 -
 tests/qapi-schema/empty.out              |   1 -
 tests/qapi-schema/include-repetition.out |   1 -
 tests/qapi-schema/include-simple.out     |   1 -
 tests/qapi-schema/indented-expr.out      |   1 -
 tests/qapi-schema/qapi-schema-test.out   |   1 -
 119 files changed, 937 insertions(+), 954 deletions(-)

-- 
2.46.0


