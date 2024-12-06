Return-Path: <kvm+bounces-33213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D9F9E73EA
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 16:25:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6144F188430C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 15:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B83207658;
	Fri,  6 Dec 2024 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bu4mXpY+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6CC53A7
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498627; cv=none; b=fhwWb3lS8tXzUjLFxQmh/CPyVKh5JkVFHVnDys1smUsOp1JvE6dN9bd6yC1bn9nXRxa4a2BTsQ2Xqlg3RuCLfDpacr/ZXmo4rJPJGANS3tXZbUNBhRDJ8k7icROf+a3inYQ0xrbyCpwgVk29eEAxrcihKG8cVdAzev8Uz94S60Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498627; c=relaxed/simple;
	bh=F4U6VgJx6UfwjdqMTgo7+Gu1UAr07beEQ6XOlw/vXmk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oM2OkMtGE+3AuW8YahK59lFDLXnfQsjgwmjaLJNHqaqkrQx1lKZsSbC4kE49WZlj9gAy1WZfJzaHic/VOgnTn9K9+1XdPZSCDVOLpkU8EOati4RY7cpsHgkeM1YBPzYToPjZBCQ418MceFA73C73jAI2BYRFd7RgxG74sz+LVb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bu4mXpY+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so2136859a91.0
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2024 07:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733498624; x=1734103424; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FL5Ug04a77bJ6f6c5eJHUK8+Cf/EL2TCmknlyMn6nmU=;
        b=Bu4mXpY+fuloFhn/bM4KXBPm1V9HKAZA68GAo0gxeNm8Di/XXvTmT2AqKdPuaLxKVN
         dM+uBXkvXW9TccYfHrcsKiUpDAmRfGZk+HGBwcW9uxnw9oQcNRvDWDZHWF1HkGgk83Eb
         cwcdaNq9/Oeo2dxXMucwb4M4G6GNrMwET2lGBnxLJ+ysi5vNWQs/fdG2FEACk5eIsr0l
         Ij5lqtTNKVVJm/1Kl2H7N7Yg1IIwcbpt/thifgFiwQ6+1OxRa6iMSxeL3I8gyeSYcEUL
         wq5HugCGsmjKhTMSzYclb5gyhSSnbAIRYhmrXyd5Q+h1fIckALmagw5HxHAk9d/TT9L2
         L4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733498624; x=1734103424;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FL5Ug04a77bJ6f6c5eJHUK8+Cf/EL2TCmknlyMn6nmU=;
        b=ZEfAJ5hUOt3pakhRP66OmxIsbNv9+y1Uvk6T3hMUCwv8kzj3u2KmSIYvGVwcj8S5q0
         dTy/jCRGfGL/epMMnUjUxnK3FLUnGJ/lA80SWddEj0BlJuLzBJdu0Z4+JpTtM2U799MW
         VGld8cp9QhzHdm2sB0ZmBV13wKJF2CtgM+Yuy4Vrar3wQF5R6FjLW/9rxa/Jx7jqaAYn
         PlO3YrLObfhwQNt0yBB+VMnbmf1w9z1YyAVlY3yBHDaexIkGYmCyVe32EJYXX9TZWGkx
         u4A0SspML9ezF4x3c37PLBWKwtNrn2mNMgiKTjvTqtZ5kpNAcIKsJBtlFMZSvdiIQWXJ
         a+xw==
X-Forwarded-Encrypted: i=1; AJvYcCXJXFlcFLEzclu+RTzeZt8IRLzzxG4Z2ROuc5etCjqotnTyEu33ao3xcUj5i5kA2liuDdU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9RqSGXE0sXoTuYNzSCkjDkTMUr98QzKhAAp4+mYJTos8JLZ1S
	/8MI6JaUIdxTtRTV7rxSVFMARd/G88wZs3U4ZzfNlxXhymwaT+7mqlqMbbXTnJ1Zh561uHaaPX7
	zmw==
X-Google-Smtp-Source: AGHT+IFk5H1Pk94tqKaL6QCl5HpDmD891trCKrV69rMW7/nMsDz6ykEXf0JBS99k/KVhe1O5kwAEIXGYZjM=
X-Received: from pjyr4.prod.google.com ([2002:a17:90a:e184:b0:2e0:9fee:4b86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d43:b0:2ea:7329:43
 with SMTP id 98e67ed59e1d1-2ef6955fa3cmr5341681a91.6.1733498624663; Fri, 06
 Dec 2024 07:23:44 -0800 (PST)
Date: Fri, 6 Dec 2024 07:23:43 -0800
In-Reply-To: <20241205180608.GCZ1HrkLq2NQfpNoy-@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-13-aaronlewis@google.com> <Z0eV4puJ39N8wOf9@google.com>
 <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local> <Z09gVXxfj5YedL7V@google.com>
 <20241205180608.GCZ1HrkLq2NQfpNoy-@fat_crate.local>
Message-ID: <Z1MW__KcGo-QyDtc@google.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in kvm_x86_ops
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	jmattson@google.com, Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 05, 2024, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 11:47:33AM -0800, Sean Christopherson wrote:
> > It applies cleanly on my tree (github.com/kvm-x86/linux.git next)
> 
> Could it be that you changed things in the meantime?

Nope, I double checked that I'm using the same base.
 
> (Very similar result on Paolo's next branch.)
> 
> $ git log -1
> commit c55f6b8a2441b20ef12e4b35d4888a22299ddc90 (HEAD -> refs/heads/kvm-next, tag: refs/tags/kvm-x86-next-2024.11.04, refs/remotes/kvm-x86/next)
> Merge: f29af315c943 bc17fccb37c8
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Tue Nov 5 05:13:01 2024 +0000
> 
>     Merge branch 'vmx'
>     
>     * vmx:
>       KVM: VMX: Remove the unused variable "gpa" in __invept()
> 
> 
> $ patch -p1 --dry-run -i /tmp/0001-tmp.patch 
> checking file arch/x86/include/asm/kvm-x86-ops.h
> checking file arch/x86/include/asm/kvm_host.h

Are you trying to apply this patch directly on kvm/next | kvm-x86/next?  This is
patch 12 of 15.

> Hunk #1 succeeded at 1817 (offset -2 lines).
> checking file arch/x86/kvm/lapic.h
> checking file arch/x86/kvm/svm/svm.c
> Reversed (or previously applied) patch detected!  Assume -R? [n] n
> Apply anyway? [n] y
> Hunk #1 FAILED at 79.
> Hunk #2 FAILED at 756.
> Hunk #3 FAILED at 831.
> Hunk #4 FAILED at 870.
> Hunk #5 FAILED at 907.
> Hunk #6 succeeded at 894 with fuzz 1 (offset -30 lines).
> Hunk #7 FAILED at 1002.
> Hunk #8 FAILED at 1020.
> Hunk #9 FAILED at 1103.
> Hunk #10 FAILED at 1121.
> Hunk #11 FAILED at 1309.
> Hunk #12 FAILED at 1330.
> Hunk #13 FAILED at 1456.
> Hunk #14 succeeded at 1455 (offset -35 lines).
> Hunk #15 succeeded at 1479 (offset -35 lines).
> Hunk #16 FAILED at 1555.
> Hunk #17 succeeded at 3220 (offset -40 lines).
> Hunk #18 FAILED at 4531.
> Hunk #19 succeeded at 5194 (offset -38 lines).
> Hunk #20 succeeded at 5352 (offset -38 lines).
> 14 out of 20 hunks FAILED
> checking file arch/x86/kvm/svm/svm.h
> checking file arch/x86/kvm/vmx/main.c
> checking file arch/x86/kvm/vmx/vmx.c
> Hunk #2 succeeded at 642 (offset -2 lines).
> Hunk #3 FAILED at 3943.
> Hunk #4 FAILED at 3985.
> Hunk #5 succeeded at 4086 (offset -1 lines).
> Hunk #6 succeeded at 7532 (offset 6 lines).
> Hunk #7 succeeded at 7812 (offset 6 lines).
> Hunk #8 succeeded at 7827 (offset 6 lines).
> 2 out of 8 hunks FAILED
> checking file arch/x86/kvm/vmx/vmx.h
> checking file arch/x86/kvm/vmx/x86_ops.h
> checking file arch/x86/kvm/x86.c
> Hunk #1 succeeded at 10837 (offset -3 lines).
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

