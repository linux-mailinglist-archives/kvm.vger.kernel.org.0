Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899F6406572
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 03:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhIJBzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 21:55:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:39045 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJBzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 21:55:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="284668191"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="284668191"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:54:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="548935759"
Received: from jianjunz-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.170.205])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:53:54 -0700
Date:   Fri, 10 Sep 2021 09:53:51 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Avi Kivity <avi@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] kvm: x86: Introduce hypercall x86 ops for
 handling hypercall not in cpl0
Message-ID: <20210910015351.yxvgv2nedgojmmeo@linux.intel.com>
References: <cover.1631188011.git.houwenlong93@linux.alibaba.com>
 <04a337801ad5aaa54144dc57df8ee2fc32bc9c4e.1631188011.git.houwenlong93@linux.alibaba.com>
 <20210909163901.2vvozmkuxjcgabs5@linux.intel.com>
 <YTo/t4G1iI28oDmk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTo/t4G1iI28oDmk@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 05:09:11PM +0000, Sean Christopherson wrote:
> On Fri, Sep 10, 2021, Yu Zhang wrote:
> > On Thu, Sep 09, 2021 at 07:55:23PM +0800, Hou Wenlong wrote:
> > > Per Intel's SDM, use vmcall instruction in non VMX operation for cpl3
> > > it should trigger a #UD. And in VMX root operation, it should
> > 
> > Are you sure? IIRC, vmcall will always cause VM exit as long as CPU
> > is in non-root mode(regardless the CPL).
> 
> Correct, VMCALL unconditionally causes VM-Exit in non-root mode, but Hou is
> referring to the first fault condition of "non VMX operation".  The intent of the
> patch is to emulate hardware behavior for CPL>0: if L1 is not in VMX operation,
> a.k.a. not post-VMXON, then #UD, else #GP (because VMCALL #GPs at CPL>0 in VMX
> root).

Oh, I see. It's to make the virtualized world more real. But like you said, 
it's not KVM's target. And doing that could cause more problems - a PV guest
expects the VMCALL to succeed, regardless it has VMX capability or its VMX is
on or not.

Thanks for the explaination.

B.R.
Yu
