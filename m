Return-Path: <kvm+bounces-61995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D40F9C3269A
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92CBB3BFA3A
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9C333BBD5;
	Tue,  4 Nov 2025 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q5ejbdnz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA312236FD
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278348; cv=none; b=RPhFrtYR8UKfe4xWeiL8s17Srip/xgdvG4QJoMz8V7ywJgba6IDhw38OdGN2u22u53M0ANLo+YJACQCLNS9a9P4ZrZN4FziDE7V3OiDUmxvcvwHJ0wak9XVfISbQb0bgHO1+IvshuO13lp1qnGLAmfT1Qv/t0prBT9QsoJIOZ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278348; c=relaxed/simple;
	bh=fBHyh4lKIxCTDwgTRfUUKt+kE22zWmOu/3V7EgwlniA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EK4tBIxLagROSgBgAtni+H87MI2gHsLxuy7SQoFs/LtLmvN3SESnUS3tdEu+l1BelAk7G1QFnTJtU1yfRz/qE/4aAuz9HNPlS+ro+8PXrD/PwfKR9cyYGWxVgvVU0Fd6ohY23w0HqNzYx223jOu5Jo/4z0VjgTktbMjjSO5gbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q5ejbdnz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295592eb5dbso37747775ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762278346; x=1762883146; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2Tu+KDxGtSxrgMOAtFN7Npf0pEh0K0jTPtmg/yHZME=;
        b=Q5ejbdnzUOrnHgCmMCXEFHE9cUiTEDbXDTOWPZ3ci2FekhA4EGVsdr5KWIR/BykTSm
         6SPtfL7RKxU7TFljCfVuA9S8JMERtGPCJO/pfxUo0zcyb9hPSOOixx59gcYzF8veh9ah
         vjvqKo36n8CyuVMcr8tBWs/jhNdJ0UQGwfHbfznwprli/Suv6zex7BP8a+iUJVC78tX7
         0GioS563uUbIMAhgUNy8Uzk6w3ujBKXqkrwq6G7ESfGigsu3CjCsrlvbpXVJhwKaDOtY
         /JWOOWtQrQBpjT+S3G8dV9V9wlHn+7xRb8JxYX6FMYsIfIvME/D0nLFcQq5hyUHzJvbI
         xAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278346; x=1762883146;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z2Tu+KDxGtSxrgMOAtFN7Npf0pEh0K0jTPtmg/yHZME=;
        b=IXmfFVqF1OEe2QbQhY5yEJHdPpyxrTHDt+J/Zizounm7nqdgXJFD+xEsk4cggT08tN
         QITmG/O7UC54GCCoZS1QLjXg2Eb38PK1ed5w1ZkngSRFLnqv0uoEDBLYFk14/WdJOHjG
         ZTXGKV1iQ7QClVzYeLvvFjc0devFUnBz++uJShbimWZkWcsrTHj4fwnNzkF4sXtPBFcv
         IC8Hz9bp4gaevZbBJIyeiiSKa+q0ePssDRi0suVFMncmTWmw6c86IaYuRDyZ8fBedac3
         YuqwUT8X1ewqN578scdcW0Usj8YTnTx2zoIp2dtAkWkT6tpG6kULiCfRncCiORWN9HoT
         TYZw==
X-Forwarded-Encrypted: i=1; AJvYcCWFmQRy6IPutl86+CR8qxX3pTh+SDghJgwlWLIwzwrQ/8OPIYX6Qe/67mb/HhQ7y/amBEY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9Mth4iGiKGTK3sOiIp65+WQnBsOO5sDBQP4GAzqjGoVTK7v0O
	X2U2BX/OIU7cqtccDHYZu5rVoXG0cChAwisLkpdd0IEENi0Jm2JISykZYc91G3ERp1Cj+G8FPZX
	DoYx7qg==
X-Google-Smtp-Source: AGHT+IFv3dUrYmn1lVlBlYev0eg/cf2TWmxof3SNenYFyvB6TqMDKe0rrPAkSHQAlVHpWcI5k2MtUqf2+Ns=
X-Received: from plrq15.prod.google.com ([2002:a17:902:b10f:b0:295:5948:f5d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3d0f:b0:252:50ad:4e6f
 with SMTP id d9443c01a7336-2962ade2bccmr5238175ad.54.1762278346475; Tue, 04
 Nov 2025 09:45:46 -0800 (PST)
Date: Tue,  4 Nov 2025 09:44:56 -0800
In-Reply-To: <20251028060142.29830-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028060142.29830-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.51.2.1006.ga50a493c49-goog
Message-ID: <176227794159.3934184.6943075964127868106.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Call out MSR_IA32_S_CET is not handled by XSAVES
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Oct 2025 23:01:41 -0700, Chao Gao wrote:
> Update the comment above is_xstate_managed_msr() to note that
> MSR_IA32_S_CET isn't saved/restored by XSAVES/XRSTORS.
>=20
> MSR_IA32_S_CET isn't part of CET_U/S state as the SDM states:
>   The register state used by Control-Flow Enforcement Technology (CET)
>   comprises the two 64-bit MSRs (IA32_U_CET and IA32_PL3_SSP) that manage
>   CET when CPL =3D 3 (CET_U state); and the three 64-bit MSRs
>   (IA32_PL0_SSP=E2=80=93IA32_PL2_SSP) that manage CET when CPL < 3 (CET_S=
 state).
>=20
> [...]

Applied to kvm-x86 fixes, with an opportunistic tweak of the comment (the w=
hole
spiel about the safety was attached to the wrong function).  Thanks!

[1/1] KVM: x86: Call out MSR_IA32_S_CET is not handled by XSAVES
      https://github.com/kvm-x86/linux/commit/cab4098be418

--
https://github.com/kvm-x86/linux/tree/next

