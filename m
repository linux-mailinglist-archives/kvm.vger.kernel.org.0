Return-Path: <kvm+bounces-72825-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uNw+HYaiqWl5BQEAu9opvQ
	(envelope-from <kvm+bounces-72825-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:34:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2DDE2149AA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86D403106C77
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 15:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B2D39C621;
	Thu,  5 Mar 2026 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lqWpSxIt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1572654654
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772724789; cv=none; b=bgRNrtB7lwaW4hfm4U0gT+v0FSscoQRXdxUSbeoHTX7qvku8htJv9iEaa1y2Q7ZEPH2CP4+fqqNV8Ia6cRXo28Cg47v7rQx3vYCiPvH+zHK3QmTNRnb+fx5BHzcxq5+BQ6l1MA3kalNlO9l24L4xNCJ2RRxG4sAm4GX4Mfc8kkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772724789; c=relaxed/simple;
	bh=sBohCdeL84PSvBUf7YUzOPwpe/DBqrjyCfFfqvIffiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kETBdS8rX8ejh7zy1ImFDlveXguhxQB9zoAexOsMwbgA0odDN5ZIEsvnLwugPTgOpzfIYqi+RjQWhZrl7pCEMMuGEEpd31/n/Cc8Mo9rzF98mh24LFdKOxP7KXNMOeJm3h2M1wTl7SWestFIaR1XnbdRb2geTpNIY0X0EPjflJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lqWpSxIt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-359918118ebso11521473a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 07:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772724786; x=1773329586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HuC7vw5TewHVqYtxo4NaHVLtIIY2hMz/mpCs88acKy0=;
        b=lqWpSxItx3yG4HYld4Wc34XrA6ZYfyaHpdyGq51QfGwyJSgjgt8LOGj1ji/q09Uecz
         PX7Mt6rX0Ssu4oIqFeHhYzhH8/IvtdZ+7EtIrSsfiE1ZyAvsc1zasgj4LE1VMu6CsbXU
         PyRphAiGSfaQUa/LqXW+39mMlUEl9lnc3AdhUZzwiL1qEuXJ7D9qC+haDEZFvHF7NXsd
         FAq7RvV0jMeK+z7tI19lOXlTP/bZ8R6GUlreihp8xUT2seCwRvkoou3Z3O9jRKAmvB3g
         AMXOPhwkFTw0KAs4R4J4NFuQPL8OewZN7mlEAPiTG0+qf1rDYQ2+zzoiLRDEy7NuRfHF
         wIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772724786; x=1773329586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HuC7vw5TewHVqYtxo4NaHVLtIIY2hMz/mpCs88acKy0=;
        b=JL04oD55fowzo3c/81AK/DEi0i7G4ubhHRDKJMhqqeh7WiJu4c+kdiFEHM0OKNrrNp
         Cxvv0hOvZkds7w+s7w5aot/x7kq7EGg+/WnRTE33eYQMV9H/RWgFnYdGeu+FJCKk1f+K
         fbsA2pZwPLSieHGBOgSthzoScEWP3QYkso2YjGKimkOGdXSHQtLG2kXy8ra+7LfwdqMe
         SIGLYulVi/mpPL6mKjCV2SD9r5X/JU73Z81wL5X1y+CI4nR6Is2nQCvkC9h28YiIggcv
         Os8UmTMj11r/Ury+lZmZsZU/tXXYPdmI1CPxPM20cyxn8UyWiWQ0mwCGVUGKeCkl4QAc
         M1qg==
X-Forwarded-Encrypted: i=1; AJvYcCXX4butbmeYVZvzwUbNg2CFTvZ0eE6SAxKlhmfXXzmYuwaxLwtYsBp0Rq3INJuOBTjO7YI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrowwD3m/pgtErsb5uJIxDxK8SE15O0U2C6RF+uAjOANdxIYxB
	mGZn+hDywjRItBZIyHrPBueOyiEMQpmlCL3MRlicDl0+DuZM5KmirckFBgJUKDaQsrvpJfXwgwQ
	kUcahrQ==
X-Received: from pjj5.prod.google.com ([2002:a17:90b:5545:b0:359:974a:3d42])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e86:b0:359:92b5:da70
 with SMTP id 98e67ed59e1d1-359a69d64e9mr5463259a91.9.1772724786236; Thu, 05
 Mar 2026 07:33:06 -0800 (PST)
Date: Thu, 5 Mar 2026 07:33:04 -0800
In-Reply-To: <tencent_4897299F3F479A188C8C19A7BD58D2A40608@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <tencent_4897299F3F479A188C8C19A7BD58D2A40608@qq.com>
Message-ID: <aamiMBRsSwn7yxu0@google.com>
Subject: Re: [PATCH] KVM: x86: Add LAPIC guard in kvm_apic_write_nodecode()
From: Sean Christopherson <seanjc@google.com>
To: xuanqingshi <1356292400@qq.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: D2DDE2149AA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72825-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[qq.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,qq.com:email]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, xuanqingshi wrote:
> kvm_apic_write_nodecode() dereferences vcpu->arch.apic without first
> checking whether the in-kernel LAPIC has been initialized.  If it has
> not (e.g. the vCPU was created without an in-kernel LAPIC), the
> dereference results in a NULL pointer access.
> 
> While APIC-write VM-Exits are not expected to occur on a vCPU without
> an in-kernel LAPIC, kvm_apic_write_nodecode() should be robust against
> such a scenario as a defense-in-depth measure, e.g. to guard against
> KVM bugs or CPU errata that could generate a spurious APIC-write
> VM-Exit.
> 
> Add a WARN_ON_ONCE() guard and bail early if vcpu->arch.apic is NULL.
> 
> Found by a VMCS-targeted fuzzer based on syzkaller.

Found how exactly?  If you managed to actually hit a NULL pointer deref here,
that *significantly* changes the value of adding defense in depth.

> Signed-off-by: xuanqingshi <1356292400@qq.com>
> ---
>  arch/x86/kvm/lapic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9381c58d4c85..0f9d314dfa2a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2657,6 +2657,9 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  
> +	if (WARN_ON_ONCE(!apic))
> +		return;

Hmm, a simple WARN isn't a net positive.  If the CPU generates a spurious APICv/AVIC
VM-Exit, or KVM managed to enable one or the other without an in-kernel local
APIC, then I'd *much* prefer a crash due to a NULL pointer dereference.  Letting
the vCPU continue on in this state would be disastrous for the guest.

But luckily we have KVM_BUG_ON().  And we can use lapic_in_kernel() to make this
"free" for the overwhelming majority of setups, which always use an in-kernel
local APIC (in which case lapic_in_kernel() is a static branch that returns true).

	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
		return;

