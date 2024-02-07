Return-Path: <kvm+bounces-8277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D310D84D1C0
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 19:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FCDA284E9B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 18:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3489686157;
	Wed,  7 Feb 2024 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wh1Xw5M7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F2586144
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707331514; cv=none; b=h7C+U0/2kjYgkjUmiivSMESea5HQ3kZt7Yh00+512slx29me25UKwPGZ+fJwC7aqmx/0pMoz0Pdhu27Ix6yF4FWOPYUGT6RrvIms8BzMtVdAdsKUleezQSlc5Ii2zD/yht7WiTUBBk/b7dMJkr2XyXF8QKIKivEP53inR/GOnXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707331514; c=relaxed/simple;
	bh=rB6Ec3p7AhKSA+4vWbIWmOnRXzrkeuPKLZuukgZZEB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fIxwpOM2otQJc5Ah2zbAKCY0aECrtzRQk61lSin0EzW7r9yUmwd15znZtEAjtJypNe07BRK0wYmkxAUKnqihzKRfH5aGRSnHICttKizUkIgu9QPu/IAfbkpOq/zZa8IbgWS1Ob1g65USIKuokF0xGUy86BZa7WW3irwZ1D0PJZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wh1Xw5M7; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-59a8b9b327aso336408eaf.2
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 10:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707331512; x=1707936312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/ClBNBLoP9L3DooA9dVRQXDTvqkKaBQDDYFzsdwXvU=;
        b=Wh1Xw5M7EdyZeUvD2PBM+WeFhljIwB9hopPLSu5J8rbWgUo/1lkcthd8keKIHpXtfP
         e6EGecwzi+VCd0wu08YNhzdeMuDO2IF/HXAQvTkgZgw8n4Br0kgznLaShdgOidLseYN9
         9Va70SuMpf5xTTG2tl6iwC8S1OdeDH/8lLp0QmOm+58ps2aPQqolaQyeJxYwM/qOvItR
         a+Mk0evpyHD6QKTk2JFkoujo8wqW2bYgqZbBwhZ8ji4u0LXF2cZtccp34wxjo3sQ7h9Y
         g3bhTMf+RbIiSi+/x6X/eLeLnamGNK8VxNs3g/9rBvzVD/D+p62cd1x7o6j7wYg2hYV3
         tmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707331512; x=1707936312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/ClBNBLoP9L3DooA9dVRQXDTvqkKaBQDDYFzsdwXvU=;
        b=SkEmOU0SKNWhEGJqJoWBrXtB+yWbKql70C8f46ayM4h4bmgpdsCbUi38V/J4mK9hcY
         7Av5gXvY/KL3CnLY3VpNsE4NdtyN75xZSJcLgGPtuo7EayUYn97b1j4qc6jTiEz7Sz3x
         V3Ej1N9hK+XEcvgdjhFIW8LJzEzgALcrz3cWawXbQWZvDvN0P/S/K0Eb0//3TtctVLjo
         uFRFMlz7RVrtpQk/P1Ka7wSSW7ajSC6Nf7KMj7B8CCGRek0MgdwIUds+vOGI1Kv7wKlb
         fSY66k/nfhqSocvMxhJz4knfmdT0E4RbUc5tnZy5AC8xKMkWJlwkzav4kjRKRK0u6nwE
         sGSA==
X-Gm-Message-State: AOJu0Yw3yY18MqxqXmxoDS6/bEzXit4lBfnhpEq7L1POyTDmHuVWT69L
	Mp+AZ8fgpeP7zwp0gJRqBJ4nMeFUQ6HkAlq5LWSsexMVheutn0iNmy2/NWNHfpKWFUZs32NXixI
	FXJlIJ8Vm+bULN9NDYzSNjsta9v4RtQ+ZXxlDRSb/FwE2114avQ==
X-Google-Smtp-Source: AGHT+IFr75SrPnd63j+W0s/lOHj2a8WzH7MkXgPW3MqyBgjBBBpINO6XePXGPl2a+oNRSfCWUuFBSWROkh2x3mJJ2OQ=
X-Received: by 2002:a4a:9c8b:0:b0:593:f906:614f with SMTP id
 z11-20020a4a9c8b000000b00593f906614fmr7576755ooj.4.1707331511783; Wed, 07 Feb
 2024 10:45:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-2-amoorthy@google.com>
 <ZcOhM5wPguyNC0j5@google.com>
In-Reply-To: <ZcOhM5wPguyNC0j5@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 7 Feb 2024 10:44:34 -0800
Message-ID: <CAF7b7mrfn5jbDQpDf4_0_1vtMq8YS9mo4MpUK1wKuxgQ328rBA@mail.gmail.com>
Subject: Re: [PATCH v6 01/14] KVM: Documentation: Clarify meaning of
 hva_to_pfn()'s 'atomic' parameter
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 7:26=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> This is not a Documentation change.  The comment might make its way to ge=
nerated
> docs, but this is not Documentation/ and I most definitely did not expect=
 a change
> to kvm_main.c based on the scope.

Whoops, didn't realize that Documentation: carried that specific
meaning- thanks for letting me know

