Return-Path: <kvm+bounces-20949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AAA927334
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 11:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D5F2283796
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 09:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B081AB51C;
	Thu,  4 Jul 2024 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZ6gzlDF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DC748F
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085971; cv=none; b=LuEY40fKpf7/fhBJ+YJGBriaosLQ+rU1jf1wF0zhxF7BJ9gBFGJMmnXbitaMM8NnLRONqjVGij75+Mm2mpN1bjivGCcJX+fQOCSlA0sC4JQQsogHg3+BmAGxYdSl5QavzYixbFx5MGj4I4scXh77YYPp5DUu+J4t+pJhptX0IHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085971; c=relaxed/simple;
	bh=mKSkiux4gWPPD+GpcIE6UfCF/kYapVXzvAczNXjkpeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUApWC2vCU2+6DjU2MnyRBIUuAx6booEp39tiGlAu1if5ziFJGc9K2rveHVhOzXlA+JikA4YXvxzuuiJSpjjqs0kXHZE7v7yM/hCA8Xzx6SgrydaclJ9/Z7a54bYGldPqO7NRyf1x4+WKTenztSXNvEyWbtN7IoU3SNznWmtAPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AZ6gzlDF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720085968;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wDLZJHKzSrjg2/Q2Ck/6gMTQyX9tZqJNy+6mBsYfN4w=;
	b=AZ6gzlDFCkjG0QZcr3orF7zJ/qpgqiVgPWrr+20kTrR0+78NrXikZpJi8FYEUP86xuXJav
	9P5Mee9nZWhKkNWLSBnnYcJ+vNC1LNSzIb2KOxFFKISEarxzmrooRhuf0+Ln2c/B5PptAN
	Fpbrew2MdnbEocrOhdiVIDignout2CE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-OZfNEKOQO9ugSNal8hkWRQ-1; Thu,
 04 Jul 2024 05:39:25 -0400
X-MC-Unique: OZfNEKOQO9ugSNal8hkWRQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC4201958B35;
	Thu,  4 Jul 2024 09:39:23 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E92353000180;
	Thu,  4 Jul 2024 09:39:20 +0000 (UTC)
Date: Thu, 4 Jul 2024 10:39:17 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] i386/sev: Don't allow automatic fallback to legacy
 KVM_SEV*_INIT
Message-ID: <ZoZtxUPdDmnFaya6@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240704000019.3928862-1-michael.roth@amd.com>
 <CABgObfYX+nDnQSW5xyT3SjYbQ72--EW5buCkUuG_Z_JPFqfQNA@mail.gmail.com>
 <ZoZge_2UT_yRJE56@redhat.com>
 <CABgObfbf1u_RvRTcoZFepFWdavFnkqNwUCwHm1nE4tNKmM8+pA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbf1u_RvRTcoZFepFWdavFnkqNwUCwHm1nE4tNKmM8+pA@mail.gmail.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jul 04, 2024 at 11:31:16AM +0200, Paolo Bonzini wrote:
> On Thu, Jul 4, 2024 at 10:42 AM Daniel P. Berrangé <berrange@redhat.com> wrote:
> >
> > On Thu, Jul 04, 2024 at 08:51:05AM +0200, Paolo Bonzini wrote:
> > > On Thu, Jul 4, 2024 at 2:01 AM Michael Roth <michael.roth@amd.com> wrote:
> > > > Currently if the 'legacy-vm-type' property of the sev-guest object is
> > > > left unset, QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
> > > > interface in conjunction with the newer KVM_X86_SEV_VM and
> > > > KVM_X86_SEV_ES_VM KVM VM types.
> > > >
> > > > This can lead to measurement changes if, for instance, an SEV guest was
> > > > created on a host that originally had an older kernel that didn't
> > > > support KVM_SEV_INIT2, but is booted on the same host later on after the
> > > > host kernel was upgraded.
> > >
> > > I think this is the right thing to do for SEV-ES. I agree that it's
> > > bad to require a very new kernel (6.10 will be released only a month
> > > before QEMU 9.1), on the other hand the KVM_SEV_ES_INIT API is broken
> > > in several ways. As long as there is a way to go back to it, and it's
> > > not changed by old machine types, not using it for SEV-ES is the
> > > better choice for upstream.
> >
> > Broken how ?   I know there was the regression with the 'debug_swap'
> > parameter, but was something that should just be fixed in the kernel,
> > rather than breaking userspace. What else is a problem ?
> 
> The debug_swap parameter simply could not be enabled in the old API
> without breaking measurements. The new API *is the fix* to allow using
> it (though QEMU doesn't have the option plumbed in yet). There is no
> extensibility.
> 
> Enabling debug_swap by default is also a thorny problem; it cannot be
> enabled by default because not all CPUs support it, and also we'd have
> the same problem that we cannot enable debug_swap on new machine types
> without requiring a new kernel. Tying the default to the -cpu model
> would work but it is confusing.

Presumably we can tie it to '-cpu host' without much problem, and
then just leave it as an opt-in feature flag for named CPU models.

> But I guess we can add support for debug_swap, disabled by default and
> switch to the new API if debug_swap is enabled.
> 
> > I don't think its reasonable for QEMU to require a brand new kernel
> > for new machine types, given SEV & SEV-ES have been deployed for
> > many years already.
> 
> I think it's reasonable if the fix is displayed right into the error
> message. It's only needed for SEV-ES though, SEV can use the old and
> new APIs interchangeably.

FYI currently it is proposed to unconditionally force set legacy-vm-type=true
in libvirt, so QEMU guests would *never* use the new ioctl, to fix what we
consider to be a QEMU / kernel guest ABI regression.

If libvirt adds this though, it is basically a forever setting we would
never be able to remove as removing would break ABI compat again.

  https://lists.libvirt.org/archives/list/devel@lists.libvirt.org/message/KP24LPFV4OCMN45TDHNXQVBPDZ56QSRR/

I'd much rather QEMU did NOT set this by default in its machine types,
so libvirt doesn't have to add this forced flag. That way downstream
distros who /can/ guarantee new enough kernels, can still use
legacy-vm-type=false in their downstream machine types, without
libvirt overriding this.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


