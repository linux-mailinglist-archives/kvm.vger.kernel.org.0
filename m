Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1881A632AD2
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 18:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiKURUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 12:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiKURTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 12:19:55 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80693D39EB
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:19:00 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q71so11739290pgq.8
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6eRZBGDIdbbq9qEGvVuNy8kXEqzsVLRSF+qgp5vgUO8=;
        b=WgKA2gNPMTazNZjE8OQZOHcA6LZD75wsUT5jr8Nis1NcAia7+INt91bOnVbHOQZZmQ
         SOHJ8kd8g3nzVjswgCKzRgrxNGttkw2Ao3r0ntVn25DJ9TPD/2VG8psKvY3UusWBgEBg
         MbPgThhotVjseSYey/ir+dHgGKFdC0Hyv5PSxI7oBD6wZfvkcVbmYB5J5R4l1DMFcSrl
         L+tiKq7d0f/cKy4hnsmN84hC6NuqgX81qytsDFkG/ayFiru+uhXTKpd+cuZ63UjKasYL
         X99C7Py5r1ejvF19zLeJQJwh68StE4QpQoOn8BLeG5i2qlgHp3A7jKsJ2wS4HXtcpyz4
         5EFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6eRZBGDIdbbq9qEGvVuNy8kXEqzsVLRSF+qgp5vgUO8=;
        b=X4imfJvRQ9eSSLi1/q5rk2sy4UY5p6pYmdUJhZbzu2MT70+xdBkfaD/3aRqgnJ1s2t
         AlNmT6ir3yzhCILpae6p81gv83/tBsCv+A0fn3iZbkvb1a5bxwqksqVn5cqscaazIZhT
         aF16bsZbuMzcArODIiSkrMdurbp0yum9L57toNBSUJqKUTQWsqz1cSiv0w4seU6h8wvS
         f4J2HrDnnaH7N70/U6aGScJtJYYWFDVCeAadqaBRIuHuWYGGqqJlv9e90cvmmZvpdmR4
         dekpQj6xIPJimJNduNnQM78VRXEN3Y1wRshV2B4hTYS1tGXhGiBC3BMLtnosdz1crqVD
         ZbYQ==
X-Gm-Message-State: ANoB5pnVxTCQhtaKO1251Dt+/oqr8NPE2hNubrntKNk1Y79RuoEOPpMg
        lfvw2RsxMJzJkxFRRN2YU4iQOw==
X-Google-Smtp-Source: AA0mqf6UbtOJWyPSSbxlcWPAqvLAbrsV8KdeveRYIEhwW1KycZzX12rmKKmP7aXQLAqvVYAdiPDyCw==
X-Received: by 2002:aa7:8d88:0:b0:562:69d4:f9f3 with SMTP id i8-20020aa78d88000000b0056269d4f9f3mr985874pfr.5.1669051139867;
        Mon, 21 Nov 2022 09:18:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id cu9-20020a17090afa8900b00209a12b3879sm8033740pjb.37.2022.11.21.09.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 09:18:59 -0800 (PST)
Date:   Mon, 21 Nov 2022 17:18:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 07/13] KVM: SVM: Add VNMI support in get/set_nmi_mask
Message-ID: <Y3uzAM3/XrUPRpgH@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-8-mlevitsk@redhat.com>
 <Y3aDTvglaSfhG8Tg@google.com>
 <4aadf4616e4f1c6219e7c83ee491494feefa78e1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4aadf4616e4f1c6219e7c83ee491494feefa78e1.camel@redhat.com>
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

On Mon, Nov 21, 2022, Maxim Levitsky wrote:
> On Thu, 2022-11-17 at 18:54 +0000, Sean Christopherson wrote:
> > E.g. with HF_NMI_MASK => svm->nmi_masked, the end result can be something like:
> > 
> > static bool __is_vnmi_enabled(struct *vmcb)
> > {
> >         return !!(vmcb->control.int_ctl & V_NMI_ENABLE);
> > }
> > 
> > static bool is_vnmi_enabled(struct vcpu_svm *svm)
> > {
> >         struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > 
> >         return vmcb && __is_vnmi_enabled(vmcb);
> > }
> > 
> > static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> > {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> >         struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > 
> >         if (vmcb && __is_vnmi_enabled(vmcb))
> >                 return !!(vmcb->control.int_ctl & V_NMI_MASK);
> >         else
> >                 return !!(vcpu->arch.hflags & HF_NMI_MASK);
> > }
> > 
> > static void svm_set_or_clear_vnmi_mask(struct vmcb *vmcb, bool set)
> > {
> >         if (set)
> >                 vmcb->control.int_ctl |= V_NMI_MASK;
> >         else
> >                 vmcb->control.int_ctl &= ~V_NMI_MASK;
> > }
> > 
> > static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
> > {
> >         struct vcpu_svm *svm = to_svm(vcpu);
> >         struct vmcb *vmcb = get_vnmi_vmcb(svm);
> > 
> >         if (vmcb && __is_vnmi_enabled(vmcb)) {
> >                 if (masked)
> >                         vmcb->control.int_ctl |= V_NMI_MASK;
> >                 else
> >                         vmcb->control.int_ctl &= ~V_NMI_MASK;
> >         } else {
> >                 svm->nmi_masked = masked;
> >         }
> > 
> >         if (!masked)
> >                 svm_disable_iret_interception(svm);
> > }
> 
> OK, this is one of the ways to do it, makes sense overall.
> I actualy wanted to do something like that but opted to not touch
> the original code too much, but only what I needed. I can do this
> in a next version.

After looking at more of this code, I think having get_vnmi_vmcb() is a mistake.
It just ends up being a funky wrapper to the current svm->vmcb.  And the manual
check on the "vnmi" global is pointless.  If KVM sets V_NMI_ENABLE in any VMCB
when vnmi=false, then that's a KVM bug.

Dropping the wrapper eliminates the possibility of a NULL VMCB pointer, and IMO
yields far more readable code.


static bool is_vnmi_enabled(struct vcpu_svm *svm)
{
	return !!(svm->vmcb->control.int_ctl & V_NMI_ENABLE);
}

static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	if (is_vnmi_enabled(svm))
		return !!(svm->vmcb->control.int_ctl & V_NMI_MASK);
	else
		return !!(vcpu->arch.hflags & HF_NMI_MASK);
}

static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	if (is_vnmi_enabled(svm)) {
		if (masked)
			svm->vmcb->control.int_ctl |= V_NMI_MASK;
		else
			svm->vmcb->control.int_ctl &= ~V_NMI_MASK;
	} else {
		svm->nmi_masked = masked;
	}

	if (!masked)
		svm_disable_iret_interception(svm);
}
