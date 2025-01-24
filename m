Return-Path: <kvm+bounces-36555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F226A1BACD
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6632618878CB
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 16:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1F91A0B13;
	Fri, 24 Jan 2025 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aruBxrMy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A951199EA3
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737737033; cv=none; b=OilpP0BNufkP9G1iYJPivL6h2l+vVA0r/rRqz8HZe5OqmlSdY8PrDGSG9gxEUmyqSoZ6dpc63k+tQsq66He9nLYev3gP/jqcxjFjbtb05oUlcG/kYFHwk8HK4WfR3Dunwhlt9qvOniFPAVe9N0a9d/TGCCS+P6HRJY2sJQdoK+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737737033; c=relaxed/simple;
	bh=M0gUo6K+Yug351ge5kav4yGXMaVYaJQg3+ESkre66t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7J3wewPPo6Zbrs1SzcFME0hkdYm1ddHsm/hSab5eaofNHXo6wwKwRoXPmvKoi39BUzFFy1EqaRYJK3IWd1tndBIxPodTHdlyQGivJyU1hQe2ufH72pOUq9+0SLopkI9R/5SYqQws9AvhwCiMiIePSwb+uYGFsjqg/XayRhgNNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aruBxrMy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737737030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+a/GBdBpxGagHtsT9KFhBKvr7JZFccrGBu8wLCkI9O0=;
	b=aruBxrMyEzxGOxPLU6r32X2/zEE0t7f8Zi77OWGsZlZhzSrL7rYdT6q3/jMkKAOK88DYV9
	FI16pP8uXFR+kjZ6pnePY10Bn+4zvEHJmojPBAlkEzEp0c1TSQA/NT0GT1FtMnqxREtpGu
	vHAO3D8qrSK6PB4iw1HVOgJn+qJF5gg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-MsZoim5EOIOUmPA4ceIZJw-1; Fri,
 24 Jan 2025 11:43:49 -0500
X-MC-Unique: MsZoim5EOIOUmPA4ceIZJw-1
X-Mimecast-MFC-AGG-ID: MsZoim5EOIOUmPA4ceIZJw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78C6319997C5;
	Fri, 24 Jan 2025 15:30:48 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7065E19560A7;
	Fri, 24 Jan 2025 15:30:45 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Vlad Poenaru <thevlad@meta.com>,
	tj@kernel.org,
	Keith Busch <kbusch@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Alyssa Ross <hi@alyssa.is>
Subject: Re: [PATCH] kvm: defer huge page recovery vhost task to later
Date: Fri, 24 Jan 2025 10:28:03 -0500
Message-ID: <20250124152802.93279-2-pbonzini@redhat.com>
In-Reply-To: <20250123153543.2769928-1-kbusch@meta.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

> Defer the task to after the first VM_RUN call, which occurs after the
> parent process has forked all its jailed processes. This needs to happen
> only once for the kvm instance, so this patch introduces infrastructure
> to do that (Suggested-by Paolo).

Queued for 6.13; in the end I moved the new data structure to include/linux,
since it is generally usable and not limited to KVM.

>  int kvm_arch_post_init_vm(struct kvm *kvm)
>  {
> -	return kvm_mmu_post_init_vm(kvm);
> +	once_init(&kvm->arch.nx_once);
> +	return 0;
>  }

This could have been in kvm_arch_init_vm(), but then the last user of
kvm_arch_post_init_vm() goes away and more cleanup is in order.  I'll
post the obvious patch shortly.

Thanks Keith and Alyssa.

Paolo


