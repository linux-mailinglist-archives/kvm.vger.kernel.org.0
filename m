Return-Path: <kvm+bounces-30371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D754D9B9897
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 158561C21FD2
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE381E5718;
	Fri,  1 Nov 2024 19:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PqIdcb4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85101D173A
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489284; cv=none; b=bVMb3F2JRD7bzogn+pnL1ecICGY2+nIzmeYQYeGoGfAk1lkRJ1JZ8LBIGsdMaWuZKKSuhAiFHmBI4UX4BCDGoLggcb11Yc9HaN4KXtzBAmqUbaMyxAibRGlbBP3kaNsTHSBtC1hIRhVayNZIYvKYReJajWCz1df8asrUKz3Bfjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489284; c=relaxed/simple;
	bh=QfIr9ZgH3YxeRaReqTzxBk0Rd+0/zCA8wPNGyqKn06s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJf737QrRjVv+nAc4lLXERHEL3HqAlYzFmM2tLKW1Bl/lKjIHBTAPmkMgLNZiomgbj83bPVgIJgbUMQXnwSWf0ph9uUWOKSmPuPXsdNjfsGxveGO9/k/r2zihN+vGPubLRb38Lvws/OuClxfee9zoo6gWGOGQbUmNa/tTtS6spE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PqIdcb4O; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2ca403f5dso2294557a91.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489282; x=1731094082; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rnat+5Qxwr1RPbjlAmK89ke8+3RGlYZMlzw2sHBOBts=;
        b=PqIdcb4OucZ4terzZ1farjTEofIPaUkdVTiw05hJcZ16lNKif6J3DDJgr0gSOzoej1
         gIAxgtQ71B9oagkOVtZ0t1HAnzinDyg+nStv9QULfV69g8fYcpusJhoYK0cvvcnOKnC3
         /pY8DIMBhJXC5umHci4Msp1TDCSuQQCCeaEpWhtNo0xMMJl3L7t82X1a0y8Hq14CsvrM
         AIQm4IutrnunTGaqRofldjhVl6SVCaqg5VzJjT1p+aT706oUqBtr7Rvr9wT+eOy/jd8C
         AGYc43hV3z5rmHX8l7gnjt/1JZAZYP6diQeArt67NU3hZ4MPYeQMeAgIuB5ymO4tXoTP
         hbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489282; x=1731094082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rnat+5Qxwr1RPbjlAmK89ke8+3RGlYZMlzw2sHBOBts=;
        b=QQJGrpsYUkLATtklbVPLyvaLpG+9y97hd4jl1l2qBcJ/OEQ6dda5BH93E4tMA+nWWI
         9kLnJCdQyzthTPFZ6bHnx0/u297ZiaXTY+1l3NoLjAKLTjl/8ZyXJN4iBpqhBQRML5Pp
         JjUDKzhUchFRZ45jYz1BSv7cGfC2ru3coMfRGxzbVcVgYVg4eSlLdCuAHmTyu6Gp0f29
         X52qYw2ZEj/HDJp99gxZvZur2eLpF7sQ3Gt4jkh6Ww/RiWqKp+SA0XPZBXQx9nKXXU8T
         rpMFg0BxcJC6Rkp46hA8qtCZbCiSxDLrWNFY3T0CsCTftY+diKa7MGJR6TU2yb5FGDoC
         FSeA==
X-Gm-Message-State: AOJu0YzfLyGVgYguK5lcQwbxAe+Uy/V50G63yS3h7ssrO4t/ZVRLQhAP
	hN3U2DogCdDy4s1dAQ4UdnuxQcQO+HP3bDfCka2DG8EkKtE6Fnwq7EYfHUa8TdSHQcArhFRoAJv
	5Yw==
X-Google-Smtp-Source: AGHT+IHxYslOCg/T95KMqV+JPinrVR9r+LFGKVQKpD+ikNIYIwK5kDmVLHevRdtBah8bHC64lZuVIWi5mmA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1943:b0:2e2:af52:a7b4 with SMTP id
 98e67ed59e1d1-2e8f11d0128mr40947a91.8.1730489282274; Fri, 01 Nov 2024
 12:28:02 -0700 (PDT)
Date: Fri, 1 Nov 2024 12:28:00 -0700
In-Reply-To: <173039501630.1508013.8131245116314575241.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com> <173039501630.1508013.8131245116314575241.b4-ty@google.com>
Message-ID: <ZyUrwCeIyaNE310v@google.com>
Subject: Re: [PATCH v4 0/4] KVM: x86: Fix and harden reg caching from !TASK context
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Wed, 09 Oct 2024 10:49:58 -0700, Sean Christopherson wrote:
> > Fix a (VMX only) bug reported by Maxim where KVM caches a stale SS.AR_BYTES
> > when involuntary preemption schedules out a vCPU during vmx_vcpu_rest(), and
> > ultimately clobbers the VMCS's SS.AR_BYTES if userspace does KVM_GET_SREGS
> > => KVM_SET_SREGS, i.e. if userspace writes the stale value back into KVM.
> > 
> > v4, as this is a spiritual successor to Maxim's earlier series.
> > 
> > [...]
> 
> Applied 1 and 3-4 to kvm-x86 misc.  Patch 2 went into 6.12.  Thanks!
> 
> [1/4] KVM: x86: Bypass register cache when querying CPL from kvm_sched_out()
>       https://github.com/kvm-x86/linux/commit/8c8e90f79c56
> [2/4] KVM: VMX: reset the segment cache after segment init in vmx_vcpu_reset()
>       (no commit info)
> [3/4] KVM: x86: Add lockdep-guarded asserts on register cache usage
>       https://github.com/kvm-x86/linux/commit/21abefc6958d
> [4/4] KVM: x86: Use '0' for guest RIP if PMI encounters protected guest state
>       https://github.com/kvm-x86/linux/commit/a395d143ef40

FYI, I rebased misc to v6.12-rc5, as patches in another series had already been
taken through the tip tree.  New hashes:

[1/4] KVM: x86: Bypass register cache when querying CPL from kvm_sched_out()
      https://github.com/kvm-x86/linux/commit/f0e7012c4b93
...

[3/4] KVM: x86: Add lockdep-guarded asserts on register cache usage
      https://github.com/kvm-x86/linux/commit/1c932fc7620d
[4/4] KVM: x86: Use '0' for guest RIP if PMI encounters protected guest state
      https://github.com/kvm-x86/linux/commit/eecf3985459a

