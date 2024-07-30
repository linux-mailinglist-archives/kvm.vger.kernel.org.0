Return-Path: <kvm+bounces-22648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7C0940CF9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C97028737C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8A61946A6;
	Tue, 30 Jul 2024 09:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dN0dPk0U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180D11940A9
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330446; cv=none; b=O33uEy90CAAkzODTbDbc4oboCLweswadgcFfuDqlUhi9JAcGOCTkLnQbVKm4Zq8JilyspyF7mnXR8LCoumLnt5sx2JHCIrN/Yt2+5jrj1YOKDgB6m3Tj3pMhRqUIhMqFn9mzfCCCLGiJY3kkPHeKvU571K1J/5po/uH52MvxUn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330446; c=relaxed/simple;
	bh=swsybZdw37evAVWr0FlnA7kSWJ9zoILq9Ozq9sg8QiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9qIbgQi1y5DB09Clc1NOsJoTze6v2OR+7p2lTJOAXXMRIcXzgesGNgycDLIAbodFDYL8jQ2kAAv4waT0hCrxq6jzbx6cbunsR1Ikez8Yx9/qGdqyPZ467tEbiuCQB5QbZRLZBCpODUo+MTCsxPKjP+CY9RqDm8J+S2E0zo3mpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dN0dPk0U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722330444;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8G8Ati8s0mfJIwWhbqO1Cy1v5UKqA95Dovy5TDyMNOs=;
	b=dN0dPk0U8pPKZu+ealO4ML1P7lX/WcLPPzzFyKL0h2dASqcUhxaRZvvp8y3mY2NtwBYNzv
	R6nGscO3GIaDMd5SxPa2+xsQ/I+2WS9Bz0MY2tJJx+8dA8FTVYsS94HHuRYeeALwJoxLO5
	eTprdjnIl+bFgdcxNwsqkbJ5WPWFXH0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-tl4Lklj9PCCoKtygfp27yQ-1; Tue,
 30 Jul 2024 05:07:20 -0400
X-MC-Unique: tl4Lklj9PCCoKtygfp27yQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5F001955BF4;
	Tue, 30 Jul 2024 09:07:15 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EE801955D45;
	Tue, 30 Jul 2024 09:06:58 +0000 (UTC)
Date: Tue, 30 Jul 2024 10:06:54 +0100
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
Subject: Re: [PATCH 18/18] qapi/cryptodev: Rename QCryptodevBackendAlgType to
 *Algo, and drop prefix
Message-ID: <ZqitLrbh3LrI9Lp0@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-19-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-19-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Jul 30, 2024 at 10:10:32AM +0200, Markus Armbruster wrote:
> QAPI's 'prefix' feature can make the connection between enumeration
> type and its constants less than obvious.  It's best used with
> restraint.
> 
> QCryptodevBackendAlgType a 'prefix' that overrides the generated
> enumeration constants' prefix to QCRYPTODEV_BACKEND_ALG.
> 
> We could simply drop 'prefix', but I think the abbreviation "alg" is
> less than clear.
> 
> Additionally rename the type to QCryptodevBackendAlgoType.  The prefix
> becomes QCRYPTODEV_BACKEND_ALGO_TYPE.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/cryptodev.json          |  5 ++---
>  include/sysemu/cryptodev.h   |  2 +-
>  backends/cryptodev-builtin.c |  6 +++---
>  backends/cryptodev-lkcf.c    |  4 ++--
>  backends/cryptodev.c         |  6 +++---
>  hw/virtio/virtio-crypto.c    | 14 +++++++-------
>  6 files changed, 18 insertions(+), 19 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


