Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F072E5845E0
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 20:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiG1SrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 14:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiG1SrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 14:47:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143866F7C0
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 11:46:59 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c139so2666416pfc.2
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 11:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=7izCngOY4FlJA7aFVGJAVWlS1so31LHrdF1iXKo0s7k=;
        b=AM21h/0ZazfG9t+LflSWC6wOUxf0sIuppMbc4jGoGUlehO+IH4f5xZcXJAy6mewqdp
         DvdYRPqEiU+VlN0xnvlVRpCoaIJup9Tfr8ktmoZOY4hrOoN5YnbxK28oDwRb5EpLSmip
         lM9AG2NaCSeDeSlSEMBullYvZeO9gr0REU3AQJ2ImnQdGRAp4qMHQ0LADFNKfz+sUJPh
         vg43NTe1Zur6nAIVxadX8uwYLNIJ5UZUFCwiyIpU5HmsBc+dP1TswFOTOuFkEHwEFPVd
         oMjGg39f7JMqPgBUWnq4DL7EBWWlSmDf0nM5MBlOQKA/kfQiQaW3xdqYc/JhgN3seH6Z
         hzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=7izCngOY4FlJA7aFVGJAVWlS1so31LHrdF1iXKo0s7k=;
        b=HybEJLtwolP46VuGG6uIPTX4/bBRQcbZvu+2U9aIcLRz6AfgbriA+6RXvFPzFB9868
         8bFThzWN2N0A7bbsKFbur9J6v87iQNIcrkMBbhl8AwxGhblN1r/N3EJSoXIicrXt82Bq
         Qm2Mr/S4Q7NvYUIsOa4WyqTZZxp9g1D1U7QyfyybVt6nks6eqZek7iOXMTeaWFQC0wnw
         JGjZOemjqJ9tl+/mDJHt6uBSUdvOH9JdTmlw9rt5Y7fncejZYzuUwvZX3ZfBOJyw5smK
         pl1aXYU74mBTxhCymirjwRpwz6LD57VkQ75tEjH8Gizr/zSwx+lqmqO618x9vHgnbOz5
         D43w==
X-Gm-Message-State: AJIora/meDSCZPyst8O+yfnKhcaCHmROyf3QKieWGuAj1yqSsUEAdfx5
        QklbkU0cTzUq2yfkLZhcyrs2sQ==
X-Google-Smtp-Source: AGRyM1vjaB1h+xE9vDngPt439cAbv1JnPa8dBVGgeDZaKfEcBegXZIOHbyewCCZLnFkv3DUgwi4Ibw==
X-Received: by 2002:a63:f04:0:b0:41a:aea0:9726 with SMTP id e4-20020a630f04000000b0041aaea09726mr104814pgl.382.1659034018461;
        Thu, 28 Jul 2022 11:46:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n9-20020a056a00212900b0052844157f09sm1127537pfj.51.2022.07.28.11.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 11:46:58 -0700 (PDT)
Date:   Thu, 28 Jul 2022 18:46:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Move kvm_(un)register_irq_mask_notifier()
 to generic KVM
Message-ID: <YuLZng8mW0qn4MFk@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-2-dmy@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220715155928.26362-2-dmy@semihalf.com>
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

On Fri, Jul 15, 2022, Dmytro Maluka wrote:
> In preparation for implementing postponing resamplefd event until the
> interrupt is unmasked, move kvm_(un)register_irq_mask_notifier() from
> x86 to arch-independent code to make it usable by irqfd.

This patch needs to move more than just the helpers, e.g. mask_notifier_list
needs to be in "struct kvm", not "stuct kvm_arch".

arch/arm64/kvm/../../../virt/kvm/eventfd.c: In function ‘kvm_register_irq_mask_notifier’:
arch/arm64/kvm/../../../virt/kvm/eventfd.c:528:51: error: ‘struct kvm_arch’ has no member named ‘mask_notifier_list’
  528 |         hlist_add_head_rcu(&kimn->link, &kvm->arch.mask_notifier_list);
      |                                                   ^
make[3]: *** [scripts/Makefile.build:249: arch/arm64/kvm/../../../virt/kvm/eventfd.o] Error 1
make[3]: *** Waiting for unfinished jobs....
  AR      kernel/entry/built-in.a


And kvm_fire_mask_notifiers() should probably be moved as well, otherwise there's
no point in moving the registration to common code.

The other option would be to make the generic functions wrappers around arch-specific
hooks.  But IIRC won't this eventually be needed for other architectures?
