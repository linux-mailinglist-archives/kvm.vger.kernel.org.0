Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F984EE44C
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 00:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242633AbiCaWnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 18:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242603AbiCaWnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 18:43:11 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C71215911
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:41:23 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id bc27so911787pgb.4
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 15:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wzx4h3J831JsKYMNZGvkQ7llH9BK5twqJrLQ0USMFVk=;
        b=Xtf7XTzhWR7t6NfeN54sWEY1W81DT0Gvy7A/N6JbR+VzgSteQDCd+Eugmmt6WCB6+P
         E+XQ0MaZx6Lj2Ys2HNhcglwFGBUo9wqKD0Dvgrsl59FE1qIX2xpGOID432kT3n9a93aV
         d83ZRxxrHb0yEb09xo36wb0eYO5yAIZO+lZUgddfw0XJUNEso3gcGu7PIWjpiHkMpH8D
         du/IZ88kpi+3TI64iacCrGrfWOQ6B+xi71Vb73/2RvnVNaWVfYrQmx0FkxVXIIyJCi9Q
         B79APqR3zMtDg6/y7UaP/fzHKU/waClPQQwtxbc0N28zAK9q39hW2B0SYMexRs6sGEAB
         XMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wzx4h3J831JsKYMNZGvkQ7llH9BK5twqJrLQ0USMFVk=;
        b=cFA9KoFSKxUDJphdDDlLFRhkv000sw+Prh07hpQBJ9UCFfufH4cRal1Tbdi8BS0VoI
         dpMG3SmKH9GU/XB+UqFaZdf+OvLW6RGtf6oZVj106PoELplUc22E2Bnhxi0gFr87kBM4
         uUFxWl/FacUlQxeOt0s+qYnfhlkxENIGim/Yq8EjsKuzk5Iems45EgWecf7YabL1EHXY
         j1Hc0bw/fKVnODWoDuRSYIGnZ/RNAwd9AMD4U3LcnG55HZ6rdsIlqG6dzfT59da38juw
         Q9Qa9KCiPWtWFa3AKziJs3TdxeNLRLmNaxRbZmH8eq7IEIbj2NUaoVK3nXfre6cLUp5z
         rcKA==
X-Gm-Message-State: AOAM533tc8+o8y9LhCs2xWW/7oEA4B8iQzXrsYPd+Fbvg5IOPa113GOD
        edu7X/dbZyUh+2ItcS8wqFBigNrfC02SQg==
X-Google-Smtp-Source: ABdhPJxL82J4VYKL/M6pm3nZqC+OeNw+8EDVWpdCQZQ602X+PjVzW1QMB5xJ6HUvY3y5dvW5D5bQDg==
X-Received: by 2002:a63:4005:0:b0:373:9ac7:fec1 with SMTP id n5-20020a634005000000b003739ac7fec1mr12512800pga.12.1648766482539;
        Thu, 31 Mar 2022 15:41:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f6519ce666sm508170pfi.170.2022.03.31.15.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:41:21 -0700 (PDT)
Date:   Thu, 31 Mar 2022 22:41:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 3/8] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
Message-ID: <YkYuDo3hOmcwA1iF@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-4-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304080725.18135-4-guang.zeng@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Zeng Guang wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c569dc2b9192..8a5713d49635 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2422,6 +2422,21 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>  	return 0;
>  }
>  
> +static __init int adjust_vmx_controls_64(u64 ctl_min, u64 ctl_opt,

I slightly prefer controls64 over controls_64.  As usual, KVM is inconsistent as
a whole, but vmcs_read/write64 omit the underscore, so we can at least be somewhat
consistent within VMX.

> +					 u32 msr, u64 *result)
> +{
> +	u64 allowed1;
> +
> +	rdmsrl(msr, allowed1);
> +
> +	/* Ensure minimum (required) set of control bits are supported. */
> +	if (ctl_min & ~allowed1)

Eh, just drop @ctl_min.  Practically speaking, there is zero chance tertiary
controls or any other control of this nature will ever be mandatory.  Secondary
controls would fall into the same boat, but specifying min=0 allows it to share
helpers, so it's the lesser of evils.

With the error return gone, this can be

  static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
  {
	u64 allowed;

	rdmsrl(msr, allowed);

	return ctl_opt & allowed;
  }

Alternatively, we could take the control-to-modify directly and have no return,
but I like having the "u64 opt = ..." in the caller.
