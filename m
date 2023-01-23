Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C6E6785A6
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 20:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAWTAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 14:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjAWTAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 14:00:51 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F88C1716
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:00:50 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z13so12385482plg.6
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YRKDiD8yk6UzOY/88nYqL2GqYUybU1/pZpM7K8+xke8=;
        b=BWLbKerSlobHaylN1IKXrU1WcSHG764kfCeOLzcsg1JrGhTVW5jN+sI1fkkKM7mojG
         AxGfLFjjhq1xGkIGei698W7dGqanVwYWteHjayHXPlAKQ837wFyq00gO7IHks2vYeD8G
         kUfGCyU4Zz48ffCEbVyrHhfdRVN4KQD5yf6HUIsroGJKoEBpym1EC82xHt2xdeNQ759/
         EB+jKXmW34F3panq1WaQKIBOZAXhvkoUPCPikdcv/yTm5Glp3ulSN5htfip6Xelku3NA
         gRmtG6Iq6+YRT7NIMZSgpteD36qXfJWR5XP366VV2QcGllHX3YzizMCxBKbuleWnMyq1
         a0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRKDiD8yk6UzOY/88nYqL2GqYUybU1/pZpM7K8+xke8=;
        b=d1b1WNs5r8sxzJQxR5p8lB8/0+cTX1LmIEvl2A1G5mf9QBC/9Q7cBiOTAdBC2jhEHE
         9QUpe4JEjs8T0YCGUjznoWqxCoMzwl8O2pM7zj7DSfvTSixR9b6pH10SJgjr9yr5f9zf
         eHeBGlMikoGNRLXAq3gEKzaXDvs6ElNTcsOLqhLQnjXYrjgSNs9WzSt4g3bxnExcO/be
         n2V/DrIDZz5A2MT9EeT8kA0r0xGTG9LboMsIxX8N413R4rU6fFc+8gddIWNYIO/PNjTh
         xOixOpRHYyX+eAGsLQpBs89Tt+9okuqqwJuohSx1jc59Xwhey6zMd3YjvUUlhcZTDaXx
         sxpw==
X-Gm-Message-State: AFqh2koKr9hPS8+kJ+3m6u5+fd+SO+D0GpW9xdZDkIbofBTy2+6aYLCV
        96cRPP7Wg3BGOgy+s+xn1Qwd1Q==
X-Google-Smtp-Source: AMrXdXvhUfv5zqb5mbH+a9tDvD1eSRTtUQzRMPQYkqu8PfAvK7dW2CVM3Kne9MLQXQUor+vIwdpUPA==
X-Received: by 2002:a17:903:503:b0:189:b910:c6d2 with SMTP id jn3-20020a170903050300b00189b910c6d2mr626020plb.1.1674500449485;
        Mon, 23 Jan 2023 11:00:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jm13-20020a17090304cd00b001933b4b1a49sm34970plb.183.2023.01.23.11.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:00:49 -0800 (PST)
Date:   Mon, 23 Jan 2023 19:00:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Alexandru Matei <alexandru.matei@uipath.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v3] KVM: VMX: Fix crash due to uninitialized current_vmcs
Message-ID: <Y87ZXRBfY9RThKHT@google.com>
References: <20230123162929.9773-1-alexandru.matei@uipath.com>
 <878rhtchjo.fsf@ovpn-194-126.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rhtchjo.fsf@ovpn-194-126.brq.redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023, Vitaly Kuznetsov wrote:
> Alexandru Matei <alexandru.matei@uipath.com> writes:
> 
> > KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> > a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> > evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> > that the msr bitmap was changed.

...

> > @@ -219,7 +223,7 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
> >  static inline u32 evmcs_read32(unsigned long field) { return 0; }
> >  static inline u16 evmcs_read16(unsigned long field) { return 0; }
> >  static inline void evmcs_load(u64 phys_addr) {}
> > -static inline void evmcs_touch_msr_bitmap(void) {}
> > +static inline void evmcs_touch_msr_bitmap(struct hv_enlightened_vmcs *evmcs) {}
> >  #endif /* IS_ENABLED(CONFIG_HYPERV) */
> >  
> >  #define EVMPTR_INVALID (-1ULL)
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index fe5615fd8295..1d482a80bca8 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3869,7 +3869,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
> >  	 * bitmap has changed.
> >  	 */
> >  	if (static_branch_unlikely(&enable_evmcs))
> > -		evmcs_touch_msr_bitmap();
> > +		evmcs_touch_msr_bitmap((struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs);
> >  
> >  	vmx->nested.force_msr_bitmap_recalc = true;
> >  }
> 
> Just in case we decide to follow this path and not merge
> evmcs_touch_msr_bitmap() into vmx_msr_bitmap_l01_changed():

This is the only approach that I'm outright opposed to.  The evmcs_touch_msr_bitmap()
stub is a lie in that it should never be reached with CONFIG_HYPERV=n, i.e. should
really WARN.  Ditto for the WARN_ON_ONCE() in the actual helper; if vmx->vmcs01.vmcs
is NULL then KVM is completely hosed.

KVM already consumes hv_enlightenments_control.msr_bitmap in vmx.c and in nested.c,
shoving this case into hyperv.h but leaving those in VMX proper is odd/kludgy.
