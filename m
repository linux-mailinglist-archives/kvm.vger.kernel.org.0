Return-Path: <kvm+bounces-59740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D26BCB208
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9B04F4EEEAB
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B493B286D4B;
	Thu,  9 Oct 2025 22:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kWOqO9jd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9BC283CB0
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049659; cv=none; b=urN9vmCHpD7ayUK+aSnS+aI81xI3ZygfbA12/xxaACIPqOFkIuxpG7QyCRAyeyBrDE3JPwpYCkRsuFx3W+cZpYy5XkzSP68qmJiXWcgjy90y8SPJA+0dy4ewx8i4dMMDmGFcP4WKH6azBHcidcjMPpkiiKPc5rlxbzBTX/0kHII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049659; c=relaxed/simple;
	bh=iHRkwjZFmsgbGZZzOocWcAK7uAsaUtkHpRJuDecbgAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n1Itd9j2sIExF57l6xphL86/wPNrbJJdtD1MVo4XRVraJnpqoqBYcXWFb82jcXF4mIvGMPxi4LDGIish94aAA3gooCCdMMY7Uz0Fr0gbwQIXFT2VPCnApLPT3Pny0qlPyASb2Z6VlwLUPKhMBRkhhZX1Wj8m2vCIlR+p6x6tqi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kWOqO9jd; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-633c627d04eso3627a12.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049656; x=1760654456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+yH0NA0xcLeoUzm7kKblyD7A4cYDfGhXJpCuB241zQ=;
        b=kWOqO9jdBNaDQWxdpD1Jzsrr6vL8xpF8EfnwiLBCNRr5NUct9D4YR+5l2HrbZqF3QR
         tp4p9SDOsbtmSW1zylvYJrr4fxQSe2N13nRE13gifOYLKdyy4KwTw+7D2R9SnZN2VDFE
         jsY5vVeDSrW1iWyXZQRNYeqIByU0EsqNi+8Km3AWjxvxF+0N4iJLNwL+siLoPWkkn95v
         34wDQgkxEg0+4s4jPJVSdGoxs2zDojS6AImBKGF8aYlzSsHkCS0Xmmkl2G8s+SE/0LU2
         ZzxagTJA5eMZuyVH5bBIu3Tn1lCPMfRZhZaZExiz19epP68XIqHnzBw+uN8cHPGoReV+
         xS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049656; x=1760654456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y+yH0NA0xcLeoUzm7kKblyD7A4cYDfGhXJpCuB241zQ=;
        b=lqWO9O3D09DoroiF8Yv1Y9F9jrkI79CBPiNWGQ2Ps8FtufY92s/LDPjA/jsLpFyvvF
         tVv7KFRp9UJlfINCyMsFavYumEDET9lxCfmbl3ENd0Rz9WQ0NrwM8aA+UELUt/7Ni4DG
         5jxX2QTtUFEG3VTybo/WRuRMwVFYfzVEAaYOd6AfEHIxJX3rX4G73cOkSMCIAq6hfzm/
         wEu8fIIjIvfINPaaSdzmi7ufKx4V9GXdYLkIPdb5OAogvN4MNXVYXvUZTFv3mOT/lXz0
         L7HKzwJvVbtqAMNHhMxktnD+OFUKDIJUqUu6gL7o806S1aPAmL8eaI2w8sfR4UyTBpQG
         1k6g==
X-Forwarded-Encrypted: i=1; AJvYcCWmexlsVNBWED4SwF9YrHlrXhbM6dLSTpzPfR8moWD1/XMTf8HBxMIzbMG9qHY+2wo2Ehs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1n5w8lr2xTtn6Xx/FHKnlPHq2X3nV3g2yYdhqO/Hab8+0Nrff
	mzrzfZ/B0pY0wtRpJKZ834M8WKy1aZr74VSNpzdV6gdTUECUjqrR2FrCH36GYspkzXFypbUQ+aU
	P0YKVVYmqG9I2zz1ehXOUPFWMEpOo+1m8QLyIp/EJ
X-Gm-Gg: ASbGncsF6oc98IS1lDSPm4aMF7d2NtKvZsiCpZiXBpdX2AgtcoAnnXOs7F0Ygnzj8DD
	2carLHphXgYQL1QHXrAeM3dRFRzqDBWLHqEFru4zr9mbJFx6eQ2Qrl0oEpUKzyE6kov5tpuNYXh
	+MjMSQTo0zFdYehazw6wTzMdmlYil40ywgmnXneJRs3vjoxVXRL6hE5UCc4uyMsyDE+o1LP/bpN
	kxq0eh6VkJbyTnOLP2U9RWKJ+O4qxM9b58kPQgS684CCEeB
X-Google-Smtp-Source: AGHT+IFMM1arzendIaoMvMcuHn77hUD6Cz9k4obCkd7Pd1UFiRKLhkp+8wOJGZxP9+89FENelDIu1jZMTZAZS1MUY/U=
X-Received: by 2002:aa7:c602:0:b0:634:ab12:83d4 with SMTP id
 4fb4d7f45d1cf-639d52c4caemr298350a12.6.1760049656367; Thu, 09 Oct 2025
 15:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-3-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-3-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Oct 2025 15:40:44 -0700
X-Gm-Features: AS18NWC2e-ck6-uSYkTGFpZGqTrjbtjUd68e3ZwQCkjFl7PBxVXuoTR0B7cFVUc
Message-ID: <CALMp9eQi15V1+5EqCevm9aWMv4OAGbUb14dazBcjhhL8mVGHww@mail.gmail.com>
Subject: Re: [PATCH 02/12] KVM: selftests: Extend vmx_set_nested_state_test to
 cover SVM
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:03=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Add test cases for the validation checks in svm_set_nested_state(), and
> allow the test to run with SVM as well as VMX.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
> ...
> +       /* If EFER.SVME is clear, GIF must be set and guest mode is disal=
lowed */

The GIF constraint is not architected. See
https://lore.kernel.org/kvm/20251009223153.3344555-2-jmattson@google.com/.

