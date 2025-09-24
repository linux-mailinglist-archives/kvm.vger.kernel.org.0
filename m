Return-Path: <kvm+bounces-58690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24184B9B679
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FDCF7AB90E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C108C31DDAB;
	Wed, 24 Sep 2025 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e0oMAR43"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBF831A068
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758737441; cv=none; b=ee4QqBHgVpUyQnaZEr+bT+FhiXz2n9E2FEMS40np60x95VlXRVAhmUD//V03KWDCGY/Sws+wzjweIEtQBISN+drSvOO0c631XrVQe+5bMgM25/2Yekg3y06OclKTMGZIRTpByCO+qzMw4pfTgHzUcKY4wLhbaLOGA7gQ97joQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758737441; c=relaxed/simple;
	bh=HnbCbq8xUoSPL82EWmkwrjtcy/MfRTsomun+NPlhkOw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uJkQdp1aMzjuoFV+xjvcFKdi/RLhSunSD4YXGLmhOVs5NwkEQTYgHxNejuXEwx4/n9JkuSutMQEH9EWFGSIZkedccNNi6niy9gutR0l/ns5FYscmNOutHEYQtjLdMbrHwvx9R4qjneGL1uzxBBu6pyAXi1ViCMhdRyD/cJqoZU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e0oMAR43; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77e4aeb8a58so84179b3a.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758737440; x=1759342240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kTEo27w09QsleqdXmAFAASTfDXHnOjQN5vy93ATVo+M=;
        b=e0oMAR43B/uFQnYTpsZrJBNrTTe6hp/+IA8mEUv2YrQm6434zFjel0io3RTGBxfRhB
         nhcEIRGsmOFIhsxiI+VrPZ4uIPjFdzQaGvhcECb/thDTU59r8xo7eElcb+7fa6XtTh0P
         i+asCrY+LDPFzcAD6+S8eHpvokU9P1CfTdAWyQNTOOhb7F6I9pAc7GwaaM62Tlyfa6L7
         k0dkPg5KFH96xC73MW58iC43av/ryCKJeWVn12sX3rcfzraTbbebNNxmDhMsLULl+d5o
         RkBeKIMLkMa6Ds2nurNyLOJN5Rqefvj0HL5bhont44Rl9ydOFspOE/ghCpIUfXvncmXt
         zLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758737440; x=1759342240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kTEo27w09QsleqdXmAFAASTfDXHnOjQN5vy93ATVo+M=;
        b=f7aeG/Gg6yssw6RWNC6adIvhi0RpGPv/vgvp52H/0EiF+jgQhmFEigiKTq6DoeXq0a
         0EIkdRZEVB+nztZmp8pW4zuHSzM41Rq4dPLP5rrDz09IVtTlMmRhnfqcDCgSPGodKG51
         wbfEYQhQTl38hiXfvsjZmHutrL4hwz74Iic+gXMDTxpUl3Ao8Q+ef8/wu8Y7cfb5zP9h
         ErNaNZkRlmBdwkuQVsgG2da0kOa3LHMaa4SSGofTCpgcdJUsWPeHtR4UGLRXtl5iC4GM
         ebSsa3RKhVfem0mMITu9J6tp1XKONq5VqxgdRKLIqWheJYakYDN16dXWibFaEjghqr9l
         lE8w==
X-Forwarded-Encrypted: i=1; AJvYcCXXEUMG1G4OS2QAvln2zqe6s58tr5lFqeuObSIgNRDnv6tKSpY6g5XGLBrfRbjo14r/GiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ+OxJ74a4AU0uFXKfdoLb2arFhexZfz2wHNzdAMH80VItpm1D
	g12ntV7FJkX8ZxNTOW5H9ode4aScEBSgTIuL0vVH1RFIKGzZzPdfEJAXpEK+bcPiSgIJu58hSpL
	XEI7OwQ==
X-Google-Smtp-Source: AGHT+IGy9UhUhJ98F4R1K3qPDUBkNCiqaTPTXyTbsgsjomOe3ENcTeNXnn7xs7rFzLQlUBH41tSk9/xo6jE=
X-Received: from pgbca32.prod.google.com ([2002:a05:6a02:6a0:b0:b54:ac4f:20f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d84:b0:244:facc:65ef
 with SMTP id adf61e73a8af0-2e7c7ea5c1bmr631932637.19.1758737439691; Wed, 24
 Sep 2025 11:10:39 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:34 -0700
In-Reply-To: <20250908210547.12748-1-hsukrut3@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250908210547.12748-1-hsukrut3@gmail.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873638301.2146431.11936191215737388089.b4-ty@google.com>
Subject: Re: [PATCH] selftests/kvm: remove stale TODO in xapic_state_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sukrut Heroorkar <hsukrut3@gmail.com>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com
Content-Type: text/plain; charset="utf-8"

On Mon, 08 Sep 2025 23:05:46 +0200, Sukrut Heroorkar wrote:
> The TODO about using the number of vCPUs instead of vcpu.id + 1
> was already addressed by commit 376bc1b458c9 ("KVM: selftests: Don't
> assume vcpu->id is '0' in xAPIC state test"). The comment is now
> stale and can be removed.

Applied to kvm-x86 selftests, thanks!

[1/1] selftests/kvm: remove stale TODO in xapic_state_test
      https://github.com/kvm-x86/linux/commit/ff86b48d4ce3

--
https://github.com/kvm-x86/linux/tree/next

