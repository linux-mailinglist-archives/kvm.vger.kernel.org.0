Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9699F14A980
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 19:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgA0SM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 13:12:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:33692 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgA0SM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 13:12:57 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 10:12:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,370,1574150400"; 
   d="scan'208";a="221811110"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 27 Jan 2020 10:12:56 -0800
Date:   Mon, 27 Jan 2020 10:12:56 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
Message-ID: <20200127181255.GA2523@linux.intel.com>
References: <20200127060305.jlq5uv6tu67tsbv4@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127060305.jlq5uv6tu67tsbv4@kili.mountain>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 09:04:22AM +0300, Dan Carpenter wrote:
> Hello Paolo Bonzini,
> 
> The patch e71ae535bc24: "KVM: x86: avoid incorrect writes to host
> MSR_IA32_SPEC_CTRL" from Jan 20, 2020, leads to the following static
> checker warning:
> 
> 	arch/x86/kvm/vmx/vmx.c:2001 vmx_set_msr()
> 	warn: maybe use && instead of &
> 
> arch/x86/kvm/vmx/vmx.c
>   1994                  vmx->msr_ia32_umwait_control = data;
>   1995                  break;
>   1996          case MSR_IA32_SPEC_CTRL:
>   1997                  if (!msr_info->host_initiated &&
>   1998                      !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
>   1999                          return 1;
>   2000  
>   2001                  if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
>                                    ^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This seems wrong.  kvm_spec_ctrl_valid_bits() returns a bool so this
> is either 0xffffffff or 0xfffffffe.  data is a u64.
> 
>   2002                          return 1;
>   2003  
>   2004                  vmx->spec_ctrl = data;
>   2005                  if (!data)
>   2006                          break;
>   2007  
>   2008                  /*
>   2009                   * For non-nested:

Paolo already had to put on the cone of shame for this one :-)

https://lkml.kernel.org/r/6b725990-f0c2-6577-be7e-44e101e540b5@redhat.com
