Return-Path: <kvm+bounces-43344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED47EA89C90
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 13:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA78116E63A
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F9628F515;
	Tue, 15 Apr 2025 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZG3kuZ5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FF2275867
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 11:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744716773; cv=none; b=M9zDcG3y4h+3OGrDfnvgK4ufrXvaXNzbw+zo4MbAP88YO8UBrMkFy2LtEEIinhitzwCtZHRSj6qJzQu7wacPJpljpzWM3XJNJgLboI02q1ddmYFv8s2NRh4ZHRQW1UZ37E2xQ/uIqhVSSip41O9rWC2a6+mQr1n8DdYJqT/GQ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744716773; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iidZ7aeVfcgrjLgs1dCVJpYsHqTkZbXdhz+/Ezgq1U+Sv6dUN2XZjuVoFm+Rc7RSwXDwK+a8/l52RVoy2jvsQypPB/CknclXz9DcMuOa89uog861CrTTimdIIyBhG0Qeop8rzRVfj/82EilDKPSclawmyKjQ0QJVy/GPsTNzmxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IZG3kuZ5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744716771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=IZG3kuZ5BUsCh/TAET2gb2s6LaKn3ztL+qiMBme8T86u/WcK4hnCE0r7CTbCEukOF3/xA9
	Q3Ser2QxoUGBmCWI/LuEsqjoz0GS40WAEcuhI96aVGrpOuokXSe+bvH8DoYU/K+Tijt2lz
	B1wflsFJpNTqs1czaUxN8UhQ4FcRdUk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-ZRJ3MaDwNpax-opShLQo6A-1; Tue,
 15 Apr 2025 07:32:46 -0400
X-MC-Unique: ZRJ3MaDwNpax-opShLQo6A-1
X-Mimecast-MFC-AGG-ID: ZRJ3MaDwNpax-opShLQo6A_1744716765
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A578419560AE;
	Tue, 15 Apr 2025 11:32:44 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45FA1180176A;
	Tue, 15 Apr 2025 11:32:42 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: Re: [PATCH 0/2] KVM: x86: Correct use of kvm_rip_read()
Date: Tue, 15 Apr 2025 07:31:53 -0400
Message-ID: <20250415113153.214515-1-pbonzini@redhat.com>
In-Reply-To: <20250415104821.247234-1-adrian.hunter@intel.com>
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



