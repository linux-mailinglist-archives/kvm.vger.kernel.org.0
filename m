Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA1A20F5F6
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgF3Nl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 09:41:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733299AbgF3Nl4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 09:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593524515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipmBc6HojCARbwllHbnHwrqfgLM8sbDtOUTY+0qFSa4=;
        b=Z/CHPW7ZPP/7DqQL7QBywU2imJQfVQVCVhiGszwxdE+XTac8ieWa82DlRDrV7FLRUQi5L7
        /gouPBo2Iylppv9iOIR5bwvKy1A63u+1GPN7i0JDhep+sd1qaB8QDOnRz5+CT4e9sBr4K7
        pVOWFx2ldTQa/jmyAY5enmyPu8sRgAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-4OQ2FzdZMgiVBtD4MAQSww-1; Tue, 30 Jun 2020 09:41:53 -0400
X-MC-Unique: 4OQ2FzdZMgiVBtD4MAQSww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8596880183C;
        Tue, 30 Jun 2020 13:41:52 +0000 (UTC)
Received: from starship (unknown [10.35.206.251])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBCB71001B0B;
        Tue, 30 Jun 2020 13:41:50 +0000 (UTC)
Message-ID: <08986e161635cc83d2d96b9729257dec91fc4562.camel@redhat.com>
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Tao Xu <tao3.xu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 30 Jun 2020 16:41:49 +0300
In-Reply-To: <3642373d-8d1d-de80-d3db-e835a8f29449@redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com>
         <20200520160740.6144-3-mlevitsk@redhat.com>
         <b8ca9ea1-2958-3ab4-2e86-2edbee1ca9d9@redhat.com>
         <81228a0e-7797-4f34-3d6d-5b0550c10a8f@intel.com>
         <c1cbcfe4-07a1-a166-afaf-251cc0319aad@intel.com>
         <ad6c9663-2d9d-cfbd-f10d-5745731488fa@intel.com>
         <6c99b807-fe67-23b5-3332-b7200bf5d639@intel.com>
         <3642373d-8d1d-de80-d3db-e835a8f29449@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-05-21 at 10:40 +0200, Paolo Bonzini wrote:
> On 21/05/20 08:44, Tao Xu wrote:
> > I am sorry, I mean:
> > By default, we don't expose WAITPKG to guest. For QEMU, we can use
> > "-overcommit cpu-pm=on" to use WAITPKG.
> 
> But UMONITOR, UMWAIT and TPAUSE are not NOPs on older processors (which
> I should have checked before committing your patch, I admit).  So you
> have broken "-cpu host -overcommit cpu-pm=on" on any processor that
> doesn't have WAITPKG.  I'll send a patch.
> 
> Paolo
> 
Any update on that?

I accidently hit this today while updating my guest's kernel.
Turns out I had '-overcommit cpu-pm=on' enabled and -cpu host,
and waitpkg (which my AMD cpu doesn't have by any means) was silently
exposed to the guest but it didn't use it, but the mainline kernel started
using it and so it crashes.
Took me some time to realize that I am hitting this issue.


The CPUID_7_0_ECX_WAITPKG is indeed cleared in KVM_GET_SUPPORTED_CPUID,
and code in qemu sets/clears it depending on 'cpu-pm' value.

This patch (copy-pasted so probably not to apply) works for me regardless if we want to fix the KVM_GET_SUPPORTED_CPUID
returned value (which I think we should).
It basically detects the presence of the UMWAIT by presense of MSR_IA32_UMWAIT_CONTROL
in the global KVM_GET_MSR_INDEX_LIST, which I recently fixed too, to not return this
msr if the host CPUID doesn't support it.
So this works but is a bit ugly IMHO.

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 6adbff3d74..e9933d2e68 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -412,7 +412,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
             ret &= ~(CPUID_7_0_EBX_RTM | CPUID_7_0_EBX_HLE);
         }
     } else if (function == 7 && index == 0 && reg == R_ECX) {
-        if (enable_cpu_pm) {
+        if (enable_cpu_pm && has_msr_umwait) {
             ret |= CPUID_7_0_ECX_WAITPKG;
         } else {
             ret &= ~CPUID_7_0_ECX_WAITPKG;
-- 

Should I send this patch officially?

Best regards,
	Maxim Levitsky


