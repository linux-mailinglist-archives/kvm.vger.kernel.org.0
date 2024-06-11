Return-Path: <kvm+bounces-19301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E81C2903465
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 09:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 812F3281CAB
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 07:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD920172BCE;
	Tue, 11 Jun 2024 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="US+92s5x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8CD172786
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718092508; cv=none; b=D50RdgeT4B8azvznLKlkLB4ngOUihch9RM5nwqQY22oA1S5CbTnvZYJtpMxeSYnq5+FGusVz2oygauVVwjp3fuzdUvH4BtspaeHb2QZn+Vq+yG9OvH99p8HEcgNu8IN1Bk0AmaCFFOrE6phtjDTmQLjsnHlH46P/EL32r5T0CrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718092508; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MswgOQgt/sxVehtYuYGehwIQ89wZ6+0+BPwoaJJ3P8FY7fEul3UANnO8Rpt8x2WriAe0Phzorfzdg4A4+z+C8pawQgzJZwfN0Wt9jMcvAtH6SC7BhH6bw5LxINGJiMNAUVe+YOKF7D2tvsKgpuA16s/TovLgDwRBHn4nICujhtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=US+92s5x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718092505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=US+92s5xb25N+wrch/Yh7ZpLUhKU04UVfutOswHSKQzEcorzISL0x/tR/73aoCL2lqB9O6
	zzmFB08lWdXEdzDWF3C55ztIrLb6ejFdYwIo2H9Va7FkYx/GX4xrW3xxUyFHz+PxLWZS+v
	NOFJV5qRf74O83x7rs/EEh0nRL/k53E=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-3VmhZf0RNdeVdTkkifctkg-1; Tue,
 11 Jun 2024 03:55:01 -0400
X-MC-Unique: 3VmhZf0RNdeVdTkkifctkg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB85F19560B3;
	Tue, 11 Jun 2024 07:54:59 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9F6DD30000C3;
	Tue, 11 Jun 2024 07:54:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adamos Ttofari <attofari@amazon.de>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes
Date: Tue, 11 Jun 2024 03:54:56 -0400
Message-ID: <20240611075456.17117-1-pbonzini@redhat.com>
In-Reply-To: <20240611014845.82795-1-seanjc@google.com>
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



