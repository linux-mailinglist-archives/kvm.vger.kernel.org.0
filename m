Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903673C760D
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 20:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGMSDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhGMSDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 14:03:00 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34104C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 11:00:10 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y4so19797349pgl.10
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 11:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aUnwvzo3iJx64EYOs36puVhqp9GJq4422krM2Lg28ME=;
        b=pjVheK0zx5si1i4Eb9s5pegJG0OMW2zAHJpyCgDLb3LtX1Y7fa51g9Hemt6Z6DEA5B
         /v76+1atkf1zQ5aFPBUpsRPz4HjJE18d79Q9YlRKj+0UqcQZGM03XgHRrRVstC4n+XGK
         peZGo/WocfT+2+8SfvpxTmo0BK7901uovyMvl6KIoctAtLEwmSpwggDxYZB/t5AVbTl+
         E3DdQVUj6GjNNZv/AQv/mAKC9HxWGhq05FTWUtldVgs0FJcRm6GnPuC3x74hJINiQ1PY
         3mKUU2TNNxzBC3hfT8L+AZiQNftgYjcHD2fpY/H9+04lDIbk7rS3HLa8DSoPWZFDOEjv
         Nzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aUnwvzo3iJx64EYOs36puVhqp9GJq4422krM2Lg28ME=;
        b=q0DUGwxRBBbOWccUYiO4L0bIe9p6A4aOZVc5fTOT4GlVNTXQhuTJGQ80mb3KB95gka
         PAKoRD6p0PPeUoDi0IZi8sXhPcyQMCGBOjunwiMh0vi4SISFe1ee+N79wQFCGSRq0WGY
         I4Hu6gWFrwMfL8ic+c0Kd0dLijqXCgvm86HKlIOS6GN2UxFuEQ1Pw3rV1JV0LxfqfPPR
         LcEdPWQnnDaZ9Ogi4QaxkZjp70INA+equnRFDNx6eaxeTiDUqXFm3sFdZZtfufttS6NV
         yaf9mEtIwvAgcL2JXs7/vLLpTeKneQg8kasuD5yL5w+k4dzrf6eKYTev0Ub3FOGN8Mev
         OP0A==
X-Gm-Message-State: AOAM5325yOJqZfQ8fqsIczIbHaI5qqO6FND52BVNG84/LfKqfr3M18wr
        nLlusXo2m9aRlVFalmfUNFsm+A==
X-Google-Smtp-Source: ABdhPJxaQxbHMgMZVyJ0E5PG31fBCaX18MkwNLy14FTMd4q9lNqBvbMwHOSOurSVNYYmXu/IIpynaA==
X-Received: by 2002:a62:3045:0:b029:32b:880f:c03a with SMTP id w66-20020a6230450000b029032b880fc03amr5884323pfw.22.1626199209362;
        Tue, 13 Jul 2021 11:00:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 133sm21494711pfx.39.2021.07.13.11.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 11:00:08 -0700 (PDT)
Date:   Tue, 13 Jul 2021 18:00:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 03/69] KVM: X86: move out the definition
 vmcs_hdr/vmcs from kvm to x86
Message-ID: <YO3UpbYp1WRycupy@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <62b61eb968f867518aedd98a0753b7fd29958efb.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b61eb968f867518aedd98a0753b7fd29958efb.1625186503.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This is preparation for TDX support.
> 
> Because SEAMCALL instruction requires VMX enabled, it needs to initialize
> struct vmcs and load it before SEAMCALL instruction.[1] [2]  Move out the
> definition of vmcs into a common x86 header, arch/x86/include/asm/vmx.h, so
> that seamloader code can share the same definition.
       ^^^^^^^^^^
       SEAMLDR?

I don't have a strong preference on what we call it, but we should be consistent
in our usage.

Same comments as the first two patches, without seeing the actual SEAMLDR code
it's impossible review this patch.  I certainly have no objection to splitting
up this behemoth, but the series should be self contained (within reason).
