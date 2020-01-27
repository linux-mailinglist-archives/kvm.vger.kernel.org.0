Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0414A9AA
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 19:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgA0SR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 13:17:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:36105 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgA0SR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 13:17:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 10:17:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,370,1574150400"; 
   d="scan'208";a="308836628"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 27 Jan 2020 10:17:27 -0800
Date:   Mon, 27 Jan 2020 10:17:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200127181727.GB2523@linux.intel.com>
References: <20200122054724.GD18513@linux.intel.com>
 <9c126d75-225b-3b1b-d97a-bcec1f189e02@redhat.com>
 <87eevrsf3s.fsf@vitty.brq.redhat.com>
 <20200122155108.GA7201@linux.intel.com>
 <87blqvsbcy.fsf@vitty.brq.redhat.com>
 <f15d9e98-25e9-2031-2db5-6aaa6c78c0eb@redhat.com>
 <87zheer0si.fsf@vitty.brq.redhat.com>
 <87lfpyq9bk.fsf@vitty.brq.redhat.com>
 <20200124172512.GJ2109@linux.intel.com>
 <875zgwnc3w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zgwnc3w.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 04:38:27PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > One last idea, can we keep the MSR filtering as is and add the hack in
> > vmx_restore_control_msr()?  That way the (userspace) host and guest see
> > the same values when reading the affected MSRs, and eVMCS wouldn't need
> > it's own hook to do consistency checks.
> 
> Yes but (if I'm not mistaken) we'll have then to keep the filtering we
> currently do in nested_enable_evmcs(): if userspace doesn't do
> KVM_SET_MSR for VMX MSRs (QEMU<4.2) then the filtering in
> vmx_restore_control_msr() won't happen and the guest will see the
> unfiltered set of controls...

Ya, my thought was to add this on top of the nested_enable_evmcs() code.
