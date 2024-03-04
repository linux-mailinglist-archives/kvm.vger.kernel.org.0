Return-Path: <kvm+bounces-10799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50BD18700BC
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 12:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC8D6B24557
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 11:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B723D0BC;
	Mon,  4 Mar 2024 11:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XrQvNCKQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA53C470
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 11:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709552853; cv=none; b=pLHAozHvXAUhQoZ9fm8BGpmGcmbj49MsRGqJ2PWv1yDIYqw5U/2luHWhQeeko88+5L2GfLPxJXiHHkIXIMSXU0iT+7ntQ5VuFVYFxwnBJMdCAqs+QgWWU3iis0Jmt8lSRUdVCCeXutIDqQhIfdnnXUfgfsU695NqGTXRijCc3bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709552853; c=relaxed/simple;
	bh=/seq8s9s5SaI2WG5otaQLdzF6dmyrocZTuz5aj2Hfv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do/WqcoZJ96Jh1Zm6cbByRE55YTka/yRxOqtglH7eoSbyVjnWsS3GeH8eHKdFf2YlJCDGvggIMAP9up5O1bHuRGOfiMmtsWC42yP6TRFSDnMlDpwmcM/uR1ou74AdU2SVsR1zT6h5cxB0t/593aYMyJdIinJSeFEpkPwNg7GXok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XrQvNCKQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709552850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8u3ZKUE4itA3oS5HviRsE+wBXJKRiMcfZN7VwqDsuPY=;
	b=XrQvNCKQseAA9PuRTRsDcaLsof8O7ANQy86NHvjTeNb+itTmDOtyRpUodfb6gttBJ1NMBL
	K6cPdAZ08eyp9XaeL9NPWgDT7MDU30SkbiNunnnycXGBuNbXHHhgFPiMlltaQbcgOAHAne
	b29lksy7o4zsPDsuE9W6uUwvqktjVxk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-6WsMwRiiNMqoARjO8uQNXQ-1; Mon,
 04 Mar 2024 06:47:24 -0500
X-MC-Unique: 6WsMwRiiNMqoARjO8uQNXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1F2B2812941;
	Mon,  4 Mar 2024 11:47:23 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EC23C03489;
	Mon,  4 Mar 2024 11:47:23 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 19CCC18009DB; Mon,  4 Mar 2024 12:47:22 +0100 (CET)
Date: Mon, 4 Mar 2024 12:47:22 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] kvm: wire up KVM_CAP_VM_GPA_BITS for x86
Message-ID: <qj2i4kplogjz3yppzyifacqv5qges3ijb6wuhoms4vazus7b33@5dmwvfq2vxmj>
References: <20240301101410.356007-1-kraxel@redhat.com>
 <20240301101410.356007-2-kraxel@redhat.com>
 <ZeH+pPO7hhgDNujs@linux.bj.intel.com>
 <vlr6f5dnyhb6aw5si6m4vxqemwoyg7lrti7pdy4jzatady5mgr@bv44qwgk6ppu>
 <ZeWNdBSWVTAwtLyI@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeWNdBSWVTAwtLyI@linux.bj.intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Mon, Mar 04, 2024 at 04:59:32PM +0800, Tao Su wrote:
> On Mon, Mar 04, 2024 at 09:43:53AM +0100, Gerd Hoffmann wrote:
> > > > +	kvm_caps.guest_phys_bits = boot_cpu_data.x86_phys_bits;
> > > 
> > > When KeyID_bits is non-zero, MAXPHYADDR != boot_cpu_data.x86_phys_bits
> > > here, you can check in detect_tme().
> > 
> > from detect_tme():
> > 
> >         /*
> >          * KeyID bits effectively lower the number of physical address
> >          * bits.  Update cpuinfo_x86::x86_phys_bits accordingly.
> >          */
> >         c->x86_phys_bits -= keyid_bits;
> > 
> > This looks like x86_phys_bits gets adjusted if needed.
> 
> If TDP is enabled and supports 5-level, we want kvm_caps.guest_phys_bits=52,
> but c->x86_phys_bits!=52 here.

Do you talk about EPT or NPT or both?

> Maybe we need to set kvm_caps.guest_phys_bits
> according to whether TDP is enabled or not, like leaf 0x80000008 in
> __do_cpuid_func().

See patches 2+3 of this series.

Maybe it is better to just not set kvm_caps.guest_phys_bits in generic
kvm code and leave that completely to vmx / svm vendor modules.  Or let
the generic code handle the !tdp_enabled case and have the vendor
modules override (considering EPT / NPT limitations) in case tdp is
enabled.

take care,
  Gerd


