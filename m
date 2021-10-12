Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D7342A9E0
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 18:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhJLQsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 12:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhJLQsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 12:48:11 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC62C061570
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 09:46:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c29so76821pfp.2
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WxtJ6kTMjB335FQT7eQ0eT+70TQDiMjlEAzZlxMqe30=;
        b=bKOflXsLFzC3VU2LBpYLCOQSqWZeASP6ZYpwtMXyXCQ24DvBTaHGYfF64wgjZDKsla
         LpPBv3FFCMFYsmS+evB4X2EmqUiQKWI7oaGecXjhcm4t10DJpJr2vmOVqhi9jQY9eJXi
         9a6BmBu4332+d7Ju7hIbBp1ZnLa2LGcKGoTyDvfvwICGsr9y4cx2bX3A4DiwdeDSleK6
         ADuM4LSQ5VFYhTx9WO6iia8tKPWVl1qqkwJiMW8Bt/75nqycZwR4exTh/O2RXjV8cMPx
         kBII7YI8Dhm4R3Hr2cD4FnOV4Ddw1flpexyUS8KyOwUiN8m8eaoqUtQ2eqAhi9HeeGkk
         8HoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WxtJ6kTMjB335FQT7eQ0eT+70TQDiMjlEAzZlxMqe30=;
        b=yhTwzbRudH9KoQnYDqSprfpjGcaoCZcq5T7wU3hX2ALjfKpjgX6i+FhWnKN2b9XC6A
         tE+sf4J/wMtUTGXVys/xLslUWIOpAlhf05cTZ3vZ9tAiRoNbcqAP3pec1AnwyBBWUSMs
         rEABAzsxH8sMCR25KTuJMenZN3BxWkWxGdL0MrpViKElKBFlLyaU7vYpvwEIvk+EA4p2
         xlwAKyoLdmHAtTS/rjOD97HtKDURsagaOpw65X+ikwko1DkWHcYNB+e6/0zoRXviqylS
         ykbKZuf0cqXDUKv4U6NFp6VgSJPIztW4/E+rSIWTPDlbyv2SbaLhbzQmn8ZmueACF8L0
         BhKg==
X-Gm-Message-State: AOAM532LHOMxj/KppzAfYn2w1PqfTkXLm29CGupgJgnpko0c12hQ3lgn
        mx11KdnMys3ZcYqvMFvzUi394g==
X-Google-Smtp-Source: ABdhPJwqjQYiIu9GVaeWoRMdEp/IOLk9KZQUl3zIehqyu0N4NWB1pHgyw7wIiEOvLESAmyrDCLnUww==
X-Received: by 2002:a63:564a:: with SMTP id g10mr23601412pgm.199.1634057168886;
        Tue, 12 Oct 2021 09:46:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z19sm11467471pfj.156.2021.10.12.09.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 09:46:08 -0700 (PDT)
Date:   Tue, 12 Oct 2021 16:46:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Atish Patra <Atish.Patra@wdc.com>
Cc:     "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "vincent.chen@sifive.com" <vincent.chen@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] RISC-V: Add SBI HSM extension in KVM
Message-ID: <YWW7zGWUpqXLXE/4@google.com>
References: <20211008032036.2201971-1-atish.patra@wdc.com>
 <20211008032036.2201971-6-atish.patra@wdc.com>
 <YWBdbCNQdikbhhBq@google.com>
 <0383b5cacb25e9dc293d891284df9f4cbc06ee3a.camel@wdc.com>
 <YWRLBknWXjzPnF1w@google.com>
 <a762f0263090d7e818e58873d63139d7b6829d87.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a762f0263090d7e818e58873d63139d7b6829d87.camel@wdc.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021, Atish Patra wrote:
> On Mon, 2021-10-11 at 14:32 +0000, Sean Christopherson wrote:
> > On Mon, Oct 11, 2021, Atish Patra wrote:
> > > On Fri, 2021-10-08 at 15:02 +0000, Sean Christopherson wrote:
> > > > On Thu, Oct 07, 2021, Atish Patra wrote:
> > > > > +       preempt_disable();
> > > > > +       loaded = (vcpu->cpu != -1);
> > > > > +       if (loaded)
> > > > > +               kvm_arch_vcpu_put(vcpu);
> > > > 
> > > > Oof.  Looks like this pattern was taken from arm64. 
> > > 
> > > Yes. This part is similar to arm64 because the same race condition
> > > can
> > > happen in riscv due to save/restore of CSRs during reset.
> > > 
> > > 
> > > > Is there really no better approach to handling this?  I don't see
> > > > anything  in kvm_riscv_reset_vcpu() that will obviously break if the
> > > > vCPU is  loaded.  If the goal is purely to effect a CSR reset via
> > > > kvm_arch_vcpu_load(), then why not just factor out a helper to do
> > > > exactly that?
> > 
> > What about the question here?
> 
> Are you suggesting to factor the csr reset part to a different function?

More or less.  I'm mostly asking why putting the vCPU is necessary.

> > > > >  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> > > > >  {
> > > > > +       /**
> > > > > +        * vcpu with id 0 is the designated boot cpu.
> > > > > +        * Keep all vcpus with non-zero cpu id in power-off
> > > > > state
> > > > > so that they
> > > > > +        * can brought to online using SBI HSM extension.
> > > > > +        */
> > > > > +       if (vcpu->vcpu_idx != 0)
> > > > > +               kvm_riscv_vcpu_power_off(vcpu);
> > > > 
> > > > Why do this in postcreate?
> > > > 
> > > 
> > > Because we need to absolutely sure that the vcpu is created. It is
> > > cleaner in this way rather than doing this here at the end of
> > > kvm_arch_vcpu_create. create_vcpu can also fail after
> > > kvm_arch_vcpu_create returns.
> > 
> > But kvm_riscv_vcpu_power_off() doesn't doesn't anything outside of the
> > vCPU.  It clears vcpu->arch.power_off, makes a request, and kicks the
> > vCPU.  None of that has side effects to anything else in KVM.  If the vCPU
> > isn't created successfully, it gets deleted and nothing ever sees that
> > state change.
> 
> I am assuming that you are suggesting to add this logic at the end of
> the kvm_arch_vcpu_create() instead of kvm_arch_vcpu_postcreate().
> 
> vcpu_idx is assigned after kvm_arch_vcpu_create() returns in the
> kvm_vm_ioctl_create_vcpu. kvm_arch_vcpu_postcreate() is the arch hookup
> after vcpu_idx is assigned.

Ah, it's the consumption of vcpu->vcpu_idx that's problematic.  Thanks!
