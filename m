Return-Path: <kvm+bounces-67071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A18B4CF53AA
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5D1B305CD20
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D562333FE05;
	Mon,  5 Jan 2026 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txFGgRxt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C932C08AD
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767637544; cv=pass; b=ufM9kSECRYQ8oqrvbWUr2CLujUU5NsrYsA8qjyOKK51NkLvvlnua9Q9QW+zA8y5lqkW2iseIBPnLyDzleyMEpepJO6i3qkNqrM9NhgO1yC1SgIlZL1CvHS/749XCK9ekdp9KBhQdHv5U/HkVmTJuUiCV17cQSHZJRsh6iJkuzIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767637544; c=relaxed/simple;
	bh=+rsLOIW1esrUzCtOfr5nyd6WlEJlB2L9jLpWg3L3/0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMCH05BjHx58NHAiXcv2ghOv5cexgGZ1YSxsAZdNshe9m3J59/OfJhVCQt1Ks2Npl4dx2uxpQXdwfDd5W99j/T9eLIwlIv3tv0frkkqyVPxZNRVXub5X0ya7sVXmJWlmxGLiWKx/zHwDyvtjjbdHDqO6kxY4POgnMNqZljXg8+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txFGgRxt; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b72793544so564a12.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 10:25:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767637541; cv=none;
        d=google.com; s=arc-20240605;
        b=IAXcBy4FCdovq5Bx0DeOZBp1NxSCL0Nktb/Ee7GnYmasDqUFXr/JhIRLnv+LRzJWR8
         DRjdmnJWHgmCf3KXpX4uD4d6oPz3w/NgedaD8yXZaeHPHbV/MGWnJrvvO5/ihPkx0J4/
         V0rTBDzSRrVm2/10lTWakIUE/XUfKYVf5ccspyqQhLzDPhn1lnHQ62w55GcedCFw8Gdq
         lFndUX3gB2zTxuhG2BWjrZLxGi7BNiHtTgKNLUpqihvaZxH2T0VNZcGwZXMr7ILYiKmr
         lnpxAE5xNj66KhXOrI7PXj95FuRfuMJ30zQk+80TXE3b4EWAnOk5gWgh9p7BTf2MEPGe
         CbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oi7DZ2qZ4qrdJiiBgsksWiRY2EW14PGxhtG4/wy5aM0=;
        fh=NrEMd4cv6v5Zjivu5N0zx3J+1YFispouXmGrRwwFDbE=;
        b=dvN5oR5RMdks8qZN0mMZCnK3nTGiZ1v6Nxn+fszNTmX/ZZPoEuoOKiKfFDwjMNEHSp
         rdy8lcbLiS5AfRORK4VSVEOkxNGlTX+VFR5JUlBVyKCs7wr7elwqgP1tlDjvb8cqSQIX
         Cxv/J7c5CUxKLhTtmNlydjhowH+NHoMOvpFabjTqDX29nQPw+/oku1AcFQQEvxFuEJUY
         c3pNnkTLMh3nWQjZAryXW9j5yQiAve1UrdShdAwMszPOhhS6pYcbSA67lllSJC1EeVr2
         EWgok8HzXvOWmriw+cLj5o5eznFQ275UuV2xYRk7JE4dBcjKZOkW4QzV7MzJ4eiMdAST
         GuVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767637541; x=1768242341; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oi7DZ2qZ4qrdJiiBgsksWiRY2EW14PGxhtG4/wy5aM0=;
        b=txFGgRxty9VFn1GCHEoBhcF5T4a3n8AL6DB5vPxRW87ZSCvLt/G0/xalm13rMEb0/5
         A7aBhCF8No4QCBpZJjD+mL5HQ+Wv8S68TZtOu68hqbHauc3f3EzPHNfzBD30XVG12Ebv
         tVlZFI9he7IElfrRdsi96Puur5pxkMlhWV0HEDxca6DEZKY91OGQRrFHQQcwoYBl0TCu
         OCV3PVSD68NubdxLKM3IaEjGPOGwtLeioXDI8CZJaTtgddnBCPdPhoGRr6V/DEbvOQI1
         UWYWH9nlR/LNt3KgxiXwjRtdFaFVKFFTdtM1WinpGQpPQPRqCJ8p0g0F8b+bO9u+7P1M
         0ahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767637541; x=1768242341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oi7DZ2qZ4qrdJiiBgsksWiRY2EW14PGxhtG4/wy5aM0=;
        b=AS0lj8syouVMx6mrKeBMjuXrq6CoZ/j0B4hK0rICiAmHqbybwBXAshaKt/u/8hz/l/
         I4sklUxN2hzq6axn8BF4UVJ2GVCgu2kSAuDDUK4JHyj5ZbRpEuPBeBRUn06EcxDvvOoV
         OybO8U+fLcnJ9Q6iYOLP+lXIrLVDHyjlVxWrbqcXpO6cVpyGzj6VGV1kQ45XX1jZ89m+
         qHyEURBepfbWtLcyU4G0czmm76+WkN6aFSEYQHXRzMMUdX9bvtxnqPKlUPcgCQ1e7AW7
         73uCwqiinlp5W5R8/oWCSdv4Nx9e/KHjX8K3PprkoGBbVAu0IyftQHMarUSnVzIKQVIL
         XAlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUxLU8QnuwXzjVW1wmk7688+pw4zqP0jomdadRRYiS7VORQRnpbKCRkCE8LeeUdkrFIZM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi0+pWIw0A1i8nC+zD5/XRRjxKHQIN9W3mZb1ThennhqyYc1G5
	misP4UOO0zaEJTZPOvH5DsQ5aNOJr2qak7tR49BZvGiNtZikiD0y4BheBxCxzonTi5HpZ6nwoWX
	YRPS7hkYYfmvAFlNTVICgvd7FrJHrvwUuW3atDwnW
X-Gm-Gg: AY/fxX6rlucSSHord5hsBycHGCoXB6JES0Mx+4OIAmx+lPbYC7nbG7CZtSqB6aomcyI
	PY5ZRUD18Ij9mwapq+/UR9mYmOSCXAd/wMiLuLNCaYLU1lRnxegyk1VfyJCWwHDep4oX+Nm6tLs
	KHCSr2Adbb+9cOQLi6DQZJklKruejhLC36c077lm8v7JSEEo0L6Mm8q8REdQ5UXUHk342Aumax8
	pb7rdoYUYzcQ1ceohx9VsWaqLgQjbOePxPVVjY2INFWqx0h1d/sdGK8X+CFe7PsS821PX4=
X-Google-Smtp-Source: AGHT+IErmY1RR8fLs/bjJFbgpDgfaRvZSMUD/4PW+5SFPA4YPh9Oztw0aeecX5CGguWN8QnEuPIYiNSwbHCoOiZhZkw=
X-Received: by 2002:aa7:cc89:0:b0:649:8aa1:e524 with SMTP id
 4fb4d7f45d1cf-6507c4c2e60mr538a12.11.1767637540797; Mon, 05 Jan 2026 10:25:40
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251230205948.4094097-1-seanjc@google.com>
In-Reply-To: <20251230205948.4094097-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 5 Jan 2026 10:25:27 -0800
X-Gm-Features: AQt7F2qPUCLxZZdRMopKqbpIrNbx1KXa_BXaN9XOn7WdSE3_SLKOsBzEV1b-iKI
Message-ID: <CALMp9eTmHs4k7_iiCb16u96whZFdW-Mckw2mL2WRtDag15256g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Return "unsupported" instead of "invalid" on
 access to unsupported PV MSR
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025 at 12:59=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Return KVM_MSR_RET_UNSUPPORTED instead of '1' (which for all intents and
> purposes means "invalid") when rejecting accesses to KVM PV MSRs to adher=
e
> to KVM's ABI of allowing host reads and writes of '0' to MSRs that are
> advertised to userspace via KVM_GET_MSR_INDEX_LIST, even if the vCPU mode=
l
> doesn't support the MSR.
>
> E.g. running a QEMU VM with
>
>   -cpu host,-kvmclock,kvm-pv-enforce-cpuid
>
> yields:
>
>   qemu: error: failed to set MSR 0x12 to 0x0
>   qemu: target/i386/kvm/kvm.c:3301: kvm_buf_set_msrs:
>         Assertion `ret =3D=3D cpu->kvm_msr_buf->nmsrs' failed.
>
> Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in gu=
est's CPUID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

