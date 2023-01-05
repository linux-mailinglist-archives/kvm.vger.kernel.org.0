Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F338D65EFA1
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 16:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbjAEPFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 10:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjAEPE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 10:04:59 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045171B1DA;
        Thu,  5 Jan 2023 07:04:57 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 358AE1EC06C1;
        Thu,  5 Jan 2023 16:04:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672931096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GMhRtk9cEauGSmA4lPJVHebUyYxqUZuIY1TvE+SPTcQ=;
        b=o+f2lFmxFzDQwrfUVndeh9pSFO8/LILqo+ZjpnBMTpmkZ2j3xQE7du8BJEeP4NOvinPKDJ
        CZ2SUiY4EhKFCAxxNXGnIO9ZwiomP4VihxslRhAomrMtQRbs/vKjrA4VaMa7aldn2n3R8J
        wqYVXKk5PfqMtT/WLzrqxpxBNT1yYo0=
Date:   Thu, 5 Jan 2023 16:04:51 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Nikunj A Dadhania <nikunj@amd.com>,
        chao.p.peng@linux.intel.com
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Message-ID: <Y7bnE5bTUb6fQiX/@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-4-michael.roth@amd.com>
 <Y6Xd0ruz3kMij/5F@zn.tnic>
 <20230105021419.rs23nfq44rv64tsd@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230105021419.rs23nfq44rv64tsd@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 08:14:19PM -0600, Michael Roth wrote:
> Maybe that's not actually enforced, by it seems awkward to try to use a
> bool return instead. At least for KVM_X86_OP_OPTIONAL_RET0().

I don't see there being a problem/restriction for bool functions, see

5be2226f417d ("KVM: x86: allow defining return-0 static calls")

and __static_call_return0() returns a long which, if you wanna interpret as
bool, works too as "false".

I still need to disassemble and single-step through a static_call to see what
all that magic does in detail, to be sure.

> However, we could just use KVM_X86_OP() to declare it so we can cleanly
> use a function that returns bool, and then we just need to do:
> 
>   bool kvm_arch_has_private_mem(struct kvm *kvm)
>   {
>           if (kvm_x86_ops.private_mem_enabled)
>                   return static_call(kvm_x86_private_mem_enabled)(kvm);

That would be defeating the whole purpose of static calls, AFAICT, as you're
testing the pointer. Might as well leave it be a normal function pointer then.

> On a separate topic though, at a high level, this hook is basically a way
> for platform-specific code to tell generic KVM code that private memslots
> are supported by overriding the kvm_arch_has_private_mem() weak
> reference. In this case the AMD platform is using using kvm->arch.upm_mode
> flag to convey that, which is in turn set by the
> KVM_CAP_UNMAPPED_PRIVATE_MEMORY introduced in this series.
> 
> But if, as I suggested in response to your PATCH 2 comments, we drop
> KVM_CAP_UNAMMPED_PRIVATE_MEMORY in favor of
> KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to enable "UPM mode" in SEV/SNP
> code, then we need to rethink things a bit, since KVM_SET_MEMORY_ATTRIBUTES
> in-part relies on kvm_arch_has_private_mem() to determine what flags are
> supported, whereas SEV/SNP code would be using what was set by
> KVM_SET_MEMORY_ATTRIBUTES to determine the return value in
> kvm_arch_has_private_mem().
> 
> So, for AMD, the return value of kvm_arch_has_private_mem() needs to rely
> on something else. Maybe the logic can just be:
> 
>   bool svm_private_mem_enabled(struct kvm *kvm)
>   {
>     return sev_enabled(kvm) || sev_snp_enabled(kvm)

I haven't followed the whole discussion in detail but this means that SEV/SNP
*means* UPM. I.e., no SEV/SNP without UPM, correct? I guess that's the final
thing you guys decided to do ...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
