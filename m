Return-Path: <kvm+bounces-50594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D0AAE73A8
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 02:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2247167E7E
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D2110942;
	Wed, 25 Jun 2025 00:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="us+62I+r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7D0AD58
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 00:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750810329; cv=none; b=sir0AFTOT2VbSJjRhWGbJ9DK0Rg0ejkc7Qd8B58r478sgPlLe4DNSRpNF5f03n31E10x8z2Yy2a+++L35N5FLZimiKLjrVX4e1WV25wjgsIAHL/X8fqNv2yxo6O3eH8aLGcFZeTiNDELAQ51TRVIrbbPNUnX2WHmjs7T4LZL5u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750810329; c=relaxed/simple;
	bh=4eoSUaocYmaWsmbo5jnksZ2C3rx/pVjA9dIc1SBhIag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a4bvDzAC0FHdhbJgFKixB5wp8YUayoRlR5j5lAf2jMilZyvlni1Hm/s3k7tkreXAmvdOvEvg9Hbko1ETYfCEfrqCHejMcIKSZofo1ohaC9MqvHXD0jy5IfUr4s6qSwVPu0ggc6mRArQBkvswfIerSoSo1tuk9bnZWHq0JPhEHeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=us+62I+r; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-609b169834cso5331a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 17:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750810326; x=1751415126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhThPHLsvNen0jbqs0BDq7omrwoGam4W7cLnmLsm00Q=;
        b=us+62I+r8r9eueggNzLoXt9ykNlfbtLFELP6jjljSUz/GkWLOswVq+AX7b4szSztip
         bBi8QzapgzEBjdSKDB8ivtX+LhDoTi1+n7eckpr/b+PLZFDUS7mU6E0lTy0a4Hl/Dl5h
         cMQ+blbv1q5gWI/Rsq7I+j2lvdPDTdiO2Wj9ZQ9cfJnwCDjhAytIaiC5Xy7/BEY6yWNF
         mQQPguZsqN+1+fxCuGWc3FU1iBqkaXl+8DWR8wk9AFec0wfzlf52mbKL7kTTQp/KjTuz
         oZWiPm5kPrHKd8SjnLtLIQGVDYQpxVCab7HJRggCiiJ/oQVQ3R8w44+8pO52AAC1+0PV
         l9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750810326; x=1751415126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhThPHLsvNen0jbqs0BDq7omrwoGam4W7cLnmLsm00Q=;
        b=A9itVHxYJ5gyEFuG2UiuBHFh5OQ0VPWsgrtvY5vy2uWDPtVWd/00NuWNNiK1bDl5Tk
         CXw6aiGZEht0ZBgSHWUtdOhKlyPOOy/1N5uPIpqCOA4k8gfRN9rXlaFAMnWJz+2m2uAN
         yeCoJgXKxodIg7Rl9uW9VMtE3gdr6iAb8dUgT05LArco6P26gpx0sROo7qCMvUsFSUq0
         VO87Fo7WDcMtYN0X+jrY7VR+Xz+n6dPnh9so3TxK/0d7R+Ux6mfkOVvmZtt/OMeWMACr
         /43dTuuyqbZAhlsU2cBAY13pZLwZ9HL7slgq5BIA12VDV/i+5trEi1Ra6kk2mkHg7Csz
         qgWA==
X-Forwarded-Encrypted: i=1; AJvYcCXSFYU6pnyQ24yOgcHHkixuk6JlAbss3uHMo9rjoTFqRyGCGkAHOswmkNu9vJ9BZvmQLCs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu3OCbJ98yXTrrvKx2MTPzUpCv+KDlAPj/2lYC+lDt/Uh/GqdQ
	Rm7pb4NatXKAo2le4uLDHyA8tBZoUt50t1IfS/WWK+5afpMW9mIzwJruGAmOYt5Xlw7wNA+KgKX
	TPoImZNvhF2dQzgAplZPgVmQTxwsF/wDinaI909eS
X-Gm-Gg: ASbGncsaduUlJEdpUhZT4R6g6RjSPuXEJ59J79v7G8cG3NxRNM0eJ2fZechJfIkjfsG
	zne5VaByh1v/JF0Teo3ItWW6yqsRi8xQYj+uwFiXeXMr0bOKffPCu+ZM2tDIiPp4TAcr6oesLKk
	0vd/8sPmibwJnE0Y5taOBhWom8kfKwH3f4TF4btZs33KRSTHQSxNrUUQ==
X-Google-Smtp-Source: AGHT+IFSOFiLAN3ICey2GAdu0RNYWTKLxB7jGvanJwTfeh4aRq0sUq04sobGMGS0G2nqBQj2terPEeZjtQHCwiw0uro=
X-Received: by 2002:a05:6402:4408:b0:601:f23b:a377 with SMTP id
 4fb4d7f45d1cf-60c4fba5fe9mr11095a12.6.1750810325709; Tue, 24 Jun 2025
 17:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-3-jmattson@google.com>
 <aFs1OL8QybDRUQkF@google.com>
In-Reply-To: <aFs1OL8QybDRUQkF@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 24 Jun 2025 17:11:53 -0700
X-Gm-Features: Ac12FXyF4HyLSGZZxKYDwfWReaDHVxBdd4mVp7eJRLyg4tWKSRBXXXXKbx-1nzI
Message-ID: <CALMp9eTi_8T3Yyz6NYqqmKsgTLYKVz++9qt=2gdoxty40Od5Lw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 4:31=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Question: what do we want to do about nested?  Due to differences between=
 SVM
> and VMX at the time you posted your patches, this series _as posted_ will=
 do
> nested passthrough for SVM, but not VMX (before the MSR rework, SVM auto-=
merged
> bitmaps for all MSRs in svm_direct_access_msrs).
>
> As I've got it locally applied, neither SVM nor VMX will do passthrough t=
o L2.
> I'm leaning toward allowing full passthrough, because (a) it's easy, (b) =
I can't
> think of any reason not to, and (c) SVM's semi-auto-merging logic means w=
e could
> *unintentinally* do full passthrough in the future, in the unlikely event=
 that
> KVM added passthrough support for an MSR in the same chunk as APERF and M=
PERF.

I think full passthrough makes sense.

