Return-Path: <kvm+bounces-20396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF49914A55
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 14:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42BF2B23A3F
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C8413D523;
	Mon, 24 Jun 2024 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Alua9aeK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D07713D60D
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 12:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719232752; cv=none; b=L4pIRVoNFrOYp0wIN9q8rX6m7YegXC4s/DLMgxc1mawSu8lFi5+YeJL0uLoZTQ49ilEFVjZJr+Pw8+DQ+Y2yo+7RLkFi0IyXPtVFEAtyQ0Wrv35O9j8OzmS1CA2mtjjXewmGE1O7EnAya7xeFPpiILYr3Tnma27PzHwar+6UylA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719232752; c=relaxed/simple;
	bh=C8cMy3/diK06yU+v17G87rROvVKCDW6mK/cZHhNOidc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTLkoqQFdmGnxOeMv/UKBYeSMz83+JHy3ghi2ebvc0qclXzEy7R3Jg1RwhvMw1PHBfWccNfd5F3dDFxur3QoeRk4eI+lW+M4e7fNoZRpi3XdBoyeF/j0FJ4SmpjcMm+9FT5lXtcGgshnKlUScktAY6bsJOTSvTdY2F0vd8fPor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Alua9aeK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719232749;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCkXiUAP422+GKIba8BKRNsoqDrd/P+DTSVD2LrppTk=;
	b=Alua9aeKEXnhV4zgefkPnB16hKXkPZPQ62o1rXr917bRF0hmrTTNBKycZn3+LW5sv9tSj1
	2LUAiMMfd7BA8yY3scVKV/qskR5S1Low6xkLnTtoMrvEAUwOgXepYrygPDLooBsM+wLFfV
	hwIiF+YUlI0PH1D9gzrB3mEW5GyndAQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-uYoI1mJAPMaD3NhUTvDxgQ-1; Mon,
 24 Jun 2024 08:39:06 -0400
X-MC-Unique: uYoI1mJAPMaD3NhUTvDxgQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0259819560AD;
	Mon, 24 Jun 2024 12:39:05 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.226])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FC0819560BF;
	Mon, 24 Jun 2024 12:38:59 +0000 (UTC)
Date: Mon, 24 Jun 2024 13:38:56 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
	Markus Armbruster <armbru@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for
 SEV(-ES) guests
Message-ID: <Znlo4GMgJ91nKyft@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240614103924.1420121-1-berrange@redhat.com>
 <20240624080458-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240624080458-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jun 24, 2024 at 08:27:01AM -0400, Michael S. Tsirkin wrote:
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
> > 
> > This can be re-evaluated a few years down the line, though it is more
> > likely that all attention will be on SEV-SNP by this time. Distro
> > vendors may still choose to change this default downstream to align
> > with their new major releases where they can guarantee the kernel
> > will always provide the required functionality.
> > 
> > Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> 
> This makes sense superficially, so
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> and I'll let kvm maintainers merge this.
> 
> However I wonder, wouldn't it be better to refactor this:
> 
>     if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
>         cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
>         
>         ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
>     } else {
>         struct kvm_sev_init args = { 0 };
>                 
>         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
>     }   
> 
> to something like:
> 
> if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) != KVM_X86_DEFAULT_VM) {
>         struct kvm_sev_init args = { 0 };
>                 
>         ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
> 	if (ret && errno == ENOTTY) {
> 		cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
> 
> 		ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
> 	}
> }
> 
> 
> Yes I realize this means measurement will then depend on the host
> but it seems nicer than failing guest start, no?

IMHO having an invariant measurement for a given guest configuration
is a critical guarantee. We should not be allowing guest attestation
to break as a side-effect of upgrading a software component, while
keeping the guest config unchanged.

IOW, I'd view measurement as being "guest ABI", and versioned machine
types are there to provide invariant guest ABI.

Personally, if we want simplicitly then just not using KVM_SEV_INIT2
at all would be the easiest option. SEV/SEV-ES are legacy technology
at this point, so we could be justified in leaving it unchanged and
only focusing on SEV-SNP. Unless someone can say what the critical
*must have* benefit of using KVM_SEV_INIT2 is ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


