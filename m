Return-Path: <kvm+bounces-32110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E039D317B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 01:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C09211F23353
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 00:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F82A939;
	Wed, 20 Nov 2024 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O6VD+/b+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F3442F
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 00:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732062946; cv=none; b=QpyDuVKMJLWQIEP1tvam+3Y6I16upI+T7kWvH+kPSgwiHBiB/r5gTujTWTijV6mXADul8GEeEnMzHNgIRndGMgVW2Ygf+omZ3buN/xCYd8BVbH722VJPQ/U1ILHU/RvvxCfq2IjsBwkktYFn9YlSJKUyuEjLBXqVdP8HwkV0Sbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732062946; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsPFEsvsovf3JjSAMSTUAmIjUUU8K8DcBlV+49umMWZ4e+XDUJFcOSAcoSvJsiO8XLrfQbmBhA0f6uhc4gcgi8yLptG9AjPSZ3EaK7di89kjSZb4xDmz182IJ8HqDFXwhDAHEXrBEmFWR5etHkM0V6Q5U3VuJYLG5ZduNAt2fPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O6VD+/b+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732062943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=O6VD+/b+uJiiOiuxTXDWpfrR49VQxSYNMZNtgIjnAhItTWCV3Zz3OzJHZ/JwQsxC/9mxlp
	cQ7IQZ2OGN57+R1HVyLFuTDaGq9Jtn3NKPXDww04kqiaYduTndmMM6sTM6V9pVarERBg2F
	HX70OhCiSeasNSFPaGrEypDaW8lXYKc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-94YH3BFRP2aMgGL3TBRBsw-1; Tue,
 19 Nov 2024 19:35:42 -0500
X-MC-Unique: 94YH3BFRP2aMgGL3TBRBsw-1
X-Mimecast-MFC-AGG-ID: 94YH3BFRP2aMgGL3TBRBsw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8919E19560B2;
	Wed, 20 Nov 2024 00:35:41 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99D6A19560A3;
	Wed, 20 Nov 2024 00:35:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] Revert "KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()"
Date: Tue, 19 Nov 2024 19:35:37 -0500
Message-ID: <20241120003538.78187-1-pbonzini@redhat.com>
In-Reply-To: <20241119011433.1797921-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Queued, thanks.

Paolo


