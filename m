Return-Path: <kvm+bounces-69268-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJRGNQsMeWnyugEAu9opvQ
	(envelope-from <kvm+bounces-69268-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:03:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B26E998F9
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 20:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 15698303670E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 18:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D538E3563CD;
	Tue, 27 Jan 2026 18:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EmbOuYvu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF49532B9A3
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 18:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769540368; cv=none; b=FqOQyXBMweJhrVsIKHWOzMUnDQZ3Xov/QSX65Kr/ut1VhlX9LC7mX6lH2xOkvl53kTxM19NfuP2g/XFr75iEJxdk2gjC+CP78/queyckBzDAMM48zSowvN3VF/+xMRj9ISNiafqWaBVuePAhG+aw/Cv8FjBfP7wCScN4pnJnQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769540368; c=relaxed/simple;
	bh=m8yzuLzt+5k8xQvyVmplfgseiSn5dLhJEbq3KkkBHOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BtfN7uvemnYxXY4qMwLopTbM+Y+xqCQmC42cAphtb0rPcn3sb2WNEWMypRu2PSN02pR0WmuUw+4kPzyIXdL0VoYVSvT87Lh+ADIxFlw70z/MO3HLfhp6ecMGaP5A5DMarkvI2HQ+YqC/WMS7Xi9n8NrEHkuoeDhkA190+y4Xr+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EmbOuYvu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so11639925a91.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 10:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769540366; x=1770145166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sG+LTRFf1Onf4n7WEEL8aqcN9LibwU8cf6AOwJP4mAE=;
        b=EmbOuYvud0vwqvqDutf8M1p5xBLrUtlZ3IX+8ztmZqg1FPaqptsv+6vEXg1q4R1kOM
         AI6KbulTGOTu5tEyW8fIRM9DT3pAw5H3/8DBl5ZYlgviaa7KpSKpR6BD3CxhCH15bu9M
         F+Dl2s56YcDRFxpjzmFF5vn6lDQUeMt9hHhQcr9mWDvvyUnW7BVoBX88jr8D51CyzGBq
         wIegL+H8yTnWpQ2uI6VRwQ/hT/IBbgRU+s734qbu9DP3WlCF7kT+J3TtX6dIq4WLORQK
         3Sst6Uumk+y3smvM17+kS9o6VEBy75waGEfH3H7WFJuFEFruOczVbCmCW+eYFubpo3C+
         4gLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769540366; x=1770145166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sG+LTRFf1Onf4n7WEEL8aqcN9LibwU8cf6AOwJP4mAE=;
        b=DDbtZG8OVLyqQN9zaYfb8/EGTK/dmuOme5RYPLqQbiDbxKZ1MxtJoUMw2I2qfFRTGX
         gqAG8YzITu0gaiKCbzgYZ9Zn+5Ub3WzJr0uIFySkM6WYKfA6UrPeRe2mqyfkn+SzWJke
         fsHr3n0i6ObtD18eoEuklEM7pJsQSDOBY5WoIn5rs1ZYANkjT2ZPkEgVl15N+9BUdr1M
         dCRz52LRUGVC/Smb5M0iyw4A9FFC+iXzsgmhNPdR+VfOZvujtX5KgUs4mL/Chtj4rqFz
         KNuCUhCZAHswgpX3DXOkXfOUoBvPnFSVD9yxYi6X/lw19LNJrpGqxLi/TkRE2L//EMPq
         x0xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCnCaJduwTOcDY3us7kGitcegZUWwgoM9IL0G2ttXUCX+XNfJX7+LP6lFaKlAkhU9tcBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFSn9Oic7J178iArY+010ugNS+xvgXDN0ISqbq8AUNjDWFZXgn
	beSBShWuEbMOnsbACYnS06wY6nfQU6CAWcXJYnuiK6RK6htyZ44Ed59WF0fgbgVsJdz2gtWosPD
	Y4EjBkQ==
X-Received: from pjbbr8.prod.google.com ([2002:a17:90b:f08:b0:352:f654:c302])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5883:b0:34a:adf1:6781
 with SMTP id 98e67ed59e1d1-353fecee84dmr2478760a91.9.1769540366026; Tue, 27
 Jan 2026 10:59:26 -0800 (PST)
Date: Tue, 27 Jan 2026 10:59:24 -0800
In-Reply-To: <aXhvD9DT4YtKAcIr@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123221542.2498217-1-seanjc@google.com> <20260123221542.2498217-4-seanjc@google.com>
 <aXeA1pTiDDtikdWD@google.com> <aXhvD9DT4YtKAcIr@intel.com>
Message-ID: <aXkLDOM4ZmVfbWiT@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS
 config mismatch
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Jim Mattson <jmattson@google.com>
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
	TAGGED_FROM(0.00)[bounces-69268-lists,kvm=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5B26E998F9
X-Rspamd-Action: no action

On Tue, Jan 27, 2026, Chao Gao wrote:
> On Mon, Jan 26, 2026 at 06:57:26AM -0800, Sean Christopherson wrote:
> >On Fri, Jan 23, 2026, Sean Christopherson wrote:
> >> +			pr_cont("  Offset %lu REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
> >> +				i * sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
> >
> >As pointed out by the kernel bot, sizeof() isn't an unsigned long on 32-bit.
> >Simplest fix is to force it to an int.
> >
> >			pr_cont("  Offset %u REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
> >				i * (int)sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
> 
> Why pr_cont()? The previous line ends with '\n'. so, a plain pr_err() should work.

To avoid the "kvm_intel:" formatting.  E.g. with pr_cont():

[    5.355958] kvm_intel: VMCS config on CPU 0 doesn't match reference config:
[    5.355986]   Offset 76 REF = 0x107fffff, CPU0 = 0x007fffff, mismatch = 0x10000000
[    5.356019]   Offset 84 REF = 0x0010f3ff, CPU0 = 0x0000f3ff, mismatch = 0x00100000
[    5.356048] kvm: enabling virtualization on CPU0 failed


versus with pr_err():

[    6.527945] kvm_intel: VMCS config on CPU 0 doesn't match reference config:
[    6.527979] kvm_intel:   Offset 76 REF = 0x107fffff, CPU0 = 0x007fffff, mismatch = 0x10000000
[    6.528013] kvm_intel:   Offset 84 REF = 0x0010f3ff, CPU0 = 0x0000f3ff, mismatch = 0x00100000
[    6.528048] kvm: enabling virtualization on CPU0 failed

Ugh, but my use of pr_cont() isn't right, because the '\n' resets to KERN_DEFAULT,
i.e. not captured in the above is that the continuations are printed at "warn",
not "err" as intended.

Ah, and fixing that by shoving the newline into pr_cont():

		pr_err("VMCS config on CPU %d doesn't match reference config:", cpu);
		for (i = 0; i < sizeof(struct vmcs_config) / sizeof(u32); i++) {
			if (gold[i] == mine[i])
				continue;

			pr_cont("\n  Offset %u REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x",
				i * (int)sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
		}
		pr_cont("\n");


avoids generating new timestamps too, which is even more desirable.

[    5.239320] kvm_intel: VMCS config on CPU 0 doesn't match reference config:
                 Offset 76 REF = 0x107fffff, CPU0 = 0x007fffff, mismatch = 0x10000000
                 Offset 84 REF = 0x0010f3ff, CPU0 = 0x0000f3ff, mismatch = 0x00100000
[    5.239397] kvm: enabling virtualization on CPU0 failed

Unless someone strongly prefers re-printing the timestamp+kvm-intel, I'll go with
the above approach for v2.

Thanks for the reviews!

