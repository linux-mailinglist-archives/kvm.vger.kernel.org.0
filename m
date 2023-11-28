Return-Path: <kvm+bounces-2660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7187FC375
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 19:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAA47282AE5
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 18:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A193D0A5;
	Tue, 28 Nov 2023 18:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sXXfDUci"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C93109
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 10:36:58 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cbe2845ebcso6202532b3a.2
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 10:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701196618; x=1701801418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O91Uupu7339NvmzBM4XpIhItH5W0W9g2NalbW1uqHV0=;
        b=sXXfDUciz3s5t18qTXQqBPK0QRwHfDoXwAHLBU4FEbt76xy1CCyIfzYuINW0OGaZOc
         XPzTg0drGDNmcCFF26U3n0TA3PCX281VYHUlfgar61NIF/yexlnBqzXat2Z5osQMPHzE
         8AGltxMkbm2DKUvdmyFPb10AV1JVK7oMxll17zb3i13DMt/ybgcnaH3sVfBsw47QmkNc
         uH47mDEfMcL/q5d7r8q7bfXf+NOlaJe/mNA1Q38Y2M+60IhIRrenlddv0U/HBxo8gi3j
         bbk6WaNjlp7KxifGRbbyfDWH01VDgjWZudsdj1h+2QshJnUtl7Uy7aNlRy5XbbrroEwt
         zG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701196618; x=1701801418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O91Uupu7339NvmzBM4XpIhItH5W0W9g2NalbW1uqHV0=;
        b=An10aMCGyp5WsZkrrI25Nx0Q++A+I4mFosUnHApqGzz9RejubjjT2uy2MGpgOPTkPQ
         IpyhFdkZclbMT0FYu8jf6rWrZwyFtE6wxjt+mxFPwj4gEMPOLDdaIkJICdd9TlbLZaq4
         7mIVuxQhPxYQEOOqX/J4TaeZbQfALBhksM3pPIN8S+BFCjn5YL348lNH7fHTbouf/N2b
         Rch6cVo3jvrEckPZPm8bb4kQJfxL/SFgSlrMDXQJYaFyuPRbsZ+NgHx3/0UTr8Fog834
         TKCTfKSb/qzxoupHffflViqDEJBwyRqh5JBRrWvwz5Bk+8f6gmgA0QDwS98pdlsZ1CTf
         huHg==
X-Gm-Message-State: AOJu0YyCnxwh64pijXrAT2q3m/SB94Vt7zFihx5RmbIRDFWqlMnjz+1C
	trB5+320eREX9FxLFNfihgmCETQr/MQ=
X-Google-Smtp-Source: AGHT+IHHKYVk1YH4G56UI7cwpbQhbgUXkv7M9X5puoa7iZZH1O4DvGlAXRcA0vIVhRPQPUJ+/0kD/V/tQ/s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1389:b0:6cb:95ab:cf8d with SMTP id
 t9-20020a056a00138900b006cb95abcf8dmr4156728pfg.6.1701196618074; Tue, 28 Nov
 2023 10:36:58 -0800 (PST)
Date: Tue, 28 Nov 2023 10:36:56 -0800
In-Reply-To: <c964b29b08854b2779a75584cf2c3bb1e5ccb26a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107182159.404770-1-seanjc@google.com> <c964b29b08854b2779a75584cf2c3bb1e5ccb26a.camel@redhat.com>
Message-ID: <ZWYzSMWtwDiSFUR1@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix MWAIT error message when guest
 assertion fails
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Nov 19, 2023, Maxim Levitsky wrote:
> On Tue, 2023-11-07 at 10:21 -0800, Sean Christopherson wrote:
> > Print out the test and vector as intended when a guest assert fails an
> > assertion regarding MONITOR/MWAIT faulting.  Unfortunately, the guest
> > printf support doesn't detect such issues at compile-time, so the bug
> > manifests as a confusing error message, e.g. in the most confusing case,
> > the test complains that it got vector "0" instead of expected vector "0".
> > 
> > Fixes: 0f52e4aaa614 ("KVM: selftests: Convert the MONITOR/MWAIT test to use printf guest asserts")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> > index 80aa3d8b18f8..853802641e1e 100644
> > --- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
> > @@ -27,10 +27,12 @@ do {									\
> >  									\
> >  	if (fault_wanted)						\
> >  		__GUEST_ASSERT((vector) == UD_VECTOR,			\
> > -			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", vector); \
> > +			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", \
> > +			       testcase, vector);			\
> >  	else								\
> >  		__GUEST_ASSERT(!(vector),				\
> > -			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", vector); \
> > +			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", \
> > +			       testcase, vector);			\
> >  } while (0)
> >  
> >  static void guest_monitor_wait(int testcase)
> > 
> > base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
> 
> I think that these days the gcc (and llvm likely) support printf annotations,
> and usually complain, we should look at adding these to have a warning in
> such cases.

Huh.  Well now I feel quite stupid for not realizing that's what

	__attribute__((__format__(printf, ...)))

is for.  There's even a handy dandy __printf() macro now.  I'll post a v2 with
the annotations and fixes for all existing violations.

