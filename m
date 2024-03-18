Return-Path: <kvm+bounces-11988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8355A87EC3F
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:33:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 045601F21160
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DCC535BA;
	Mon, 18 Mar 2024 15:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DYUZNb8v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5127535A7
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710776008; cv=none; b=WueEeLiJWn9pZ6sg3Dz9NFywh2oRgONosGHqwYwvzZHxhqCL5WAJWrArMgupmd7zw5ubCfLPgt1KmLLfxi83LIS2tRT+wBwaKR1ji3gFoa9JvL+AlC8yqpEmOkwEt9mb/N3VK/7JUD4NqhloPkgVgU1xeRaKsbKqFRtJLeP19bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710776008; c=relaxed/simple;
	bh=liw44utHmyz7dNEWDvm5LB2RjGq68apc2CJoej1mBVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYzpO4LunVJ5EMmdP4Vx0j6PQQMCbGlOaBFU1lHsF/7GwXCrPNBC10uInEfnLmlNe00y3R/4QucRbvNkObBjyOmRBvjLK1w4s1KxAAXfqoGjpAE1kKt2idol1diQ94FvbvjWCn+gFKC0Xx1WzrnwrIjB6GB6VmCHASDJZlkZxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DYUZNb8v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710776005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KsI4Pzf50r0MDSAv9j7JPbTKGXoz1E85vG4CVi2Biac=;
	b=DYUZNb8vkomZzbQDdBDYynDIO+ZMic6DajbiquNB79D/aKQmPNb99c+haxtod+tdWfr70N
	Y1FarfbZ6lH2aPH2hDvIiTCV85M6k4bjQT+pzxluv9N9Bz7tCZKl5rCnbK4g2haH9gm+I2
	7kmra4flAqj9ZOnVfuMwSnLldrmpG/g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-Q2ynixZ6P2iW5Q8ciu021w-1; Mon, 18 Mar 2024 11:33:21 -0400
X-MC-Unique: Q2ynixZ6P2iW5Q8ciu021w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C809185A783;
	Mon, 18 Mar 2024 15:33:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.254])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4702D2166B32;
	Mon, 18 Mar 2024 15:33:21 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 1415B1800D54; Mon, 18 Mar 2024 16:33:16 +0100 (CET)
Date: Mon, 18 Mar 2024 16:33:15 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kvm: add support for guest physical bits
Message-ID: <v5jxmmricgtbixe333aq5i3pso6umjbasbzb5degytupld3js3@eeiqmnnum3mh>
References: <20240313132719.939417-1-kraxel@redhat.com>
 <20240313132719.939417-3-kraxel@redhat.com>
 <Zfap1cqJngPblW+x@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfap1cqJngPblW+x@linux.bj.intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

  Hi,

> > +    if (cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
> > +        cpu->guest_phys_bits = cpu->host_phys_bits_limit;
> 
> host_phys_bits_limit is zero by default, so I think it is better to be
> like:
> 
>         if (cpu->host_phys_bits_limit &&
>             cpu->guest_phys_bits > cpu->host_phys_bits_limit) {
>             cpu->guest_phys_bits = cpu->host_phys_bits_limit;
>         }

Good point, fixed.

thanks,
  Gerd


