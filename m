Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4318930D064
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 01:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhBCAny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 19:43:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:54141 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232520AbhBCAnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 19:43:53 -0500
IronPort-SDR: wn9X8LUhOp7DxDA8VP4m09r/UNkcFPODdb1XbO9xuz9p2S5yzozPnzsyvC+q0QImArARiRqQsy
 Uy0nCTqiwysA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160723205"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="160723205"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:43:03 -0800
IronPort-SDR: NK3xU81U027uIwI+LXqOFFS3Pw+HHxXdQsUioR51xooZ7Pg/F+eYiWmyLJ5PYmIUyT/wFwVc4f
 PNabHFAGUWQg==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="406362523"
Received: from asalasax-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.175])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:42:58 -0800
Date:   Wed, 3 Feb 2021 13:42:55 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v3 16/27] KVM: VMX: Convert vcpu_vmx.exit_reason to
 a union
Message-Id: <20210203134255.bb27c26ae4d91b543f3ccee0@intel.com>
In-Reply-To: <YBnU/PZzKHkOIdW1@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <d32ab375be78315e3bc2540f2a741859637abcb0.1611634586.git.kai.huang@intel.com>
        <YBV0nnqUHnING5qA@kernel.org>
        <20210201133259.e0398c9f0b229fd79a8c16c6@intel.com>
        <YBmK2lt/5r/+HrAO@kernel.org>
        <20210203082340.e808a4d97318e07b265d0326@intel.com>
        <YBnU/PZzKHkOIdW1@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Feb 2021 00:41:00 +0200 Jarkko Sakkinen wrote:
> On Wed, Feb 03, 2021 at 08:23:40AM +1300, Kai Huang wrote:
> > On Tue, 2 Feb 2021 19:24:42 +0200 Jarkko Sakkinen wrote:
> > > On Mon, Feb 01, 2021 at 01:32:59PM +1300, Kai Huang wrote:
> > > > On Sat, 30 Jan 2021 17:00:46 +0200 Jarkko Sakkinen wrote:
> > > > > On Tue, Jan 26, 2021 at 10:31:37PM +1300, Kai Huang wrote:
> > > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > > 
> > > > > > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > > > > > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > > > > > bits 15:0, and single-bit modifiers in bits 31:16.
> > > > > > 
> > > > > > Historically, KVM has only had to worry about handling the "failed
> > > > > > VM-Entry" modifier, which could only be set in very specific flows and
> > > > > > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > > > > > bit was a somewhat viable approach.  But even with only a single bit to
> > > > > > worry about, KVM has had several bugs related to comparing a basic exit
> > > > > > reason against the full exit reason store in vcpu_vmx.
> > > > > > 
> > > > > > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > > 
> > > BTW, SGX is not an upcoming CPU feature.
> > 
> > Probably Sean was implying: "Upcoming CPU features that will be supported by
> > Linux". I don't see big deal here.
> > 
> > > 
> > > Also, broadly speaking of upcoming features is not right thing to do.
> > > Better just to scope this down SGX. Theoretically upcoming CPU features
> > > can do pretty much anything. This is change is first and foremost done
> > > for SGX.
> > > 
> > > > > > be set on more or less any VM-Exit, as opposed to the significantly more
> > > > > > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > > > > > flows isn't scalable.  Tracking exit reason in a union forces code to
> > > > > > explicitly choose between consuming the full exit reason and the basic
> > > > > > exit, and is a convenient way to document and access the modifiers.
> > > > > 
> > > > > I *believe* that the change is correct but I dropped in the last paragraph
> > > > > - most likely only because of lack of expertise in this area.
> > > > > 
> > > > > I ask the most basic question: why SGX will add new modifier bits?
> > > > 
> > > > Not 100% sure about your question. Assuming you are asking SGX hardware
> > > > behavior, SGX architecture adds a new modifier bit (27) to Exit Reason, similar
> > > > to new #PF.SGX bit. 
> > > > 
> > > > Please refer to SDM Volume 3, Chapter 27.2.1 Basic VM-Exit Information.
> > > > 
> > > > Sean's commit msg already provides significant motivation of the change in this
> > > > patch.
> > > 
> > > Just describe why SGX requires this. That's all.
> > 
> > This patch is to change vmexit info from u32 to union, because at least one
> > additional modifier is going to be added, due to SGX. So the motivation of this
> > patch is the fact that "one or more additional modifier bits will be added",
> > and SGX is just example. 
> > 
> > So I don't think adding too much SGX backgroud in *THIS* patch is needed.
> > And another patch: 
> > 
> > [RFC PATCH v3 21/27] KVM: VMX: Add basic handling of VM-Exit from SGX enclave
> > 
> > already has enough information of "why new modifier bit is aadded for SGX".
> > Sean also replied to you. 
> 
> Well it comes after this patch. So you either need to provide the context
> here or reorder patches. If latter is impossible, I would just add those
> couple of paragraphs that Sean wrote.

As I explained, to me the motivation of this patch is due to "adding additional
modifier bit", but not due to "adding additional modifier bit *due to SGX*". 

For instance, let's remove SGX in the commit msg, this patch still stands.
Correct?

Sean's paragraph is about why *SGX* adds one additional modifier bit, which
needs to be in another patch, and logically, that patch comes later.

> 
> > Please look at that patch and see whether it satisfies you.
> 
> Well there needs to be causality in patches. I should be able to review
> the patches if 17-> did not exist.
> 
> 
> > 
> > > 
> > > /Jarkko
> > 
> 
> /Jarkko
