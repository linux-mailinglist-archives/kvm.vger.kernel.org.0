Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840E91C7010
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 14:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEFMM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 08:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727969AbgEFMM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 08:12:59 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758A9C061A0F;
        Wed,  6 May 2020 05:12:59 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jWIuv-0002Ol-V2; Wed, 06 May 2020 14:12:50 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 6C6291001F5; Wed,  6 May 2020 14:12:48 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v8 4/4] kvm: vmx: virtualize split lock detection
In-Reply-To: <20200505030736.GA20916@linux.intel.com>
References: <20200414063129.133630-5-xiaoyao.li@intel.com> <871rooodad.fsf@nanos.tec.linutronix.de> <20200415191802.GE30627@linux.intel.com> <87tv1kmol8.fsf@nanos.tec.linutronix.de> <20200415214318.GH30627@linux.intel.com> <20200505030736.GA20916@linux.intel.com>
Date:   Wed, 06 May 2020 14:12:48 +0200
Message-ID: <87h7wtl0sf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:
> On Wed, Apr 15, 2020 at 02:43:18PM -0700, Sean Christopherson wrote:
>> On Wed, Apr 15, 2020 at 11:22:11PM +0200, Thomas Gleixner wrote:
>> > So we can go with the proposed mode of allowing the write but not
>> > propagating it. If the resulting split lock #AC originates from CPL != 3
>> > then the guest will be killed with SIGBUS. If it originates from CPL ==
>> > 3 and the guest has user #AC disabled then it will be killed as well.
>> 
>> An idea that's been floated around to avoid killing the guest on a CPL==3
>> split-lock #AC is to add a STICKY bit to MSR_TEST_CTRL that KVM can
>> virtualize to tell the guest that attempting to disable SLD is futile,
>> e.g. so that the guest can kill its misbehaving userspace apps instead of
>> trying to disable SLD and getting killed by the host.
>
> Circling back to this.  KVM needs access to sld_state in one form or another
> if we want to add a KVM hint when the host is in fatal mode.  Three options
> I've come up with:
>
>   1. Bite the bullet and export sld_state.  
>
>   2. Add an is_split_fatal_wrapper().  Ugly since it needs to be non-inline
>      to avoid triggering (1).
>
>   3. Add a synthetic feature flag, e.g. X86_FEATURE_SLD_FATAL, and drop
>      sld_state altogether.
>
> I like (3) because it requires the least amount of code when all is said
> and done, doesn't require more exports, and as a bonus it'd probably be nice
> for userspace to see sld_fatal in /proc/cpuinfo.

#3 makes sense and is elegant.

Thanks,

        tglx
