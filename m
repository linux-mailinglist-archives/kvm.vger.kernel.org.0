Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665CF4CC33A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiCCQwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiCCQwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:52:01 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25F519D766
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:51:15 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t5so5166601pfg.4
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i0NlVOGrDQifCYycNaZxtwsr4XCCtmhTO2N4TMD4zDA=;
        b=DpMrVHXRF13GOLQoAJSmaXRO6X88jSxHL2yXyRc+YhWTaODZ2m8/gJSlYQl5ON/2+4
         Dxr8uHQ/7XsYc04QWUVBuxXHWjjwSaPnnLR541yMC8WTH+ytjjmp0KVvoi14ZH/6UqDs
         dGmHHl4pvPgin5+lMoe5nDvOfurIIyvALCBBpCwpa+Sm8MK8E9UKpHCKkB3zcHv9pUDi
         RNDCEMblLNxKk/6XD+CJQ/2w9vbxS6ZA0sGXnL6KCEPy3w1Nafqj519gl5mC5xD+TWFn
         G6fJY03umHtFNfg+9RoO8JpgoIHuFtnZ7PP2q5ENUi2OWyH0Q25wJ+pvWMKnyQ8xqJEe
         YcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i0NlVOGrDQifCYycNaZxtwsr4XCCtmhTO2N4TMD4zDA=;
        b=Q16VTIUqv5dU+ED1dk37cmaU4yrU/iniue5y3p/88jjRHODYsBtkkGDXeBHXjFvifY
         0/m6xquW8NBUzaoWdsIwhbkxX2NdHbjCf+PJBfDAKQWpEkNiJMe835Dyqf5PG8y8syPM
         5pHjak2Ks2zfWqvdpNXM2ymT0Hw//86hgzkOetZgJE/fYJcvVrFf8gueHEfB70LxdfcB
         991ijvq6f3GaTiPuZAdDoMzWEIy/gG3ko4p/KevUnYdfW4iArxDCzN04LdgEYtLtbylE
         49wEU25xAnCALhDUgr5wNdlsvsDTWc0F9pjck/cHUH0lUzSuQhPvS8Iybuzfi+OeLTwt
         rDUw==
X-Gm-Message-State: AOAM531Vp1Cii/GUSO8cZ98HNiikOLIUcolxnvOsOt8r3BNU67VPtcA8
        DsghCjOJV1RZ8V73FaJz75gOPg==
X-Google-Smtp-Source: ABdhPJxboDeeuaLxiKyqoWZz04F4zeJp+hWhJ2RpVpmGe2GaHnwrZfIp4rqtg26ySpbEKFhBVpbHuQ==
X-Received: by 2002:a05:6a00:a8b:b0:4e1:52db:9e5c with SMTP id b11-20020a056a000a8b00b004e152db9e5cmr38878422pfl.38.1646326275016;
        Thu, 03 Mar 2022 08:51:15 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c9-20020a634e09000000b003790829fbc1sm2496767pgb.53.2022.03.03.08.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 08:51:14 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:51:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default apic
 id when not using x2apic api
Message-ID: <YiDx/uYAMSZDvobO@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-5-mlevitsk@redhat.com>
 <Yh5QJ4dJm63fC42n@google.com>
 <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
 <Yh5b3eBYK/rGzFfj@google.com>
 <297c8e41f512587230a54130a71ddfd9004c9507.camel@redhat.com>
 <eae0b69fb8f5c47457fac853cc55b41a30762994.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eae0b69fb8f5c47457fac853cc55b41a30762994.camel@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Maxim Levitsky wrote:
> When APIC state is loading while APIC is in *x2apic* mode it does enforce that
> value in this 0x20 offset is initial apic id if KVM_CAP_X2APIC_API.
>  
> I think that it is fair to also enforce this when KVM_CAP_X2APIC_API is not used,
> especially if we make apic id read-only.

I don't disagree in principle.  But, (a) this loophole as existing for nearly 6
years, (b) closing the loophole could break userspace, (c) false positive are
possible due to truncation, and (d) KVM gains nothing meaningful by closing the
loophole.

(d) changes when we add a knob to make xAPIC ID read-only, but we can simply
require userspace to enable KVM_CAP_X2APIC_API (or force it).  That approach
avoids (c) by eliminating truncation, and avoids (b) by virtue of being opt-in.
