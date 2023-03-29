Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB1A6CF5B7
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 23:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjC2V4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 17:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC2V4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 17:56:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5951797;
        Wed, 29 Mar 2023 14:56:12 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id ja10so16257536plb.5;
        Wed, 29 Mar 2023 14:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WEWb6dNCzy5vSqh3q1uGsKuY9/dBiDUnSaaAs+jh1U=;
        b=ZEdCSoEl9obaF5AF7yCtcCF9nR/ZfNk/7mjxcTvZLnuq5E6ouTMFp5lLthhXvq6lV/
         EzGj5EL363QgY3keFr3EHyBO2JYCL36HnHpiRDI7ilk+6CQNdKb5KZBEjzmI8GdRSKlL
         8Q29J/W7qvnC4zx+72LmYA0xlhUu7OtwnSpHBoZ2tds8jft6aU+rseaknqERIM8xKGdF
         W1fhp3O0RMBsQY9G9oVFJUTOHduGDfWkCYSna3b8bsd29+DGOF3aPV49HpbpilIFgoOR
         yWGqg9HmsubIsR/nl4bkmCfPI1dZFWb9zz3X0qgIcirusIvsyXr0LOUNgFKUQIapo+3Q
         FBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WEWb6dNCzy5vSqh3q1uGsKuY9/dBiDUnSaaAs+jh1U=;
        b=juGEpDj5g5ZgdNI+EbQr/T45rz4WZQ5ZMj9ftzZvgVV2X9IeioA59nRs8Gw+Ly45k5
         nyF7AV1SdTq+BPh+VJvlPdgHW3fXgZkmHmV73i7KbeDkrnwuwpXWcm+/PvKZ/Ww8eg6D
         4fg9oSAo/ItF7OK9GXh/zjrEb43piEcQIl55L8DXZCtmTKxCI8uTQ85YKRevRkNX5rLl
         vNUJgdtk3apJrnBqibnm6lJpZm8XEZTo51SlfYMvyuaHIpN4eLsmxh0Gih1xmHYZCiE/
         LMI5ZHl5XBV1+ts2/IancHz+xD5ncR1SyqawGptz82fYBr9uXgg88POZQGKzGLpk7TQN
         O26Q==
X-Gm-Message-State: AAQBX9cBE2rU6RleuJ9qWrK5IFpa+THzF0v6oK7gWyQ7JSM2QbUV0z5l
        U/zEOSMVcIs+gRtzYq8uP+U=
X-Google-Smtp-Source: AKy350ZH6Qrvlbz4+Pgs77QSvSr86IWieNhV0z8BQuvI0hg4R39DVV9vFaNjfLHvlq13mxyNg/EbSA==
X-Received: by 2002:a17:90a:4fc2:b0:23d:4242:a7a5 with SMTP id q60-20020a17090a4fc200b0023d4242a7a5mr23322803pjh.47.1680126971574;
        Wed, 29 Mar 2023 14:56:11 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id d9-20020a17090a7bc900b00233df90227fsm1886641pjl.18.2023.03.29.14.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:56:10 -0700 (PDT)
Date:   Wed, 29 Mar 2023 14:56:09 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230329215609.GB1069687@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
 <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
 <20230315072711.GF3922605@ls.amr.corp.intel.com>
 <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
 <20230316002702.GA197448@ls.amr.corp.intel.com>
 <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
 <20230328235839.GA1069687@ls.amr.corp.intel.com>
 <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 01:13:45AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > 
> > > >  
> > > > +	/*
> > > > +	 * TDX requires those methods to enable VMXON by
> > > > +	 * kvm_hardware_enable/disable_all()
> > > > +	 */
> > > > +	static_call_update(kvm_x86_check_processor_compatibility,
> > > > +			   ops->runtime_ops->check_processor_compatibility);
> > > > +	static_call_update(kvm_x86_hardware_enable,
> > > > +			   ops->runtime_ops->hardware_enable);
> > > > +	static_call_update(kvm_x86_hardware_disable,
> > > > +			   ops->runtime_ops->hardware_disable);
> > > >  	r = ops->hardware_setup();
> > > >  	if (r != 0)
> > > >  		goto out_mmu_exit;
> > > 
> > > Hmm.. I think this is ugly.  Perhaps we should never do any
> > > static_call(kvm_x86_xxx)() in hardware_setup(), because hardware_setup() is
> > > called before kvm_ops_update() and may update vendor's kvm_x86_ops.
> > > 
> > > So probably use hardware_enable_all() in hardware_setup() is a bad idea.
> > > 
> > > I think we have below options on how to handle:
> > > 
> > > 1) Use VMX's kvm_x86_ops directly in tdx_hardware_setup().  For instance,
> > > something like below:
> > > 
> > > int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > > {
> > > 	...
> > > 
> > > 	cpus_read_lock();
> > > 	r = on_each_cpu(vt_x86_ops.hardware_enable, ...);
> > > 	if (!r)
> > > 		r = tdx_module_setup();
> > > 	on_each_cpu(vt_x86_ops.hardware_disable, ...);
> > > 	cpus_read_unlock();
> > > 
> > > 	...
> > > }
> > > 
> > > But this doesn't clean up nicely when there's some particular cpus fail to do
> > > hardware_enable().  To clean up nicely, we do need additional things similar to
> > > the hardware_enable_all() code path: a per-cpu variable or a cpumask_t + a
> > > wrapper of vt_x86_ops->hardware_enable() to track which cpus have done
> > > hardware_enable() successfully.
> > > 
> > > 2) Move those static_call_update() into tdx_hardware_setup() so they are TDX
> > > code self-contained.  But this would require exposing kvm_x86_ops as symbol,
> > > which isn't nice either.
> > > 
> > > 3) Introduce another kvm_x86_init_ops->hardware_post_setup(), which is called
> > > after kvm_ops_update().
> > > 
> > > Personally, I think 3) perhaps is the most elegant one, but not sure whether
> > > Sean/Paolo has any opinion.
> > 
> > I think we can simply update the ops before calling hardware_enable() and
> > clean up ops on failure.
> > 
> > 
> 
> This doesn't work because hardware_setup() may update vendor's kvm_x86_ops.
> 
> If you do kvm_ops_update() before hardware_setup(), you need to manually update
> those updated (in hardware_setup()) callbacks again after. 

We can call kvm_ops_update() twice before and after hardware_setup().
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
