Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D147F3F238C
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbhHSXQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 19:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbhHSXQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 19:16:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3351C061756
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 16:15:34 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u15so4833533plg.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SJ68uCCulu7vBqyA3mzbB52oQ65OuytKFW+IpmZC5sQ=;
        b=rTTcOqAjjfAgKr+F7AUFDVFvPIfVkA2BGSUEnCMtnClOm+hYOknuS/WYfKen1c+r/K
         8k782+SrBC7Kk8//Cx2aKPxDZYazP0UGPgRZyiuVMbN67GJNnKVQiVMmHz1qDxq/2Ibj
         CCj//SU/biqBAFQc5hNkmbwdrSSXB0gIu7V75V0MoVC8zM36s7huED8QWawQEV5Thcny
         zIIniAiXfX3B67i5f5YsZTVU/AMHGvm2VZc0/OHufUmex5/L8poNQpUPRE55vGAXBg8B
         XTkXKTYeeOir5hjXQCGyOtWpVY4ZxbEdcTz+fZ25SrFk+WDsidYd9d+N1G6sy5eDEVzs
         ru/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SJ68uCCulu7vBqyA3mzbB52oQ65OuytKFW+IpmZC5sQ=;
        b=T+Ye2Z3qRpES2HetyBiObetoDQe8I4Nyai4sEwXHSM37tB+MzZnXov7O3nSiEkNt3a
         9Cgs6DMQZLAYwolOhVDOhYYWuFCByTJWX95BNztFIOb9gBp3jQJWChkDFhxcFYlB7utl
         Mq3xDiJA8ACpt3mzd1sVqagzcVxwNP5Svk7vujCeLvlsEKjhHkBvJZFv0pm6HuYgIVMa
         4xMXPpkpujQGVnx5107jDSSmzbJQklFZMKi7L7GuX/+ngmIS15LlJeye6G1SjNplC8iH
         h01RbElZUdEwcSLtoJqPW+ByREd2xIFJDS1Xb3tC53gf14Qz6ggayz2Izt9INNG3O8q2
         Hu8g==
X-Gm-Message-State: AOAM532yf1T0bkuRQ7vsUuz6GK3PlxilNA7+dyHBf9kKx6bmShNOh2XV
        KEMucJfDdTCXMMUDhkxyVIjIpw==
X-Google-Smtp-Source: ABdhPJwdoKU7fDLCRXuSfBBXcZ3gJWJBLplBh+PNmJCsycoF5Td4O0ZdSjZ74ZnXCx4HQh/d+36KlA==
X-Received: by 2002:a17:90a:b88:: with SMTP id 8mr1303060pjr.12.1629414933160;
        Thu, 19 Aug 2021 16:15:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w11sm5081987pgk.34.2021.08.19.16.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 16:15:32 -0700 (PDT)
Date:   Thu, 19 Aug 2021 23:15:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH v3 2/5] KVM: x86: invert KVM_HYPERCALL to default to
 VMMCALL
Message-ID: <YR7mDlxJyVkSkCbO@google.com>
References: <cover.1623174621.git.ashish.kalra@amd.com>
 <f45c503fad62c899473b5a6fd0f2085208d6dfaf.1623174621.git.ashish.kalra@amd.com>
 <YR7C56Yc+Qd256P6@google.com>
 <B184FCFE-BDC8-4124-B5B8-B271BA89CE06@amd.com>
 <ED74106C-ECBB-4FA1-83F9-49ED9FB35019@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED74106C-ECBB-4FA1-83F9-49ED9FB35019@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, Kalra, Ashish wrote:
> 
> > On Aug 20, 2021, at 3:38 AM, Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
> > I think it makes more sense to stick to the original approach/patch, i.e.,
> > introducing a new private hypercall interface like kvm_sev_hypercall3() and
> > let early paravirtualized kernel code invoke this private hypercall
> > interface wherever required.

I don't like the idea of duplicating code just because the problem is tricky to
solve.  Right now it's just one function, but it could balloon to multiple in
the future.  Plus there's always the possibility of a new, pre-alternatives
kvm_hypercall() being added in generic code, at which point using an SEV-specific
variant gets even uglier.

> > This helps avoiding Intel CPUs taking unnecessary #UDs and also avoid using
> > hacks as below.
> > 
> > TDX code can introduce similar private hypercall interface for their early
> > para virtualized kernel code if required.
> 
> Actually, if we are using this kvm_sev_hypercall3() and not modifying
> KVM_HYPERCALL() then Intel CPUs avoid unnecessary #UDs and TDX code does not
> need any new interface. Only early AMD/SEV specific code will use this
> kvm_sev_hypercall3() interface. TDX code will always work with
> KVM_HYPERCALL().

Even if VMCALL is the default, i.e. not patched in, VMCALL it will #VE on TDX.
In other words, VMCALL isn't really any better than VMMCALL, TDX will need to do
something clever either way.
