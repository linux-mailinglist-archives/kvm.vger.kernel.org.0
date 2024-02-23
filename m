Return-Path: <kvm+bounces-9466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6969A860855
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01A2528593F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF6810A3C;
	Fri, 23 Feb 2024 01:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OAhzHpv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA3BE4A
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652181; cv=none; b=B16Q6W/PXsgi09cknC9W+6MIU1jpj0edW7wla+9wiJFFgJdVLhIeuLtnWj1NFM7QgzRqlRfJ+yrUe2+nBmR2fysxskDdjxzhGW2AEtAF7kha+AUetnT8vuXXTIh1H5Z3URxaQ41CdWJQgiXhqYRrRSIh6n4shFZm/1jyde5v4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652181; c=relaxed/simple;
	bh=P6KynTd25mmA5nnWS7DZ67ACtBg36Ii/fR5FpU2kyHk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JLQtW6rdY4mKhzTDiuxZ4adw5Tr5dcGXmxOUMt28x6GltOuDxdhqgNC3uxtbNFdbnM4nKjGa+Ub8DKaqSJnjW4i+VQsT2anw7KGKA03KZL/w8dv+LO7kXVfJLR+IOLAMsRWIejYAESmTGVDi7G5xQG7ZOcSMhXc0MODiXVcHejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OAhzHpv8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcd94cc48a1so570425276.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652179; x=1709256979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Rcw8tudKzhaatewYgd0UihB3Ym1E2teLVbr4vLLJgk=;
        b=OAhzHpv8Rnk8Y4AxX3m9KEz+3Z5wetA7Ct0ZHlRL1WEebfjIU4iuV+Ew4FeVnbNRd0
         Qx2tKf0c0DYwMzfdRUNR14Tq0L1OgKw+hvaFb2L5WJ4A1syJ0nXknEWlz9UABgWPpBSZ
         NB/xQ637Tm2U/6mRDMmZlWbem/MHbOClbGCLhCoVRJriaEieQqYokr8fB4Wg81wuZlFq
         1bRELBfoHzAmB+lRnFem2zwPfiscVj7fDjBItbxIQiJXuwfSgC4dcxoBw6p0HrCVNISZ
         z0G0T4iahp3/s4RcuaPEcoV+ZYPrZB3n3rMG7uDLxq9A5N8kftlXxKssbiuZlnTab1WX
         aEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652179; x=1709256979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Rcw8tudKzhaatewYgd0UihB3Ym1E2teLVbr4vLLJgk=;
        b=xN2QroKTA6nJ1mNC8ZnsgmfbBYCp+zJnTc/OIJYsWhJDUxnTr0IIeRZ/uSWANpB1mx
         UpnTz4IxMCNdUuqdWgZxuVXSDVvu3QLqOpNS4K/e9wH9x38S5MXH3JdQHidp5JAsmyKO
         cSg523S7QQcsFyo+PsiIx3EHHwbf5l/HZKAUVUT1FB7aPI2YbM/8tOOnwdZ9YppE4Flg
         tfLZgMiP4e/7jQfwYc6Mx/lP3vAUVDntxQSYS+G1MjZGnaxky/3LBVugx5EsEb/z5SgH
         osOtn3GXMQE6jJpOCe7KR+pV6efCRhESL1cM/e90YQYE3jdcRN0LDadsX9hKwUHWIj0U
         f3/g==
X-Gm-Message-State: AOJu0Yz7MqgsPw6FA9cnCHSLiExsY9F0CsEnvxJnbOWN1noq4gYiKgkh
	z3tr+UOHSW3GNdMdtkxlTcoxkDO9AnFU3kKju8D4t0jnzJOReodeRzL390qOKZsNaaAjq+wYWQJ
	2DQ==
X-Google-Smtp-Source: AGHT+IGZTlgnDqcnrCbRRfkgaHHxqSojuVx8LUBEdz+ygbdpV4uhRDNfZTkLAnCCFRjmF1Jf3lX1Yiw5ssY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dc7:48ce:d17f with SMTP id
 w7-20020a056902100700b00dc748ced17fmr218627ybt.10.1708652179382; Thu, 22 Feb
 2024 17:36:19 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:40 -0800
In-Reply-To: <20240209222047.394389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222047.394389-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170864806790.3089707.15358518741225122287.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: kvm_has_noapic_vcpu fix/cleanup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 09 Feb 2024 14:20:45 -0800, Sean Christopherson wrote:
> Fix a longstanding bug where KVM fails to decrement kvm_has_noapic_vcpu
> if vCPU creation ultimately fails.  This is obviously way more than just
> a fix, but (a) in all likelihood no real users are affected by this, (b)
> the absolutely worst case scenario is minor performance degredation, and
> (c) I'm not at all convinced that kvm_has_noapic_vcpu provides any
> performance benefits.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Move "KVM no-APIC vCPU" key management into local APIC code
      https://github.com/kvm-x86/linux/commit/a78d9046696b
[2/2] KVM: x86: Sanity check that kvm_has_noapic_vcpu is zero at module_exit()
      https://github.com/kvm-x86/linux/commit/fc3c94142b3a

--
https://github.com/kvm-x86/linux/tree/next

