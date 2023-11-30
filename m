Return-Path: <kvm+bounces-2974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B2F37FF512
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C9F31C20E07
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D76F54FAE;
	Thu, 30 Nov 2023 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IuMVeDtU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1836196
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:25:40 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cdc03f9fe9so1302895b3a.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701361540; x=1701966340; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Frsrx8QxJTCbf8WmA7nSYv8M2eurLvDkjduXU5Q/zds=;
        b=IuMVeDtU7LvGDFGw3IOZID4Rka7Bvx233updt39BqroyROkdlwpDUGraDOTY8+l4zi
         QN6XKyZxFs2MEKrBl5x8g7hBbaz4tyI+cYY3Y4JqrfgUMo+p6/U55f4noY2Sdt2VHCdN
         AcBPqgz+DdZNJB8oXwJM0Xk37PXAKGo6uGTj5g70QatRa9X1NKODW76/iekVgmUgyxDs
         zqHDOoOb37cd9+LkNM06CB1Jn38j8k02HeFq3qwu6Oov/AZYrbm2UPccFcVOS1EIANvk
         P88oE0it0w1QGrK0MZEPdklZRXu6k7ujcng97yi8BprN6FOnf+h3nBx0Z39ozkqwCgQY
         VBaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701361540; x=1701966340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Frsrx8QxJTCbf8WmA7nSYv8M2eurLvDkjduXU5Q/zds=;
        b=s527pBXC2t9pDDFUZRvSoFn3gO9FtaOk8jKt9VQs7BOKfkWY56YVDiIqxPjH42jihL
         8VNw0Dofk9nsg1U0g0TnqwRfvInD6sMyUTsIqEV3IxYfAghu9Wh6/WKT+ZSYZTJOReI0
         hgQHql9zbqwE07cVWOMuj/sui02KvEpokgvpdEwsaMv6aDmRBswN5+14bRGaYtSDYk3N
         dJhYCiBIh2W1EU0k/zG7P7O9V5n59v2g4smUNYYXu4vHdWLS9rpB/rAbZrNVJewHB9Ha
         3lVxi4H31/JahUYPyGoOfL1dXUMTyuHly6Y3zhu1I7jpHQgfqD9Wm13+hNqlWVA488x4
         9Tsg==
X-Gm-Message-State: AOJu0Yz/7ushYjeic8wSLPHOB19QqJjlx+6exHaDAUgw2iBFiKo/iDil
	yrgDxhtyXypJMUixNUDC3GQ7JtXSffw=
X-Google-Smtp-Source: AGHT+IGu+c68aXbfWv0Zq9ytnR9R1vz5ds4Tk7HWe8PM6XpfqZSJA6l/qnKx9Z7p0qZCIRdP8IQrTYrKQ8A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:399c:b0:6c0:ec5b:bb2d with SMTP id
 fi28-20020a056a00399c00b006c0ec5bbb2dmr5386707pfb.2.1701361540551; Thu, 30
 Nov 2023 08:25:40 -0800 (PST)
Date: Thu, 30 Nov 2023 08:25:39 -0800
In-Reply-To: <049e4892-fae8-4a1d-a069-70b0bf5ee755@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231007064019.17472-1-likexu@tencent.com> <e4d6c6a5030f49f44febf99ba4c7040938c3c483.camel@redhat.com>
 <53d7caba-8b00-42ab-849a-d8c8d94aea37@gmail.com> <ZTklnN2I3gYjGxVv@google.com>
 <ZTm8dH1GQ3vQtQua@google.com> <049e4892-fae8-4a1d-a069-70b0bf5ee755@gmail.com>
Message-ID: <ZWi3g6Mh9L8Lglxj@google.com>
Subject: Re: [PATCH] KVM: x86/xsave: Remove 'return void' expression for 'void function'
From: Sean Christopherson <seanjc@google.com>
To: Like Xu <like.xu.linux@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Like Xu wrote:
> On 26/10/2023 9:10 am, Sean Christopherson wrote:
> > On Wed, Oct 25, 2023, Sean Christopherson wrote:
> > > On Wed, Oct 25, 2023, Like Xu wrote:
> > > > Emm, did we miss this little fix ?
> > > 
> > > No, I have it earmarked, it's just not a priority because it doesn't truly fix
> > > anything.  Though I suppose it probably makes to apply it for 6.8, waiting one
> > > more day to send PULL requests to Paolo isn't a problem.
> > 
> > Heh, when I tried to apply this I got reminded of why I held it for later.  I
> > want to apply it to kvm-x86/misc, but that's based on ~6.6-rc2 (plus a few KVM
> > patches), i.e. doesn't have the "buggy" commit.  I don't want to rebase "misc",
> > nor do I want to create a branch and PULL request for a single trivial commit.
> > 
> > So for logistical reasons, I'm not going apply this right away, but I will make
> > sure it gets into v6.7.
> 
> Thanks, and a similar pattern occurs with these functions:
> 
>  'write_register_operand'
>  'account_shadowed'
>  'unaccount_shadowed'
>  'mtrr_lookup_fixed_next'
>  'pre_svm_run'
>  'svm_vcpu_deliver_sipi_vector'
> 
> Although the compiler will do the right thing, use 'return void' expression
> deliberately without grounds for exemption may annoy some CI pipelines.
> 
> If you need more cleanup or a new version to cover all these cases above,
> just let me know.

I'd rather update the CI pipelines to turn off -Wpedantic.  There is zero chance
that -Wpedantic will ever get enabled for kernel builds, the kernel is deliberately
not ISO C compliant.  I have no objection to cleaning up kvm_vcpu_ioctl_x86_get_xsave()
because it's an obvious goof and a recent change, but like checkpatch warnings,
I don't want to go around "fixing" warnings unless they are actively problematic
for humans.

