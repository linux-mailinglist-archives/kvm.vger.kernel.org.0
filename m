Return-Path: <kvm+bounces-70408-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLayKdFjhWl3BAQAu9opvQ
	(envelope-from <kvm+bounces-70408-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:45:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 44709F9D3E
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9760B302A191
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 03:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C4E334C1F;
	Fri,  6 Feb 2026 03:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b="BitVipMj"
X-Original-To: kvm@vger.kernel.org
Received: from jpms-ob01.noc.sony.co.jp (jpms-ob01.noc.sony.co.jp [211.125.140.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA1333730;
	Fri,  6 Feb 2026 03:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.125.140.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770349504; cv=none; b=HIbZd5rPUKwuaReS9h3xXin6Tq+0PiVm33KSXHv96EdX8YxHVlgl7CKQKV9eI6i5JFiYeRAEyvJeGOhKgZYRs7yNSXeBmxLSJkrYYdAPm6J4rYP9zSPvvoUKNarnwhjLXX8W8n9yitUbX+ED/fog+XfQ4BMMkp/P+65BxL8Jb+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770349504; c=relaxed/simple;
	bh=hnE5I4/wZ5Znpn5z3YA2kW21UHAlwuw/qzxayvYooEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aa5nF73T+8POQy1jc8L8SCighRKp2Rbf/BraY+A7WcZoPSYg0ruUhnUdCJKgRPzP0iMmHFVEn/6nXscXaUUaTDFUoRiWSn5YxGEqH1/Gn3vVX1buYZixxdbKmPoYhFqKHEL7qXMoqsmF6Sdb87Mo0ws9HZf813g+opQmFO5z6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com; spf=pass smtp.mailfrom=sony.com; dkim=pass (2048-bit key) header.d=sony.com header.i=@sony.com header.b=BitVipMj; arc=none smtp.client-ip=211.125.140.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sony.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=sony.com; s=s1jp; t=1770349504; x=1801885504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IuPnlqREwJB3pbqSqs+4wA7Rlfs308sbPiaPxE9gRow=;
  b=BitVipMjANx8XmpHpr7NpGZhZrLBn7nvnAhMDgtFMiwmANVf0j9wOcDb
   kvvWQ7barMOJpb5QdynBIitZOq7E5V39XRwcYJaUAMfBuzDyo6NksNjdQ
   6ydQO72THnbp14AGDTmPXUKzwCP3B4V7bxUpWj/7MP7kNfXNq+9wEJBU2
   22GztKGo8xeqqL5FUUYDNpUGdD6TB/g12VDhK8zPbB8rjN4N8Xq+C3Vqs
   DMnlBjP2sizxuDjiJ0MFlZ9sLwIR429iQ/6QNEDdGjM25bu4ocEbm5/us
   alc9gEYxL8V/sCX8CMSj+686hm7I+2NCIlGjCTME9hdZ2RQ+oe5s/+Awe
   g==;
Received: from unknown (HELO jpmta-ob02.noc.sony.co.jp) ([IPv6:2001:cf8:0:6e7::7])
  by jpms-ob01.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 12:45:02 +0900
X-IronPort-AV: E=Sophos;i="6.21,275,1763391600"; 
   d="scan'208";a="578775205"
Received: from unknown (HELO JPC00244420) ([IPv6:2001:cf8:1:573:0:dddd:6b3e:119e])
  by jpmta-ob02.noc.sony.co.jp with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 12:45:01 +0900
Date: Fri, 6 Feb 2026 12:44:57 +0900
From: Shashank Balaji <shashank.mahadasyam@sony.com>
To: Sohil Mehta <sohil.mehta@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Tim Bird <tim.bird@sony.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Message-ID: <aYVjuSkdOlBh06_S@JPC00244420>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
 <aYMOqXTYMJ_IlEFA@JPC00244420>
 <722b53a7-7560-4a1b-ab26-73eeed3dffa5@intel.com>
 <aYQzhRN83rJx6DSb@JPC00244420>
 <e5ac3272-795b-488c-b767-290fd50f2105@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5ac3272-795b-488c-b767-290fd50f2105@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sony.com,none];
	R_DKIM_ALLOW(-0.20)[sony.com:s=s1jp];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70408-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[sony.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shashank.mahadasyam@sony.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,sony.com:dkim]
X-Rspamd-Queue-Id: 44709F9D3E
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 03:18:58PM -0800, Sohil Mehta wrote:
> Maybe a warning would be useful to encourage firmware to fix this going
> forward. I don't have a strong preference on the wording, but how about?
> 
> pr_warn_once("x2apic unexpectedly re-enabled by the firmware during
> resume.\n");

That works

> A few nits:
> 
> For the code comments, you can use more of the line width. Generally, 72
> (perhaps even 80) chars is okay for comments dependent on the code in
> the vicinity.
> 
> The tip tree has slightly unique preferences, such as capitalizing the
> first word of the patch title.
> 
> Please refer:
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#patch-submission-notes

Thanks! I noticed that I also didn't use '()' for function names in the
commit message. I'll fix all these and add the pr_warn_once in v2.

