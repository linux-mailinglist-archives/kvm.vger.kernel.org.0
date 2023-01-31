Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7499F68386A
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 22:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjAaVMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 16:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjAaVMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 16:12:22 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F7953E69
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 13:12:21 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 7so6094569pgh.7
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 13:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I07ziaxrU3JZoL2lW8helH5/76F7uWK5/a/ZXOsI6YI=;
        b=ApP9tmjkg2VahldaXyySaP4hBgNG9g7NHyHaRWippde2Fqy0mQTEr+aik293jsoxEJ
         XnEQiB1RYxn7Gcntc/CAFXEy3hZpp63+CEWlvJtcsENC48HvokymlaSSsgUdh7zq+tZt
         J608i5tSz6r3m8gZvcJ5tE2Ifo6nGF+F9hMDxxcR5jboj5Fo66DM/KGlFgUcT9S8t5qX
         yWgoYcfMmKaoThIUZFICha3DW6Ap8EeQmXZyYmXl1ti06AJAOxbWYiujtF4AVUvs3tmD
         3yR2OLWZK7W+yzwv4xVn7pg9rHhm1YIX39KQajvWjD+alNrK4AlKE2SHkZKa5C9orQuC
         1Hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I07ziaxrU3JZoL2lW8helH5/76F7uWK5/a/ZXOsI6YI=;
        b=z/kdcWZs5cYM5cbaAd3kceglKxz3yS/XLQPPUIJO1mYdt2W27v47M2oNCyLRjjZX4M
         AhA71r9AcLCx+W4qQsUzS55vWL2Pt7Ap80B4InEjEOf2xde+zt80rWYGRr9VnmLBVzxC
         4TouBKndxgqDnSmwUgyU+kMwhX705QaKL32SHDi6TaA2uHrbvtnXWcIbMSTyAVtnrK1X
         2vWaIwiV+7wp+V2mhU8NGEL/jAhOPvfLSdvaNKid3BDYNE0AI70vF+4p2BWWuQ1xbjVN
         Bbsald65ah1IBz/uF33ysn1ROJ/dU3lfriDMjpvc3jHJ3Ks8Q0RHdUERXeaeBcX5lTYx
         dtlQ==
X-Gm-Message-State: AO0yUKXirridNwU58a11IB31GOmetUdbFWW15SdWHcfa67SKZGSTVirF
        /YxoR8ffIyJ6aaPrbl6lYKnjSSr0NGNKF9FzU4s=
X-Google-Smtp-Source: AK7set+fdfaKzkzRiNhYemCVS81y7K5XMnW4HASGWZB572PEmdHC6kmHppMH+kGiOOU9wf3XrC+v7w==
X-Received: by 2002:a62:1c4e:0:b0:590:7627:91b with SMTP id c75-20020a621c4e000000b005907627091bmr143992pfc.0.1675199540800;
        Tue, 31 Jan 2023 13:12:20 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i20-20020aa796f4000000b0057726bd7335sm9853084pfq.121.2023.01.31.13.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 13:12:19 -0800 (PST)
Date:   Tue, 31 Jan 2023 21:12:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Message-ID: <Y9mEMNGXe8lG5oW8@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com>
 <Y9R1w8kfQjCNnEfl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9R1w8kfQjCNnEfl@google.com>
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

On Sat, Jan 28, 2023, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
> >  	 * Otherwise, allow two (and we'll inject the first one immediately).
> >  	 */
> >  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
> > -		limit = 1;
> > +		limit--;
> > +
> > +	/* Also if there is already a NMI hardware queued to be injected,
> > +	 * decrease the limit again
> > +	 */
> 
> 	/*
> 	 * Block comment ...
> 	 */
> 
> > +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))
> 
> I'd prefer "is_hw_nmi_pending()" over "get", even if it means not pairing with
> "set".  Though I think that's a good thing since they aren't perfect pairs.

Thinking more, I vote for s/hw_nmi/vnmi.  "hardware" usually means actual hardware,
i.e. a pending NMI for the host.
