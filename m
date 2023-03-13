Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4597C6B8645
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 00:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCMXtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 19:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCMXtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 19:49:21 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63796C8A4;
        Mon, 13 Mar 2023 16:49:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k18-20020a17090a591200b0023d36e30cb5so517048pji.1;
        Mon, 13 Mar 2023 16:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678751359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=veCb5kgkwpfOZhFg24jGViGOhj9MBZ2C2UnSqiBHm5U=;
        b=UE0h6mJiXvamxHNE9tkWOS7zJojTVeX594dwceoemH58pbPY1cL6zsQskb2Sq3BGFN
         c0BMpsgqcUN3OEPjySpUoHlr9Hc6wr3dcAlBiNoq+S0s4vaRR4ypnbF63vIUJiWU+EG2
         LMEC7PqO5YQwQfj+bPzlI9Aa2RTdbzbN60C+X44jb5p1QFQHEy8H6MutxlnKLO79VaJE
         1FlnLx+q7S+XAxZ1VhxCoC6bOoUWZs6ts/hV5w1A2XC2MwTPmohk1O7+1jEq/RprGERi
         vKbWGaFO+8vB7049HOCholwiEph8d+3W3/bdon6H11FxVTuultkrRP7AXuCkoBndvPHx
         g90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678751359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veCb5kgkwpfOZhFg24jGViGOhj9MBZ2C2UnSqiBHm5U=;
        b=WFxmoWVazH807OKFE5eU/fkour6OlV5wH0WJCwx0PpdIUY3WeAIKFMrCrVNAy0cnPT
         pOhM7vW3F7eyuYtn00/WemS95fFxafaBRnOTHnC2UWYlhK1RIPT6xP4vyx3/9TDPP+Pn
         fzgJwwHY2obK6GqZtgqHjwka3xy5cv1ePMdDmyVmRskMMdPEhJyQMAavM69ZzrxcrSly
         H3KH05P2m8Ed9jM2dQ5se7B/c+sqlrMo5FIevfws6TOnD73ZLjoVBqAJzTTjPDQAWpnM
         VcP7pqNIR8fs5lbSnu94qpWzZMiY4bLFGti7XAskIAIpOLILS6YCY81E2BHOt9h12gdt
         iZlA==
X-Gm-Message-State: AO0yUKVPVEibhTcTqjUMyy8V7xo+WyTqGlEZeinnyeOkveJ16SkcSU28
        3p2egueYdDZ0hW8R+EBv9Eg=
X-Google-Smtp-Source: AK7set/CjZAHSn9j/7nDCvM2png4vRlpqlSVmsRAnTLnb7O4nhF+5i2H43foXW1osOGQjAuc8KVIMQ==
X-Received: by 2002:a17:90b:2318:b0:23b:3662:11ef with SMTP id mt24-20020a17090b231800b0023b366211efmr9334283pjb.36.1678751359156;
        Mon, 13 Mar 2023 16:49:19 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id v11-20020a17090a458b00b0023d0c2f39f2sm412835pjg.19.2023.03.13.16.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 16:49:18 -0700 (PDT)
Date:   Mon, 13 Mar 2023 16:49:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230313234916.GC3922605@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
 <20230308222738.GA3419702@ls.amr.corp.intel.com>
 <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 12, 2023 at 11:08:44PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2023-03-08 at 14:27 -0800, Isaku Yamahata wrote:
> > > +
> > > +static int try_init_module_global(void)
> > > +{
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * The TDX module global initialization only needs to be done
> > > +	 * once on any cpu.
> > > +	 */
> > > +	spin_lock(&tdx_global_init_lock);
> > > +
> > > +	if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
> > > +		ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
> > > +			-EINVAL : 0;
> > > +		goto out;
> > > +	}
> > > +
> > > +	/* All '0's are just unused parameters. */
> > > +	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
> > > +
> > > +	tdx_global_init_status = TDX_GLOBAL_INIT_DONE;
> > > +	if (ret)
> > > +		tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;
> > 
> > If entropy is lacking (rdrand failure), TDH_SYS_INIT can return TDX_SYS_BUSY.
> > In such case, we should allow the caller to retry or make this function retry
> > instead of marking error stickily.
> 
> The spec says:
> 
> TDX_SYS_BUSY	The operation was invoked when another TDX module
> 		operation was in progress. The operation may be retried.
> 
> So I don't see how entropy is lacking is related to this error.  Perhaps you
> were mixing up with KEY.CONFIG?

TDH.SYS.INIT() initializes global canary value.  TDX module is compiled with
strong stack protector enabled by clang and canary value needs to be
initialized.  By default, the canary value is stored at
%fsbase:<STACK_CANARY_OFFSET 0x28>

Although this is a job for libc or language runtime, TDX modules has to do it
itself because it's stand alone.

From tdh_sys_init.c
_STATIC_INLINE_ api_error_type tdx_init_stack_canary(void)
{
    ia32_rflags_t rflags = {.raw = 0};
    uint64_t canary;
    if (!ia32_rdrand(&rflags, &canary))
    {
        return TDX_SYS_BUSY;
    }
...
    last_page_ptr->stack_canary.canary = canary;


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
