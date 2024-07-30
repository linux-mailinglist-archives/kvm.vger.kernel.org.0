Return-Path: <kvm+bounces-22641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C3623940D17
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:11:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1FC8B29BED
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9FB19415F;
	Tue, 30 Jul 2024 09:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCi/d/Pr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C529B194153
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330167; cv=none; b=VPPcVMP5Ww+gR2J4wVKVRkMomLhEBdyFuZuQ6MTB70Vy/8RykelI91jLZ8vGOMCNME06HKdhdoEkZCp7Os3I+L0cM0qzZ8QNNGoFixM6C+hHIFNm1SR77Y1iUhJHLo+Zi46ptfMeUy2mXr4ButgihrNmTpXMlXK+kbBcDWNfaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330167; c=relaxed/simple;
	bh=NJ7WBr7RnCbYz1cC5NYdVfV0dy3cuFav9zEOEtrF5vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Acg2h0Cv4s2W/4JAYlYoeipiznHMlv+uDL2RH3/sJ4m/dUV7FR/3s8ZjuCvAlXFTmxBowNlK4TzCZ5/7q/3yNjKwIgzsqCtj9lW8Z3yAZSGHjPig0ita30br5KKkqOzbe+wcRBvC5FrDrkR8L4T8K0nyMqSdbXAwJwHgeMc2Msg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DCi/d/Pr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722330164;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MBwOk2rybr4Cx13x5qids7FEyTGoF/M1u/fGVdH5wmk=;
	b=DCi/d/Prd2hKO1zVfacLwIj04G7kZjev52URWD9B0dLOziQuLowSnbVD6Z+DN5W2J1Of/R
	SrnVc8gPocBEjB3lSLttsky8vtWFx8kFprW/+iQF4P8jEOn2BET5HkbbON9SqpsCOW6ELY
	Z4lDJta2B9lcgr/fFV4bXzWoQ+e0bsA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-Ff90LyE-P3Gck4jquHwqnQ-1; Tue,
 30 Jul 2024 05:02:42 -0400
X-MC-Unique: Ff90LyE-P3Gck4jquHwqnQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F0401955D4A;
	Tue, 30 Jul 2024 09:02:37 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16B26300019B;
	Tue, 30 Jul 2024 09:02:20 +0000 (UTC)
Date: Tue, 30 Jul 2024 10:02:17 +0100
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
Subject: Re: [PATCH 12/18] qapi/crypto: Rename QCryptoCipherAlgorithm to
 *Algo, and drop prefix
Message-ID: <ZqisGQF2fz6Qpvmi@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-13-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-13-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Jul 30, 2024 at 10:10:26AM +0200, Markus Armbruster wrote:
> QAPI's 'prefix' feature can make the connection between enumeration
> type and its constants less than obvious.  It's best used with
> restraint.
> 
> QCryptoCipherAlgorithm has a 'prefix' that overrides the generated
> enumeration constants' prefix to QCRYPTO_CIPHER_ALG.
> 
> We could simply drop 'prefix', but then the prefix becomes
> QCRYPTO_CIPHER_ALGORITHM, which is rather long.
> 
> We could additionally rename the type to QCryptoCipherAlg, but I think
> the abbreviation "alg" is less than clear.
> 
> Rename the type to QCryptoCipherAlgo instead.  The prefix becomes
> QCRYPTO_CIPHER_ALGO.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/block-core.json                  |  2 +-
>  qapi/crypto.json                      |  9 ++-
>  crypto/blockpriv.h                    |  4 +-
>  crypto/cipherpriv.h                   |  2 +-
>  crypto/ivgenpriv.h                    |  2 +-
>  include/crypto/cipher.h               | 18 +++---
>  include/crypto/ivgen.h                | 10 +--
>  include/crypto/pbkdf.h                |  4 +-
>  backends/cryptodev-builtin.c          | 16 ++---
>  block/rbd.c                           |  4 +-
>  crypto/block-luks.c                   | 92 +++++++++++++--------------
>  crypto/block-qcow.c                   |  4 +-
>  crypto/block.c                        |  2 +-
>  crypto/cipher-afalg.c                 | 24 +++----
>  crypto/cipher.c                       | 72 ++++++++++-----------
>  crypto/ivgen.c                        |  4 +-
>  crypto/secret_common.c                |  2 +-
>  tests/bench/benchmark-crypto-cipher.c | 22 +++----
>  tests/unit/test-crypto-block.c        | 14 ++--
>  tests/unit/test-crypto-cipher.c       | 66 +++++++++----------
>  tests/unit/test-crypto-ivgen.c        |  8 +--
>  ui/vnc.c                              |  4 +-
>  crypto/cipher-builtin.c.inc           | 18 +++---
>  crypto/cipher-gcrypt.c.inc            | 56 ++++++++--------
>  crypto/cipher-gnutls.c.inc            | 38 +++++------
>  crypto/cipher-nettle.c.inc            | 58 ++++++++---------
>  26 files changed, 277 insertions(+), 278 deletions(-)

Acked-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


