Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240AF2EAA82
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 13:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbhAEMPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 07:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbhAEMPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 07:15:39 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D4DC061574;
        Tue,  5 Jan 2021 04:14:59 -0800 (PST)
Received: from zn.tnic (p200300ec2f103700516ef90d43f797fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:3700:516e:f90d:43f7:97fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8C4C81EC03CE;
        Tue,  5 Jan 2021 13:14:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609848897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RF566gcx4bAK61IE/QfhQTdQnYQn1pp0i7xMLkNYktk=;
        b=ATkefP+A8d3f/dc/yazlw9dUeXvMHJ//SfznAbr2iCTSm69LbcHbnIr9MD+MI4Ytqn+zCL
        FCTQlQ/pOnrgOmEne7o/eGRcaoKaWN3GvBrjkw32SlivHh+7doVO6e4YvXCbzg42LJupJZ
        YaM3AJxTXn24p+Z/A39HKMdC8KUXKWA=
Date:   Tue, 5 Jan 2021 13:14:56 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Zhong <yang.zhong@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, tony.luck@intel.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, x86@kernel.org
Subject: Re: [PATCH 1/2] Enumerate AVX Vector Neural Network instructions
Message-ID: <20210105121456.GE28649@zn.tnic>
References: <20210105004909.42000-1-yang.zhong@intel.com>
 <20210105004909.42000-2-yang.zhong@intel.com>
 <8fa46290-28d8-5f61-1ce4-8e83bf911106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8fa46290-28d8-5f61-1ce4-8e83bf911106@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 05, 2021 at 12:47:23PM +0100, Paolo Bonzini wrote:
> On 05/01/21 01:49, Yang Zhong wrote:
> > From: Kyung Min Park <kyung.min.park@intel.com>
> > 
> > Add AVX version of the Vector Neural Network (VNNI) Instructions.
> > 
> > A processor supports AVX VNNI instructions if CPUID.0x07.0x1:EAX[4] is
> > present. The following instructions are available when this feature is
> > present.
> >    1. VPDPBUS: Multiply and Add Unsigned and Signed Bytes
> >    2. VPDPBUSDS: Multiply and Add Unsigned and Signed Bytes with Saturation
> >    3. VPDPWSSD: Multiply and Add Signed Word Integers
> >    4. VPDPWSSDS: Multiply and Add Signed Integers with Saturation
> > 
> > The only in-kernel usage of this is kvm passthrough. The CPU feature
> > flag is shown as "avx_vnni" in /proc/cpuinfo.
> > 
> > This instruction is currently documented in the latest "extensions"
> > manual (ISE). It will appear in the "main" manual (SDM) in the future.
> > 
> > Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> > Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > ---
> >   arch/x86/include/asm/cpufeatures.h | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > index f5ef2d5b9231..d10d9962bd9b 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -293,6 +293,7 @@
> >   #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
> >   /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
> > +#define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
> >   #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
> >   /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
> > 
> 
> Boris, is it possible to have a topic branch for this patch?

Just take it through your tree pls.

Acked-by: Borislav Petkov <bp@suse.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
