Return-Path: <kvm+bounces-11535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2899B877F61
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AB5F1C218A3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10FC23BB36;
	Mon, 11 Mar 2024 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZ3+7taG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B362C69A
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 11:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710158387; cv=none; b=hmj8CN/LoOHGyDzz70JQQCMA9S8CVuT3sEZBUAXIzaBHgyApBPtjMF7bhAl6sWoLSxKUZ87ZXSlZInNvaSDEDiWo04yPvK9tb+uRQGh6GV71BcGRg1JVkFVLdDPtr26jyJ1JAg/g23f/73NAQ0m4V8TP5PI7ON/2wo5FqrBK4yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710158387; c=relaxed/simple;
	bh=22id+7Sn4vYwNc4GCqkGYRy+xTHYzXGBDfO0D11nENM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRgl1Wx1/oQiBcI8ZB8Lf2jKoHILnzAyC240ElZ0FlLRHgs2hQk6R5AtAU5kFi5LSGb86PHPTmNB2ogEroGlQSgcRmzxP6aVu2+qnJSRP51bnWD0Og458qxn19CGOvbTEq9RbHMEsMw3/AZdukR826sEIDR6qVPMvOA9mUyoTdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZ3+7taG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710158384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uRyEkCKNkPVnOj3uensDQWTBZOHL7iOI9MqexSDkxoM=;
	b=RZ3+7taG1T+xhRyHZyIu+wT1AnwrPRUpGlMw4BDFAm7rA/59XeSNiHqdB2zBZmEiR+/CIQ
	ICmm80We5dYe3e0LQA43w2yzw2/3YsOCLCIxziFZKSPMb1rBNzMXmv+NTk7xdeYUV6Mujj
	jTVNCpHPqr+ShwPogUwCQTSI0o9sNbk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-pzQ_R8s9N2264nbHyKsxiA-1; Mon,
 11 Mar 2024 07:59:30 -0400
X-MC-Unique: pzQ_R8s9N2264nbHyKsxiA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E97BE1C04330;
	Mon, 11 Mar 2024 11:59:29 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C60DB492BC4;
	Mon, 11 Mar 2024 11:59:29 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 8FBC91801A82; Mon, 11 Mar 2024 12:59:28 +0100 (CET)
Date: Mon, 11 Mar 2024 12:59:28 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kvm: add support for guest physical bits
Message-ID: <q6zckxcxwke2kdlootdq3s7m2ctcy7juuv3fsezhpw3nqyewxo@sqku62f25gdc>
References: <20240305105233.617131-1-kraxel@redhat.com>
 <20240305105233.617131-3-kraxel@redhat.com>
 <CABgObfZ13WEHaGNzjy0GVE2EAZ=MHOSNHS_1iTOuBduOt5q_3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZ13WEHaGNzjy0GVE2EAZ=MHOSNHS_1iTOuBduOt5q_3g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

  Hi,

> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index 952174bb6f52..d427218827f6 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > +    guest_phys_bits = kvm_get_guest_phys_bits(cs->kvm_state);
> > +    if (guest_phys_bits &&
> > +        (cpu->guest_phys_bits == 0 ||
> > +         cpu->guest_phys_bits > guest_phys_bits)) {
> > +        cpu->guest_phys_bits = guest_phys_bits;
> > +    }
> 
> Like Xiaoyao mentioned, the right place for this is kvm_cpu_realizefn,
> after host_cpu_realizefn returns. It should also be conditional on
> cpu->host_phys_bits.

Ok.

> It also makes sense to:
> 
> - make kvm_get_guest_phys_bits() return bits 7:0 if bits 23:16 are zero
> 
> - here, set cpu->guest_phys_bits only if it is not equal to
> cpu->phys_bits (this undoes the previous suggestion, but I think it's
> cleaner)

Not sure about that.

I think it would be good to have a backward compatibility story.
Currently neither the kernel nor qemu set guest_phys_bits.  So if the
firmware finds guest_phys_bits == 0 it does not know whenever ...

  (a) kernel or qemu being too old, or
  (b) no restrictions apply, it is safe to go with phys_bits.

One easy option would be to always let qemu pass through guest_phys_bits
from the kernel, even in case it is equal to phys_bits.

> - add a property in x86_cpu_properties[] to allow configuration with TCG.

Was thinking about configuration too.  Not sure it is a good idea to
add yet another phys-bits config option to the mix of options we already
have ...

In case host_phys_bits=true qemu could simply use
min(kernel guest-phys-bits,host-phys-bits-limit)

For the host_phys_bits=false case it would probably be best to just
not set guest_phys_bits.

take care,
  Gerd


