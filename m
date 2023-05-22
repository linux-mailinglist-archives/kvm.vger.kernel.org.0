Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E6070C4BD
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 19:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjEVR6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 13:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjEVR6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 13:58:19 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F61C103
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:58:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d138bd759so2883519b3a.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684778296; x=1687370296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EPy6ysi4yXV+mVmWOpkoIos7NdQ+ux7cZDKpxCd81ng=;
        b=znDrwM/LSqXebEc86YrxqhHfPNY3wKmkg/7qRdKtx15BL42YQtrdRlCv28s621PeUA
         9sz81yfg0uvodeNonJsknFgKOeoCiAdJjw9+xA3GUg/DKdxghtYAbR24+JeTENXJBPuT
         Ou3HSgUap4ERgD04nO95Y1fw1E2dfFqDN46KAQixR/Eha5ClrewWK35wSNZyODBXtrzq
         edDu7Zxb1j8B2+PxVzRFtDAKPRJ+PONNle3rpgBWFJa9gKi9O3TjcthvxK32PvRG9gfR
         6wtaklWWVv+KSUTEpZquAj7rpxoRNm7V19oQp6GWmQRaKFnrj1hhs0KRdt5+Uq4TNVzC
         Djyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684778296; x=1687370296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPy6ysi4yXV+mVmWOpkoIos7NdQ+ux7cZDKpxCd81ng=;
        b=YQHeWbFzW3M8/HX1qio6QyNdpix4OpZ0IXNOw+SNekANX15dKMXKPMi6ULOLFtiI6b
         SIvF/7sJiD/NCS2mZZ344JKW7oi16hCdMNcDf0rWcUaya4L1b2rxjIL02HJnGp2l5KYa
         OL5aUAz4rqzMEPJ8PnwaFP5OBk34W/i2bt+KFk+ftWIb3bb9Vdl6ZhqlcCkigbOykYPo
         i88hEQiEnoJoFSXJWrehcOWUc/K0Guf3xac/wal88nAKikUvSU68FglrlcaK3aY+NIdC
         RRCgCwsyJ9KK4IpnZ/Frc96gQ7mD2/0OgMncD5G5uUSydsjca/7JGaFyN6yODVhbzzam
         qS4g==
X-Gm-Message-State: AC+VfDxfBhWoK92F0++ExLscG8F+21bpuFDiUtxUNn9MpMS/xtwv+cvS
        Np2s3sTuIpMWG6sBcHCdVhjaJiK7VaI=
X-Google-Smtp-Source: ACHHUZ6VvDPFNVP7w4+ShbtfiVcVYndxJRNeUQu62zyqRddJVzqbpLBpXrLuE9YE7r0t4QWhvKnc7JCpHf0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:13a2:b0:63a:ff2a:bf9f with SMTP id
 t34-20020a056a0013a200b0063aff2abf9fmr5090898pfg.2.1684778296755; Mon, 22 May
 2023 10:58:16 -0700 (PDT)
Date:   Mon, 22 May 2023 10:58:15 -0700
In-Reply-To: <0f683245388e36917facbda4d0b69934fce7b0a8.camel@intel.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com> <20230512235026.808058-4-seanjc@google.com>
 <0f683245388e36917facbda4d0b69934fce7b0a8.camel@intel.com>
Message-ID: <ZGutN1cylVw7ICB9@google.com>
Subject: Re: [PATCH v3 03/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023, Kai Huang wrote:
> On Fri, 2023-05-12 at 16:50 -0700, Sean Christopherson wrote:
> > Use KVM VMX's reboot/crash callback to do VMXOFF in an emergency instead
> > of manually and blindly doing VMXOFF.  There's no need to attempt VMXOFF
> > if a hypervisor, i.e. KVM, isn't loaded/active, i.e. if the CPU can't
> > possibly be post-VMXON.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index fc9cdb4114cc..76cdb189f1b5 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -744,7 +744,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
> >  	return ret;
> >  }
> >  
> > -static void crash_vmclear_local_loaded_vmcss(void)
> > +static void vmx_emergency_disable(void)
> >  {
> >  	int cpu = raw_smp_processor_id();
> >  	struct loaded_vmcs *v;
> > @@ -752,6 +752,8 @@ static void crash_vmclear_local_loaded_vmcss(void)
> >  	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
> >  			    loaded_vmcss_on_cpu_link)
> >  		vmcs_clear(v->vmcs);
> > +
> > +	__cpu_emergency_vmxoff();
> 
> __cpu_emergency_vmxoff() internally checks whether VMX is enabled in CR4.  
> Logically, looks it's more reasonable to do such check before VMCLEAR active
> VMCSes, although in practice there should be no problem I think.
> 
> But this problem inherits from the existing code in  upstream, so not sure
> whether it is worth fixing.

Hmm, I think it's worth fixing, if only to avoid confusing future readers.  Blindly
doing VMCLEAR but then conditionally executing VMXOFF is nonsensical.  I'll tack on
a patch, and also add a comment to call out that CR4.VMXE can be _cleared_
asynchronously by NMI, but can't be set after being checked.  I.e. explain that
checking CR4.VMXE is a "best effort" sort of thing.
