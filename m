Return-Path: <kvm+bounces-25509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFDF96600E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:09:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A664B2E4D1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03C1199939;
	Fri, 30 Aug 2024 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="coWzMlH8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F4199931
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 11:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015917; cv=none; b=bW/BH8UUhFtMrELBmp9RlPa/3NjJdMVplGKoukys2Fm0xN+MJWmIQINWKxSBri35y9/au1hLaC2l4UTV3XTYsylcGmm+IWgNqfvzlZlO/iLs6q3XDsJc/SBo1B+1SNwls9O7WErKptwwW1XUFKJOQG4XlanaQHRiueaDFopGhMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015917; c=relaxed/simple;
	bh=kOIpmlYJb8ft6Y2rN58XGcZtgztFV91lYJqhTSPV0c0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbizgonMXIpBSC2+vds1zj9vSsYTW2lZvRO5CFZMpBwFBtQaN7/PDmFPOl/JUIQNNhTS+xD0klcKUCAGIwA1ZAKZD/69gJe+44emxVAefhyEpXAFadJpsEV1ajb+D+pEDYld1wSXmJqXaaBDTgxVyFxvmakwhKlYJ9fo7XIO1mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=coWzMlH8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725015914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l0tSha6adNMlOrHuzQyVeK84z60qmOVbtCpMu1nyGv4=;
	b=coWzMlH8giDPrAITkjbUuFYt4fHx0nCsDkAeEgwmjDavMxr+51gJ/D8iRgkUeGlglBYg0T
	SdZWyo+Q9UezGAClW961+2J5IJTcPNRaQg2QzSHYLy7NoAcAfhgohip43SUFF6X8c8JuVK
	E1MfPsnwYyTGo5CM1+eE7MBZCocE71Q=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-tzY--79qN_6mAMQY2I00NQ-1; Fri,
 30 Aug 2024 07:05:13 -0400
X-MC-Unique: tzY--79qN_6mAMQY2I00NQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 841861955D54;
	Fri, 30 Aug 2024 11:05:11 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D418B19560A3;
	Fri, 30 Aug 2024 11:05:10 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id B3E191800D40; Fri, 30 Aug 2024 13:05:08 +0200 (CEST)
Date: Fri, 30 Aug 2024 13:05:08 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Yiwei Zhang <zzyiwei@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cbyuzdn.fsf@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

> Necroposting!
> 
> Turns out that this change broke "bochs-display" driver in QEMU even
> when the guest is modern (don't ask me 'who the hell uses bochs for
> modern guests', it was basically a configuration error :-). E.g:

qemu stdvga (the default display device) is affected too.

bochs-display is effectively stdvga minus the vga compatibility: no text
mode, no silly planar video modes.  Only linear framebuffers in xrgb
format are supported.

Both devices are handled by the bochs drm driver.

> The CPU where this reproduces is fairly modern too (Intel(R) Xeon(R)
> Silver 4410Y, Sapphire Rapids). I wish I could give additional details
> to what exactly happens in the guest but I can't find anything useful in
> the logs ("WARNING: Application 'org.gnome.Shell.desktop' killed by
> signal 9") and I know too little (nothing?) about how modern Linux
> graphics stack is organized :-( Cc: Gerd just in case.

The device has an (purely virtual) pci memory bar for video memory.
The drm driver allocates buffer objects in this video memory.  They
are either used by the kernel directly (fbcon case, which works fine)
or mapped into userspace so the wayland / X11 display server can
software-render into the buffer (which breaks).

take care,
  Gerd


