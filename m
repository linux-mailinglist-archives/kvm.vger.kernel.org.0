Return-Path: <kvm+bounces-11719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 835DB87A3FE
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 388741F21777
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 08:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6013B1A58B;
	Wed, 13 Mar 2024 08:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+UGWFVy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080B7171A6
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710317744; cv=none; b=NmEPla5P6dS/Y+rbBXGsMg52tQXYQGi+ResbxH1jvXNBQktWocfVuHwXmK0/m3787S95D/UK/EIfVDsymX2YQ9IU549nn2KleSzKdsJbG1dnwiBBRPL//WO6nhyRsGTFPT/d348mKlBpz9NErtZROlVnzfGbCP/7i4cdel0xHP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710317744; c=relaxed/simple;
	bh=Zx1CyQHR23uLiD8KR9ESU7nfqDKd6a4BX+GF2n2acJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwtZIGi+LtjIOFQe2WzXveFczeHupKCzEGf+Wpt6FPFTDjZZTutCB2YuJ0MOEST63QvoYs2XVba8jBb6y3bPqTtkZx5fCRGEJxVsTs0sd/oFL+3qT9+prxBJhmmTAv4acYl0hA6cvIqZGUm0H364MuvFgpGmdg1EsgGzGPiFpZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+UGWFVy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710317742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4iiF09AQqMKK+vz1K8fXrb5ZKZyEsbQmkRPwfWXefcA=;
	b=Y+UGWFVyB1IPkXRTbQwt13FdGv0jZj+ygDGA997Hr3mQ9OBfe8gEzqWj3ei7/oVyLs9rUH
	6NfTgmCT5rVMUOztp08ArfFMqN75ZzyhY5PJKS2ynFfi55FXOurXP59WqYyIxl5uvcI/zc
	J31va3qez9+zwBFv6JNS7Gx62d6r4Zw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-8uImgTX4Omuj2Ikv2gNyVA-1; Wed, 13 Mar 2024 04:15:40 -0400
X-MC-Unique: 8uImgTX4Omuj2Ikv2gNyVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C5B688F522;
	Wed, 13 Mar 2024 08:15:40 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E82C31C060D0;
	Wed, 13 Mar 2024 08:15:39 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id ADEB318009A3; Wed, 13 Mar 2024 09:15:38 +0100 (CET)
Date: Wed, 13 Mar 2024 09:15:38 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] kvm: add support for guest physical bits
Message-ID: <bu2rau6gpkgbm3uagostv6fxye53nd3qx7fhdxcr5mwwvd7yln@4nesoydyg7dt>
References: <20240305105233.617131-1-kraxel@redhat.com>
 <20240305105233.617131-3-kraxel@redhat.com>
 <ZfFKJPYoE5bacb6+@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfFKJPYoE5bacb6+@linux.bj.intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Wed, Mar 13, 2024 at 02:39:32PM +0800, Tao Su wrote:
> On Tue, Mar 05, 2024 at 11:52:33AM +0100, Gerd Hoffmann wrote:
> > Query kvm for supported guest physical address bits, in cpuid
> > function 80000008, eax[23:16].  Usually this is identical to host
> > physical address bits.  With NPT or EPT being used this might be
> > restricted to 48 (max 4-level paging address space size) even if
> > the host cpu supports more physical address bits.
> > 
> > When set pass this to the guest, using cpuid too.  Guest firmware
> > can use this to figure how big the usable guest physical address
> > space is, so PCI bar mapping are actually reachable.
> 
> If this patch is applied, do you have plans to implement it in
> OVMF/Seabios?

Yes.  ovmf test patches:

https://github.com/kraxel/edk2/commits/devel/guest-phys-bits/

take care,
  Gerd


