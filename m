Return-Path: <kvm+bounces-64494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BBA0C84C4F
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 12:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1F2E4E929D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528BA3191C0;
	Tue, 25 Nov 2025 11:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/l+H2HI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31971487F6
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764070842; cv=none; b=N4O7ekA0OPqo+Yl3sIgiSIz1hV4yU8uqtC8nk68e95TfKV7FD/QYl7w+qA8o/Scjy0CFd+LgU/oadG0SECp6Xs2YfPDuNn/axBFbrLF89BqkpHmcii+3K2pt41IdFds/4HRlnE9wubxbKa6pjc9+4P1OzGKbada1GURhN3T8Hvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764070842; c=relaxed/simple;
	bh=Ha0nR4PryNtMyCivP4U0V/e0VG1Yw6dOWxoNPIhfbqY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AflLlDOFfwBQcXqBaW0nBnEj/qkStfyZT6JLV1zsRCcWP7OOYqUOCyQHHRRTUXUKLIKH+p4DHvpPMN1L8eKMBZrCBBZ2TN8LNUgdgc24U6FkcWNHHqwXj2X7Tx+1wDQW1f9J06c9KN4p4QmDMrp1/GbLq7ab78jf8t91I1GLFZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C/l+H2HI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764070839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HV5v/0PX91ze+rqqyXuU8cyV6ZiotaUP3OO2JKWgpBo=;
	b=C/l+H2HIX4kU+K/nihkhAUIQi9MAkpikMZYix4ydVVn2hQ4NS09nsMWvxyr1jigev+GnF0
	rV4IB0n4rqOCf6+XjqWKZPYoSWjdbFXFVOom4w9k0ZYcBDAFuiQEMKjkXS9CPZkAlTDaoi
	3AxGKBQo2ZKUg597eE7ek6yMv4qpCsQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-113-rOHIm4nHPKaBGrGs89H5Ew-1; Tue,
 25 Nov 2025 06:40:36 -0500
X-MC-Unique: rOHIm4nHPKaBGrGs89H5Ew-1
X-Mimecast-MFC-AGG-ID: rOHIm4nHPKaBGrGs89H5Ew_1764070836
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6FEF180057A;
	Tue, 25 Nov 2025 11:40:35 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 418EF18004D8;
	Tue, 25 Nov 2025 11:40:35 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id C9A6321E6A27; Tue, 25 Nov 2025 12:40:32 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  pbonzini@redhat.com,  kvm@vger.kernel.org,
  eesposit@redhat.com
Subject: Re: [PATCH] kvm: Don't assume accel_ioctl_end() preserves @errno
In-Reply-To: <bdbb568d-0432-4d59-bd1f-cf2eb20bc2a1@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Tue, 25 Nov 2025 11:33:43
 +0100")
References: <20251125090146.2370735-1-armbru@redhat.com>
	<875xay4h6y.fsf@pond.sub.org>
	<bdbb568d-0432-4d59-bd1f-cf2eb20bc2a1@linaro.org>
Date: Tue, 25 Nov 2025 12:40:32 +0100
Message-ID: <871plm2vdb.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> On 25/11/25 10:03, Markus Armbruster wrote:
>> Markus Armbruster <armbru@redhat.com> writes:
>>=20
>>> Retrieve the @errno set by ioctl() before we call accel_ioctl_end()
>>> instead of afterwards, so it works whether accel_ioctl_end() preserves
>>> @errno or not.
>>>
>>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>>=20
>> I did not check whether the assumption holds or not.
>
> Indeed, on Linux the futex syscall is called via qemu_event_set.

So ...

>>  If it doesn't,
>> then this needs
>>=20
>>    Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)

... we definitely want this tag, and the commit message should be
clarified as well.  Here's my try:

    kvm: Fix kvm_vm_ioctl() and kvm_device_ioctl() return value

    These functions wrap ioctl().  When ioctl() fails, it sets @errno.
    The wrappers then return that @errno negated.

    Except they call accel_ioctl_end() between calling ioctl() and reading
    @errno.  accel_ioctl_end() can clobber @errno, e.g. when a futex()
    system call fails.  Seems unlikely, but it's a bug all the same.

    Fix by retrieving @errno before calling accel_ioctl_end().

    Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)

> LGTM.
>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Thanks!


