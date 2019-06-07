Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E48B392CC
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbfFGRIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:08:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:20601 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbfFGRIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:08:34 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 10:08:33 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jun 2019 10:08:32 -0700
Date:   Fri, 7 Jun 2019 10:08:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 06/15] KVM: nVMX: Don't "put" vCPU or host state when
 switching VMCS
Message-ID: <20190607170832.GF9083@linux.intel.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-7-sean.j.christopherson@intel.com>
 <79ac3a1c-8386-3f5a-2abd-eb284407abb7@redhat.com>
 <20190606185727.GK23169@linux.intel.com>
 <10df352d-d90b-8594-cc1c-5a5f8df689f7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10df352d-d90b-8594-cc1c-5a5f8df689f7@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 07:00:06PM +0200, Paolo Bonzini wrote:
> On 06/06/19 20:57, Sean Christopherson wrote:
> > What about taking the vmcs pointers, and using old/new instead of
> > prev/cur?  Calling it prev is wonky since it's pulled from the current
> > value of loaded_cpu_state, especially since cur is the same type.
> > That oddity is also why I grabbed prev before setting loaded_vmcs,
> > it just felt wrong even though they really are two separate things.
> > 
> > static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> > 				     struct loaded_vmcs *old,
> > 				     struct loaded_vmcs *new)
> 
> I had it like that in the beginning actually.  But the idea of this
> function is that because we're switching vmcs's, the host register
> fields have to be moved to the VMCS that will be used next.  I don't see
> how it would be used with old and new being anything other than
> vmx->loaded_cpu_state and vmx->loaded_vmcs and, because we're switching
> VMCS, those are the "previously" active VMCS and the "currently" active
> VMCS.
> 
> What would also make sense, is to change loaded_cpu_state to a bool (it
> must always be equal to loaded_vmcs anyway) and make the prototype
> something like this:
> 
> static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> 				     struct loaded_vmcs *prev)
> 
> 
> I'll send a patch.

Works for me.  The only reason I made loaded_cpu_state was so that
vmx_prepare_switch_to_host() could WARN on it diverging from loaded_vmcs.
Seeing as how that WARN has never fired, I'm comfortable making it a bool.
