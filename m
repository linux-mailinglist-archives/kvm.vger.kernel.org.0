Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18394534232
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 19:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245667AbiEYRcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 13:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238126AbiEYRce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 13:32:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F80AE273
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:32:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so2260209pju.1
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uKOzhX8ru6YupzPPVUW9G2G9XsQPjTP3RBRMRT4HCrs=;
        b=FyAccB0oXpEBuBOxcmix4vQsWmUhUjnf8be7oMXpDUvwUENkgP2x52FT40EnpIwaDw
         fr7MQg1gH5pfpoKEKmgLmSRpwRlAPv8uoNHjnRignSUoOSY63W//VWSR9MNj3WEMZl9/
         r2TUYrBLGdbL31Kf1hstHdiIZU1+LVMfCtS1w/GwV0Mal1LlQSx4qu6gSfpjnoR4D23Z
         MLyKNO6dX/cfK0OfvmedVYFnTH464/YqGeh4FOr7MpVuPDU/EZ0wGow3LN2QFt69oqYc
         y6DbaDylpoEwuA6Rjyra8npsj12P/Mg+qEJDmSTLh/PY8OhbUdTB0Mry8fiSV0LD/08Z
         HKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uKOzhX8ru6YupzPPVUW9G2G9XsQPjTP3RBRMRT4HCrs=;
        b=mt5he2IeaO1mzZO2p1/BUSJRNxuPC9SN18EYrDdasKCWrbK53ZhsPJBbo+2XzhVEci
         N9PmiK8r55mJ0L4728hU8ls0K5zuWTQHLp6OS4+YCL3hGqzztQ9tvculEaWy4UttImUQ
         DQzELphmht9OtZ+BvFZlK232lKdXrr3oyKlsEuiijswE5GoFho+zjsiZ2v1rizWJDigq
         GhbBeHqWCGwPLBGDkehEVwG/d3Yr4/8SJDuInJ+q+2Cl4HBhOK9m2ZhvOwYohzZe9BeB
         VD2utw0uwYoPUzIHbxvE1E4uYmqe+t+eI5UKIFBH+uyCKUOvF21oT3hmBApVHzIzwyCg
         9V/A==
X-Gm-Message-State: AOAM533Yc/k/rYxDFG8hIeRgMFN2sOfxItGZpNrPZXQFdQ3+7VG4jstm
        jbEtXpZEk1cR8z12SIVFEQRJJA==
X-Google-Smtp-Source: ABdhPJymqelJmqXaqJ5lvTkskc43UEh4IL2o064fxrk4cTDYfPDuhIiWfzubPs2mkHTO8lG7+q28zQ==
X-Received: by 2002:a17:90a:5ae1:b0:1db:d0a4:30a4 with SMTP id n88-20020a17090a5ae100b001dbd0a430a4mr11701841pji.128.1653499952316;
        Wed, 25 May 2022 10:32:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902a9c600b001624dab05edsm3506026plr.8.2022.05.25.10.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:32:31 -0700 (PDT)
Date:   Wed, 25 May 2022 17:32:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Message-ID: <Yo5oLAzdYurlMQFm@google.com>
References: <20220520204115.67580-1-jon@nutanix.com>
 <Yo5hmcdRvE1UrI4y@google.com>
 <3C8F5313-2830-46E3-A512-CFA4A24C24D7@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3C8F5313-2830-46E3-A512-CFA4A24C24D7@nutanix.com>
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

On Wed, May 25, 2022, Jon Kohler wrote:
> > On May 25, 2022, at 1:04 PM, Sean Christopherson <seanjc@google.com> wrote:
> > the code.  Again, it's all about whether eIBRS is advertised to the guest.  With
> > some other minor tweaking to wrangle the comment to 80 chars...
> 
> RE 80 chars - quick question (and forgive the silly question here), but how are you
> counting that? I’ve got my editor cutting at 79 cols, where tab size is accounted
> for as 4 cols, so the longest line on my side for this patch is 72-73 or so.

Tabs are 8 cols in the kernel.  FWIW, your patch was totally fine with respect to
wrapping, my comment was purely to give the heads up that I arbitrarily tweaked
other bits of the comment to adjust for my suggested reword.

> These also pass the checkpatch.pl script as well, so I just want to make sure
> going forward I’m formatting them appropriately.

For future reference, checkpatch.pl only yells if a line length exceeds 100 chars.
The 80 char limit is a soft limit, with 100 chars being a mostly-firm limit.
checkpatch used to yell at 80, but was changed because too many people were
interpreting 80 chars as a hard limit and blindly wrapping code to make checkpatch
happy at the cost of yielding less readable code.

Whether or not to run over the soft limit is definitely subjective, just try to
use common sense.  E.g. overflowing by 1-2 chars, not a big deal, especially if
the statement would otherwise fit on a single line, i.e. doesn't already wrap.

A decent example is the SGX MSRs, which allows the SGX_LC_ENABLED check to run
over a little, but wraps the data update.  The reasoning is that

		if (!msr_info->host_initiated &&
		    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
		    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
		    !(vmx->msr_ia32_feature_control & FEAT_CTL_SGX_LC_ENABLED))))
			return 1;

is much more readable than 

		if (!msr_info->host_initiated &&
		    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
		    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
		    !(vmx->msr_ia32_feature_control &
		      FEAT_CTL_SGX_LC_ENABLED))))
			return 1;

but this

		vmx->msr_ia32_sgxlepubkeyhash
			[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;

is only isn't _that_ much worse than running the line way out, and ~93 chars gets
to be a bit too long.

		vmx->msr_ia32_sgxlepubkeyhash[msr_index - MSR_IA32_SGXLEPUBKEYHASH0] = data;
