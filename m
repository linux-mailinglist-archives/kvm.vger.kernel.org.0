Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE2453CB8
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 00:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhKPXiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 18:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhKPXix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 18:38:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E991AC061570;
        Tue, 16 Nov 2021 15:35:55 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637105752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9uL6alBtzbSwWo4J3REeTUCzQ4YPJ5LPQzd9HoPbnRc=;
        b=MoFwvZY9tjv3ESgZnaViMaPfDa1CPIFbIp4oXbDK+darUpkNYB+LtoQerhjhoK0BvRdGwH
        krYgeUUn2dZajNm0AAlhNpBBjrnt2zfXCOes37tI/NIU3z0dJmNdhgk34xSAYAExk5JOaY
        HcMxfVgZCjZn1r5VksExV0slqQ3WoG140ELVE9r0fEh1nFEs4UGDfqOqLgX//rPGv8Fnrn
        WLsfxWHBMdCgtOuA9h01S9er+YuMXwbLa7rThJzKKQiNfJSYbfP8JnconQzEUH8asYKAKZ
        +WMFvKBrovTUA1XXhy3sbQeVfjPymW+sIMNtUkgZfa0PTdpas5msOYYRyneeGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637105752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9uL6alBtzbSwWo4J3REeTUCzQ4YPJ5LPQzd9HoPbnRc=;
        b=CVqAG9xg+TqxF0jpBOoQS+i2pYAobRVTVSQyaUcubPMNPdmra5n+/MbJdan6ABA0Y5PIeL
        ktcF96d4IHgibzAQ==
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <YZQQuQDWPhcJG6pM@google.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx> <YZPWsICdDTZ02UDu@google.com> <87ee7g53rp.ffs@tglx>
 <YZQQuQDWPhcJG6pM@google.com>
Date:   Wed, 17 Nov 2021 00:35:51 +0100
Message-ID: <87wnl74qso.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16 2021 at 20:12, Sean Christopherson wrote:
> On Tue, Nov 16, 2021, Thomas Gleixner wrote:
>> Now you could argue that the interrupt/softirq XSAVES should also read
>> the XFD MSR and save it in guest_fpstate.xfd. Same in schedule()
>> and kvm_put_guest_fpu(), i.e:
>> 
>>       XSAVES
>>       if (fpstate->is_guest) {
>>             rdmsrl(XFD, xfd);
>>             fpstate->xfd = xfd;
>>             __this_cpu_write(..., xfd);
>>       }
>> 
>> We can do that, but I'm unhappy about this conditional in schedule(). So
>> I was asking for doing a simple KVM only solution first:
>
> Ah, the schedule() conditional is the part I was missing.  Thanks!

As I was missing the preempt notifier... which makes it a different
story, but I still think that the simple version is good enough at least
for a start.

Thanks,

        tglx
