Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC60489B25
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbiAJOSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 09:18:37 -0500
Received: from ssh.movementarian.org ([139.162.205.133]:53964 "EHLO
        movementarian.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235417AbiAJOSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 09:18:36 -0500
X-Greylist: delayed 1631 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2022 09:18:35 EST
Received: from movement by movementarian.org with local (Exim 4.94)
        (envelope-from <movement@movementarian.org>)
        id 1n6v50-00A6ze-VH; Mon, 10 Jan 2022 13:51:22 +0000
Date:   Mon, 10 Jan 2022 13:51:22 +0000
From:   John Levon <levon@movementarian.org>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: X86_FEATURE_AMD_IBRS getting set for Intel guests
Message-ID: <Ydw52mvd3SQH/5CY@movementarian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url:  http://www.movementarian.org/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


```
arch/x86/kernel/cpu/common.c:

 863         /*                                                                       
 864          * The Intel SPEC_CTRL CPUID bit implies IBRS and IBPB support,          
 865          * and they also have a different bit for STIBP support. Also,           
 866          * a hypervisor might have set the individual AMD bits even on           
 867          * Intel CPUs, for finer-grained selection of what's available.          
 868          */                                                                      
 869         if (cpu_has(c, X86_FEATURE_SPEC_CTRL)) {                                 
 870                 set_cpu_cap(c, X86_FEATURE_IBRS);                                
 871                 set_cpu_cap(c, X86_FEATURE_IBPB);                                
 872                 set_cpu_cap(c, X86_FEATURE_MSR_SPEC_CTRL);                       
 873         }                                                                        

arch/x86/kvm/cpuid.c:

 550         /*                                                                       
 551          * AMD has separate bits for each SPEC_CTRL bit.                         
 552          * arch/x86/kernel/cpu/bugs.c is kind enough to                          
 553          * record that in cpufeatures so use them.                               
 554          */                                                                      
 555         if (boot_cpu_has(X86_FEATURE_IBPB))                                      
 556                 kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);                           
 557         if (boot_cpu_has(X86_FEATURE_IBRS))                                      
 558                 kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);                           
```

As a result, we're setting AMD-specific bits in the relevant CPUID leaf. They're
reserved, but it appears, somewhat unfortunately, that libvirt happily reports
them regardless of vendor - with the knock-on effect that anything using `virsh
capabilities` to decide which flags to pass to qemu inside the guest VM
breaks[1].

Curious if other people have hit this, and if there's specific reason why we're
setting AMD-specific flags on Intel like this.

thanks
john

[1] yes, it should be using `virsh domcapabilities`, but that didn't use to
exist AFAIK
