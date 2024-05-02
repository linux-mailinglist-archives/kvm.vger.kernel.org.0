Return-Path: <kvm+bounces-16411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A188B9A88
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 14:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD7211C21C2D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 12:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DC578276;
	Thu,  2 May 2024 12:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uvw/qGZE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB346341B
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 12:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714652031; cv=none; b=CQ/Cyp2dQ/y3KwlIG3w1eFd4DakXqQyMWRLLlpt57DTCju+GSTUP7+L9Tz3feBdb9yrTZR4rXv6CYvrY08enIL+931OE2plN2l3VN704xZu2b7swIq8tVYZgC7OMGftl5FvpxKXa8Wv5koWuzgfwDKj6uyusmJmRRv/Qzdpu5p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714652031; c=relaxed/simple;
	bh=33va+Ck9YUlXQWyqwCcQegbYM/J8O473QqlB6HlvAwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnc2V3XvJWAcReyA+nsB7ULKJxX21tUSSRHjEQJBcgL95Un9nWpwdtFS/vhAh1B7BYPBeJAuyDIntnkvbuvVxgRR58JHk3fde6jWNbzh7PF9ANFP9yVfFpfAA1ccVScv3T/BHy5jOQK6kUO7ahG08dTxAjCuucE75+yjq7bIroM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uvw/qGZE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714652029;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMfa/XrGYhegbpAwndAKxgfT1VHN5XMhQpu8iMYZ4Ng=;
	b=Uvw/qGZEIlmQyhDMurFYJGvH5W3/aO95RZB93PF0c+9eYFPwu5maWu6zojw5/DjT7wzAzj
	/Qme2JR/z2bELiIOeJmmLLpT3ZAvDJyoQYfCLOcuxGEiZ//HX3F6cFXlOw/8OnhoAjz9wf
	B95ML1aUiqff/9Y3wnlkD5WMetDAoNQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-xzCSHd0QOYiKA7j74SUk4w-1; Thu,
 02 May 2024 08:13:45 -0400
X-MC-Unique: xzCSHd0QOYiKA7j74SUk4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3924C1C4C3E1;
	Thu,  2 May 2024 12:13:45 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.138])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B43E1C0654B;
	Thu,  2 May 2024 12:13:41 +0000 (UTC)
Date: Thu, 2 May 2024 13:13:40 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
	qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>, devel@lists.libvirt.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v4 20/22] hw/i386/pc: Remove deprecated pc-i440fx-2.3
 machine
Message-ID: <ZjODdLACORiQ0Kfm@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240416185939.37984-1-philmd@linaro.org>
 <20240416185939.37984-21-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240416185939.37984-21-philmd@linaro.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Tue, Apr 16, 2024 at 08:59:36PM +0200, Philippe Mathieu-Daudé wrote:
> The pc-i440fx-2.3 machine was deprecated for the 8.2
> release (see commit c7437f0ddb "docs/about: Mark the
> old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
> time to remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  docs/about/deprecated.rst       |  4 ++--
>  docs/about/removed-features.rst |  2 +-
>  hw/i386/pc.c                    | 25 -------------------------
>  hw/i386/pc_piix.c               | 19 -------------------
>  4 files changed, 3 insertions(+), 47 deletions(-)


> diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
> index 30bcd86ee6..370d130a6d 100644
> --- a/hw/i386/pc_piix.c
> +++ b/hw/i386/pc_piix.c
> @@ -421,14 +421,6 @@ static void pc_set_south_bridge(Object *obj, int value, Error **errp)
>   * hw_compat_*, pc_compat_*, or * pc_*_machine_options().
>   */

The comment that is just out of sight in the diff is now obsolete
and should be removed too.

>  
> -static void pc_compat_2_3_fn(MachineState *machine)
> -{
> -    X86MachineState *x86ms = X86_MACHINE(machine);
> -    if (kvm_enabled()) {
> -        x86ms->smm = ON_OFF_AUTO_OFF;
> -    }
> -}
> -
>  #ifdef CONFIG_ISAPC
>  static void pc_init_isa(MachineState *machine)
>  {
> @@ -812,17 +804,6 @@ static void pc_i440fx_2_4_machine_options(MachineClass *m)
>  DEFINE_I440FX_MACHINE(v2_4, "pc-i440fx-2.4", NULL,
>                        pc_i440fx_2_4_machine_options)
>  
> -static void pc_i440fx_2_3_machine_options(MachineClass *m)
> -{
> -    pc_i440fx_2_4_machine_options(m);
> -    m->hw_version = "2.3.0";
> -    compat_props_add(m->compat_props, hw_compat_2_3, hw_compat_2_3_len);
> -    compat_props_add(m->compat_props, pc_compat_2_3, pc_compat_2_3_len);
> -}
> -
> -DEFINE_I440FX_MACHINE(v2_3, "pc-i440fx-2.3", pc_compat_2_3_fn,
> -                      pc_i440fx_2_3_machine_options);

This is the last DEFINE_I440FX_MACHINE call that provides a
non-NULL 3rd parameter.

IOW, there could be a further patch removing the 3rd 'compatfn'
parameter now it is finally obsolete.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


