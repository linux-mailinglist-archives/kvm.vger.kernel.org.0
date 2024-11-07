Return-Path: <kvm+bounces-31140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 896F59C0D5C
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 18:56:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E2F028350E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 17:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E019216E19;
	Thu,  7 Nov 2024 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kP6ywlC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0AB6F31E
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731002156; cv=none; b=MtAsWFz8X0vmpiq8Ye6QxbIhCyiY25F+WaDjx04T6DyqohNAtzLzG3PkSccWhofnmfmPlCL8EYWme/XnZ14dqO74jzY2fFUccKbPy/Ug6g7xKQ4+oTTHxxOKOMmXDVQo6DoL70RADf428NsbAN+eZfK+fS1rbyYwLioXhQFGPU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731002156; c=relaxed/simple;
	bh=2s4A8gKTdQZhphe0yJhrlb5JiI83cOaCyhsF5E0G8Yc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q4TAhqwLskVeUWJEzthuuZBYrYYvy1vFNvdGyxivAFyR1F0PAyUMEB39MzBIOAR2w+3BFTMlzUzIuqNia5YXU3R6y3tA7iU/xNIdfR/jusHqNGWuDrqRzUXJjTtzPJbh4N6CM9QoNwRDrITGwswQJ/2NbHqoZ8l1grfg3aeGLKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kP6ywlC7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30df8dbfd4so2567850276.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 09:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731002154; x=1731606954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgKJYCEI2CSDb/xLh6X/UMs+jy9ls5WzdJWZNluUnjQ=;
        b=kP6ywlC7QEK1suWlF2NDIm4T3AktXPoZ9/xvYwffxTdEH4GPvh6R6ZAHitlP0vv/HM
         QMDoeo0YSLCOVQvARcRg0/SwBOaGeJlfW94aXcuWs56sYX7FCED+8m1L/6Ts943nHbGc
         vk4Q3+z1eTpbS92nn8aA7ccK3gGkmQgdmuX7gG2XqYKuvnJe6xDwJX3WzBnJD1dUGzxP
         lgxUlquGEwsF4VxngeqDS3q6/oV5p+4eUCRllE4Om2PLRbwt0STHyB79m2fCEwikgqKS
         Er46RqIzwN3bpqMJaouNALP+JEKoKt86XxTZMGCZm2ohLfn1DWjEKUXt/nArolH/dgA0
         NPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731002154; x=1731606954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgKJYCEI2CSDb/xLh6X/UMs+jy9ls5WzdJWZNluUnjQ=;
        b=G4PEw16DwkGp0FS0a3aQFy23l3F+Qx2IKe4U6MI648BxhB2Nf30zeC6z+Cxr9do2Gr
         PdWKbUOb/4J6Hj+6r9AIBMCWXMmw+gwddaB2BkjKSGtcr6yOu+4ItVklRH7+Ys3WLzQv
         CccsNsNmZIWHyV6yHOL5dhkOfPG+wiQZxsrYhFibTfy8d/EqldmQYYsW0kAExhLpmo5R
         5ZolQcDiHpY9BSFjIB0DyJEHdrkHUKvUQ4PdZvLgbdqX+hw6bRsTP3dVPkg2pGh0OzlX
         hoVgREyiAw9E7OkYLfxvIyFhAZr6vuNVY/4mLM6HVMr+bcy5XvUdF5rL8dTDSyAThErp
         UZsw==
X-Forwarded-Encrypted: i=1; AJvYcCVTjzscqtQSjhQdFVcEo0WyoIiN4JhFLVSh+GpIUuHSiZlPfpiZ6OSy7muyLAdA6iyD9uI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxuzw0HdF/EZiKqezvFfZ+0bghhnDrma/uk/3Tdu4pvpSfGDAy
	DpbOUtXGJsgBNs7NVZ8EyHCYyTZbCo6UYbK4UNB9rOf6fmafcwBKXv1hg+ewrD2gLqjuE5gE4SY
	g8A==
X-Google-Smtp-Source: AGHT+IFvhTHMuMFI9mT31McwxfLIdUC6ciPwdbQZ4NP2mqW4X0p7NR7s1YxE8I5RlOmEFOSOgJ08jSvYgEg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c347:0:b0:e30:d61e:b110 with SMTP id
 3f1490d57ef6-e337e429bb0mr369276.5.1731002154247; Thu, 07 Nov 2024 09:55:54
 -0800 (PST)
Date: Thu, 7 Nov 2024 09:55:52 -0800
In-Reply-To: <20241107094000.70705-3-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107094000.70705-1-eric.auger@redhat.com> <20241107094000.70705-3-eric.auger@redhat.com>
Message-ID: <Zyz_KGtoXt0gnMM8@google.com>
Subject: Re: [PATCH  2/3] KVM: selftests: Introduce kvm_vm_dead_free
From: Sean Christopherson <seanjc@google.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, broonie@kernel.org, maz@kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, joey.gouly@arm.com, 
	oliver.upton@linux.dev, shuah@kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 07, 2024, Eric Auger wrote:
> In case a KVM_REQ_VM_DEAD request was sent to a VM, subsequent
> KVM ioctls will fail and cause test failure. This now happens
> with an aarch64 vgic test where the kvm_vm_free() fails. Let's
> add a new kvm_vm_dead_free() helper that does all the deallocation
> besides the KVM_SET_USER_MEMORY_REGION2 ioctl.

Please no.  I don't want to bleed the kvm->vm_dead behavior all over selftests.
The hack in __TEST_ASSERT_VM_VCPU_IOCTL() is there purely to provide users with
a more helpful error message, it is most definitely not intended to be an "official"
way to detect and react to the VM being dead.

IMO, tests that intentionally result in a dead VM should assert that subsequent
VM/vCPU ioctls return -EIO, and that's all.  Attempting to gracefully free
resources adds complexity and pollutes the core selftests APIs, with very little
benefit.

Marking a VM dead should be a _very_ rare event; it's not something that I think
we should encourage, i.e. we shouldn't make it easier to deal with.  Ideally,
use of kvm_vm_dead() should be limited to things like sev_vm_move_enc_context_from(),
where KVM needs to prever accessing the source VM to protect the host.  IMO, the
vGIC case and x86's enter_smm() are hacks.  E.g. I don't see any reason why the
enter_smm() case can't synthesize a triple fault.

If memory utilization is a concern for the vgic_init test (which seems unlikely),
I would much rather solve that problem by expanding KVM selftests support for the
selftests harness so that each testcase runs as a child process.

https://lore.kernel.org/all/ZjUwqEXPA5QVItyX@google.com

