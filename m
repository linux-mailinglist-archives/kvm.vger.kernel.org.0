Return-Path: <kvm+bounces-65590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A74ECB0DF5
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:49:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0492930DEE73
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3249303A26;
	Tue,  9 Dec 2025 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sj81pXVJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD462FBDF5
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765306186; cv=none; b=NPGrltbW4Da5/ZZsaAeoXY+C4GVwyl0N4t/UM6UrZ5ynGS0dVqfFbUZ1Jhj1nHkIGlml80SP1cCaruK5WT7cYGkTcpLGg5u+vtbm/qj/dGq6Fz7QtIJtmQHYABgSfoRV8izNlj7rYzyXVW2YMpLn5fSxTlBa87urTFK+p/8F36U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765306186; c=relaxed/simple;
	bh=H7AEzQvg3xxmq4/QvwA/inMoUi6+qgBz75EP15Kh1vE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hYRZkGDTEUKShmCWH6aeOctEOE5G7x3cnb/yqJxCS16XicY5YOyeata0N/eDJYwJ1s8BGKSurfLFTB6s2tc5SlD/l0h6/BWHrh7wo9LnuTqMBSAcIyoCaIudMS+Uo3QAJoK3BmAYn0ws1Txl8YXT7Auo+eHZw6J97OyaIs6Vnck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sj81pXVJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9c91b814cso15363129b3a.2
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 10:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765306184; x=1765910984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WcrjLCGc8k8E3gcSnmFKTYsG1dvjfc2izQ3DHrkDoZo=;
        b=Sj81pXVJmm37iL04fCRMnlaf/LJK1vddLdlfjHbN9891FbVVnkE0HwFo+qKoxZDyei
         3Pfr2VfHeAHtSGu5eW+eNAQYK5LWOXKCZ33WVCqlC9DuAPkc9huelN+97ws7unkJkkZl
         U8z9bod+KU0ZsMUlFlq6eot40M4BkSbGTWMLIDMkgxQR5vXtS0cUm/9WipN1kh5/zvuD
         S196EVKwyjx5DmkmuAFBbM+JIZKRcZS3K3MPL3/Z2q0qr40XVYYjbbRnpEsrb5Q8b9fs
         F9WQlH1RYE91MHgtwV4vQVnhjIrLnpAie4Zg9fBXn0eRJhcGT8e8jXehX5Pa2NsMrAaA
         /8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765306184; x=1765910984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcrjLCGc8k8E3gcSnmFKTYsG1dvjfc2izQ3DHrkDoZo=;
        b=M2B+8wTV5GE+OY59q+bqvPgvzXSmwE3oAZTJZJvYtzOzec4WbYoyQRjtrfXHrR1CcV
         f7xfWYilLq3O34O1sPv1FOLOOJA8RH/rcGVt8Z6cxcBoIuJfuD1i6I97Qi7rOd7O/m/x
         QwEL5QSk6FIIYF1fCMAnyof7fwn1xWuyih44e5CYdRPohV6nVpPK7X/K8HKb5TmdpI43
         sx0tfjaauHCE0X3w+DNFxsIRY60HpcmTqCVXSgovOyedWnYD1pAVtAmT1EunD0phm+xY
         Xs/o7L3QB6uMWck/x/oPg3AvrFAqZdbJ0IoYUK97heOGKAevdPtxH6E0ibEWChQBK/vc
         g5WA==
X-Forwarded-Encrypted: i=1; AJvYcCX+n1YmfLPNdMObD3WFa231SbOxEITrxCeT2uwFf24yL6tzKhmdN6QNiO+ldcDnXDZIKTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpCaZ3QfnGp3XOa23u418qRDwQ5BCBbf9DPsFKlhcc/MaYgrfY
	cwVkHsd0+qmG+M4vvT1j+oXTywA+WVMdHKjHBhl/jUrKNTSlENDtYHj1T4C0JWpXykL1SX+uY//
	+YFgSQg==
X-Google-Smtp-Source: AGHT+IEl5xQVOtfAL+zxUgNBdhkvTeJL6EGCv0+2w0lHUIzTLp1enbV9QhSHzHHuayLtrZNhKfZsCDdRTjY=
X-Received: from pgbfq5.prod.google.com ([2002:a05:6a02:2985:b0:bd9:a349:94c1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a7:b0:35d:5d40:6d7b
 with SMTP id adf61e73a8af0-36617edbb5amr12213431637.37.1765306183962; Tue, 09
 Dec 2025 10:49:43 -0800 (PST)
Date: Tue, 9 Dec 2025 10:49:42 -0800
In-Reply-To: <nbkpibgkill4hyuphsju7id5v73lufmas5sammpj6umvhzd25t@y6dkgguq2cuy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-11-yosry.ahmed@linux.dev> <aThIQzni6fC1qdgj@google.com>
 <nbkpibgkill4hyuphsju7id5v73lufmas5sammpj6umvhzd25t@y6dkgguq2cuy>
Message-ID: <aThvRtPXzZBajwI3@google.com>
Subject: Re: [PATCH v2 10/13] KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 08:03:15AM -0800, Sean Christopherson wrote:
> > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > +	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
> > > +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
> > > +
> > > +	if (!nested_vmcb_check_save(vcpu) ||
> > > +	    !nested_vmcb_check_controls(vcpu)) {
> > > +		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> > > +		vmcb12->control.exit_code_hi = 0;
> > > +		vmcb12->control.exit_info_1  = 0;
> > > +		vmcb12->control.exit_info_2  = 0;
> > > +		ret = -1;
> > 
> > I don't love shoving the consistency checks in here.  I get why you did it, but
> > it's very surprising to see (and/or easy to miss) these consistency checks.  The
> > caller also ends up quite wonky:
> > 
> > 	if (ret == -EINVAL) {
> > 		kvm_inject_gp(vcpu, 0);
> > 		return 1;
> > 	} else if (ret) {
> > 		return kvm_skip_emulated_instruction(vcpu);
> > 	}
> > 
> > 	ret = kvm_skip_emulated_instruction(vcpu);
> > 
> > Ha!  And it's buggy.  __kvm_vcpu_map() can return -EFAULT if creating a host
> > mapping fails.  Eww, and blindly using '-1' as the "failed a consistency check"
> > is equally cross, as it relies on kvm_vcpu_map() not returning -EPERM in a very
> > weird way.
> 
> I was trying to maintain the pre-existing behavior as much as possible,
> and I think the existing code will handle -EFAULT from kvm_vcpu_map() in
> the same way (skip the instruction and return).
> 
> I guess I shouldn't have assumed maintaining the existing behavior is
> the right thing to do.

Maintaining existing behavior is absolutely the right thing to do when moving
code around.  It's just that sometimes touching code uncovers pre-existing issues,
as is the case here.

> It's honestly really hard to detangle the return values of different KVM
> functions and what they mean. "return 1" here is not very meaningful,
> and the return code from kvm_skip_emulated_instruction() is not
> documented, so I don't really know what we're supposed to return here in
> what cases. The error code are usually not interpreted until a few
> layers higher up the callstack.

LOL, welcome to KVM x86.  This has been a complaint since before I started working
on KVM.  We're finally getting traction on that mess, but it's a _huge_ mess to
sort out.

https://lore.kernel.org/all/20251205074537.17072-1-jgross@suse.com

