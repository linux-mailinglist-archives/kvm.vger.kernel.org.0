Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3C16CF6EE
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjC2XXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjC2XW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:22:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52D926A4;
        Wed, 29 Mar 2023 16:22:58 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j13so15601093pjd.1;
        Wed, 29 Mar 2023 16:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680132178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rxq/vuSpInfYGqF100OlU+qAGSifmYxPvkU49clv7gI=;
        b=Ew0P11Cjc5Sfc4IF++NP/wDrXiOBhGgsRa/u+WD31TSlFZGiys9CS31gMyEsj1DdxB
         fC09rc6XFylQDwHIA4pjwiztVeNeepTV2tCoa486LOaqPYT3XIX7zdl+zsaclQamDB5u
         bn5r9LrUyjGaRgICe+E8Nv6TLNGP+3nrRcX+McsHBqlx8DOEnnDZ5HHp+tkxGX3CTjsI
         fSl4bRZh5zrPMpwA5xVXi6BcvfbFiWhHl/N+UYc3d0UAqZou3Le5/lBsxIFarKKQH6Z5
         qiMP0lDjOBgsYvNpzmJ0HDj6xBGkQYhUUddeIWhzZLz7eXfhDZZ7mJc4WuFtcwhBJJOm
         vGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680132178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rxq/vuSpInfYGqF100OlU+qAGSifmYxPvkU49clv7gI=;
        b=ss1cBr+hqwaY7+kOT8e1Yeq8TKpvTaQz4raI3qjwys4Cy1kyq2XsDnAdGBEVRGG3QO
         FtDjyikG5DviYWxtKpiju+MARkduezC7sNKhCUANGb9Emtrh+b2wVIsHLN8RjI4PbyKk
         boaB/y/bis1evOqCmVxDat5JNzcRB4QewDqk2dgWLOHg5hdMhjVFwETHnlLVMxMa9R8d
         Hgiiz84HsC0qGmzmPjxTm4VJyEKELf4JDVmPvc4SOpVPZTsiIaSY+7bYDncsdvEpn6bN
         j1wstuHLzEfRE2iO5Nwa6CMN4KbH0YFqrFSMqIa9dSpSV8tx0zmNfYg43PEZulu026lU
         vLSA==
X-Gm-Message-State: AO0yUKVadwP3EYwrwuEUJ9vWoXVzaYs/f5m5qbMfNDJX7VqbnerQXR3F
        IDY2i8eLpWM0cUpqf4Rd70I=
X-Google-Smtp-Source: AK7set+r0G3UPfwGBAvscY8gFEcvK5MJoQ9CGKZufxvuaZeUcdiRpOGJ1Q2xEVE6KpDyuFifWwb0rQ==
X-Received: by 2002:a05:6a20:4a13:b0:d8:afd4:4ac7 with SMTP id fr19-20020a056a204a1300b000d8afd44ac7mr17731367pzb.4.1680132178038;
        Wed, 29 Mar 2023 16:22:58 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id i22-20020aa78b56000000b005aa60d8545esm23531104pfd.61.2023.03.29.16.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 16:22:57 -0700 (PDT)
Date:   Wed, 29 Mar 2023 16:22:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 017/113] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20230329232256.GB1108448@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <7cdfc307ea8717849e71063ceebf1e328448e773.1678643052.git.isaku.yamahata@intel.com>
 <20230325110550.00006091@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230325110550.00006091@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 25, 2023 at 11:05:50AM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index b46dcac078b2..58fbaa05fc8c 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -117,7 +117,7 @@ KVM_X86_OP(enter_smm)
> >  KVM_X86_OP(leave_smm)
> >  KVM_X86_OP(enable_smi_window)
> >  #endif
> > -KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
> > +KVM_X86_OP(dev_mem_enc_ioctl)
> 
> I guess it should be KVM_X86_OP(mem_enc_ioctl) here.

Yes, thanks for catching it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
