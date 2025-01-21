Return-Path: <kvm+bounces-36174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67025A1845C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 808AF18819D3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AF01F7064;
	Tue, 21 Jan 2025 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C6DK+YAr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA21F63C9
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482676; cv=none; b=R+8LeYfKY7ymNBikvGeDJ91QKbvQTodGuIa1LoTfdELkmad4pMYghP5C1eRuxIDoY7F36ewpknThfDw/CE5CKvR3YkwtBROQ9iE/SMaf35Gj4B/kbFyVtfw1EgzHWlNPI1dsNmztNw3gYdI1sMkZLXj7LSJIJEZUywXu8BdYAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482676; c=relaxed/simple;
	bh=0H6DV1frPEjQ6pyp5LFnKUrOtQChN9SH4bsk1iqonNQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oYswWC29Tndc3Tl+9bOu1BPD8DaHnjCck+vZemxp+bZki05mNXrH/lwN7ZckMEfRlNk/MUJpdJu8Dw27pte6zDPQ3KEWq1vgZvr1By03XZRV/Tvfqdg+cdcdzWo8YtXu0W9JycvnRGYs9PENMFIl/kBQSg9ioNTzInWLzuUK7SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C6DK+YAr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21650d4612eso40358915ad.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737482674; x=1738087474; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UlpJgylYPBhBTOXJmnDjlqjGKEbVzLH3urNLpkBE040=;
        b=C6DK+YAroXMHhX7+3aRiE05Rq3hj2zy7XXHg+VYW77/2AryU4ubP5epAO9PLnGzXX7
         KvYBLe22pPWD2sTJYxMSCji7K/RR3zflVJvcZY+TKgyADRX62uOQvbUBWC8P/CUqZgXC
         yfSip+ERWG8H3iAU9VNJojW8AmenC3QydWOVNSHeP2i0UprpNCijmlfboIvLxnIIxFEO
         FkyKpWI0eaHP4T1Zn7AMp2/7/WHa+zpP/kusXeJr15rv71pzGjqQmvlKtkqmphdA5vVi
         +DKW26XI1ZvpuFjTP2O8BGFCfp9BZyfcbU77ZaIE6tBXOPBuYI4kqFkBthIBo//7gd/J
         on3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737482674; x=1738087474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UlpJgylYPBhBTOXJmnDjlqjGKEbVzLH3urNLpkBE040=;
        b=tRxQIx2OCQMxFOX+1yf5xf86l6hCu6mBQW24Hwv4tW+llq/e5f+VWEwJZRBecTpPxm
         Wfvy/1z01fPzr3h948M86xfE0JA8WOkGNDMRaJ3xkKbMQSTayQh8uRldQDHZ6EQrNsRR
         Ms7LJyf1GoX9eH5rNJAGN/uMNVFKfx6kZ/Se2WTEZw2TxCakrz6ijCfg/IrbNBbDUhvA
         kvZ6S4Jkbu2A1TX8m2CtpzKiFQ/dArCLSa2Hua5HZfPfPUqqy9WOtWvj/GbEhWoeWSe+
         99kaXm9qBtLi6R3692kM4w6FJnNyysq+CueKWm0xPHRkpNFcA1Q/SPRkGWZY1qrFm2+H
         FG7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmpRlTuCuSG7UBVoC74+oxbz8lYyZVh1VxeXjEiA+ZRhqnysyKNu5T1lfw99tnoPV8lvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB6kqRZA+nsaVO+HDwA57cOw+cXLK4TDF3nvswioeIEVTrV7S+
	LHnOl4zyOOxkC//7mM3pmp6v09A41eaaO3/l7yPKhd+QaSW4jGw/AerI3S+nAuTW/w4lhwHB4yK
	HTA==
X-Google-Smtp-Source: AGHT+IHlUgnOTr4k9tHfDWgSC3sUed0m8QoaMEhUwxYs2XWjlGPAXM0XM+5srTfYVUtWffGBv0HqR/TSvWk=
X-Received: from pfaq8.prod.google.com ([2002:a05:6a00:a888:b0:725:eb9c:47e4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728e:b0:1e0:c1d5:f3ac
 with SMTP id adf61e73a8af0-1eb215ec4aemr34539711637.32.1737482673957; Tue, 21
 Jan 2025 10:04:33 -0800 (PST)
Date: Tue, 21 Jan 2025 10:04:32 -0800
In-Reply-To: <5718f02c-59e7-402b-91ee-b4b7b43f887a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com> <173457537849.3292936.8364596188659598507.b4-ty@google.com>
 <67f0292e-6eea-4788-977c-50af51910945@linux.intel.com> <Z4qv9VTs0CZ0zoxW@google.com>
 <5718f02c-59e7-402b-91ee-b4b7b43f887a@linux.intel.com>
Message-ID: <Z4_hsKjBS32_miZP@google.com>
Subject: Re: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Binbin Wu wrote:
> On 1/18/2025 3:31 AM, Sean Christopherson wrote:
> > On Wed, Jan 15, 2025, Binbin Wu wrote:
> > > On 12/19/2024 10:40 AM, Sean Christopherson wrote:
> > > > On Wed, 27 Nov 2024 16:43:38 -0800, Sean Christopherson wrote:
> > > > > Effectively v4 of Binbin's series to handle hypercall exits to userspace in
> > > > > a generic manner, so that TDX
> > > > > 
> > > > > Binbin and Kai, this is fairly different that what we last discussed.  While
> > > > > sorting through Binbin's latest patch, I stumbled on what I think/hope is an
> > > > > approach that will make life easier for TDX.  Rather than have common code
> > > > > set the return value, _and_ have TDX implement a callback to do the same for
> > > > > user return MSRs, just use the callback for all paths.
> > > > > 
> > > > > [...]
> > > > Applied patch 1 to kvm-x86 fixes.  I'm going to hold off on the rest until the
> > > > dust settles on the SEAMCALL interfaces, e.g. in case TDX ends up marshalling
> > > > state into the "normal" GPRs.
> > > Hi Sean, Based on your suggestions in the link
> > > https://lore.kernel.org/kvm/Z1suNzg2Or743a7e@google.com, the v2 of "KVM: TDX:
> > > TDX hypercalls may exit to userspace" is planned to morph the TDG.VP.VMCALL
> > > with KVM hypercall to EXIT_REASON_VMCALL and marshall r10~r14 from
> > > vp_enter_args in struct vcpu_tdx to the appropriate x86 registers for KVM
> > > hypercall handling.
> > ...
> > 
> > > To test TDX, I made some modifications to your patch
> > > "KVM: x86: Refactor __kvm_emulate_hypercall() into a macro"
> > > Are the following changes make sense to you?
> > Yes, but I think we can go a step further and effectively revert the bulk of commit
> > e913ef159fad ("KVM: x86: Split core of hypercall emulation to helper function"),
> > i.e. have ____kvm_emulate_hypercall() read the GPRs instead of passing them in
> > via the macro.
> 
> Sure.
> 
> Are you OK if I sent the change (as a prep patch) along with v2 of
> "TDX hypercalls may exit to userspace"?

Ya, go for it.

