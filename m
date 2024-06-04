Return-Path: <kvm+bounces-18819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AED88FBFF4
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EA6E1C2298F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:37:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8D114D708;
	Tue,  4 Jun 2024 23:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mtciDoVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59C714D6ED
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544254; cv=none; b=kXTrBOPXzcEOnXXjlPeWcyrWQ7+UYJgrrTIYyR/nLL3zrBgYFKKCemdkvkWstKvwoN0gzuXzVx3iB+NVr/gubF7azekTv6zdFWJxPhFSvjwjM9u3wPqBxQsPYL/OjL9pI+cFDiYGvsz1cNA79bH4n4CVs4BN7bpnDWmxW2C68A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544254; c=relaxed/simple;
	bh=U1yAyx7cuyVFpl60o3sFcCfbv96IoZW7jXHBYJj0J2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VwlCCEGS5Vknn//zRnZwYadE9XT8h89R+hYPNl0J9Q/CFTrmhSeck9EYy1aM8ICRfgxO2lIjTey6B0pwA1Vyhm5tl+u2mwLWqTqJqw13+GnJ2N5rJUgrAQoZs/A+disPC6Rt9Rd4DSQzpMKqdqsTn9GKK9+CIL0D+22tEg5DU1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mtciDoVm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f61b9823cbso61088155ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544252; x=1718149052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1aziGuG3oqscD80bCqynmifrWZFDgLg8pJgvYx3eIww=;
        b=mtciDoVmdJu7ss8MPLBDecxRLmZjXnRYIOYkVcF+kqF7g6EWvAP6kK2BOCfbi2uoc4
         zAiThLDEv4iF34Ai75Z4QJNlxIBxgFrsRl4ZKBIp7j8aFFhmSRGrzCwcjgTfzX1fZhUK
         JtkV7EQ87Ni4qYM0doiVQk1h8JWOqwREBLT7TZGP3ClxQKppytwBWEskxP4E0XY1riUt
         BBZIAA54pH1oprUMhwNwHnPmnXSiVp+7t00AsTnznxsKinfdfxuHGX/6Pkz9qmqhBx/r
         BVxjKjDDTsVxgkvR42mMmhuTrawR64RNf9Mh5C93BX8pIquwsqZZ7on13OEIHWBFlfTK
         fJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544252; x=1718149052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1aziGuG3oqscD80bCqynmifrWZFDgLg8pJgvYx3eIww=;
        b=fM21jYjUUltUlTiHj6zIH0ydXmH9rqDKXpyoEGabI9eDbLkzZ7ZsQ9cWJL10M2GhJ6
         qIwmcTk/CtzY/ewGDZWS7SlD8aK5OAqX42ntdbfURgfx+afFpv98w8rVLMuB1lbSQo5c
         oPpPVTQH21VnyUPoO8t6k5EhQdvU9DGVCXF9Hf50LofbnZDvroL2geekpekbc5gc19ry
         LvJQm1UR4E0nQ/YiQjlW6RCU0CubCAxV53nLvZ4IaldQpNU3RtmUu1zjMEi8CQqRSeb3
         tJXNHEDE5pNfMj9GUAOMAjZ2ZcLpVBKnWYvkLEZ6r1in34ybSz8CGSiZjqKelwHdHMHm
         PYgA==
X-Forwarded-Encrypted: i=1; AJvYcCVsQ7X5BtO34mELjpVRasMokByWXQKaa5e2s9RE9htDqc7A4uCdB7+rAd69aDD/HA1lfS2sJHVrToCqQ/LG1cKJkKCc
X-Gm-Message-State: AOJu0Yz2e2FIIPs3Ehn22lA5E0sEtcUGlZ9T2XE8RTevX2bfAfZOlczd
	Gvrlm7mvyB1ZL8tTxiPSpBFeb9lB338+fP/y8JkEB9TwjXd/5aDquS71R25TyrzDYlLB6Qs7gj3
	+ow==
X-Google-Smtp-Source: AGHT+IG8j9YdiZulKToJcOB+QeemX29Tr8HUrp2T7HOKShIoiBkbqEtI5DvXFe9kqpB9ZsQDTTdUbExlxXo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2311:b0:1f6:5631:4ec5 with SMTP id
 d9443c01a7336-1f6a5a0e853mr948095ad.5.1717544251880; Tue, 04 Jun 2024
 16:37:31 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:29 -0700
In-Reply-To: <20231102154628.2120-1-parshuram.sangle@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231102154628.2120-1-parshuram.sangle@intel.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754275211.2777812.9934084019005836188.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: enable halt poll shrink parameter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	Parshuram Sangle <parshuram.sangle@intel.com>
Cc: linux-kernel@vger.kernel.org, jaishankar.rajendran@intel.com
Content-Type: text/plain; charset="utf-8"

On Thu, 02 Nov 2023 21:16:26 +0530, Parshuram Sangle wrote:
> KVM halt polling interval growth and shrink behavior has evolved since its
> inception. The current mechanism adjusts the polling interval based on whether
> vcpu wakeup was received or not during polling interval using grow and shrink
> parameter values. Though grow parameter is logically set to 2 by default,
> shrink parameter is kept disabled (set to 0).
> 
> Disabled shrink has two issues:
> 1) Resets polling interval to 0 on every un-successful poll assuming it is
> less likely to receive a vcpu wakeup in further shrunk intervals.
> 2) Even on successful poll, if total block time is greater or equal to current
> poll_ns value, polling interval is reset to 0 instead shrinking gradually.
> 
> [...]

Applied to kvm-x86 generic, with a reduced version of the doc update as
described in response to patch 2.  Thanks!

[1/2] KVM: enable halt polling shrink parameter by default
      https://github.com/kvm-x86/linux/commit/aeb1b22a3ac8
[2/2] KVM: documentation update to halt polling
      https://github.com/kvm-x86/linux/commit/f8aadead1971

--
https://github.com/kvm-x86/linux/tree/next

