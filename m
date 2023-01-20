Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D276758E3
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjATPjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjATPjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:39:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD7C4DE09
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 07:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674229060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lf+VUNzHo6930QhHDjlYS5a/9FVCtfkspKq7OQ6oVEY=;
        b=MO4uzR935q98DxhIKd51GMndg7y8YlQU/8Frnu4yLKk+0G9e2c+catA2uyLqfZy76Uloxp
        hMgaRSopBnLZhK+3bRzkD+ShtWvJBvXi3qX/eU+EdA6xHLQ7BH8B5d+z51luiIAkNbXHFb
        1n+i94xnvqwTZnEmXJHq0lHeZqBn1QE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-IuCFiylNNgiCZJZKXtIOSQ-1; Fri, 20 Jan 2023 10:37:39 -0500
X-MC-Unique: IuCFiylNNgiCZJZKXtIOSQ-1
Received: by mail-ed1-f69.google.com with SMTP id b15-20020a056402350f00b0049e42713e2bso4130534edd.0
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 07:37:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lf+VUNzHo6930QhHDjlYS5a/9FVCtfkspKq7OQ6oVEY=;
        b=NXsy6swGjvyFhtnDYJUXwFE6HcDi19wY5irZ7rCUwJ/I/afmJ4VP7+bMUNd8yszoOF
         jzMj2n9qb6e9CiQ+7f9UKWOt8v4Pqp6zEVg3W3FZRyXHDzlgEjYAbC+PXY9FJXTfqIUo
         x0TJvVQCRJ3W/1xnyl87ri1DB9ebR71Y9b+KJIn+3ZBfzmeGRKGBHjHGuz3Xg49ahhyg
         whIo7bUZfYRCMc7H9HOdjfRAN/mAsI/LAX+0capdm4H7MudKqQqA2yapA0d7PIVq6kci
         ZpfMg9/HIHoqnBBriu4SGSNaN7xfZ+M+dT4/byOJCY4D/F922vdtnH3/0whg/lRS7SgU
         gwng==
X-Gm-Message-State: AFqh2kojWKjRqObNh0mWiy8losdzA2bSmb3rXLjAososzZ8uYtnE379d
        mF9mC5GjpT8nCGN3T2MD6zHPp5RRG5McJLdL6SWXEaNdes3SX//tdaEQuT9mCezLJ40can7T1uQ
        6MdwlOgKbfGJw
X-Received: by 2002:a05:6402:413:b0:498:b9ea:1894 with SMTP id q19-20020a056402041300b00498b9ea1894mr14217253edv.15.1674229058188;
        Fri, 20 Jan 2023 07:37:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt9Neac975gd5nkcxdpVzeTBwC+wqA5CjhhwnQrnrtHBQwgyExGpn/wMyvV8tTW0X127YXwMw==
X-Received: by 2002:a05:6402:413:b0:498:b9ea:1894 with SMTP id q19-20020a056402041300b00498b9ea1894mr14217220edv.15.1674229057884;
        Fri, 20 Jan 2023 07:37:37 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id eg49-20020a05640228b100b00488117821ffsm17591730edb.31.2023.01.20.07.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 07:37:35 -0800 (PST)
Date:   Fri, 20 Jan 2023 16:37:34 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        amakhalov@vmware.com, ganb@vmware.com, ankitja@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, blamoreaux@vmware.com,
        namit@vmware.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Lewis Caroll <lewis.carroll@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2] x86/hotplug: Do not put offline vCPUs in mwait idle
 state
Message-ID: <20230120163734.63e62444@imammedo.users.ipa.redhat.com>
In-Reply-To: <ecb9a22e-fd6e-67f0-d916-ad16033fc13c@csail.mit.edu>
References: <20230116060134.80259-1-srivatsa@csail.mit.edu>
        <20230116155526.05d37ff9@imammedo.users.ipa.redhat.com>
        <87bkmui5z4.ffs@tglx>
        <ecb9a22e-fd6e-67f0-d916-ad16033fc13c@csail.mit.edu>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Jan 2023 05:55:11 -0800
"Srivatsa S. Bhat" <srivatsa@csail.mit.edu> wrote:

> Hi Igor and Thomas,
> 
> Thank you for your review!
> 
> On 1/19/23 1:12 PM, Thomas Gleixner wrote:
> > On Mon, Jan 16 2023 at 15:55, Igor Mammedov wrote:  
> >> "Srivatsa S. Bhat" <srivatsa@csail.mit.edu> wrote:  
> >>> Fix this by preventing the use of mwait idle state in the vCPU offline
> >>> play_dead() path for any hypervisor, even if mwait support is
> >>> available.  
> >>
> >> if mwait is enabled, it's very likely guest to have cpuidle
> >> enabled and using the same mwait as well. So exiting early from
> >>  mwait_play_dead(), might just punt workflow down:
> >>   native_play_dead()
> >>         ...
> >>         mwait_play_dead();
> >>         if (cpuidle_play_dead())   <- possible mwait here                                              
> >>                 hlt_play_dead(); 
> >>
> >> and it will end up in mwait again and only if that fails
> >> it will go HLT route and maybe transition to VMM.  
> > 
> > Good point.
> >   
> >> Instead of workaround on guest side,
> >> shouldn't hypervisor force VMEXIT on being uplugged vCPU when it's
> >> actually hot-unplugging vCPU? (ex: QEMU kicks vCPU out from guest
> >> context when it is removing vCPU, among other things)  
> > 
> > For a pure guest side CPU unplug operation:
> > 
> >     guest$ echo 0 >/sys/devices/system/cpu/cpu$N/online
> > 
> > the hypervisor is not involved at all. The vCPU is not removed in that
> > case.
> >   
> 
> Agreed, and this is indeed the scenario I was targeting with this patch,
> as opposed to vCPU removal from the host side. I'll add this clarification
> to the commit message.

commit message explicitly said:
"which prevents the hypervisor from running other vCPUs or workloads on the
corresponding pCPU."

and that implies unplug on hypervisor side as well.
Why? That's because when hypervisor exposes mwait to guest, it has to reserve/pin
a pCPU for each of present vCPUs. And you can safely run other VMs/workloads
on that pCPU only after it's not possible for it to be reused by VM where
it was used originally.

Now consider following worst (and most likely) case without unplug
on hypervisor side:

 1. vm1mwait: pin pCPU2 to vCPU2
 2. vm1mwait: guest$ echo 0 >/sys/devices/system/cpu/cpu2/online
        -> HLT -> VMEXIT
 --
 3. vm2mwait: pin pCPU2 to vCPUx and start VM
 4. vm2mwait: guest OS onlines Vcpu and starts using it incl.
       going into idle=>mwait state
 --
 5. vm1mwait: it still thinks that vCPU is present it can rightfully do:
       guest$ echo 1 >/sys/devices/system/cpu/cpu2/online
 --              
 6.1 best case vm1mwait online fails after timeout
 6.2 worse case: vm2mwait does VMEXIT on vCPUx around time-frame when
     vm1mwait onlines vCPU2, the online may succeed and then vm2mwait's
     vCPUx will be stuck (possibly indefinitely) until for some reason
     VMEXIT happens on vm1mwait's vCPU2 _and_ host decides to schedule
     vCPUx on pCPU2 which would make vm1mwait stuck on vCPU2.
So either way it's expected behavior.

And if there is no intention to unplug vCPU on hypervisor side,
then VMEXIT on play_dead is not really necessary (mwait is better
then HLT), since hypervisor can't safely reuse pCPU elsewhere and
VCPU goes into deep sleep within guest context.

PS:
The only case where making HLT/VMEXIT on play_dead might work out,
would be if new workload weren't pinned to the same pCPU nor
used mwait (i.e. host can migrate it elsewhere and schedule
vCPU2 back on pCPU2).


> > So to ensure that this ends up in HLT something like the below is
> > required.
> > 
> > Note, the removal of the comment after mwait_play_dead() is intentional
> > because the comment is completely bogus. Not having MWAIT is not a
> > failure. But that wants to be a seperate patch.
> >   
> 
> Sounds good, will do and post a new version.
> 
> Thank you!
> 
> Regards,
> Srivatsa
> VMware Photon OS
> 
> 
> > Thanks,
> > 
> >         tglx
> > ---        
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index 55cad72715d9..3f1f20f71ec5 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -1833,7 +1833,10 @@ void native_play_dead(void)
> >  	play_dead_common();
> >  	tboot_shutdown(TB_SHUTDOWN_WFS);
> >  
> > -	mwait_play_dead();	/* Only returns on failure */
> > +	if (this_cpu_has(X86_FEATURE_HYPERVISOR))
> > +		hlt_play_dead();
> > +
> > +	mwait_play_dead();
> >  	if (cpuidle_play_dead())
> >  		hlt_play_dead();
> >  }
> > 
> > 
> >   
> >   
> 

