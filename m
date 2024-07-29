Return-Path: <kvm+bounces-22514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE6393F977
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 17:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BF2F1C22250
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FEA1155CB8;
	Mon, 29 Jul 2024 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mXlt8W1W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0FC13BC3F
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722267067; cv=none; b=kgGbSdKXnQ8YibyKFYtbDjtn5RCh0zLVYhoNNq1JHUC1CgiZnnbe+aQ0APoEimjP2B62dEq5eddjmQl5dkaGlWAANhGwRQQu5C04F42I9WTu9xuFi3u+/b3ci9AoHk9Zwxi9Mo5d6STVPNU3VPO/6p4cYCdLXaUdP0OMPwuBe4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722267067; c=relaxed/simple;
	bh=QxwcKzX7wljivpzQMsXQIorYU1Ba9o0hvcoSR6EVI8A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LBbjc6BhgXrCNa9D3T5KEyxqbe4OWN2NqEOvup9bf3xR462Bq0jjshgQtHa5vJKDKDbqyqqggjyd7z0a40ZoxiHLXZqfew12JCPu1MJuznIXTaBF8xKEvsROjzahWMJi/GdUDr+ToBADfD29lBalyIHEajpISrQffBDKJXrv4to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mXlt8W1W; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b39c429a1so4011947276.0
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 08:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722267065; x=1722871865; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fnJGLb7UkCkWxw+38nu6Nu4IE9q5Mel5J5PRzG0GI80=;
        b=mXlt8W1W6Lm81hqmr5R95NX686ZJDdzleU8K1l8ybTT8irxzsbHmLBUQHaDmTwTSSy
         /4/MepMhENOfWhjrh/bWncIL359/THUlc0z9CB+daI5vxPJi8ycVmtQO/lZLIwkQDb0X
         UD+E4k7AxGtrgyywGIhy6nKzG27NXLVF4ulTWARd9CyZxU3IjI/cuOPHZ3pAS3P6oXCP
         f7beaAkWqXbuE1XvY+EpwngUz5l1aVDSebKot0qbNdVRyB/nIhZyoUZsbYL2HFqwuwbX
         D87rTnW3Tp4ROKeCqvPZXWmOlewlPor39cMe/gcg6wjpEhorjkqIIhDgN4IIc4xzXYXE
         VKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722267065; x=1722871865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnJGLb7UkCkWxw+38nu6Nu4IE9q5Mel5J5PRzG0GI80=;
        b=AsESOP6ncpkDycTU/NF+sQGJhD052lD4oQ5DYzKzLBVDiH7nrnsFsr31xnzolJ6TCx
         H8kpbqArCntAXf66DxnSpiYs1Aaq5Zaj+cTKsG119fXYI2/myaeDm+OjQ8Zn+uOjNlLv
         er9VCd32VdHafkRNQoGv8eP/HnlN/qqJQssGJm+Ng/5nT98C3HW1HcdRrxCpIM9x4+xT
         KvG2M6WBSW97Qupu4hjr3XAOSu6A5NvOp4nJPt41aspjJQ5jEiyy6Kya/LTiPBHVXtvz
         gfSR3/CPjh3sXC70UB/Onn9Ked/WeVSDTQHi1V2oI/oL03kjs+xz29D4q4YvHqz1jnZz
         khMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqfcU5ykIi8z8tdSi7AWiEP7z+Ga+X0obEENfmcMCbV93mEFUHjLz1Z5TSMZpTAZu2sj+AC8XM9IHuIXQtSvjLVaTv
X-Gm-Message-State: AOJu0YwL5065l7wvxJZXTYfmskCwc7bZEyZ9etWpPV14ZAK4zt+Y76sp
	M0ECq7r7MhuUh5ln78uDuK0iqZIzRrk02XSiXZVWtYK064L1nJxywvj77evXAdcd/PxfdWoycze
	c1w==
X-Google-Smtp-Source: AGHT+IGUv5cQAvOwm2KmbR/i5UzKfyfX7KmkVHNSC8c9t8oOjmo+yoPkIPIh+MeLHstjLauBIJTZIJS0ckE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1549:b0:e05:eccb:95dc with SMTP id
 3f1490d57ef6-e0b5445f558mr125287276.6.1722267064763; Mon, 29 Jul 2024
 08:31:04 -0700 (PDT)
Date: Mon, 29 Jul 2024 08:31:03 -0700
In-Reply-To: <b999afeb588eb75d990891855bc6d58861968f23.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240624012016.46133-1-flyingpeng@tencent.com>
 <171961453123.238606.1528286693480959202.b4-ty@google.com> <b999afeb588eb75d990891855bc6d58861968f23.camel@intel.com>
Message-ID: <Zqe1t_tc8LWNv39J@google.com>
Subject: Re: [PATCH] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for
 temporary variables
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"flyingpenghao@gmail.com" <flyingpenghao@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"flyingpeng@tencent.com" <flyingpeng@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jun 29, 2024, Kai Huang wrote:
> On Fri, 2024-06-28 at 15:55 -0700, Sean Christopherson wrote:
> > On Mon, 24 Jun 2024 09:20:16 +0800, flyingpenghao@gmail.com wrote:
> > > Some variables allocated in kvm_arch_vcpu_ioctl are released when
> > > the function exits, so there is no need to set GFP_KERNEL_ACCOUNT.
> > 
> > Applied to kvm-x86 misc, thanks!
> > 
> > [1/1] KVM: X86: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables
> >       https://github.com/kvm-x86/linux/commit/dd103407ca31
> > 
> > --
> > https://github.com/kvm-x86/linux/tree/next
> > 
> 
> Hi Sean,

Sorry, lost this at the bottom of my inbox.

> I thought we should use _ACCOUNT even for temporary variables.

Heh, that's what I thought too.

[*] https://lore.kernel.org/all/c0122f66-f428-417e-a360-b25fc0f154a0@p183

