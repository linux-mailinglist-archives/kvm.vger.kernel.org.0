Return-Path: <kvm+bounces-24969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 325B395D9E5
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEECF282FAF
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90091C93A8;
	Fri, 23 Aug 2024 23:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CiJBDbj2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15A219342B
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457239; cv=none; b=ZRiXPB2r9yLdPCP/SU1+jzaK7e4YGkVX4+Ys+KT5VQ/cJ9SGCSaALEYcfFGDnjyH7GyUAFpUf8m3loUmJNp6H5zEPfhmlGUIBs5KrhIlSCjRuX2Z2z3dRNqT6rrMXG7phxTCGmB4d6WPgTstf0qyhiq06Vh+FSjwj4J5eJCbRSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457239; c=relaxed/simple;
	bh=MKneRBQTzCIgssX/p97R99LtroMtvOBaD8srJhLeCEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=UjlWVJznTu1wNJoCR2NI11iRM1fSVQ2IJYEZv5jR5sLyyAHYa5zXQpnrNIfB971W3ivLeQ41hhmg03RgMR3VEQsppuloSlKBNDIFeiNz1nH+fTkOf2cFT4trKeiW+7F/ws5uehG2n8eN8d/zvraV6gakXrlPM4g8ejUdRxHDhJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CiJBDbj2; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc58790766so26328775ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457237; x=1725062037; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXU2cuvVzWrgYoc/bA9uWcfYRw4nNpdCvs2896qOp7w=;
        b=CiJBDbj2bsE6FVlddxL44ZO8kwJ4GDpy++h6O8JKR3IH4oiGgWr2fQPbD6DJHXmnpl
         uX0SKmb2N53T85u786YprxPaQwEDkv+rHQf+XKYvkHvg2T09uv+g7ukmNDJ8S6qTCcwh
         Yz1JSFOYyhjgaqyx+Z59gC4yRHOuJBFAdRvM1GMDuAnitBpMqrT5go2Fr7Vak+nLh7tZ
         7RiyyI0bXZe0URbLKIs8msRWIyeqAD0sTtxLvQg8glnn6iHNLrrvsYeeYfVsC/bi0g7o
         sTHLfC46DKEB5M9izXaTI2regUpqjFc6FsIEFgzSIPvgGF5uWEWSN6/IZEue4L8DxcQd
         WtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457237; x=1725062037;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXU2cuvVzWrgYoc/bA9uWcfYRw4nNpdCvs2896qOp7w=;
        b=UKPwnepYv0IhWLFnzqwrM2Hi9tbEU7ps/7s02iS9fewWuDO02voSOr8V7gPiqsdZi1
         Fek7lrYZlZvkBqDlO15th7XdKp/hTTYccMHZbDAyYpX+c6gWNCFLsTt1aoSiPE6ZS2tp
         VWBtter+r7VB7XG0tJi/bdj3/Hu2TI1jNZBtbsd3TR4IgZ0tRVUsowix3zqBfSbj7OGs
         lHbWclxQzkXhOqRlT4NjJRW37ZSvuVqx9yMsGgG0TV/U3nTKU90DhVOc77CnWo4PwcB/
         sklbkAL27om00b7KhWBheFSCvgWBJRJVqRtO1YGRmp1rwtTyURWlQgnvf7CFcWzF56RD
         WagQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy1Up6bhPQeUYoNqKgGCIeM4ukxbOiq84nkR/Yq4Uj5qnoSNoN4id3iECm59bVdvuR2gk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzamKTnfQGEQEGSXIEZwO5IEM0oq7y1Rsi2XZmUoUBXMJrtWZzE
	wR115AWSjk6nFO/mfMeVj4B6LPGfbl4zqXFZfBHuWGkEidIexWvUfZ9d3AoxG14phcwpJEu2d/1
	pcg==
X-Google-Smtp-Source: AGHT+IHAEPzX+BN6KvbiPTwJtlMABD+dkzCNtBcOdKPySXycmiTxUEsTgGTt3KR04s+OXTfJCRLGWKhI1vA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fc8b:b0:1fb:f03:8935 with SMTP id
 d9443c01a7336-2039e6747f8mr816435ad.7.1724457236803; Fri, 23 Aug 2024
 16:53:56 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:47:45 -0700
In-Reply-To: <87zfp96ojk.wl-me@linux.beauty>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <87zfp96ojk.wl-me@linux.beauty>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <172443891288.4129548.9684153677258951771.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Use this_cpu_ptr() in kvm_user_return_msr_cpu_online
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Li Chen <me@linux.beauty>
Content-Type: text/plain; charset="utf-8"

On Mon, 19 Aug 2024 13:59:27 +0800, Li Chen wrote:
> Use this_cpu_ptr() instead of open coding the equivalent in
> kvm_user_return_msr_cpu_online.
> 
> 

Applied to kvm-x86 misc, thanks!  I'm quite annoyed with myself that I missed
that one when sending the patch for commit 15e1c3d65975 ("KVM: x86: Use
this_cpu_ptr() instead of per_cpu_ptr(smp_processor_id())").

[1/1] KVM: x86: Use this_cpu_ptr() in kvm_user_return_msr_cpu_online
      https://github.com/kvm-x86/linux/commit/e0183a42e3bc

--
https://github.com/kvm-x86/linux/tree/next

