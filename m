Return-Path: <kvm+bounces-42644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 421E4A7BB1D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30740188EA42
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CD8B1C5F07;
	Fri,  4 Apr 2025 10:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+di4Hyu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5EBB672
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743763278; cv=none; b=I29LgXZorduYbbNQOxBsDUl9r2INlxDuNXGLhfjdPavajJw3IP2mjSIPk8qB+ee6sF4bf8DLYYfote1BeRN3aQb5FIoPS0QWZmRDyIkYMhJG8x9x24d/vgmCtKwvU/VdQzNvfqDJO11umb6WFwPWKBjXGzluiaOssNdnoPwqA5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743763278; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5sok9BbB7xsnUwzD5MADirJbo068v+WWw23An55vKWSl5h2GdSnIQlHc9w1qg6PIJr0i8Fg2Es006BbtfQU4NlAVqXfuVyHolUaeGDnBNMdSWl2SOBGl4ALRxqxu5nM8iIMlQgJQ99BCtpIR95vBlcHIRpV9ijUUhuhmFp/x3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K+di4Hyu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743763275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=K+di4HyuZ95H9WFgbinzj89DGMTs90M3+ggss+mGaH97vau1zlGxtTQdJ79po4tleWecvg
	PZyBlRiH1+l8BHoyWFN+TPWB/EmR1hUv+rXTWXzt0TJUnhnhm2RhniU5NQnMR74VbbJoiM
	8eyE+TUwLVwox1orGgpbHEd5UIsOt6w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-RX6RD0w9MKSLnEL5vcsbbw-1; Fri,
 04 Apr 2025 06:41:14 -0400
X-MC-Unique: RX6RD0w9MKSLnEL5vcsbbw-1
X-Mimecast-MFC-AGG-ID: RX6RD0w9MKSLnEL5vcsbbw_1743763273
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0A8718001E0;
	Fri,  4 Apr 2025 10:41:13 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 03C241955BC2;
	Fri,  4 Apr 2025 10:41:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Allow building irqbypass.ko as as module when kvm.ko is a module
Date: Fri,  4 Apr 2025 06:41:10 -0400
Message-ID: <20250404104110.188205-1-pbonzini@redhat.com>
In-Reply-To: <20250315024623.2363994-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Queued, thanks.

Paolo



