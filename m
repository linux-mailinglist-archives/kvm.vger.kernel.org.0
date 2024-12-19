Return-Path: <kvm+bounces-34149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 548B29F7BE7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32FE77A04D8
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 12:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DE4224B1A;
	Thu, 19 Dec 2024 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fZVHntix"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9B1221DA0
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 12:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734613103; cv=none; b=Xt5Pi2VxYJKhcAfNhzUu4hDjKULZGwsMHFAPAFdOpact4dl+AK+jxwg6pYGzuvWztoIRHWTTniykX0wNjpNsHIjJXpqkyub1BqpqqHXR45O/B/8bapDBF7PBs0MOLxioOtLQc5cbsDoQrLKneEke64fXj7rU5M8HG6sirbjtl3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734613103; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OielpdeEF/OAgVKKnsBA8wkYnlpCZ57tIO9OUdCVPJetW90cTIAM/qQzhQcCTp/AnfbSteliULimGU62CIE6l/kTxgGHDc4/nPfwYd3Xwju4mfMJjp51FVf0KAIUTo8cycoXARoAmrsWUFSUnh1zQtThzC+JLIezkTyQ8LnOCKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fZVHntix; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734613100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=fZVHntixPiugNYV5qAFmIRCKM2XnQRanjSfSlR+QpkD8Dek7lovfBXyccG6xHvz2LGUR/u
	+IoKqieOZeHtgkj1l4QMMnlY/1YgzWLCHu3a3YAkdkqMutFEOl0Nij9AB9OQhKV/QaYpwV
	dbsEsICXRfaXA+0fc050C7Z35VcrwRU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-ji7Y6Uu9NR-ZGGccbWK40w-1; Thu,
 19 Dec 2024 07:58:17 -0500
X-MC-Unique: ji7Y6Uu9NR-ZGGccbWK40w-1
X-Mimecast-MFC-AGG-ID: ji7Y6Uu9NR-ZGGccbWK40w
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75F4D1955F2B;
	Thu, 19 Dec 2024 12:58:15 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 539821956053;
	Thu, 19 Dec 2024 12:58:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: don't include '<linux/find.h>' directly
Date: Thu, 19 Dec 2024 07:58:12 -0500
Message-ID: <20241219125812.326562-1-pbonzini@redhat.com>
In-Reply-To: <20241217070539.2433-2-wsa+renesas@sang-engineering.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Queued, thanks.

Paolo



