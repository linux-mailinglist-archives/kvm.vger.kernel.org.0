Return-Path: <kvm+bounces-58174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0E8B8AD62
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07B09A03495
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F8332276E;
	Fri, 19 Sep 2025 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pQB/oqDn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C319A1F152D
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758304699; cv=none; b=cX/JVRI4BxLTophSdJMPrTa4gIS3QndjUgGC0RML6A2BIQtR49RyRolNAk1beEWJIdpnkhn3tHRq94CETCyeRl1VhJT6iQKrVk0Wx65yR90wPcA/PJnTYjmk9p0n3a3+onxWJekeAPmg7HoUgzGI9/nJF6HTIS8GInucMLZtef8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758304699; c=relaxed/simple;
	bh=uLIkvEtIzGX1v8v50qAs1CDnWlrCfYVlffYX1ZV+o+Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C0pOGPr8qe51vV7VwYx3PE6kZ/7KNOt0cfpqmvkjOHUDfgywLkfPp1kr8x28leMmcP9C4t0i6J5gIH3Tj49WrXhhtJaeglAgNrd7bdpX/C2d4h5HcCSd5rS6Kyeb0V0Dgp+Nu9rJSCNHbEbMEIqSIgvLXkhXAeoI4pArONpi6YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pQB/oqDn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32dd9854282so3481019a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758304697; x=1758909497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0q97Hto0x87Uf34glk44E5CdssqQo7iDL3JqbWg6pt0=;
        b=pQB/oqDnfTKqY4QEJK01VA4r9+LlSY+tS2TQsyeGA4MJu+KEPTNJxqHNDRPUom/hK/
         Ggz9Icw8v2MU7uTLSJDZPpKZhxjKqN7uS8KSpxciRiepuiuyljMwyVwq8X3paLPhy//6
         M/lmIzc2Ijfk22hUWafaZVALp622SmtskWCGU01EQHfRnan+ztG6my+FpBJGM+P8d+4H
         3tBsgdhEO7dy4gfhaHHj3yCJqLuIlJwYOcAxM/HJ71X9mWoLDXXvTC3xJo1ONKf6C0GG
         hE/7xj0AQOtczEoVPQo8cN3htQAVIXHElaY4a1bxxlAKQr03mr8xEgb+C27tknmrgv2p
         ABbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758304697; x=1758909497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0q97Hto0x87Uf34glk44E5CdssqQo7iDL3JqbWg6pt0=;
        b=YFdXilRB6JA4LunA40qFqMb60oOa5UE7pAuLZvdQihsc2GBfzxuJULicqvNvTuj3Di
         bayCj6lBAh+npi1F6pfp41dMsapIxqoFJqYWuQchTMbzzoVAaeuLfz8v4FHXB8/oY738
         NDWNBhGmPCbqCtwjvEulivUGMKZrWsJ9dtVbbdof+zm6Yx7/kN/yP2sYWT6mBQFgVGkn
         hm+Z+KS3pOgR7oEm5isvPhommVH352IKQMASRk8B7hGS2oHcba+3mG8M2FuKlOCSJKEg
         6/c+wwPNxLfJ1oBALjK/3sPg7HmWXGEIQsJSgRnofpBdWSNMySbiZJ71caFo3hZADKYS
         CAWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvdrqcNCW49EgkcGwpCjEzd6tCDQxX/a3r31z5NxKUsOhvMPsnKKHD5XAWkQFpd78izpY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9g4Hcu1tm/o7fp9DjwPNtyqEofKgm/jLgDRLB/MLa3CqdV348
	H3TFMN4y1a0G+A4jjUrDfJoK1BUCXFH+DPMNvKTtiBc9VSWHJGjYyomtc19X0tQkolO4S7YArZW
	y2AqzIQ==
X-Google-Smtp-Source: AGHT+IGdCRYTTV0YTTBa/yjp+sS56WIstVSosXG2ct7aGNWpLTvcMX6dA6Do4Up5TsXMSSxWoDnwQSOmPRk=
X-Received: from pjbpw3.prod.google.com ([2002:a17:90b:2783:b0:32b:8eda:24e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e53:b0:32e:32e4:9789
 with SMTP id 98e67ed59e1d1-33097fdc3ffmr5364626a91.3.1758304696561; Fri, 19
 Sep 2025 10:58:16 -0700 (PDT)
Date: Fri, 19 Sep 2025 10:58:14 -0700
In-Reply-To: <aM2XJjYyssKU9ScY@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-14-seanjc@google.com>
 <aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com> <aMiPTEu_WfmEZiqT@google.com>
 <d1bfb652-19ff-434f-bd51-b990543d14d6@intel.com> <aM2XJjYyssKU9ScY@google.com>
Message-ID: <aM2Ztr_PChkeefXf@google.com>
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

On Fri, Sep 19, 2025, Sean Christopherson wrote:
> On Tue, Sep 16, 2025, Xiaoyao Li wrote:
> > On 9/16/2025 6:12 AM, Sean Christopherson wrote:
> > > For 6.18, I think the safe play is to go with the first path (exempt KVM-internal
> > > MSRs), and then try to go for the second approach (exempt all host accesses) for
> > > 6.19.  KVM's ABI for ignore_msrs=true is already all kinds of messed up, so I'm
> > > not terribly concerned about temporarily making it marginally worse.
> > 
> > Looks OK to me.
> 
> Actually, better idea.  Just use kvm_msr_{read,write}() for ONE_REG and bypass
> the ignore_msrs crud.  It's new uAPI, so we can define the semantics to be anything
> we want.  I see zero reason for ignore_msrs to apply to host accesses, and even
> less reason for it to apply to ONE_REG.
> 
> Then there's no need to special case GUEST_SSP, and what to do about ignore_msrs
> for host accesses remains an orthogonal discussion.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4ed25d33aaee..4adfece25630 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5932,7 +5932,7 @@ static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
>  {
>         u64 val;
>  
> -       if (do_get_msr(vcpu, msr, &val))
> +       if (kvm_msr_read(vcpu, msr, &val))
>                 return -EINVAL;
>  
>         if (put_user(val, user_val))
> @@ -5948,7 +5948,7 @@ static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *user_val)
>         if (get_user(val, user_val))
>                 return -EFAULT;
>  
> -       if (do_set_msr(vcpu, msr, &val))
> +       if (kvm_msr_write(vcpu, msr, &val))
>                 return -EINVAL;
>  
>         return 0;

Never mind, that would cause problems for using ONE_REG for actual MSRs.  Most
importantly, it would let userspace bypass the feature MSR restrictions in
do_set_msr().

I think the best option is to immediately reject translation.  That way host
accesses to whatever KVM uses for the internal SSP MSR index are unaffected by
the introduction of ONE_REG support.  E.g. modifying kvm_do_msr_access() would
mean that userspace would see different behavior for MSR_KVM_INTERNAL_GUEST_SSP
versus all other MSRs.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab7f8c41d93b..720540f102e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6016,10 +6016,20 @@ struct kvm_x86_reg_id {
        __u8  x86;
 };
 
-static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
+static int kvm_translate_kvm_reg(struct kvm_vcpu *vcpu,
+                                struct kvm_x86_reg_id *reg)
 {
        switch (reg->index) {
        case KVM_REG_GUEST_SSP:
+               /*
+                * FIXME: If host-initiated accesses are ever exempted from
+                * ignore_msrs (in kvm_do_msr_access()), drop this manual check
+                * and rely on KVM's standard checks to reject accesses to regs
+                * that don't exist.
+                */
+               if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+                       return -EINVAL;
+
                reg->type = KVM_X86_REG_TYPE_MSR;
                reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
                break;
@@ -6075,7 +6085,7 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
                return -EINVAL;
 
        if (reg->type == KVM_X86_REG_TYPE_KVM) {
-               r = kvm_translate_kvm_reg(reg);
+               r = kvm_translate_kvm_reg(vcpu, reg);
                if (r)
                        return r;
        }

