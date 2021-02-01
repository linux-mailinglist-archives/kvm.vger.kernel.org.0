Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96D930AD87
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhBARNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhBARNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:13:35 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D24C061756
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 09:12:55 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w14so12036417pfi.2
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 09:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wnxL/Wu6UUpfOivFYidUIhipJomX5KXsxYVYyO2G8yE=;
        b=TvksATvAc6G2vbTvv9nKkYP7Zkep98KYIP24YvDzKYkbyu3f1/BLkRDiyOYhpNsHha
         BJP9y5tUCKGhHV+IWl0ScrtI/ENwyP+bKqjy6M9JqWRfOconuXxQaE7ZB/vTpnmhXiHp
         Srq+iMBGi1bUosS7lHO8fWomFpJGlBigTOr5jfMNNPRG5LYIAE5IusTxkMmvNuVvRbrw
         92g1x25Nt54IIjLqflBsiaL0rL7UOXWyfY/BbB9ZUIuIipRHvbw2zlOP4++OsywgfNJI
         Bg0AgegGY4lkVIjcSz3CHMWOVcl0WPvr8FstsVnRD8TH7vaz6YsxK5Lf7W9A/xegj4g2
         k5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wnxL/Wu6UUpfOivFYidUIhipJomX5KXsxYVYyO2G8yE=;
        b=roBjTrJDbifgVaBgwNcuO13Ai6rtYu4t9IhDFlfmPBkpsViZbDojepHQBcNK/JgAHX
         i7pSP7GcyYA7zQtUgnlYmb1vJ/2lkxQ3BfWWpseTxGah/qKvdncoaur2u6k5Lc74ltkl
         INgdKwurf0mZOpWz4JDYKHCaalF//z1xSdJtBjM0UU7tWv/QmpV4Sn53kkJgs+REr3q3
         UsCsa47yYQCgJje2DKmv9tVuNwVCoEserubyzvT+k6Eem4U5qsH0x5u9M5OE9D/gO2bT
         rqLOM8c/JAJZT+Z+aJPNzsE6t416xwSYidA+bfZu+A/ZCKJ1npklN7BXt9d2igaHmWgm
         19mQ==
X-Gm-Message-State: AOAM533oTxREkDXT6aS54Zv3L+gniuvOM7kZiEl9Lv4BsFRCv4/8IkC7
        tO16YL+A6kQXzAl5hBs3mdpHEw==
X-Google-Smtp-Source: ABdhPJzlfjcr/RNlVEJ1zibUwiriHwtPa4v2J/8gXajIL0KidyItWMtVCNTTgzXCBnNWe+XYqm30Gg==
X-Received: by 2002:a62:18c5:0:b029:1bd:e72c:b4f2 with SMTP id 188-20020a6218c50000b02901bde72cb4f2mr17341052pfy.50.1612199574825;
        Mon, 01 Feb 2021 09:12:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:829:fccd:80d7:796f])
        by smtp.gmail.com with ESMTPSA id i62sm18397083pfe.84.2021.02.01.09.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:12:54 -0800 (PST)
Date:   Mon, 1 Feb 2021 09:12:47 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v3 16/27] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YBg2j45w2IIUlZ0V@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d32ab375be78315e3bc2540f2a741859637abcb0.1611634586.git.kai.huang@intel.com>
 <YBV0nnqUHnING5qA@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBV0nnqUHnING5qA@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 30, 2021, Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2021 at 10:31:37PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > bits 15:0, and single-bit modifiers in bits 31:16.
> > 
> > Historically, KVM has only had to worry about handling the "failed
> > VM-Entry" modifier, which could only be set in very specific flows and
> > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > bit was a somewhat viable approach.  But even with only a single bit to
> > worry about, KVM has had several bugs related to comparing a basic exit
> > reason against the full exit reason store in vcpu_vmx.
> > 
> > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > be set on more or less any VM-Exit, as opposed to the significantly more
> > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > flows isn't scalable.  Tracking exit reason in a union forces code to
> > explicitly choose between consuming the full exit reason and the basic
> > exit, and is a convenient way to document and access the modifiers.
> 
> I *believe* that the change is correct but I dropped in the last paragraph
> - most likely only because of lack of expertise in this area.
> 
> I ask the most basic question: why SGX will add new modifier bits?

Register state is loaded with synthetic state and/or trampoline state on VM-Exit
from enclaves.  For all intents and purposes, emulation and other VMM/hypervisor
behavior that accesses vCPU state is impossible.  E.g. on a #UD VM-Exit, RIP
will point at the AEP; emulating would emulate some random instruction in the
untrusted runtime, not the instruction that faulted.

Hardware sets the "exit from enclave" modifier flag so that the VMM can try and
do something moderately sane, e.g. inject a #UD into the guest instead of
attempting to emulate random instructions.
