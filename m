Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30CE6A78B9
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 02:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCBBLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 20:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBBLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 20:11:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584CC23102;
        Wed,  1 Mar 2023 17:11:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y2so15237809pjg.3;
        Wed, 01 Mar 2023 17:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677719511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+zNU2traPyY4e76JjN6VQpIVRi1XnP7HB+q7Nr0E/4=;
        b=Mmro2sTZ/dgxsJ+grrWfL89raBn2OGoq/Drc+R2Mlxr8qJCZmZLA/1ORflcpcarfXt
         gR3GoQYhl30tZ7KPX+gAhc/hDJ16+pItSV0/mZpg2Ps+DmYasaNQb6/pMUTAmboZxyc3
         a6C95G2ajIvCLC/IFymCnpOcnEkjmMcLl7txXSfLXVMGXJnbPcu6hRnd4EZyRE1cSHrH
         zOve4LFDhYzUTiHz9O8jevSmwTDVnLCRJSQVKt5brPYmp3tkz4aaCoB4ajw1Y8iduHgx
         D16+EfXt1trqM6KVaN2fcJoJf3K3aST0AqjOMqTNlAIIrcb+p9RqZ8OFHPkx1Y3GXj+F
         Lemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677719511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+zNU2traPyY4e76JjN6VQpIVRi1XnP7HB+q7Nr0E/4=;
        b=xx1RHmBB/hcO4G5kUKFQa9NUaXcP/kwxEJ4CZH8LxNBHhzx9lW4/xepxJQGVqPWj7w
         nXK80h9PxbBwjJ+TQs9DmpYKlJW/DIJCkak9sDGjVLTUeCmsWu/kNfcCfgiySQq2e+y2
         Z1BkauF916KL47jnvNYrpNZRjZS4qvjlKByKaZ/OZ9GlKSGmkDZVVCvn0JAmF2cGN3a2
         W+ncI6iovFu2JdNuXAZmQGaig+HP7psMInQFbewSyY/cqrUXVYJLzitSLMXqIQkVbTnV
         JrZpW4NJWhYTCrqHKW7jLSD7kO3fGbjChq3SQQXAWVyU5s/vzqi84Wr4knvgXCrJ2774
         cLSA==
X-Gm-Message-State: AO0yUKVtCH07IPhZPo3E0x6xqjX238d6I5/Y1/FPqVmgsENiECTrMf9J
        X9ffmuaNRI1KXVPoNco7Ufo=
X-Google-Smtp-Source: AK7set//9F6BtGJ1V3XpntmKtzHp1dSvX+v72vFs+x5Hmv+o7wUqfqc6rRldy2GK86dl72DVeRjtRA==
X-Received: by 2002:a05:6a20:9388:b0:cc:59b7:79e6 with SMTP id x8-20020a056a20938800b000cc59b779e6mr330718pzh.24.1677719510548;
        Wed, 01 Mar 2023 17:11:50 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id l72-20020a63914b000000b005030a00085asm8139712pge.46.2023.03.01.17.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 17:11:49 -0800 (PST)
Date:   Wed, 1 Mar 2023 17:11:48 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v12 013/106] KVM: TDX: create/destroy VM structure
Message-ID: <20230302011148.GA2069594@ls.amr.corp.intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
 <fd52ff91fbce051ecf9781af2e5c54138c995230.1677484918.git.isaku.yamahata@intel.com>
 <e23b30cc-80a1-774f-7d58-a676d989b5ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e23b30cc-80a1-774f-7d58-a676d989b5ce@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 03:24:49PM +0800,
Chenyi Qiang <chenyi.qiang@intel.com> wrote:

> >  		return -EINVAL;
> >  	}
> >  
> > +	max_pkgs = topology_max_packages();
> > +	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
> > +				   GFP_KERNEL);
> > +	if (!tdx_mng_key_config_lock)
> > +		return -ENOMEM;
> > +	for (i = 0; i < max_pkgs; i++)
> > +		mutex_init(&tdx_mng_key_config_lock[i]);
> > +
> >  	/* TDX requires VMX. */
> >  	r = vmxon_all();
> >  	if (!r)
> > @@ -168,3 +600,9 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> >  
> >  	return r;
> >  }
> > +
> > +void tdx_hardware_unsetup(void)
> > +{
> 
> To align with tdx_hardware_setup(), add some check like:
> 
> if (!enable_ept || !enable_tdx)
> 	return;
> 

Oh yes, thanks for catching it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
