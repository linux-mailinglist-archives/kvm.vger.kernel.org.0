Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EA83108A1
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 11:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhBEJ7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 04:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhBEJ4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 04:56:48 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8272BC061356;
        Fri,  5 Feb 2021 01:56:08 -0800 (PST)
Received: from zn.tnic (p200300ec2f0bad000b74c3ca4e4ea61e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ad00:b74:c3ca:4e4e:a61e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E938B1EC04DF;
        Fri,  5 Feb 2021 10:56:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1612518966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zN4c6Rjazb5+C5xqrwy+KhxDQNgptXz2W8SjYpj0YEQ=;
        b=WzEwt8w+fqlI7Y2STC9YTvuuz6wD+90ZeeTy69RINCVlvK5Ug5ceCoOrO10SWLB3smVEPC
        How6cdAlbzpfHRwh4TZxPctedf/xm+pSAivNYvMNQ0ZAjkkTOZnHlP1U44IehsV3hjjL5o
        KksFFATN9wDyYIz+r7H6HaDlgFTv/Kk=
Date:   Fri, 5 Feb 2021 10:56:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 2/5] KVM: X86: Expose PKS to guest
Message-ID: <20210205095603.GB17488@zn.tnic>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-3-chenyi.qiang@intel.com>
 <8768ad06-e051-250d-93ec-fa4d684bc7b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8768ad06-e051-250d-93ec-fa4d684bc7b0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 10:25:48AM +0100, Paolo Bonzini wrote:
> On 05/02/21 09:37, Chenyi Qiang wrote:
> > 
> > diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
> > index 57718716cc70..8027f854c600 100644
> > --- a/arch/x86/mm/pkeys.c
> > +++ b/arch/x86/mm/pkeys.c
> > @@ -390,3 +390,9 @@ void pks_key_free(int pkey)
> >  	__clear_bit(pkey, &pks_key_allocation_map);
> >  }
> >  EXPORT_SYMBOL_GPL(pks_key_free);
> > +
> > +u32 get_current_pkrs(void)
> > +{
> > +	return this_cpu_read(pkrs_cache);
> > +}
> > +EXPORT_SYMBOL_GPL(get_current_pkrs);
> > diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
> > index bed0e293f13b..480429020f4c 100644
> > --- a/include/linux/pkeys.h
> > +++ b/include/linux/pkeys.h
> > @@ -72,6 +72,10 @@ static inline void pks_mk_readwrite(int pkey)
> >  {
> >  	pr_err("%s is not valid without PKS support\n", __func__);
> >  }
> > +static inline u32 get_current_pkrs(void)
> > +{
> > +	return 0;
> > +}
> >  #endif /* ! CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
> 
> This would need an ack from the x86 people.  Andy, Boris?

This looks like the PKS baremetal pile needs to be upstream first.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
