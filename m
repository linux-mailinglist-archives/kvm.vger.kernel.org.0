Return-Path: <kvm+bounces-34099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E859F72C6
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9534E7A24FE
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B3D86337;
	Thu, 19 Dec 2024 02:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEhv6Z51"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C709778F44
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576081; cv=none; b=kev45uBQukycIu0ygPW28rugPGcMaZ/9HXSu/k8RYFvLdHHCZLEkn3px+HaDsUNfP+gQWnsnqcoOeoMk1AQqI5ERb3h0hGvlRv0BcIbIsKfc5i6+2a96LIcbxLOKn2V5SBH1502W7x4e/a+FcTbzo6LWOpfveuXB3TNhx9FiNhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576081; c=relaxed/simple;
	bh=W29aFcScQoZlbgRh7q306lEfMLyFwCWO5iBjpHfIMpw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dW8v/IH3mYHe5bMTGDfn+V6E2JZRvppcOivKXubI+m+egsvEBxRrL/qrWG47Y4C3waBrbZg3rmYNqYxpaE7CoKVQOpWd9vwVPx/h+0AkI2ZpgLWHWhVML5xA+17corOrevF+nIwbeg6gTiRkFTBY0vxDMZ9+e6ms70db3mxmcNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mEhv6Z51; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21632eacb31so2602015ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576079; x=1735180879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8/s1yCN2zcQIkiltQKCEikgMkhC+dhz8YmH8QUKsk0=;
        b=mEhv6Z51CvylbwU9qQP8xot4rX+6mdIY7v0xU0n32WT+7uWa4LyakbPH/S0kjDS1tJ
         GB43Mi336OELvcbEUVMFqI/2YCm4W+iIIJo380LhdZpYFu4uBENFmsmT8vyAvNjqICV3
         kI6GqO5f74gSsFeDDd0BHuF0eA9+UfgS24RN7jPzgQt8lghkaTDYmWMejMG/uPBW5W7o
         hFITgX0CVenbsY3V5WIA0LL0mqWJNau+L+vZLrQp62PT/+sQjj4T4tmz3NKRneL296Iz
         kyDJ+kN7w3xCIQ1JYmLMtEknhvSK6ob6jSK6ernIf489g+KFXM5E5yMbqZwwnBc4nd5U
         GPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576079; x=1735180879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l8/s1yCN2zcQIkiltQKCEikgMkhC+dhz8YmH8QUKsk0=;
        b=MSejNbg85XAm1naj7mYBHlpDwxScPdOwNPw5AVJ+MNq4b6M7CamStVxla1Ev67iRB8
         hS8xKht4YXZvj82H4sVy5wtJhBZxPirGdWVKQNe0pIPDjPOcqfZuZTssVxj6pWAtV7iv
         oD3KRqeZyrL9yEAwtWtI/aGirfBHbCrF+SpoRPLHdELW5Np2e21L92nj0n0x2owr0fa2
         dPlkkpO6WeD9Rgdt5IddCs2z1DTci0XzVR7GGzg765UGBeEVZLBuQufH9toQFEaCkdrU
         BdvHUsHNCufRVvujDbyORCxAPOg7RQcTdzElQAzM8OnaUdXU7XVkZyVlNN/yMgSo7IsT
         yBxQ==
X-Gm-Message-State: AOJu0Yy3x94eJ+4H+GBzD+lQBOOsQkqQ8ledJ3H7Ecy74vlrQCSmpIkA
	bcTSzM4aZUYwsyBXngQ3lSit61NsPL+O+KJKtd2pjs3+KQTTzSgscRem+L/in7H2pQx+i2j3VXn
	s2w==
X-Google-Smtp-Source: AGHT+IHMAV0PD3ksM/bCmRlL3QA95RZDiejljIEb5aW5zvEyHiMeJNhMFgopxZvYLzqtAspgG41g8FSC/hw=
X-Received: from plii21.prod.google.com ([2002:a17:902:eb55:b0:216:2fcc:4084])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce85:b0:216:1d5a:f33f
 with SMTP id d9443c01a7336-218d72877e8mr55980925ad.57.1734576078917; Wed, 18
 Dec 2024 18:41:18 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:42 -0800
In-Reply-To: <20241128004344.4072099-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457537849.3292936.8364596188659598507.b4-ty@google.com>
Subject: Re: [PATCH v4 0/6] KVM: x86: Prep KVM hypercall handling for TDX
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Nov 2024 16:43:38 -0800, Sean Christopherson wrote:
> Effectively v4 of Binbin's series to handle hypercall exits to userspace in
> a generic manner, so that TDX
> 
> Binbin and Kai, this is fairly different that what we last discussed.  While
> sorting through Binbin's latest patch, I stumbled on what I think/hope is an
> approach that will make life easier for TDX.  Rather than have common code
> set the return value, _and_ have TDX implement a callback to do the same for
> user return MSRs, just use the callback for all paths.
> 
> [...]

Applied patch 1 to kvm-x86 fixes.  I'm going to hold off on the rest until the
dust settles on the SEAMCALL interfaces, e.g. in case TDX ends up marshalling
state into the "normal" GPRs.

[1/6] KVM: x86: Play nice with protected guests in complete_hypercall_exit()
      https://github.com/kvm-x86/linux/commit/a317794eefd0
[2/6] KVM: x86: Add a helper to check for user interception of KVM hypercalls
      (no commit info)
[3/6] KVM: x86: Move "emulate hypercall" function declarations to x86.h
      (no commit info)
[4/6] KVM: x86: Bump hypercall stat prior to fully completing hypercall
      (no commit info)
[5/6] KVM: x86: Always complete hypercall via function callback
      (no commit info)
[6/6] KVM: x86: Refactor __kvm_emulate_hypercall() into a macro
      (no commit info)

--
https://github.com/kvm-x86/linux/tree/next

