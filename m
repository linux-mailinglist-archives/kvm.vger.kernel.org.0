Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6A047741E
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 15:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhLPOM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 09:12:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54752 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237813AbhLPOMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 09:12:55 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639663973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wY+CAEJAUwckZ4JP8ztzEAXZBMnZfuK1dsJI9iW3q8=;
        b=FYg/+/2whs/bC58ZLt166FzhUqUu+5bC/y4ISVw/xulKhKFSLjKETK6KTaqz/cNMNnJlzs
        fBEnRGgALWUF39NgPbJcgve9h5H4ay1QKNCm4kdXyJXlgTjDCTTdGBtZ8CSPb/Wkb5ZmNh
        CNspG69mszOwLmVFO5EZre74Y7OT6H8TeZ6vZqfknvhS956zhpOs4fAIH78PxFVGphP9vj
        5K+YDLDJ6iVurRHsd0OppkQqHIHEuJ/hUOm7XgT2GrPDmPjWXtWGpMxolEJrKmtH/c+U03
        /oFTck1u5bMvu2qvjcjg6KEgi/olf4BfiSyzzKJE592FVsevBrBcoauq9ugH9A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639663973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wY+CAEJAUwckZ4JP8ztzEAXZBMnZfuK1dsJI9iW3q8=;
        b=RL6Sn1ZH2WSL8SKDU61iH/J8qZ95Lyj7rEAO8+kA6bPcenXQdFiLRmz9BZsZQAFso3XExt
        Ki4MgZxwcPauviDA==
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <BN9PR11MB52761B401F752514B22A23768C779@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica>
 <afeba57f71f742b88aac3f01800086f9@intel.com> <878rwmrxgb.ffs@tglx>
 <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
 <BN9PR11MB5276E2165EB86520520D54FD8C779@BN9PR11MB5276.namprd11.prod.outlook.com>
 <87fsqslwph.ffs@tglx>
 <BN9PR11MB52761B401F752514B22A23768C779@BN9PR11MB5276.namprd11.prod.outlook.com>
Date:   Thu, 16 Dec 2021 15:12:53 +0100
Message-ID: <8735msljtm.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16 2021 at 09:59, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> This can be done simply with the MSR entry/exit controls. No trap
>> required neither for #NM for for XFD_ERR.
>> 
>> VMENTER loads guest state. VMEXIT saves guest state and loads host state
>> (0)
>
> This implies three MSR operations for every vm-exit.
>
> With trap we only need one RDMSR in host #NM handler, one 
> RDMSR/one WRMSR exit in guest #NM handler, which are both rare.
> plus one RDMSR/one WRMSR per vm-exit only if saved xfd_err is 
> non-zero which is again rare.

Fair enough.

>> XFD:     Always guest state
>> 
>> So VMENTER does nothing and VMEXIT either saves guest state and the sync
>> function uses the automatically saved value or you keep the sync
>> function which does the rdmsrl() as is.
>> 
>
> Yes, this is the 3rd open that I asked in another reply. The only restriction
> with this approach is that the sync cost is added also for legacy OS which
> doesn't touch xfd at all. 

You still can make that conditional on the guest XCR0. If guest never
enables the extended bit then neither the #NM trap nor the XFD sync
are required.

But yes, there are too many moving parts here :)

Thanks,

        tglx
