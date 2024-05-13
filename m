Return-Path: <kvm+bounces-17275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1235B8C39BF
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A69801F2114C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46515D304;
	Mon, 13 May 2024 01:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QF7e93kU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CD4C9F
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 01:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562404; cv=none; b=mrG1/QJ8FgQI8YEtCJQYXad5vmPLtqY73x6NFIXiPBPkOanbxN6Bhuqo+nzWgOe1VCErCbU42H/d7UoEdJ9/5qzCdX1BG1KSp9jt/BbAjzNyJoJ0/gzcF3PBUMqYMlJgoc+rWrb8RLG6vkUTj2UQd4vdtkLVUBiVYdFzeAPSnK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562404; c=relaxed/simple;
	bh=ezi5JG5jGeRIMP4maaRmb26rGRyip+vMxbnGTkqsVGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFIuroBN2ijTyk0BCAY0OK+OdiW6I4kSelMW+JbHeyTfbZrf7vU+IrqaQ7N2UZp3KFIWpZn5UVho1bB8Q+JiE8dKtPW0Af+qLstt63kicrsbPAFpr4j6VWoVmx39dvc9obkw3MrrvzNIhPI2ayetyB2fGwHtG+YeF56Glot8jxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QF7e93kU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715562401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6MyrT71GcyLYykYsEHxxBn+570CfbXvsmsIsSXNOh8M=;
	b=QF7e93kUdFtvz7My+07zxm/ltJY/dNPIAtUWYNgW7GfEL7tEE0tvi7PK8/TqqjDlp2hmTg
	btSCXZlCmGXWNOWZxr6xcHuEQVtjunvpq8P/lyFLr8C8p4drA+E1q+//kImibwy5wZgLYN
	66wgnjtT5MaDBO4UhbR9mHXb5Et+ZAA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-8OscVjmtPX2G7pk1n611Vw-1; Sun,
 12 May 2024 21:06:37 -0400
X-MC-Unique: 8OscVjmtPX2G7pk1n611Vw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3B551C05149;
	Mon, 13 May 2024 01:06:36 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.2])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB61B40C6EB7;
	Mon, 13 May 2024 01:06:35 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 0C35B400DF3F8; Sun, 12 May 2024 22:06:20 -0300 (-03)
Date: Sun, 12 May 2024 22:06:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] kvm: Note an RCU quiescent state on guest exit
Message-ID: <ZkFnjDZRB2x/tzVt@tpad>
References: <20240511020557.1198200-1-leobras@redhat.com>
 <ZkE4N1X0wglygt75@tpad>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkE4N1X0wglygt75@tpad>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Sun, May 12, 2024 at 06:44:23PM -0300, Marcelo Tosatti wrote:
> On Fri, May 10, 2024 at 11:05:56PM -0300, Leonardo Bras wrote:
> > As of today, KVM notes a quiescent state only in guest entry, which is good
> > as it avoids the guest being interrupted for current RCU operations.
> > 
> > While the guest vcpu runs, it can be interrupted by a timer IRQ that will
> > check for any RCU operations waiting for this CPU. In case there are any of
> > such, it invokes rcu_core() in order to sched-out the current thread and
> > note a quiescent state.
> > 
> > This occasional schedule work will introduce tens of microsseconds of
> > latency, which is really bad for vcpus running latency-sensitive
> > applications, such as real-time workloads.
> > 
> > So, note a quiescent state in guest exit, so the interrupted guests is able
> > to deal with any pending RCU operations before being required to invoke
> > rcu_core(), and thus avoid the overhead of related scheduler work.
> 
> This does not properly fix the current problem, as RCU work might be
> scheduled after the VM exit, followed by a timer interrupt.
> 
> Correct?

Not that i am against the patch... 

But, regarding the problem at hand, it does not fix it reliably.


