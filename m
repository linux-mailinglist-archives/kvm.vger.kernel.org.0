Return-Path: <kvm+bounces-71886-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJxUFyxan2lRagQAu9opvQ
	(envelope-from <kvm+bounces-71886-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:23:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BCA19D267
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 21:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D3E33071F2B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F125A2DCF55;
	Wed, 25 Feb 2026 20:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uTDMm2rc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA9626ED59
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772050872; cv=none; b=dcnhAc6o2aUR3WrS6nRppBiUzmNE2sxYHJcl5Px8Z+adBA03G8S2+unIePylFK/sr3vzjr5+OPJLeOyg/JvGIRVJo7PrOaK+OmE+dhd38HFy6AOl42LkhRiuVuN+X0kL2TDXeXdPD1gZsqzVEjPYlXbcQ/mNjspSJZAaczBELPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772050872; c=relaxed/simple;
	bh=CjFbqOLn5WP5KXf0R1Hc9sBVWXyOe7id4YswrRUGc7w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d5oBRHmpCIMD+1BmbmCo20tyJpep9Id/ZX/OGvz51BSVDQfLDnpYA8pTX2ghUunR7FtijXagX2IO+oz49qNI+icifWLJToaKHORBxT70r1ME3wCfRiAkTLx60SNfdj0jML09ZIRGow0paH2VCIlzE3hNL90SVnzg3t7EEOgMoDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uTDMm2rc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2addb9ba334so544565ad.2
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 12:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772050869; x=1772655669; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ldmr9oU0MSeitk+1OIgY+rdK40ygdsN3dEDub2L4tpc=;
        b=uTDMm2rcxuJbh1kxaJFRzKifwMm+9jSmvILj3cg4QiwiJm7hZ7wREYQRdJghKYC6cl
         wmH7EYGcUNrLdS4e2CyNTxFU44ZKc/4Afo55cOREdwM+H5y9L74+um7RVtsowjNExGQI
         QVmCl99HjMyy1viLIVoijzpQqOYbgcEemkNFfgwHMh3X5qsbuRyR0W+cfRgyqGRUpFm2
         w9iIriqBETT/liunHaGgFRsKGTpJgDp0y6N+ia02/tvgM26ooMe6xnwoZatZpRF4lRAn
         o8PYQgYgaF3AJWSNbU3rlqB2jW0sKF7xtlFa6rep7SpxspYBa54Qv7FB7BDgKqaGKLMx
         Y/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772050869; x=1772655669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldmr9oU0MSeitk+1OIgY+rdK40ygdsN3dEDub2L4tpc=;
        b=EXQA7l1zSQNRjNrzL3zxYoZ11UsButSsqlS/dUZPa/bwN8NC3QDdbsFGN0m4TN+/6N
         Wf/b2eUFDENEnRMgXCtJEiFFB3PBELOCM6JNBtg9mwK32SnPHz7/ZLWxDpJDO86Y/wYA
         5q0JEkPVhS5NdoxEqVK2lrLDMXuXDMa1idYYjJj7dw3KIG/G6rWg/RXfpdnRnCPKJL85
         JpY4v3W67a92i7i9EyF8zoN/tjTwR4EEpkm+kVEAQtUMsZjsfOBl485crXxC1Kwjuv1b
         7S6R16JDugofAxwbLkk7d1txq7qkZq7S5fGod0BREeKKaVyF4xiOieYXBXAgQJvfjNTJ
         tuEA==
X-Forwarded-Encrypted: i=1; AJvYcCU5IH6x8QU82dSKfhOk9B0GmYFe4dpRT/ZZRKeR4VjLS9gb6I+Sbi2CUQOgFa2AHerXrX4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwUsRcxO6jzvGm3Gc7xEKYf880BNWI1nomiA5sSHHHJri4iF57
	mpvvdKNHuzEV1jeoT6PGgjR+Y3LJLiYRJL3cwy780gqCGoyt9iq6w/id4tgjON7ySVEhvoqzI/X
	jclsZ/Q==
X-Received: from pjbsl11.prod.google.com ([2002:a17:90b:2e0b:b0:34e:90d2:55c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2812:b0:354:a9f3:68bc
 with SMTP id 98e67ed59e1d1-358ae8e8390mr13614658a91.30.1772050869370; Wed, 25
 Feb 2026 12:21:09 -0800 (PST)
Date: Wed, 25 Feb 2026 12:21:07 -0800
In-Reply-To: <928a31e1-bb6f-44d4-b1de-654d6968fd55@fortanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
 <aZ9V_O5SGGKa-Vdn@google.com> <928a31e1-bb6f-44d4-b1de-654d6968fd55@fortanix.com>
Message-ID: <aZ9Zs0laC2p5W-OL@google.com>
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
From: Sean Christopherson <seanjc@google.com>
To: Jethro Beekman <jethro@fortanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-71886-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B2BCA19D267
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, Jethro Beekman wrote:
> On 2026-02-25 12:05, Sean Christopherson wrote:
> > On Mon, Jan 19, 2026, Jethro Beekman wrote:
> >> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH results in a
> >> kernel page fault due to RMP violation. Track SNP launch state and exit early.
> > 
> > What exactly trips the RMP #PF?  A backtrace would be especially helpful for
> > posterity.
> 
> Here's a backtrace for calling ioctl(KVM_SEV_SNP_LAUNCH_FINISH) twice. Note this is with a modified version of QEMU.

> RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
>  snp_launch_update_vmsa+0x19d/0x290 [kvm_amd]
>  snp_launch_finish+0xb6/0x380 [kvm_amd]
>  sev_mem_enc_ioctl+0x14e/0x720 [kvm_amd]
>  kvm_arch_vm_ioctl+0x837/0xcf0 [kvm]

Ah, it's the VMSA that's being accessed.  Can't we just do?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 723f4452302a..1e40ae592c93 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -882,6 +882,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
        u8 *d;
        int i;
 
+       if (vcpu->arch.guest_state_protected)
+               return -EINVAL;
+
        /* Check some debug related fields before encrypting the VMSA */
        if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
                return -EINVAL;

