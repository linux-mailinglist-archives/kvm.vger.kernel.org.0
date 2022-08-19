Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC7F599DCA
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349524AbiHSOtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 10:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349414AbiHSOtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 10:49:41 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF48D8E28
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 07:49:40 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 20so4324262plo.10
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 07:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uRT1dfCACycQqNXmcC8HP5/+bX38g4rLbOY9bQx0QKs=;
        b=ish7ZOCTD7n29s4ja2n6fBm1QfHXkE6KMyKyZs+QOfQm6L8DM4YqFjCS8viMyjsnBc
         5C69v5tlpeq8PhzwvJPyE9sb8Na2PrLboUSwEanyMCE6KOUfJ84ydT2evoNQWH9K0tyq
         yw0rApG1TdNwk/NZeTAXFkhViMu/9mPt0XKnJDRQYWv2LhQfRG767bGCjxcW0P8uxpIQ
         EFRNGyzsBI2P+z756RV1YpPzHCb8dsf3iVV8SuIf77mfBn5Gq7JY9BkLtbWMend+Qx5+
         Q3svzgWq7R5mfkCpgGdT8xI/JSwO753FEbKO0Iov3H45k+GT9JVGquxSsRnJCzlf6tKS
         pqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uRT1dfCACycQqNXmcC8HP5/+bX38g4rLbOY9bQx0QKs=;
        b=vjz/L5nLx/DDLx2M3cXw4BaaHp0qHQPD7X/d8SR+HqolseZlMqJc6dwqLShulkBei/
         e0uYW/HFCY4UerDktFBaHMoPql00O4E41ptO44jcS3AnjJvnE61LJM5iacuxudIHNSSi
         BzqmSDH+VKVd7DQrjOvjqdciPX71attsy6kD3HU7ueeCvChgm3uA5lO5GV+AlsgruVBv
         Y5dMvXnBAlBJ7z1f64N5t9CIuGnDqDjlozCPh+aUE6JLgbRZyb2pxWlRvHlB4lMoOrJl
         XNh/pCegvhB8f86DNC3Znki+ums7k1MTQ0jloh31cYiH0DJPEzH9YPcfadCF4EiX0duc
         utlA==
X-Gm-Message-State: ACgBeo3zynUVzviEQoT+s0SnRnsFXayvHNwSJrtCnvQRr4Nd7jdAXoTO
        KAZqp9HbYZJkj00+YRLAnTg1ZBJG/E1lVA==
X-Google-Smtp-Source: AA6agR6Ni20ut6dVdgRtMYnrfm3+VwwBk3uL3D6coMcgFeqx4bqlmxKgg8G9I3PPvhuYPCPAwCO2VA==
X-Received: by 2002:a17:90a:e7cc:b0:1f7:26c9:ee9f with SMTP id kb12-20020a17090ae7cc00b001f726c9ee9fmr8865506pjb.75.1660920579765;
        Fri, 19 Aug 2022 07:49:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h9-20020aa796c9000000b005360813cabasm1581787pfq.69.2022.08.19.07.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 07:49:39 -0700 (PDT)
Date:   Fri, 19 Aug 2022 14:49:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <Yv+i/wuObvLf7QZE@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
 <Yv50vWGoLQ9n+6MO@google.com>
 <87zgg0smqr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgg0smqr.fsf@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> >> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> >> index f886a8ff0342..4b809c79ae63 100644
> >> --- a/arch/x86/kvm/vmx/evmcs.h
> >> +++ b/arch/x86/kvm/vmx/evmcs.h
> >> @@ -37,16 +37,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
> >>   *	EPTP_LIST_ADDRESS               = 0x00002024,
> >>   *	VMREAD_BITMAP                   = 0x00002026,
> >>   *	VMWRITE_BITMAP                  = 0x00002028,
> >> - *
> >> - *	TSC_MULTIPLIER                  = 0x00002032,
> >>   *	PLE_GAP                         = 0x00004020,
> >>   *	PLE_WINDOW                      = 0x00004022,
> >>   *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
> >> - *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
> >> - *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
> >> - *
> >> - * Currently unsupported in KVM:
> >> - *	GUEST_IA32_RTIT_CTL		= 0x00002814,
> >
> > Almost forgot: is deleting this chunk of the comment intentional?
> >
> 
> Intentional or not (I forgot :-), GUEST_IA32_RTIT_CTL is supported/used
> by KVM since
> 
> commit f99e3daf94ff35dd4a878d32ff66e1fd35223ad6
> Author: Chao Peng <chao.p.peng@linux.intel.com>
> Date:   Wed Oct 24 16:05:10 2018 +0800
> 
>     KVM: x86: Add Intel PT virtualization work mode
> 
> ...
>  
> commit bf8c55d8dc094c85a3f98cd302a4dddb720dd63f
> Author: Chao Peng <chao.p.peng@linux.intel.com>
> Date:   Wed Oct 24 16:05:14 2018 +0800
> 
>     KVM: x86: Implement Intel PT MSRs read/write emulation
> 
> but there's no corresponding field in eVMCS. It would probably be better
> to remove "Currently unsupported in KVM:" line leaving
> 
> "GUEST_IA32_RTIT_CTL             = 0x00002814" 
> 
> in place. 

GUEST_IA32_RTIT_CTL isn't supported for nested VMX though, which is how I
interpreted the "Currently unsupported in KVM:".  Would it be accurate to extend
that part of the comment to "Currently unsupported in KVM for nested VMX:"?
