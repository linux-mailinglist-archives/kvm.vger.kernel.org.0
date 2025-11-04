Return-Path: <kvm+bounces-61999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 63679C326C4
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A93F34F3949
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1363033C50B;
	Tue,  4 Nov 2025 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d1SN72X0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3B23396EE
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278413; cv=none; b=UwZklk8LI02z3Su3UUngobWDQNIc4lCxzPkQKzAM85BWrd7AcrhdiKQ2Mrze3IvPynC1v164tI9iGAu/L0mbqLKfZglmwJpAbsNodHcVxqtKDv8XypeJTDcxeaxUbQHAjMMYzAQFGs1vF0p53gwnmw8tKf+b6h9Pduq/fqgL1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278413; c=relaxed/simple;
	bh=0yGAFsZK/ZOs1LyRJ0YrGf+aIvZ2uzN1ts2a//mG9Xo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DXJkJqVk5tRvs598yeUvu0REzAH9qAuw1iozmSRp6EtF99SBhGikP9puGaP84EoRFOWiIesZZ3Ml/3uUFDVIuwMLOCWwgbnufDE5r6cM9ydX3mfbXEPmunr9vMk/wTrWE1Sxcnez8N9RVWoXENyTwBXVhVnWwCJKmVyz0bQbq7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d1SN72X0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34188ba5990so1436593a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278411; x=1762883211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wxZmu92VBNo3ZNs8uk3xtJDnVPLBURDJBhabtGLpMSc=;
        b=d1SN72X098qIrAxlS7iEAMKakkrkl0+A3mdqtzOcOrKMcBwpJnE3VpupyLEAxHdIf3
         r8gPjJ5eZDWhB5e6Y2XdrIazyZpyeiJhaq0s5lhIsK0Ke/ZZDm0DkJmoL3Htm2E8zQYs
         wJxdGEMRMtFZ2/aQkCc7of84YdiFMws47fJhL12JXIkHGFV2AArpnsxHsE3jimw2Iyof
         BVdrqMD8W5/3iU/CGR6oWph1kastrVDzSAGYfoS0GxftH1KvTaJnOAa2XBtMbSVKBW/m
         alBiuPYKo5PjqNusMICsoFlwHc7g35iZ8XGJdSvMJqEGFq+jfy8BESjkqts+j1Osu0Gb
         3aLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278411; x=1762883211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxZmu92VBNo3ZNs8uk3xtJDnVPLBURDJBhabtGLpMSc=;
        b=VUURYaLGF0ypM4gO201UEmTIbce45xzF/AM62xketZnnfqgSQDQs2NnaP2/Dykc2b3
         nIYs/WBjvHLqDVTpih1TOXMQPMqukjIXoMV47mBeO+S8GVlA0d9rmdpZdFbvTZR8Z6qJ
         8MeZvjTq6W1qrYDljtdwj0wVK8a+Nm+FAjIrNi0aUVgMeAjecVDPxPY/6B1HXKkBS/di
         cywy3wY2eWgk+nW0TqbbTasPWiCIZM4Zsxse/Zsq4Q0K9YCW5Y/x2oGLuBHbGHEtA+7X
         +M9ieSxc76VqnSBLcBotP4og1tnszMgEs7PRiR+es1g62Oc0/AMloEv1z+ypJHWoQStc
         PZnQ==
X-Gm-Message-State: AOJu0Yz3RSnW5lPcI7GyqTUhVcxHeirQaQsKNZlsZcM1+UbuRA5+Vaih
	LN5Ab5c4ZrhnpaFeZXwx0Cjk6FpZfGZDpyuawfdRjnKdRZeyGoc5gRYfNOru9+vLEY8Ldhkg+kP
	EApyBGA==
X-Google-Smtp-Source: AGHT+IF2w+QUzQmGm88xylznNwALcIwnLH35z1gzfSNPKSINRGs9eZiPe3VCtQNgWgpABVBw+tns4zm27Og=
X-Received: from pjbge14.prod.google.com ([2002:a17:90b:e0e:b0:32d:dbd4:5cf3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54d:b0:295:3ad7:9485
 with SMTP id d9443c01a7336-2962ada3a9amr6135875ad.14.1762278410993; Tue, 04
 Nov 2025 09:46:50 -0800 (PST)
Date: Tue,  4 Nov 2025 09:45:04 -0800
In-Reply-To: <20251104011205.3853541-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251104011205.3853541-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227766483.3932613.3439641824887004985.b4-ty@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Remove bindings on memslot deletion
 when gmem is dying
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+2479e53d0db9b32ae2aa@syzkaller.appspotmail.com, 
	Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 03 Nov 2025 17:12:05 -0800, Sean Christopherson wrote:
> When unbinding a memslot from a guest_memfd instance, remove the bindings
> even if the guest_memfd file is dying, i.e. even if its file refcount has
> gone to zero.  If the memslot is freed before the file is fully released,
> nullifying the memslot side of the binding in kvm_gmem_release() will
> write to freed memory, as detected by syzbot+KASAN:
> 
>   ==================================================================
>   BUG: KASAN: slab-use-after-free in kvm_gmem_release+0x176/0x440 virt/kvm/guest_memfd.c:353
>   Write of size 8 at addr ffff88807befa508 by task syz.0.17/6022
> 
> [...]

Applied to kvm-x86 fixes, with a tweaked comment to clarify that the bindings
and file haven't yet been destroyed/freed (and can't be destroyed/freed
concurrently either).

	/*
	 * However, if the file is _being_ closed, then the bindings need to be
	 * removed as kvm_gmem_release() might not run until after the memslot
	 * is freed.  Note, modifying the bindings is safe even though the file
	 * is dying as kvm_gmem_release() nullifies slot->gmem.file under
	 * slots_lock, and only puts its reference to KVM after destroying all
	 * bindings.  I.e. reaching this point means kvm_gmem_release() hasn't
	 * yet destroyed the bindings or freed the gmem_file, and can't do so
	 * until the caller drops slots_lock.
	 */

Thanks!

[1/1] KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying
      https://github.com/kvm-x86/linux/commit/ae431059e75d

--
https://github.com/kvm-x86/linux/tree/next

