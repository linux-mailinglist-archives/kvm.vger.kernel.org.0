Return-Path: <kvm+bounces-12488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E64886C5E
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 13:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC94E1C203AC
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 12:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B60446AB;
	Fri, 22 Mar 2024 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBl4XBYV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D501EB31
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711111854; cv=none; b=YkyRw74FhnymLSEi9BLlAyq/L38MMeUpZMhILLD5dRSb5XkGWOpZSxAhvCZViBweH/MQzgVDkheRAVKPT3cAqVWe+7eRw7hE4AxPoPTIQRHtZqoS8DqWt0ncAWJ5BYE8aJpl2Tfj9xzOCrzeVc64/qwR++HKom8kHg0C1id7uA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711111854; c=relaxed/simple;
	bh=Q19NQOoDXUvjifrZfiyR2kvYp5xoVi4EAehQ5W7003Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBXfAlNECr7DyPnyQ99phlRiBrl5mszFVuSVeJiw2m+e0d/w+Zu7PwJYXHLWmDUMLQoj9j5CQHxqvKOHZkTgjyZYnfg3Z5OsJ+G8VvszvoQjqybY2fB6cJRFwJBYKf+Dtdp7454qXqiTxiBo/DgqQXOmnp7xCIVrYnFMrzsEkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LBl4XBYV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711111851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WooMsR1THrWNs3sSPXkMGo7sE9cVLAC8nCveF1oP/UU=;
	b=LBl4XBYV+PP7IrTQtBAHhpqUsdbg9n+GmgMwUnaM0nm8CqXBJapDv3Ew9nBytD53+Y0aBy
	s1336LrLiaie4UK5qpnlgNTg3ebu2Gc0/sMKhTg+Z91S4YBBrvqNPjLIX659cArf/pzUZK
	tHmXJ7TtN7skJGsiil9jmzmaOptcmO8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-BXuJwiB0NCOlqhzb0oaKrw-1; Fri, 22 Mar 2024 08:50:50 -0400
X-MC-Unique: BXuJwiB0NCOlqhzb0oaKrw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCC8A800265;
	Fri, 22 Mar 2024 12:50:49 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.134])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B690C2022C1D;
	Fri, 22 Mar 2024 12:50:49 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 8756518014AE; Fri, 22 Mar 2024 13:50:44 +0100 (CET)
Date: Fri, 22 Mar 2024 13:50:44 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 1/2] kvm: add support for guest physical bits
Message-ID: <6gxghpqxu3756dddw7eia7hkmr4ufwhdm4pdun2iukq7fv2q4w@mt3u5ijgmhyx>
References: <20240318155336.156197-1-kraxel@redhat.com>
 <20240318155336.156197-2-kraxel@redhat.com>
 <54e8b518-2bea-4a5b-a75a-4fd45535c6fa@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e8b518-2bea-4a5b-a75a-4fd45535c6fa@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

> > +    if (cpu->host_phys_bits_limit &&
> > +        cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
> > +        cpu->guest_phys_bits = cpu->host_phys_bits_limit;
> 
> host_phys_bits_limit takes effect only when cpu->host_phys_bits is set.
> 
> If users pass configuration like "-cpu
> qemu64,phys-bits=52,host-phys-bits-limit=45", the cpu->guest_phys_bits will
> be set to 45. I think this is not what we want, though the usage seems
> insane.
> 
> We can guard it as
> 
>  if (cpu->host_phys_bits && cpu->host_phys_bits_limit &&
>      cpu->guest_phys_bits > cpu->host_phys_bits_limt)
> {
> }

Yes, makes sense.

> Simpler, we can guard with cpu->phys_bits like below, because
> cpu->host_phys_bits_limit is used to guard cpu->phys_bits in
> host_cpu_realizefn()
> 
>  if (cpu->guest_phys_bits > cpu->phys_bits) {
> 	cpu->guest_phys_bits = cpu->phys_bits;
> }

I think I prefer the first version.  The logic is already difficult
enough to follow because it is spread across a bunch of files due to
the different cases we have to handle (tcg, kvm-with-host_phys_bits,
kvm-without-host_phys_bits).

It's not in any way performance-critical, so I happily trade some extra
checks for code which is easier to read.

take care,
  Gerd


