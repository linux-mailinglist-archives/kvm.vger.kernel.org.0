Return-Path: <kvm+bounces-14790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 500918A6F88
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA19FB2341F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2E0131737;
	Tue, 16 Apr 2024 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1m+wB+J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57203131726
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713280682; cv=none; b=bIn7MxQuwXD5cXTiGq0kC3Cr3I1ZqG8S1vKk7SBWrI6xW+N7kHJ4SJSFy0m8ys1ogxYJLaBROS9dpgFzie35NMonUHqHNoFfEeQotHxJzeM0HjjOmSb+EL+cMxqKiRWqfEAZ9PX9WTrhDQJsUHhV2MZRVzBU5mb28QVP+qfrnOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713280682; c=relaxed/simple;
	bh=tPtRVTsXis21eVmAj2j9npZRV3GxwQ/AaRJo8gVEatg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gTbIsHSr8GTXOVzU0WoNCROPugffhzXKQMuzizlexWxeTUUA9q8nu59vLlQzuDpLNoQd1bVgNCC+cezZni+VZ2bpt+AuOMLZAxIVv3vhDTGgeSOUcNjattZFflyH2febVSKKdbgQm/pGJLjTPfyItBV+yXPk+UHLwsgJ+Xu19Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1m+wB+J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713280680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPtRVTsXis21eVmAj2j9npZRV3GxwQ/AaRJo8gVEatg=;
	b=a1m+wB+Jlbvf29smpBLD4aJoQFC4yRnsn1IgLHn95CHF3mbP6VBOM9XUxW0+On+UHXGwem
	iBo6zlVrhp+l3QK0yIduKvEgkoEbtUrBPf26ytQLJNQfmR1WczsczYP0JtV+l+XgbkjUTB
	nhTIG9ZCQmwa7pyFqNcgiQs4TBP0//g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-Gxm3JAxfNWyzzrw3LARPug-1; Tue, 16 Apr 2024 11:17:56 -0400
X-MC-Unique: Gxm3JAxfNWyzzrw3LARPug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6AC7104B507;
	Tue, 16 Apr 2024 15:17:55 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 597DB2026D1F;
	Tue, 16 Apr 2024 15:17:55 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Thomas Huth <thuth@redhat.com>, Shaoqin Huang <shahuang@redhat.com>,
 qemu-arm@nongnu.org
Cc: Eric Auger <eauger@redhat.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Paolo
 Bonzini <pbonzini@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
In-Reply-To: <227c96c8-4f17-4f79-9378-a15c9dce8d46@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20240409024940.180107-1-shahuang@redhat.com>
 <d1a76e23-e361-46a9-9baf-6ab51db5d7ba@redhat.com>
 <47e0c03b-0a6f-4a58-8dd7-6f1b85bcf71c@redhat.com>
 <227c96c8-4f17-4f79-9378-a15c9dce8d46@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Tue, 16 Apr 2024 17:17:54 +0200
Message-ID: <875xwhjpzx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Apr 10 2024, Thomas Huth <thuth@redhat.com> wrote:

> On 09/04/2024 09.47, Shaoqin Huang wrote:
>> Hi Thmoas,
>>=20
>> On 4/9/24 13:33, Thomas Huth wrote:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert_has_feature(qts, "h=
ost", "kvm-pmu-filter");
>>>
>>> So you assert here that the feature is available ...
>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert_has_feat=
ure(qts, "host", "kvm-steal-time");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert_has_feat=
ure(qts, "host", "sve");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 resp =3D do_que=
ry_no_props(qts, "host");
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_supports_pmu_filter =
=3D resp_get_feature_str(resp,=20
>>>> "kvm-pmu-filter");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_supports_st=
eal_time =3D resp_get_feature(resp,=20
>>>> "kvm-steal-time");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_supports_sv=
e =3D resp_get_feature(resp, "sve");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vls =3D resp_ge=
t_sve_vls(resp);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qobject_unref(r=
esp);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (kvm_supports_pmu_filte=
r) { >
>>> ... why do you then need to check for its availability here again?
>>> I either don't understand this part of the code, or you could drop the=
=20
>>> kvm_supports_pmu_filter variable and simply always execute the code bel=
ow.
>>=20
>> Thanks for your reviewing. I did so because all other feature like=20
>> "kvm-steal-time" check its availability again. I don't know the original=
=20
>> reason why they did that. I just followed it.
>>=20
>> Do you think we should delete all the checking?
>
> resp_get_feature() seems to return a boolean value, so though these featu=
re=20
> could be there, they still could be disabled, I assume? Thus we likely ne=
ed=20
> to keep the check for those.

This had confused me as well when I looked at it the last time -- one
thing is to check whether we have a certain prop in the cpu model, the
other one whether we actually support it. Maybe this needs some
comments?


