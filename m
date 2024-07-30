Return-Path: <kvm+bounces-22671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D989411DA
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 14:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15F921F2402D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEE519EEC7;
	Tue, 30 Jul 2024 12:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoBLdQoD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D93C187340
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 12:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722342429; cv=none; b=EPDDWsJUjUX5bjl6l6sdaKSKhGKcUBrMLQ+J+lMRb62yU4tC96+uMArJCk293p9FBNRqL6NJLOBGQEEOwc2+gxNaEisBWK9mEj9qWcF9/OLt+9CIBOB/i0lqRwhqcQXb9a4k0hl/dZfwmcQFUSolC+rd53eH+VkQ2P6mmBez6eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722342429; c=relaxed/simple;
	bh=kW/ukfKejjyVJxRYk532WggEq4jgGaH1FvqMC/+KpaQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=P90xbn8CiQEYJn1CJctAMIYLn8I2u7ygLWAiF6LlX8v7ABajQfRSY55NMaDZHIse/2NgO+/PNPMQnLeK7J6QBHWuPl43Ape3xar4iFLEwUPpj4Vj7suQ6xVEgJIlwbuhb7zbSqxMzHANh/arOOoG91g52eRpYOJ93fwmCWS9RTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GoBLdQoD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722342426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FoIl7pnZLKt8nid26W0BwwgLMAFf7a0+a91Pu4Hk4Y8=;
	b=GoBLdQoDiptCmrJ/QX0xEKl3qGKfaYf7/LSdcoFIC55S7fQ46I7sfBJzeWIEVONYlbiuZt
	9ZNj1pqiCieLFkdMjVT8sQ9xmHXWi7lrYhKdwLVXNPFCeC+gYBJmRvYCF75p12mFN/zj99
	Vyyx1grqSKw0zgoDbh5CB1jub+JPHgE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-T4iU4Vj9N4-vkF_jdi51Rw-1; Tue,
 30 Jul 2024 08:26:59 -0400
X-MC-Unique: T4iU4Vj9N4-vkF_jdi51Rw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5B4D1955F0D;
	Tue, 30 Jul 2024 12:26:53 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B11A219560B2;
	Tue, 30 Jul 2024 12:26:51 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9991B21E668B; Tue, 30 Jul 2024 14:26:49 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,  alex.williamson@redhat.com,
  andrew@codeconstruct.com.au,  andrew@daynix.com,
  arei.gonglei@huawei.com,  berto@igalia.com,  borntraeger@linux.ibm.com,
  clg@kaod.org,  david@redhat.com,  den@openvz.org,  eblake@redhat.com,
  eduardo@habkost.net,  farman@linux.ibm.com,  farosas@suse.de,
  hreitz@redhat.com,  idryomov@gmail.com,  iii@linux.ibm.com,
  jamin_lin@aspeedtech.com,  jasowang@redhat.com,  joel@jms.id.au,
  jsnow@redhat.com,  kwolf@redhat.com,  leetroy@gmail.com,
  marcandre.lureau@redhat.com,  marcel.apfelbaum@gmail.com,
  michael.roth@amd.com,  mst@redhat.com,  mtosatti@redhat.com,
  nsg@linux.ibm.com,  pasic@linux.ibm.com,  pbonzini@redhat.com,
  peter.maydell@linaro.org,  peterx@redhat.com,  philmd@linaro.org,
  pizhenwei@bytedance.com,  pl@dlhnet.de,  richard.henderson@linaro.org,
  stefanha@redhat.com,  steven_lee@aspeedtech.com,  thuth@redhat.com,
  vsementsov@yandex-team.ru,  wangyanan55@huawei.com,
  yuri.benditovich@daynix.com,  zhao1.liu@intel.com,
  qemu-block@nongnu.org,  qemu-arm@nongnu.org,  qemu-s390x@nongnu.org,
  kvm@vger.kernel.org
Subject: Re: [PATCH 11/18] qapi/crypto: Rename QCryptoHashAlgorithm to
 *Algo, and drop prefix
In-Reply-To: <Zqir1y4qyp-lwyuz@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Tue, 30 Jul 2024 10:01:11 +0100")
References: <20240730081032.1246748-1-armbru@redhat.com>
	<20240730081032.1246748-12-armbru@redhat.com>
	<Zqir1y4qyp-lwyuz@redhat.com>
Date: Tue, 30 Jul 2024 14:26:49 +0200
Message-ID: <8734nrgj5i.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Tue, Jul 30, 2024 at 10:10:25AM +0200, Markus Armbruster wrote:
>> QAPI's 'prefix' feature can make the connection between enumeration
>> type and its constants less than obvious.  It's best used with
>> restraint.
>>=20
>> QCryptoHashAlgorithm has a 'prefix' that overrides the generated
>> enumeration constants' prefix to QCRYPTO_HASH_ALG.
>>=20
>> We could simply drop 'prefix', but then the prefix becomes
>> QCRYPTO_HASH_ALGORITHM, which is rather long.
>>=20
>> We could additionally rename the type to QCryptoHashAlg, but I think
>> the abbreviation "alg" is less than clear.
>
> I would have gone with this, but it is a bit of a bike shed colouring
> debate so I'm not fussed

Either solution seems okay, so I went with my personal preference.  Do
feel free to state yours and ask me to respin!

>> Rename the type to QCryptoHashAlgo instead.  The prefix becomes to
>> QCRYPTO_HASH_ALGO.
>>=20
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>> ---
>>  qapi/crypto.json                        | 17 +++++-----
>>  crypto/blockpriv.h                      |  2 +-
>>  crypto/hashpriv.h                       |  2 +-
>>  crypto/hmacpriv.h                       |  4 +--
>>  crypto/ivgenpriv.h                      |  2 +-
>>  include/crypto/afsplit.h                |  8 ++---
>>  include/crypto/block.h                  |  2 +-
>>  include/crypto/hash.h                   | 18 +++++-----
>>  include/crypto/hmac.h                   |  6 ++--
>>  include/crypto/ivgen.h                  |  6 ++--
>>  include/crypto/pbkdf.h                  | 10 +++---
>>  backends/cryptodev-builtin.c            |  8 ++---
>>  backends/cryptodev-lkcf.c               | 10 +++---
>>  block/parallels-ext.c                   |  2 +-
>>  block/quorum.c                          |  4 +--
>>  crypto/afsplit.c                        |  6 ++--
>>  crypto/block-luks.c                     | 16 ++++-----
>>  crypto/block.c                          |  2 +-
>>  crypto/hash-afalg.c                     | 26 +++++++--------
>>  crypto/hash-gcrypt.c                    | 20 +++++------
>>  crypto/hash-glib.c                      | 20 +++++------
>>  crypto/hash-gnutls.c                    | 20 +++++------
>>  crypto/hash-nettle.c                    | 18 +++++-----
>>  crypto/hash.c                           | 30 ++++++++---------
>>  crypto/hmac-gcrypt.c                    | 22 ++++++-------
>>  crypto/hmac-glib.c                      | 22 ++++++-------
>>  crypto/hmac-gnutls.c                    | 22 ++++++-------
>>  crypto/hmac-nettle.c                    | 22 ++++++-------
>>  crypto/hmac.c                           |  2 +-
>>  crypto/ivgen.c                          |  4 +--
>>  crypto/pbkdf-gcrypt.c                   | 36 ++++++++++----------
>>  crypto/pbkdf-gnutls.c                   | 36 ++++++++++----------
>>  crypto/pbkdf-nettle.c                   | 32 +++++++++---------
>>  crypto/pbkdf-stub.c                     |  4 +--
>>  crypto/pbkdf.c                          |  2 +-
>>  hw/misc/aspeed_hace.c                   | 16 ++++-----
>>  io/channel-websock.c                    |  2 +-
>>  target/i386/sev.c                       |  6 ++--
>>  tests/bench/benchmark-crypto-akcipher.c | 12 +++----
>>  tests/bench/benchmark-crypto-hash.c     | 10 +++---
>>  tests/bench/benchmark-crypto-hmac.c     |  6 ++--
>>  tests/unit/test-crypto-afsplit.c        | 10 +++---
>>  tests/unit/test-crypto-akcipher.c       |  6 ++--
>>  tests/unit/test-crypto-block.c          | 16 ++++-----
>>  tests/unit/test-crypto-hash.c           | 42 +++++++++++------------
>>  tests/unit/test-crypto-hmac.c           | 16 ++++-----
>>  tests/unit/test-crypto-ivgen.c          |  8 ++---
>>  tests/unit/test-crypto-pbkdf.c          | 44 ++++++++++++-------------
>>  ui/vnc.c                                |  2 +-
>>  util/hbitmap.c                          |  2 +-
>>  crypto/akcipher-gcrypt.c.inc            | 14 ++++----
>>  crypto/akcipher-nettle.c.inc            | 26 +++++++--------
>>  52 files changed, 350 insertions(+), 351 deletions(-)
>
> Acked-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>

Thanks!


