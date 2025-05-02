Return-Path: <kvm+bounces-45259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E05AA7B8D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAE2F4A8113
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6693B213E81;
	Fri,  2 May 2025 21:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5crxOho"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0283B20E33F
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222675; cv=none; b=bFrdyww97vhIoqXMrscU603wDVCO+tMDgK1ZzDR0UcKhrkQnwG1vVBUCwBtLQRmmTqnGX7/xlnJAa0GCbXrRG54oO9J8U0RcTEv3893XemVj1GIiyiPAqN4ZkjmBj63H180sVFLUno+enmzNELl9DrqNbF0V8bV5bsy2wM7cOpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222675; c=relaxed/simple;
	bh=Gj/hcXfuvVHFknDEAxJ5AVipH6beh4WGFNEUuiyEd0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qsd9tsxNC0hhfM8uN3gCBingulnc8H/BBKLKUGFjavSmSgz2BylnKuGRqo09v1bzjALQ93DsaukxwdCcZWA3x73sGOAR6ReSG14YVf3FhzjT6J5sLR+RtoAs8VPa6osrIVULeEjWyPSQyCNnrt5OXW8hTLmu3P4i2bWd0MFnCaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5crxOho; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-309c6e43a9aso3455255a91.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222673; x=1746827473; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1F14yPjgIjua3k3WxhflUPSluE+UaRJV2x5bg1KV/JA=;
        b=e5crxOhobelG8IVl96wtzIGPBmipU3M2iHQ+83a64m4NoA89lo4GipDe+NUYyH/oFv
         NSfsMtkPrv8S1D0mRCASH5Gb2wo/Gsp3AHbT3QfiwGPxMCJz/UK+as+g9RtnXLwS91ZC
         gRLpWXkIyKaAa39e9nPuda/Shl1mj6wWXo2UwkZWuA8vRsi8Y/uG6d6ItdsRZCBBzQ3C
         4e7R8Ya9rgrrwr+8J9mwsejSXkWtclB9srUbQX4//w4jiH/FB8/GUC0tI5Gz/MksGR6I
         LjeiMSmkyJmCMvrPUj5vsmHqQlTFVLRyCq+wOZtHErvkv7j9nMW7lh+5L7DZKyGGJAcR
         XJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222673; x=1746827473;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1F14yPjgIjua3k3WxhflUPSluE+UaRJV2x5bg1KV/JA=;
        b=YxMAhxG6CZvtGaHeKgDI0Dhz1fTYTP0fJHf2COaqS2EXPwjuIkz71rlOpoea9qne7x
         Xlxv01fcaCiQOsZvSsBxwNbrZT9rfXGaA91M7T51G9X4l6RB44wptPU8d3822W+vvrqL
         cK2CuB2BUkk7AlEzSt4t/yRgg2jUYnjnN0NWh2rL29FUrv10qzro/k4hBfW8lXpwkdJx
         qC/xtcacRC+l63ZK07FRlG8tHSL85nXdGs1SDXzS2unZ0Ln+soZME3LDQQjhvVdEB3dQ
         6AiJWezQD7JE4n0qCPd29WZLLnFq4swIHKOLCCBfXxydGSPx4qjkGoMHkbQSMgXZ608k
         6kVg==
X-Forwarded-Encrypted: i=1; AJvYcCX1ZFLMbOYW120UnuVDaa8j2RconBW+qgAXMApd/ltSJViAXhRCiKNA/OCkSFqdRKkOyCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEm+OHtLlX81tKLwx2D/PKxK9otxiVQGwMn9no8i/CaO3Uszmz
	MPU8Ks3t63VGnsHzBJAjtkHSyxEEpkRlIFSl0LtFwYiN97yvbEm+1lFrHJr0LyRbsX1mmP2UvF7
	W9Q==
X-Google-Smtp-Source: AGHT+IGU44TiKCZpI7ljyJ9xxYxmv0CT76QH3Qjgw2iQ9CqlVFba2IULpaRLM6JskQG0YgWolj5yZUMzRG0=
X-Received: from pjbsu14.prod.google.com ([2002:a17:90b:534e:b0:2fe:7f7a:74b2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2801:b0:2fe:baa3:b8bc
 with SMTP id 98e67ed59e1d1-30a4e685d7amr5721229a91.23.1746222673285; Fri, 02
 May 2025 14:51:13 -0700 (PDT)
Date: Fri,  2 May 2025 14:50:51 -0700
In-Reply-To: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622206797.880734.10916535986146752236.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 28 Apr 2025 13:55:31 -0500, Tom Lendacky wrote:
> Commit 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
> updated the SEV code to take a snapshot of the GHCB before using it. But
> the dump_ghcb() function wasn't updated to use the snapshot locations.
> This results in incorrect output from dump_ghcb() for the "is_valid" and
> "valid_bitmap" fields.
> 
> Update dump_ghcb() to use the proper locations.
> 
> [...]

Applied to kvm-x86 fixes.

Tom, I tried to find a middle ground between capturing the "snapshot" behavior
and not making it seem like the reported GPA is the GPA of the snapshot.  Holler
if you don't like the end result.

[1/1] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
      https://github.com/kvm-x86/linux/commit/5fea0c6c0ebe

--
https://github.com/kvm-x86/linux/tree/next

