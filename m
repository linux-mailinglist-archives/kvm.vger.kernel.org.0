Return-Path: <kvm+bounces-71504-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aI1yH3WGnGm7IwQAu9opvQ
	(envelope-from <kvm+bounces-71504-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:55:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2558817A30F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CE28D301135A
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5B731A805;
	Mon, 23 Feb 2026 16:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mH4FwtwC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8531B30E0E7
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771865703; cv=none; b=vB9gJa0+NuO+sOeDEGiDskNiH3NzAvHPU82yYYMxoJIqgEXNpForX/gZjRALxHiuW7HZbBuonxnUO8w/o79nuMtcPq7W/Rw7cIvtbxs+TIJ8HuO0yEFKk6HYqmWO+1tDohVQjlPnLlvudk7MsoaQuULksyD/vM/aq4nDRoMg35E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771865703; c=relaxed/simple;
	bh=a65itpG/3qypMOKzQnXH1GYRqzdgYzhqGWrjYPEbTzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X4gfYTxMpWb7ip6XZpjhLAUWMWFjEe0p56wMERW/fQA3H+Vw0UwmfOlWBW8t/HtQPUCDA5oNkpSuk6JMUAUCuwdNZLz7chcKiRPQabuub2pjUlNWgBGgV89hr7ieKKnSsmOnbnXodgksKCf5qL2zsWmBdsRoyAlDDFeLUz2sWmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mH4FwtwC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a79164b686so59955425ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 08:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771865701; x=1772470501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tgArmQCLg5v3sLuuWDh0CImXRXpeNf26TpjYBPRcbNI=;
        b=mH4FwtwCOj2LHdCajraQ7ryEkUHquIrfGVtSuecqBq5JFhqZlxALFBLavPJ4DsJizf
         bVgFWYwi9jLrDeuEcArdOiHaUQmSi13Qa4tv08VSgUcfEC+HNxYK31EHSTFpmMJUvvrK
         QmiFv6cFd1H4ZFph45ZkPNdFVjNAsbeit8tF8xrLpYzlS92gduMvK2kF9dC8w7xxHq4c
         vJi/7K/giKkYDhEvlyuupPEsxkkI3PtUE4QkufnnntuvqxfcN0TDQ/DM1hjzvE/1pkO4
         L0Agq4hCtNV4zUvhtTsivPIWvAzB8XuZScVi18D1zSWaavPKQ7D7thpTa7u4GGsBcm2b
         7V8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771865701; x=1772470501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgArmQCLg5v3sLuuWDh0CImXRXpeNf26TpjYBPRcbNI=;
        b=PDJC+2ZCueamCQZkLpYV5IEnX66nFCdFu9G088ivTe/c1uzax3A78D93dwwizTa3Ll
         DBUFSQQ06Jpyk2vt6y1g3tpIxLskr9g7lzNa+oXRyIaWcB4ZYpXXxVjSa6VgZakz8pmJ
         75UJKG17Eq5sffdvHC4s7m4B+IIKPmxULsVNFCsdyvvBE9JLNMRwgq27SLfc91aYJusn
         aEqChOpxMxqPQyNwwdsCOpO1jHom8/M0N6ONPy0NKTD1z95rWWsK0Y7E0ZD4US6YWhT8
         aoixWD4X5EvvqGohV7ROCRh8xHgq8YuMl/sgm+zNeNG5/zc9chMDZtZ6XGGJJnWLO2SV
         qWag==
X-Forwarded-Encrypted: i=1; AJvYcCVYC1TwHDRCTDq27WYHCmXyTuR1wDLpKrBl6CVJsgDJAK0tTk+z2TfAeK2EGaSXxZ+Qj2w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5odAduhasV8JjS8gvWiFQVBgReN1x+zxOWO8KttQuzONM3pV4
	ZXwRQU1Q1BPB6zo/gug76j0OYTkYGz+DzPR7kp77YYS8D8Fwly7Kkyms1xjHzVjmLbKDk6Y+bVx
	JQeeO+A==
X-Received: from plef22.prod.google.com ([2002:a17:902:f396:b0:2aa:f9fe:3355])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:234e:b0:2aa:e3f7:a945
 with SMTP id d9443c01a7336-2ad74549d90mr81342145ad.49.1771865700687; Mon, 23
 Feb 2026 08:55:00 -0800 (PST)
Date: Mon, 23 Feb 2026 08:54:59 -0800
In-Reply-To: <5a826ae2c3549303c205817520623fe3fc4699ec.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260219002241.2908563-1-seanjc@google.com> <5a826ae2c3549303c205817520623fe3fc4699ec.camel@intel.com>
Message-ID: <aZyGY41LybO8mVBT@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>
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
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71504-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2558817A30F
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Kai Huang wrote:
> 
> > @@ -3540,6 +3540,14 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
> >  	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
> >  		return RET_PF_EMULATE;
> >  
> > +	/*
> > +	 * Similarly, if KVM can't map the faulting address, don't attempt to
> > +	 * install a SPTE because KVM will effectively truncate the address
> > +	 * when walking KVM's page tables.
> > +	 */
> > +	if (unlikely(fault->addr & vcpu->arch.mmu->unmappable_mask))
> > +		return RET_PF_EMULATE;
> > +
> >  	return RET_PF_CONTINUE;
> >  }
> >  
> > @@ -4681,6 +4689,11 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >  		return RET_PF_RETRY;
> >  	}
> >  
> > +	if (fault->addr & vcpu->arch.mmu->unmappable_mask) {
> > +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> > +		return -EFAULT;
> > +	}
> > +
> 
> If we forget the case of shadow paging, do you think we should explicitly
> strip the shared bit?
> 
> I think the MMU code currently always treats the shared bit as "mappable"
> (as long as the real GPA is mappable), so logically it's better to strip the
> shared bit first before checking the GPA.  But in practice there's no
> problem because only TDX uses shared bit and it is within the 'mappable'
> bits.

I don't think so?  Because even though the SHARED bit has special semantics, it's
still very much an address bit in the current architecture.

> But the odd is if the fault->addr is L2 GPA or L2 GVA, then the shared bit
> (which is concept of L1 guest) doesn't apply to it.
> 
> Btw, from hardware's point of view, does EPT/NPT silently drops high
> unmappable bits of GPA or it generates some kinda EPT violation/misconfig?

EPT violation.  The SDM says:

  With 4-level EPT, bits 51:48 of the guest-physical address must all be zero;
  otherwise, an EPT violation occurs (see Section 30.3.3).

I can't find anything in the APM (shocker, /s) that clarifies the exact NPT
behavior.  It barely even alludes to the use of hCR4.LA57 for controlling the
depth of the walk.  But I'm fairly certain NPT behaves identically.

