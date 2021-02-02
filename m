Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353AC30CF37
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhBBWlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:41:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234135AbhBBWlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:41:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B6AC64F68;
        Tue,  2 Feb 2021 22:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612305667;
        bh=bhanN5du/Uw41D7LIvrjljn0saroYLL1UQvTM6/jgbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Og8kB+9e7Ji7BlPRG6CvYKz2egn/yVSkw4NGkZrtfVG34MN5wnyFsA5yAgpDdyDYZ
         g2iJdr6bpJujA/f84vmSZ0eNmYbBCYwFuCBoWM7b+6cLkyjogWHQERjfrq2bfzWIs/
         DqLZ5w+ONdss2lzqXJxAiNpjILD2/GEktKJURiGBNsuSPM82eSGHmrCMjA1Da9zNjY
         rSkGpjRQixSDiQ1V9DaTwhxLgSuSnaYrPeRjlL7/JlZLk/SXkcNhK7LNsaEJo5iiS3
         Rt8tSQfEoOMWA0gA4jNMSuTkfQKQMfSqg3k1TwSW++D33F7ivedqYaJ/BWUitgJCFj
         yNzB51EV83BcQ==
Date:   Wed, 3 Feb 2021 00:41:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v3 16/27] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YBnU/PZzKHkOIdW1@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d32ab375be78315e3bc2540f2a741859637abcb0.1611634586.git.kai.huang@intel.com>
 <YBV0nnqUHnING5qA@kernel.org>
 <20210201133259.e0398c9f0b229fd79a8c16c6@intel.com>
 <YBmK2lt/5r/+HrAO@kernel.org>
 <20210203082340.e808a4d97318e07b265d0326@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203082340.e808a4d97318e07b265d0326@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 08:23:40AM +1300, Kai Huang wrote:
> On Tue, 2 Feb 2021 19:24:42 +0200 Jarkko Sakkinen wrote:
> > On Mon, Feb 01, 2021 at 01:32:59PM +1300, Kai Huang wrote:
> > > On Sat, 30 Jan 2021 17:00:46 +0200 Jarkko Sakkinen wrote:
> > > > On Tue, Jan 26, 2021 at 10:31:37PM +1300, Kai Huang wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > 
> > > > > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > > > > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > > > > bits 15:0, and single-bit modifiers in bits 31:16.
> > > > > 
> > > > > Historically, KVM has only had to worry about handling the "failed
> > > > > VM-Entry" modifier, which could only be set in very specific flows and
> > > > > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > > > > bit was a somewhat viable approach.  But even with only a single bit to
> > > > > worry about, KVM has had several bugs related to comparing a basic exit
> > > > > reason against the full exit reason store in vcpu_vmx.
> > > > > 
> > > > > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > 
> > BTW, SGX is not an upcoming CPU feature.
> 
> Probably Sean was implying: "Upcoming CPU features that will be supported by
> Linux". I don't see big deal here.
> 
> > 
> > Also, broadly speaking of upcoming features is not right thing to do.
> > Better just to scope this down SGX. Theoretically upcoming CPU features
> > can do pretty much anything. This is change is first and foremost done
> > for SGX.
> > 
> > > > > be set on more or less any VM-Exit, as opposed to the significantly more
> > > > > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > > > > flows isn't scalable.  Tracking exit reason in a union forces code to
> > > > > explicitly choose between consuming the full exit reason and the basic
> > > > > exit, and is a convenient way to document and access the modifiers.
> > > > 
> > > > I *believe* that the change is correct but I dropped in the last paragraph
> > > > - most likely only because of lack of expertise in this area.
> > > > 
> > > > I ask the most basic question: why SGX will add new modifier bits?
> > > 
> > > Not 100% sure about your question. Assuming you are asking SGX hardware
> > > behavior, SGX architecture adds a new modifier bit (27) to Exit Reason, similar
> > > to new #PF.SGX bit. 
> > > 
> > > Please refer to SDM Volume 3, Chapter 27.2.1 Basic VM-Exit Information.
> > > 
> > > Sean's commit msg already provides significant motivation of the change in this
> > > patch.
> > 
> > Just describe why SGX requires this. That's all.
> 
> This patch is to change vmexit info from u32 to union, because at least one
> additional modifier is going to be added, due to SGX. So the motivation of this
> patch is the fact that "one or more additional modifier bits will be added",
> and SGX is just example. 
> 
> So I don't think adding too much SGX backgroud in *THIS* patch is needed.
> And another patch: 
> 
> [RFC PATCH v3 21/27] KVM: VMX: Add basic handling of VM-Exit from SGX enclave
> 
> already has enough information of "why new modifier bit is aadded for SGX".
> Sean also replied to you. 

Well it comes after this patch. So you either need to provide the context
here or reorder patches. If latter is impossible, I would just add those
couple of paragraphs that Sean wrote.

> Please look at that patch and see whether it satisfies you.

Well there needs to be causality in patches. I should be able to review
the patches if 17-> did not exist.


> 
> > 
> > /Jarkko
> 

/Jarkko
