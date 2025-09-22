Return-Path: <kvm+bounces-58390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FDDB923ED
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88A691901EDF
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52A831076D;
	Mon, 22 Sep 2025 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="csBwoL7/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B93112C6
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758558942; cv=none; b=bSkgj6O8qFN+/8q7qkusqqpIUNiEOX4M06r5tKkwPoNPviMIhcEK7umEqTHGh1nStriVXgFKdHuZabYlU3tBFQ2haiFFE+AbtMNhX95Dy1pTc3EjUgcQoX0lp/t15SYMXfLMeaH3KOp/btE9gzQ7mPtQ+XpAwIIZ9a1h5jqx1bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758558942; c=relaxed/simple;
	bh=5vgMcmSa6/stHBv9njEn9/fmRr97vtkLUdC85MjkScI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JU+OKNyNtGDr+F382qlIwDSFtqfdRnC8QtEpliV0KtND/ygv3pMwaViqmN421pAC/4QxT5BIrPL2ypXkvuofxS7vXoLePmD+wi4L5GlnkkAjjw/Ot8WJdFliFCTdJ+wL0TTKBT5drJavqx+k07qkWSnhJENzOjGXtBsQy2YySnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=csBwoL7/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso6289017a91.2
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758558940; x=1759163740; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/L6eoZpM1VPVhp3LcIdJtF+77mJVWtKzfwXAMS2FaZE=;
        b=csBwoL7/a+uoZ8YOTusBF7HHVg3bxgyM/ao+z4BBhVJp/SxZ6FqmXB21fkbIxnHRzZ
         m+FeJuTTmKMNNP6ZP3UJwdFW65Gexzd72OvHov6h9WoiyEIkNxQM/X2C9tnTrzTQjgrc
         hxzD7HDiyWGcIOBrmS8Jy3Jj+qlWZupQqQsCZ+IbqoR/67SxQB/qaBQLTPdjR8DLKqx+
         ufnodQ9LFZd9UXT9PB/Yt+ZBRBHMi40lGkVpMwo6ARrDM/6d3qBwsyBunssimwKEEAA5
         WjLqUmu0WW+EJ80Poqbm3JyDNNVWewfOwoe9pGeVDyoMctVTieddW44hERzndVq/Rt4s
         DlNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758558940; x=1759163740;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/L6eoZpM1VPVhp3LcIdJtF+77mJVWtKzfwXAMS2FaZE=;
        b=D0N1n1/TiR+6FTurF1SrQSyFx970I9Xezh9RJIwksTOY6SOrnkoVIwo5XYxhYXUxI1
         /1rLbGXDVHAv/Sa1lICY0WFH0rZJgvqobcrGeD/XUN0YQMIW4lyuMPsH786EQA2aGHAf
         F/NlFhMMYGtdM0FprwfIOvOFGsBqgwdhc23VgNXLH9Q2S9M9f2uPbW5M90JzCgM6Hnod
         niAltaHYifZMt3jxuOXEtn6uU1cqhI5avHgu7LOdEF0UKoeLhk9opQPtQXX+U1Cs7H9C
         brEW51lSnxSfKTUVKoaME5ymsBdS0+HAJiVDh2eEM9lt1Lwn2tyHeZ8kcMiZ0ukrNoED
         mIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbSYwGDpxk+JagpK8H7o3NtrgSOTaeBPbbJkBtp6BszqyUAXkOpVhIfRtoR3oKbVUue+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRw1zJRjAZMkiIFtg1NBzqEBOv7xsr/GHJ3ZkMqo7IRaaNIy/m
	v2iGAYE4gjILdSH7lGcPWu5f5r0OAaamn1ZXv4P0Nhh/9gDFQt3TzfQv/0tic4PeYdP5Nt2n7Cd
	g406XPw==
X-Google-Smtp-Source: AGHT+IFxZmHXxGe1VF4kRpoNHxCAb/9eKuC/xMhUWpWpUydlcsJ5ERtJaV7+/sSJoOAwKktN1cSskOa7EdE=
X-Received: from pjbqn7.prod.google.com ([2002:a17:90b:3d47:b0:330:49f5:c0b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:288b:b0:330:88d7:961f
 with SMTP id 98e67ed59e1d1-33097ff703fmr17125592a91.14.1758558940555; Mon, 22
 Sep 2025 09:35:40 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:35:39 -0700
In-Reply-To: <4f59ec69-15fd-4463-86c9-17491afd8eca@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-34-seanjc@google.com>
 <4f59ec69-15fd-4463-86c9-17491afd8eca@linux.intel.com>
Message-ID: <aNF62zmnuXTETlKv@google.com>
Subject: Re: [PATCH v16 33/51] KVM: nVMX: Add consistency checks for CET states
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025, Binbin Wu wrote:
> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Is the following simpler?

Yeah.  I was going to say that separating checks in cases like this is some=
times
"better" when each statement deals with different state.  But in this case,=
 SSP
is bundled with S_CET, but not SSP_TBL, and so the whole thing is rather od=
d.

> index a8a421a8e766..17ba37c2bbfc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3102,13 +3102,8 @@ static bool is_l1_noncanonical_address_on_vmexit(u=
64 la, struct vmcs12 *vmcs12)
>=20
> =C2=A0static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u6=
4 ssp, u64 ssp_tbl)
> =C2=A0{
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!kvm_is_valid_u_s_cet(vcpu, s_cet) || !IS=
_ALIGNED(ssp, 4))
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> -
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_noncanonical_msr_address(ssp_tbl, vcpu=
))
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> -
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0return true;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0return (kvm_is_valid_u_s_cet(vcpu, s_cet) && =
IS_ALIGNED(ssp, 4) &&
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!is_noncanonical_=
msr_address(ssp_tbl, vcpu));

Parantheses are unnecessary.

But looking at this again, is_valid_cet_state() is a misleading name.  In i=
solation,
it would be very easy to assume the helper checks _all_ CET state, but that=
's not
the case.  And the other flaw is that the CC() tracepoint won't identify ex=
actly
which check failed.

Completely untested, but assuming I didn't fat-finger something, I'll fixup=
 to
this:

static int nested_vmx_check_cet_state_common(struct kvm_vcpu *vcpu, u64 s_c=
et,
					     u64 ssp, u64 ssp_tbl)
{
	if (CC(!kvm_is_valid_u_s_cet(vcpu, s_cet)) || CC(!IS_ALIGNED(ssp, 4)) ||
	    CC(is_noncanonical_msr_address(ssp_tbl, vcpu)))
		return -EINVAL;

	return 0;
}

