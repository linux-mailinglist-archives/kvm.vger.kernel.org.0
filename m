Return-Path: <kvm+bounces-30367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDCF9B986D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C670A1F22CA4
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6AA1D0175;
	Fri,  1 Nov 2024 19:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0s/+TF/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEDA1CFEB7
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730489056; cv=none; b=Qr5XitA8erwVgqtZWvtyHo7m+ZHngse3vJsL6KhsXHYg1mlLtPFuwbEwBRLevzx7L0dXfjmVR294v4NDt4AofTJcPDlxpHIRuJpIpv2z4rcSPDEycBqeGh4L8p25kQQ8HUuo0JG9aWf5Iv4039PlkNDr9OijR4m3np1ovcD6rNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730489056; c=relaxed/simple;
	bh=waFA7JUjYk8261SzvR3E9TcY2sF/GY6yjtVVhhKVNYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kQqiCWeYZc5PWFtaLOQptC+hX0ii1iVRvQxG1q8xe7V8Aq5blNXDp1tYTLMkEXtpyXVia3CEeWHkTKBHjC1zVPRpFKh7b89LgilpL8VqWBFlY/Tq1PAj7aUWil+BvtQXgUxVq2T8YqMnCSMhO0J3jPSEc/4ySgA3aoip+xB83tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0s/+TF/+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-20cb3d9f5eeso19952435ad.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 12:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730489055; x=1731093855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lo0BRhTxoGsYmyZdsoLkO5ZYMsC/PbiC0MlmUUL6eN8=;
        b=0s/+TF/+p6LmLMpzats4iHFYn87s/gNrsZgf6jyD4IuUzcKMAw0gh1JyYS+gNzKqgV
         HhMVFPrUaJOXQncmVUHDXEw8PVTujqXfHoAkq99tzNYzwz0/bsN2BKN9TibjCSiOxdPQ
         6y9D2LU0WjH5YEmLkYACG0Xu5V084ev+k6lcyL4E6eJN2poDWWMPu+tWNS+53dE5LkuI
         dnvbvOQwYFcP0W0ixMVH0Wow2JrG+Hj3f04bdGGvUf+prBkYOI4VF8idJlmcDfOg8bg8
         hoFOe4VPYyE2aM7wDx9DXQ6EV63u4GgMFY9F2sX09DQPN59eM3/u6/mZNioRvZvFlw/b
         Uplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730489055; x=1731093855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lo0BRhTxoGsYmyZdsoLkO5ZYMsC/PbiC0MlmUUL6eN8=;
        b=WF8nY+0Wz5SQxd/Hxwm5mGgtk9Dvi5lK5gl5V+aQf/B0AoMPNLd4Vep0JhOOsOmjCR
         YsqIwRbde6/MWzKdLARLKxZjm7cMm/mb/dCd0kTe11QfTLZxGg86zxN94LvPuhdiC+Vv
         6E6fJITWdTNLtMzYPsQX/TKjyFgQFGzKr/sfTPsGOYtshRvYvpwx3R+knoFy/ybDvozm
         r+IdtyTKQiS/xPko3nC0FeOaElLdrYXxcqQy1a2AK9fpj5gXMCxVukJDdN/QFEo5WB94
         X+DHaVgryLh1QxFwfw94YkmvGYJAZ9swkWyJ6Nd5Aa8RftEJaMsDwv6GqBp77NnEzvHs
         FQXQ==
X-Gm-Message-State: AOJu0YwNtP8SakP3zxTxw1GEth6SQvgYbwEtmwuq5qgcFFs1f83DxHuU
	ZBnF8w75rP4rZf49rcWU9uTWRocUgcY3wuxQhQKeHMaH2Zlns17ZtkePD7Ho93j3hhQithqo2YH
	vLg==
X-Google-Smtp-Source: AGHT+IGQz5HIbvcdsklFk1U8K2pzyCVbD5kE125GcZgrfggCexOE1wDsiWZKG56vgwLAlQPq0UheS6J/bk4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa0c:b0:20c:5beb:9c6a with SMTP id
 d9443c01a7336-2111946702emr76735ad.4.1730489054915; Fri, 01 Nov 2024 12:24:14
 -0700 (PDT)
Date: Fri, 1 Nov 2024 12:24:13 -0700
In-Reply-To: <173039507056.1509043.12101873900724716741.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802200420.330769-1-seanjc@google.com> <173039507056.1509043.12101873900724716741.b4-ty@google.com>
Message-ID: <ZyUq3WSLbKkoiExF@google.com>
Subject: Re: [PATCH] KVM: x86: Document an erratum in KVM_SET_VCPU_EVENTS on
 Intel CPUs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Sean Christopherson wrote:
> On Fri, 02 Aug 2024 13:04:20 -0700, Sean Christopherson wrote:
> > Document a flaw in KVM's ABI which lets userspace attempt to inject a
> > "bad" hardware exception event, and thus induce VM-Fail on Intel CPUs.
> > Fixing the flaw is a fool's errand, as AMD doesn't sanity check the
> > validity of the error code, Intel CPUs that support CET relax the check
> > for Protected Mode, userspace can change the mode after queueing an
> > exception, KVM ignores the error code when emulating Real Mode exceptions,
> > and so on and so forth.
> > 
> > [...]
> 
> Applied to kvm-x86 misc, thanks!
> 
> [1/1] KVM: x86: Document an erratum in KVM_SET_VCPU_EVENTS on Intel CPUs
>       https://github.com/kvm-x86/linux/commit/eebc1cfae6c9

FYI, I rebased misc to v6.12-rc5, as patches in another series had already been
taken through the tip tree.  New hash:

[1/1] KVM: x86: Document an erratum in KVM_SET_VCPU_EVENTS on Intel CPUs
      https://github.com/kvm-x86/linux/commit/0e3b70aa137c

