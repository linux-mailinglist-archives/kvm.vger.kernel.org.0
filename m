Return-Path: <kvm+bounces-73172-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPlXMdtTq2n3cAEAu9opvQ
	(envelope-from <kvm+bounces-73172-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:23:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2F42284E8
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 483BC30C39AF
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF542351C09;
	Fri,  6 Mar 2026 22:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ARqtqvr7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1185E34FF40
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772835736; cv=none; b=W+qkYSkLmhSYbe0+S2wEsGNK4mAkvlbedom0CGNoAQ8sOospY/Ln0NIHtQXNZPQnMRGHo6Qh7oas6TKURfu+nd+S2AKxcCFgiTN++09Cu6TMpGJzKIzCNwWkvNlrVbeGea/nnPFgJrIN4r5H08MIarJAuBA6RK+6atOMJB1mdow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772835736; c=relaxed/simple;
	bh=7y7bW0euFqRFl2pAT8uq9BnHtLvpcbHApIe+8yy8qz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i86WmNBnSbFRhe+33RGMaI1dx/Aw0Rj9L0u34tlhKTlauc13OZ3b0f4Mj81V80IAXL6x2QrOoHQclm3/HNaFAB8olLee8tias7voTPTeRZOSmUGjeJr//igJ4rhoZIX6LoWkVrltaNHmRz1bmG7R7EbpK01EGXZOD72d4AW8ShM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ARqtqvr7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598007eb74so31559587a91.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 14:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772835734; x=1773440534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WjbFTwqUIkgjoHiZRe9Sew4VJBm0utvvvEEjQeXLqkQ=;
        b=ARqtqvr7TTsTPHvyLbVk76rvCsuUfwfWbR/YjZ4pjDURmT/tfVGunA7IpJLdIFYOXY
         Z24fGQSJrB2adDghYnOj6H6lCpcsX0XypPfmjddahn+DYy95qIjtLsnS0dXvJawWtTCK
         +kCNH/I/I9ptRjODj/F2qQctV3ydmJBt5IPRMhtfYp3xT2q7vdNx4E3BQltE7U8MnB0X
         ZSwwC+5uU+9CluRviL83cGX/jxok43i41etayvBAi0La6uaOqajVThKTYVV3PhM83wfV
         Dcf/lT8BiTXM7dPWXeS778otmwwRXdb4ICyj1GGwckeAsg1E7f33j2cY52/fuExI+eaA
         mlUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772835734; x=1773440534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WjbFTwqUIkgjoHiZRe9Sew4VJBm0utvvvEEjQeXLqkQ=;
        b=lmO9277fCnnNMobiW7JcxH0h4chm2XHAsAXWnyry/zHNvB1rNql1EXF1kktddG1Du1
         1gA6SPKisyD9fDHtdYpoiPI8Daz0QY9vwj8exDbtQSUvHhxSbDn8KLs//8HCgsaZ49L0
         M/dK2xJWZstG2Hdo3B9UFzqj1W+0+1Hk2ajZ8xDYIh6+fgMNL2UfJIeIWlX4QmfSlPVA
         aIqDufz/rgtceN2jznQGLunvZx8rOzTn5J0e0/1Z/i/V9sytLeQLxsXqMyklEowr+nCA
         JZXx4cS/XDYsLJwL7ZLbpGv2ttYxKw5105l4Cq8Q1DI7O/+pFF/njjQAc/Ma5FN4HSYh
         HW+g==
X-Forwarded-Encrypted: i=1; AJvYcCVk2e0ztDshg+afIvKJRrUsk11Ea7Tbj5SyjvyO67wtR/kigy22J0sofdhEAm/kkX2Jv4I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Ep6Db01IevUtFH8q/Q9dTciEYPmaMm8shFfWCwgTRQEINGCl
	wRjoeGTzkR+9omB4xmtbWF/iWGimeOigAW3o8qJOAGe2WkVUZexZS99LTIQWhp2w7Q2QgBn4O6R
	C15T9NQ==
X-Received: from pjam9.prod.google.com ([2002:a17:90a:1589:b0:359:96a8:84e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f46:b0:354:c602:a573
 with SMTP id 98e67ed59e1d1-359be31e12amr2753981a91.27.1772835734276; Fri, 06
 Mar 2026 14:22:14 -0800 (PST)
Date: Fri, 6 Mar 2026 14:22:12 -0800
In-Reply-To: <aak3C/kR9o/pJ40n@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <aak3C/kR9o/pJ40n@yzhao56-desk.sh.intel.com>
Message-ID: <aatTlMfE1otFL6jq@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6F2F42284E8
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73172-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.944];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, Yan Zhao wrote:
> On Wed, Feb 18, 2026 at 04:22:41PM -0800, Sean Christopherson wrote:
> > Track the mask of guest physical address bits that can actually be mapped
> > by a given MMU instance that utilizes TDP, and either exit to userspace
> > with -EFAULT or go straight to emulation without creating an SPTE (for
> > emulated MMIO) if KVM can't map the address.  Attempting to create an SPTE
> > can cause KVM to drop the unmappable bits, and thus install a bad SPTE.
> > E.g. when starting a walk, the TDP MMU will round the GFN based on the
> > root level, and drop the upper bits.
> > 
> > Exit with -EFAULT in the unlikely scenario userspace is misbehaving and
> > created a memslot that can't be addressed, e.g. if userspace installed
> > memory above the guest.MAXPHYADDR defined in CPUID, as there's nothing KVM
> > can do to make forward progress, and there _is_ a memslot for the address.
> > For emulated MMIO, KVM can at least kick the bad address out to userspace
> > via a normal MMIO exit.
> > 
> > The flaw has existed for a very long time, and was exposed by commit
> > 988da7820206 ("KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults")
> > thanks to a syzkaller program that prefaults memory at GPA 0x1000000000000
> > and then faults in memory at GPA 0x0 (the extra-large GPA gets wrapped to
> > '0').
> If the scenario is: when ad bit is disabled, prefault memory at GPA 0x0, then
> guest reads memory at GPA 0x1000000000000, would fast_page_fault() fix a wrong
> wrapped sptep for GPA 0x1000000000000?
> 
> Do we need to check fault->addr in fast_page_fault() as well?

Ugh, yeah, good catch!

