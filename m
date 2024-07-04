Return-Path: <kvm+bounces-20943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBBC9271ED
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CC122850F0
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911BE1A4F18;
	Thu,  4 Jul 2024 08:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzND/FY1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2759F1A4F01
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720082569; cv=none; b=DbhlJvrHWDTG5tvDuXCtPHuQhHowkB4hLfMy1KA0mAok/GqvV8NX/0qIIgBoqi7PG/1rOAJFboyznGVlU1LCr8VY8gyZ6C5t6ZOD8A5neVzwztMWvGRyvtGXzGXcfV5aNw+fKlsrp+lJLaRd4//fAkVACm1QZqHq1Ve1b3U0xiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720082569; c=relaxed/simple;
	bh=8u1rd/BEZ6ussF9G3Hs3IT8foDcG28DZGe3hPa6uOMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bd3Ve1p7ffXJbpx3wlfV3EUCO3JQnrA7kwWPP2wJPnkq6T4W5elxTX/t/HhKc9ShS2wpJncaES2hv+2CSEcmx6Xji2C2/1FNjcTLPVyT7h7kK+lb+HBnxQ5Wt7RkLTk7RKcuozxFPCDzmEZpKfrWAvz3V15BPchdU/eSfx1SUhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzND/FY1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720082566;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vozscD3o8VlMPbAmDro3V7LyfO/P+fi6WccYcHp4DII=;
	b=IzND/FY1n56CpK2QiudrwYRC/lALrAAQSJTF7lyUSUSFVhdG+7MOWHoCgX0D7nc3ogM6gC
	U1CnIBKnrcH7lQcv8/uQkBi2HPyqYAP4fw0A0cJseJvq5CdkPHOIau0wBgIPsYeWOIlpbO
	jDpTJsxayixdVaUnMwMl4+HaZ1/LWJQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-6OlWIiqyOrqGJhyDnD3FHg-1; Thu,
 04 Jul 2024 04:42:43 -0400
X-MC-Unique: 6OlWIiqyOrqGJhyDnD3FHg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC19F1956088;
	Thu,  4 Jul 2024 08:42:41 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.21])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 30406195605A;
	Thu,  4 Jul 2024 08:42:38 +0000 (UTC)
Date: Thu, 4 Jul 2024 09:42:35 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] i386/sev: Don't allow automatic fallback to legacy
 KVM_SEV*_INIT
Message-ID: <ZoZge_2UT_yRJE56@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240704000019.3928862-1-michael.roth@amd.com>
 <CABgObfYX+nDnQSW5xyT3SjYbQ72--EW5buCkUuG_Z_JPFqfQNA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYX+nDnQSW5xyT3SjYbQ72--EW5buCkUuG_Z_JPFqfQNA@mail.gmail.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Jul 04, 2024 at 08:51:05AM +0200, Paolo Bonzini wrote:
> On Thu, Jul 4, 2024 at 2:01 AM Michael Roth <michael.roth@amd.com> wrote:
> > Currently if the 'legacy-vm-type' property of the sev-guest object is
> > left unset, QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
> > interface in conjunction with the newer KVM_X86_SEV_VM and
> > KVM_X86_SEV_ES_VM KVM VM types.
> >
> > This can lead to measurement changes if, for instance, an SEV guest was
> > created on a host that originally had an older kernel that didn't
> > support KVM_SEV_INIT2, but is booted on the same host later on after the
> > host kernel was upgraded.
> 
> I think this is the right thing to do for SEV-ES. I agree that it's
> bad to require a very new kernel (6.10 will be released only a month
> before QEMU 9.1), on the other hand the KVM_SEV_ES_INIT API is broken
> in several ways. As long as there is a way to go back to it, and it's
> not changed by old machine types, not using it for SEV-ES is the
> better choice for upstream.

Broken how ?   I know there was the regression with the 'debug_swap'
parameter, but was something that should just be fixed in the kernel,
rather than breaking userspace. What else is a problem ?

I don't think its reasonable for QEMU to require a brand new kernel
for new machine types, given SEV & SEV-ES have been deployed for
many years already. 


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


