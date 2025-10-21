Return-Path: <kvm+bounces-60722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AADA2BF9112
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38438583BB0
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320D12BE04F;
	Tue, 21 Oct 2025 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YhTJyNZ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9659429D265
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086246; cv=none; b=mpnoUCZmE4pmJu9ldXnCBhKoXep3tMiD8wVXFByApmRriL7EXrNAxJan3wYl0FGNBHPvoa/1ysUK7SrcW1BMQqEAfCU5Gy3qMUQka8CBcJMIEeUwspKXinBwGEgdeqigRLt0YhXdy+Qfs4nGHM0/oVo4iG2fd+Rh+A/tsglhm4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086246; c=relaxed/simple;
	bh=HCABZ0fSb2gwncRmR9GNGsqNXHTK6LESdR3hiZ/zCTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KRqMwF9EHsZ0kVkpWMkc4oKYc6y+lw7ycof9VRXftbuRFg4+He6ND5Ngocz1ScKRttjRXCf5AzIkSjz5BnnLS9KU0F0OZQaMT7UqQS/rNTCq/FJmZrgUe+oJOdr4H26DRkdV+H/ZkPhmZMSoyEio9BA4fx9y1QfuV3SgrspQAwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YhTJyNZ0; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-63c2b48c201so2194a12.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761086243; x=1761691043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wd0nSui/IVY+78Jp/2L3ftVcgcNhuYZhu3p7Z3L7toc=;
        b=YhTJyNZ0jovG+khcIo5bCGupsDXJARvqx0MWiRDEy8WlEyFEt5F/lToIjHMxyPZmMw
         YgcfuX5k6p7/o3ey0qhV7YVn2dzRhuHFFCZYyzAn7UTYOJr598yDc3BVJPJp/qqKQ8D+
         zNLJZSWZsJ/f2D0igwLVNd4m+FihnK+AHuC8qkTBmsiW4f4rRvmDr+d3YuQv5tyPe1Xq
         ls1MKrChNyPDf2uxWEqWQeBvG9ifgVAkHU0dPEEsFZmzrYLuQgerxwFHtHSaU6SgoRB6
         ae4QiPHVWQGMSYVuyTiZtHd982v2gejckLhW9YVyGD5zvw8VI6+kklt4iwDEmjl3//Sn
         eP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761086243; x=1761691043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wd0nSui/IVY+78Jp/2L3ftVcgcNhuYZhu3p7Z3L7toc=;
        b=SyXbgPEs9g/E+XumL027Q0Q1fMgXwqf28f3O0MaLO/eqL/vcOTesGY/0YwffWCOGT3
         ANNybOqbp/ZpO6oOvm87F/qq0hzg8/rbCuHfxMcsKB06lCjy6GMIh6yyfAzf1U0uGtRe
         a+PRouYiHAVT2UQNCrys3crP7EPWPLbcC+Rs1edO1eSCnRupbasLfC4DJDr4I+zKV8OX
         iBE6YcdW/ScSaYsbO870TgFTSRup1m7pacBVKrApCufHSsfzsqPEBfMCpyshPmx2WcDT
         JG2YUNS3zzzWBRJMbFWoNj7NnfWup/lsm22xyfvg3x0quESFubkJkxp5bpj5CESfbhO5
         KbsA==
X-Forwarded-Encrypted: i=1; AJvYcCXybgsJGmeyS7m2bYm0KL4OvcjBNzAhnY3JXDpi/R+HxWFcTxI9rMECmiJYjPNLx5c43yo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqxfhX1/Ep9kVssO6pYynDKAlP/H6gxzd0gKclsr/H5ut2y/y4
	ExyMXV9iB4x3TNAZS5PIkEa8/i+rIwHZ0OKyUleWYpeLN7O5hJo4UBok/DQmMKmo9s7zD3liHh1
	FiSNl+7jWPuAV5LK7sPcBlIBN7MOzwVMfFrQDpT64
X-Gm-Gg: ASbGnctv0FnaaBMvjF4/uwzNuCJuyEecFr34nv7nalpwlnSlL8RD0Hr4gG0ae7pZs5n
	zPMkZN3KZYvrtu1sAb264fKuXQsAs1Yl9ErGMoswm2oOrJDb+9rV4sVFigtz/1FN0JP7dshGpj2
	WuYmQShRmVDZTna+UVGb+JlRxE/gVFY0S0g2hsB214ufv3ngqeAUfjZN4r1BbzTtPZkZ1Q2mZDm
	9x48MiOxrb9qTN7xDUCb0eVIXo8p197ZrHF8y55dE/BkYohiwVT1Va/PK4QoD47L6mLcYg=
X-Google-Smtp-Source: AGHT+IEInvFD+rNulexjDzzfxJhwDPmWVBfA30UjD5rmIsAKo7gUu1vHuokzwbQl+cd4r3IddtU+c3F0TtmyKxvdsVM=
X-Received: by 2002:aa7:da47:0:b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-63e1970aba1mr33610a12.6.1761086242750; Tue, 21 Oct 2025
 15:37:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917215031.2567566-1-jmattson@google.com> <20250917215031.2567566-4-jmattson@google.com>
 <aPAnWWmo555uB0-H@google.com> <aPA-60vV0WQUCmc2@google.com>
In-Reply-To: <aPA-60vV0WQUCmc2@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 21 Oct 2025 15:37:10 -0700
X-Gm-Features: AS18NWBZoStzmHUAyoYpMbkWywDCeuQ7pVI5QsF3xxQE_nerMPa41G1gJLfsWo0
Message-ID: <CALMp9eQ3VdsNVb73BfaL5=2z=W+8-3O5Nv=ucmK2D+_zKWbyxw@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Add VM_MODE_PXXV57_4K VM mode
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 5:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Oct 15, 2025, Sean Christopherson wrote:
> > On Wed, Sep 17, 2025, Jim Mattson wrote:
> > > Add a new VM mode, VM_MODE_PXXV57_4K, to support tests that require
> > > 5-level paging on x86. This mode sets up a 57-bit virtual address
> > > space and sets CR4.LA57 in the guest.
>
> Thinking about this more, unless it's _really_ painful, e.g. because test=
s assume
> 4-level paging or 48-bit non-canonical address, I would rather turn VM_MO=
DE_PXXV48_4K
> into VM_MODE_PXXVXX_4K and have ____vm_create() create the "maximal" VM. =
 That
> way tests don't need to go out of their way just to use 5-level paging, e=
.g. a
> "TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_LA57))" is all that is needed.  It =
will also
> gives quite a bit of coverage for free, e.g. that save/restore works with=
 and
> without 5-level paging (contrived example, but you get the point).
>
> The NONCANONICAL #define works for LA57, so hopefully making tests play n=
ice with
> LA57 is straightforward?

I will see what I can do. :)

