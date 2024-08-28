Return-Path: <kvm+bounces-25251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CD2962869
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E1372841FB
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 13:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA10918787A;
	Wed, 28 Aug 2024 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QoQ22abj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D544175D48
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724851029; cv=none; b=LKiZ9Tj1eDFgQMjtCFn8SMpBt5Wg9kl09I5dEGtTV7JyCCV04UUWLmGZ85k+QGOSD4Lv0catFWUCi3pHuVBajrVwWuV1dlXhhV1bGOW56WEKs7s+AnVAyCCQFZqPA85UUUyw9nq/1RXz6gcPEjLiDpj0pTk5uKAOIgE5zA7imco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724851029; c=relaxed/simple;
	bh=tVDwP/61XrzDpTP+li4vy/cCfHP01Xc3fr3Zsez68sM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qpl0H2Ggc6XjW7LpQlw1859xqOLo7vxSYUuaJJM8+ai67mdJlfF/mDoo3HDdgXPzXqnAeV9cBBUyB1dLglPZs+kWi+TPUYIUGtqKUn2reXd0FvSiQseBNv197PIsYxJrrE/7H5tJcNu8wPpNjghag1XSaKn3rAFJWum9EVEBItE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QoQ22abj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724851026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0TgtqdjKCvWtZAewbSEHHFCTAFowGaw5CywnmWY6G8o=;
	b=QoQ22abjO5k819TF5nPNXeaBu7ryMqgNPwJYlW/Q8yNzDvCAOWKpJIvcloK1XQjuBqyyvH
	Z4HvfvV3mm+kb3GUGFL4BI2VuA7k4DCbNt+ke7hvWoqaeNfvPwGwT4HYvQzes4zT+HEWAn
	XZlIxcsdf2GJrUjfvnmxIIePaYNmW8s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-xg62V1oaMYKhzctZzJuAYA-1; Wed,
 28 Aug 2024 09:17:01 -0400
X-MC-Unique: xg62V1oaMYKhzctZzJuAYA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82E481955D52;
	Wed, 28 Aug 2024 13:17:00 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E39E919560A3;
	Wed, 28 Aug 2024 13:16:57 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id AE1BB21E6A28; Wed, 28 Aug 2024 15:16:55 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  qemu-trivial@nongnu.org,  Zhao Liu
 <zhao1.liu@intel.com>,  kvm@vger.kernel.org,  qemu-devel
 <qemu-devel@nongnu.org>
Subject: Re: [PATCH v5 1/2] kvm: replace fprintf with
 error_report()/printf() in kvm_init()
In-Reply-To: <E66A6507-F348-49F9-8887-1CE24A5827EF@redhat.com> (Ani Sinha's
	message of "Wed, 28 Aug 2024 18:10:24 +0530")
References: <20240828075630.7754-1-anisinha@redhat.com>
	<20240828075630.7754-2-anisinha@redhat.com>
	<87ikvkriw3.fsf@pond.sub.org>
	<E66A6507-F348-49F9-8887-1CE24A5827EF@redhat.com>
Date: Wed, 28 Aug 2024 15:16:55 +0200
Message-ID: <874j74rdmg.fsf@pond.sub.org>
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

Ani Sinha <anisinha@redhat.com> writes:

>> On 28 Aug 2024, at 4:53=E2=80=AFPM, Markus Armbruster <armbru@redhat.com=
> wrote:
>>=20
>> Ani Sinha <anisinha@redhat.com> writes:
>>=20
>>> error_report() is more appropriate for error situations. Replace fprint=
f with
>>> error_report() and error_printf() as appropriate. Cosmetic. No function=
al
>>> change.
>>=20
>> Uh, I missed this last time around: the change is more than just
>> cosmetics!  The error messages change, e.g. from
>>=20
>>    $ qemu-system-x86_64 -nodefaults -S -display none --accel kvm
>>    qemu-system-x86_64: --accel kvm: Could not access KVM kernel module: =
Permission denied
>>    qemu-system-x86_64: --accel kvm: failed to initialize kvm: Permission=
 denied
>>=20
>> to
>>=20
>>    $ qemu-system-x86_64 -nodefaults -S -display none --accel kvm
>>    Could not access KVM kernel module: Permission denied
>>    qemu-system-x86_64: --accel kvm: failed to initialize kvm: Permission=
 denied
>
> You got this backwards. This is what I have:

I do!  Sorry %-}

[...]


