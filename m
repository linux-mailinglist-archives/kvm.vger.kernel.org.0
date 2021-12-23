Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F42B47DDDE
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 03:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbhLWCxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 21:53:50 -0500
Received: from mga07.intel.com ([134.134.136.100]:51483 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238419AbhLWCxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 21:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640228030; x=1671764030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nGqAFCAOo7SNv90egd7saIgr/P8AiY2KCKJgLHhFTg4=;
  b=chlN3FUp3hmbrANcvLzpN49DujUX9qND+mD5TTlnMOyPxAcuaBtbhwW0
   95ZQJ2n7q2iOyYFRwB1PIOArW3eZSx4i/NQSIlYG0PCEBkJdNDiZLlUjl
   OSrkG0Vj98N5eWEulSX7J/c1y7DTguzrCBB5auRW8V+mlJqddpuHEwdxo
   6qWsav5fkzYBzdaPfWMhWWCF9yh7vwa6qfiy5Tg79OWmiWEAQx3T/xwxh
   DKEv9sDj4nerH5GuXCil3MfsjqhErPFa4CPIAsrFy7WPDv/Z/HblCdie5
   NGfhhR/gVFxqqAHi8mMS2FOFnKCA90oqETehGM4moFD2dBEGCYy6dC7n4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="304112467"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="304112467"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 18:53:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="521919214"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 22 Dec 2021 18:53:47 -0800
Date:   Thu, 23 Dec 2021 10:38:46 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, jun.nakajima@intel.com,
        kevin.tian@intel.com, jing2.liu@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH v2 3/3] selftest: kvm: Support amx selftest
Message-ID: <20211223023846.GA10804@yangzhon-Virtual>
References: <20211222214731.2912361-1-yang.zhong@intel.com>
 <20211222214731.2912361-4-yang.zhong@intel.com>
 <2348d4e6-fb14-9c5b-5a6a-829d4ecd1839@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2348d4e6-fb14-9c5b-5a6a-829d4ecd1839@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 22, 2021 at 04:15:02PM +0100, Paolo Bonzini wrote:
> On 12/22/21 22:47, Yang Zhong wrote:
> >+	/* Trigger #NM exception */
> >+	__tileloadd(tiledata);
> >+	GUEST_SYNC(10);
> >+
> >+	GUEST_DONE();
> >+}
> >+
> >+void guest_nm_handler(struct ex_regs *regs)
> >+{
> >+	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
> >+	GUEST_SYNC(7);
> >+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> >+	GUEST_SYNC(8);
> >+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
> >+	/* Clear xfd_err */
> >+	wrmsr(MSR_IA32_XFD_ERR, 0);
> >+	regs->rip += 3;
> >+	GUEST_SYNC(9);
> >+}
> 
> I don't understand why "regs->rip += 3" is needed though.
> 
> My idea was that, after GUEST_SYNC(9) and IRET, the guest would
> execute __tileloadd again; this time without generating #NM, so that
> after GUEST_SYNC(10) the host sees the loaded data in TMM0.
>
  
  Sorry, I didn't capture it before, and in that time, I wanted to skip this
  load intruction.

  Let me enbale amx before GUEST_SYNC(9), and then load tiles again.

  The new v3 will address this, thanks!

  Yang


 
> Thanks,
> 
> Paolo
