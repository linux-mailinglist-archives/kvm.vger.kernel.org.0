Return-Path: <kvm+bounces-22642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 424CF940CCC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73F691C24708
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F111193092;
	Tue, 30 Jul 2024 09:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvIhbdZc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001B31946B6
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330215; cv=none; b=dFiy4EF40cbHPUhBYx1AwRZLxU2V+C0IUsF7kqKp/btqSZHzT6qr1eRjO8fT5b98YUkms8Uu2KjUaEEZv6IpYLWXB9VkwIku5Iu8Sq89fV0HrUXCkB8oMCIEMsRuAccbZW/Nrkf+KKDUmh7cFPfpB72MyBn9GCXB2QsdoGn4chs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330215; c=relaxed/simple;
	bh=lc3xRa7sh8FDF1ChCpjMKFB+PCavBuGrLmp4pmwxS+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=po1ptPdp4Co8PbEmwBDsFDoxthB8IHg2ACdhiQIO5MoQY3xfHwFyfHx5fU38gxjdFK+TZuRKJb7SypgNXuc5Dr7cU/hjefRv6SCqYsUpyyE/o8NiFIOHhljQZMi1u07LKWJefRP6+KUX+2xVwTVrq3cz1PT0MNAGW6pNKaKfU0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvIhbdZc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722330209;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CJI1iBaARoQHF7n545LUBlg3UPJ4WTV6fVy3e6SNBA=;
	b=QvIhbdZcAU6lgn1LheQrauk/3bGh03OskJQeNbs7SBNXb6lAdLgyjbBLnUqCoNWJfQ5JSu
	ItaNDiseWbg92Kwb1kbyFSaVBNkmj0bGsKw4sh5EVXOpcZvXJn+S38PzUf1I8InfzLxsSy
	kLG/INPQEuR9zOQNtCXAn0MExprP350=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-HHTbthWNNB-J10lqS1v_vQ-1; Tue,
 30 Jul 2024 05:03:25 -0400
X-MC-Unique: HHTbthWNNB-J10lqS1v_vQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 875441955D44;
	Tue, 30 Jul 2024 09:03:20 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 92C001955E89;
	Tue, 30 Jul 2024 09:03:04 +0000 (UTC)
Date: Tue, 30 Jul 2024 10:03:01 +0100
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
Subject: Re: [PATCH 13/18] qapi/crypto: Rename QCryptoIVGenAlgorithm to
 *Algo, and drop prefix
Message-ID: <ZqisRRREEA5Q3uIk@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-14-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-14-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jul 30, 2024 at 10:10:27AM +0200, Markus Armbruster wrote:
> QAPI's 'prefix' feature can make the connection between enumeration
> type and its constants less than obvious.  It's best used with
> restraint.
> 
> QCryptoIVGenAlgorithm has a 'prefix' that overrides the generated
> enumeration constants' prefix to QCRYPTO_IVGEN_ALG.
> 
> We could simply drop 'prefix', but then the prefix becomes
> QCRYPTO_IV_GEN_ALGORITHM, which is rather long.
> 
> We could additionally rename the type to QCryptoIVGenAlg, but I think
> the abbreviation "alg" is less than clear.
> 
> Rename the type to QCryptoIVGenAlgo instead.  The prefix becomes
> QCRYPTO_IV_GEN_ALGO.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/crypto.json               |  9 ++++-----
>  crypto/ivgenpriv.h             |  2 +-
>  include/crypto/ivgen.h         | 14 +++++++-------
>  crypto/block-luks.c            | 16 ++++++++--------
>  crypto/block-qcow.c            |  2 +-
>  crypto/ivgen.c                 | 10 +++++-----
>  tests/unit/test-crypto-block.c | 14 +++++++-------
>  tests/unit/test-crypto-ivgen.c | 22 +++++++++++-----------
>  8 files changed, 44 insertions(+), 45 deletions(-)

Acked-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


