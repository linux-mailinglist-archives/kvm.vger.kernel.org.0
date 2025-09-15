Return-Path: <kvm+bounces-57636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D660EB58732
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A3322A3374
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F5C2C08C8;
	Mon, 15 Sep 2025 22:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tp2dAl7j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885EB23957D
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974352; cv=none; b=F84CyokfCnHWTev3fMPx9LVDnoqMUOW3Mhh6gOM6nkMj2kFXADihCCmDYb+QL9Uy+zItgYPthJ6pIqisI6jFa0CZH2emVCfGUrQH09uqAcTX31ZNvi5lvk1nVEv6JB4LNgjxNhlkI3RSNlzgiwajZGZ6H15+77CS4PZ+XwJTAY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974352; c=relaxed/simple;
	bh=UxqqOLgeOcZVIT/anqZ+G+jfCLHIPv2RScY+P+RgxW4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TUT5Ew4IK/p/XVPNNjKIMy16huFXTZX1eR8lyWywzvRzgVhe6WoHAWNMEjwgZzWqtKy0DrNVLoBKMf/v1QW0/YluC44L3VN2kU5OSsrHudfX34P/CFWBXQK/SLhvuuoOK2M7DYSEIf2aHxlHa/6UQbpR74JmPVW1mNKSnV4EIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tp2dAl7j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e0b001505so2212572a91.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757974350; x=1758579150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hr8LZude88xba8bJloaRJyQTYbUOUfQ4ZPSQ9KFa+7A=;
        b=Tp2dAl7j/FTVbvgGHIyoJHc6BX+ch3zdcxpdwwZFOMghNAfaUcP5aYiheFo+/LNO+U
         RuOfrV8MlNYT45sIy6O3enEVsP53A1n+1K6JdNiy/WhjZusRA87eQqLlXTHvvNzcOBVl
         EErDz03M6hYvFaaPqJLFHmelHi427pHlhwP4I/LDuhvD6VanX+Hp5jdnn1Fx0IA5Nz/F
         vRCx+g+ERnhGwrzAf4xfM6i51p1fulSIJ8p+QCD3ZSoiiWcxkm/I/yQBHjdktRs+D/yv
         2magO4uKNotuZoG0CVHVLndXZemJUdXPjbHdepRpWtmoRNV8ShvzvVnJPWiF3AYO2bVW
         0NkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757974350; x=1758579150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hr8LZude88xba8bJloaRJyQTYbUOUfQ4ZPSQ9KFa+7A=;
        b=WzTmQ3rkr6rnKgaTQ8CWPnGEHiMwDhIVeX0av28E4wvbtHsieOhtiKybadSsGg8SpL
         +3bFyezJxygaUdmWy7hGYQmHuaE+uoni6B7ghaJNrtvSwdw261XCSuK1QbZtJ++Ou+lR
         DxvBBevv2d4TpBm+iLjLtl3vEewj/g+hpSHRdpB7ZrxbKz13QPtF1Ub0lcfLtCoG51jv
         /mIVO4V23JlktQr/WhgspTYsSLYM4UsRsLjut25+nCkT5DK5ms6wxUm2tdN6aj6WtIQX
         VSzrK7dML87U5hxH5Yt+8fQSVv0pDBrN+Lte5ltugh5jn1fm04pyJ1XmgcrRgf9/Zvix
         oURg==
X-Forwarded-Encrypted: i=1; AJvYcCURsClvNRV4f7ABTGd5CXAe7FfxQVhqBjXd9CZ20Kp/WRJufar0DOJgsydTaB6Y6NpNzec=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgvE6ukrncjw9yTaFTahSpJC96bEOZtUbSmngFUAeMJLdT5H0r
	Z8LHWiNOM8/3nhB5IOVpn2sxgqZ0J1hdfPQWbt89n3GcOSyTGH9ZfRnzLrOyWeUIVWPXHrwxb3N
	udUKlfA==
X-Google-Smtp-Source: AGHT+IFYB1LmHv0XQLVEdkS8gxXjB2AMclzITY7YSD46tThFFzfxBvuQrogabKdZsaRHQj7NStxA3mjEfRk=
X-Received: from pjk14.prod.google.com ([2002:a17:90b:558e:b0:32e:27d9:eda1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c82:b0:32b:dfdb:b27f
 with SMTP id 98e67ed59e1d1-32de4f961d1mr18891549a91.17.1757974349882; Mon, 15
 Sep 2025 15:12:29 -0700 (PDT)
Date: Mon, 15 Sep 2025 15:12:28 -0700
In-Reply-To: <aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-14-seanjc@google.com>
 <aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com>
Message-ID: <aMiPTEu_WfmEZiqT@google.com>
Subject: Re: [PATCH v15 13/41] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Xiaoyao Li wrote:
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> > @@ -6097,11 +6105,22 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
> >   static int kvm_get_reg_list(struct kvm_vcpu *vcpu,
> >   			    struct kvm_reg_list __user *user_list)
> >   {
> > -	u64 nr_regs = 0;
> > +	u64 nr_regs = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ? 1 : 0;
> 
> I wonder what's the semantic of KVM returning KVM_REG_GUEST_SSP on
> KVM_GET_REG_LIST. Does it ensure KVM_{G,S}ET_ONE_REG returns -EINVAL on
> KVM_REG_GUEST_SSP when it's not enumerated by KVM_GET_REG_LIST?
> 
> If so, but KVM_{G,S}ET_ONE_REG can succeed on GUEST_SSP even if
> !guest_cpu_cap_has() when @ignore_msrs is true.

Ugh, great catch.  Too many knobs.  The best idea I've got it to to exempt KVM-
internal MSRs from ignore_msrs and report_ignored_msrs on host-initiated writes.
That's unfortunately still a userspace visible change, and would continue to be
userspace-visible, e.g. if we wanted to change the magic value for
MSR_KVM_INTERNAL_GUEST_SSP.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c78acab2ff3f..6a50261d1c5c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -511,6 +511,11 @@ static bool kvm_is_advertised_msr(u32 msr_index)
        return false;
 }
 
+static bool kvm_is_internal_msr(u32 msr)
+{
+       return msr == MSR_KVM_INTERNAL_GUEST_SSP;
+}
+
 typedef int (*msr_access_t)(struct kvm_vcpu *vcpu, u32 index, u64 *data,
                            bool host_initiated);
 
@@ -544,6 +549,9 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
        if (host_initiated && !*data && kvm_is_advertised_msr(msr))
                return 0;
 
+       if (host_initiated && kvm_is_internal_msr(msr))
+               return ret;
+
        if (!ignore_msrs) {
                kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
                                      op, msr, *data);

Alternatively, simply exempt host writes from ignore_msrs.  Aha!  And KVM even
documents that as the behavior:

	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
			Default is 0 (don't ignore, but inject #GP)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c78acab2ff3f..177253e75b41 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -544,7 +544,7 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
        if (host_initiated && !*data && kvm_is_advertised_msr(msr))
                return 0;
 
-       if (!ignore_msrs) {
+       if (host_initiated || !ignore_msrs) {
                kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
                                      op, msr, *data);
                return ret;

So while it's technically an ABI change (arguable since it's guarded by an
off-by-default param), I suspect we can get away with it.  Hmm, commit 6abe9c1386e5
("KVM: X86: Move ignore_msrs handling upper the stack") exempted KVM-internal
MSR accesses from ignore_msrs, but doesn't provide much in the way of justification
for _why_ that's desirable.

Argh, and that same mini-series extended the behavior to feature MSRs, again
without seeming to consider whether or not it's actually desirable to suppress
bad VMM accesses.  Even worse, that decision likely generated an absurd amount
of churn and noise due to splattering helpers and variants all over the place. :-(

commit 12bc2132b15e0a969b3f455d90a5f215ef239eff
Author:     Peter Xu <peterx@redhat.com>
AuthorDate: Mon Jun 22 18:04:42 2020 -0400
Commit:     Paolo Bonzini <pbonzini@redhat.com>
CommitDate: Wed Jul 8 16:21:40 2020 -0400

    KVM: X86: Do the same ignore_msrs check for feature msrs
    
    Logically the ignore_msrs and report_ignored_msrs should also apply to feature
    MSRs.  Add them in.

For 6.18, I think the safe play is to go with the first path (exempt KVM-internal
MSRs), and then try to go for the second approach (exempt all host accesses) for
6.19.  KVM's ABI for ignore_msrs=true is already all kinds of messed up, so I'm
not terribly concerned about temporarily making it marginally worse.

