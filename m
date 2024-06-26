Return-Path: <kvm+bounces-20558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 103B49183CA
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADF021F23742
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5F7185091;
	Wed, 26 Jun 2024 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U5fw8szd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547921836F9
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 14:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719411650; cv=none; b=DklqOEdTffLy8VFXMk/botTlGMm5jkb8zpw9PNECOv2y+ftrFpZUpivwzvPlKE2NhEKhOIEzTNyklgCmlvO9HNpC9VDJWq09MsOlbDL0pQQqDzS2SPy8atxB4ZaG3dcSw6NalfmIwUtFNM4BSmyg71dqMNN/8d4w+Z2rE/l+/bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719411650; c=relaxed/simple;
	bh=fedo0LsGAu0Z36We4vIHDSuuNs9gsnFFCS1v6gdIMlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpN3CesxUrEmVMOyoWlG/gbGhjt83Lqk0GlrxvTobRjhxbf3ae6lpIN2d+KLtdQb9EpiOd9GT/oQSOihe2STfcewvpoiBflVLiSXpRFjtSY0q/NUELLJOb6cyJ2aFCEq7H1wA82LYBtACDOfSGWjyA4fYGeIRiyTW5BVcPD8BYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U5fw8szd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719411647;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eyZaLxL1fVded8yAr7hUAFouf/feJ7a7gDZYQs8G4Q4=;
	b=U5fw8szdLzE0E/Xz3CWKTVkM4ayOzLIRRu+ndR+kixgC+0YS9QylUtHIC8NTh+fXk6z1MB
	tagjCmIYWEEMUmKr7PoVMmtuH+icrzVvq/Mj161vxGUaEBRwDE361Z3naRR5ODgcAvuZ1g
	XTpnGOtGkvRxX+nJsCLw2mE11y5coMU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-341-PPS9qjKuMu6tYtsyqgDPrg-1; Wed,
 26 Jun 2024 10:20:43 -0400
X-MC-Unique: PPS9qjKuMu6tYtsyqgDPrg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBE5F1955DE1;
	Wed, 26 Jun 2024 14:20:41 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.50])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C789B1956050;
	Wed, 26 Jun 2024 14:20:39 +0000 (UTC)
Date: Wed, 26 Jun 2024 15:20:36 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"open list:X86 KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] target/i386: restrict SEV to 64 bit host builds
Message-ID: <ZnwjtOxQy1iiRoFh@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240626140307.1026816-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240626140307.1026816-1-alex.bennee@linaro.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Jun 26, 2024 at 03:03:07PM +0100, Alex Bennée wrote:
> Re-enabling the 32 bit host build on i686 showed the recently merged
> SEV code doesn't take enough care over its types. While the format
> strings could use more portable types there isn't much we can do about
> casting uint64_t into a pointer. The easiest solution seems to be just
> to disable SEV for a 32 bit build. It's highly unlikely anyone would
> want this functionality anyway.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  target/i386/sev.h       | 2 +-
>  target/i386/meson.build | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 858005a119..b0cb9dd7ed 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -45,7 +45,7 @@ typedef struct SevKernelLoaderContext {
>      size_t cmdline_size;
>  } SevKernelLoaderContext;
>  
> -#ifdef CONFIG_SEV
> +#if defined(CONFIG_SEV) && defined(HOST_X86_64)
>  bool sev_enabled(void);
>  bool sev_es_enabled(void);
>  bool sev_snp_enabled(void);
> diff --git a/target/i386/meson.build b/target/i386/meson.build
> index 075117989b..d2a008926c 100644
> --- a/target/i386/meson.build
> +++ b/target/i386/meson.build
> @@ -6,7 +6,7 @@ i386_ss.add(files(
>    'xsave_helper.c',
>    'cpu-dump.c',
>  ))
> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c', 'confidential-guest.c'))
> +i386_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('host-cpu.c', 'confidential-guest.c'))
>  
>  # x86 cpu type
>  i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
> @@ -21,7 +21,7 @@ i386_system_ss.add(files(
>    'cpu-apic.c',
>    'cpu-sysemu.c',
>  ))
> -i386_system_ss.add(when: 'CONFIG_SEV', if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
> +i386_system_ss.add(when: ['CONFIG_SEV', 'HOST_X86_64'], if_true: files('sev.c'), if_false: files('sev-sysemu-stub.c'))
>  
>  i386_user_ss = ss.source_set()

Instead of changing each usage of CONFIG_SEV, is it better to
prevent it getting enabled in the first place ?

eg. move

  #CONFIG_SEV=n

From

  configs/devices/i386-softmmu/default.mak

to

  configs/devices/x86_64-softmmu/default.mak

And then also change

  hw/i386/Kconfig

to say

  config SEV
      bool
      select X86_FW_OVMF
      depends on KVM && X86_64


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


