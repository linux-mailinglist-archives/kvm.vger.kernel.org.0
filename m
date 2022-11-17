Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8422662E362
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiKQRsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiKQRsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:48:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86980FE4;
        Thu, 17 Nov 2022 09:48:28 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so2259582pjb.0;
        Thu, 17 Nov 2022 09:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s1yYyNmZdv0daCGoHPHS3FUErcT+tuPk7PSjFra0en8=;
        b=cGLj1pwtomgmbByfX6WX1U5VFKSYmw1CoVvTun74RZ1F5WUcqXYadMBeRKWnQD4sbD
         UEtWkhVQMvidb7CS/SwYw5dMznbXkc1A2fjJ7P+AD6C+5UoEgKJc3CbYekdSMe2F3rGO
         iPfq0sUfX2kgjHUCJi+1SPy7G5pmwUsf/HZUih8Z7edJP8AdfSmBYgO/EJoCHv67bMfJ
         ly9iIYlmBxqawthD3cxy2wmryDHf85BW52l0PniSXiv9uuZVSms5B6XUIImmEl8ZAnlM
         c0o2d9ed96ww9fRCky1LsXK6DQD4vVAQiy5Mwvd4a0Yv83J3zxKMiHzxDt/Qi0mabbZP
         2qTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1yYyNmZdv0daCGoHPHS3FUErcT+tuPk7PSjFra0en8=;
        b=PBZJmLIfcbmNkCYaSS+yLER1SDwOOHy3zuaV/uehJSblO1NB25WtsvrndbFahelSXo
         gbPoE6Jz8wy1oL4HsZDwc/40jf6KH3TSGoEKbi84cR68r2lhlk7XDswFn/JYADntE2s6
         UM9NrXvYNjX2dRWcVNGRCkMnP+QWSs8Hm4PfvKvapSjCOiwbgMopg2o/P4iBcJxSmPGM
         q1gOpHG/7fti4WsecyyTPSWbGjOsSr4y3h+wioIIFUnutF5TeOahNmrf23otpFK/C/rE
         amge5m60GGgtKugtt5+fJhgc0nysltpjcqrn/MB1zfyS357KFgfBZ9XGOxyWy9h1qCgN
         mWeQ==
X-Gm-Message-State: ANoB5plLyq4BRhFq6jf+DsuGjvu8Rz7ozo51Yu0tQds+L7lJxKn9gMp8
        aufdPzuD5p060d2rAP1epTdZQf4Aols=
X-Google-Smtp-Source: AA0mqf4Bqehu/lUEeB16X4B1QBG8C+LCUyw88XLJlnfIwVSP0sizWnH3+FPhFqN4bJVqPLWWSrlqWw==
X-Received: by 2002:a17:902:8d92:b0:182:e9dd:936d with SMTP id v18-20020a1709028d9200b00182e9dd936dmr3949002plo.6.1668707307958;
        Thu, 17 Nov 2022 09:48:27 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id r8-20020a63ce48000000b0046feca0883fsm1233253pgi.64.2022.11.17.09.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:48:27 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:48:26 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Message-ID: <20221117174826.GE2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
 <CAAhR5DFGvGQmf95hrGcK0uvawvFrzdCisnEtvLV8k8pM3FRV_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAhR5DFGvGQmf95hrGcK0uvawvFrzdCisnEtvLV8k8pM3FRV_w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022 at 04:06:10PM -0800,
Sagi Shahar <sagis@google.com> wrote:

> > +int tdx_vm_init(struct kvm *kvm)
> > +{
> > +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +       cpumask_var_t packages;
> > +       int ret, i;
> > +       u64 err;
> > +
> > +       ret = tdx_keyid_alloc();
> 
> Can we skip the hkid allocation at such an early stage?
> This makes intra-host migration more complicated as the hkid of the
> destination VM is already allocated before we have a chance to migrate
> the state from the source VM.
> 
> I remember you had an internal version that already did that in
> https://github.com/intel/tdx/blob/552dd80c48f67ca01bcdd10667e0c11efd375177/arch/x86/kvm/vmx/tdx.c#L508

With the patch of "KVM: TDX: initialize VM with TDX specific parameters",
the allocation code is split out into its own code with KVM_TDX_INIT_VM.
I think that's what you want.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
