Return-Path: <kvm+bounces-19376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1611A904845
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17CA41C22E4C
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7E8B663;
	Wed, 12 Jun 2024 01:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bUvMAmHu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E069610795
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155181; cv=none; b=osN9//Lh+zXVJc99zAeKpqncFWkV+OqV1gCXOKXS8WbRknQjyBzMAeVFQiba2TNVbIF2b9JlABgyGlbEfmn1Oy56gDM8HHJ5vVK+o0UKAz+oD0+Tqhd95qjsiVlKVOGXGbZfhX5h1UCNjGfCQ8FvLwdOgg0M+e5i/HDRE5uYrvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155181; c=relaxed/simple;
	bh=ZtX1s1hXE7bmPxWnn9VXN8JelDZTdMwnyMJhqBsFBDU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MvvIABQI8gPOYbAw+fOnfH9MfflH5VTiZ1zJhiXcoLJ/qMvMAnWfonJQVtqj3b+VdV3sqTVJKYuWPHJR2lBrQ7Pnrh7E+WZUCLPyih6Ov1Ll5hwNjeXw6x44kklUvF9jMb54RAdzinee+aBAqO2423Yv2J3WNPu+QqQXthD9vW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bUvMAmHu; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6e3341c8865so4248839a12.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155179; x=1718759979; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8jsSK3imQEryaxf2anzrgoWKvNS6m0fGR63VtCmdp5c=;
        b=bUvMAmHuie0Q7b+SaTGDqt0wjQb7lWtjB9xKZxbAKwUs6GjzUN2/dffI9+nbBRYMCB
         hdd173DuWVXjaRz9fYvqWfkiW03PlhpAuQMt/kcZE/qzBzLkb4xyRjVEQgmb2gC3yXrP
         sxhr0qT4Bzl3G+SQanm4L2nQUEqQMqxCzUMGCkHWQDlvurLa96RbFuYRfyBy52OVxqQN
         Ah2w+VYPXK7Bi1VFMjnE+sjqEvY3QWofa05Ljl1ZwZHGAg4fHzIJFkyIPuhMfPvxyUG/
         xYvTygO429zzUCxitH63gBAdoy955MFiNRs9+SfMrpTFIc8Q9Ou3GU7uikcffjMABr8n
         hzyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155179; x=1718759979;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jsSK3imQEryaxf2anzrgoWKvNS6m0fGR63VtCmdp5c=;
        b=b5HyIfHG3dw5O+/+incjaonXOf/RhyHhKlwwG+aU+l+dEY/6+WgQaVTeY1Nlw0pHZ3
         ERIzUMzuSHj2Em9zMYfx4aPy4Hroxw93dSCylYkfvJEZov7AVqO6kSMSJbFVSY+YYE+e
         EGS8IZyeC/dkMPi37HjNBNo5p2uOIUuspCdGjFKtk9q1yE8eVkHip5VZtCpMO/jB0f36
         nibB5H2a6fzzgEeupZJjvPn/A0091btTQtI2QA8cFL6UFPXTotvRjaiyJbkxK0xSQDh4
         iWyJrK5F2pJ7rJfkti4Yw6Ycja7WyEcZ/nRQS4t4DX4LwhziM+q6hNSPzQST3udTZ8No
         Z+iA==
X-Forwarded-Encrypted: i=1; AJvYcCWQGLLaJoKMAm8aKDNNSmvdzE43wHNPx1QTUU9i//Znkjov6C4R4bIG4GWkIhZX9Iq/Ohe2G7b9t6wOZ+VKs4ly8BAo
X-Gm-Message-State: AOJu0YzYC51Bzg2ybvT/CE9DnQeAPAbPbffp86Wjks+1X5LtFfmuP5CY
	jtPhujOLqRbsWLkD5Lk0qdTw1BoXzewguRq723QDw7dk6JvSppNc0ll4wy82slmDBklXhbF9+tc
	iNg==
X-Google-Smtp-Source: AGHT+IHUUEc4D4vyKYP7fHBa2tj4d3EHkY2IkXDSa1+CkSKXASaoY9W2JGXiM+UnleB8V6TtDr2FxNvlvXg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:586:b0:6e5:790d:1d6e with SMTP id
 41be03b00d2f7-6fae66aadb7mr973a12.7.1718155179083; Tue, 11 Jun 2024 18:19:39
 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:34 -0700
In-Reply-To: <54abd1d0ccaba4d532f81df61259b9c0e021fbde.1714977229.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <54abd1d0ccaba4d532f81df61259b9c0e021fbde.1714977229.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171803647246.3355936.8432724232961067756.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Drop unused check_apicv_inhibit_reasons()
 callback definition
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 06 May 2024 14:35:02 +0800, Hou Wenlong wrote:
> The check_apicv_inhibit_reasons() callback implementation was dropped in
> the commit b3f257a84696 ("KVM: x86: Track required APICv inhibits with
> variable, not callback"), but the definition removal was missed in the
> final version patch (it was removed in the v4). Therefore, it should be
> dropped, and the vmx_check_apicv_inhibit_reasons() function declaration
> should also be removed.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Drop unused check_apicv_inhibit_reasons() callback definition
      https://github.com/kvm-x86/linux/commit/c7d4c5f01961

--
https://github.com/kvm-x86/linux/tree/next

