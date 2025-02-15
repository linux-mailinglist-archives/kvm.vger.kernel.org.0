Return-Path: <kvm+bounces-38221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F84AA36A79
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6376216B937
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110A51FE460;
	Sat, 15 Feb 2025 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vYZT9dG1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B021A316B
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580970; cv=none; b=G8UfGHs3I2SjrYDWddDYrzl2q+tsw2hi0noAYjm+kwkSgUU05HfAXtQTNp+TQ2fNCJf+b6HnZQ/FxGgKutO70YGTmDNA+GYByU6pASC/5r8BPwFvmrvtkBJqoJ4iB54P1xZ5m7kZG6btsvFZyxQRL5csEIPWJyYjQI0kAD5MItc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580970; c=relaxed/simple;
	bh=Jekbf6Q0cU6Wx7OkQXLe7hOjuTG5eVvU2JGpq1WJW1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L/HQPMXrNqoXLxbSZvwJdnotiA86KN8i/CbLjATx1+uahDYAeI7KqzF6lGdWBA4TkKleKTNQelBI+2pn0IRRzL0KN9QJGwGmOP4e7WTY7cJhoK/gmi7OaQWkToQmIiEKKCwNCIHjWxGkgwukQBn+I1mIbMpXR+lL2Ge5BgpysNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vYZT9dG1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc261eca15so3568682a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580968; x=1740185768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fL7l1+LmTgBeEbzpsciM8sZysU50WTuc3k3as/xBPhw=;
        b=vYZT9dG17Id6ykd3yNlOBUuVIt7vo1xPRtBmm8EA31vAuRicJjFdBIkEIsACq6irTk
         +SG3yTH99nv0oYns6CkTVj0ePUI0/9EsGL4BfGwhMqkvY8aWfdaYkDEttzbM1aHAJbVl
         qY+VnanWnsW2rbz007mhsN83ByASAo0c247CJ8XXmm18WadYkXGiY5VOja1iIn2QY93N
         DNKWBNwQJGJbbsAaOI7i9pG/FK4nvoHCfwZuo7x5pk5O0VFOR/2gjzoSwZ9alUP74CE0
         fA05ijB85bWO34pRI8g6xTjgAXHFWXtdxqukTyTubXLr/LSE1GwmvVHs0OYb8hcDyhbH
         H1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580968; x=1740185768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fL7l1+LmTgBeEbzpsciM8sZysU50WTuc3k3as/xBPhw=;
        b=XaGqXQlNCd8gICRLkbZ3Tdiieh5+NkFPgKj1X2rnLgJEri75vGN3deHje/NjSlNPQ5
         MrZOX/eb9H2odDT6c+IC0TAWE/xnL9GnVg65jQ2jQPIlaeZji+oFMEFw1gla6rFmDGs4
         nIs7bzsQ9nuLp7mvqn/M9/G93RTQYlR5FBi60UjyvPdkzi5TsYnZmCOflgp574EnSBRK
         WF0tnBoA6AgukH474X4ZIUTuddNQQKQAKAE88nGRlb+p3aqeRM87A/brLON4+c4qCQhp
         28NbwCFbll0K8TCo2t1oB/dmkUCVpEF+4Oe67BmDiQybmEnq/MGyHRuHL1Yozv9n9gOj
         Yw9w==
X-Gm-Message-State: AOJu0YwOnVfdwwagqVZITTgrjSosT9HRHGZnKkPIb724h+gmJ6rPcqoe
	DheHqJe5309/TGYILvG+TT4VDaQFQbxrwKCEVcLCGTqS1Ucx46CsnbRtBwKhnnqAHI7UPQOnH1h
	zuA==
X-Google-Smtp-Source: AGHT+IGD6lMbhax+0H1lXwQiLO2YDpzdhmH8XWd8CjdLfJqWYkoGcpnAs+TyM1wwCnmQp7KQ9OxRdUOlICc=
X-Received: from pfbf10.prod.google.com ([2002:a05:6a00:ad8a:b0:730:8970:1f9c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d55:b0:728:15fd:dabb
 with SMTP id d2e1a72fcca58-73262200ec7mr2404019b3a.8.1739580968046; Fri, 14
 Feb 2025 16:56:08 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:26 -0800
In-Reply-To: <20250201013827.680235-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958053855.1191632.15119979488375341205.b4-ty@google.com>
Subject: Re: [PATCH v2 00/11] KVM: x86: pvclock fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 31 Jan 2025 17:38:16 -0800, Sean Christopherson wrote:
> Fix a lockdep splat in KVM's suspend notifier by simply removing a spurious
> kvm->lock acquisition related to kvmclock, and then try to wrangle KVM's
> pvclock handling into something approaching sanity (I made the mistake of
> looking at how KVM handled PVCLOCK_GUEST_STOPPED).
> 
> The Xen changes are slightly better tested this time around, though given
> how many bugs there were in v1, that isn't saying a whole lot.
> 
> [...]

Applied to kvm-x86 pvclock, to start getting coverage in -next.  I put this in
its own branch so that it can be reworked/discarded as reviews come in.

[01/11] KVM: x86: Don't take kvm->lock when iterating over vCPUs in suspend notifier
        https://github.com/kvm-x86/linux/commit/d9c5ed0a9b52
[02/11] KVM: x86: Eliminate "handling" of impossible errors during SUSPEND
        https://github.com/kvm-x86/linux/commit/4198f38aed24
[03/11] KVM: x86: Drop local pvclock_flags variable in kvm_guest_time_update()
        https://github.com/kvm-x86/linux/commit/aceb04f571e9
[04/11] KVM: x86: Process "guest stopped request" once per guest time update
        https://github.com/kvm-x86/linux/commit/6c4927a4b7b8
[05/11] KVM: x86/xen: Use guest's copy of pvclock when starting timer
        https://github.com/kvm-x86/linux/commit/ca28aa63918b
[06/11] KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across PV clocks
        https://github.com/kvm-x86/linux/commit/24c166378026
[07/11] KVM: x86: Set PVCLOCK_GUEST_STOPPED only for kvmclock, not for Xen PV clock
        https://github.com/kvm-x86/linux/commit/93fb0b10e712
[08/11] KVM: x86: Pass reference pvclock as a param to kvm_setup_guest_pvclock()
        https://github.com/kvm-x86/linux/commit/46aed4d4a7db
[09/11] KVM: x86: Remove per-vCPU "cache" of its reference pvclock
        https://github.com/kvm-x86/linux/commit/39d61b46adfd
[10/11] KVM: x86: Setup Hyper-V TSC page before Xen PV clocks (during clock update)
        https://github.com/kvm-x86/linux/commit/847d68abf10c
[11/11] KVM: x86: Override TSC_STABLE flag for Xen PV clocks in kvm_guest_time_update()
        https://github.com/kvm-x86/linux/commit/1b3c38050b5c

--
https://github.com/kvm-x86/linux/tree/next

