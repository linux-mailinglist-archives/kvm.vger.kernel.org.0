Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB614EFAFF
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 22:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351882AbiDAUUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 16:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbiDAUUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:00 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B83A2706E7;
        Fri,  1 Apr 2022 13:18:10 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i11so3382204plr.1;
        Fri, 01 Apr 2022 13:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kdnSMpiTCRDvRUDbYzRwpTgjmgodk5oaNh3fctE9L/g=;
        b=H26iFxckDVq+YQVbmm0eqktbwJjqz4DvYVm67KyjEbafrWXdkDYv1EAt+8r/51FL42
         Q4c8TxkF54vMWDLC+wF1/s/ig4WTU0PtPCClwFl9h9FUZF1UoxNs+v9wVIC7N2YF5GGe
         QoeMEdJ2Edg18qp+Uq8iJspIKXXSf6BiBOrt9yfW8RMNvsqsJUDSrib5nl8Qgtt5CHHP
         t/g/gCfpbL6oX+MVXjuBXnSsG9qbT4LxkisUCESOQmTn+wDIWvEh+l6/12a0M8kwpakj
         Re5vCJ6i0RUtzYwIq0xLVE6JRNmuFBH40PDX3kHf9yyYaHvbtM/PbTt3g3H9+b1Yksfi
         h09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kdnSMpiTCRDvRUDbYzRwpTgjmgodk5oaNh3fctE9L/g=;
        b=3ofhz+PZFAhFNjvqNEq5ykkJl5FvJf3iWt1Q2xMaqAcDzyqBXjnAKQcEnij6YpRLXf
         P7neWmTMl9sl4PJLcjvS4ItWpsY03bEhLK2UcUVgZ33xcq/I4NBBk2Ry5M/isb8HGNie
         yRmuXYDrgvHn2P56cY+1iP+4zWi3X5NLAccS//7DC5ebhdX60vzWH0AkL9vhZO/md43M
         fTcPzdhO3WilwEzRmCa8/myZkGQ8JWx3uunSM9C8rp3VlSq5t3gntnDy0+DFBVHHui12
         Vc7Gu2+16E8M02BY6oiLVXhFwOnsOmVlUMYnz4vAbnhhmb015Mr6bCMNwMeTye6yNnXW
         yRFw==
X-Gm-Message-State: AOAM532YhKAYIbHt48ccAEDXOB6gSENcxH231/krSserTiSS31Pfq3uH
        DpwmBVV+fOt2AskVs7zUMME=
X-Google-Smtp-Source: ABdhPJxdgGqV7vPcSBlNaImstCIy0ZOcEaVBYvEY/qbtR6uKbWO1XRGd/oyDjb8VronlpmJbhP5TYw==
X-Received: by 2002:a17:902:ced0:b0:153:f78e:c43f with SMTP id d16-20020a170902ced000b00153f78ec43fmr11718153plg.64.1648844289605;
        Fri, 01 Apr 2022 13:18:09 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id j3-20020a056a00234300b004faabba358fsm3886617pfj.14.2022.04.01.13.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:08 -0700 (PDT)
Date:   Fri, 1 Apr 2022 13:18:06 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <20220401201806.GA2862421@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <36aac3cb7c7447db6454ee396e25eea3bad378e6.camel@intel.com>
 <20220331194144.GA2084469@ls.amr.corp.intel.com>
 <d63042a2-91d8-5555-1bac-4d908e03da2b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d63042a2-91d8-5555-1bac-4d908e03da2b@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022 at 02:56:40PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 4/1/2022 3:41 AM, Isaku Yamahata wrote:
> > On Thu, Mar 31, 2022 at 04:31:10PM +1300,
> > Kai Huang <kai.huang@intel.com> wrote:
> > 
> > > On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > > > Add a wrapper function to initialize the TDX module and get system-wide
> > > > parameters via those APIs.  Because TDX requires VMX enabled, It will be
> > > > called on-demand when the first guest TD is created via x86 KVM init_vm
> > > > callback.
> > > 
> > > Why not just merge this patch with the change where you implement the init_vm
> > > callback?  Then you can just declare this patch as "detect and initialize TDX
> > > module when first VM is created", or something like that..
> > 
> > Ok. Anyway in the next respoin, tdx module initialization will be done when
> > loading kvm_intel.ko.  So the whole part will be changed and will be a part
> > of module loading.
> 
> Will we change the GET_TDX_CAPABILITIES ioctl back to KVM scope?

No because it system scoped KVM_TDX_CAPABILITIES requires one more callback for
it.  We can reduce the change.

Or do you have any use case for system scoped KVM_TDX_CAPABILITIES?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
