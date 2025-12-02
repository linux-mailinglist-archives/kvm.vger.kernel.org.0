Return-Path: <kvm+bounces-65112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C969EC9BA3C
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 14:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 40FF94E3531
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 13:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8CB315D27;
	Tue,  2 Dec 2025 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUFg599T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0612BE020
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764682958; cv=none; b=Ih2S+PQQgjJKQOXDaliqYcQmpAKCIzwrieZdvPkE1esoCatlR7Q38i+PW7hxPrJLS0z1GIj9Dtgp+TvvI9wkdiXRtj7tIXwdsMxtDqYMDx8MWSw4XzToPGIZrVGkQCF/t0cECCO5+jnpqmmFtcNXFFAoXj4U4FztNwBbn5JJv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764682958; c=relaxed/simple;
	bh=9lcmb+WsEAUHsi7py9Vhr4ds7fe6Uj9/26ejxJ8nxdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LnovryJpwVEOuCY6IISQQS1f8JYpRFGtje3byQighAAUeirLQggel0UHxFsLYz36y+nLWc4FFDFnRe8knwdZaJRhSL/c/n0Zb6vGAWOT/5bmJjQxIp7/BGyVf1oJbXiL8kkvcyajbO0L7bi2F5QNCn0IqzzpMfMW9NOJz9QRf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DUFg599T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764682955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LN3ZRhlR55DAhXGZZfrNPYhGZ9yXyiDQHCZwNpQSxaQ=;
	b=DUFg599ThPAaKBN7y807Idjp5QhaTfpw0yDk55p8pjpRqod3SnWGZPTSNGOlC+ub7fxNrC
	uyYTznBeRzLPYU83z42teJzYinOfsbA5RikhscWUnuGCdTr9fvHQywWmnccwcAWPLsL4yr
	EFjvEFDwkHL2/HuKIOk/YLed8KMDKkU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-V1al1FhNMyeFRg-VXnlFSw-1; Tue,
 02 Dec 2025 08:42:32 -0500
X-MC-Unique: V1al1FhNMyeFRg-VXnlFSw-1
X-Mimecast-MFC-AGG-ID: V1al1FhNMyeFRg-VXnlFSw_1764682951
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 828C71956080;
	Tue,  2 Dec 2025 13:42:30 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3732C180047F;
	Tue,  2 Dec 2025 13:42:29 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 89B4221E6A27; Tue, 02 Dec 2025 14:42:26 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: qemu-devel@nongnu.org,  pbonzini@redhat.com,  kvm@vger.kernel.org,
  eesposit@redhat.com,  philmd@linaro.org,  qemu-stable
 <qemu-stable@nongnu.org>
Subject: Re: [PATCH v2] kvm: Fix kvm_vm_ioctl() and kvm_device_ioctl()
 return value
In-Reply-To: <db4b64b3-d40e-456f-b76a-bf8228e91946@tls.msk.ru> (Michael
	Tokarev's message of "Tue, 2 Dec 2025 16:14:56 +0300")
References: <20251128152050.3417834-1-armbru@redhat.com>
	<db4b64b3-d40e-456f-b76a-bf8228e91946@tls.msk.ru>
Date: Tue, 02 Dec 2025 14:42:26 +0100
Message-ID: <871pldt2yl.fsf@pond.sub.org>
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

Michael Tokarev <mjt@tls.msk.ru> writes:

> On 11/28/25 18:20, Markus Armbruster wrote:
>> These functions wrap ioctl().  When ioctl() fails, it sets @errno.
>> The wrappers then return that @errno negated.
>>
>> Except they call accel_ioctl_end() between calling ioctl() and reading
>> @errno.  accel_ioctl_end() can clobber @errno, e.g. when a futex()
>> system call fails.  Seems unlikely, but it's a bug all the same.
>>
>> Fix by retrieving @errno before calling accel_ioctl_end().
>>
>> Fixes: a27dd2de68f3 (KVM: keep track of running ioctls)
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>
> Isn't this a qemu-stable material?

I think it is.  I should've thought of adding Cc: qemu-stable.  My
apologies!


