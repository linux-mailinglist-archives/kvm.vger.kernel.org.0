Return-Path: <kvm+bounces-36668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64621A1DAFC
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 18:05:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD6E3A2958
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A66188926;
	Mon, 27 Jan 2025 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1RXoJyHp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C051F1581E0
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 17:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737997503; cv=none; b=ZJdatq1ogmtzLZkw+NCT2LG5aqeEwf/uJQ6yrNaC4tSCjIc7ZhMy3Lgaz0bT7cJ0tRqcvfLbIPr9KDbCpzpIb7KTe1r/SqcR+rkg2BpBdbFnEg1BM6Y5kB4CddBfxqfOx/yLz/ymlN0d62/nTXzEY+gv7Q4YTyZYV5URkh4406U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737997503; c=relaxed/simple;
	bh=wJmbWVGPNlBY1q9XcbEFIAtJU0FoZRe9yZqry0QkOsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CWRiNQefMZBFBO9dVebg0tjKVcV9Su5HwdAqnhhKCUj/sbbSBIBU/E0VlGEOwx68XXqvugyTGqMKQubSJOqy5qA4kj+/MSjUb7GJ+3OcN+MweQHqdbkYyLUd6NIinHxb7CsySaI9HvhUN4iBhSsI+NnqI4Yok/h22wBIW4fxyws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1RXoJyHp; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166e907b5eso82882385ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 09:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737997501; x=1738602301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+ETOTo5IfPgKyFMapOrCWmqlpkzTGZaFAV0TeQlMDE=;
        b=1RXoJyHpfkMiqH1bgm9VSF2mh9zxPja069TXsbu7lWbeUryTb1BnOyUB1r1/5Q3k9K
         diKM20jPcJkxROJubTde6IR/qg52IjuVF2PzmSnDN0ccU08zk6C3pcTAGjpvOdj/FPrT
         +3rS+jV3PiqkPFYurFPf1k79QagbRkgH2o+jXsZI+/V+4a0McS3oYcAQbb9n/KNA/o3V
         JGMdtSdpFeQl/NVYMuQXLpyPWVm5eH9vQZ9cOJrtmqkE+QW4HCHdMlpvDYJMKE80Yfp3
         akGSVqPt8Xt0YMxHHe4dOn2BhCtvAwS5uUCnLZUGNK6Qh/yROijso1MeSzabdOiqhAIR
         DxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737997501; x=1738602301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+ETOTo5IfPgKyFMapOrCWmqlpkzTGZaFAV0TeQlMDE=;
        b=c11Wt54gH9qePUvKQsPpGe32/RgZ2ug+bcdHiz2/VKLsSqAvfzbr1THwMCQNw09Knq
         aX3S9+/H+9K5SZSxGVfwFUNfirB0b2ffYi8iRwgXkspFQvXA9v9c6s+NRGAUoTGoVYK4
         B6o3shWXe23D57Ws1BYXfNCOBZ75mGUAZ1fCgPXTfE9Rtdc5XOzZNFaSq1KwFd4PAi5R
         vSv0fOB5iB+WwNhGjlt7DoiZAFYWSdsaZyIp4Ovn593AS8SN7pJdMTCh73Ri7tDDXVNP
         GrLPommLswYaNSquy6BqxWfQykuoNayvuts4vEq44mEhuSAnYXcA4xPdFMT4DKHqEXxK
         Udaw==
X-Forwarded-Encrypted: i=1; AJvYcCUf8GW4Mc3WrsVMgr90h0CXY/BcQO18FlDKRSkU8aIPrukutx5Ecm8s6VYW4c+PivTFtfU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1uy9P+BTpzIobe4unhMFC/i5UBo/5q9nejDdb8gTuRTEcWviN
	8rMMYFGjzhGIpX+CgI0K3XgBYibRG7lqTUTPI+TW9tClN620kWsNnH1GEp4CblPswzMS41+BQkw
	xgw==
X-Google-Smtp-Source: AGHT+IFYQZC+7lIxW9G9BX1IIQ/awHF38+WG0ZYkvV34s8cor4Z8FTRasrIVcMKPRdWl8WX50bSEoI4+OsA=
X-Received: from plblq13.prod.google.com ([2002:a17:903:144d:b0:216:248e:8fab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c6:b0:215:65f3:27f2
 with SMTP id d9443c01a7336-21c352c7915mr502501525ad.8.1737997500962; Mon, 27
 Jan 2025 09:05:00 -0800 (PST)
Date: Mon, 27 Jan 2025 09:04:59 -0800
In-Reply-To: <Z5dQtuVO2mQfusOY@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113020925.18789-1-yan.y.zhao@intel.com> <20250113021218.18922-1-yan.y.zhao@intel.com>
 <Z4rIGv4E7Jdmhl8P@google.com> <Z44DsmpFVZs3kxfE@yzhao56-desk.sh.intel.com>
 <Z5Q9GNdCpSmuWSeZ@google.com> <Z5dQtuVO2mQfusOY@yzhao56-desk.sh.intel.com>
Message-ID: <Z5e8uycCzOlMwP_t@google.com>
Subject: Re: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler
 on RET_PF_RETRY
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 27, 2025, Yan Zhao wrote:
> On Fri, Jan 24, 2025 at 05:23:36PM -0800, Sean Christopherson wrote:
> My previous consideration is that
> when there's a pending interrupt that can be recognized, given the current VM
> Exit reason is EPT violation, the next VM Entry will not deliver the interrupt
> since the condition to recognize and deliver interrupt is unchanged after the
> EPT violation VM Exit.
> So checking pending interrupt brings only false positive, which is unlike
> checking PID that the vector in the PID could arrive after the EPT violation VM
> Exit and PID would be cleared after VM Entry even if the interrupts are not
> deliverable. So checking PID may lead to true positive and less false positive.
> 
> But I understand your point now. As checking PID can also be false positive, it
> would be no harm to introduce another source of false positive.

Yep.  FWIW, I agree that checking VMXIP is theoretically "worse", in the sense
that it's much more likely to be a false positive.  Off the top of my head, the
only time VMXIP will be set with RFLAGS.IF=1 on an EPT Violation is if the EPT
violation happens in an STI or MOV_SS/POP_SS shadow.

> So using kvm_vcpu_has_events() looks like a kind of trade-off?
> kvm_vcpu_has_events() can make TDX's code less special but might lead to the
> local vCPU more vulnerable to the 0-step mitigation, especially when interrupts
> are disabled in the guest.

Ya.  I think it's worth worth using kvm_vcpu_has_events() though.  In practice,
observing VMXIP=1 with RFLAGS=0 on an EPT Violation means the guest is accessing
memory for the first time in atomic kernel context.  That alone seems highly
unlikely.  Add in that triggering retry requires an uncommon race, and the overall
probability becomes miniscule.

> > That code needs a comment, because depending on the behavior of that field, it
> > might not even be correct.
> > 
> > > (2) kvm_vcpu_has_events() may lead to unnecessary breaks due to exception
> > >     pending. However, vt_inject_exception() is NULL for TDs.
> > 
> > Wouldn't a pending exception be a KVM bug?
> Hmm, yes, it should be.
> Although kvm_vcpu_ioctl_x86_set_mce() can invoke kvm_queue_exception() to queue
> an exception for TDs, 

I thought TDX didn't support synthetic #MCs?

> this should not occur while VCPU_RUN is in progress.

Not "should not", _cannot_, because they're mutually exclusive.

