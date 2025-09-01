Return-Path: <kvm+bounces-56447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE956B3E551
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDAD7440D1F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423B73375BE;
	Mon,  1 Sep 2025 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ciSMXar7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A895A334393
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733882; cv=none; b=HckfqiAJpqkRJCqro4wu+MZ6GvUExP98r0epTH+QqHAA5SI5m+fU/X4jDVOTINtCO/N2Oqi58RhJMacDYEYAiY8yep5koBaZvOlhXl9f9WuEQvmAEFT6P2tjC0Jvrf8sAnzmKjKJBC7UofT3wFWvVd7m6sxhBirczV8LIiqPeDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733882; c=relaxed/simple;
	bh=UuNf9rlk+hEcaXZorDmSiD8BwVp7IM4xnbSWZEnN6/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vy/1PkEz8hh3n1b1njSUXXTHwXGjzH4tVKOApeeyuBUujbtbwCFJljWhg4Nya2g/+u1JX5+F96Zs7xK67a5XOvyZSPYexCA45zTZRUowe3jczWqez/LD6oTToNbJO+mbNLkcYBGOF9X+w4EydL1tTbc3FBlOwxKAbgEJTQ8W91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ciSMXar7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756733879;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UgsEaIVb7dOAyNYJBPoyoEcEYDI0X0WnsrsLkdY2hoE=;
	b=ciSMXar7ZY68kIG1XWif6V9hNJqBCOIB++Hhgt9rU10lzqKcKB8bTqBcw43zHHc1z+bHnt
	/Vse0h3DOVipMay670Gv2FWoqxIyCooH2qCkyhwk8D9oyx0zCqHmjyfAHBBiUOJ1fengtr
	uoH4p/02b7dyaQeGTZfcvdV/euQG4xk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-dz18ecxlNBOU4mvOHyz-fA-1; Mon,
 01 Sep 2025 09:37:56 -0400
X-MC-Unique: dz18ecxlNBOU4mvOHyz-fA-1
X-Mimecast-MFC-AGG-ID: dz18ecxlNBOU4mvOHyz-fA_1756733874
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7024D1800289;
	Mon,  1 Sep 2025 13:37:54 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.100])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83F6818003FC;
	Mon,  1 Sep 2025 13:37:48 +0000 (UTC)
Date: Mon, 1 Sep 2025 14:37:45 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org,
	Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>
Subject: Re: [PATCH v2 2/3] buildsys: Prohibit alloca() use on system code
Message-ID: <aLWhqb7Kc59N3jGx@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250901132626.28639-1-philmd@linaro.org>
 <20250901132626.28639-3-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250901132626.28639-3-philmd@linaro.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Sep 01, 2025 at 03:26:25PM +0200, Philippe Mathieu-Daudé wrote:
> Similarly to commit 64c1a544352 ("meson: Enable -Wvla") with
> variable length arrays, forbid alloca() uses on system code.
> 
> There are few uses on ancient linux-user code, do not bother
> there.

This says you're not turning on -Walloca for linux-user, but....

> +if have_system
> +  warn_flags += ['-Walloca']
> +endif

...surely this still turns on -Walloca for linux-user, if the build has
enabled multiple targets covering both system & user mode. ie a default
qemu build ?

> +
>  # Set up C++ compiler flags
>  qemu_cxxflags = []
>  if 'cpp' in all_languages
> -- 
> 2.51.0
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


