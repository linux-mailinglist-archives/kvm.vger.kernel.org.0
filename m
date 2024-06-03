Return-Path: <kvm+bounces-18647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0478D823C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 536D0283FD1
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341BC12BF23;
	Mon,  3 Jun 2024 12:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i/M5sWiB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF57F12BF1C
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417755; cv=none; b=KnDvj5/gUGobwPM51pX/CDCO0KdOdcUAFt+uO048tuGazjeaM13sRZ69s1vSGVzeOIn/9p1m/ymRrJdCuFbFuu+vw6WYDvxUJ5rBMdA0S1U9f/IfW0rwJKKiFZH8WdQSH7dRI30Rm/wDnTOuE1BxlXABmQGYldUNFDNux8kIrrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417755; c=relaxed/simple;
	bh=O6+JynnAXqlFRKh7pz2yi+fxxN6nuw2CwMl047Zf/S8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FaCIuN3Bb4DdCU5lzqYgtzvr8foEzcIb9BJp0AUbGMNxIamZjYRzGN5QHxpLIK2OTvWf1qiomikGkl/US24uF+i5neq9nynQR1BXkHK0pNGSAoKNrDHHvif4SwAHVmUmMDMWHao4TGhm0gmOxwgw5Fhp8oRYmJpq+HJweBh6uro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i/M5sWiB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717417752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NEp1b7+yXvj4sMU+gABKlSkGj8k2gCBF8kxLkzopYec=;
	b=i/M5sWiB44mnUiJdRVcIn5Oh+HOL+zQKQq4OnZpu+GsM+m4jTdNyOqpk3/t3U5slZrD54s
	w3nuAYqqCyg0CxAz5b/wYGvkyKdLaVMVmuxl9pbrC8EYr+xuE0kG+22AX3YaO546aBA1nQ
	aC03i5Qdonb7DdJoMRuu/Ot7Yw/hetY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-WZDoDWsxO2KG0_JIpu-jhQ-1; Mon,
 03 Jun 2024 08:29:07 -0400
X-MC-Unique: WZDoDWsxO2KG0_JIpu-jhQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB2323806707;
	Mon,  3 Jun 2024 12:29:06 +0000 (UTC)
Received: from localhost (unknown [10.39.194.201])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30BA4C15C03;
	Mon,  3 Jun 2024 12:29:06 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, pbonzini@redhat.com,
 npiggin@gmail.com, kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org
Subject: Re: [PATCH 0/2] ppc: spapr: Nested kvm guest migration fixes
In-Reply-To: <171741555734.11675.17428208097186191736.stgit@c0c876608f2d>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <171741555734.11675.17428208097186191736.stgit@c0c876608f2d>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 03 Jun 2024 14:29:04 +0200
Message-ID: <877cf6mcq7.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Mon, Jun 03 2024, Shivaprasad G Bhat <sbhat@linux.ibm.com> wrote:

> The series fixes the issues exposed by the kvm-unit-tests[1]
> sprs-migration test.
>
> The sprs DEXCR and HASKKEYR are not registered with one-reg IDs
> without which the Qemu is not setting them to their 'previous'
> value during guest migreation at destination.
>
> The two patches in the series take care of this. Also, the PPC
> kvm header changes are selectively picked for the required
> definitions posted here at [2].
>
> References:
> [1]: https://github.com/kvm-unit-tests/kvm-unit-tests
> [2]: https://lore.kernel.org/kvm/171741323521.6631.11242552089199677395.stgit@linux.ibm.com
>
> ---
>
> Shivaprasad G Bhat (2):
>       target/ppc/cpu_init: Synchronize DEXCR with KVM for migration
>       target/ppc/cpu_init: Synchronize HASHKEYR with KVM for migration
>
>
>  linux-headers/asm-powerpc/kvm.h | 2 ++

Please split out any changes under linux-headers/ into a separate patch;
those files need to be changed via a full header update against a
released kernel version. If the changes are not yet upstream in the
Linux kernel, please put in a clearly marked placeholder patch in the
meanwhile.


>  target/ppc/cpu_init.c           | 8 ++++----
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> --
> Signature


