Return-Path: <kvm+bounces-31240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9886B9C18AA
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 10:03:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50EB71F21F84
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 09:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7BD1E0DC0;
	Fri,  8 Nov 2024 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CzAKBIYs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABAC1C8FB7
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 09:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731056584; cv=none; b=EsGgc1DwVavhg/DL1Dkq9hr5GXcytbwGZ2B8YBLkN4OAYOKeiHPsUpQce4yS8BAqHFfxFTbCiubjnU5EtxZrrb4a7cQZSLk33/Cuh9Y1mAkFmTHwW8R/oF5/ypnXAR6KWjIGgINFHQIiWArlhbLjNzDBXBBo8TFk9eBkFZNERyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731056584; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUJSFjm/MHH7kJXk7HYLZ1Yv0QLYEromyh32nCFUodfNavI7sMY+ZShi4tIIKKqptdbsLlcJ3Rb6IEnOl6xXJO0v6PJUYbx2Mg8KrtnKkZOKZa5UOUsqHGIPqgoyaCqaJjk1Vb+w0Hj/UDrBB1wT1mQzPpa3mmyCLtOdWDoXLEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CzAKBIYs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731056581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=CzAKBIYsJaFp6d0C57sBHBnfXUi81OQcBIDVTYgDisqF+3PmAhqmuiTQn+MDGG2ylxAqwU
	0COyFN5sYgXPI+Wr6vEkvQwLE1rFGI/iSo2FnwPesLMV+MztKDu8q0x0nha1cUGah6w1et
	XBCgcc/XKzqW0Dt/+BmeNcMR0cIt4+w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-5hdWNaeuNf6vdLl1mQaSbA-1; Fri,
 08 Nov 2024 04:03:00 -0500
X-MC-Unique: 5hdWNaeuNf6vdLl1mQaSbA-1
X-Mimecast-MFC-AGG-ID: 5hdWNaeuNf6vdLl1mQaSbA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27B091956048;
	Fri,  8 Nov 2024 09:02:59 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 45F6B300019E;
	Fri,  8 Nov 2024 09:02:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Yong He <zhuangel570@gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Unconditionally set irr_pending when updating APICv state
Date: Fri,  8 Nov 2024 04:02:52 -0500
Message-ID: <20241108090252.5439-2-pbonzini@redhat.com>
In-Reply-To: <20241106015135.2462147-1-seanjc@google.com>
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



