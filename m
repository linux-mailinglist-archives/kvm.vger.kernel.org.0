Return-Path: <kvm+bounces-18821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609A08FBFF9
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D01A5B23CFF
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC21914E2CF;
	Tue,  4 Jun 2024 23:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Os+UPWTZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE8E14B061
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544294; cv=none; b=suMl+V+a6uh8+rGn/5AwKf/b8Dy6Bv8MvV0Q3dfd8jt/y8FCMjZ6wwomli+BeoilkUKW8di46owvo+Zs1V46R6xjkTZPqEdJbyQBIN4EpIXN9Tavb1Me8H5v8a/InpSqahdIkpVZZBEXaFYdxYnkRqoocm3yQ4v5fIvLHbnvBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544294; c=relaxed/simple;
	bh=SgCn/l7g4v+vmT6795+UxJUGRirIdKhPEsjbXrH81BU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dfUdjYrFCwROW5pUPjDVJFSD7yUZ2hX9lK0BSGSLVGfexqVXlZSLeiKA+moJWTtI5OiLMosMYpGwp2PBQe8Uq5iWyb6zVaZ40GLoG4LcOdwdUOQdv9WNQ0hDBq7vub2bGeDDDwI3KX421SVgVGiLmjdXZ1OKx+CeJ7+nIDMDhAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Os+UPWTZ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6c7e13b6a62so3376462a12.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544292; x=1718149092; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xAzqMhmS0H/CDDPovrdGPbxW+iLCDyuoKj+AAyKi6gM=;
        b=Os+UPWTZcL9J5fMYbMWCFMFO5MvGW2NUcYgqw03teT+2EBWlktHoZwHSDZZuYI8pGt
         0lVv6Rqw0rwnwJN/8Rl/UCo8iVCRBXTVa5ZujE/j4VtVHEM8VifanD66l/kmIABQ3/iU
         CoByNAv5vGE2K4WYhoXXOJduRiOoPLT6Coa8KbgZjdVOUaKXKxwwDVgxUmRpg+CrW+0G
         heFDPeVA4ebbJKQlgm/S5NFuXwL+Wttpl1Tvamia0bA9Bb77GoVxceSitBsMbTF7owFd
         YIRShUcwUE9uzAxw9iTNjXjkNJTXM3DY7k1Jg+mzOAw9/OGkpmutXp2/s8FMosLRoXxX
         4L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544292; x=1718149092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xAzqMhmS0H/CDDPovrdGPbxW+iLCDyuoKj+AAyKi6gM=;
        b=g/cNIw2kgCbm3dSyx5fbE/X8bY7he1jmzuV8qO2eQe9ET9kBqxDmw1H2dCkjMdOLL+
         qbvOHW75f6XZEbyF0SwXNDT170nbcDtsaAPkvYGZwOI5GLSSfdNIjAu6TSdjmLqYrm40
         nZPQ7j6uzfBqpdlKFpnsZ9Bce44Mv7TgpC6EkhIiauxP8SchSRlzyZbzXmaOWjpNRS98
         1OhxsnH9gWZT2s8tJX5a9HsAsFR2Y4C3oq9Lx1VrXJX8yHEqxxgUOdg0DMODDUX9EDjA
         5jTTZHC/fIUIoyvlkf1z5mLfLtlP+HPbons/CQVbQdTa7UmjnM4cOxMsD5J20fKOAlXp
         QHZw==
X-Forwarded-Encrypted: i=1; AJvYcCUVnbi1vvZfuV8VtRNFg2T/WAUbGPU2Wszx2visEYFmqvzl6aX5QWcwL4veHnpg3t04HuBHvt2E4FVvRwF2+Xp6w7Vx
X-Gm-Message-State: AOJu0YxUweSvMxFT+XbuzXnxpl8zYFT99mGkl7FyojHEJNjBPo29DD1G
	j5Cajl3rhbpXFVS5CrU26y8dkheZtiYzrNk6qEGZoP4wqxylpC0Paz+aJGjNmPiIVbbTnNBa8bG
	K8g==
X-Google-Smtp-Source: AGHT+IGCD99fitWPdtKdasUbYEWUOBm7hBtry/D23V5KTSUlmLEyVY9kWlvcOhJeAMQ6LM++mt1w/gb/8k0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f542:b0:1f4:4618:8932 with SMTP id
 d9443c01a7336-1f6a5862887mr28415ad.0.1717544291993; Tue, 04 Jun 2024 16:38:11
 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:33 -0700
In-Reply-To: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754374489.2780783.15684128983475310982.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] Print names of apicv inhibit reasons in traces
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, vasant.hegde@amd.com, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="utf-8"

On Mon, 06 May 2024 22:53:19 +0000, Alejandro Jimenez wrote:
> v2:
> - Use Sean's implementation/patch from v1: https://lore.kernel.org/all/ZjVQOFLXWrZvoa-Y@google.com/
> - Fix typo in commit message (s/inhbit/inhibit).
> - Add patch renaming APICV_INHIBIT_REASON_DISABLE to APICV_INHIBIT_REASON_DISABLED.
> - Drop Vasant's R-b from v1 since implementation was refined, even though the
> general approach and behavior remains the same.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/2] KVM: x86: Print names of apicv inhibit reasons in traces
      https://github.com/kvm-x86/linux/commit/8b5bf6b80eb3
[2/2] KVM: x86: Keep consistent naming for APICv/AVIC inhibit reasons
      https://github.com/kvm-x86/linux/commit/f9979c52eb02

--
https://github.com/kvm-x86/linux/tree/next

