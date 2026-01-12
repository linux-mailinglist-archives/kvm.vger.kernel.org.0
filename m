Return-Path: <kvm+bounces-67715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CEDD11A61
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDB2D30428E6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF612777F3;
	Mon, 12 Jan 2026 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E70AKxDw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7833827B50C
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211851; cv=none; b=lly8l/h1jymP9gxH92J8oDnMfbXdHbub11aK6CnUqMJ9EIehJRuAY5/XYfpqMODAVjXkuJdG37QYFAOxEwU+DaMoRpwN1EDTtnzAPcBRT0yuFu1fGWG/YkvDpv66I88o06Xx+qrF6+ZOILbYYCEsgXd68+TOhKTSI8+xlQZRoMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211851; c=relaxed/simple;
	bh=R1X5Bg6OyLsS9pRaNNGF5H7jEcXAR+Vqy5xQ5xAg0oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZcsBzRfY+ZzwyuKjv7TFj/KFqJHKfJdfZpLFJOt9E5LJ5KAyZt1SVF78EMFE/lSjMHRncz0e/HpJdFMbaSGZbsaIhcwpFauvWygbXOTEx1LY6WeXBY+wPmcI6ev2wCu+1PjYDEOnVuiqQE7ajU+XySdF9nTUExmggidZ62zzvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E70AKxDw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768211847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP1As6bffZ8c1Tj6Ryzx1G3FlOBMhPc4mR5vcLY1XcE=;
	b=E70AKxDwQoguRIl55f2n5LX7f6ukOKkbmPYOb0r3xpwdKTIu1H8A4S8idjVO1yTCLlJ9LZ
	eCqOz0nghhfW6QcxZejb2KZi6CvyZ78hPcjyhvxJL3Ml2AYcnQ5bfD8U32pK6ulPbcjQyx
	8m67as9+8hoZBRTWIOdGIkkh5r7h2Tc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-zEntJDotN6elDZg89o8svg-1; Mon,
 12 Jan 2026 04:57:25 -0500
X-MC-Unique: zEntJDotN6elDZg89o8svg-1
X-Mimecast-MFC-AGG-ID: zEntJDotN6elDZg89o8svg_1768211844
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A331185FBDF
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:57:15 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.56])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A05E119540EB;
	Mon, 12 Jan 2026 09:57:09 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 96B471800081; Mon, 12 Jan 2026 10:57:06 +0100 (CET)
Date: Mon, 12 Jan 2026 10:57:06 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Luigi Leonardi <leonardi@redhat.com>
Cc: Oliver Steffen <osteffen@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
Message-ID: <aWTEO9LIPNbf9YMe@sirius.home.kraxel.org>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-4-osteffen@redhat.com>
 <CANo9s6muvcOrDH286o1zA06tRUvZBnOBqn03e0RiOEDC60W4sg@mail.gmail.com>
 <aWTBdSDO9KKpXLt4@sirius.home.kraxel.org>
 <aWTDQZT4L3mX3Rfd@leonardi-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWTDQZT4L3mX3Rfd@leonardi-redhat>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  Hi,

> > > IMHO this should be sent a separate patch
> > 
> > Huh?  It /is/ a separate patch ...
> 
> Sorry, I meant outside of this series.

Not needed, separate patch is good enough, even though sending a
separate 'fixes' series might make sense in some cases (split an
already long patch series, or during freeze where only fixes are
allowed before the next release).

take care,
  Gerd


