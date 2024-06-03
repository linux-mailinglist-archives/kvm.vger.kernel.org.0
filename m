Return-Path: <kvm+bounces-18679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AEC28D87AB
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 19:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C65FE1C22015
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 17:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC8B136E3F;
	Mon,  3 Jun 2024 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAi47d8g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4AB13213E
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717434522; cv=none; b=o0uOl2pNaX06xnn4j4rxFohFcSVVddVLT+jNWyQISAKcIHvLbhnMsEBAzj3xW+bAwLMRmykyNV1NjpuH+xkk1tYVC87KRCfPHcgwDA70TbNOJucz6Oiux9uPWtHT1l5ZkpbX3vmGxnsvqhgbCwd0vw0thDVC9942hrfHkCDiCr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717434522; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFbSOEVaFMf93lSEihnPBkUN9KT38wTNftjJB35d0OTF0yRfrXHIP2zuhKdy1eL0YrwvtJXJLp1+5Ai4E/8cH4qRMNtqfmju+vnxLt7JNnvCuBfDOY4auhS7dN6YoI92oPdhWaMByPLnG2XPoZxIEeV8DwGzzV6GRNXObwYCa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAi47d8g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717434520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=aAi47d8gn0z5VcIeAYs+auQt1vNpDA4itc0OWtO5kiEzekJHgoHxXxhvEN1DAdjSyiMsAN
	XJJjLr6cr5ilbXm9Hy2Hl1Xv7tb/ygdsWH6UtFaSrc0ml3lIEOBcKltB0S5lxNwbXZLYYm
	CFu29pKu4kQHf5AcaF7+w8tY33GMtH4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-aAiMCrwRMDO79DBJ0nncXg-1; Mon,
 03 Jun 2024 13:08:36 -0400
X-MC-Unique: aAiMCrwRMDO79DBJ0nncXg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F0B018BF6F0;
	Mon,  3 Jun 2024 17:08:34 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 684C630000C3;
	Mon,  3 Jun 2024 17:08:33 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuling Zhou <zhoushuling@huawei.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] KVM: x86: Drop support for hand tuning APIC timer advancement from userspace
Date: Mon,  3 Jun 2024 13:08:31 -0400
Message-ID: <20240603170831.12051-1-pbonzini@redhat.com>
In-Reply-To: <20240522010304.1650603-1-seanjc@google.com>
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



