Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5692A5FAF21
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 11:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiJKJNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 05:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiJKJNT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 05:13:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A664EE18
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 02:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665479597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VThX7WbifVT6BXrss5grux5JWHQo9lFU0LPJWiFOeu0=;
        b=HaVXElnoD4pqV079MOOxXahhkE+qm0zjwDGtY6Uejtk5pZ2E5IH1U0U8uGAgUHOqV8dLPh
        M9woKYnEqt6vPZ2NP0Nm+DAjAbmufsQ8gD117/DX+TFsHUgPY0cevAxbqt56numnyu5ucz
        uGaQkzgioyFSw8HnsA1MOcF1q3s0sGY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-112-nFEXwkFNPgifarM7ZTB24A-1; Tue, 11 Oct 2022 05:13:11 -0400
X-MC-Unique: nFEXwkFNPgifarM7ZTB24A-1
Received: by mail-ej1-f70.google.com with SMTP id qa14-20020a170907868e00b0078db5ba61bdso1876731ejc.12
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 02:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VThX7WbifVT6BXrss5grux5JWHQo9lFU0LPJWiFOeu0=;
        b=5Vtp5uYFGYF1seZwiEOpxtk7mYVowyXCnZHI0znIQP7hjl9s8ELOt8iPbTOg4Py/5D
         9S3pSU6Azd+23oMZ9wR38VC0rt5ceLi7AEwhS94oWLBDGBn5/aludrPE7EzT9O13c6CF
         CpcC1R7p0NXyLZVW061lyfzkIPDMYHPrAwoio6/NABywSTm2HrkYV82AhiS6WKmy6ZgV
         OBbGvc3Tudjml3KRZo6/mf3GxQ+3jS6Uh7oW4UMmWL36Sy3YDlu3PiHy5HelWB5i3R+U
         2w1qN5xyP4ESJLeuVWq4hXNU+DdbfAVBZYXSHYW3yDPGbpcyTG1SpMF5pw1CmLcoE/tU
         GCkw==
X-Gm-Message-State: ACrzQf2v301OiH+Hw5BL18HAiUWBXQZ2Mc9HUA93thKL/LADa+qNO2M3
        Unfl6tdkRf3clPvjK71zaM/lKISX9LRF2GLpq9w/NpsOCgyUP499r5iQ1etaWnrngOVR6kXiy9c
        Eb7iwiInkZSB85L65ikIDryIH4I+OJ4p+0aBiMyrfK013mwAAqIw0UxOb7eOv6i0/
X-Received: by 2002:a05:6402:42c3:b0:459:cebb:8d3a with SMTP id i3-20020a05640242c300b00459cebb8d3amr22291466edc.421.1665479589967;
        Tue, 11 Oct 2022 02:13:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7rwXi31GTGapUa9CJLiOZ/I3OJKRFG0ol4xHLIaRP/F+ZlHvFBopeGF9Nqar2zmSmyZrZuLw==
X-Received: by 2002:a05:6402:42c3:b0:459:cebb:8d3a with SMTP id i3-20020a05640242c300b00459cebb8d3amr22291444edc.421.1665479589769;
        Tue, 11 Oct 2022 02:13:09 -0700 (PDT)
Received: from ovpn-194-196.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ti5-20020a170907c20500b0078bfff89de4sm6573881ejc.58.2022.10.11.02.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 02:13:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-5.15.y 4542/9999]
 arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds
 limit (1024) in 'kvm_hv_hypercall'
In-Reply-To: <202210110411.z2fNZUCa-lkp@intel.com>
References: <202210110411.z2fNZUCa-lkp@intel.com>
Date:   Tue, 11 Oct 2022 11:13:07 +0200
Message-ID: <875ygq910c.fsf@ovpn-194-196.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> Hi Vitaly,
>
> FYI, the error/warning still remains.
>
> tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-5.15.y

...

>
> All warnings (new ones prefixed by >>):
>
>>> arch/x86/kvm/hyperv.c:2185:5: warning: stack frame size (1036) exceeds limit (1024) in 'kvm_hv_hypercall' [-Wframe-larger-than]
>    int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>        ^
>    1 warning generated.

For the reference, previous discussion of the problem:
https://lore.kernel.org/kvm/87zgg6sza8.fsf@redhat.com/

The patch to fix this:
https://lore.kernel.org/kvm/20221004123956.188909-19-vkuznets@redhat.com/

is part of "KVM: x86: hyper-v: Fine-grained TLB flush + L2 TLB flush
features" series (v11:
https://lore.kernel.org/kvm/20221004123956.188909-1-vkuznets@redhat.com/) 
which I hope to see in 6.2 (fingers crossed!), however, it is unlikely
to go to stable@ unless we know that there's a real problem to fix. I'll
backport it then.

-- 
Vitaly

