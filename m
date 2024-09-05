Return-Path: <kvm+bounces-25923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BFE96CED4
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 07:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CB9B1F2243B
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 05:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A651891B9;
	Thu,  5 Sep 2024 05:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZiBC1pM4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3800155725
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725515977; cv=none; b=RUJXeEfJBv0D40jvaQwojCen1jOfziCJNpPIALYqgUMb/dHqve1mg8VR8NvYAsONyr+6y3Q0d6x7omvDMFOO22pR72EQ7GW2DeVeBQBwdC5Se76JBJHa0eswhAK0BqOZTJjAMOtLDxQvBUbNwJkymnz5SUqjwrOMqijDsTqzyg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725515977; c=relaxed/simple;
	bh=sWfZuJ7waVjuYwsAafTJy2/S+05vtvCqpA4NPLdw1ag=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p4sHjHEFlwwOY8Xwr+iVSQzmvYv/MFdxsmsOpJuhgiBsjtxrG/qe2TXi9dEeugiJyKuCX6nn90x8U9csG9UG2QY9nkXk6biELuiij7x0G3hTgrwVC0LSz184g4cpjhqTfqhpnPOd8MtNgcUbVNIBcFXZcz8wFCCLY1tgYbiWYLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZiBC1pM4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725515974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6reZ1veDRgjADNo0UCSOVYrtvbXoke99y6rq2zpHqqE=;
	b=ZiBC1pM46Km2ZV085i3jhmny7tsU8dXN8mBgNLoh6WkfD35XwokYxB3DU8f9A9E7O+c1ck
	M8trBeBH3SW1ug3XIrrqnHfPIYTiETiiZtB1NiZS/8bR3Pq9ZOjwmP+X4ygv30HdwXZSgf
	Nmy0wGaIArr2/qkKHCHS8eGMYew+5S0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-ZRVVieJlOqmc7_FmfFlFbA-1; Thu,
 05 Sep 2024 01:59:32 -0400
X-MC-Unique: ZRVVieJlOqmc7_FmfFlFbA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A45AA19560B0;
	Thu,  5 Sep 2024 05:59:24 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 954071956048;
	Thu,  5 Sep 2024 05:59:15 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9218221E6A28; Thu,  5 Sep 2024 07:59:13 +0200 (CEST)
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
  kvm@vger.kernel.org,  avihaih@nvidia.com
Subject: Re: [PATCH v2 01/19] qapi: Smarter camel_to_upper() to reduce need
 for 'prefix'
In-Reply-To: <ZthQAr7Mpd0utBD9@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 4 Sep 2024 13:18:10 +0100")
References: <20240904111836.3273842-1-armbru@redhat.com>
	<20240904111836.3273842-2-armbru@redhat.com>
	<ZthQAr7Mpd0utBD9@redhat.com>
Date: Thu, 05 Sep 2024 07:59:13 +0200
Message-ID: <87o75263pq.fsf@pond.sub.org>
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

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Wed, Sep 04, 2024 at 01:18:18PM +0200, Markus Armbruster wrote:
>> camel_to_upper() converts its argument from camel case to upper case
>> with '_' between words.  Used for generated enumeration constant
>> prefixes.
>
>
>>=20
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>> Reviewed-by: Daniel P. Berrang?? <berrange@redhat.com>
>
> The accent in my name is getting mangled in this series.

Uh-oh!

Checking...  Hmm.  It's correct in git, correct in output of
git-format-patch, correct in the copy I got from git-send-email --bcc
armbru via localhost MTA, and the copy I got from --to
qemu-devel@nongnu.org, correct in lore.kernel.org[*], correct in an mbox
downloaded from patchew.

Could the culprit be on your side?

> IIRC your mail client (git send-email ?) needs to be explicitly
> setting a chardset eg
>
>   Content-type: text/plain; charset=3Dutf8
>
> so that mail clients & intermediate servers know how to interpret
> the 8bit data.
>
> With regards,
> Daniel


[*] https://lore.kernel.org/qemu-devel/ZthQAr7Mpd0utBD9@redhat.com/T/#m4a76=
25a47ce94c30ca2ae6d94acd2901e0d0d176


