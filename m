Return-Path: <kvm+bounces-8242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F49F84CE47
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1069B26177
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3567FBDC;
	Wed,  7 Feb 2024 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcdYkA+V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5627B7FBBD
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320393; cv=none; b=RpMLqppAGU/bdXGBHCpWo6/wq8dvPaDFvsKofbDTO3zy/HYeux0LcPM7b2DiFofuMHHyZX7QvRbLHHcnUCUdaT11aRLYoQmOsOjYPEEyPa+6IP0uQMxWp7zyDNlmAj71tBCEOk+tLlB+cydwGnzvqYpY9TOKlXyX8fetgPnea3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320393; c=relaxed/simple;
	bh=LjkaP/58PtU/mEZcOrW3Z6nQNBjxZ1mblfqFHWtphoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SDN5RFOpGnpuJoajBy+gYo5NHSBpze/5+RGq+Po5RUeHtpssSQX5gZ9WW2UCtk0N2fljRz4G2pbi2x4mGV2h0VokKzE+pU4Jc9I7kA0WjkcfumZqix1t90ZMmgQqlwQQ1/bbMfuzuwddgSlNMqmoNw+xrBw6WQsKYOZp+ywfCOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KcdYkA+V; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e06c03316eso356768b3a.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707320391; x=1707925191; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MP00cAF+lbB1IB+JNFIWr/0G3/2k6U4WEvUSE+Ofg6A=;
        b=KcdYkA+VJD9ZRbN/0pKEjWdi+xJD0XKs3nx7DgReytrAOXZDUjDO1vSKTK/BEmlU1c
         IbOlzRGRZZEA4vnYZaxh+7GflhXLeEcG/zanUs6jMWXsnuL/H81iQWSvE1ugQ2KY5Ypf
         nW3gnXCBwIOFTJ6petlWrPGokeD9m6FUh+JFMgttI2cecIB7T8DbXwBz2t7Qxq/vOJvP
         q2NYpvSPwz3tp+ad4PyToH4syqEUHXPLKQF+hIpkXEOopXmwRhtWcBxAZhnnEF6Kwusb
         Cj0zt6UvoXIoEfT8Y0ah1Nd7w1cXF9A+wSFFx+yap3CMiTf0TBgDCmonEBFQsx4kLKn9
         RZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320391; x=1707925191;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MP00cAF+lbB1IB+JNFIWr/0G3/2k6U4WEvUSE+Ofg6A=;
        b=TEeUXcm5R2gQxILJoEdVRXf97emW9vKFzKMA8Ii//8JvKPXVu7NZZWJfjo79TLRKh/
         HfVTIIVbF1t2kSqhELJ77V4usBt+Ou/POlqOjXgHx/A5Vv5gAHJ02PeWKACkP3VLeIpH
         a7VD/3WldoY/nQjs11XSYbh2qyreXSd+jMOZcB7BrrVjKZiWVauRUDRc1SLCjdBt7/QJ
         IaPeOfiGLEotMY7AUI46bgsiHQg3KzW53Nb/SdLqv5Gjvhh6mt1EXzNsNvaelaIKaZ7u
         7txnbafQYOU08b4QMXfziM/mvIZ8rxS0JvSvfrii4Z7rDUqjUF6Q12tQQ+z/SjpbqCMX
         GsIA==
X-Gm-Message-State: AOJu0YzVmnYOm6SZm23/RhTybVPViDc0YT6Wkw3olJGnd8wjVgRj0S/h
	YgiO+JyD4NHnL3+MygHPFeiKuYSzq75tRJ0z+h42GsWVZb8/+R0nvusIkf+pX5eFZW5dx9G+ly+
	Vjw==
X-Google-Smtp-Source: AGHT+IEKNwD2x3BYf0hQrUmS/ECtCacMU0Y3UBFT7748g6QN/uYN0uZ9PIOGPsjg4lSmnGcbPb5fP5hZQAg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:84f:b0:6df:e757:cd56 with SMTP id
 q15-20020a056a00084f00b006dfe757cd56mr180478pfk.2.1707320391651; Wed, 07 Feb
 2024 07:39:51 -0800 (PST)
Date: Wed, 7 Feb 2024 07:39:50 -0800
In-Reply-To: <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
Message-ID: <ZcOkRoQn7Q-GcQ_s@google.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com=
> wrote:
> >
> > TODO: Changelog -- and possibly just merge into the "god" arm commit?
>=20
> *Facepalm*
>=20
> Well as you can tell, I wasn't sure if there was anything to actually
> put in the long-form log. Lmk if you have suggestions

I think the right way to organize things is to have this chunk:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b1e5e42bdeb4..bc978260d2be 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3309,6 +3309,10 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fa
                return RET_PF_RETRY;
        }

+       WARN_ON_ONCE(fault->goal_level !=3D PG_LEVEL_4K);
+
+       kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(fault->gfn), PAGE_SI=
ZE,
+                                     fault->write, fault->exec, fault->is_=
private);
        return -EFAULT;
 }


be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY_FAULT=
_INFO
is a lie.  Userspace can't catch KVM in the lie, but that doesn't make it r=
ight.

That should in turn make it easier to write a useful changelog.

