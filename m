Return-Path: <kvm+bounces-23996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D88C395067D
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9625A2862AC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 13:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3588319B5AA;
	Tue, 13 Aug 2024 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7TwsmsW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0744119B5A6
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723555764; cv=none; b=UDl8meopvMiNJmw6tvRHQYcDMfWYGU98ENlKhAnTsNACrmfta4H0bPXaG1QV1ZiCY/rAo6utHD02ThRkr7T+V2hlMspRJ8HpOxNg6+nDrf2MQe3euyLRY3SahMi9F6CVTH5H6x09L8usUPuHQj0az80IbgUFdQzjJv+cZx+UBN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723555764; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbEDIwBgs3+zI8Sis+yu8WrJTBN9lOyjFIR8/ZI5yfL6Xcyn9k9FLZC2DjEe46sXCV6zBovx7A3k66mta6WEgvZh0y/Ei3PjC5aE6/o+QVsbgPtSiC5pYU0Gs7qmenevflptEAzI4dO93D2jdXc3/UOh0pt1hFLq/g+nO4og9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7TwsmsW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723555761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=L7TwsmsWld4ECkk0gI5ZLmm1CyB9oOMLS9I7xDHookF7FFLK4K41c8eP4C9CQiqtA6bAnj
	N95jxnBBiM737+BEm7Hvdlmn3QariPvTxGmbHGw9+UyO3JgYujvSdYICcsbGQHM2uP5pmh
	Z+Q/Yyr+8xl8sr6+nommQGoL2M7+sOk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-mw9b2aXWNi-E2TBNlX91Mw-1; Tue,
 13 Aug 2024 09:29:17 -0400
X-MC-Unique: mw9b2aXWNi-E2TBNlX91Mw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34FB91956095;
	Tue, 13 Aug 2024 13:29:15 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE91B300019C;
	Tue, 13 Aug 2024 13:29:12 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: vkuznets@redhat.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] KVM: x86: hyper-v: Remove unused inline function kvm_hv_free_pa_page()
Date: Tue, 13 Aug 2024 09:29:11 -0400
Message-ID: <20240813132911.133380-1-pbonzini@redhat.com>
In-Reply-To: <20240803113233.128185-1-yuehaibing@huawei.com>
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



