Return-Path: <kvm+bounces-30241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6BC59B83E1
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04DFE1C211B5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617371CC162;
	Thu, 31 Oct 2024 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JAhPAd9g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB53D1CC153
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404697; cv=none; b=hgbfxEPqM+Jg9xzapXzXJ12cyOd1YUvaXHSwAZeBTmK93tA3C4b2T/egWFIEKVuqmJUKVJKyiehFECgEbI8mdMEbPtUg14G52nMGw7mUOF0c8MjxIKvNAywC9sY8FpVWE5iC8ID6+9jZQr0xNwUpW1v7vhgOqmc3xJX2X7Q0TQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404697; c=relaxed/simple;
	bh=wfVPuQjg4pTT8nITD0HM856Hwxi07sPDN/CPn9k8zSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SJABCqfN/3Sv4FXqstxq7M3wsk3GERuIbgo8qP2pY8EpGVURJmSjBpxLplxVDXby4rRs5c5ivXV7lIPjk3+5S0w6cj2WPdFZfujhbMhh2Yn/KeH4dZEekCVQUirxfcw3F90ao+kwBHUv9lnjUs+NL5FzL8PMkaoeiDe2gqBoLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JAhPAd9g; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e35bdb6a31so24870947b3.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404695; x=1731009495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNICsHqwMdHeZvWy3hsB3nyNIVlSoJHA3dF6aNeWo6M=;
        b=JAhPAd9gKVi01qoImGcXSMbl+zAZW00BYRYt+MrctRM7EHMX5O3AlDEs2vzjsu0PVG
         mOn+7wp+ai6uIeMHJ0T/eV9ko+0LmamiBp7iofquzzynAELe0bZnnKDjvqkbQ9MgnZd3
         eqk0cS06IxqM/bEIhKz+UmnF5ItN22HQx8GebaCwA8D0G6bX0pqMulhGLjrAZbwoCznY
         D5jXYEE7xxRVmg1IVOvY1ORAOTKEmQebZO/hbOm7NuDrFzW2uTB9eJwpKQm70So6Btid
         NyeHR9RTCnK4orJuOxmTiwXZhpeG9YK46hcbp7ldmEZGG+iT05yUAXv2aBmgPNtCXUyY
         dlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404695; x=1731009495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNICsHqwMdHeZvWy3hsB3nyNIVlSoJHA3dF6aNeWo6M=;
        b=okDnAMvTeALhCXFqH8lmPqHc+YFtV35/5yOAVVfMT2cGWVBK1ytmMHcTyXpVDYCARr
         IKuT0vHbvjiWArd2I5C71x4pjXq6J5OD0KpqrMQF0wK2uPsHRB5+iiFfcjQl6GaQ0b0g
         GhLRMzb8A6/gOcIzHhHqh1+bCtJA+ahaBm/vwD8IFeNgsIiNJ7eauhCwoXySRf3DwdGK
         YSO30SK+59ocXJ1ygh0NcxLkXPWscB/U7O8vojPLJ4etl44uF7rSGssI2DoF+0NuSaCK
         7l7qbQNTWlokhn903lowgD4jQf7w31xY7wqXFdm1l6/S7Ls/Glt9AA+NTPPW1bVUaLyf
         CEuA==
X-Forwarded-Encrypted: i=1; AJvYcCXXvrUFFy2fJHVkwzD+C187fPREeVi95dvjqDqr5FsaoI1Y0gQvOdELfNcnNllUOxSYVpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuX/NzFYVXYw4isiq4n21/xTnW2/N0hulY9XYj8PVFjJ/xHSsC
	erRaZ2YZQ/8yNWl0sOuhFB7rZuYuk1sKfZGwPuaY9HKMm/OubWMXZ/D+ECKkQupEI+pV6EzQFx5
	D1A==
X-Google-Smtp-Source: AGHT+IHIBAudi8+ePUHSP0AIZTVk5T1CCGOPq4+2lkCRsa14EhhW0npTIP2rwAL+igCci0qbI35PHNl2slY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1d1:b0:e2e:3031:3f0c with SMTP id
 3f1490d57ef6-e30e5b0ee45mr2642276.7.1730404694604; Thu, 31 Oct 2024 12:58:14
 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:58 -0700
In-Reply-To: <20241014045931.1061-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241014045931.1061-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039500886.1507775.1819808332270567216.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: VMX: Remove the unused variable "gpa" in __invept()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, Yan Zhao <yan.y.zhao@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 14 Oct 2024 12:59:31 +0800, Yan Zhao wrote:
> Remove the unused variable "gpa" in __invept().
> 
> The INVEPT instruction only supports two types: VMX_EPT_EXTENT_CONTEXT (1)
> and VMX_EPT_EXTENT_GLOBAL (2). Neither of these types requires a third
> variable "gpa".
> 
> The "gpa" variable for __invept() is always set to 0 and was originally
> introduced for the old non-existent type VMX_EPT_EXTENT_INDIVIDUAL_ADDR
> (0). This type was removed by commit 2b3c5cbc0d81 ("kvm: don't use bit24
> for detecting address-specific invalidation capability") and
> commit 63f3ac48133a ("KVM: VMX: clean up declaration of VPID/EPT
> invalidation types").
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Remove the unused variable "gpa" in __invept()
      https://github.com/kvm-x86/linux/commit/bc17fccb37c8

--
https://github.com/kvm-x86/linux/tree/next

