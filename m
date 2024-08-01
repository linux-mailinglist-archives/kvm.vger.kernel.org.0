Return-Path: <kvm+bounces-22925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C010944878
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9CAC28693B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35DD18455D;
	Thu,  1 Aug 2024 09:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NHiTn5Pa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D3B18454C
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504714; cv=none; b=ECiEIQ2nKZiyYpwV8uFoBggsixoFxrD0iWVxcMeEVvg7v1fKnklzDIQQVpZJjsE/jPTqA6ibN2NdTzoimSo29XJbIMRMPdx3BVD9ISjvrYi8eUb1czQUuaPPYHZTKVPqVEyHQwA1XjWHdyth8aYG6xCciZLbjNU5GyC/h1Z1SSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504714; c=relaxed/simple;
	bh=Rijpxav22ULBZ/jbonQFBSqZGbACHb2Ltfu5GqR29ew=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eYBMdH6Zln08pmWKUF/C842AujrG3NAP7bqGt2xjKkmN/qOXqt85HfW/yyzS7vCPm/gp+2Lq2eohZkRKHPBW/3Vm/VcdSMbPQZFm2yZaoOIMElUJchvDW0he4WKgle2RZSHrHQci12kg8Ve9pHA8jCdnam12/1No8keQrfYgs4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NHiTn5Pa; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7aa4ca9d72so848308466b.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722504709; x=1723109509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rijpxav22ULBZ/jbonQFBSqZGbACHb2Ltfu5GqR29ew=;
        b=NHiTn5PaXsFBhGMxXwLqmyIc9iZiaTO8jfKsKgJugmD/MnTo42TLsjTKZyMbvVheXo
         pIC9smJg4It7nEZ4vD33ZNzf/gqF6Kh4GagP1IZo/9KngfsvAC4ZpqqL6oEGvEcNsgUt
         yBQ9lKBxGIYCIKFGg7fNyT1No6REkiBrYJoA0qh0x3qIbIhijfd+vi2seyT3+YEpo/Gp
         tpd2wy+uYkya8YgiC+1x9WU/IQ9Wvqz2JxMGgABklnFDGoHVmI0xUaCJnTaRKEjFeeZ7
         bITpyj35nrOeCN5APWGj/m+pDtX9eRwaxztSw4AaGXZ/oEpt4yo+ov1tm3lOoxYmr8Ec
         Ep7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722504709; x=1723109509;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rijpxav22ULBZ/jbonQFBSqZGbACHb2Ltfu5GqR29ew=;
        b=Sy9kkMB7GqpQuV6vhSRtVnF7MlkRCr/qf0D3iOMAXpZNufVGIwc3l3nStNL/FqC2BT
         0Vjbz4C3tkoelIfUdirC24EeE0TS/yQapq/odBJL5+u86pgTHv1x+uyfGADoDwJfwPe9
         NlRhQS7TrhRMfBRVyOE+QVy1LXMC4e+vzHYq+PyHYN+O16aOpTf/dUV58zBrF79W4SWL
         k2Rp8zLOQdyAHXUx3pTMrnJoE6ojDWsPP/vVHHM6xUjcfknt4bAzbcGyFgrbwjP63xch
         GaHTXM6KjQYPwaXsLYWR+D3k0obW52k1FbQHfIam9M58PBWpyGeZhdvFg3iuthL5lLX8
         oXtg==
X-Forwarded-Encrypted: i=1; AJvYcCVONBgNDsIUItGhUniome1O+T9tHhrp+NmiXKi35KBIREqrvJq+L7BjvCfvXXGExfIy22/nqA6yN0rNcmhUcMPbonN4
X-Gm-Message-State: AOJu0YwYfI64/qj12h2fUlxbaRrpV+nlj8V/pFrI7HqiG0Bp3Q2ER5j9
	lV5y0bhYDgvy4KXSemZZ+IjawZL+R6Ur7e4qQWiQsXEP9sfkNcjE0hV1T6sZztY=
X-Google-Smtp-Source: AGHT+IG5iXbqJIGCb3pyknIex0iMsjWXZk5BqBH1pB4+wqA2VBzM+EI5zwQ/R0bb0H5+cKiu5+pmpA==
X-Received: by 2002:a17:907:968b:b0:a77:cdaa:88ab with SMTP id a640c23a62f3a-a7daf544a4fmr161420366b.15.1722504708836;
        Thu, 01 Aug 2024 02:31:48 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acadb8313sm876290366b.211.2024.08.01.02.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 02:31:47 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5DD7F5F80C;
	Thu,  1 Aug 2024 10:31:46 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 12/84] KVM: Drop @atomic param from gfn=>pfn and
 hva=>pfn APIs
In-Reply-To: <20240726235234.228822-13-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:21 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-13-seanjc@google.com>
Date: Thu, 01 Aug 2024 10:31:46 +0100
Message-ID: <87plqseghp.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Drop @atomic from the myriad "to_pfn" APIs now that all callers pass
> "false".
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

