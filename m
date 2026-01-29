Return-Path: <kvm+bounces-69556-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Ab/Fdx4e2nWEwIAu9opvQ
	(envelope-from <kvm+bounces-69556-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:12:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCB9B1542
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05BB13012EB8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6993148A6;
	Thu, 29 Jan 2026 15:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NrL+KWb4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A131C1F02
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769699525; cv=none; b=UUHwNnAPyEKGSDPJsxkohlG/7UjjSxnZN3vU6TgIfBzLeo2BtRcRQuzCyunz1kInHlEeiJPMAi9Np4XY/hqgp/cl5ffcOWVy4FlXHwr0stkVXPhD52eOZ0SGRgx7n8Oast496NBPdJ5Mv9P/rxViWcEwlNl3GDvQwxvOV9ycNPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769699525; c=relaxed/simple;
	bh=sA5T9gW0TAD5jrJgR0Anj1Ohz7jzIcsd3GswmubIOXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NCo2CWPfCQuq9ZT1wgO3pQtCq+GB5Y/AaOs/+ZJDX2NxseU3HOHco7MBWBFWqVtVDxhdYhDtK2UWbL4QzJysFX1FnPPRH81V/jIqsBXu3rOvw1yDCwdf/uAD63/ZTwCaU/CLWBfIauGzCTE2SGDoGu2MIu5sz6MP/7eYYzVOkbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NrL+KWb4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c636238ec57so728494a12.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 07:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769699523; x=1770304323; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s9kHKjSq4qleJmEsJAzaJ+D2RjwhSg1oHgKsobJdsyg=;
        b=NrL+KWb4njsBPnR7kR8MqHF+2WRog92yzafMnnn/VB3AlO4Il1PeJ10yWk7VjfDaNc
         mjMY6+qcKbtpd9C/FS9rd8cA0ri1SyGofWMGXwEs0OEWXi6kmPbwyFtkffkM8EPRYKBy
         x4EOEWElM3P2UVws+mOQWG+bPFCnowbPtgWo0Ocwh3jSaMMQVfH9zaOHt4IOrZ7DhzpO
         LvpqWczuyatoYUVmAc3Y12JQYlhLDtUcMecMbhHAGveYQwKl5Y+Gy2vpkB0wQ2InwFe3
         epy+1RgeRQn/iBfJk1W2wX3duxJ1IfUh2zPkOFhOtoOJPcoblyzA5Uy77ebNiqbjxoli
         Dbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769699523; x=1770304323;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9kHKjSq4qleJmEsJAzaJ+D2RjwhSg1oHgKsobJdsyg=;
        b=Lz5aPHT3/SEnSjI+RhgUcMqF2W6r/ozX5YykrWUchOUpFF6A+sGa+Kn6vZDHWCHl9D
         Iz0vKjMYnFzKxoBc4b7N7t8ibce8vt/z4LS8zC+AkbXlRLqVr388UP2rtKY+oHAkcqT5
         mGWOKrq7wxM2nb8DyNn45q2PBDKdNu6LBzwT2uaaq36cdxM3dZ6WuVuGvx7MuyIvl91H
         Dd3ENAkruQ+hAJ1gccQOK8IIYgptFpSTH5FarpLHF5Vw0wcSEGhPHiXa9PE9wnfTlroJ
         Jh/GpLE2H5x/ARVDc/qIIQRAfD9IwhF3/LFnFhso4j1J5gFYzeSG+GJxUIqMIZUg1uEb
         P9NQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+ls3xyWjL9Uba1S6ENfqVlPrLtWyuVaJPInrpJdk+9ZA9tgr20kHazKORHHa1DukxzX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoYdxftmj0IVSbonIBApi4fb74gT6YyELE6Et+uZ0IWNkIFJOE
	Hjzamn+jR/198zb2bCtcYpVwkjKqOXO8tA6WPvmCb9BmE22Au8vACGIl2NCg47YlBt7/bMPijhH
	QChowdQ==
X-Received: from pglq12.prod.google.com ([2002:a63:504c:0:b0:c5e:eb90:df6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:95:b0:38e:5f46:bdfb
 with SMTP id adf61e73a8af0-38ec657fe37mr9054043637.73.1769699523234; Thu, 29
 Jan 2026 07:12:03 -0800 (PST)
Date: Thu, 29 Jan 2026 07:12:01 -0800
In-Reply-To: <7f045418-6ce4-4f2f-a3ee-4ddc3cf2fda5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260128014310.3255561-1-seanjc@google.com> <20260128014310.3255561-3-seanjc@google.com>
 <7f045418-6ce4-4f2f-a3ee-4ddc3cf2fda5@intel.com>
Message-ID: <aXt4wf6Vpo5da2rc@google.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-69556-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EDCB9B1542
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Xiaoyao Li wrote:
> On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> > Add a flag to track when KVM is actively configuring its CPU caps, and
> > WARN if a cap is set or cleared if KVM isn't in its configuration stage.
> > Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
> > vendor setup code expects the CPU caps to be frozen at that point, e.g.
> > will do additional configuration based on the caps.
> > 
> > Rename kvm_set_cpu_caps() to kvm_initialize_cpu_caps() to pair with the
> > new "finalize", and to make it more obvious that KVM's CPU caps aren't
> > fully configured within the function.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/cpuid.c   | 10 ++++++++--
> >   arch/x86/kvm/cpuid.h   | 12 +++++++++++-
> >   arch/x86/kvm/svm/svm.c |  4 +++-
> >   arch/x86/kvm/vmx/vmx.c |  4 +++-
> >   4 files changed, 25 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 575244af9c9f..7fe4e58a6ebf 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -36,6 +36,9 @@
> >   u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
> >   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_cpu_caps);
> > +bool kvm_is_configuring_cpu_caps __read_mostly;
> 
> I prefer the name, kvm_cpu_caps_finalized. But not strongly, so

"finalized" reads too much like the helper queries if the caps are already
finalized, i.e. like an accessor.

