Return-Path: <kvm+bounces-22719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84DAF9425A3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 368071F24E00
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 05:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822634963C;
	Wed, 31 Jul 2024 05:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGCTLWcQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EE4C8FF
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 05:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722402780; cv=none; b=RqWovbr8dFAyABxlvJ5By/gCLLEjoo0SsqHilAVHoPM7heggCJ4DbmsziPydUudIBbFr4/NRQQmZAIKEHYiiWW+wIum/bzM4elo1usxPHJ7x6+NTwyT286gqtmAwsEfW6v/FyqLT9L62H9LCGRVSHNToojb9TrcrX6vu+IAvte4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722402780; c=relaxed/simple;
	bh=QdL8QPjQBpoxUdeVn/xfeGx4ObRtlSfStgmedzKslxE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OK9WOC3f/XaFfUDiiSwLiuWUgqY5DP9XpSZhgf5bmvNOiL93yNFCphVLSLRlksHA61AEp0od7ZyNxtz/6LSCdhx1ZZvDyzWdZLktIXK+bHfKeH7yzV8lQuJsmqcjFDWPEw47P7q/TqzlJPGhBwDaKSKgCFaE0JHwYKR1HEh+hw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGCTLWcQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722402778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVHQrxNekcxtK1Yq7919QcmyccPj5czJKpkTBAdsp/s=;
	b=SGCTLWcQmX68LQE1FFqLhgoRCx3IVOCuW3cNJnGV3aiDkwOY1up3BJO12G7rpG+pjO0xrs
	1IbVlVbtxIuvH7Z3RTxKSuozU6/N6oUi0lZZlCx79l1faf83CiOd5tUx29MJklNevSff/e
	GXTZDuhS22QdtPIW+O3Uhtbc4Jl6oHo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-dAPmUXj7O6O0ulCe7pCW5A-1; Wed,
 31 Jul 2024 01:12:52 -0400
X-MC-Unique: dAPmUXj7O6O0ulCe7pCW5A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 948711955BFC;
	Wed, 31 Jul 2024 05:12:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BFAF1955F3B;
	Wed, 31 Jul 2024 05:12:40 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4BF7921E668A; Wed, 31 Jul 2024 07:12:38 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Avihai Horon <avihaih@nvidia.com>
Cc: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,
  qemu-devel@nongnu.org,
  alex.williamson@redhat.com,  andrew@codeconstruct.com.au,
  andrew@daynix.com,  arei.gonglei@huawei.com,  berto@igalia.com,
  borntraeger@linux.ibm.com,  clg@kaod.org,  david@redhat.com,
  den@openvz.org,  eblake@redhat.com,  eduardo@habkost.net,
  farman@linux.ibm.com,  farosas@suse.de,  hreitz@redhat.com,
  idryomov@gmail.com,  iii@linux.ibm.com,  jamin_lin@aspeedtech.com,
  jasowang@redhat.com,  joel@jms.id.au,  jsnow@redhat.com,
  kwolf@redhat.com,  leetroy@gmail.com,  marcandre.lureau@redhat.com,
  marcel.apfelbaum@gmail.com,  michael.roth@amd.com,  mst@redhat.com,
  mtosatti@redhat.com,  nsg@linux.ibm.com,  pasic@linux.ibm.com,
  pbonzini@redhat.com,  peter.maydell@linaro.org,  peterx@redhat.com,
  philmd@linaro.org,  pizhenwei@bytedance.com,  pl@dlhnet.de,
  richard.henderson@linaro.org,  stefanha@redhat.com,
  steven_lee@aspeedtech.com,  thuth@redhat.com,  vsementsov@yandex-team.ru,
  wangyanan55@huawei.com,  yuri.benditovich@daynix.com,
  zhao1.liu@intel.com,  qemu-block@nongnu.org,  qemu-arm@nongnu.org,
  qemu-s390x@nongnu.org,  kvm@vger.kernel.org,  =?utf-8?Q?C=C3=A9dric?= Le
 Goater
 <clg@redhat.com>
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
In-Reply-To: <9b147a34-4641-4b4c-a050-51ceb3ea6a67@nvidia.com> (Avihai Horon's
	message of "Tue, 30 Jul 2024 16:33:31 +0300")
References: <20240730081032.1246748-1-armbru@redhat.com>
	<20240730081032.1246748-2-armbru@redhat.com>
	<ZqiutRoQuAsrllfj@redhat.com> <87mslzgjde.fsf@pond.sub.org>
	<9b147a34-4641-4b4c-a050-51ceb3ea6a67@nvidia.com>
Date: Wed, 31 Jul 2024 07:12:38 +0200
Message-ID: <87jzh2kuux.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Avihai Horon <avihaih@nvidia.com> writes:

> On 30/07/2024 15:22, Markus Armbruster wrote:
>>
>> Avihai, there's a question for you on VfioMigrationState.
>>
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>
>>> On Tue, Jul 30, 2024 at 10:10:15AM +0200, Markus Armbruster wrote:

[...]

>> * VfioMigrationState
>>
>>    Can't see why this one has a prefix.  Avihai, can you enlighten me?
>
> linux-headers/linux/vfio.h defines enum vfio_device_mig_state with values=
 VFIO_DEVICE_STATE_STOP etc.

It does not define any VFIO_DEVICE_STATE_*, though.

> I used the QAPI prefix to emphasize this is a QAPI entity rather than a V=
FIO entity.

We define about two dozen symbols starting with VFIO_, and several
hundreds starting with vfio_.  What makes this enumeration type
different so its members need emphasis?

[...]


