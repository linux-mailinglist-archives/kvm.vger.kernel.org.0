Return-Path: <kvm+bounces-69018-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yME3IEDSc2kCywAAu9opvQ
	(envelope-from <kvm+bounces-69018-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 20:55:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D9A7A5C4
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 20:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BD9FE300614E
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCFB62D5408;
	Fri, 23 Jan 2026 19:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x8zUkbQU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5080299920
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769198141; cv=none; b=hzk+mQk7eVpCVH9Y6lQ/gKsAPkM+7+Nacr+V7yRkVNnrQ1+a8f+xtlqHUMPYjslHYdu8vEymCRVixi1F/kldo7rWn9T3tg4SMP+RRqhdPT6Hsu9r+RuHc9FekEhADuiuWuVxfP/CRCIWUxQwZfWPuVLGS50p5kb9rS39km08gV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769198141; c=relaxed/simple;
	bh=/iHTAtlUfKZ7bjqT/eoeDMP7AxJkXO/6TW0k6Ct13JI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZwLU+LEB3yf3WdYN86RcsYSWALidkmKjtQr9NkHcuDsBSUUiQn335OEQovTZU9AgDC0QdwRzEH4JYTAzpIpQqXaTSIVUr5Gw27dnjydfJSFk5NHzYeGB08RNji4PsCmIhthsw77vuZBFSKybxYntXbCQIz9zSQntIjZRgZd70X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x8zUkbQU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c552d1f9eafso3861122a12.0
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 11:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769198138; x=1769802938; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7oUCISiugP7Y041nkb2bRCMgZt2WzvvJ4k3wS41Ljo0=;
        b=x8zUkbQUGNzNsJOtHO1xpqpavY+3dAG4J5+TTIruxiJdwDVbhYNNiDeBcUzeLIhmPa
         RdRZ9ATMqazA1CwK2kW1piMDZ12WJJk4LY0TFAsX0uTd4oevX2slivntYX4ss5ZsfVti
         ZgYZQZke4A9Bhb4Qsayigf7cKRJf0aA/myK1ooqmkL7o6nPHFx9uDROddDzQ47uWVKUy
         89RgDVMbZf+5MVWKAX+llAFAiitB4eH839JXyDS9OiZLAD2nl21expWJhzNPkrLnfUCh
         NyyiXD1pJua5TYkfzO0U2POinib1EZCmm8aj9uOkSth1ndtn560dVI88dt6cB3Mkd2FD
         ZcUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769198138; x=1769802938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7oUCISiugP7Y041nkb2bRCMgZt2WzvvJ4k3wS41Ljo0=;
        b=w+HALQZM14WnlZ+T2hOWmBWren7QYaB+sI7iQ3OWmkI1BI3pldZezfkMXPvIzt0owN
         MDC41+eDF8nSFt+dI6o8jv8TJQ8YTN1K0mmg+t2p3eNkaRx7HDncL9ExCdl3lVAC95lM
         wsP//JKwrI9Z1ow/15+HFyMPYpyJy1SAyyeI5lCSJ3GW+hXo7yIbfAald6UIlFkis8yb
         +QeyJL/72mFrliEyzhkRJcuGNsdBp5wv6a4q0hrLd6d8Wn++qIhg5SvgDl3gshQ/+IW2
         3m5jOVw6tpojqjZd0KH5w0z8iBU2DbT1epmtKyTH8jDvrFdtesYm3TA5NfOmp2yUZpY7
         43SA==
X-Forwarded-Encrypted: i=1; AJvYcCXt6UQYC6ls/blswq60Gn09JTfiX8AeFNmj7R+dbBSO0CbFDYGOhgKVtbjEh+76mQ3SvYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKEbl56qT+VR59DwlTkofTb2UCozdyGmLRKZOIoT+PShRPMDmr
	TdNP++IAEwsRy5h6gjHKb7tZhVZm6GOB9bUKp3CYCfLt9SSGUY6kYInlnnrkmXCFkudnT7WyeeW
	DeXSGXA==
X-Received: from pge4.prod.google.com ([2002:a05:6a02:2d04:b0:c0e:c1b4:51a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7484:b0:364:144a:d21c
 with SMTP id adf61e73a8af0-38e6f70c5d7mr4592927637.26.1769198137865; Fri, 23
 Jan 2026 11:55:37 -0800 (PST)
Date: Fri, 23 Jan 2026 11:55:36 -0800
In-Reply-To: <aXI1EAolDjVbp_9W@blrnaveerao1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1752819570.git.naveen@kernel.org> <26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org>
 <aWf0zQ6vA0Hmon2r@google.com> <aXI1EAolDjVbp_9W@blrnaveerao1>
Message-ID: <aXPSOMClTeRKG0_V@google.com>
Subject: Re: [RFC PATCH 2/3] KVM: SVM: Fix IRQ window inhibit handling across
 multiple vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69018-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 53D9A7A5C4
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Naveen N Rao wrote:
> On Wed, Jan 14, 2026 at 11:55:57AM -0800, Sean Christopherson wrote:
> > I also want to land the optimization separately, so that it can be properly
> > documented, justified, and analyzed by others.
> > 
> > I pushed a rebased version (compile-tested only at this time) with the above change to:
> > 
> >   https://github.com/sean-jc/linux.git svm/avic_irq_window
> > 
> > Can you run you perf tests to see if that aproach also eliminates the degredation
> > relative to avic=0 that you observed?
> 
> Yes, this definitely seems to be helping get rid of that odd performance 
> drop I was seeing earlier. I'll run a couple more tests and report back 
> by next week if I see anything off. Otherwise, this is looking good to 
> me and if you want to apply this to -next, I'm fine with that:
> Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>

Nice, thanks for testing!  I'll post a proper series later today (or early next
week), and will wait until after the merge window to apply (a little too close
for comfort at this point).

