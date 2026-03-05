Return-Path: <kvm+bounces-72880-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNtmCnC+qWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72880-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:33:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5D72164BF
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 697BC3049AD7
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82C13D7D9C;
	Thu,  5 Mar 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F/E40bu+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D6C189F43
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731606; cv=none; b=bJqgj7z3ZGbPom+YyR5sC/Gt2hI6/As8bpY3UDyrraPp609ytQooX4kF6Ef2YVmt+yJFXnUTzqpKBAWaSMKyXM8fRdzHvI3GmMbcU2SLoZUH4g0e67V7HDfynCr+TXeHOfXc31EGBLRn6x76I6G6/MoKai6Fy6bjhOibCtqf22U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731606; c=relaxed/simple;
	bh=/qTR+FlpC6jv9zqromkulGG4vJfxzQpk8fzKxtHe1CA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iuk+Pf2PhF86yA+zgSPedZjVg520AUOfsVV6byvMrwPqyoXVFGGudvqy4qFsO/knDRQplBBWMbspq4p7x5CG2YviMaqjMmFBN+hIPql8V8/tlt2oycWGEeIJBPbEgELnQS7DudZLVm9mOqBlPEATfkmt8z3PzsrFADZf0sUbMpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F/E40bu+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c739120475fso490517a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731604; x=1773336404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/YKerVOgUfCo1tZeAnR18gxzPlHG3ROkYEM1oa36L+0=;
        b=F/E40bu+0iE/oWUROXZQs8ZgBwV5YR5gMFOqYBtr/elhydhl/f9n2AIT9lP8lCUqb5
         dj6hHag1mC4ni4Kc3tMGw4rAtJQ4A5jNTNfnDtsbVV5yv8efLkrmJElYgz3E8Fk71rDF
         8p6rbPWtnJ/QhCoPYS0++JSu9F8Fms3PkzHw9YOPj1ivStsUB62YfV8J98TMmStD3alN
         4h36fzWfdqwpRgEara9iQzEDZ4kzbGJpNbj9BG+9zEhxkokte5WiFXLAZ9NATQxGAwKn
         tqvy2z5nZwbsgX9js7J71/+6dyxDvl0oGgscmuZP7uzi4Vw0TY3k87eNXsHfEyuSVqCz
         N95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731604; x=1773336404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/YKerVOgUfCo1tZeAnR18gxzPlHG3ROkYEM1oa36L+0=;
        b=qF23dtxxIyGZvV4YvU5MSn7S7xke/Y6B3D6jNwyd0f6Rz5ruqubvRkmYhzRvbIY3zL
         Bol0yUu3VY/lgClAMSNhoIFzw8YM+obOzEETOyHSkNnZYhKgie0RWoUKq+I628OFOYgN
         W6tiwVGPm8vCVOfAennTNPwG3xPt+R0dujZ6nmEM+KCCtRabpqHJnvzfvCzV1vpTlZXN
         UEjaaIIVWqXbsyqHuIVEGm71EKQmS3ZxqDRr0N03Z4em7cIQn99I49hMchxghQ/1WDZh
         IL40c13UmDcRdmCwa9hzcW0TlBmNUVdKrdzG8giId99NAS3KLhowdrsIiZCgp5JX6izT
         3Tvw==
X-Forwarded-Encrypted: i=1; AJvYcCXihMyY0Knyr8qworj5yUrqF+gDnR/M0AWnZCDXNikiv+XjXEUbpj5a8kyKhDu3idjZ8bA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK0R0FCeTRI/zaHMhS0bV+lt92EC6nyuDIFud+L4zs/Cb5sIVg
	Y6YDVMiw5Jt4xgTRXUyzsvz7x29c2vHkIwDMpv9wYBIC4f0URQ2pEa3rGfXJ5vBFvZzXW3R1G1q
	t/FsRfg==
X-Received: from pgau29.prod.google.com ([2002:a05:6a02:2d9d:b0:c73:8e3c:d0d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3291:b0:398:4af5:a61f
 with SMTP id adf61e73a8af0-3985493108bmr318140637.13.1772731603971; Thu, 05
 Mar 2026 09:26:43 -0800 (PST)
Date: Thu,  5 Mar 2026 09:26:41 -0800
In-Reply-To: <20260227011306.3111731-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273157299.1580330.10745295571877711572.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix incorrect handling of triple faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 2D5D72164BF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72880-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Fri, 27 Feb 2026 01:13:03 +0000, Yosry Ahmed wrote:
> Fix a couple of bugs related to handling triple faults, namely KVM
> injecting a triple fault into an L2 that hasn't run yet, or KVM
> combining #DB/#BP from KVM_SET_GUEST_DEBUG with existing exceptions
> causing a triple fault (or #DF).
> 
> Either of these bugs can result in a triple fault being injected with
> nested_run_pending=1, leading to triggering the warning in
> __nested_vmx_vmexit().
> 
> [...]

Applied patch 3 to kvm-x86 misc, thanks!

[1/3] KVM: x86: Move nested_run_pending to kvm_vcpu_arch
      (coming separately)
[2/3] KVM: x86: Do not inject triple faults into an L2 with a pending run
      (DROP)
[3/3] KVM: x86: Check for injected exceptions before queuing a debug exception
      https://github.com/kvm-x86/linux/commit/e907b4e72488

--
https://github.com/kvm-x86/linux/tree/next

