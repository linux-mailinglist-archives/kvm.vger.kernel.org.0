Return-Path: <kvm+bounces-30953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD2A9BEF81
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 151A71F23871
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE61A201018;
	Wed,  6 Nov 2024 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="krTkBLMu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFF717DFF2
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 13:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730901263; cv=none; b=G46K49vq3IvkSYEp3wJ3UTM4WVYskTzhk8kKwrGVDgdU2Dr0IanFCPGfnCQ9ETmWlwP6N8/5m82vDp2/aEcpjW/7cMce3mJglwQEaj8nPemx21gVqPGNi1WTA928YEVMnwHZe2/kPDEH+cyBTMF8ZPoB+Ip1Q2j4D4FuSwwpipQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730901263; c=relaxed/simple;
	bh=JQBIHPmPJN2CvTRqnCyvMz01lP1GgryuaD6L7iVuScA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TnZT9eODYmQRnx3GYn52rr0g5PMKr8joOh6QS0fqcvfB8GfF9vpe8nXghJmporrFNXx9NnOwlxMQy6rspbJQmcKqdUeUcQ45BNaR95wb1gnMfND/r2m+oWVVZxXDWxaad1x5DAoLKxgbDHTvRlvxtLz4t/OrS3lTikl6Rnq6wvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=krTkBLMu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ed98536f95so734109a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 05:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730901261; x=1731506061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J8Jp5664XXxvLT8kd1+cxeFbBOkGmXp2vl44rKC+LTM=;
        b=krTkBLMu5VD+mVajdNcTuK4by72bU2AaW6UXCjcZ+ZNAVHMakpSzasd6hYTkCVhUYo
         zumbBsZsddSehEOj3kY07orJt7r6UlK9gsadiKU/Rq4TZig0vWD2tR2NwK++i+dyWq8Z
         rU6cHZs0v2/DU8dMhmjUG+6pXqFgSKYW/DO3qN//dJ0taLI9hZE9HAGpIp0HAb1+Lwal
         Jne7CCqKKclzG+D6UVcnTjwZ1kk++rfTA/M4TWWhNM/YJPWuWt6V2rZw9l5VUU7XpEfS
         RSirZCVLWKLmmxbo3+ihC5VnzVL/2lzKI2C1QSUQX6EKvCp6rMR2qvkoqakD4j7kG97u
         IT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730901261; x=1731506061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8Jp5664XXxvLT8kd1+cxeFbBOkGmXp2vl44rKC+LTM=;
        b=arwhzy5xa5amhKeclg/d2QCoSSiSnXmtDPgo+nMq4wlqgnpTTn51SaWvILpSnXKbge
         GVS3DSq0i32YifK3Tv6jbf5+3EeI3FjmVQMmv/Gmn3HiqZ8wSRd3ycW6ZBSaaDm4gnQ8
         bJW6HoHXMOJBgJsB31IdM7uIyLB2beOex+ji8O+3Y2o2b8+yIe+tUosBehzjg+TFPf75
         0KYgaRMMOVcuJcEVwKZxTiyc25BO0BQzB1E7oLxubBhBNr1yhZuwWEWHs7ocDHv8th8u
         /E5EftHj7smU2L8HK6iF8hLplbkYgbSjQ80Cc+1pQOZRvSEX2czQBmCSEGvT+DzPL68Q
         shIA==
X-Forwarded-Encrypted: i=1; AJvYcCVP58uYa7CxRk01Ucm3YtVKg+YcLefumR0/9ttwX4paHImjHkYQ24Qvb6nTOTLKEeppQa0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0bPlUrvEGtPKKlwsTSSkU/uJA+nXV3K0ugpnKSLcCpRY1COXU
	EYp/osT7KgCZYGv1UpO/hDeVhp165OeKLLN66jo2Vmts7h21fhVFefk9pRQ4WC3r0rKDkGPPrpF
	ZAg==
X-Google-Smtp-Source: AGHT+IG0dd6L1RqL0LIJscy8aKUpn6cXn5VoRBJhMyp2MBFEuW/dbIVRXe82qw1RNKHqa1lWIksmKSUAFHo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:1641:0:b0:7ea:8c4c:d07c with SMTP id
 41be03b00d2f7-7f40585a9cbmr26890a12.3.1730901260830; Wed, 06 Nov 2024
 05:54:20 -0800 (PST)
Date: Wed, 6 Nov 2024 05:54:19 -0800
In-Reply-To: <ZytLLD6wbQgNIHuL@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101193532.1817004-1-seanjc@google.com> <Zymk_EaHkk7FPqru@google.com>
 <ZytLLD6wbQgNIHuL@intel.com>
Message-ID: <Zyt1Cw8LT50rMKvf@google.com>
Subject: Re: [PATCH] KVM: x86: Update irr_pending when setting APIC state with
 APICv disabled
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yong He <zhuangel570@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 06, 2024, Chao Gao wrote:
> >Furthermore, in addition to introducing this issue, commit 755c2bf87860 also
> >papered over the underlying bug: KVM doesn't ensure CPUs and devices see APICv
> >as disabled prior to searching the IRR.  Waiting until KVM emulates EOI to update
> >irr_pending works because KVM won't emulate EOI until after refresh_apicv_exec_ctrl(),
> >and because there are plenty of memory barries in between, but leaving irr_pending
> >set is basically hacking around bad ordering, which I _think_ can be fixed by:
> >
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 83fe0a78146f..85d330b56c7e 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -10548,8 +10548,8 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> >                goto out;
> > 
> >        apic->apicv_active = activate;
> >-       kvm_apic_update_apicv(vcpu);
> >        kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
> >+       kvm_apic_update_apicv(vcpu);
> 
> I may miss something important. how does this change ensure CPUs and devices see
> APICv as disabled (thus won't manipulate the vCPU's IRR)? Other CPUs when
> performing IPI virtualization just looks up the PID_table while IOMMU looks up
> the IRTE table. ->refresh_apicv_exec_ctrl() doesn't change any of them.

For Intel, which is a bug (one of many in this area).  AMD does update both.  The
failure Maxim was addressing was on AMD (AVIC), which has many more scenarios where
it needs to be inhibited/disabled.

