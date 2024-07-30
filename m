Return-Path: <kvm+bounces-22635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A622940C6C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9BF9B263E6
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF07193074;
	Tue, 30 Jul 2024 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zntiucyv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E551B86DD
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722329857; cv=none; b=L8xXjoxfUIgmscn6XIU8UoCFxoq08WxE5YUfpyRp6gt7k4123TRQjvlQRj9av2iFQNDlRVs7/Z16lrIrDU6QaFMs3YePnLijmOCKbuuFkhSL5AoqMpgn692XccZ6Z91Qeyyyke0X+mQP7HzONSKK8zQ296ut7g1E575aQxP+1Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722329857; c=relaxed/simple;
	bh=kSu+bMXlOWDj5DWMeiExu6y+bUrDHckWpRMNB6hbws8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWOqvZvB8ZtujHnxv01i1Vx8KQ43ZvBh6HLi/w/FeGZoqVSsLbULrYndcpbGfyIWbD5pAZIUdvZDWvGWzqVrf3/6yXdWh515usfDDGsURZDnEN3xomZBviS2zcm0sQ9SEviq30B+BQpg8GrHiNZL6dGvUlHjrCPP0ShXgAOZ/XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zntiucyv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722329854;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HKJuVy4/ZxASOqlOg6/2YmnKNm3gJV99U5B5eDfmww=;
	b=ZntiucyvG4Cc2Q3qD+jlPBM2nlbddletgGrBtDqfiH8Gfa+g92QdCcYI2oJhUhxzJS2JJx
	2L94rNKzfJoNVRVkfMFXh96Ng+vV15BZHb2c0R/vEOuYe9XQeuAa/cHI0UDgZMZ3fBc6hf
	Dv/8vmWpUqp90Nsg6vsC2wE6UYBy5MQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-xXXIN3zbMx-6BE3TPf7olA-1; Tue,
 30 Jul 2024 04:57:31 -0400
X-MC-Unique: xXXIN3zbMx-6BE3TPf7olA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36B981955D58;
	Tue, 30 Jul 2024 08:57:24 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04A2119560AA;
	Tue, 30 Jul 2024 08:57:06 +0000 (UTC)
Date: Tue, 30 Jul 2024 09:57:03 +0100
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
Subject: Re: [PATCH 05/18] qapi/crypto: Drop temporary 'prefix'
Message-ID: <Zqiq3-nzsfBR7mzW@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-6-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-6-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Jul 30, 2024 at 10:10:19AM +0200, Markus Armbruster wrote:
> Recent commit "qapi: Smarter camel_to_upper() to reduce need for
> 'prefix'" added two temporary 'prefix' to delay changing the generated
> code.
> 
> Revert them.  This improves QCryptoBlockFormat's generated enumeration
> constant prefix from Q_CRYPTO_BLOCK_FORMAT to QCRYPTO_BLOCK_FORMAT,
> and QCryptoBlockLUKSKeyslotState's from
> Q_CRYPTO_BLOCKLUKS_KEYSLOT_STATE to QCRYPTO_BLOCK_LUKS_KEYSLOT_STATE.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/crypto.json               |  2 --
>  block/crypto.c                 | 10 +++++-----
>  block/qcow.c                   |  2 +-
>  block/qcow2.c                  | 10 +++++-----
>  crypto/block-luks.c            |  4 ++--
>  crypto/block.c                 |  4 ++--
>  tests/unit/test-crypto-block.c | 14 +++++++-------
>  7 files changed, 22 insertions(+), 24 deletions(-)

Acked-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


