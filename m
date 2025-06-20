Return-Path: <kvm+bounces-50061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3997AE1A6E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EACD1BC549B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 12:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541A428A40F;
	Fri, 20 Jun 2025 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ujt8Qewu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FAE28AB03
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 12:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750421038; cv=none; b=gFHUqQdOmo/aQnJaDr2WB0r7O+OPJLi3lpIeeGZ1MOYS3AEBmW9ZsOvf/P4LVHF5HuuOCTtw/DU4iFhz8vBs+nUvaz8QOemm4k0E4nBX9Os0AYSEust+7RLx42ymCR/dtgKPm/w2R83AiryAMKhZKFvHFRkgbnIm/7wM5PUfI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750421038; c=relaxed/simple;
	bh=FAqGh+Ap3WVTnB3giMA2j55BTztyBeGG/4uN29HFZ7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iQkZdko45CKQB9jyjRduV5qAj5bKt7AzcAv8C7YOqY3uM618G7mHGJrb1vDTbsFROC2OyBY2aKO6PtR1mt88dsFz61EZUoq8SAFAVmEDrYJdJ7oLlhMQJW8QvT6IDJwKPaPuIQFP67uKgjKlsgOi1rlfjV8ojr2+IlxWXfdgTMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ujt8Qewu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750421035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hRiX5hP6eSsbI68Jfq5YDPv8YMSSHRs8HbY7Wk8t+xQ=;
	b=Ujt8QewusR5fNh9opkVqJtAvJJQBCF8Ktr2QxeO5ehgsFhtkt6ir/7aa2Z+NlvcyUGT+38
	bsXxldvqygnISK4Yl/u7l9o8lRHkehZhLUsb7R8jSe28LFnEboa+d5bMJk/npEfdrH0s+h
	TWGczfxXnN9fA1kKuNPFCOFE4y3V1GM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-qXXqihO1NTec5N7QxN_YaQ-1; Fri, 20 Jun 2025 08:03:54 -0400
X-MC-Unique: qXXqihO1NTec5N7QxN_YaQ-1
X-Mimecast-MFC-AGG-ID: qXXqihO1NTec5N7QxN_YaQ_1750421034
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a37a0d1005so1069919f8f.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 05:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750421033; x=1751025833;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hRiX5hP6eSsbI68Jfq5YDPv8YMSSHRs8HbY7Wk8t+xQ=;
        b=aRVlmzIs0HxCsCTEU/KubXW7mCmrNBt69fBY1DvK6ePeWzRPCMger91t3Bp0GGEKf2
         Cy9t5PLkhSmdCXwM0vwNKrU+4E8I/uNQ2uUVVFFlHAf8S+osIx2ttoh0bvdk62XZ+acb
         mZZKlLIfFd10ktyMC9NHgPCNZ08+uJB7GohOqR185WOOXAOVG7VsJL0AKJo1Y60DAC7z
         LidiSa1uWRHeSlqZDw9YTZB3emCTn0C9ev+D5cnstoDIsjyECL2LJRWJ1+5FLwd7Tf8z
         Om4IYrz9UGVH/5JInCexob60sZlQwYKncBLg9bf4/2l8nmiM6mo3vqIqJQtYVc1fXlhG
         6TbA==
X-Forwarded-Encrypted: i=1; AJvYcCUv2e4RBKCkTDHx0cw/WeGXfgNfamosPeViVt1hZLcorPEATpcDeZHdExU79tFeURkDcII=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBLkgDHp3uanI6Q+c/XdTwNQVeB3EyIAR4xs0FAWOx5BUzEdNH
	56BXpEnQS3hwdahDKIQisvZWKW9jUGaN5BChgIPolJC1tKK0ru3z18Hie7I3UxJj5tsz2Glsqkv
	wP4AsgyyhPincl8s5vqPBdFtHICN/YhnzmP91Q99QGhcyYVR5cf99bAdOvlL+jeXDVnCVxrXDWs
	466MAcwYczDw0zA757tOsC1HGrbdiE
X-Gm-Gg: ASbGncu91HRwMi1inSmuMdAgBwigGKcHb8sB88yN0lvtplYbtnzWVAeqylAIy5c8awD
	sTTNm0unng83mNlHgOGkPcdVgJ8+FqrlcUZvRieDSo8r7U0JmgvfwUbTHp/FVWTxTYrapbtb2vJ
	LJZKY=
X-Received: by 2002:a05:6000:2282:b0:3a4:d79a:35a6 with SMTP id ffacd0b85a97d-3a6d12e34b9mr2465542f8f.14.1750421028901;
        Fri, 20 Jun 2025 05:03:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEtw8HSbD5c31bjPnNG3AKWy62fuJMXkjNiI7W5B8OEByPQc05lu178uJKqVYi+04d45VIy1BAwLE5B8oF7v8=
X-Received: by 2002:a05:6000:2282:b0:3a4:d79a:35a6 with SMTP id
 ffacd0b85a97d-3a6d12e34b9mr2465273f8f.14.1750421025914; Fri, 20 Jun 2025
 05:03:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619180159.187358-1-pbonzini@redhat.com> <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
In-Reply-To: <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 Jun 2025 14:03:30 +0200
X-Gm-Features: Ac12FXwlP3mB0d4H_A3QTPM4diBtAL8jRHpn6HbJoT9oX8REYeRb2oG13FSy0CE
Message-ID: <CABgObfaN=tcx=_38HnnPfE0_a+jRdk_UPdZT6rVgCTSNLEuLUw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	"Huang, Kai" <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, reinette.chatre@intel.com, 
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, mikko.ylinen@linux.intel.com, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Il ven 20 giu 2025, 03:30 Xiaoyao Li <xiaoyao.li@intel.com> ha scritto:
>
> On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
> > This is a refresh of Binbin's patches with a change to the userspace
> > API.  I am consolidating everything into a single KVM_EXIT_TDX and
> > adding to the contract that userspace is free to ignore it *except*
> > for having to reenter the guest with KVM_RUN.
> >
> > If in the future this does not work, it should be possible to introduce
> > an opt-in interface.  Hopefully that will not be necessary.
>
> For <GetTdVmCallInfo> exit, I think KVM still needs to report which
> TDVMCALL leaf will exit to userspace, to differentiate between different
> KVMs.


The interface I chose is that KVM always exits, but it initializes the
output values such that userspace can leave them untouched for unknown
TDVMCALLs or unknown leaves. So there is no need for this.

Querying kernel support of other services can be added later, but
unless the GHCI adds more input or output fields to TdVmCallInfo there
is no need to limit the userspace exit to leaf 1.


Paolo

>
> But it's not a must for current <GetQuote> since it exits to userspace
> from day 0. So that we can leave the report interface until KVM needs to
> support user exit of another TDVMCALL leaf.
>
> > Paolo
> >
> > Binbin Wu (3):
> >    KVM: TDX: Add new TDVMCALL status code for unsupported subfuncs
> >    KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
> >    KVM: TDX: Exit to userspace for GetTdVmCallInfo
> >
> >   Documentation/virt/kvm/api.rst    | 62 ++++++++++++++++++++++++-
> >   arch/x86/include/asm/shared/tdx.h |  1 +
> >   arch/x86/kvm/vmx/tdx.c            | 77 ++++++++++++++++++++++++++++---
> >   include/uapi/linux/kvm.h          | 22 +++++++++
> >   4 files changed, 154 insertions(+), 8 deletions(-)
> >
>


