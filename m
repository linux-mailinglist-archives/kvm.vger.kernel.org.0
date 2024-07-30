Return-Path: <kvm+bounces-22640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00ED2940CBA
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B073F286159
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0CD18FC93;
	Tue, 30 Jul 2024 09:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ByT0UPg9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9B2188CB6
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330118; cv=none; b=Ei8D62yn2mqKUlfgvekWoJoXcPkauUWB3Rg1uGfI+0gllz6rl1usv3nZ5Z6zRcbiXDp6zYgtU0EQuT/CCY5OiFrDR0Rf2Nw41Uj681gW13/bN7OvvusPtYLz40AgyFsriaalIeCsbfaw3CEQeiTi5BQmAsybNucpWEdTtvK6zFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330118; c=relaxed/simple;
	bh=TlMqIE8wi5/RSUIj+yEMy9YelVmO9taQNHqiucKvk/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdtiKyeCVRkqu+gQhaqrkyMspWE2vet446e/p3V8wiekNocbCOUbifWdNocroR6IdCL/m74jgGXsjO+yXuzkgV4+FwLdUGo0M90VC18vPbEtAG3aDk6WI8SRukxlKcfmHtxPRGHfGu7gz1lIHI2hX2VHntK+yaEe6TbJoPfgRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ByT0UPg9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722330115;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2bb64z1B0PkvBwmQIOkISOJC81cCbnlZt6q61HyPEYo=;
	b=ByT0UPg9g3rL+NWLPJSI2Ve+zmQQQI8sYwNktbzACWmXRcwht8N3s1zJ9zTazzSTJiL5QN
	sa/9zn//ZEusWrN8DCaL5alBcxezTXuuIgeBdPDKcleMkFo10sXFdeTViQ/6SEVZP6wfJi
	eJz53zR/Z17SMvMa486LNLGvVK7EmuI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-mz5nYGKvNaqkVyLOfmD7IA-1; Tue,
 30 Jul 2024 05:01:52 -0400
X-MC-Unique: mz5nYGKvNaqkVyLOfmD7IA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74EFA1955F41;
	Tue, 30 Jul 2024 09:01:47 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBCAA19560B2;
	Tue, 30 Jul 2024 09:01:14 +0000 (UTC)
Date: Tue, 30 Jul 2024 10:01:11 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, alex.williamson@redhat.com,
	andrew@codeconstruct.com.au, andrew@daynix.com,
	arei.gonglei@huawei.com, berto@igalia.com,
	borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
	den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
	farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
	idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
	jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com,
	kwolf@redhat.com, leetroy@gmail.com, marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com, michael.roth@amd.com, mst@redhat.com,
	mtosatti@redhat.com, nsg@linux.ibm.com, pasic@linux.ibm.com,
	pbonzini@redhat.com, peter.maydell@linaro.org, peterx@redhat.com,
	philmd@linaro.org, pizhenwei@bytedance.com, pl@dlhnet.de,
	richard.henderson@linaro.org, stefanha@redhat.com,
	steven_lee@aspeedtech.com, thuth@redhat.com,
	vsementsov@yandex-team.ru, wangyanan55@huawei.com,
	yuri.benditovich@daynix.com, zhao1.liu@intel.com,
	qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 11/18] qapi/crypto: Rename QCryptoHashAlgorithm to *Algo,
 and drop prefix
Message-ID: <Zqir1y4qyp-lwyuz@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-12-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-12-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Jul 30, 2024 at 10:10:25AM +0200, Markus Armbruster wrote:
> QAPI's 'prefix' feature can make the connection between enumeration
> type and its constants less than obvious.  It's best used with
> restraint.
> 
> QCryptoHashAlgorithm has a 'prefix' that overrides the generated
> enumeration constants' prefix to QCRYPTO_HASH_ALG.
> 
> We could simply drop 'prefix', but then the prefix becomes
> QCRYPTO_HASH_ALGORITHM, which is rather long.
> 
> We could additionally rename the type to QCryptoHashAlg, but I think
> the abbreviation "alg" is less than clear.

I would have gone with this, but it is a bit of a bike shed colouring
debate so I'm not fussed

> 
> Rename the type to QCryptoHashAlgo instead.  The prefix becomes to
> QCRYPTO_HASH_ALGO.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/crypto.json                        | 17 +++++-----
>  crypto/blockpriv.h                      |  2 +-
>  crypto/hashpriv.h                       |  2 +-
>  crypto/hmacpriv.h                       |  4 +--
>  crypto/ivgenpriv.h                      |  2 +-
>  include/crypto/afsplit.h                |  8 ++---
>  include/crypto/block.h                  |  2 +-
>  include/crypto/hash.h                   | 18 +++++-----
>  include/crypto/hmac.h                   |  6 ++--
>  include/crypto/ivgen.h                  |  6 ++--
>  include/crypto/pbkdf.h                  | 10 +++---
>  backends/cryptodev-builtin.c            |  8 ++---
>  backends/cryptodev-lkcf.c               | 10 +++---
>  block/parallels-ext.c                   |  2 +-
>  block/quorum.c                          |  4 +--
>  crypto/afsplit.c                        |  6 ++--
>  crypto/block-luks.c                     | 16 ++++-----
>  crypto/block.c                          |  2 +-
>  crypto/hash-afalg.c                     | 26 +++++++--------
>  crypto/hash-gcrypt.c                    | 20 +++++------
>  crypto/hash-glib.c                      | 20 +++++------
>  crypto/hash-gnutls.c                    | 20 +++++------
>  crypto/hash-nettle.c                    | 18 +++++-----
>  crypto/hash.c                           | 30 ++++++++---------
>  crypto/hmac-gcrypt.c                    | 22 ++++++-------
>  crypto/hmac-glib.c                      | 22 ++++++-------
>  crypto/hmac-gnutls.c                    | 22 ++++++-------
>  crypto/hmac-nettle.c                    | 22 ++++++-------
>  crypto/hmac.c                           |  2 +-
>  crypto/ivgen.c                          |  4 +--
>  crypto/pbkdf-gcrypt.c                   | 36 ++++++++++----------
>  crypto/pbkdf-gnutls.c                   | 36 ++++++++++----------
>  crypto/pbkdf-nettle.c                   | 32 +++++++++---------
>  crypto/pbkdf-stub.c                     |  4 +--
>  crypto/pbkdf.c                          |  2 +-
>  hw/misc/aspeed_hace.c                   | 16 ++++-----
>  io/channel-websock.c                    |  2 +-
>  target/i386/sev.c                       |  6 ++--
>  tests/bench/benchmark-crypto-akcipher.c | 12 +++----
>  tests/bench/benchmark-crypto-hash.c     | 10 +++---
>  tests/bench/benchmark-crypto-hmac.c     |  6 ++--
>  tests/unit/test-crypto-afsplit.c        | 10 +++---
>  tests/unit/test-crypto-akcipher.c       |  6 ++--
>  tests/unit/test-crypto-block.c          | 16 ++++-----
>  tests/unit/test-crypto-hash.c           | 42 +++++++++++------------
>  tests/unit/test-crypto-hmac.c           | 16 ++++-----
>  tests/unit/test-crypto-ivgen.c          |  8 ++---
>  tests/unit/test-crypto-pbkdf.c          | 44 ++++++++++++-------------
>  ui/vnc.c                                |  2 +-
>  util/hbitmap.c                          |  2 +-
>  crypto/akcipher-gcrypt.c.inc            | 14 ++++----
>  crypto/akcipher-nettle.c.inc            | 26 +++++++--------
>  52 files changed, 350 insertions(+), 351 deletions(-)

Acked-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


