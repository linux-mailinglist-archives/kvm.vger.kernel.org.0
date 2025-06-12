Return-Path: <kvm+bounces-49221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44AAEAD66E4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 06:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 085C417DC9D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFB91E503C;
	Thu, 12 Jun 2025 04:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ge+WDk/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEA410E5
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 04:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749703455; cv=none; b=QdKjm8NbkVwgQOb5b4+XeidbkgbRlT9QAKod7e5Wjj19miX9/8+ovkGUqHXgQJHTX9W/kBfDGn5BEO9QKqJa4rGIoOLmnofnib16gjxJpHj3DFotHTvlFA4+hKEkmmSJH/OlEHijT0no/uECc4Ix9xlUYCnVkvyZDW0v0xvPq68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749703455; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pt+khz77YrmPTdCB2QABzWTnUys7x0bDuKJ5XQvxqaf3jX8buLXtaD9iKaMW3QRzhVOFoFZ+ulVCUP4fPMoQKatq5QiqWYq1+wLd3JlULbMJZUkH1kghwz/BznB9G6gbCbCMdIyzYSKdGIoTy/iNLERj2DFVI/rJJbN+SuJ7B9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ge+WDk/6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749703452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=ge+WDk/6Q71EJdEwSUNxNhllkx/ayaw4KN2D0Lp1oeAvufEtUFFY7od77xqqPwsF/bzxlv
	k8gljqPS7Wy6ZUMWt5wCMaR1ftYoRyxZB6oBDrSycZnIlNVXgSMjpHhzrcjtWL/8iGCNDm
	KRUCFNrbPjh5nmF31cFKRDoCmfEStIM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-Rqy1sf4PNNKlfeNWmV53CQ-1; Thu,
 12 Jun 2025 00:44:06 -0400
X-MC-Unique: Rqy1sf4PNNKlfeNWmV53CQ-1
X-Mimecast-MFC-AGG-ID: Rqy1sf4PNNKlfeNWmV53CQ_1749703444
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE0831956086;
	Thu, 12 Jun 2025 04:44:04 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 83726180045C;
	Thu, 12 Jun 2025 04:44:02 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	isaku.yamahata@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	tony.lindgren@linux.intel.com
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
Date: Thu, 12 Jun 2025 00:44:00 -0400
Message-ID: <20250612044400.151036-1-pbonzini@redhat.com>
In-Reply-To: <20250611001018.2179964-1-xiaoyao.li@intel.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Queued, thanks.

Paolo



