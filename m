Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CAE4464EB
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 15:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhKEObL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 10:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhKEObK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 10:31:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00716C061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 07:28:30 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id m14so9014132pfc.9
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 07:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6VOsn4mMFoeIpWQu2tEjJSqUu/jwqRBM5pT3S++VzdI=;
        b=XiyvkvqawwmKSqbr6vdIUBXiQC1cfJn1vgIyTfwpitSY0+4E6fSaF93z849+RwCj8S
         Ex0FHHCMA7sy9lOiTRZwF0KEuGO569VhInFavlOBCppDT29OEbHRFS4WhydMiuUPLl6C
         Q9949q//FEzvM/LEb71LH3RXYR2UYuSDEpuHyUevgVGF66RMB7CiCtud470kF2m4jc+0
         zpkwmj/vgznbhqeuefUMEIsiCYZMXy5yBMtivvmlpOqWJx7WpcVQV+PP3o73dT0GNHo1
         Y+z63NkNTs0uca57NwO6LKhHrgdrjIDgzpqSXxSXob5HMXdU0IuhDHbI9TDl/Hkoh8dv
         9hXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6VOsn4mMFoeIpWQu2tEjJSqUu/jwqRBM5pT3S++VzdI=;
        b=yP4eSXn/xiV0rChvGQ+cxH40ChWEe53dnzByB+zk8X3lJDQ4miHiaK5Yy7bFLqR+2E
         nl2lJXQPIZ8FDWbxIxdUibAbp/uxi4vz5rEXmTr5RrYnJvWqzOjY2SJn2rZ4WHsvk4mg
         KWy+v7bQVjNg7ohc9rUQpVSjEX2FHQhUwIE/kWGuy+zPft8KtAAKXyqClEdmL+zy+owZ
         2t3Z5bvzBPSDNM8h8hayFX3TfJih6ckiZ/dNU1Y6qaxibzwOWlb9CpDNVC4pS55wvWaM
         yy+4yO6uaIiYuGYYlHR791J5EpTqwpG4SrqsWlv/0Ftm44QAb74Dt/tL01EZGBic2CnN
         os1Q==
X-Gm-Message-State: AOAM531bUp3PcU0La1baw9eM1pRWo/RGbA9UtD8BUePBXevjd5GplUK1
        r88VjIZ/iXLCMKiOUfIPjeAneg==
X-Google-Smtp-Source: ABdhPJylVGegWkkSA0YXLTmS35LbNL+nGjfJbkH+KHjlMdPQu/IG4VPB10tM6rOLC8rVBwrBWi1JCQ==
X-Received: by 2002:a05:6a00:1906:b0:44c:b35d:71a8 with SMTP id y6-20020a056a00190600b0044cb35d71a8mr60181918pfi.51.1636122510325;
        Fri, 05 Nov 2021 07:28:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id fw21sm9722729pjb.25.2021.11.05.07.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 07:28:29 -0700 (PDT)
Date:   Fri, 5 Nov 2021 14:28:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: nVMX: Track whether changes in L0 require
 MSR bitmap for L2 to be rebuilt
Message-ID: <YYU/iQCQJosjTKVs@google.com>
References: <20211013142258.1738415-1-vkuznets@redhat.com>
 <20211013142258.1738415-4-vkuznets@redhat.com>
 <YYSDbljJgpEOnx+W@google.com>
 <875yt6lscj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yt6lscj.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 05, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Oct 13, 2021, Vitaly Kuznetsov wrote:
> >> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> >> index 592217fd7d92..2cdf66e6d1b0 100644
> >> --- a/arch/x86/kvm/vmx/vmx.h
> >> +++ b/arch/x86/kvm/vmx/vmx.h
> >> @@ -148,6 +148,15 @@ struct nested_vmx {
> >>  	bool need_vmcs12_to_shadow_sync;
> >>  	bool dirty_vmcs12;
> >>  
> >> +	/*
> >> +	 * Indicates whether MSR bitmap for L2 needs to be rebuilt due to
> >> +	 * changes in MSR bitmap for L1 or switching to a different L2. Note,
> >> +	 * this flag can only be used reliably in conjunction with a paravirt L1
> >> +	 * which informs L0 whether any changes to MSR bitmap for L2 were done
> >> +	 * on its side.
> >> +	 */
> >> +	bool msr_bitmap_force_recalc;
> >
> > Belated bikeshedding...  What about need_msr_bitmap_recalc to follow the above
> > need_vmcs12_to_shadow_sync?
> >
> 
> 'msr_bitmap_force_recalc' was suggested by Paolo but
> 'need_msr_bitmap_recalc' sounds equally good to me.

Ah, actually, Paolo's is better.  "!need" implies that the recalc can be skipped
regardless of any other behavior, whereas "!force" provides the hint that a recalc
may still be needed for other reasons.

Can we move the "force" to the front though, i.e. force_msr_bitmap_recalc?  The
other fields in nested_vmx all have the verb at the front.

	bool need_vmcs12_to_shadow_sync;
	bool need_sync_vmcs02_to_vmcs12_rare;
	bool change_vmcs01_virtual_apic_mode;
	bool reload_vmcs01_apic_access_page;
	bool update_vmcs01_cpu_dirty_logging;
