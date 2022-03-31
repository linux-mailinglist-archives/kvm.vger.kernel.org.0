Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7695B4EDF52
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbiCaREz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 13:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiCaREy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 13:04:54 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73A813D3E;
        Thu, 31 Mar 2022 10:03:06 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c2so264271pga.10;
        Thu, 31 Mar 2022 10:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wp4EJkzvjqFPvNMlPc3SR+839jqbE97y6QA0y3+c+dg=;
        b=CrtfCCrS7dIMHPXEJA32ZXUO6VZAAPWW6CP2YeRrEfRrU5nq9rjdw4Sb9Q3Waqfn6N
         7J3nJd2NOwX6Rq1f3J5yCcJKPq7A84BRm+q1aKFs1fopI5iEgv8XrjpCUS79JNM6iBIy
         bSsQ+wBeH7u8EJV/yhHEOQC5cdgXukPNO99NWvosTz3qKZP+utzw08BO4zQQWljn73wE
         RokkNrXu2ObzFqOSPzpjXXdteJ6f9ycj7ZmjkJPtvTOzgYfCXG2XjpvGhk5BsWT8XJp+
         +XWK1aA3mheC+8MHJcb/Nu0JES+kN59u8BmPnHTsaJ8NvxBN2zgAWbsYfk/wvkb6BO5l
         RNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wp4EJkzvjqFPvNMlPc3SR+839jqbE97y6QA0y3+c+dg=;
        b=PxWwgZfu3VHLy7frskjFJGoBqr1jwO9DO7cCkUtexx8D91D4OmM4mo1SHxmB8Znp3o
         29aZAy96N7NhpiIpVYg+c4T0i8e3LmfLx6Yocy0aNxmTmQ77C+ca6H5UiyutwduqIhAJ
         F2SqdskFsc6oJ6TcP8kONNgNd5bRnLLS8Hpop3E5u9ln8hDy3uJZzDnib1NnCZOMUEiX
         D4HaP/uSsbMSpYetPF0WOK+gRuY+fzWEvaSlbNiXGl30V2vcXxWU8uZ1u/H2A/J/vN/a
         51LIMPeYLYpJ/S577Tt7EY9w9ZL1pUsXjp2+OjRSdjGONG3/UI4dJUFOqpiEYbMWuRd8
         Qm5w==
X-Gm-Message-State: AOAM532/KLPXXkR8jao2e5o27uNHxlLqUgWloIzTq715mTHP+ct0kww4
        io+YTb8B3i9XWioRSjY3FhS3h0swZzE=
X-Google-Smtp-Source: ABdhPJz4DPS7JiovUk81i6+FD75E76f7WSeerexiHUmOISNjKATg1LWv/sUdEQRPx2CFbna93jc0CA==
X-Received: by 2002:a65:6d8b:0:b0:376:bfb9:1f3b with SMTP id bc11-20020a656d8b000000b00376bfb91f3bmr11449638pgb.427.1648746186014;
        Thu, 31 Mar 2022 10:03:06 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id k18-20020a056a00135200b004fb18fc6c78sm40158pfu.31.2022.03.31.10.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 10:03:05 -0700 (PDT)
Date:   Thu, 31 Mar 2022 10:03:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <20220331170303.GA2179440@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
 <20220314194513.GD1964605@ls.amr.corp.intel.com>
 <YkTvw5OXTTFf7j4y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YkTvw5OXTTFf7j4y@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022 at 12:03:15AM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Mar 14, 2022, Isaku Yamahata wrote:
> > On Sun, Mar 13, 2022 at 03:03:40PM +0100,
> > Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > > +
> > > > +	if (!tdx_module_initialized) {
> > > > +		if (enable_tdx) {
> > > > +			ret = __tdx_module_setup();
> > > > +			if (ret)
> > > > +				enable_tdx = false;
> > > 
> > > "enable_tdx = false" isn't great to do only when a VM is created.  Does it
> > > make sense to anticipate this to the point when the kvm_intel.ko module is
> > > loaded?
> > 
> > It's possible.  I have the following two reasons to chose to defer TDX module
> > initialization until creating first TD.  Given those reasons, do you still want
> > the initialization at loading kvm_intel.ko module?  If yes, I'll change it.
> 
> Yes, TDX module setup needs to be done at load time.  The loss of memory is
> unfortunate, e.g. if the host is part of a pool that _might_ run TDX guests, but
> the alternatives are worse.  If TDX fails to initialize, e.g. due to low mem,
> then the host will be unable to run TDX guests despite saying "I support TDX".
> Or this gem :-)

Ok.


> > - memory over head: The initialization of TDX module requires to allocate
> > physically contiguous memory whose size is about 0.43% of the system memory.
> > If user don't use TD, it will be wasted.
> > 
> > - VMXON on all pCPUs: The TDX module initialization requires to enable VMX
> > (VMXON) on all present pCPUs.  vmx_hardware_enable() which is called on creating
> > guest does it.  It naturally fits with the TDX module initialization at creating
> > first TD.  I wanted to avoid code to enable VMXON on loading the kvm_intel.ko.
> 
> That's a solvable problem, though making it work without exporting hardware_enable_all()
> could get messy.

Could you please explain any reason why it's bad idea to export it?

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
