Return-Path: <kvm+bounces-70544-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IeaA7PQhmmqRAQAu9opvQ
	(envelope-from <kvm+bounces-70544-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 06:42:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 183461050A7
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 06:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC6DA302A051
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 05:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 305FC301465;
	Sat,  7 Feb 2026 05:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJ3hDO6a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9758A2E229F;
	Sat,  7 Feb 2026 05:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770442891; cv=none; b=IoDlva0scSf+ZO5Tu6aVCaJNSL84jYDIFHZLDouy8fZtxHd5dvzfXLvPjDPg3oReWxqM29N0nYgtjOaK4vrpJaFjWDGsajiXXOuSGYDfw3B+0rkXC0iZZwqs9ONQtShlCbFp5xtWsslyOkCZVM8pOt1TbooBpePOafhVcqVyVzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770442891; c=relaxed/simple;
	bh=pM9/YDTyKKI0sD4Dhh4VK/fPcuA6cFUij7u1q0xmBNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ume3iHdFMMTslg9Mo4essIe93kS1SxgRa1THKc6j8rx/DjGZSwf1GRDzz7iFOy3tvr6wD+Ju+YJyHUkf3Ab9LiU3WjeZudw2F5setcJ+D05NSeLuW6m7uUQg84CxpYLo9JJAjsv8Nu47gfunAhA5QJd1xQYlGjgWfcdRduBm0kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJ3hDO6a; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770442890; x=1801978890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pM9/YDTyKKI0sD4Dhh4VK/fPcuA6cFUij7u1q0xmBNM=;
  b=cJ3hDO6agHpneUapqL8hugQJPaHUtzp59ONG8RF9q12ZQz24SWYNEIH3
   k2m8B2h1JpmAsrSbCKEOZ/olCIQLjVJA7PtBflTisUJOCbBOWWN6iGIH/
   14ecX+SYBzMo/ZF6Z9m6Qz+61tAZ4WCH/zvss26798TfrBLS5JmALAPw1
   ksuaQw8NL34fdf7yECIeo7VqEyCZFmnAvhwRQs2SD3UineJvoT4LG99T1
   ahUvl+qbjqKrMWX+d4B1Q/f/6TUeKsJcmMF4bWX9PSI4MUKX8NaUKk9PF
   zmxNmD7wb4Q78o7tbTkQ/O/+9REQs0QK+81/sWfoLMuyzXb5r0lLCLkbi
   g==;
X-CSE-ConnectionGUID: ZLWspzyPRKaPRc90cmolqw==
X-CSE-MsgGUID: /8CkmWBmQoeCkGTQi9sLnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="81963078"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="81963078"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 21:41:30 -0800
X-CSE-ConnectionGUID: xgKTgBFESxew693gJUYllQ==
X-CSE-MsgGUID: NvLtUkYgQiOg8muxH6UkYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="211090153"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO localhost) ([10.124.222.204])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 21:41:29 -0800
Date: Fri, 6 Feb 2026 21:41:29 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: syzbot ci <syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com>
Cc: isaku.yamahata@gmail.com, isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, oliver.sang@intel.com,
	pbonzini@redhat.com, seanjc@google.com, yang.zhong@linux.intel.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [syzbot ci] Re: KVM: VMX APIC timer virtualization support
Message-ID: <aYbQiS8k5K23bHE_@iyamahat-desk>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
 <6982f952.050a0220.3b3015.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6982f952.050a0220.3b3015.0012.GAE@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70544-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,intel.com,vger.kernel.org,redhat.com,google.com,linux.intel.com,lists.linux.dev,googlegroups.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,ci66a37fb2e2f8de71];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,syzbot.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,appspotmail.com:email]
X-Rspamd-Queue-Id: 183461050A7
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 11:46:26PM -0800,
syzbot ci <syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com> wrote:
...
> Full report is available here:
> https://ci.syzbot.org/series/febd2a47-f17d-45ba-954d-44cd44564c81
> 
> ***
> 
> general protection fault in kvm_sync_apic_virt_timer

This case is caused because in-lapic is disabled.
I'll fix this gp fault with the next respin by adding in-kernel lapic check
to disable nested apic timer virtualization.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

