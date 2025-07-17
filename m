Return-Path: <kvm+bounces-52737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8171FB08E47
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 15:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78EDA179CB3
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 13:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E652E62B7;
	Thu, 17 Jul 2025 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKsDrn6c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8452E6116
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 13:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752759080; cv=none; b=Go8R2j6wPpP0VKFT6ruoUxrET4CI0byUoB6m8t0tHeOAsONYlzKOfYgXDoUt0Kd4PPLvY2UNfQyQQ8k3G3grC72FFNB7gCbFW7RHXJE3W7UNasWOs5P7NPtlYiy71yO8GOVKgiLcKXs6NQqhfD8k8Pk62KDMdzyAQOLLekd986o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752759080; c=relaxed/simple;
	bh=GK65W7rCCP6PYZFGXbMxCGBPgIK/98u7Jbpr258sYms=;
	h=From:In-Reply-To:References:To:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=LJwb7lk3drY5Yys833Xd321R7WTousGOki7KtsUe9HOfsfq7tocATUSZrIgPkK3ic5NbisnffK1ijRg0ZGQRcE8KPiEpQ7kaKuPbe4vGozivlS4K8evdB1HBf+qfOgSY7fbQnKbmFS7L/OmEjCQR8s2HpmW3zjTmBXrg5fTYMJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKsDrn6c reason="signature verification failed"; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752759077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KEycMEjSIHuMJWfbML+0v4uxeifaLK0H8rWbOjaZJzo=;
	b=eKsDrn6cWG+Zbs1YxlpJKLeK94eeCnPIOqRdPEfAJTx1sveZE5lwH6ijg6ITRXTWGJK1Xa
	vhWwIX8tv2ZOE9ORLdzxAaCG9PjPltjsvipZ4MaKaVkXmlk8mXljQbF0NQ59xXWLaF5dxs
	M654y6/uGJ+YijZzY13qU5UZTDl0xzA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-318-GQRGT67gPK-ToQzamFnUAQ-1; Thu,
 17 Jul 2025 09:31:13 -0400
X-MC-Unique: GQRGT67gPK-ToQzamFnUAQ-1
X-Mimecast-MFC-AGG-ID: GQRGT67gPK-ToQzamFnUAQ_1752759066
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF89319560B3;
	Thu, 17 Jul 2025 13:31:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3729C18003FC;
	Thu, 17 Jul 2025 13:30:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250717080617.35577-2-bagasdotme@gmail.com>
References: <20250717080617.35577-2-bagasdotme@gmail.com> <20250717080617.35577-1-bagasdotme@gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
    Linux Documentation <linux-doc@vger.kernel.org>,
    Linux RCU <rcu@vger.kernel.org>,
    Linux CPU Architectures Development <linux-arch@vger.kernel.org>,
    Linux LKMM <lkmm@lists.linux.dev>, Linux KVM <kvm@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
    Frederic Weisbecker <frederic@kernel.org>,
    Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
    Joel Fernandes <joelagnelf@nvidia.com>,
    Josh Triplett <josh@joshtriplett.org>,
    Boqun Feng <boqun.feng@gmail.com>,
    Uladzislau Rezki <urezki@gmail.com>,
    Steven Rostedt <rostedt@goodmis.org>,
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
    Lai Jiangshan <jiangshanlai@gmail.com>,
    Zqiang <qiang.zhang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
    Alan Stern <stern@rowland.harvard.edu>,
    Andrea Parri <parri.andrea@gmail.com>, Will Deacon <will@kernel.org>,
    Peter Zijlstra <peterz@infradead.org>,
    Nicholas Piggin <npiggin@gmail.com>,
    David Howells <dhowells@redhat.com>,
    Jade Alglave <j.alglave@ucl.ac.uk>,
    Luc Maranget <luc.maranget@inria.fr>,
    Akira Yokosawa <akiyks@gmail.com>,
    Daniel Lustig <dlustig@nvidia.com>,
    Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>,
    Waiman Long <longman@redhat.com>,
    Paolo Bonzini <pbonzini@redhat.com>,
    Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
    "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
    Changyuan Lyu <changyuanl@google.com>,
    Dan Williams <dan.j.williams@intel.com>, Xavier <xavier_qy@163.com>,
    Randy Dunlap <rdunlap@infradead.org>,
    Maarten Lankhorst <dev@lankhorst.se>,
    Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 1/4] Documentation: memory-barriers: Convert to reST format
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3830638.1752759048.1@warthog.procyon.org.uk>
Date: Thu, 17 Jul 2025 14:30:48 +0100
Message-ID: <3830639.1752759048@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

I believe memory-barriers.txt is often referred to outside of the kernel and
should retain that name.  Maybe that's no longer the case.

David


