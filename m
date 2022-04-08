Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EAB4F8C23
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiDHBBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 21:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiDHBAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 21:00:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C61E315ABC;
        Thu,  7 Apr 2022 17:58:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t6so206849plg.7;
        Thu, 07 Apr 2022 17:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DdDfF5vBC6ZDMW6RUWafc7xCMkUyD7e4BPQtm25XblU=;
        b=ag8/rgDpaqlZWPOwvN0Iq6EkkDWpYoA0byICil0SnJVE6RbyzRHp9E+OApenarx7yu
         ppyh7tQLcpIv3PA5HTCLDfBEhywQXU4S+9Ah1eRfWw0NlkVWA+HqIcmhqeHeHrG023aK
         4WGGgH9MdyuRm50fIuvBZ346cqytl6P7Wa2zk1FTCen3Q0wJ3t+oyAMYCPnmIfJRNeBT
         +n91xKOB8a+w2YIRQxAgnhfPCp9rRjv2ZD1wQ/UGZfN1kQEZlie35AAN6R1jBawDJb3y
         X8CAVaTeNLbXyXHWLaMEYpco4NrKrC7dp3QMQTC4Bc7UnLDtpvfLKneWz4CDE+lyJvMf
         /jSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DdDfF5vBC6ZDMW6RUWafc7xCMkUyD7e4BPQtm25XblU=;
        b=R6+y08Ro7tbWNAWqey242JrKuLuYDTFHLmKr4LeerRCyRYdbR4uxwmW+GUJnDZlFbj
         8eHUwoDfu6O1fvE8pC7niRcJpC4IBF42M6x93u+OFdhHzyzDeuh/u+sPLOM0rvldUiL7
         4t7EkbnHZepJYZsuHMzIqG494i6s1ymWD7grKUjwbit3x+O4i19wFz5HZwbWjMRwjDze
         fvSg/0J245fbGvlZ4ZfkZ47i2rxHh7X1iltlB/PL3mUvaGQ0ZFD4uG9fuSTgR3iwq+Ne
         O68Rtq/Rmz9AdVAQ6eMeoUC19ItRQAR0aW79Gix609AtR6AAqlLVN70fMAd9tJe62di5
         GpZQ==
X-Gm-Message-State: AOAM531hZ6H7MJSfdHvALO63fxoEPVQ+1AZGG7pJsmpJJu2adB/Uv++X
        W6QSnqc5Br9U+P6y+SfjYPQft0apXpQ=
X-Google-Smtp-Source: ABdhPJwqAM3yMDvX935JOetPY+OR/AM3jygV4cY0OwFrTOC7EN2RLsmNQD/71dvQ9gMgdOpq6NOXMg==
X-Received: by 2002:a17:902:b70c:b0:156:16f0:cbfe with SMTP id d12-20020a170902b70c00b0015616f0cbfemr16346264pls.152.1649379530851;
        Thu, 07 Apr 2022 17:58:50 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id q22-20020a056a00085600b004fb249e5be4sm24507641pfk.181.2022.04.07.17.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 17:58:50 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:58:49 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 026/104] KVM: TDX: x86: Add vm ioctl to get TDX
 systemwide parameters
Message-ID: <20220408005849.GD2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5ff08ce32be458581afe59caa05d813d0e4a1ef0.1646422845.git.isaku.yamahata@intel.com>
 <586be87a-4f81-ea43-2078-a6004b4aba08@redhat.com>
 <17981a2e-03e3-81df-0654-5ccb29f43546@intel.com>
 <bf3e61bcc2096e72a02f56b70524928e6c3cfa3e.camel@intel.com>
 <8aa0cf5b-bfda-bcf8-45f9-dc5113532caa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8aa0cf5b-bfda-bcf8-45f9-dc5113532caa@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 09:17:51AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 4/7/2022 9:07 AM, Kai Huang wrote:
> > On Wed, 2022-04-06 at 09:54 +0800, Xiaoyao Li wrote:
> > > On 4/5/2022 8:52 PM, Paolo Bonzini wrote:
> > > > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > > > Implement a VM-scoped subcomment to get system-wide parameters.  Although
> > > > > this is system-wide parameters not per-VM, this subcomand is VM-scoped
> > > > > because
> > > > > - Device model needs TDX system-wide parameters after creating KVM VM.
> > > > > - This subcommands requires to initialize TDX module.  For lazy
> > > > >     initialization of the TDX module, vm-scope ioctl is better.
> > > > 
> > > > Since there was agreement to install the TDX module on load, please
> > > > place this ioctl on the /dev/kvm file descriptor.
> > > > 
> > > > At least for SEV, there were cases where the system-wide parameters are
> > > > needed outside KVM, so it's better to avoid requiring a VM file descriptor.
> > > 
> > > I don't have strong preference on KVM-scope ioctl or VM-scope.
> > > 
> > > Initially, we made it KVM-scope and change it to VM-scope in this
> > > version. Yes, it returns the info from TDX module, which doesn't vary
> > > per VM. However, what if we want to return different capabilities
> > > (software controlled capabilities) per VM?
> > > 
> > 
> > In this case, you don't return different capabilities, instead, you return the
> > same capabilities but control the capabilities on per-VM basis.
> 
> yes, so I'm not arguing it or insisting on per-VM.
> 
> I just speak out my concern since it's user ABI.

The reason why I made this API to VM-scope API is to reduce the number of patch
given qemu usage.  Now Paolo requested it, I'll change it KVM-scope API.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
