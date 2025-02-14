Return-Path: <kvm+bounces-38207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1405DA36927
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C57A41890E96
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 23:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633C91FDA73;
	Fri, 14 Feb 2025 23:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GI0py/Rg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019391C84D9
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 23:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739576517; cv=none; b=mTNyj+Vsm6eLHzo+xW8h79hqlfC5mgHgdcbexbPEWGKwBpwMApV3fteUG/qTUWw5/V8UqAvj7yJXuMbRI3XY6VygfsP1xfEqQqJaHrImFyyPlWvsqtvybJsIuKj8kKINIjj/j8K/OysArE7lruVmcDt1LeRQJ2HDyFHVTgcHQjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739576517; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMbGSG+KFYci+vfgabho8prX8JoyDXn9kGAxFN3Zz1wdi17p7A9o0w0w3UcZ2vtSbVlbb27eI1Vr7TKbj4iPZR6MC1bpg/MFS52rOF5wGCZJ8lVtCGmkCw66h/eOS90QyylH5D5VNFLBsCWi3Nn7XgJiCir7jvBxNrKJ0+l7rYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GI0py/Rg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739576514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=GI0py/Rgqgi4RL/vyrulIyy0THSBSHCN8W5z+2ZWW0Mg3ubXfYFz9i6PPd789liA1HulTW
	llQXG3cJH3u5EmcOvt5jycasnnB38RCAe3rf2R/loM995j1S/7qtQOEbW5CPysAKeth8nC
	DMYnaceLK0c0Es/O6Y5QpA/apaQC6fM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-9P3SI80JMEmV33ESfQD9wA-1; Fri,
 14 Feb 2025 18:41:50 -0500
X-MC-Unique: 9P3SI80JMEmV33ESfQD9wA-1
X-Mimecast-MFC-AGG-ID: 9P3SI80JMEmV33ESfQD9wA_1739576509
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF60118EB2C3;
	Fri, 14 Feb 2025 23:41:48 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 05E051800365;
	Fri, 14 Feb 2025 23:41:47 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	John Stultz <jstultz@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Load DR6 with guest value only before entering .vcpu_run() loop
Date: Fri, 14 Feb 2025 18:40:58 -0500
Message-ID: <20250214234058.2074135-1-pbonzini@redhat.com>
In-Reply-To: <20250125011833.3644371-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Queued, thanks.

Paolo



