Return-Path: <kvm+bounces-22727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A6A942701
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 08:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2D2E28237F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 06:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6599716DC21;
	Wed, 31 Jul 2024 06:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7xljfw5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F5416CD39
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 06:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722407855; cv=none; b=MvufbIt8CkpRdTIS92yBfTXall4+ISCn176spMep5xxipNxLTuRknzZe0ImEGYXPLXjuJBcgsALv2Wzot4dOtEYQJOx2qyTzJMe7disb+ON31/9mYp63MvdBevLOqxVQsK+l7C2W4060Bn8le4xK226E9mR5A5Yrwj/QupPUiIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722407855; c=relaxed/simple;
	bh=h9WJ3vfetxrbC7on9u5wXv5B/r7xCLGfPLXI8KNZDhA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gF5o0A8DkZ+t+DR9vOXnpFvSD9RDdYQNFPr5VW986V/AUI5C/5yDUBI/LqilmINl4zxWvVNXC79pf8WH5o7IaSkhZANUZWOb8tL8wldIJpw6aTdQBVVqjsgWUx3JYKZDZFzvbundDGiPZdu0KAxz7JZisBiTRY0RcVbKExV4gLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7xljfw5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722407852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnUTEtS+No9S/JuqPITES1G3oDrohvDkWf9tXSxF6fE=;
	b=Y7xljfw5o9FrWXgW/9GfkMH7xVJQnciClH4y2r1Vn6IT/St0jE+7+ac9RdbrJwGWY5lyBQ
	SVIOLExXVRkYz7bxlliljJ8dssQbv5bddNnnY2BmDz+usRclfRLgbZmD5ltIHgzeenoENP
	89pdHDwBVmAgVcjXippoGNlvKeG0ma4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-uE_kmhtRPSqnjMjlJ6wdWA-1; Wed,
 31 Jul 2024 02:37:30 -0400
X-MC-Unique: uE_kmhtRPSqnjMjlJ6wdWA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF29B1955D52;
	Wed, 31 Jul 2024 06:37:16 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7061D19560B2;
	Wed, 31 Jul 2024 06:37:13 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4172521E668B; Wed, 31 Jul 2024 08:37:11 +0200 (CEST)
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
In-Reply-To: <462d7540-f9ad-4380-8056-232e69f161e9@nvidia.com> (Avihai Horon's
	message of "Wed, 31 Jul 2024 08:59:28 +0300")
References: <20240730081032.1246748-1-armbru@redhat.com>
	<20240730081032.1246748-2-armbru@redhat.com>
	<ZqiutRoQuAsrllfj@redhat.com> <87mslzgjde.fsf@pond.sub.org>
	<9b147a34-4641-4b4c-a050-51ceb3ea6a67@nvidia.com>
	<87jzh2kuux.fsf@pond.sub.org>
	<462d7540-f9ad-4380-8056-232e69f161e9@nvidia.com>
Date: Wed, 31 Jul 2024 08:37:11 +0200
Message-ID: <87wml2jcdk.fsf@pond.sub.org>
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

Avihai Horon <avihaih@nvidia.com> writes:

> On 31/07/2024 8:12, Markus Armbruster wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> Avihai Horon <avihaih@nvidia.com> writes:
>>
>>> On 30/07/2024 15:22, Markus Armbruster wrote:
>>>> Avihai, there's a question for you on VfioMigrationState.
>>>>
>>>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>>>
>>>>> On Tue, Jul 30, 2024 at 10:10:15AM +0200, Markus Armbruster wrote:
>> [...]
>>
>>>> * VfioMigrationState
>>>>
>>>>     Can't see why this one has a prefix.  Avihai, can you enlighten me?
>>>
>>> linux-headers/linux/vfio.h defines enum vfio_device_mig_state with valu=
es VFIO_DEVICE_STATE_STOP etc.
>>
>> It does not define any VFIO_DEVICE_STATE_*, though.
>>
>>> I used the QAPI prefix to emphasize this is a QAPI entity rather than a=
 VFIO entity.
>>
>> We define about two dozen symbols starting with VFIO_, and several
>> hundreds starting with vfio_.  What makes this enumeration type
>> different so its members need emphasis?
>
> Right. I thought it would be clearer with the QAPI prefix because VFIO_DE=
VICE_STATE_* and VFIO_MIGRATION_STATE_* have similar values.
>
> But it's not a must. If you want to reduce prefix usage, go ahead, I don'=
t have a strong opinion about it.

Thanks!


