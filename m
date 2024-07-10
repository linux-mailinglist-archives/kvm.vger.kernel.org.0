Return-Path: <kvm+bounces-21271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1433292CBBE
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FBDE1C2277D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 07:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDE37D095;
	Wed, 10 Jul 2024 07:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KOp9rJI4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CE53BB24
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595724; cv=none; b=Ag7HWjDRUU+op9NuK3sSmrZ1huSAkXi73TtR73bTyQje9t2/UiDJNSbZx4nHfA6dgG9CB9O/cEkRfPF+hwFA44GO/eGX5kG5DZCaJGZWJDE83jdHfNl1j/dKZlxRTEjg/ADy9oQJCym1yOFe5fQHLI2Zv5Jbk6A3ZYJXom4UK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595724; c=relaxed/simple;
	bh=AnJb7O8b/znRdfwu40rOZE7kXkU+ieaNdv4lccuKtJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0hfwHQgjx8IRP8eAYQIJmW7fzl1TQt2DbV2MPJhJV5W2mWdbVxNM8k+8q8+g+gMDinIZCNiS3r6AqqRTfBe2K8dsueLU9mCa/7VXX9qiqGedfbM46Jg4F0hKQ9sE3MQmonlLvlFxJR/VuLH0os3JXX8Z/YEXOom0izlpnUboVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KOp9rJI4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720595721;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UMU3qVQQd5gCJgegoVmffWhIQ56IyxVkzgTRd1PnKFg=;
	b=KOp9rJI4fAthjDXUVa39FOnFI77n41GB6YR9RQRoni9MRC1pOnqy93Whzi96WutLJuIhZi
	/dGwIWp3p5gFNikN8Fg+UpCAVe9k2EmZ6x/p2Huo37xhUVJOL9tWWvj0no+4qHCaWo8+5t
	M2sr2hHq8YYBU2fIS3n6wR6ctrOVZgE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-yA7hdqIgMt63u7YsDBHEqw-1; Wed,
 10 Jul 2024 03:15:17 -0400
X-MC-Unique: yA7hdqIgMt63u7YsDBHEqw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 544C81955BCE;
	Wed, 10 Jul 2024 07:15:16 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.46])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A724E19560AE;
	Wed, 10 Jul 2024 07:15:14 +0000 (UTC)
Date: Wed, 10 Jul 2024 08:15:11 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] i386/sev: Don't allow automatic fallback to legacy
 KVM_SEV*_INIT
Message-ID: <Zo40_2e1I4gXdNxx@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240710041005.83720-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240710041005.83720-1-michael.roth@amd.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Jul 09, 2024 at 11:10:05PM -0500, Michael Roth wrote:
> Currently if the 'legacy-vm-type' property of the sev-guest object is
> 'on', QEMU will attempt to use the newer KVM_SEV_INIT2 kernel
> interface in conjunction with the newer KVM_X86_SEV_VM and
> KVM_X86_SEV_ES_VM KVM VM types.
> 
> This can lead to measurement changes if, for instance, an SEV guest was
> created on a host that originally had an older kernel that didn't
> support KVM_SEV_INIT2, but is booted on the same host later on after the
> host kernel was upgraded.
> 
> Instead, if legacy-vm-type is 'off', QEMU should fail if the
> KVM_SEV_INIT2 interface is not provided by the current host kernel.
> Modify the fallback handling accordingly.
> 
> In the future, VMSA features and other flags might be added to QEMU
> which will require legacy-vm-type to be 'off' because they will rely
> on the newer KVM_SEV_INIT2 interface. It may be difficult to convey to
> users what values of legacy-vm-type are compatible with which
> features/options, so as part of this rework, switch legacy-vm-type to a
> tri-state OnOffAuto option. 'auto' in this case will automatically
> switch to using the newer KVM_SEV_INIT2, but only if it is required to
> make use of new VMSA features or other options only available via
> KVM_SEV_INIT2.
> 
> Defining 'auto' in this way would avoid inadvertantly breaking
> compatibility with older kernels since it would only be used in cases
> where users opt into newer features that are only available via
> KVM_SEV_INIT2 and newer kernels, and provide better default behavior
> than the legacy-vm-type=off behavior that was previously in place, so
> make it the default for 9.1+ machine types.
> 
> Cc: Daniel P. Berrangé <berrange@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> cc: kvm@vger.kernel.org
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
> v2:
>   - switch to OnOffAuto for legacy-vm-type 'property'
>   - make 'auto' the default for 9.1+, which will automatically use
>     KVM_SEV_INIT2 when strictly required by a particular set of options,
>     but will otherwise keep using the legacy interface.
> 
>  hw/i386/pc.c      |  2 +-
>  qapi/qom.json     | 18 ++++++----
>  target/i386/sev.c | 85 +++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 83 insertions(+), 22 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


