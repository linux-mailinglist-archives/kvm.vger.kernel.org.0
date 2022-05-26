Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE925347AD
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 02:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbiEZAqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 20:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345986AbiEZApd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 20:45:33 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F1D9EB44
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 17:45:32 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c22so118797pgu.2
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 17:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f4AX+KtvRK6LhGfmEdX/rRyvF5FWy936MY/9wJFO4uQ=;
        b=ryPNjIunYOmh62sQx6erT7+OoB4c7sx1X4PLmWfyMUa1fjfmSsdd/fAPuqKTQHiLH9
         9QmZKQh6aZzFUSROAsK5/Mt+GI5V20xPnuWoKjR00iVVnb/E2ZW7fqvAARLLGLff47UB
         MT+2Tw9htQ0k9AZxP2eX6NSHgGUJ6lSsGNrY7WZj094rbZwWmaWPTK5yUcJnyXHxeSKW
         fqRoTul2E+OUvxXlUz7znybW+1U9QvyP4KJp7OV0z8ho1FWdf7lTma4ijO/eCm35czW3
         qKEW9lUr/jfbHTNhaI/keweBGs3X6L3IfbZLr7lzjhHPbMyGNaFPhV+llcEyQQ/OypYe
         f6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f4AX+KtvRK6LhGfmEdX/rRyvF5FWy936MY/9wJFO4uQ=;
        b=QMSSx7OiXJiyp1MKUcrScvB/8zKg0QzSn0P0ObEyAzmsow2dHEpFPDupfZwyDFdpRQ
         E/gsW68GafIPK4tYRmIzM1yWz+XCeiZd1INVFTFM6ZBj4kDdHtkJY8aHXYeUmig7eIyx
         zd/6sdHWi4+TxV/Q+dCB1Aq+FzhepLCWMqn4fs76G8dsI3ysACOluGuuJdfPXSUpCBLQ
         xmb7zrumfEiAX89H9xPBjgS4Kn88kbrK4SGB/BJkTFGAl/3eRu+l4mGMAQK+JK3BXXe3
         FIclXbFeo3knfJpGU3afP1FK+v2W2i/9ef77J626lg08akGudW5YH5kfLky+OVEuSCKf
         bKWw==
X-Gm-Message-State: AOAM532vx2guHp0XTeXUaIa81T7cQ9FUCyodnnOszWnUBnRtwIVXG2tR
        qNVcGvPVODoerfvsfdfahlyYfQ==
X-Google-Smtp-Source: ABdhPJyqRXk3aEzaC9lOXLrxlB+ufa0EwVBh8NAbV8WzaVFpFce5P3SudCbOQGYsHO+Uio0yMWojVQ==
X-Received: by 2002:a65:6b8e:0:b0:39d:6760:1cd5 with SMTP id d14-20020a656b8e000000b0039d67601cd5mr31172162pgw.379.1653525931737;
        Wed, 25 May 2022 17:45:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902740500b0015edc07dcf3sm34132pll.21.2022.05.25.17.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 17:45:31 -0700 (PDT)
Date:   Thu, 26 May 2022 00:45:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Add knob to allow rejecting kvm_intel on
 inconsistent VMCS config
Message-ID: <Yo7Np1N1TVD4drxc@google.com>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-3-seanjc@google.com>
 <CALMp9eRgiPZeGhKHMnwJVSLPvKjPFo4vKzg3=TXTuLL_LSt_fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRgiPZeGhKHMnwJVSLPvKjPFo4vKzg3=TXTuLL_LSt_fw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022, Jim Mattson wrote:
> On Wed, May 25, 2022 at 2:04 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Add an off-by-default module param, reject_inconsistent_vmcs_config, to
> > allow rejecting the load of kvm_intel if an inconsistent VMCS config is
> > detected.  Continuing on with an inconsistent, degraded config is
> > undesirable when the CPU is expected to support a given set of features,
> > e.g. can result in a misconfigured VM if userspace doesn't cross-check
> > KVM_GET_SUPPORTED_CPUID, and/or can result in poor performance due to
> > lack of fast MSR switching.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> There are several inconsistent VMCS configs that are not rejected here
> (e.g. "enable XSAVES/XRSTORS" on a CPU that doesn't support XSAVES).
> Do you plan to include more checks in the future, or should this be,
> "reject_some_inconsistent_vmcs_configs"? :-)

I have no plan, it was purely a reaction to continuing on with a known bad entry/exit
pair handling being awful.  I hesitated to even apply it to the EPT/VPID stuff, but
again it seemed silly to detect an inconsistency and do nothing about it.

I'm not opposed to adding more checks, though there is definitely a point of
diminishing returns.  I'm just picking the really low hanging fruit :-)
