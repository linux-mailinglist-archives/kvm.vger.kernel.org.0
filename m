Return-Path: <kvm+bounces-41990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5654CA709B7
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 19:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BA96189D97A
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 18:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C8A1E1E1D;
	Tue, 25 Mar 2025 18:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yv1r0u2H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E855B1C6FFF
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 18:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928409; cv=none; b=d/8YC9sAJhgSTEspolRbkxK9fvqaueRvkIYzQQrDI+AYGh3frUnEChkA5NGem9CTVE1Iw90mhM3M6jG1eDMbf1RH53eS/m8jbC0dcyt+hCSnuAT7GN84AXs/Jm5nV+x6yTRk5SEsdIj1JZ1xnv3P1+WZGQyOUEARnlGQiTe9K3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928409; c=relaxed/simple;
	bh=uH3irTP3zXmAb3aGzFghU1gKMvLS5WMAIkInFcjJdEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4ztn/trOr5J0rhErQzURzC+ECri/Ns5KE8c0JlkERus0KLyJXTe+gB3QOiWsfk+YAAz2hoKfYp/d7N54VE8ZIIRuTnpV9z8R7gUZO0RGmMfQbRZSRFh1aVrisKtFL8yJMYVPrLqPwa9xkJ84PAdO8GF12Sxzgkyc3Izy30mV5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yv1r0u2H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742928406;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=hKa7QnrXX6+uetxxUeYkejthJ5t555o/0s469UnOHVg=;
	b=Yv1r0u2HgTU1xWgOhurEK70CR5OHyPuraaQyrnx1/EoQhW8UXgDMUamv0CNcpKw2UGAEnB
	ocW8c4asFodbaenwhDpsejNPU8iKK9LJDx9wYWa5y9MFdjISpSMPgNahDOXcFYMNvb8FQV
	xY19/o9REH+7nz8gUCAZ1HushNyOeWI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-4C4bLYNMPJ-qjfR7jXaPDA-1; Tue,
 25 Mar 2025 14:46:43 -0400
X-MC-Unique: 4C4bLYNMPJ-qjfR7jXaPDA-1
X-Mimecast-MFC-AGG-ID: 4C4bLYNMPJ-qjfR7jXaPDA_1742928402
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9574180AF50;
	Tue, 25 Mar 2025 18:46:41 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.51])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD9DD1801756;
	Tue, 25 Mar 2025 18:46:36 +0000 (UTC)
Date: Tue, 25 Mar 2025 18:46:33 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 52/52] docs: Add TDX documentation
Message-ID: <Z-L6CSajU284qAJ4@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
 <20250124132048.3229049-53-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250124132048.3229049-53-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Fri, Jan 24, 2025 at 08:20:48AM -0500, Xiaoyao Li wrote:
> Add docs/system/i386/tdx.rst for TDX support, and add tdx in
> confidential-guest-support.rst
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---

> ---
>  docs/system/confidential-guest-support.rst |   1 +
>  docs/system/i386/tdx.rst                   | 156 +++++++++++++++++++++
>  docs/system/target-i386.rst                |   1 +
>  3 files changed, 158 insertions(+)
>  create mode 100644 docs/system/i386/tdx.rst


> +Launching a TD (TDX VM)
> +-----------------------
> +
> +To launch a TD, the necessary command line options are tdx-guest object and
> +split kernel-irqchip, as below:
> +
> +.. parsed-literal::
> +
> +    |qemu_system_x86| \\
> +        -object tdx-guest,id=tdx0 \\
> +        -machine ...,kernel-irqchip=split,confidential-guest-support=tdx0 \\
> +        -bios OVMF.fd \\
> +
> +Restrictions
> +------------
> +
> + - kernel-irqchip must be split;

Is there a reason why we don't make QEMU set kernel-irqchip=split
automatically when tdx-guest is enabled ?

It feels silly to default to a configuration that is known to be
broken with TDX. I thought about making libvirt automatically
set kernel-irqchip=split, or even above that making virt-install
automatically set it. Addressing it in QEMU would seem the most
appropriate place though.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


