Return-Path: <kvm+bounces-803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D607E2A2E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C2F01C20C67
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3726E2941E;
	Mon,  6 Nov 2023 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jq2+XEWi"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3320179B8
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:45:53 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152BF125
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 08:45:52 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d86dac81f8fso5649271276.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 08:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699289151; x=1699893951; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aOiMdoM502S2KW47u+OJd6KgkJY8UT00qBsOiFWsPPc=;
        b=Jq2+XEWiyUJsJPCSRmHnk6MACYI4JIuS5Vr4/gGLw8fHmEfcHMboDCmaOIWmGC2nkG
         6qQ0NWu5zkYAivmwzlyfHaXjHmT4jJsj+JjTKahBVYh9llYVINU2o+OrIQx4ZOa9ounk
         mV8+v3mtAttKhxqaE0xfR4sDr54NPKoREA1a3OTuYJp0Y5TaO6a5aLQ+IPgJ80Lz8YFf
         Zf7+lVl45jtEJfTb+Kc3ql0513p0jc6kp7I7y6AS/c8EJmHhGIuyf0rc1WzqL6swOZzX
         MWMlE5gzQ3agyruVHSA9GoasLJK5L46lsjVbTxLRvAHw37+JYIMJIJYHnsuJtWZBy2f6
         jH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699289151; x=1699893951;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOiMdoM502S2KW47u+OJd6KgkJY8UT00qBsOiFWsPPc=;
        b=E9QXGM/QPbVp8NnjN++AgYG9I2SMkXCRZzb/H69ToDiFsmGTLkVlMxZcy3p1V0GOIw
         lS2xGjXFSfIf6o2sRaG/un1+uTRkoUhR6Lwep08kMpewW/GbjBrpsrmJfqPtKTx/SisJ
         lFWq5Zbou9pXA0HQxhyLNPy8AqfN4B20yinCyHLgIvQcjNSS3661KHEg9OPQM1TBikBk
         U3t66Nl1n8w/fYtfkUUU36yzDQX6TX8pE+UIic11a/2OdpPqkiblzZDxVD4hY/w0goxo
         lGQ8cdNZ9refs8ce7yZGJJm5Mntx27EmVgec+y8XJoJ8AhEaUxVXJ0oXhcywLEtP6NlW
         g92Q==
X-Gm-Message-State: AOJu0YyH76J+rR7aAzldNt5Qqx7VtPHxZ/NwlDTpxPYe/0zbVn5+cMOp
	kPZqaxMzc8VOrhAlcZs+jPmD96ACzwI=
X-Google-Smtp-Source: AGHT+IGzgx6Xrns9ibInxlOaaTlB1HMfvVJO1aF0Ilz0hUdWqLLXikJDl0rzl1f3edD8+cyAQV+3hR8QkVw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c789:0:b0:d9a:c218:8177 with SMTP id
 w131-20020a25c789000000b00d9ac2188177mr514830ybe.8.1699289151328; Mon, 06 Nov
 2023 08:45:51 -0800 (PST)
Date: Mon, 6 Nov 2023 08:45:49 -0800
In-Reply-To: <874ae0019fb33784520270db7d5213af0d42290d.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231010200220.897953-1-john.allen@amd.com> <20231010200220.897953-4-john.allen@amd.com>
 <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com> <ZS7PubpX4k/LXGNq@johallen-workstation>
 <c65817b0-7fa6-7c0b-6423-5f33062c9665@amd.com> <874ae0019fb33784520270db7d5213af0d42290d.camel@redhat.com>
Message-ID: <ZUkYPfxHmMZB03iv@google.com>
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: nikunj@amd.com, John Allen <john.allen@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, weijiang.yang@intel.com, 
	rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com, 
	bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> On Wed, 2023-10-18 at 16:57 +0530, Nikunj A. Dadhania wrote:
> > On 10/17/2023 11:47 PM, John Allen wrote:
> > In that case, intercept should be cleared from the very beginning.
> > 
> > +	{ .index = MSR_IA32_PL0_SSP,                    .always = true },
> > +	{ .index = MSR_IA32_PL1_SSP,                    .always = true },
> > +	{ .index = MSR_IA32_PL2_SSP,                    .always = true },
> > +	{ .index = MSR_IA32_PL3_SSP,                    .always = true },
> 
> .always is only true when a MSR is *always* passed through. CET msrs are only
> passed through when CET is supported.
> 
> Therefore I don't expect that we ever add another msr to this list which has
> .always = true.
> 
> In fact the .always = True for X86_64 arch msrs like MSR_GS_BASE/MSR_FS_BASE
> and such is not 100% correct too - when we start a VM which doesn't have
> cpuid bit X86_FEATURE_LM, these msrs should not exist and I think that we
> have a kvm unit test that fails because of this on 32 bit but I didn't bother
> yet to fix it.
> 
> .always probably needs to be dropped completely.

FWIW, I have a half-baked series to clean up SVM's MSR interception code and
converge the SVM and VMX APIs.  E.g. set_msr_interception_bitmap()'s inverted
polarity confuses me every time I look at its usage.

I can hunt down the branch if someone plans on tackling this code.

