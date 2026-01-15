Return-Path: <kvm+bounces-68183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BBFD24C11
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 14:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B6610303B444
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 944F739E6F9;
	Thu, 15 Jan 2026 13:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7nl3wcF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A3B20C029
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768484158; cv=none; b=gQUMYtPR21vPDVZcyFCoHXr4JK5Eo6N7OCFo7oRAd0nGqiN+WUb7FV4VUOn+15Z7m3zu6rh1Ekx3rlE3NaN+7qNEUVUcSTJzNIW7Y3v2BCUSxtnmZEUN7uzIxbTx5eQXEo+4HDewGnY+rXGC+6XRDJbr/+KHGbT9PI2C6LCZ13A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768484158; c=relaxed/simple;
	bh=3xex3gdbILdh+bpwy4d7F0ol315kRKSgMBIMtrZo5Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJbUidfHE9w1uxH5TcMdbRVpVLVbMkbotz+o+sUM0G9Lmto0/QV15CSBY9QP2WvrIaYvCE5SFy/SEyKKMB1+yiRd8VvCmKy8m+u9vt15X1JPhZlfDGPi+p2EcpJabrxHxOfiJ3NIhEs5LBg6RUFF7voOo2sqwvteUMbu+LtivYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7nl3wcF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768484156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KK578V5KZ67C/SipG2IvCY3oGt7pJx7DvxiYhNEVA4s=;
	b=A7nl3wcFGPBNmWM6If+Qi2I8F6khP5eTGftweA5SbiHixKk7kSVyUhwlBkVDX91MZiu7DX
	9oMj2tsZK/JfrZ/jnXvui+hBnWxBam3wFtddn+9JtfaHR/B6TlPA5H7z74XyFUREJsJFoO
	pa3TFbc5LFU+VyfQr1Qa3GiMgZQVWA0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-350-v7NE_fG5MSKZNFrZJZ7dWA-1; Thu,
 15 Jan 2026 08:35:53 -0500
X-MC-Unique: v7NE_fG5MSKZNFrZJZ7dWA-1
X-Mimecast-MFC-AGG-ID: v7NE_fG5MSKZNFrZJZ7dWA_1768484152
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C2B2180047F;
	Thu, 15 Jan 2026 13:35:52 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.56])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 139D2195419F;
	Thu, 15 Jan 2026 13:35:51 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id C451F18007A9; Thu, 15 Jan 2026 14:35:48 +0100 (CET)
Date: Thu, 15 Jan 2026 14:35:48 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Luigi Leonardi <leonardi@redhat.com>
Cc: Oliver Steffen <osteffen@redhat.com>, qemu-devel@nongnu.org, 
	Marcelo Tosatti <mtosatti@redhat.com>, Ani Sinha <anisinha@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Richard Henderson <richard.henderson@linaro.org>, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v4 5/5] igvm: Fill MADT IGVM parameter field
Message-ID: <aWjrh9SYqSgvwyqp@sirius.home.kraxel.org>
References: <20260114175007.90845-1-osteffen@redhat.com>
 <20260114175007.90845-6-osteffen@redhat.com>
 <aWjJdGSOl0T9zEqK@leonardi-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWjJdGSOl0T9zEqK@leonardi-redhat>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

  Hi,

> > +    /* Find the parameter area that should hold the MADT data */
> > +    param_entry = qigvm_find_param_entry(ctx, param);
> > +    if (param_entry != NULL) {

> On top of that, we return 0 even if we don't find the entry, is that
> correct?

If we can't find the parameter area the IGVM file is not consistent.
I think it makes sense to warn about that.  Not sure if we should
treat that as fatal error.

take care,
  Gerd


