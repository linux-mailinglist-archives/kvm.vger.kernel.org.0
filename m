Return-Path: <kvm+bounces-61693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BF809C25ED6
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 16:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AEA06350A91
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 15:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C662ECD2E;
	Fri, 31 Oct 2025 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FIVFPezx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EFC2EB87E
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761926160; cv=none; b=n/zwYCbUGR3fbB4RXSTEY66XlNGZumDmxiaB25S0Cw2ibGDQhdBZnv8tu7yjiqe6ll6//IDHdogLV92XkoVHTUBM+LA5iKaCJCW6noCd/y7rTSXok055qBCgWBpdXZG6eu8wand5q5L2g+MiKxqoYmMw+BD90NZa+AtY1xxc4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761926160; c=relaxed/simple;
	bh=t8Bki2mZlE4ZDwdVcMbMtVwPgZgWgPVZgc6TnvQRl9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VsZYosECFUwVq26/GQyZofjuv5ZXnXBN4gxYzpkjrf3qmCHmSlTQLcqzTAxT4Ud/jo1IAp+xXr737WVPtk6tIUWKLLQZZpwfd6IXsHx8e1bNo01cjbalRFr47tFtgS4vyBwMTCls03lYejOYkzuu9YRIZZ/XbdwRLVsUkj+4Ntw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FIVFPezx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340bb1bf12aso60124a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 08:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761926158; x=1762530958; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eSE6VWD4vxaaTE+0KBr/ChxCqFBWm8TM2v7b9di8yIw=;
        b=FIVFPezx07D5IdTkgodTZt+ara/8KqP1yM/NoZHCUO5dX8b+CWQA1rdA2GqNExzreD
         UNUrH9hDQjG3VqhGl3c2KAtRjZj0nGij0BEAbhC50QEAvFU2SRCAgXr+uagdl4aCcmuM
         fkNdaiB2yom3IM6fsAB2WUOhIVNE1gICajl+0x7IjroHeCQEWiv3pB60cs9ScVaBn4FP
         uMNLyfic0wWsaptlnVwwhohm2OnMjb6jhRS9fT7RfGhTAYkBV++KeY/EQwu9uCGmR0Fi
         IeCD/HZgUXJcfY2cG7qjyLKEAG8Bf663v4unJvsyqWxiznFP2Xi0NM7tscSCTEHSblk3
         Og5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761926158; x=1762530958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eSE6VWD4vxaaTE+0KBr/ChxCqFBWm8TM2v7b9di8yIw=;
        b=wT7Qh4Z3Ic+bLurvFDK7EgoTzDOecjZgTbIRx5NdI+Jt5vg8DwBjEJHbZXSayYZ8Xq
         Oi5G7iDLjpTtuOGBv1zF5q27UpFGbVzIybULADJfrKx17XOuDbsHtUoPzfSAq9EYcZkL
         PqdfKT91RE8Nl5pzIBTZYnXb6CYL2AUCglvNm/zNAieTS8t9TLYxHWkuqPmVGxoY6bWJ
         4PZ2DUYCvQrfybx7d0in7H1XRvgKz6XHmo0FMr9fAjB8MWmR9lNRh7Xv3fX60NCj0wiz
         NZYw7HpjVQW3yB+XVbIpfGi4tQSSaMOvxIZWGANQUMFSIZZ7m/Td36LpV715lnum+Cqz
         jnLA==
X-Forwarded-Encrypted: i=1; AJvYcCVYKhW3RA+SbSKuIjz/C76uF0qV3anR7BLXo4l2OZ2V5jy0PpUYh+pyev0JOusj0n9F72Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YymWMMK/xNo5AqmdyzRdynWny89nertgyAES8RPNDiB4PdtjBpC
	k1YDq4ABZwaL+CJlTlw8AVOzL1HdK20fQDYqPxUHN8v5x+3gwT5/a7T3clnHYqztjbhL1a6yoAa
	sbE3OgQ==
X-Google-Smtp-Source: AGHT+IHK5XrSj2/97kQFOhhQkT/88rHDWAg9SuzbdwRpl3MTETpFtRtdCwbGXG4UVT+AGrJf8RWbxI8IFXY=
X-Received: from pjbnm10.prod.google.com ([2002:a17:90b:19ca:b0:32e:d644:b829])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c12:b0:32e:f1c:e778
 with SMTP id 98e67ed59e1d1-34082fce72amr5948234a91.3.1761926157852; Fri, 31
 Oct 2025 08:55:57 -0700 (PDT)
Date: Fri, 31 Oct 2025 08:55:56 -0700
In-Reply-To: <20251028212052.200523-23-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com> <20251028212052.200523-23-sagis@google.com>
Message-ID: <aQTcDH9LRezI30dm@google.com>
Subject: Re: [PATCH v12 22/23] KVM: selftests: Add ucall support for TDX
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 28, 2025, Sagi Shahar wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> ucalls for non-Coco VMs work by having the guest write to the rdi
> register, then perform an io instruction to exit to the host. The host
> then reads rdi using kvm_get_regs().
> 
> CPU registers can't be read using kvm_get_regs() for TDX, so TDX
> guests use MMIO to pass the struct ucall's hva to the host. MMIO was
> chosen because it is one of the simplest (hence unlikely to fail)
> mechanisms that support passing 8 bytes from guest to host.

Uh, I beg to differ.  Stop following the GHCI verbatim.  The protocols defined by
the GHCB and GHCI specs are horrific, but necessary, evils.  They exist to define
guest<=>host ABIs+contracts so that guests can communicate with hypervisors,
without massive fragmentation in the ecosystem.  But as mentioned in an ealier
mail, KVM selftests don't care so much about ABIs and contracts because we control
both the guest and the host.

The GHCI matters only for the guest<=>KVM contract, it matters not at all for
guest<=>VMM communication for KVM selfetsts.

Simply set RCX (the mask of GPRs to preserve) to the maximal value for _all_
TDG.VP.VMCALL invocations.  There's zero reason for KVM selftests guests to hide
state from the host.  Then TDX guests can do port I/O and pass the address of the
ucall structure in RDX, just as regular guests do.  I.e. there's zero need to
change ucall_arch_get_ucall(), at all.  We'll want to modify ucall_arch_do_ucall()
so that we don't need to wire up a #VE handler for every test, but that's easy
enough to do.

Side topic, that's also one of the easiest TDX selftests that can be written:
verify the TDX-Module and KVM honor the spec and preserve registers according to
RCX, e.g. that KVM doesn't clobber registers just because they're not defined to
some magic purpose in the GHCI.

SEV-ES+ will need to come up with a slightly different approach because there's
no way to automagically expose RDI to the host, but that's an SEV-ES+ problem.

