Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77B76CF73D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjC2XdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC2XdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:33:03 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AEB5257;
        Wed, 29 Mar 2023 16:33:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c18so16450921ple.11;
        Wed, 29 Mar 2023 16:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680132781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6UqQPNvzkss1LbgIQ4B7N84vGNBYynu9RnkZNtN4TIw=;
        b=U3I9pq60QeWrgwytzJFP7H4m5JL68HfMhTvMVt1ylcg7zv5QUQvRKe6ZXdJ4NeLpfg
         TPxoX+MgPSeNZrDBXiKaUqbhqanTRrcQY0Ut6Tlein6CgJwQabMn/UyiITbQxs4nBYjI
         w+YBfj/f9DFoOhO04t43+TYMYoL2BO1P1YZGCpjXqy6dRVy2rxAS6OfUU7Kn0v76K7Zy
         UDVZzYCfbWAcVQ14EQfy+0b1uVNew/hlTkOOfJ0SVxawKyQ7pPhYaV1zVZKaaqRMTjSm
         jbsLWxM5F5kKA37MFPg4QnKOTkuh2928QZLYPLZXHER6oKJsAE2FEl+sISyeYjIdFdoC
         mYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680132781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UqQPNvzkss1LbgIQ4B7N84vGNBYynu9RnkZNtN4TIw=;
        b=CCARyMxj1TDtWjPw3PZhp4GDSZ940Q8FTcS8B62dG+m9eIAkfY8wRxt64glep33I33
         WWTsr4U4IdWfTh8t3Zqs4Xxf0CwIgUYIXG3i5XeNVLv0z1juGFe3vPMNY4AxwWQK9k6m
         9vy+DqkH8XvKYJRNE0qUDMQv1QudKAuOIkU3gM444E+u365pqSrhi75sbW2REHIFmGmk
         ustv8PA5bPxBctXHiNL0gnW2cZO1Ka74QP6P8Hi5MhTKJBi495IkZUMRPmpkFXO/wSOY
         e7nSFMPWa6Sc1hxYCMdqrt6fHvLJTZgcqpgavBn/LBFHpWxU62QdZkHLqqyy5yhspl8a
         7okA==
X-Gm-Message-State: AAQBX9diXATSs7/i20bgVBwk/CFQx0tPanGtHXYCOQi32xCe2Hn/AMHA
        kLLWiRhrzCcdfDNr1B3jaRo=
X-Google-Smtp-Source: AKy350YWk9gKD6cYAGzYcktMbjE5pp/EGxRP14zqjzWWVzJ7+eE9ThgbS86fxS2eONurCzxuUST03A==
X-Received: by 2002:a17:902:eccd:b0:19b:64bb:d546 with SMTP id a13-20020a170902eccd00b0019b64bbd546mr4542228plh.18.1680132780934;
        Wed, 29 Mar 2023 16:33:00 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id g6-20020a1709026b4600b001a19cf1b37esm23492704plt.40.2023.03.29.16.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 16:33:00 -0700 (PDT)
Date:   Wed, 29 Mar 2023 16:32:58 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 018/113] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS
 backend specific
Message-ID: <20230329233258.GC1108448@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <87f6baf8419103077f0a42859a0a847c695f5f59.1678643052.git.isaku.yamahata@intel.com>
 <20230325201326.00002d4d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230325201326.00002d4d@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 25, 2023 at 08:13:26PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Sun, 12 Mar 2023 10:55:42 -0700
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX has its own limitation on the maximum number of vcpus that the guest
> > can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> > handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
> > e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
> > 
> 
> I think enabling the cap here is actually "configuring the cap". KVM_CAP_MAX
> _VCPUS is actually always enabled whether userspace enables it or not. It
> would be nice to configure of the max VCPUS in kvm_arch_vm_ioctl() where
> routines of configuring a VM should belong. E.g. KVM_SET_MAX_VCPUS.

I'm not sure I understand your point.  Although KVM_ENABLE_CAP sounds like
only on/off feature, but it isn't. It's also used to set parameters. For
example, KVM_CAP_MAX_VCPU_ID.

KVM_SET_XXX is for run time feature. But the maxium number of vcpus is not
runtime changable. Set it at vm creation.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
