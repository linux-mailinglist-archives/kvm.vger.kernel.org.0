Return-Path: <kvm+bounces-32605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7270B9DAE9F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1394C164870
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE8C201260;
	Wed, 27 Nov 2024 20:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v6V+ltjJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404F314F90
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732740458; cv=none; b=SaV3RL+kJsonX6YDrSvgaJM8EObGREf7fN7TCnIjpPaN4Bf7FMhxIOUM+Pu378/yxw6n4LfJoXYcDDQgunsJgLWXPTesHORGPu5ssJRruv6OmBQf+tqyFmckblESv6zD8WuagN9khQZkhojyW3W+bIKKT82/wxuggDJkwA++ZgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732740458; c=relaxed/simple;
	bh=+NOLQpZ8k2VzPLsG2cKS+G7N0xQy3Lre/9Aqw3Td2lM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fDMC6w7ptnAHVALBGun0Y1hhE+PBoTDh7elRMEepRuC7rUxMrwvir9qjfhOsT47mpgR1WuSqPokE9AncHtYdMazA0ZoCn4cZ3cWZ1vAsoX8/ObBj2WC3GHUpjCq1XTgqcx2fFErvB0buy85qTlz1pHd2B4ZwlYCxwNteXcQdqFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v6V+ltjJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea42039766so160743a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732740456; x=1733345256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDHgMzQvV17xwScSGP80Z51ZEHtmLEPAmGNNCP/yJSs=;
        b=v6V+ltjJ/vVDtYeWneXV73nxSYcUVOplMjSqz1ZslCR9iIMkyQkxjCraQ5Wlqs+KXN
         1sqTl4j+rUGzu5YaNKD87DPzgEzj1kEJ4mr+ayilJGWFWVVCapUA6hNPHg22/kqi3vc6
         vMoebzoSYDA7v645UQa7afielElVWrUm3aFaI7ultVzqc1iyHJ5Heztj0ImnI7+XRzRY
         Ek+8uivfvC8TREwOpg4HpDB7P36Lbkfy81iDhqU2SYoCgHnEXN3mABUWS0QQpjc2Y/qv
         k0JEAcpeYCXIsOIyrxYoQmX0lNF+y7u+onmlsce0IEOAI4Jw+R45nFhFiw/AncrmWKNm
         LEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732740456; x=1733345256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDHgMzQvV17xwScSGP80Z51ZEHtmLEPAmGNNCP/yJSs=;
        b=YqAzDnwfDwzG1wv0UGrOAUGUFRfkkUGfRxP0nDNfTg69hpHo+1f8J+Qnb7b2+Q9hIR
         a+yhMBDxJw8wZ+vErj6K3+TfQZzo2lE8BkLaOJTl8sQY7A5LJSCepQ4XR1L1qXpiDjO4
         0Cj+ekrXW6kk8CU2KsCBZU7APVheQO0z4aArJeyruB4xRD/Zd12lzXje0B5CtMJaa0YM
         zHD2IZ0KPvAfXoBVjKOZY8RyXflrJ5qUCc5aRMewne3Yg68d4GSHBXVoaxBPlsbzAU9F
         ZFsJuZkDvtts/yTjynwU6duFV4ZM/diR1WAM79s6XmowOS5hp+6MAU2AEEY0X0B1Hz1w
         D3IA==
X-Gm-Message-State: AOJu0Yw+RZftyr79PyRn9fqk+QcFQjLSSodgxqzAZmwu3OvWJ37icLwT
	IOT36PFpikEaWCYuP4aCNWqIA8LtErzuEvSXyjpjesr6FP1hzaBBW4nzgA4V7XkheSbr8IpuPxd
	l5Q==
X-Google-Smtp-Source: AGHT+IE+1B5hNdTNzmB3FWVrAZzu1SjlVJ5B1xCWC1V4AnKxH7PpsHFJAa39YCUbGcPcZZFpRpnPVTPAQxI=
X-Received: from pjbpt13.prod.google.com ([2002:a17:90b:3d0d:b0:2ea:6b84:3849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfd0:b0:2ea:3b42:35d8
 with SMTP id 98e67ed59e1d1-2ee097baf4fmr5957266a91.24.1732740456579; Wed, 27
 Nov 2024 12:47:36 -0800 (PST)
Date: Wed, 27 Nov 2024 12:47:35 -0800
In-Reply-To: <20241127201929.4005605-7-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com> <20241127201929.4005605-7-aaronlewis@google.com>
Message-ID: <Z0eFZ6b7JizKPNYX@google.com>
Subject: Re: [PATCH 06/15] KVM: SVM: Disable intercepts for all direct access
 MSRs on MSR filter changes
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com, 
	Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Aaron Lewis wrote:
> From: Anish Ghulati <aghulati@google.com>
> 
> For all direct access MSRs, disable the MSR interception explicitly.
> svm_disable_intercept_for_msr() checks the new MSR filter and ensures that
> KVM enables interception if userspace wants to filter the MSR.
> 
> This change is similar to the VMX change:
>   d895f28ed6da ("KVM: VMX: Skip filter updates for MSRs that KVM is already intercepting")
> 
> Adopting in SVM to align the implementations.

Wording and mood are all funky.

  Give SVM the same treatment as was given VMX in commit d895f28ed6da ("KVM:
  VMX: Skip filter updates for MSRs that KVM is already intercepting"), and
  explicitly disable MSR interception when reacting to an MSR filter change.
  There is no need to change anything for MSRs KVM is already intercepting,
  and svm_disable_intercept_for_msr() performs the necessary filter checks.

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Anish Ghulati <aghulati@google.com>

See the docs again.  The order is wrong, and your SoB is missing.

