Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1639E502C02
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 16:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354565AbiDOOiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 10:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiDOOiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 10:38:21 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BB050E0F
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:35:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id k14so7439054pga.0
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 07:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5CJKuH7khF1y3DizoabvaS6odECAtRFkcRZfxb+4uoM=;
        b=eVIE5dV1M83IQmQu3BKM+cGuaxyk8PaG6cAjk96I2yBD3kYCMUhK85oHRfsWEVHNuy
         CX2nRUI6Q+D0RuUb61rnfe0/YeUKnil8pDz34ySN+2gO+D4JxGC4+3TDi1WqLQyHyRgp
         8S2R9haf472bv/J995Ch9pE9tcdEgz1hwsPKjtNGc/l/koy4kOqnBYQH3TebTU40jLiR
         r7rHZStdDWvNSxILsuSov8AddPbZrC/5CmEmhcDBcOIQ6HZYDNKMM+v2binSPPAgP2id
         e4Zmn6SDnDMvbxvf5XUNnF9ib9ov21ZTT8UHyKRXFl0XwYWqwa9OzVdgq6xYqJKOHvvQ
         4CYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5CJKuH7khF1y3DizoabvaS6odECAtRFkcRZfxb+4uoM=;
        b=at3iYPWPYCWnH+kV7wAoNmBLQeu6FEvFWdbhO9ahO2Y4td4KUGM+AaWBW8SdKexG52
         BCbYcTHd31MCQMZzsIOyf33VsP98c5wo98E6ST3yY5iJ8OLo2WjDfngxgY3x2Jnqk6O2
         eH0a6bo+CIsIuxdvpwA5EyFz06y+HoXfrXwsncfgPiEI6vYlAx1z8kVHeYdqWPijgcBQ
         n1T2lcE1kyZbLsvn64wtpntzdvBgLJuPEi2cleeevGdYg9YK3nzMVvRg3yHyLZTzVSR0
         zRrv7ObHsx7hPOWYFpCgejl+BJzz8g+X/+KByQWBrKP7xQP1N96ubxgKaAdw0IGAodYj
         hbrw==
X-Gm-Message-State: AOAM531xSMLLb4xEzJMXrQCDLpK/Q8vxDlu5cDlEF8glG81c+hPCrNRy
        aCnc4TgHQ78GVe8jqfpUfMF2xQ==
X-Google-Smtp-Source: ABdhPJz7AGrSLCIpiI5vobjTwGztjseHVxY2LqnQac0HzghAh/fFbXTARvxvKsuq2VPwzQPY83nBAA==
X-Received: by 2002:a65:480a:0:b0:39c:c745:6f59 with SMTP id h10-20020a65480a000000b0039cc7456f59mr6432618pgs.33.1650033352643;
        Fri, 15 Apr 2022 07:35:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090a1f4f00b001c7ecaf9e13sm5045100pjy.35.2022.04.15.07.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 07:35:51 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:35:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v7 8/8] KVM: VMX: enable IPI virtualization
Message-ID: <YlmCxOcWvbXzaYpw@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-9-guang.zeng@intel.com>
 <YkZlhI7nAAqDhT0D@google.com>
 <54df6da8-ad68-cc75-48db-d18fc87430e9@intel.com>
 <YksxiAnNmdR2q65S@google.com>
 <b8f753b0-1b57-3e42-3516-27cc0359c584@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8f753b0-1b57-3e42-3516-27cc0359c584@intel.com>
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

On Sat, Apr 09, 2022, Zeng Guang wrote:
> 
> On 4/5/2022 1:57 AM, Sean Christopherson wrote:
> > On Sun, Apr 03, 2022, Zeng Guang wrote:
> > > On 4/1/2022 10:37 AM, Sean Christopherson wrote:
> > > > > @@ -4219,14 +4226,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> > > > >    	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
> > > > >    	if (cpu_has_secondary_exec_ctrls()) {
> > > > > -		if (kvm_vcpu_apicv_active(vcpu))
> > > > > +		if (kvm_vcpu_apicv_active(vcpu)) {
> > > > >    			secondary_exec_controls_setbit(vmx,
> > > > >    				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
> > > > >    				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> > > > > -		else
> > > > > +			if (enable_ipiv)
> > > > > +				tertiary_exec_controls_setbit(vmx,
> > > > > +						TERTIARY_EXEC_IPI_VIRT);
> > > > > +		} else {
> > > > >    			secondary_exec_controls_clearbit(vmx,
> > > > >    					SECONDARY_EXEC_APIC_REGISTER_VIRT |
> > > > >    					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> > > > > +			if (enable_ipiv)
> > > > > +				tertiary_exec_controls_clearbit(vmx,
> > > > > +						TERTIARY_EXEC_IPI_VIRT);
> > > > Oof.  The existing code is kludgy.  We should never reach this point without
> > > > enable_apicv=true, and enable_apicv should be forced off if APICv isn't supported,
> > > > let alone seconary exec being support.
> > > > 
> > > > Unless I'm missing something, throw a prep patch earlier in the series to drop
> > > > the cpu_has_secondary_exec_ctrls() check, that will clean this code up a smidge.
> > > cpu_has_secondary_exec_ctrls() check can avoid wrong vmcs write in case mistaken
> > > invocation.
> > KVM has far bigger problems on buggy invocation, and in that case the resulting
> > printk + WARN from the failed VMWRITE is a good thing.
> 
> SDM doesn't define VMWRITE failure for such case.

Yes it absolutely does.  cpu_has_secondary_exec_ctrls() checks if the VMCS field
_exists_, not if it's being used by KVM (though that's a moot point since KVM
always enables secondary controls when it's supported).  VMWRITE to non-existent
fields cause VM-Fail.

  ELSIF secondary source operand does not correspond to any VMCS field
  THEN VMfailValid(VMREAD/VMWRITE from/to unsupported VMCS component);
