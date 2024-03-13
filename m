Return-Path: <kvm+bounces-11720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B5087A424
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 09:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB23F283237
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 08:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736D51B59B;
	Wed, 13 Mar 2024 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5j4p96p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7D61A286
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 08:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710319112; cv=none; b=u6QNmcTI3HkDzUfclJRUxS3Bkk+MNhBZ+nxm2Dx5CrkCSq0gqg0tDoHPUxB9EAnUZkwLcNb2aumYsi1jc14e1DjK6usnZkoIA95n//fiZU6445Sn0WT8Aaf5ttd19+ZKzE51/TuvtWJp2oKdk4rZAIImSovLiWEePeqVTw7wBDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710319112; c=relaxed/simple;
	bh=PnOTieHCZlMmJbLEcfj7Iqz+Y9jzI/+xF58R5cFRyFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9T4nZ4S+L4lB/j1nSdOQ3c7iaPj4+2WkWe/epdnr2D2zW154YMQ+vTlmn5p7THYiooM1dS4gsyhLvt9lVPd1bO/MNQ5NFdMFE+GLmEXIT0x6UQWGERoqRy3GzB9IGQWAk0Eqv1z/AzUa6rI62BFQCHoYHhRVbGBnSekvjSaeAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a5j4p96p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710319110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mpack/J+7HrVXgcyiDIBRHYLXZMo3CgTAYK0qYafvtI=;
	b=a5j4p96pYMLOezM+y+ZdT2JUdRo7oOPmkj3CtdMW4QB8WSdz0A6mqG035Ptz7smqaki7JL
	Bhw+W5ozWzZ3hHpXMWfcWjURC2kWOxK6izge3XxKi34nG+Y/sRa5NiM6XDlQFFeKMiZHqu
	j0SCrfXxqdgZ02atyyVxYkbHX1tVHZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-_rhQDwNENAiFYF4EUFFgFg-1; Wed, 13 Mar 2024 04:38:26 -0400
X-MC-Unique: _rhQDwNENAiFYF4EUFFgFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B2E91018985;
	Wed, 13 Mar 2024 08:38:26 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7E013C22;
	Wed, 13 Mar 2024 08:38:25 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 7C1F718009A3; Wed, 13 Mar 2024 09:38:24 +0100 (CET)
Date: Wed, 13 Mar 2024 09:38:24 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] kvm/cpuid: set proper GuestPhysBits in
 CPUID.0x80000008
Message-ID: <pcxeiwgpu6gtxibfahadopifjkehgdcb2vfjovqrc5v6mogsuu@3kcetsllglen>
References: <20240311104118.284054-1-kraxel@redhat.com>
 <20240311104118.284054-3-kraxel@redhat.com>
 <ZfD8BrVOM9gaTudC@linux.bj.intel.com>
 <76a8a880-6c8f-4c4c-bd5d-da02206967ed@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76a8a880-6c8f-4c4c-bd5d-da02206967ed@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

  Hi,

> > > -		entry->eax = phys_as | (virt_as << 8);
> > > +		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
> > 
> > When g_phys_as==phys_as, I would suggest advertising g_phys_as==0,
> > otherwise application can easily know whether it is in a VM, I’m
> > concerned this could be abused by application.

There are *tons* of options to figure whenever you are running in a VM,
there is no need to go for this obscure way.

> IMO, this should be protected by userspace VMM, e.g., QEMU to set actual
> g_phys_as. On KVM side, KVM only reports the capability to userspace.

Yes, at the end of the day this is handled by qemu.

Current plan for qemu is to communicate it to the guest unconditionally
though.  When setting this only in case g_phys_as != phys_as the
firmware has the problem that it doesn't know the reason for finding
zero there.  Could be g_phys_as == phys_as, but could also be old kernel
/ qemu without GuestPhysBits support.  So the firmware doesn't know
whenever it is save to use phys_as.

take care,
  Gerd


