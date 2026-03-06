Return-Path: <kvm+bounces-73095-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMArNlkBq2msZQEAu9opvQ
	(envelope-from <kvm+bounces-73095-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:31:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D39F224ECF
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:31:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BE36315A2DF
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96E83EDACD;
	Fri,  6 Mar 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aNzMGWV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477CF3630AE
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772814298; cv=none; b=JHWhLRhy+8Cicctwz2TQioNGmFJqZ59m0ijzb1Vhb+/CwRGdVfi+XrMGmmHpNckrsF8INwGxgLZ0Uv5k93Ib4Pj1YIwTUnB3rpB0BezfgwWO9qNlsx/nxq4VbADfnMXKUAnem5CUGLud/hXYcAiqPROfPyo7UwPrSNj+GRoIROA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772814298; c=relaxed/simple;
	bh=nne6hfkcWfjwMq1RQmckYFoDq6sA/Hf2xSpxcsa2Lno=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b8ka9vGd1emzwO/Tqgv2RXG/KXVV3hsPwDpy1jYCdJgFhjYfxr+uRtvoRcxBtq4czggPU3QcoGgGdhJIpciV3d84SwPToLSX56saJlnjHH4lKdbG2ACpjrhmHbdDF4p/fc+ap5zBpDID5ApANgJCWh4ISI0W9GjHcrlHNslK2u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aNzMGWV7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae65d5cc57so172280175ad.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 08:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772814295; x=1773419095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uf5NkfTgzKe1e6zjeS2xh88bJlDrw2IsrPqKeeEk998=;
        b=aNzMGWV72oX7NOdvqsC7g0D6xzsVlnd3h6faUsWgOvZTSfw86Hrj2uIGKUZDeQKCwp
         /M/RNI6k54ZtH86pkFYxpzCgcI17l4ugc8/aZ7Ezq7RekUjEkZd5Dh2EEfGY776uTfmC
         7YPajNYTAV16ozsdWX3HdjGiPMxHRVJqwWairxjTlB0DTtNMWMTNCNzfYqfpkrbpPuFt
         5MwJ0WI01Q9ecvP2uwAUv5pF/xO5tgfVAxTuEbmK0/uZ2KmzmMyxGwFIETfHBdGNfuEW
         ycHyYdbgMGLpzaNtxVDR8w7IuFvYyWQW0HccIn2Ncqvq7mwlPd8jVijIWCWgRjJ+Z9iT
         F23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772814295; x=1773419095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uf5NkfTgzKe1e6zjeS2xh88bJlDrw2IsrPqKeeEk998=;
        b=qwrepWexi4+g8DlLwDwhMNRyraAZgy9pxJpmG4gD4D3hY3JXjOEEqxhYphpYE2zUmd
         I3i0PRa7gnsf+GkyN/G6WI1NO5/PD2SsgjqC6VnQLI6TE3UQRnI+IwngtrxZfnR0JE0A
         HF/69VbqUYASwWu4LSfaqV7aXV7FBZv7xZf5BZlOXaAsOtuRMseYOwLFLX56hib/ecmd
         RCS4QwjWzqs5aMd/P3ovNslbgxerZ2ysCMug3puReAhUH77VdvlLXnkzUsBtP9d12+AS
         Ioy6GshLw1RXczwzci9WKVwytAO6GeNRzY0oC2t7rg9BBxlVXz7gkRlU+dGcJa+ODExq
         fnGw==
X-Forwarded-Encrypted: i=1; AJvYcCUjZB1Vwb0YCqA9vV6QaCOKrJ8QY2z87BHp0ggFKy/05JJ+1zwu8h08Wq9orDjyDhhJBNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG2xQ4Ls1F2OZf89LTffkAK9LDK5/HDI085VYYlAp3+woP/Zof
	6A0rGPNsVKV80ucAaaPveuG++Uz17RvhPN0FZ16PY81h5JQflByLPsSLUKamorzqGoA9nDkEbNL
	RvTJ5OQ==
X-Received: from plblf3.prod.google.com ([2002:a17:902:fb43:b0:2ae:3bf5:af0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3bac:b0:2ae:8081:c5a0
 with SMTP id d9443c01a7336-2ae8245e0afmr29642405ad.39.1772814295233; Fri, 06
 Mar 2026 08:24:55 -0800 (PST)
Date: Fri, 6 Mar 2026 08:24:54 -0800
In-Reply-To: <1795684a-b453-440e-88bb-035993d9deab@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260305235416.4147213-1-xin@zytor.com> <1795684a-b453-440e-88bb-035993d9deab@lanxincomputing.com>
Message-ID: <aar_1pOk4t3_MX4p@google.com>
Subject: Re: [PATCH v1] KVM: VMX: Remove unnecessary parentheses
From: Sean Christopherson <seanjc@google.com>
To: BillXiang <xiangwencheng@lanxincomputing.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 3D39F224ECF
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
	TAGGED_FROM(0.00)[bounces-73095-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.927];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, BillXiang wrote:
> On 3/6/2026 7:54 AM, Xin Li (Intel) wrote:
> > From: Xin Li <xin@zytor.com>
> > 
> > Drop redundant parentheses; & takes precedence over &&.
> 
> I would not recommend relying on default operator precedence.

Eh, in practice, the kernel heavily relies on operator precedence all over the
place, so I'm not worried about correctness.  But as you note below, judicious
use of parentheses can help readability.

> > Signed-off-by: Xin Li <xin@zytor.com>
> > ---
> >   arch/x86/kvm/vmx/capabilities.h | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> > index 4e371c93ae16..0dad9e7c4ff4 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -107,7 +107,7 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
> >   
> >   static inline bool cpu_has_load_cet_ctrl(void)
> >   {
> > -	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
> > +	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE;
> >   }
> >   
> >   static inline bool cpu_has_save_perf_global_ctrl(void)
> > @@ -162,7 +162,7 @@ static inline bool cpu_has_vmx_ept(void)
> >   static inline bool vmx_umip_emulated(void)
> >   {
> >   	return !boot_cpu_has(X86_FEATURE_UMIP) &&
> > -	       (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC);
> > +	       vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_DESC;
> >   }
> >   
> >   static inline bool cpu_has_vmx_rdtscp(void)
> > @@ -376,9 +376,9 @@ static inline bool cpu_has_vmx_invvpid_global(void)
> >   
> >   static inline bool cpu_has_vmx_intel_pt(void)
> >   {
> > -	return (vmcs_config.misc & VMX_MISC_INTEL_PT) &&
> > -		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
> > -		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
> > +	return vmcs_config.misc & VMX_MISC_INTEL_PT &&
> > +	       vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA &&
> > +	       vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL;
> >   }
> 
> Removing the parentheses could significantly reduce code readability here.

+1.

For cases like cpu_has_load_cet_ctrl() where it's a single statement, I'm 100%
in favor of dropping the parentheses because they're pure noise.  E.g. putting
them in the return statement is kinda like doing this:

	if ((vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE))

But for code where there are multiple checks, IMO it's totally fine to use
parentheses, and probably even encourage.

Can you send a v2 to just clean up cpu_has_load_cet_ctrl()?  Ah, and the changelog
will need to be different, because there's no &&, which is another argument for
treating "return x & y;" differently.

