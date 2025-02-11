Return-Path: <kvm+bounces-37929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A78FA319A8
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 00:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 203921611B0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 23:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D65268FFD;
	Tue, 11 Feb 2025 23:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zz6YBY7A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8967317BCE
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 23:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739317583; cv=none; b=FzZ7MNQ/plhXd0sbEWqHNnfzOPfy3dAbYZ1bBncRgKX3DvhvJ67Et6XnK58Es73doHoT0zcq2UwR9EuMj0jHAmFKNQbgjXJcbD4XIjwK5opnMPgSkr8Dl48yNGX2eRrxVd0SvTQnw357dUnBmCjmdq839/vdfT7mkM4oF185p+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739317583; c=relaxed/simple;
	bh=kHUwfpy1smNGdaw85fEjR6sH/+WmLJ/W665jWONW8wY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=glrQohTLu8ir2IPFcpwhRb52YATKYk6+V4S/qJ6A89dtm9PnZF00swedNtHYSUBrd285lozSzcffoUNkZCP77ffrfwlPy6cchpOepSz3AiA35IgZt64xKP1HmTLv457btsc8c/PdewYKwJI3TnumdAA5JdWTZrzUbAXLHFauC3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zz6YBY7A; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21f6c90a8ddso111160655ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 15:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739317582; x=1739922382; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9Xzg9fBMPuduClNg7a4EXeruDnPSNgXZs+2LgOO7Ss=;
        b=Zz6YBY7A6WnbWLYp0yVYBsiwrdxRAByeHUIvN/Hedfv3PcDtwoX952ZnykkqSZEXxr
         KR1sW3919j1vN+VE5d1oRkF8fsIoz88hAZQNUN1QXtQSZ0vcSdEK+RSbc2Rnj6hIa4dD
         oHp9rYSB+xVP9jD+KSzdVngz9/2Tf7Rox9NqsZc44A2JRyISBsfcjpU0BwJ5HKUxF/RW
         /IeM65FzUS+wU9iNxn+BIxfTI+GWXC/bY8K8UpJIXgr492djf/jhn97efiNDkdDE48E4
         oQD2Px8R5XAaPO5oD87T4ap8AfsMCOdyhm7/RxIGnKboF8RU4Dgj7T8r3dDIMAiQi8Zu
         petw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739317582; x=1739922382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9Xzg9fBMPuduClNg7a4EXeruDnPSNgXZs+2LgOO7Ss=;
        b=Vs8MzsouYF8u46uQcHgSwdl6anWBaprLh5RmIrY5ak4T8B8lC6XZwArD4XHGeDY13n
         I23Tqm5D1FNdHSvxO9R9xNEbZoWdGKZWgVk5yKM7nJIdPEylEiT7zncN4gGzRc9DQrMN
         BODQrqL44YPRv4NP4JhG65tKiNKCIlkfta4HAmWpV/efUwfhZ9WRnxdi72GAwk0Uphgr
         u/KJIHnpnZAMT3e8YlxZx+KO/urMa2wtAXMvpk94KlTW4F/EQylzfVpXAKRiaD7RyHcQ
         hwedd0rrlExJtlniT2kkRr6xhLi+mla2Erm/4IeYXyp92bzSdCRbw3tkyglEjJ96Hl2g
         lmrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDPUxwY3DJkBpttWjF5/UlnHIPFlFzQSCfcsppoTVrITGM1LFFghaNDcif91H0aob0QqM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwD+5hRL/p3o83d2mDPpggNPhkkQCIlyHoEzs+8XOh4bzD3gWQ
	Xbb6xtK5NoP3kZF7oNYS1wABpLWlPwXz10apwnREz1njnRdxyCjkFcLB4JSw0g4AWn9Mym/xT1Q
	qDQ==
X-Google-Smtp-Source: AGHT+IFvQzX7lWGLAMj8TJxXLpAAUI5EKLtWu6l9t6xkKWmGql2QeNCpb4soSUkQDdQZD4EObhZCf0S98Tc=
X-Received: from pgho13.prod.google.com ([2002:a63:fb0d:0:b0:ad5:433a:36b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3987:b0:1ea:db1d:99b
 with SMTP id adf61e73a8af0-1ee5c732540mr2128000637.3.1739317581787; Tue, 11
 Feb 2025 15:46:21 -0800 (PST)
Date: Tue, 11 Feb 2025 15:46:20 -0800
In-Reply-To: <Z6sNVHulm4Lovz2T@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-4-binbin.wu@linux.intel.com> <Z6sNVHulm4Lovz2T@intel.com>
Message-ID: <Z6vhTGHKIC_hK5z4@google.com>
Subject: Re: [PATCH v2 3/8] KVM: TDX: Add a place holder for handler of TDX
 hypercalls (TDG.VP.VMCALL)
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	isaku.yamahata@intel.com, yan.y.zhao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Chao Gao wrote:
> >@@ -810,6 +829,7 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
> > static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
> > {
> > 	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >+	u32 exit_reason;
> > 
> > 	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
> > 	case TDX_SUCCESS:
> >@@ -822,7 +842,21 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
> > 		return -1u;
> > 	}
> > 
> >-	return tdx->vp_enter_ret;
> >+	exit_reason = tdx->vp_enter_ret;
> >+
> >+	switch (exit_reason) {
> >+	case EXIT_REASON_TDCALL:
> >+		if (tdvmcall_exit_type(vcpu))
> >+			return EXIT_REASON_VMCALL;
> >+
> >+		if (tdvmcall_leaf(vcpu) < 0x10000)
> 
> Can you add a comment for the hard-coded 0x10000?

Or better yet, a #define of some kind (with a comment ;-) ).

