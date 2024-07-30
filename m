Return-Path: <kvm+bounces-22644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78940940CE0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32EFF28061F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D884190053;
	Tue, 30 Jul 2024 09:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLbpeMvl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CD419414D
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330301; cv=none; b=S2IWSl5W8Iydfb2SHQr4Ykh1FhZ/j1x4QWhiGsOoBAd+vq6qZcQoYu1Me/VyPpF+D+9mHpOmqDpIOMI6f+g0iFuXa3Ll5fr1iJ2jyeRFuOK6UjfxRjM5Aareh6rNL7MifYx3Emc15TAp+41f5cAFJZF68FiR8FvgytEcV7XcA74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330301; c=relaxed/simple;
	bh=CyzQ302xALeySbUhCJ//KT+jll2/VGMml9CtYD6RbNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXZqlWHE+xJkFCv6m1rfa4+00+GOmy+wAfnuUUQQmKxvroR7BpqXksq+S2c2+nWBDHMv0C35jmRFaC/GChjOGs5lO97FXTAU570jgDxsbWtOBJgSsAokMBZW1ddYEK5ZBtYcV7sMV8d9w+O8UjrPW72kc06lwDmyhNoxNE+ToH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLbpeMvl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722330298;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZvKDZ10vluOr4JkVggkswGdfbJxzsSeMOXoQItf/Cs=;
	b=aLbpeMvlZjS3a2ZnP9ukEYNXu7/6WM2UnwKCxGC1z/k9XNE/+EqHOMCoup5gdya5f1rsFL
	jdu7HDstAsQ37bx86xRZOLvH7sKaOGikvU/+pA66QJGYcamkP//HLID5+KlCJTfQ82K3QN
	LKpD7v2Gr7rY+9etO+xQGmZ0FDnlokk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-BDKcixTcM_GH6HUaFT6nvg-1; Tue,
 30 Jul 2024 05:04:54 -0400
X-MC-Unique: BDKcixTcM_GH6HUaFT6nvg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E0721956064;
	Tue, 30 Jul 2024 09:04:50 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 815541955F40;
	Tue, 30 Jul 2024 09:04:34 +0000 (UTC)
Date: Tue, 30 Jul 2024 10:04:31 +0100
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
Subject: Re: [PATCH 15/18] qapi/crypto: Rename QCryptoRSAPaddingAlgorithm to
 *Algo, and drop prefix
Message-ID: <ZqisnyvjHzYZUuTL@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-16-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-16-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jul 30, 2024 at 10:10:29AM +0200, Markus Armbruster wrote:
> QAPI's 'prefix' feature can make the connection between enumeration
> type and its constants less than obvious.  It's best used with
> restraint.
> 
> QCryptoRSAPaddingAlgorithm has a 'prefix' that overrides the generated
> enumeration constants' prefix to QCRYPTO_RSA_PADDING_ALG.
> 
> We could simply drop 'prefix', but then the prefix becomes
> QCRYPTO_RSA_PADDING_ALGORITHM, which is rather long.
> 
> We could additionally rename the type to QCryptoRSAPaddingAlg, but I
> think the abbreviation "alg" is less than clear.
> 
> Rename the type to QCryptoRSAPaddingAlgo instead.  The prefix becomes
> QCRYPTO_RSA_PADDING_ALGO.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/crypto.json                        |  9 ++++-----
>  backends/cryptodev-builtin.c            |  6 +++---
>  backends/cryptodev-lkcf.c               | 10 +++++-----
>  tests/bench/benchmark-crypto-akcipher.c | 12 ++++++------
>  tests/unit/test-crypto-akcipher.c       | 10 +++++-----
>  crypto/akcipher-gcrypt.c.inc            | 18 +++++++++---------
>  crypto/akcipher-nettle.c.inc            | 18 +++++++++---------
>  7 files changed, 41 insertions(+), 42 deletions(-)

Acked-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


