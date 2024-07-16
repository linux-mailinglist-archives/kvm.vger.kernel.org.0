Return-Path: <kvm+bounces-21714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0309327E3
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 15:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06AB81C22812
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 13:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D128B19B3E4;
	Tue, 16 Jul 2024 13:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iEH9sfuN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD4519B3CB
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721138280; cv=none; b=Y+S0W9MK+meyvKHbJsV+vTGNoRrMGa60ay7VCKnfX8C1wkpp1qP19mP3HXMDG6OXPyg4nA7XgL5yb0+60cOWh/GR/2qeXoUyiZ8Pc29xXPMNmpoV+aFAomgbSa6kvrtUSBy+0zkqI27B9cbDjcQ2pgrtooMnhzd/lfGZQ31BLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721138280; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgTLi3UOpZZNHYfmHv3kIlWrzcZkewqcsi1d+ph+2Iod1sVrYKkhiK7IZAQPTp3ZPNhrdx/T3XPxvS4Yn/cQIE+couFQqaaKcOT9qyquTc2JZkiKTbbMuetPt7PSrhF7kL6AF6nne2En1NB1a6pi5VgrnTfH5Km3NcGABmlIqBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iEH9sfuN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721138277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=iEH9sfuNExWOfppPeijV2GFO+3/KSzUv2jVoEfdA/1SJ8IYuHrDi7nPS9vLxgkTpIAQxZ0
	7pEsDhfdSCWn0QCiXlxFXeGh/qQKxqyk2DervxjZUiSiavOI/TohvOoh6x5my/0yaYxas5
	UXdx0HNfTBKdwZMol52Jho0nlfimzhM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-379-9bHCi2seMHqcoTRAXG8wtQ-1; Tue,
 16 Jul 2024 09:57:56 -0400
X-MC-Unique: 9bHCi2seMHqcoTRAXG8wtQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEE3F1955D54;
	Tue, 16 Jul 2024 13:57:54 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BFBA1955D42;
	Tue, 16 Jul 2024 13:57:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+2fb9f8ed752c01bc9a3f@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Suppress MMIO that is triggered during task switch emulation
Date: Tue, 16 Jul 2024 09:57:49 -0400
Message-ID: <20240716135749.70129-1-pbonzini@redhat.com>
In-Reply-To: <20240712144841.1230591-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Queued, thanks.

Paolo



