Return-Path: <kvm+bounces-11398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9768876D33
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9666D281CC2
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC2E3BBDF;
	Fri,  8 Mar 2024 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z6Nef1/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EB12C6B6
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937429; cv=none; b=SK+9y/eM/wZ02R60iH11u/lwu7v9zPJtlghFOZh+xPeq/UdpVtcNzHRGn180jvpmZV3JHBAnCVZUOafPMQSH0QnTxmBUswDiF2tSLf4HQOvjbFiNJkyI3KTsaES6gMIq93zAZcl9iFzF+u09uA5qDa0XeUUhPLEbu2H38m+laZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937429; c=relaxed/simple;
	bh=LLXqX+BVUwia+hkGp9HY+cbLEWgv/TA1oEzTRyRwH1g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QxBI1/8dY84qFE6JQfoFU9fPif9aa4q65ZlKd5bGk1xIMrGvUUT8Pc7N153QobhBYEx7P5ngvGZyf6JxwBxFvN2wq3jy4XWb1eKuePYWkrzvsnvaDwmS0UXj5ktV3sAdRuL8u/RHlQt5zzHrRYiXqNrfqR4BO3eTRYdbgcnVQpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z6Nef1/+; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a541b720aso4570537276.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937427; x=1710542227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/QN9/bztu1JOOvBVMduriRSw65pe88Hfd7UpVSK438=;
        b=Z6Nef1/+2jERJacX9pRIN1OjXSD4/jBsaQ5XQi2mODHP8RAYpfHGdrBiFKRv6SqqYK
         TKF3zMAGDYnKP33j080ry2Avbr402segRkihJACEeULSeHMnHxxmZha5vlkAckJq1uIx
         CEKSef7jj8Aox9lp+MKwJIEglkodLCOFgdFZKqGtUCvZ5RzQjXrkXSQFcMyST0/TPSPU
         AMMHcYFlTXDVsWeXLX0RaXeldd5roNW37d+2kKsMpHzVLLaZFZtFZ++eIcTPrdI9uKRq
         Xm6wzA/1ukVcJADx0Uy3vZhTrZW6o8USTHfTEWFcmMGGVo+mlwn5YomVuuyqkUZe5OjJ
         MK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937427; x=1710542227;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3/QN9/bztu1JOOvBVMduriRSw65pe88Hfd7UpVSK438=;
        b=WS0EP3rkNL0P4VcQoayyEp4jQ4m1tJdy5pukw8KiIsy1hxlhcnQBaUEDT676FPN/Do
         9VAxKulF6bfvLV11cHhKTX6TsMXMYoELT9mm80AjJG/W4A7o/0pQztVXXlcM62RYOrU2
         ZYYW/Yd0g8VKVb6HbdKTxzYPGds/weZYKDHB1d/ne0Lb3/6GbHGn/ZB8au60PxoiJdX2
         mZC/oR7dPyViHKHYXuyO4qRNLysEf8rt6Z/LP4E5o7yFbjpQqfCwbtrs3mWIuyT/0DS+
         EFOwyh+ML9OE0jzFovgdI4KDCaSnJFHc7wFfqzjfP6Zcj48nBEIqwzcFE8ypfSmoHYEx
         /oYg==
X-Gm-Message-State: AOJu0Ywu1uKkfJjo46A6kIpLCh4g9NtrHwAZcQrYpIZnhCTZyo/vZqV6
	1o+b8oUfetuHMnE61Bp8wYeOi0bCD6S6/cdjfJuXqHXj+zJjjwBBzp2HFjZcyeeOfcIsz0l0Bzs
	l7g==
X-Google-Smtp-Source: AGHT+IFSZBhfelHFTxyz+euQ5LA4XwCVwo1uAOrGRwBVwxUKzGi0YizMdN1RYrk/Zc/sKAf+/BS2Z1l2RIA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc7:42:ecd with SMTP id
 w4-20020a056902100400b00dc700420ecdmr93554ybt.6.1709937427437; Fri, 08 Mar
 2024 14:37:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:36:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Main set of pull requests for 6.9, in addition to the previous two for-6.9 pull
requests (SVM[1] and a guest-side async #PF ABI cleanup[2]).

As mentioned in the PMU request, I'm expecting to send another pull request for
PMU fixes before the merge window closes (hopefully next week).  I am also
planning on sending a pull request (again, next week) for Vitaly's fix+test
for the PV unhalt CPUID bug, I just want to give it a few more days to soak in
linux-next.

[1] https://lore.kernel.org/all/20240227192451.3792233-1-seanjc@google.com
[2] https://lore.kernel.org/all/20240223211621.3348855-3-seanjc@google.com

