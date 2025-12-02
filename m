Return-Path: <kvm+bounces-65087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 61321C9AB1D
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 09:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D8CEE346599
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 08:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD2D24886E;
	Tue,  2 Dec 2025 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="APwK07sW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016A91E868
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 08:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764664384; cv=none; b=f1yjzW1UPjnB/q1dyUR+8HUhWe7SEK2pMJm1gJsAtxaWPuh0N1p/hWatG2ZdDvOtaV0faofawa6YIebjYHut+smE9Z6CYn0yeShqdBfv2eYDny9Cg0fKGfr1tk3fVQDESy7auEnAjM0fBvE6rW1/5wJ7RL0AC3R0QMSftWPpT2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764664384; c=relaxed/simple;
	bh=p1q7PceV/GmXODPjf71ea9to1NNrQG2Sz2Fr+UAEGKI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KOrhS73xptaI58Fa0Af1/9eRFiW0Ek16zstA8DoMYgVzCBIt1OE23zh1loscT7CyERBNkwT2S9EJX2LpsklfnglqFzOmMj7dWiMyFZUlksNZNs3TXsoT4sAEH6iZaaSVQUb7QqUcUye6oULH4p/+5gfnAnUjo3RzVQ4quGJKE/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=APwK07sW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764664381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+nyeIgdjao7kmFECITLfLNQv0kuOpWPLNI5c0Bl9fQ=;
	b=APwK07sWwnTcq9IRMCjMe96LdiLlQfBgbfZzJZdgbZzMW4JQUrR1hxXQcjg/jJ9El1S8gL
	+Y3mGrSyPEoh/+yxViSduR3Z+W5eldE+4GntZhTal1FxcodeufPOmJVcOXzG94mKa0txPV
	6eD9HZf4XK4Twi+cqvF8pg0ldDT4whA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-Fuj5WPnsNf69QYD5NAGJ2A-1; Tue,
 02 Dec 2025 03:33:00 -0500
X-MC-Unique: Fuj5WPnsNf69QYD5NAGJ2A-1
X-Mimecast-MFC-AGG-ID: Fuj5WPnsNf69QYD5NAGJ2A_1764664379
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50E4A1800451;
	Tue,  2 Dec 2025 08:32:59 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D50201800361;
	Tue,  2 Dec 2025 08:32:58 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8C4E421E6A27; Tue, 02 Dec 2025 09:32:56 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: pbonzini@redhat.com,  kvm@vger.kernel.org,  eesposit@redhat.com,
  philmd@linaro.org
Subject: Re: [PATCH v2] kvm: Fix kvm_vm_ioctl() and kvm_device_ioctl()
 return value
In-Reply-To: <20251128152050.3417834-1-armbru@redhat.com> (Markus Armbruster's
	message of "Fri, 28 Nov 2025 16:20:50 +0100")
References: <20251128152050.3417834-1-armbru@redhat.com>
Date: Tue, 02 Dec 2025 09:32:56 +0100
Message-ID: <871pldxozr.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Markus Armbruster <armbru@redhat.com> writes:

> These functions wrap ioctl().  When ioctl() fails, it sets @errno.
> The wrappers then return that @errno negated.
>
> Except they call accel_ioctl_end() between calling ioctl() and reading
> @errno.  accel_ioctl_end() can clobber @errno, e.g. when a futex()
> system call fails.  Seems unlikely, but it's a bug all the same.
>
> Fix by retrieving @errno before calling accel_ioctl_end().
>
> Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Queued for 10.2.


