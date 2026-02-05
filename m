Return-Path: <kvm+bounces-70359-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNREE3behGmi6AMAu9opvQ
	(envelope-from <kvm+bounces-70359-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 19:16:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C3AF667A
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 19:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 643C430252B5
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 18:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5CD3009CB;
	Thu,  5 Feb 2026 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mN40ooNX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070A1684B0
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770315367; cv=none; b=e/WKBxw+w25qBitcTn8QFKFh9gV2NashbL4YKjXTDC1W91YeiyM6k8veuNHZt5DVV8Ojt2CYI715BY3T1xf16OOLrAg9bJ6IGkemaC0L3/T2P8FdIIwTFtxsB3iBXC57zLqWpcyxGCNPE04Hotfi3kXaplxH0h54J8PJ5ucAOBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770315367; c=relaxed/simple;
	bh=JaSiFx5tGgruRq7Qg3RAVqyVwcNl8rziDHWnfcUwWpk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z2KMlxtaNr5MYDlqUw49shHvpevdpw9ZXd/XV5Chw4QO6Dj3c53MDBIkbEliC3Z5ogODXvj1SWMINVS5OuQ8A5HIhVHNt1z/EtM4UGcgEYpdjAHaVA6RfE4YeyfFSEXX/IrT0eICg0RETRUtU3sidBNuvB0dnLYbtSHVBJH/T+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mN40ooNX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c52d37d346dso744739a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 10:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770315367; x=1770920167; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w63WtH6exvgU3XpaEY5YF/xmw4rPvTE/WzLO1Z+uiT0=;
        b=mN40ooNXmhao3cRSagt4b2tS8rAftuf/qZbjBeCP0sZc+TcAJJ3r+dzj2zrB1XF6G/
         1RZ/dpoegkaBzCCEDCwIlgpi17hPJ9TSUTqOatZ9i37uh/rwSdyHz12s5S/2XcrQ1/yy
         aMAd6LHxSaZ3MaoTl8AvzxRSPqyZ8ZVGK3S6oL4EW/EZ8Dj8BUNWyWj6DomjPVOZRfMK
         cMu9Mclyn6olt5/+3GkeDnM/v7KQC2uBrbEZthNcz71ItwpVYFImNLtUFMuf+ld6cs7R
         8UBjN99FbGKsh5FCyqZXj01D5F3H+fqAQWFFbSTsyWG+A80UuTkI19kj6s9W8dKabudM
         iTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770315367; x=1770920167;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w63WtH6exvgU3XpaEY5YF/xmw4rPvTE/WzLO1Z+uiT0=;
        b=Wp2wmAZundkAtNVwrK/eWqresgsB1n1BT9OMtVSgMhwtb22W1DVix2JFopfi36aoda
         9iBagxDmqqhr3ZengYqEON78on1Bj5BTWHMA026/1WgIt4znh41/0RTMRCq6BGBuu8wN
         +4dZeDT8oxiKEmfIPiOynb5l72n0xhDUlyKLq5Kz/oR5Juue9jqZamaLQOwLqQLDERA+
         XlyS0Rh7/tioL7/svWZPgMOZzuY7JNWyEcfkerI8whrS34Xw1I2mAYPBiG344RNKrXxa
         olrGf5cCBjSeBziQ/5tGg802mo6wpMXIOVST27H73vEO1IxGO/g0k0ipBIWj/NgcxRmM
         dyoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJSfwUNDMEHeuj1P/aDfGrkDt9fSRjbdA9XVw9OiH+rXVIft2SXf6oCPKkIT41u0pDCNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDZ+kVNFWFnDvRmtn5M98/EKuWvBOcZ19J463vCXBB/jkBlyD9
	/lWNuUGZzRuEi4E0B5WlgbcLMwlwuqLNmoP2Mgo4StEYFhQAxbCOL4POHfgmp3231T/yLf0b8RK
	f1Chmbg==
X-Received: from pgqs26.prod.google.com ([2002:a65:691a:0:b0:c61:3772:dcf4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d9b:b0:35f:6e12:186f
 with SMTP id adf61e73a8af0-393ad0016c0mr253956637.23.1770315366666; Thu, 05
 Feb 2026 10:16:06 -0800 (PST)
Date: Thu, 5 Feb 2026 10:16:05 -0800
In-Reply-To: <CALMp9eT_uJZwO5AF-wWHFH1DnOKWjUtU2u9TCOs7=ZK8_xCx+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
 <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
 <aYKoJ74MWboBuE_M@google.com> <CALMp9eSc=0zS+6Rk-c_0P-Q1Y8_9Xv58G5BYxieKpv_XaSj0wg@mail.gmail.com>
 <aYPvyMDipM9Z9Z7t@google.com> <CALMp9eR4trBDwgDnyEJmrHnStKnAMiRgehty=xu=NMnLVN2vtw@mail.gmail.com>
 <aYStVN5MyME-Pkwt@google.com> <CALMp9eT_uJZwO5AF-wWHFH1DnOKWjUtU2u9TCOs7=ZK8_xCx+w@mail.gmail.com>
Message-ID: <aYTeZY1DoJUyrGzo@google.com>
Subject: Re: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70359-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: A2C3AF667A
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Jim Mattson wrote:
> On Thu, Feb 5, 2026 at 6:47=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > > > In other words, unless I'm missing something, the only reasonable o=
ption is to
> > > > run the guest with FREEZE_IN_SMM=3D1, which means ignoring the gues=
t's wishes.
> > > > Or I guess another way to look at it: you can have any color car yo=
u want, as
> > > > long as it's black :-)
> > >
> > > I would be happy with FREEZE_IN_SMM=3D1. I'm not happy with the host
> > > dictating FREEZE_IN_SMM=3D0.
> >
> > Yep, make sense.
>=20
> Perhaps we should ignore both L0 and L1, and arbitrarily set
> FREEZE_IN_SMM=3D1 for both vmcs01 and vmcs02 when MPT is enabled.=20

Hmm, I like that idea even more, because it's waaay simpler to implement.  =
Argh,
the wrinkle is that KVM doesn't actually know if DEBUGCTLMSR_FREEZE_IN_SMM =
is
supported.  Oh, nice, it's reported in PERF_CAPABILITIES.

  IA32_DEBUGCTL.FREEZE_WHILE_SMM is supported if
  IA32_PERF_CAPABILITIES.FREEZE_WHILE_SMM[Bit 12] is reporting 1

Arguably, this is a fix for mediated PMU support.  Because as you pointed o=
ut,
we can freeze PMCs on SMI for mediated vPMUs without impacting host profili=
ng,
unlike the legacy vCPU where it being a weird extension of perf means we ca=
n't
deny guest profiling without breaking host perf usage.

This? (untested)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-in=
dex.h
index 4d3566bb1a93..5563f68158bb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -324,6 +324,7 @@
 #define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
 #define PERF_CAP_ARCH_REG              BIT_ULL(7)
 #define PERF_CAP_PEBS_FORMAT           0xf00
+#define PERF_CAP_FREEZE_IN_SMM         BIT_ULL(12)
 #define PERF_CAP_FW_WRITES             BIT_ULL(13)
 #define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
 #define PERF_CAP_PEBS_TIMING_INFO      BIT_ULL(17)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 27acafd03381..ef0d8108ff42 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8119,13 +8119,12 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu=
)
 static __init u64 vmx_get_perf_capabilities(void)
 {
        u64 perf_cap =3D PERF_CAP_FW_WRITES;
-       u64 host_perf_cap =3D 0;
=20
        if (!enable_pmu)
                return 0;
=20
        if (boot_cpu_has(X86_FEATURE_PDCM))
-               rdmsrq(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+               rdmsrq(MSR_IA32_PERF_CAPABILITIES, kvm_host.perf_capabiliti=
es);
=20
        if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
            !enable_mediated_pmu) {
@@ -8139,11 +8138,11 @@ static __init u64 vmx_get_perf_capabilities(void)
                if (!vmx_lbr_caps.has_callstack)
                        memset(&vmx_lbr_caps, 0, sizeof(vmx_lbr_caps));
                else if (vmx_lbr_caps.nr)
-                       perf_cap |=3D host_perf_cap & PERF_CAP_LBR_FMT;
+                       perf_cap |=3D kvm_host.perf_capabilities & PERF_CAP=
_LBR_FMT;
        }
=20
        if (vmx_pebs_supported()) {
-               perf_cap |=3D host_perf_cap & PERF_CAP_PEBS_MASK;
+               perf_cap |=3D kvm_host.perf_capabilities & PERF_CAP_PEBS_MA=
SK;
=20
                /*
                 * Disallow adaptive PEBS as it is functionally broken, can=
 be
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 70bfe81dea54..e780d0e06b61 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -408,6 +408,11 @@ static inline void vmx_guest_debugctl_write(struct kvm=
_vcpu *vcpu, u64 val)
        WARN_ON_ONCE(val & VMX_HOST_OWNED_DEBUGCTL_BITS);
=20
        val |=3D vcpu->arch.host_debugctl & VMX_HOST_OWNED_DEBUGCTL_BITS;
+
+       if (kvm_vcpu_has_mediated_pmu(vcpu) &&
+           (kvm_host.perf_capabilities & PERF_CAP_FREEZE_IN_SMM))
+               val |=3D DEBUGCTLMSR_FREEZE_IN_SMM;
+
        vmcs_write64(GUEST_IA32_DEBUGCTL, val);
 }
=20
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 70e81f008030..e0084e1063d0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -52,6 +52,7 @@ struct kvm_host_values {
        u64 xss;
        u64 s_cet;
        u64 arch_capabilities;
+       u64 perf_capabilities;
 };
=20
 void kvm_spurious_fault(void);

