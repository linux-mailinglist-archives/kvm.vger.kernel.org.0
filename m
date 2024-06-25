Return-Path: <kvm+bounces-20461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3D99163EE
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 11:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08F261C221FE
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 09:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7927D1494CF;
	Tue, 25 Jun 2024 09:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5cuGo9a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99DC24B34
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 09:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309119; cv=none; b=YdVqmRN9k6g4qEo3Ov05ROkrFBlKVPkALDF0MjO0taWCF4F5SjsjNvJUOqzfEZ+f1vJ+b8F2MmQ7ASBnDiNQLn7q0R4Rl0n+R97S/OreddDA5qD1jkxgHesEYWvDvYJ4JZUDio0AUxjz3b6BKVzvj96GmBfy1bpi4kqS0PN68vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309119; c=relaxed/simple;
	bh=ZA6fZ7VihOt+qy661kP35OaS1Uz2iZzAenuBZ1k4+Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5vvCth4M7ZsG5vKgq5lWid0a42dJ1xMX/0wb5DuR96QXgvlFfANCf6cCzvcG2e5W1+NUY9b39d8/byG1gFUAeZ8cruavZzdlre0dAE0ZfXlwGbyGNcco6ZiEW2exuyu+JVH9kGKIiVya1ph7t24Ge6XWpLiaYN8e2ESdP90CeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5cuGo9a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719309116;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vo50PxDCoNXswmDcLrDznDRWT+K0xPa8KSfF4wB+SI4=;
	b=h5cuGo9ah+Pv/45XJ6OunG/YALmZ9sJ3JUr+LykfslT52B0BbvQqVgg7mkB15paq5TQen/
	GMCXPshhNd5BJngtaKy0hj477zaewOfuz70/CnfAOuw0Ne4wxTcmH6mRWtqWEeXZIjHid/
	pnU9GyFYrhaAmzlhFmHDD88I8Pd1VoM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-kGBJmploOU2fFv6eGWuchg-1; Tue,
 25 Jun 2024 05:51:53 -0400
X-MC-Unique: kGBJmploOU2fFv6eGWuchg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5050C19560B7;
	Tue, 25 Jun 2024 09:51:51 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.57])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B6741956087;
	Tue, 25 Jun 2024 09:51:46 +0000 (UTC)
Date: Tue, 25 Jun 2024 10:51:43 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
	Markus Armbruster <armbru@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for
 SEV(-ES) guests
Message-ID: <ZnqTL4oQCSiuTd6n@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240614103924.1420121-1-berrange@redhat.com>
 <za7dwgyz2yfspsivg67qkzkf4cz3eeiclavdznskap6zcip66s@7iqpll2pzax4>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <za7dwgyz2yfspsivg67qkzkf4cz3eeiclavdznskap6zcip66s@7iqpll2pzax4>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Jun 24, 2024 at 08:19:19PM -0500, Michael Roth wrote:
> On Fri, Jun 14, 2024 at 11:39:24AM +0100, Daniel P. Berrangé wrote:
> > The KVM_SEV_INIT2 ioctl was only introduced in Linux 6.10, which will
> > only have been released for a bit over a month when QEMU 9.1 is
> > released.
> > 
> > The SEV(-ES) support in QEMU has been present since 2.12 dating back
> > to 2018. With this in mind, the overwhealming majority of users of
> > SEV(-ES) are unlikely to be running Linux >= 6.10, any time in the
> > forseeable future.
> > 
> > IOW, defaulting new QEMU to 'legacy-vm-type=false' means latest QEMU
> > machine types will be broken out of the box for most SEV(-ES) users.
> > Even if the kernel is new enough, it also affects the guest measurement,
> > which means that their existing tools for validating measurements will
> > also be broken by the new default.
> > 
> > This is not a sensible default choice at this point in time. Revert to
> > the historical behaviour which is compatible with what most users are
> > currently running.
> 
> Part of the reason for the change is that SEV-ES measurements are
> already affected by some short-comings of the legacy KVM_SEV_ES_INIT
> API. Namely, if the kvm_amd.debug-swap module param is used to enable
> that SEV-ES feature, then that feature will get enabled on the KVM side
> and change the initial guest measurement (due to VMSA_FEATURES field
> of the vCPU's VMSA changing), and userspace has no way to control that
> on a per-VM basis, so measurement for any particular invocation will
> be somewhat random depending on the system configuration and kernel
> level.

The debug-swap feature was set to disabled by default. So that
could be just a docs problem to say if you want to use that
feature, then you must set the legacy-vm=false property. IOW
an opt-in to incompatible behaviour.


> I think that's why users of newer QEMU machine types are highly
> encouraged to switch to the new KVM_SEV_INIT2 interface. I do see this
> causing issues for older QEMU machine types that previously relied on
> the legacy interface, since we do want to avoid measurement changing
> for an existing guest that was previously working on an older kernel,
> which is why this flag defaults to true for pre-9.1 machine types.

This justification mis-understands how machine types are actually
used in practice though. There is *zero* correlation between use
of the new machine types, and availabilty of the new kernel
interface. 

99% of usage of QEMU, will just ask for the unversioned "q35"
/ "pc" machines. They will be expanded to the very latest machine
type version, either internally by QEMU, or by libvirt prior to
launching the VM.

Either way, you can expect essentially everything to be running on
the latest machine type versions, regardless of kernel version.

So making the latest machine types dependent on a kernel version
that is brand new is just not a sensible default. Latest QEMU
machines types need to work on kernel releases years old, without
expecting the user to set magic flags to avoid incompatibility.

> I was actually planning to go the other direction on this because
> currently for 9.1+, QEMU will try to use KVM_SEV_INIT2 if
> KVM_CAP_VM_TYPES advertises its availability, but otherwise fall back to
> the above KVM_SEV_ES_INIT interface and potential inherit the issues
> noted above. So I was planning on getting rid of the fallback, and
> basically only allowing legacy KVM_SEV_ES_INIT for 9.1+ if the user
> manually sets sev_guest->legacy_vm_type via cmdline.

Dynamic detection of SEV_INIT vs SEV-INIT2 is a bad idea as that
breaks migration when someone is moving from a host with new
kernel to an older kernel, while keeping the QEMU machine type
unchanged. The behaviour of what kernel feature to use must be
controllable with an explicit choice.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


