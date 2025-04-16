Return-Path: <kvm+bounces-43470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D414A9056E
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BD3D8E2552
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F213B1E7648;
	Wed, 16 Apr 2025 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bcgo9WF6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0439B1B4F0A;
	Wed, 16 Apr 2025 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811386; cv=none; b=QzR4P3vNQiJg9TZzJBPWcE5ngEdhjqaJu6TXfHGb5RH6T+qRYysSLJ7n9K20hJgfyu4bgo0mcED30SiPL5ilKh7yleq4TXXQYeGlu0cB2Pr0nRUkCO0wMgkDXgn7HindJ8RKCpq010yo9pUx2958olMmlsRnsh66l5gv51JiVT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811386; c=relaxed/simple;
	bh=xb9cHSMgz452v6jUacbzXuhAOkHSudLeBfbZcSsjoyM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A/px5AIS3mT0I0+x20YwDULWstfbkyxx9AZblJaSFYt4vFyu6X3W0VUGJtrA03CeZJu424ZLftMNz4vARvt5jLCl0AYFs+cTrHmYMqgJa/RGD6WgrCeBrYfLmBfx0aD4Yys/Lv/oxU03dEhaTMKcTu0H+9bCMmxMetACOnAUghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bcgo9WF6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D900C4CEE4;
	Wed, 16 Apr 2025 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744811384;
	bh=xb9cHSMgz452v6jUacbzXuhAOkHSudLeBfbZcSsjoyM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Bcgo9WF6CB9OHkZSKqG29+QE5W/fGLqEx5IISKhlRpWKf8Oi89rN5ss99qS9sV9aX
	 7C4Hge3Lj4tmQNfjntvtT6N9U8rOGICuI+OoUoTZO9fz1J9VyXBcsOFS0v29VxnWoG
	 oX6fhB9LoBKAQp4JeD2Qxf9CDtW6wjPwOazGrZVwNfjQsdW3KPKEcmL2UBXvVzQfqZ
	 Vj/oxLvZ/yq14gwpu280bSdLcpREczYS0iPN98VDJ9LzXzYhmc3b3txARKdJLoqguM
	 GBBANjQoUWtUv1KyaSVQZqP/3e6gHwkdNZKLwrMViON7X18Jpm8ZmusxbMhG3JCdPc
	 eYaZf2SpeMLcg==
Message-ID: <4913ceb31b31feeec906636a1a64d46ea6c6e94e.camel@kernel.org>
Subject: Re: [PATCH 1/1] virtio_console: fix missing byte order handling for
 cols and rows
From: Amit Shah <amit@kernel.org>
To: Halil Pasic <pasic@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, 	kvm@vger.kernel.org, "Michael S. Tsirkin"
 <mst@redhat.com>
Cc: stable@vger.kernel.org, Maximilian Immanuel Brandtner
 <maxbr@linux.ibm.com>
Date: Wed, 16 Apr 2025 15:49:40 +0200
In-Reply-To: <20250322002954.3129282-1-pasic@linux.ibm.com>
References: <20250322002954.3129282-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2025-03-22 at 01:29 +0100, Halil Pasic wrote:
> As per virtio spec the fields cols and rows are specified as little
> endian. Although there is no legacy interface requirement that would
> state that cols and rows need to be handled as native endian when
> legacy
> interface is used, unlike for the fields of the adjacent struct
> virtio_console_control, I decided to err on the side of caution based
> on some non-conclusive virtio spec repo archaeology and opt for using
> virtio16_to_cpu() much like for virtio_console_control.event.
> Strictly
> by the letter of the spec virtio_le_to_cpu() would have been
> sufficient.
> But when the legacy interface is not used, it boils down to the same.
>=20
> And when using the legacy interface, the device formatting these as
> little endian when the guest is big endian would surprise me more
> than
> it using guest native byte order (which would make it compatible with
> the current implementation). Nevertheless somebody trying to
> implement
> the spec following it to the letter could end up forcing little
> endian
> byte order when the legacy interface is in use. So IMHO this
> ultimately
> needs a judgement call by the maintainers.

The patch looks fine to me, but can you reword this message to say what
you chose and why (and not have the bit about judgment call by
maintainers in there)?  If it sounds right, it'll be acked and merged.
If not, we'll work to ensure it's all good -- so the judgment calls
happen on the list, rather than mentioning this way in the commit.

Thanks,

		Amit


