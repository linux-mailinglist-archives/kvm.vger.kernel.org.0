Return-Path: <kvm+bounces-17153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F0B8C1F84
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 10:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC09D1C21608
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 08:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE5C15FCE9;
	Fri, 10 May 2024 08:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XK9EXyIf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF919131192
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 08:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328658; cv=none; b=OGgdKVqge3fl3ZntPYKr6Os5gZRcFM6PoUh0nhOl1ZeFJynZI5phfZnDc1WkF3LkbG26y9brVizuoY8YnKKQj1/LRljy910rr/Ia/pK9jRiyWqAAKowFvJdd3fvNm+6mYsps/yf8iASRgzBXwgUn6FNX5lAUZCNy3VLA2dMDJBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328658; c=relaxed/simple;
	bh=tpS+BNb5tjTqafAl5MAPW/BHoChucZG2RFdEbfQeSV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEwjJruTfQaDMkA4cTn5/idCyunBXTaXf+YW5jY49k8/KIqzTcR37bpKCC+vyzvkhZTo4afTM98aAoXvuzGmnI8xMx0HY/gUMQf1kYfBn0xxF1IVURrISuzh8yuwTu/k8C1/E7ele5GKZAhuYCosZyGlyADKUAI8YGY2iQVXx2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XK9EXyIf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715328655;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mCF8vDoIiZlV3N+xDd1DJ/pUXi+5dTBUBfsw74CyAzU=;
	b=XK9EXyIf10UqrL3NdHK0yw2jUl51H6A7ylk1E3NaH6X0yKOBsX+hj5ZTALZbcOtw8RxbpI
	yC2pi9qUKE3sVThbx121FAnEOUeGYvCWAkC012nd009tx83qv0GBuZdUSHxfb++y1Qhs2k
	mfKfnPDqj90bsWkISTsfncmPbcqzFkM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-q2jpGgdwOU2AhDjrw0_5Og-1; Fri,
 10 May 2024 04:10:52 -0400
X-MC-Unique: q2jpGgdwOU2AhDjrw0_5Og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA14D29AC02A;
	Fri, 10 May 2024 08:10:51 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.47])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C69A72079267;
	Fri, 10 May 2024 08:10:48 +0000 (UTC)
Date: Fri, 10 May 2024 09:10:46 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
	richard.henderson@linaro.org, weijiang.yang@intel.com,
	philmd@linaro.org, dwmw@amazon.co.uk, paul@xen.org,
	joao.m.martins@oracle.com, qemu-devel@nongnu.org,
	mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
	marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
	jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
	wei.huang2@amd.com, bdas@redhat.com, eduardo@habkost.net,
	qemu-stable <qemu-stable@nongnu.org>
Subject: Re: [PATCH v3] target/i386: Fix CPUID encoding of Fn8000001E_ECX
Message-ID: <Zj3WhjDW9YBW7LP8@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240102231738.46553-1-babu.moger@amd.com>
 <0ee4b0a8293188a53970a2b0e4f4ef713425055e.1714757834.git.babu.moger@amd.com>
 <89911cf2-7048-4571-a39a-8fa44d7efcda@tls.msk.ru>
 <ZjzZgmt-UMFsGjvZ@redhat.com>
 <efb17c5f-11f0-498d-b59d-e0dfab93b56d@tls.msk.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efb17c5f-11f0-498d-b59d-e0dfab93b56d@tls.msk.ru>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, May 10, 2024 at 11:05:44AM +0300, Michael Tokarev wrote:
> 09.05.2024 17:11, Daniel P. Berrangé wrote:
> > On Thu, May 09, 2024 at 04:54:16PM +0300, Michael Tokarev wrote:
> > > 03.05.2024 20:46, Babu Moger wrote:
> 
> > > > diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> > > > index 08c7de416f..46235466d7 100644
> > > > --- a/hw/i386/pc.c
> > > > +++ b/hw/i386/pc.c
> > > > @@ -81,6 +81,7 @@
> > > >    GlobalProperty pc_compat_9_0[] = {
> > > >        { TYPE_X86_CPU, "guest-phys-bits", "0" },
> > > >        { "sev-guest", "legacy-vm-type", "true" },
> > > > +    { TYPE_X86_CPU, "legacy-multi-node", "on" },
> > > >    };
> > > 
> > > Should this legacy-multi-node property be added to previous
> > > machine types when applying to stable?  How about stable-8.2
> > > and stable-7.2?
> > 
> > machine types are considered to express a fixed guest ABI
> > once part of a QEMU release. Given that we should not be
> > changing existing machine types in stable branches.
> 
> Yes, I understand this, and this is exactly why I asked.
> The change in question has been Cc'ed to stable.  And I'm
> trying to understand what should I do with it :)
> 
> > In theory we could create new "bug fix" machine types in stable
> > branches. To support live migration, we would then need to also
> > add those same stable branch "bug fix" machine type versions in
> > all future QEMU versions. This is generally not worth the hassle
> > of exploding the number of machine types.
> > 
> > If you backport the patch, minus the machine type, then users
> > can still get the fix but they'll need to manually set the
> > property to enable it.
> 
> I don't think this makes big sense.  But maybe for someone who
> actually hits this issue such backport will let to fix it.
> Hence, again, I'm asking if it really a good idea to pick this
> up for stable (any version of, - currently there are 2 active
> series, 7.2, 8.2 and 9.0).

Hmm, the description says

  "Observed the following failure while booting the SEV-SNP guest"

and yet the patches for SEV-SNP are *not* merged in QEMU yet. So this
does not look relevant for stable unless I'm missing something.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


