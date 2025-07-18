Return-Path: <kvm+bounces-52898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F60AB0A672
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC4131C810F1
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537912DCC04;
	Fri, 18 Jul 2025 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fHfMt9D9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A72DAFD4
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752849417; cv=none; b=h8iTFPCZ5yy58JWnUmjiOubPzxMVntE6oRYdRLOndkZGxJfWlCfQnB14/uEWz3QWd7RsL0pVV/k48/jo7A6Y7SvUZATLc3N6u0THowDHQSwK08WgItOLYrpXgmB/qyL7IsXy7tc0FwJdA0nlMiTU0VRpwkvTWDL+GKe4s+Ae1Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752849417; c=relaxed/simple;
	bh=3QPhCm1sC1C6ig0Iw4HK9wtVB3WXrHJKElM+ObxU4mI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CTXaeI7DeBHm59gmeJGgRHOkrR0k8PpkLOMLTzekV1fVNtA8mYVhA2GqW6JGzPtZdiWOw8cKnhRb6AJcONx8LRf1nbJpvhbhWX7VANhRvgPevqM/4RM7gTsleo11XWXDGJWXubYFaH7059ufAIK8D5UNi/t3GOW2gAmrkT7oPPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fHfMt9D9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311a6b43ed7so1744532a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752849415; x=1753454215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L4B72Imjuaymxf5ffOiaUn+eLcRTliNp0eW0wBJCGUQ=;
        b=fHfMt9D9JHvvGuoU9ojC5r7kVOKutE+V8nBnhSdrLkL99yHuDEkbz/P8+vkCLb3NuW
         rDRoOYZOHctAJrpHFsnKnUtsaCw3qwOf+XDflSdHJqwdbuv+Qq9mvTzQBrNphwCdHb2S
         0XhFP6jUcz/1E/p873TTTzS+PvyLiGpeJlp5llKA+KVaroB1tG1vyY64UOiHsQGi+V9W
         V633z60UMXSMERSmCTHV+ZXU6RZ7fb00Bxd1DSd+EvKWxhfyYSOWxTmLQ7XeIm3HVr21
         Zon10Gis8xKVhdaUwdWfxLd4Lly03NfceJdoyHsLlcs3u8tXmRQdW5RiXiwd5QQAXkiY
         YGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752849415; x=1753454215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L4B72Imjuaymxf5ffOiaUn+eLcRTliNp0eW0wBJCGUQ=;
        b=bp6Df5M5BKjlfSwhaLzsdDGeo/YXt/CwNu7Bqb57yhKEmZXvpQvB4i05s9UORq+UhI
         m43PTIsZb6q+VuJUWFAFE7MqZUr8lNhzpFkj8vB5JYHnAXmy89Frh97iXazis4HTJqP8
         iSz2FI5StPV2EOSGjhPncFkPfHtGd81bf4u6aGWuayaV23rbIBfY6ji0E4ZCcdr/90NA
         uCBXo5oKFwcUI6Ym8w37A5ZwkKSq+3g+weunWwYDJ5KdvvEprcJ2Xxw/u1N6GSlDPRPT
         WN+csG/n8fjA3N2+kt/Reh4d1PWSutNNP4WqNjftnQnnkbK965SwgYyo5e8Zkwkx+SyB
         yBFg==
X-Forwarded-Encrypted: i=1; AJvYcCULLKgPeoPCY0qrOTuULO0nzhlyOTozk8OLF+WWqn+QEJumpOY+cObpGJB18n/GruISq8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqBGSPCrCe4fJGnzFisj1LIjF++0gAXb/STG4LgMnputTbtns6
	Egl7hlYM5mwFKFx/yEx9gEcrWGHNWaYesxkgDmObDOcsiAB7aH4KXgX+86zWbRkzUTXFt5y2VH0
	Q2pV4YQ==
X-Google-Smtp-Source: AGHT+IF4Yl8Dc5A2WffN2qGYpDxuj7spPBIOKATA0701jf+XNLG/uY9qWbBOxGQCfP/tnJZ9i37+DEhUc0c=
X-Received: from pjh6.prod.google.com ([2002:a17:90b:3f86:b0:314:29b4:453])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5385:b0:313:d343:4e09
 with SMTP id 98e67ed59e1d1-31c9f45e1a3mr13104244a91.3.1752849415579; Fri, 18
 Jul 2025 07:36:55 -0700 (PDT)
Date: Fri, 18 Jul 2025 07:36:53 -0700
In-Reply-To: <60d4e55c-2a4f-44b4-9c93-fab97938a19c@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com> <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com> <60d4e55c-2a4f-44b4-9c93-fab97938a19c@suse.com>
Message-ID: <aHpcBYwqhcw14iR1@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, pbonzini@redhat.com, 
	Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, 
	linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Nikolay Borisov wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index f4d4fd5cc6e8..783b1046f6c1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -189,6 +189,8 @@ static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
> >          if (!caps->supported_xfam)
> >                  return -EIO;
> > +       caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM;
> 
> nit: For the sake of consistency make that a |= so that all subsequent
> additions to it will be uniform with the first.

Objection, speculation, your honor.  :-D

That assumes that the predominate pattern will be "|=".  But if we end up with a
collection of capabilities that are unconditionally enumerated by KVM, then I
definitely want to express that as:

	caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM |
			       KVM_TDX_CAP_FANCY_THING_1 |
			       KVM_TDX_CAP_FANCY_THING_2 |
			       KVM_TDX_CAP_FANCY_THING_3;

not as

	caps->supported_caps |= KVM_TDX_CAP_TERMINATE_VM;
	caps->supported_caps |= KVM_TDX_CAP_FANCY_THING1;
	caps->supported_caps |= KVM_TDX_CAP_FANCY_THING2;
	caps->supported_caps |= KVM_TDX_CAP_FANCY_THING3;

I find the former to be much easier to read, and it provides some amount of
defense-in-depth against uninitialized data.  The downside is that if there are
conditional capabilities, then we need to ensure that they are added after the
unconditional set is initialized.  But we absolutely should be able to detect
such bugs via selftests.  And again, I find that this:

	caps->supported_caps = KVM_TDX_CAP_TERMINATE_VM |
			       KVM_TDX_CAP_FANCY_THING_1 |
			       KVM_TDX_CAP_FANCY_THING_2 |
			       KVM_TDX_CAP_FANCY_THING_3;

	if (i_can_has_cheezburger())
		caps->supported_caps |= KVM_TDX_CAP_CHEEZBURGER;

makes it easy to identify which capabilities are unconditional versus those that
are dependent on something else.

