Return-Path: <kvm+bounces-28426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9C9998731
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 15:09:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D513BB21B8F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 13:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F381C9EC9;
	Thu, 10 Oct 2024 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewFokfFi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2521C9B8C
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728565727; cv=none; b=pA7ZYdlgl5yj2du3GKOQf2TfbHO1ijp5TAVrraQuLk3g7JCAOIajv1u+uvd7uXaYhTUamlhdKHNeK1BWVl0H6Ifp2D7yeGU7aKUmuP+hl/zlg/0A4ItjFoGqMI6bxGG6Z1QLTP6l5E9GS/M2K+wnW1F4wM1Zk1BwZUqjNyfanns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728565727; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ha/PQ5/Sm9uGcIMtDLBeoeC3+Cza3xv0bNoGJjjVJ1r9W3XRaSY4R+6LFDEtOqN8lYanYgT7Bll5y1u+UFMXVrm7B4w5vFxYg1cD6dOkT6o+eIz7tUOO7W6/f5dA+ZU3uYcqUGR21JA43SlaX2+Az05UkmscrTGHp+rqfLoJr/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewFokfFi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728565724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=ewFokfFi//ElfH4gxyCm36x7mkk1BadD6/4tlT46sPY6s2qVfYLxNQvTKmru1rh2EtCOWW
	VviJxwceuXhWO5KHFjZqup7XpyUatOo7QVTIeYVJ4U0lmA8pf+apogHmd+uoMmTuUgq93A
	8wWqMrWK8XDVdyGnOjdHpKsIfHYc1uU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-xc5eKfdHPVem3F42Ju0kcw-1; Thu,
 10 Oct 2024 09:08:41 -0400
X-MC-Unique: xc5eKfdHPVem3F42Ju0kcw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC3561956048;
	Thu, 10 Oct 2024 13:08:39 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9C66300018D;
	Thu, 10 Oct 2024 13:08:38 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kirk Swidowski <swidowski@google.com>,
	Andy Nguyen <theflow@google.com>,
	3pvd <3pvd@google.com>
Subject: Re: [PATCH] KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory
Date: Thu, 10 Oct 2024 09:08:36 -0400
Message-ID: <20241010130836.244732-1-pbonzini@redhat.com>
In-Reply-To: <20241009140838.1036226-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Queued, thanks.

Paolo



