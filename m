Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CAA4F65B9
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237706AbiDFQfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiDFQe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:34:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B041FD1B
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 18:48:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m16so700951plx.3
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 18:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tUE3dxQm/ksTxTn0YMfdCief23RhMLZPJwxq1FLJlMc=;
        b=VDD6vs6I4ZQlRu9OeS2u6w2N8sFH2qI9RbfYFDtXvg9XdFfZxICldOMoE7yokycFxh
         yuQyWgSPIAK+HELV4CSopTWMPJFA4XXa6j+0duIyjmxDyTV/2aQhlNB37qiN6edt+A+l
         YKf4BLcWUI+o1ieTRXp19Q8G55/hJgpwrrR8fcNKpbsWe3NA7JyJeE64hoWBFtAaGd+P
         XySN7WvclIffaDz9YH+XEZmBp4VKMuYdfOMJ8CuG00zY7T+uhq78Y/nlQ3LX0nSrTlpq
         SSM1ZYh6SRV+g6pnoay+cqEe9rhAWH8yj5JELx/5ziOXmXPfFhpoRGCtQ/5FX5qZXUQC
         MUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tUE3dxQm/ksTxTn0YMfdCief23RhMLZPJwxq1FLJlMc=;
        b=QJeLvjUBbRB0r10SENMEOKN8GZhwkZcZ4HdETu1jqxJb/QQMcrGJV+CItQeQLIdeLI
         OH7wDM4IKiY6ZfUrLDqopd/w9HN3bA8uolm/3y1KluTMYk46GXvuNskxmxq9soDIUUK3
         yUdVs+yRAdIMlHoQ84zr1+wfaqI6k4rY6/iLuK8V6Qou1H9Gdk8HJBM64hqkx0kDRIj3
         I2pmDP8+wGjf0vPJZLJunjWqo/bhO/IUn/GvViPXXsjt5haTnes0FL2tSzS/mdTgEf3+
         BdGI9INhIJobKtg5EoSA3+IEI4FjlDehEBPMH2YOEb27YPFoDWcqcCfyg+oGsg+qIwFN
         7rWg==
X-Gm-Message-State: AOAM530KxjyhpxCed3xL+EsPyiAK6xIpsuBojILqGePfgYMzS+qHTKxn
        YbBmvnc/q+eBbLIu/eWA9OreAQ==
X-Google-Smtp-Source: ABdhPJy6Pf+75fs32a7/oPyt8T8e0CpqTdA+RG43t3USzaHGLlu21u/QTbiCC2JdmrrtrrCWV3dd4g==
X-Received: by 2002:a17:902:da90:b0:154:1510:acc7 with SMTP id j16-20020a170902da9000b001541510acc7mr6258840plx.103.1649209699460;
        Tue, 05 Apr 2022 18:48:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090a8b0300b001c735089cc2sm3534686pjn.54.2022.04.05.18.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 18:48:18 -0700 (PDT)
Date:   Wed, 6 Apr 2022 01:48:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] KVM: SVM: Re-inject INT3/INTO instead of retrying
 the instruction
Message-ID: <YkzxXw1Aznv4zX0a@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-6-seanjc@google.com>
 <a47217da0b6db4f1b6b6c69a9dc38350b13ac17c.camel@redhat.com>
 <YkshgrUaF4+MrrXf@google.com>
 <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7caee33a-da0f-00be-3195-82c3d1cd4cb4@maciej.szmigiero.name>
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

On Mon, Apr 04, 2022, Maciej S. Szmigiero wrote:
> On 4.04.2022 18:49, Sean Christopherson wrote:
> > On Mon, Apr 04, 2022, Maxim Levitsky wrote:
> > In svm_update_soft_interrupt_rip(), snapshot all information regardless of whether
> > or not nrips is enabled:
> > 
> > 	svm->soft_int_injected = true;
> > 	svm->soft_int_csbase = svm->vmcb->save.cs.base;
> > 	svm->soft_int_old_rip = old_rip;
> > 	svm->soft_int_next_rip = rip;
> > 
> > 	if (nrips)
> > 		kvm_rip_write(vcpu, old_rip);
> > 
> > 	if (static_cpu_has(X86_FEATURE_NRIPS))
> > 		svm->vmcb->control.next_rip = rip;
> > 
> > and then in svm_complete_interrupts(), change the linear RIP matching code to look
> > for the old rip in the nrips case and stuff svm->vmcb->control.next_rip on match.
> > 
> > 	bool soft_int_injected = svm->soft_int_injected;
> > 	unsigned soft_int_rip;
> > 
> > 	svm->soft_int_injected = false;
> > 
> > 	if (soft_int_injected) {
> > 		if (nrips)
> > 			soft_int_rip = svm->soft_int_old_rip;
> > 		else
> > 			soft_int_rip = svm->soft_int_next_rip;
> > 	}
> > 
> > 	...
> > 
> > 	if soft_int_injected && type == SVM_EXITINTINFO_TYPE_EXEPT &&
> > 	   kvm_is_linear_rip(vcpu, soft_int_rip + svm->soft_int_csbase)) {
> > 		if (nrips)
> > 			svm->vmcb->control.next_rip = svm->soft_int_next_rip;
> > 		else
> > 			kvm_rip_write(vcpu, svm->soft_int_old_rip);
> > 	}
> > 
> > 
> > 
> 
> Despite what the svm_update_soft_interrupt_rip() name might suggest this
> handles only *soft exceptions*, not *soft interrupts*
> (which are injected by svm_inject_irq() and also need proper next_rip
> management).

Yeah, soft interrupts are handled in the next patch.  I couldn't come up with a
less awful name.

> Also, I'm not sure that even the proposed updated code above will
> actually restore the L1-requested next_rip correctly on L1 -> L2
> re-injection (will review once the full version is available).

Spoiler alert, it doesn't.  Save yourself the review time.  :-)

The missing piece is stashing away the injected event on nested VMRUN.  Those
events don't get routed through the normal interrupt/exception injection code and
so the next_rip info is lost on the subsequent #NPF.

Treating soft interrupts/exceptions like they were injected by KVM (which they
are, technically) works and doesn't seem too gross.  E.g. when prepping vmcb02

	if (svm->nrips_enabled)
		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
	else if (boot_cpu_has(X86_FEATURE_NRIPS))
		vmcb02->control.next_rip    = vmcb12_rip;

	if (is_evtinj_soft(vmcb02->control.event_inj)) {
		svm->soft_int_injected = true;
		svm->soft_int_csbase = svm->vmcb->save.cs.base;
		svm->soft_int_old_rip = vmcb12_rip;
		if (svm->nrips_enabled)
			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
		else
			svm->soft_int_next_rip = vmcb12_rip;
	}

And then the VMRUN error path just needs to clear soft_int_injected.
