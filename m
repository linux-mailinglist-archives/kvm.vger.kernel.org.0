Return-Path: <kvm+bounces-23047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D701945F6A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 16:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFE351C210C1
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 14:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E88200109;
	Fri,  2 Aug 2024 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LNrTxs4s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6144118B48C
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722608871; cv=none; b=cFDj0gqLmh7xX20cPfTIocXWxD11cyGr8wemo4nt0LQskV4e4QkS7/sUxUMndi1k9ecwek8fjwVl0f9/BWxpr4jldFT2Ta/ld+I1CiWdu9Mmoa2rBy5sPcxRxxry/X/4OcI5jqbrwqUTWa+1nYUtv98Ubo6+cqHvHdrtCmDTMVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722608871; c=relaxed/simple;
	bh=X4jmHBSxvxql7GSDWaFyUViEdiHMRKgMs/wop+HFBAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mgLRWIXgllg+XcJPH0dlANdWfrAxJnZY44Ph+pWJrC926qtAe4JLwDUMaaskoVI1ebFswe4pt2wyrJ7RpMsGVz08zYb94mHXvwhFPPfUdNCkbmhwMzZARiIPqCCFNlef5wAPHcrLqS3Gu8KLQg9+dCIlX6pcA9i4L9CAOuDSXZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LNrTxs4s; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722608868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0AF836Ndnqh+hwBkZ5YXfF8VJZkH/V2VUoPsaRxoRbo=;
	b=LNrTxs4sGNC5O698Ma5pmjalcVXD094p/HYvlYeTMhwB7BI/g9qcNMxcjSebmkYVbbJpmR
	LEadjh6WEYbBHb4+GqOAMier8xrOZ53QvFueCfz26ME7aCmfZm5hkM7ABUdSjWOx/4TlLb
	H8yRCVrG0ARKHVRRvZQNrV1vcNxQtW4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-XWO4I8cYMCuIDar7bdZhBw-1; Fri,
 02 Aug 2024 10:27:43 -0400
X-MC-Unique: XWO4I8cYMCuIDar7bdZhBw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28AEC1955F3B;
	Fri,  2 Aug 2024 14:27:30 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9187300018D;
	Fri,  2 Aug 2024 14:27:25 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B5E1B21E668F; Fri,  2 Aug 2024 16:27:23 +0200 (CEST)
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
In-Reply-To: <ZqoIDEjiUqK2dZx4@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 31 Jul 2024 10:46:52 +0100")
References: <20240730081032.1246748-1-armbru@redhat.com>
	<20240730081032.1246748-12-armbru@redhat.com>
	<Zqir1y4qyp-lwyuz@redhat.com> <8734nrgj5i.fsf@pond.sub.org>
	<ZqoIDEjiUqK2dZx4@redhat.com>
Date: Fri, 02 Aug 2024 16:27:23 +0200
Message-ID: <87le1fxano.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Tue, Jul 30, 2024 at 02:26:49PM +0200, Markus Armbruster wrote:
>> Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:
>>=20
>> > On Tue, Jul 30, 2024 at 10:10:25AM +0200, Markus Armbruster wrote:
>> >> QAPI's 'prefix' feature can make the connection between enumeration
>> >> type and its constants less than obvious.  It's best used with
>> >> restraint.
>> >>=20
>> >> QCryptoHashAlgorithm has a 'prefix' that overrides the generated
>> >> enumeration constants' prefix to QCRYPTO_HASH_ALG.
>> >>=20
>> >> We could simply drop 'prefix', but then the prefix becomes
>> >> QCRYPTO_HASH_ALGORITHM, which is rather long.
>> >>=20
>> >> We could additionally rename the type to QCryptoHashAlg, but I think
>> >> the abbreviation "alg" is less than clear.
>> >
>> > I would have gone with this, but it is a bit of a bike shed colouring
>> > debate so I'm not fussed
>>=20
>> Either solution seems okay, so I went with my personal preference.  Do
>> feel free to state yours and ask me to respin!
>
> After reviewing the patches that follow, I'd observe that picking
> Algo has made the following patches much larger than if it had
> stuck with Alg. Basically changing both the types & constants,
> instead of only having to change the types.=20

Yes.  Worth the more obvious names to me, but again, feel free to ask me
to respin for less churn.


