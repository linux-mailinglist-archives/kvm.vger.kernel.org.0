Return-Path: <kvm+bounces-71410-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YL8JGOiRmGkfJwMAu9opvQ
	(envelope-from <kvm+bounces-71410-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:55:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1591697F3
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58C9930470F9
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 16:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB9F2EC0A1;
	Fri, 20 Feb 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UKFaJAEW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4952D126BF1
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 16:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771606488; cv=none; b=YVUqH+K8hNRrPr1SmwavaXYY6LHFjiOvQLJCA4EtSA1aysg8eGeluTTaxDam4KByaoi0dXWb0rP5rV6X5lc29O2G57DhmvTPyDhpOTppdHychbqQP8mzMnJ3f4WuNL9B2eO05TF5jNWvsEe0GyPyw0QoN9VtqM+abt5PxGDU+Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771606488; c=relaxed/simple;
	bh=uKJtCZaXbgW720WEGZpi9vqDGlLxa3Io2BYibYXb3AY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=riG9PNZsdn5AbhbywmT62HOZThL/GcYYDowhlghRO+qfXBpBvOF6uyCennSKsLHSIWQWAzM6Vvuynkq1LyljY6rcIa+At7Bu7mrU5lGV6d9C/aPB0DA+9Yt3GT8/yPblniJ9+/KvHwuqwx4t+Z4SQ+7+fpRnIYkTksVZ5zz6eqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UKFaJAEW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bee18a62so1670465a91.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 08:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771606486; x=1772211286; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGr7fqBn14oKU92GIyxBvn3jVsvgzYWTcMXy3dWUq0I=;
        b=UKFaJAEWl7765jNwSnveMYAiJDQKVOayIaMWhbgkbJIhfK2AUMP1YhJskim/l9NdwW
         rYSxAB1wYXvkWUsKZTAlSoDjv2vI1rpfmLyP2waM1vs9TV2aGQm+85UD+a9hut1L6Zpm
         6b4sgMKQZPeKE5BLty3wLYQb43SN8r1LnEL1A2MdEWcJbU1oyRmO732dYPaBlYAKDre+
         YuDtbkzber8Szt8HBYroBgLjctiRV6uWcIjyUDN2T9RTaxU+91pexZiARaBB3h/ygoUW
         vvNUP93E/APGCar9B6HxyrBQCSRaM2iOhU5+kEEGGZUKVSsqowLHW6da9ABMIrQTiv0q
         +h/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771606486; x=1772211286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGr7fqBn14oKU92GIyxBvn3jVsvgzYWTcMXy3dWUq0I=;
        b=ABFzB3ePQvqWvZNQLi/w33tsilUUoCTZZB/RA/L8DZ1z+KwcVD3n3mCkipEVxTaRTy
         FF+LmLtL1+fQgyvr0RdOaZsIE59+5021n1nTyCtsVBJd+TF++STZOhEsHFeRUkLoV3A0
         cornKkp3gMcPDrouHjiBbqKAaDhrfpQm1vd0zBR/tILXnd+fiNbLL0WEGEAhnqFkusep
         b4fT7M8+OtH76IEOXfS3VKPhLBg/h++z8G9z3xLRsSDQKYwVBghl4BEp667cGJ37jiOK
         rEAsyn+33KvIbbQjhFEsAD6LUpUiucfiTjZRpkenKzTI9d+yZnEBxIhWgMebtcyDe5T6
         Y8aQ==
X-Gm-Message-State: AOJu0Yy3vJ9/LvTRe5N8fZrV5RTCe/HpftlyY+80gf+mAEejNoYzWWm5
	nndlgVZymAmmcs4I0+9DHUS5vMThSJtYXI/oAcNSzNbEGIfPRmuXBEZLyqnxs6/RCNDrvteMhYb
	hKfQsLA==
X-Received: from pjvj5.prod.google.com ([2002:a17:90a:dc85:b0:34c:88ca:9ef8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5747:b0:34a:a1c1:90a0
 with SMTP id 98e67ed59e1d1-358ae8c166dmr272204a91.28.1771606486410; Fri, 20
 Feb 2026 08:54:46 -0800 (PST)
Date: Fri, 20 Feb 2026 16:54:45 +0000
In-Reply-To: <c06466c636da3fc1dc14dc09260981a2554c7cc2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <c06466c636da3fc1dc14dc09260981a2554c7cc2.camel@intel.com>
Message-ID: <aZiR1cQxbDpRkQNn@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71410-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BD1591697F3
X-Rspamd-Action: no action

+lists, because I'm confident there's no host attack.

On Thu, Feb 19, 2026, Edgecombe, Rick P wrote:
> On Wed, 2026-02-18 at 16:22 -0800, Sean Christopherson wrote:
> > In practice, the flaw is benign (other than the new WARN) as it only
> > affects guests that ignore guest.MAXPHYADDR (e.g. on CPUs with 52-bit
> > physical addresses but only 4-level paging) or guests being run by a
> > misbehaving userspace VMM (e.g. a VMM that ignored allow_smaller_maxphyaddr
> > or is pre-faulting bad addresses).
> 
> I tried to look at whether this is true from a hurt-the-host perspective.
> 
> Did you consider the potential mismatch between the GFN passed to
> kvm_flush_remote_tlbs_range() and the PTE's for different GFNs that actually got
> touched. For example in recover_huge_pages_range(), if it flushed the wrong
> range then the page table that got freed could still be in the intermediate
> translation caches?

I hadn't thought about this before you mentioned it, but I audited all code paths
and all paths that lead to kvm_flush_remote_tlbs_range() use a "sanitized" gfn,
i.e. KVM never emits a flush for the gfn reported by the fault.  Which meshes with
a logical analysis as well: KVM only needs to flush when removing/changing an
entry, and so should always derive the to-be-flushed ranges using the gfn that
was used to make the change.

And the "bad" gfn can never have TLB entries, because KVM never creates mappings.

FWIW, even if KVM screwed up something like recover_huge_pages_range(), it wouldn't
hurt the _host_.  Because from a host safety perspective, KVM x86 only needs to get
it right in three paths: kvm_flush_shadow_all(), __kvm_gmem_invalidate_begin(), and
kvm_mmu_notifier_invalidate_range_start().

> I'm not sure how this HV flush stuff actually works in practice, especially on
> those details. So not raising any red flags. Just thought maybe worth
> considering.

