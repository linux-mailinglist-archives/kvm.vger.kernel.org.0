Return-Path: <kvm+bounces-59741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26211BCB21E
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B1083BBF7F
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07F6286D76;
	Thu,  9 Oct 2025 22:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7y0mR3B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107E283CB0
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049856; cv=none; b=WTD8DJ4KwzzfCyeMlFngZ8nYedY8zwhG/K2vtxt36P3wSH0rFamQV6A7me8RMGjRgaqEIHn9nWB/eqcVIIBCPkT+xVWSSuHDpc/gUjyukfVsy00KdnYzfY+3v0wMkYWzfRGbiFiUlFUzIE3Ylz6VipTl9lL77hp94uBF2Iyi9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049856; c=relaxed/simple;
	bh=/ZQV7MCAtGcsYl1ytfZ6Hxd7JHW+2Q4tq8mrY8dcDm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pzfOZt3Sy7T0Tmk4QzqB4lqGOraNP30fG8HLj7DYsr8pk/Bfxle58/nJTnok1SVaCfGK2rxRZHEZ3Q98QlxMog6Qw9GmNEqjXfh1W2yUBIMc6/uaxVWwlfdPY4SWBAWU1QVxRC6/0EDdi7kYlLYYK+NaeBjAR8cCrveAFnZHzhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7y0mR3B; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso1985a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049853; x=1760654653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZQV7MCAtGcsYl1ytfZ6Hxd7JHW+2Q4tq8mrY8dcDm8=;
        b=d7y0mR3B6B0A9xv/8aItygjU2qaio3rD73URwheajADdbyJclvtW3DWTq3aVoov+1+
         IMMUvfFFHEedHlhYR/GuCrLCRc4ICoOgU6WpSr6zHgcWsZ84Zfm25txcImNrZH5C+dnW
         y6delvjZTItIP3m33kcJeCA2j57utWumQ9WQQh0Lshgaxw4fZQlkQJa8L6Z4noYnWO7o
         bdG+0Iti9PwoHWOvWpPv73GSpEMrw4o24Q2oXSkkU/zXqckXO9plG66mu23YJzPGnTkG
         OxZo5y4sqiF5Z1sbz7/byKYuFGwEH14vsfLPiIHXHQyVYABbZoLHB3Rb9b0Q7lUqWEqm
         +8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049853; x=1760654653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZQV7MCAtGcsYl1ytfZ6Hxd7JHW+2Q4tq8mrY8dcDm8=;
        b=PSY6iVyRyHyE4+zsIF5QRzq6w/0KNFDmK7rWbV/b4LrGavQO4ihdJXBL55TjAwZ8UL
         9YYZbtIHnyWujzLoCJ8WUOS3W0L6utNoNM47gG1dcbLnHVNKODLp/vXMFRJ6LMiKx8CO
         pfLB2CcC9L72veblkCJpMB2nPDVu/05xrY8oQUwVRfcx2k5Z3OxFWmpQaNSHE9ibyRHe
         VygymcGIT2FLUERb2YaH3o5rOmqLlc2pZQSXO66hc6tJfeap8cxjFvzVAnoiC+QqTIe/
         ktpPTE7MkdXOc7qmcj43btutDAqV7wqIr+QtombYDqloxA8/npxRT7NuPgE16Fx6+L4Z
         Sqig==
X-Forwarded-Encrypted: i=1; AJvYcCU2sMP8TVTRq+5dk4ogUSDxQlObp+OdAEK2Ap0Iy+TMnzFgBZFtFxCBI8SBNuenaGEBmy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSPIJkzjUIgdpI2WVaDyR7SvJejWnrPw9mv+OIOxKSdWwFwn/1
	evFZkeUDdvHPwqKyx8FqWYgt+LB+8fTqZVqiB/HdP1Vd7Dv+x1C/RKx5+m0lj1kL6c+ZhQycR4y
	gEV7ZX11Chs2NR/Okbnjhp0NUeg5i/IQEMosCdhVi
X-Gm-Gg: ASbGncsPQFCQRj9c122yR/lrNcUvMFDg+79u5i7smAxLJPFHC1BNN3b4GzMzOinv3WM
	gQqRap18mByH7V/9qlzMt+19nlkxKIgTR0JIj0k0xytYqsGkWcT4WW9xln8Jq5VIr9oOIJSmcaQ
	CSqiz5/owDq10RpUvIxixeHH0QJa4h3XNseWIsEQG0jxuyUwLHxM2bYt2iSkEXFDMy6XtQS61FS
	OK94QryKKRIuJRyg1ohOESeIjKV/ONbwJVrjg==
X-Google-Smtp-Source: AGHT+IEnFMZwLjS7zK4kzP+SLlOtqLFUsfvGqhS92wvgvhipMcxe/qc+nU5JiV4CuYZnk+5YoAH4Vp1mN3TSa86Oi6k=
X-Received: by 2002:a05:6402:6c1:b0:639:da2b:69de with SMTP id
 4fb4d7f45d1cf-639da2b6b6dmr279914a12.3.1760049852720; Thu, 09 Oct 2025
 15:44:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-4-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Oct 2025 15:44:00 -0700
X-Gm-Features: AS18NWAHeekPlDWhplvq5MC0GC5HvwXC-Om8NTx83NXyQCIW4DVqCcUZA_gr-so
Message-ID: <CALMp9eRN-4ndzDo1oBexmPfv1rJORfqO=kxKVJeX7De1H8BZBQ@mail.gmail.com>
Subject: Re: [PATCH 03/12] KVM: selftests: Extend vmx_close_while_nested_test
 to cover SVM
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:01=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Add SVM L1 code to run the nested guest, and allow the test to run with
> SVM as well as VMX.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Reviewed-by: Jim Mattson <jmattson@google.com>

