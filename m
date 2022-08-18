Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE95598A4B
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344910AbiHRRV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 13:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbiHRRVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 13:21:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FBD48E80
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:20:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so2487666pjf.2
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=oxkIL7t6QF/08WGCg7LwevIs7IPtvy2DWZ/yQUzyzpw=;
        b=oT+xYcRJe+BsVSbihqkOFFsJHOzKLtYkEKpL4xy/l86phwOS/hn1nfDHoIBrWVL+w9
         yb4lD5vXPHhmw9hoIden1DXoX4ZswlfgFRk4JpVJC+Lmrg80cADPMJFkmxPktCzR4+ox
         5e/2+8r2fq0NiBtOgp6LWKEZPuRWXa3vwy+wCHnSgtkwXnl+F+c4aJpQ9412goyf2NXx
         0h+uV3o02Lr+qzjOrh8H5JI/OthbOr+dH/vIaFpJptjvcJebu87c3bewsBZOqFcxHRqi
         OUtEb2kgvtJ34aL4CLvE+S9TSacRrBrtc4zlGXufA0EikQNpSCCX7QapEQ05qZuBJQCf
         L1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oxkIL7t6QF/08WGCg7LwevIs7IPtvy2DWZ/yQUzyzpw=;
        b=ySGBs80Rs540IERTmjWGxQ5Awurv7tqQT744a+U5lKlLTy+Yd2QN/uJhS9Fps54X3o
         lvvijyrLV8Fzo8UoJthPRokH249qk4ExpTezYaygZZN0KKTOwkX551P48AAoxxhTugcZ
         fG2Q8ZGvqHuywSO5oh3yn4U+1ZMaviQDyZKVy9xIWkjeJ79+TML5BaWxuozUTdmMPNFJ
         7hhDek6/66HaXIjO8NZ+hGNh3zq6TjUp2WQVP3CRFH8g8TzFWcWMo3YuZQCbdWM/6DHk
         WZWlltIVqoquV6NBOEN2U3sU0gOIMBJSingcQexoBwF+qSE3LGs8MsueeotqIIUVta+q
         4LVg==
X-Gm-Message-State: ACgBeo077ih2HwV3J06EF2gARidhxNzKrSd1pXuV2YwCMH5VN7we5W2I
        CwRGleTaRnq+Q+cEU8q2uq2lZA==
X-Google-Smtp-Source: AA6agR7Rl/cE0F+L87ZcmO12psnHHsz5CQgapTnbh6BHn8bRtzBKIoh2Dmn5hldKJ5+/F+R/OjqLjg==
X-Received: by 2002:a17:902:efd2:b0:172:b0a5:fd79 with SMTP id ja18-20020a170902efd200b00172b0a5fd79mr3704461plb.87.1660843202321;
        Thu, 18 Aug 2022 10:20:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902ce0100b0016f04c098ddsm1624592plg.226.2022.08.18.10.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:20:01 -0700 (PDT)
Date:   Thu, 18 Aug 2022 17:19:57 +0000
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
Message-ID: <Yv50vWGoLQ9n+6MO@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802160756.339464-10-vkuznets@redhat.com>
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

On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index f886a8ff0342..4b809c79ae63 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -37,16 +37,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
>   *	EPTP_LIST_ADDRESS               = 0x00002024,
>   *	VMREAD_BITMAP                   = 0x00002026,
>   *	VMWRITE_BITMAP                  = 0x00002028,
> - *
> - *	TSC_MULTIPLIER                  = 0x00002032,
>   *	PLE_GAP                         = 0x00004020,
>   *	PLE_WINDOW                      = 0x00004022,
>   *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
> - *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
> - *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
> - *
> - * Currently unsupported in KVM:
> - *	GUEST_IA32_RTIT_CTL		= 0x00002814,

Almost forgot: is deleting this chunk of the comment intentional?

>   */
>  #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
>  				    PIN_BASED_VMX_PREEMPTION_TIMER)
