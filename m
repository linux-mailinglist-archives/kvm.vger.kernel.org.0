Return-Path: <kvm+bounces-11989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 302E087EC9B
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D313A281E54
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 15:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7528C52F87;
	Mon, 18 Mar 2024 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jBviVq0N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FE4F61C
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710777055; cv=none; b=O9eEHokkgAGaah0Wia0AcWgPGEkVRfCWc+F8TyUXQ0f4cPLtwpf+sVE21JN7dMkYvC7sgOB+XaGBxf3Y6JmuaAKnthFtKaDF4h51p45IEnuSNPDzxDH8OI3KyeLo+S70iXDXc1K5BtWPSKnUa5gc7G/DKdm+Ewr2PcJADoR0Xkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710777055; c=relaxed/simple;
	bh=8ixUtHXm69FhgHKSHPpvBbR1JF6jbeobll57s24+BQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBW8+Lkwqr1CjYMTHDXow35UNlsmNCfr6jUeMTTLW5xAyvXmJhdDImdanTv/fnoCyZhVXOBlPrSRZJeEnRcfNVtUILfZtb4D10/ZWVJ44imhAQ1t99o52/jhwMQzNmfAVnogI5IPds1iZcWX3D6mpOgsmoSMtLLI0bAcHPvbIKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jBviVq0N; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710777052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D4t+F05LcxYJzY/SOfIFEjyZxI8u4VlmTFQBBGEo4gk=;
	b=jBviVq0NrcpU7a8EF6nrx1ELT+X8QNrlSnlSGibCHE69Xa2kCXxWeLHwzwq1i7jRiM36Jd
	lpX/WqPARNDFQChQD5+5yZfzZkeDBLHG4OTqTovNf6Y5Z0RM64RD/K1rlqNyGA8goxbGjq
	v9StmXx7yWnhG5iEayXG41RYkyLtceg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-J1JeeIUEPz-bz4zAQmtI8Q-1; Mon, 18 Mar 2024 11:50:45 -0400
X-MC-Unique: J1JeeIUEPz-bz4zAQmtI8Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA81B822487;
	Mon, 18 Mar 2024 15:50:44 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.254])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA7ECC04222;
	Mon, 18 Mar 2024 15:50:44 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id A56FC1800D54; Mon, 18 Mar 2024 16:50:39 +0100 (CET)
Date: Mon, 18 Mar 2024 16:50:39 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] kvm: add support for guest physical bits
Message-ID: <u6gdfu6qabzmfh6fa4llhmntjq6bq666tlg64r7gxrgsuldwyy@ei7byjx7t3v5>
References: <20240313132719.939417-1-kraxel@redhat.com>
 <20240313132719.939417-3-kraxel@redhat.com>
 <4cbf6d9c-3916-4436-abfe-10b35734b67a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cbf6d9c-3916-4436-abfe-10b35734b67a@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

  Hi,

> > diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
> > index 9c791b7b0520..a2b7bfaeadf8 100644
> > --- a/target/i386/kvm/kvm-cpu.c
> > +++ b/target/i386/kvm/kvm-cpu.c
> > @@ -18,10 +18,36 @@
> >   #include "kvm_i386.h"
> >   #include "hw/core/accel-cpu.h"
> > +static void kvm_set_guest_phys_bits(CPUState *cs)
> > +{
> > +    X86CPU *cpu = X86_CPU(cs);
> > +    uint32_t eax, guest_phys_bits;
> > +
> > +    if (!cpu->host_phys_bits) {
> > +        return;
> > +    }
> 
> This needs explanation of why. What if users set the phys-bits to exactly
> host's value, via "-cpu xxx,phys-bits=host's value"?

If host_phys_bits is not enabled it is possible to set phys-bits to any
value today (including invalid values not supported by the host).  With
this the same applies to guest_phys_bits.

My intention was to continue allowing any guest_phys_bits + phys_bits
with TCG, for testing purposes.  But thinking again this logic is
flawed, if TCG is used the control flow doesn't land here in the first
place.

So, I think this can be dropped.

> > +    ret = host_cpu_realizefn(cs, errp);
> 
> We need to check ret and return if !ret;

Fixed.

thanks,
  Gerd


