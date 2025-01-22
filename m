Return-Path: <kvm+bounces-36298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1D3A19A9D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 353C43AA5A8
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF15F1C68B6;
	Wed, 22 Jan 2025 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2sIStrtG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8959A18A6DB
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 22:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737583225; cv=none; b=e7WUXdP1CQBAbE20DY9vidEvJ8vbapS8i07DbWgkSCFV4ynRCI4CGGJwpstxDLmZzqnRZMZrxTmmCm9gsMfHFOeCn1QF7r6nezz8tYkP5660zOIKNiUmeVSy/dAJRoqx4Quxp31xz/5juCZkSJwWADWLBx37sBXE4qVRBKJjSy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737583225; c=relaxed/simple;
	bh=l1b6Mjkm9Czkw/S4l9swnJ0dWXkxdCvdoTr1iVj1Luk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FlTfAAwFEAdVAteY+7JK+yUErj1ZXng+OO/OD1vcx85hRhfx4dF4NiNvwkLf/mJEdEiuPn6ZZdKHkH+4WUbF74sKx/NzxlZHsouXfQvJivuHHw9Jl4tfbDyj72ESAcnlR/Zof1wLYlaf1x3z6FQRMXiyvRar+bJLkZaPN62/+d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2sIStrtG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2166a1a5cc4so3420745ad.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737583224; x=1738188024; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VgNjX+aHj6RonknlNxScnoD3ab9l2nJMXp3ji4z94u4=;
        b=2sIStrtGLuHvCwZedcL0u3h/m+8U0u0pMcgFUJTM4DqCU6OYH9HZlad8UG6vac7vEq
         z7q9Pa8lXDk7MJI0/3kCX8BMCgtqWrLRrahAdsbugtnEb8Gc3PMqnbmajQBGGVtX68I2
         i6Hdz7MiWlAEjdp1Bx02Q1kwnPQFkeFSNz8kPYFHALBhugZdvg46BlGT0PrEX4RX5UH8
         3p7wqv78tjdNqfTTdqWMUOFDUDXkxuNgm2s3+E5pondEC1ZcsXae+YG1KULpJjzs85r7
         8a9fvLp04hRv7xiWvip5OEVpZL1W7Z9DjXRqezlNVaquvFfspswl+owUSBvOGH0wNm7v
         IgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737583224; x=1738188024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgNjX+aHj6RonknlNxScnoD3ab9l2nJMXp3ji4z94u4=;
        b=mC04LPrp/cb1sKkBfu9qRrjrSSMjUx9dXAuXzubpg1q49Iedwc6EHYRGxSXXodltC0
         PD8q20xsah2G7Cm3IQ3fANplGOo2eblTGQUTv8CMCh1cfgRW22shCi9Mwge2jxmewucV
         L376FhB4uPJekxjwDDNamsG544IQou7eUpuIn7kLTBiOVE3QKCy80o18JTcArEnykoWt
         6DRIpU0M5iAcDfTWJVMwCWjX5TQVMTgbzYizjlXUiAchOAGWjYtfarmfqrpbh3ehIUXl
         2/XiCHIx1qyyURjQRx9hJdZKmJa/H8OcIxTTmQqTM8YSoe6hG+qYW8F3OqPwM0p0dWfz
         fzWg==
X-Forwarded-Encrypted: i=1; AJvYcCXvBw5ntXOY7DcJSfuoNzRZlVtWl+G4R37lhuG+SiWmaaQ3gHw/kgEXOhwYGAaFquaj6rQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA4i6ocBxgnjAb0nawgvld/AMJVooH3s9ZhtgrosBR/qWAuoHq
	8I8p/x25mCaGVWm+tI2xdgfWy2Elyzv4TFzYo+5nPErzTmMNEL3YqG1ogP/uN3UJbRPCuykbc8y
	gPg==
X-Google-Smtp-Source: AGHT+IHKIfEKJsLPdvtOKj5jPXzf3mSv/EAgdrvewgIqyig1Tk+VI/almLEUEdaCNDfqYarlMhPNUDQEWhk=
X-Received: from pfbcj14.prod.google.com ([2002:a05:6a00:298e:b0:725:e4b6:901f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7886:b0:1e1:9de5:4543
 with SMTP id adf61e73a8af0-1eb2147ea76mr31233458637.14.1737583223715; Wed, 22
 Jan 2025 14:00:23 -0800 (PST)
Date: Wed, 22 Jan 2025 14:00:22 -0800
In-Reply-To: <06e9f951afb46098983dc009c0efbcef3fc1b246.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122161612.20981-1-fgriffo@amazon.co.uk> <87tt9q7orq.fsf@redhat.com>
 <a5d69c3b-5b9f-4ecf-bae2-2110e52eac64@xen.org> <87r04u7ng7.fsf@redhat.com> <06e9f951afb46098983dc009c0efbcef3fc1b246.camel@infradead.org>
Message-ID: <Z5FqdjTwPmnV1t-1@google.com>
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, paul@xen.org, Fred Griffoul <fgriffo@amazon.co.uk>, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 22, 2025, David Woodhouse wrote:
> On Wed, 2025-01-22 at 18:44 +0100, Vitaly Kuznetsov wrote:
> > > What is the purpose of the comparison anyway?

To avoid scenarios where KVM has configured state for a set of features X, and
doesn't correctly handle vCPU features suddenly become Y.  Or more commonly,
where correctly handling such transitions (if there's even a "correct" option)
is a complete waste of time and complexity because no sane setup will ever add
and/or remove features from a running VM.

> > > IIUC we want to ensure that a VMM does not change its mind after KVM_RUN
> > > so should we not be stashing what was set by the VMM and comparing
> > > against that *before* mangling any values?
> > 
> > I guess it can be done this way but we will need to keep these 'original'
> > unmangled values for the lifetime of the vCPU with very little gain (IMO):
> > KVM_SET_CPUID{,2} either fails (if the data is different) or does (almost)
> > nothing when the data is the same.

More importantly, userspace is allowed to set the CPUID returned by KVM_GET_CPUID2.
E.g. selftests do KVM_GET_CPUID2 specifically to read the bits that are managed
by KVM.

Disallowing that would likely break userspace, and would create a weird ABI where
the output of KVM_GET_CPUID2 is rejected by KVM_SET_CPUID2.

> If they're supposed to be entirely unchanged, would it suffice just to
> keep a hash of them?

