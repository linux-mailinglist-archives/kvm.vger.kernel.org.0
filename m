Return-Path: <kvm+bounces-35398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB178A10CE0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C4511885F29
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 16:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7531D516C;
	Tue, 14 Jan 2025 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z7IGExJC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144E81C4617
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736873944; cv=none; b=CSmEeDulbJeIlsVCJN6DkGwcwE3cJjIDXrwYtpnyrjHPZ6ySVtESvjgBiAkiW8HGBgFAeVSCnKbrsocYJ1tXE95bTAAA8ZMVieeD+GS62TC2nHaRn5NUVwlUq36CdbcxceOKLyrl4gPddPNxe6N9zvoJxoemAgHZZyzMV6T1lyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736873944; c=relaxed/simple;
	bh=cTPCgZybjgGxoWnvCmC6onK0qXp5XJBkCCWCEp82r4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LNH07eq4leYAWi0Vl4kpaveJ0+fIbUngfscDaJTwhXsgthfeC69YIB/9fs4sp7kRLVGqwOm2blLhkYjCGvoRL3EMRAKIB3pHAvl98Mivvn4s6al2oJ7YUCnaXGHAjZjNmlQBNFl4PA2Mz/4+zBYVXNsB3TU93XLeiHSkTxirHto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z7IGExJC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee6dccd3c9so9792867a91.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 08:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736873942; x=1737478742; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFDxuX2IJcNSQnso3/JpRuLa7ermog8cVuxURDolQyA=;
        b=Z7IGExJC7FYfF1a/sKNzrMH5q8FYZSs0mJXCSCvNeSCN7BRZNvEdFxjYAZ38NEbBQN
         ccJSz6MVllV5dN+wsHCphoF+EVWyBuhD0aVTPW000K2PJhBqHDxqMJJSS2Pz7X/6qC0a
         +G/LOgq7fLNqNpj+fqSWBWzEGTstu5bIn7ttkw9z2OHjkWRfwHZyAThn8hNiqXop7jz2
         6UnBeNPN6QLEWGthWvRofJQ5Am2M5rtacjohdXsZnF7Qb8KMUIFnDveuP/32l7sf83/n
         mjg7EIUtCClKUtZP9aRgyN44nMTJGu4VKk2tlmgpzBOT6QcVJRYazJVTPanfACL7zO2K
         /Nqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736873942; x=1737478742;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FFDxuX2IJcNSQnso3/JpRuLa7ermog8cVuxURDolQyA=;
        b=OPI3GoaZzSMfGWzp9SPZs2ql5UsQiuAlUW4/VUNGFsD/yhjBqjgCPc0FCUUOBfr7Hx
         jVpR9bvdR4yvKtt4BPTqJAXQzRqeFN+BCGhcbzUmt5WvU7jpASvx1iXu5lCUjJ/0pN/h
         1tBI4YPrsnN98s0TiH5HuPmEvjvQ133ev8JaUauM3d/k6aQWxkHh1LUQ/pu3vKJDjeDc
         e8jGKuqJ1piLKYHcx57k5tuBi5zAjDy0r6Hj2jhVGRwAUh3RBTxaQU9R4cAdEHUJDb7d
         YNbd2dZOoozyHr+hAkJO1MAmunNrohQQ8RSjB80A9K51vOMiCg7OZu98DMqRjsinj2VM
         FqSA==
X-Forwarded-Encrypted: i=1; AJvYcCWT1Ix0HP8fH09HRsdrwLJyVWBApejLa6rNH2xYsDa+FxC0z+/HXs7m0ephZiXss7anh+8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys+NReZdb37ocRPSsab8+wp06V1bKhbIKLMNC9ak4KDoJxisRo
	t7LW3CjE4i4NqEKtyoc4lDELjkquNF4WCk2Dftyay3d76vMEsTnZ/yCBmOxlWX0EmAWeWSQrDiS
	jBw==
X-Google-Smtp-Source: AGHT+IGcbU/ZRTlWmJyulxFLEuAKTsIN2drNXPY0TcjZmGVTtDPbqAnCMgFSXUmKuLZCq+gbfs0BsetyLKY=
X-Received: from pjbqb12.prod.google.com ([2002:a17:90b:280c:b0:2ea:5be5:da6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d09:b0:2ee:a6f0:f54
 with SMTP id 98e67ed59e1d1-2f548f33baemr36642177a91.13.1736873942475; Tue, 14
 Jan 2025 08:59:02 -0800 (PST)
Date: Tue, 14 Jan 2025 08:59:00 -0800
In-Reply-To: <4dcc7c65-18d1-432b-8e98-501e0c38fc6b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com> <Z4VKdbW1R0AoLvkB@google.com>
 <4dcc7c65-18d1-432b-8e98-501e0c38fc6b@linux.intel.com>
Message-ID: <Z4aX1NjuxeCJd1XY@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2025, Binbin Wu wrote:
> On 1/14/2025 1:16 AM, Sean Christopherson wrote:
> > On Mon, Jan 13, 2025, Binbin Wu wrote:
> > > Summary about APICv inhibit reasons:
> > > APICv could still be disabled runtime in some corner case, e.g,
> > > APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED due to memory allocation fai=
lure.
> > > After checking enable_apicv in tdx_bringup(), apic->apicv_active is
> > > initialized as true in kvm_create_lapic().=C2=A0 If APICv is inhibite=
d due to any
> > > reason runtime, the refresh_apicv_exec_ctrl() callback could be used =
to check
> > > if APICv is disabled for TDX, if APICv is disabled, bug the VM.
> > I _think_ this is a non-issue, and that KVM could do KVM_BUG_ON() if AP=
ICv is
> > inihibited by kvm_recalculate_apic_map() for a TDX VM.  x2APIC is manda=
tory
> > (KVM_APIC_MODE_MAP_DISABLED and "APIC_ID modified" impossible), KVM emu=
lates
> > APIC_ID as read-only for x2APIC mode (physical aliasing impossible), an=
d LDR is
> > read-only for x2APIC (logical aliasing impossible).
>=20
> For logical aliasing, according to the KVM code, it's only relevant to
> AMD's AVIC. It's not set in VMX_REQUIRED_APICV_INHIBITS.

Ah, right.

> Is the reason AVIC using logical-id-addressing while APICv using
> physical-id-addressing for IPI virtualization?

Ya, more or less.  AVIC supports virtualizing both physical and logical IPI=
s,
APICv only supports physical.

> > To ensure no physical aliasing, KVM would need to require KVM_CAP_X2API=
C_API be
> > enabled, but that should probably be required for TDX no matter what.
> There is no physical aliasing when APIC is in x2apic mode, vcpu_id is use=
d
> anyway.

Yeah, ignore this, I misremembered the effects of KVM_CAP_X2APIC_API.

