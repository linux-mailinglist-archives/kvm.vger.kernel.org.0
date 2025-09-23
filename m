Return-Path: <kvm+bounces-58581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64AC6B96E42
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E26321200
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EC9329F3D;
	Tue, 23 Sep 2025 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OODOazRL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C499329501
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758646773; cv=none; b=rExSvlvRVdM7Bf4Aw/zZL+h41XRscXGwFhI0RiwltvF0MTVQD4cpVD3/t2WLmzNy/7sUeXGEV2FPttHkzJI3zf+CH/rt1GtspZiikY8IWXhyf6OKblvsVMdtQex3J2BqvyV11u9aFqTkkE9Mf6+JVkWtRYE9kPKyV0Nl55Y97bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758646773; c=relaxed/simple;
	bh=a+TGFSesu5VUUVAITEHREDz64pLmzeUXqCEahcC+ggo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=roGjD/FlijzpJSUWe5JTFVYZ6XmPDuv+9SiQum2VqT5JfpHnrAXb4CvLmJTSpfgFSEZXFC0+TbKDjzcRs6ZJYjdZsB2VAOsKFpwAGf0BgGLguZJJygw6YKYl6NOtb4a1K1l1P4MGakPw7o2p1K60eZYuW4uYbcm5zkkGUxkKZ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OODOazRL; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b521995d498so4462203a12.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758646771; x=1759251571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eugYmtKDYKJ7cH1F2PIlxiSwE2ftOyy84HNn6Ux5BoU=;
        b=OODOazRLXSY+7BOG8XaXS54J1HXm7xf3qoAnHrZh5FKS+EW85awZoWLq8mQ80BNPqL
         aE9WdJvra0ZnOULyRJxY6aZiRjNQLXXOOUlPBmGHvfSAbJ05i5ohJrJUnY47GMEOqz1B
         uXPXiLaEVSUDZuOKNa8F83u7GX15gcCxNLa4HytleKLiND6giWgmLvSKTK46reCbt6we
         NPZwg4GJ0IxjX7/0ffbqkSNxD0uzaSKRJI7IDriYM/4tpqbmUmR7LQWjgwIH5QnSv+9w
         Ie5IyiKWqomVdcMcpVUuHie4LpWbkWxlEDcQEO1MNlf5w8Jx3cOy1Bt3Dors5MrJ9mmP
         NxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758646771; x=1759251571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eugYmtKDYKJ7cH1F2PIlxiSwE2ftOyy84HNn6Ux5BoU=;
        b=Gf5XxUUEGbGGJIKrwlWUdV/jyxA4IM2Vd9Sv1N504cgSCpWg+qdBp9XFvlep8LRVYn
         Le4SEHp0TyNTtc8z8JCOhkre1NPMI++3+0l4qdnCGVZpSKShniC7r95oYH1H0hrMBjpq
         EmyC9Uebx5+pCojhz8PdIkFuTc7nu3MlOwrmbe4m2uHAZ2jC0nGz7MAyUWoJAI1ak1Ru
         fYTz+EnFB0s/Jb88NG/MRcxI10UXSnGR6UEBj51jNtHi8rZAv0oN28Rvk6NYdFs5nREO
         n5Q9EjwdxFbsdJN+37G7s2YGXXm2lZtr1Uu2eXQ1XWlCmEfxm+Xdgi0D4qSVkYClnyyp
         pzUg==
X-Forwarded-Encrypted: i=1; AJvYcCVo5430ilIOpZbD1G2U/V5tql92cWoARYWipXSLkOd9w5L+wZZgWfB8pbTUaTnPDMjF+jg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOKhoihG8YFdDNmIw86+/ug3h/OoZG0/M31vxIg60cdYwq6OAq
	SPd6yCLpM3SO3xRVeirNWu16jA6t7oIpyCHRUONvufeBxIAC1gwaMtDc/m4sUfvZG5btn2d7jqi
	n7gAEUA==
X-Google-Smtp-Source: AGHT+IHoSbwpr9rrf3RNA1kZQWNfvix8mNMekKMDtf3Qj1cDaQChIBKNA8JvxkaNaWoibhMgYu/Ju9WbOW8=
X-Received: from pgg21.prod.google.com ([2002:a05:6a02:4d95:b0:b54:ff79:96ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914c:b0:2c8:85a5:c416
 with SMTP id adf61e73a8af0-2cfd8a9aebdmr4825730637.18.1758646771547; Tue, 23
 Sep 2025 09:59:31 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:59:29 -0700
In-Reply-To: <aNI+07tytIMh/YvW@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-50-seanjc@google.com>
 <aNI+07tytIMh/YvW@intel.com>
Message-ID: <aNLR8WUn8mUtiAEi@google.com>
Subject: Re: [PATCH v16 49/51] KVM: selftests: Add coverate for KVM-defined
 registers in MSRs test
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Chao Gao wrote:
> On Fri, Sep 19, 2025 at 03:32:56PM -0700, Sean Christopherson wrote:
> >Add test coverage for the KVM-defined GUEST_SSP "register" in the MSRs
> >test.  While _KVM's_ goal is to not tie the uAPI of KVM-defined registers
> >to any particular internal implementation, i.e. to not commit in uAPI to
> >handling GUEST_SSP as an MSR, treating GUEST_SSP as an MSR for testing
> >purposes is a-ok and is a naturally fit given the semantics of SSP.
> >
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> 
> <snip>
> 
> >+static bool vcpu_has_reg(struct kvm_vcpu *vcpu, u64 reg)
> >+{
> >+	struct {
> >+		struct kvm_reg_list list;
> >+		u64 regs[KVM_X86_MAX_NR_REGS];
> >+	} regs = {};
> >+	int r, i;
> >+
> >+	/*
> >+	 * If KVM_GET_REG_LIST succeeds with n=0, i.e. there are no supported
> >+	 * regs, then the vCPU obviously doesn't support the reg.
> >+	 */
> >+	r = __vcpu_ioctl(vcpu, KVM_GET_REG_LIST, &regs.list.n);
> 						 ^^^^^^^^^^^^
> it would be more clear to use &reg.list here.

Fixed both.  No idea why I wrote it that way.

