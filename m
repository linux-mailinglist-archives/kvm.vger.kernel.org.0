Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C347E743E71
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjF3PQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjF3PQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:16:06 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A7F468F
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:15:26 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565ba5667d5so18305607b3.0
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 08:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688138126; x=1690730126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7oJzLLPGW/Cx9f/CDqtoSXPOSWREn06ZdPTZhJC3Go=;
        b=AfsXkZXlZJPvva1bmvipN9xiFdW0LWN5Ibj64QQvTBdzXdIrAXkFx0kUhmllcfNyjr
         pAlOJ7sJPNzfIfdXxHCn+R1qQiqSw5cQGKtoSE6I6+1q8qU/HMbjfixp7a/mjyvMyoSN
         b02kSEaYdL50YI1V7wz8SUtGgKFRBMVHxhqhbre0ua4nYdt2U9kAYDTJdJqzJlwBBfYb
         Wkx8i9WsPC9wi3bibCZvTbX2brPCZKCZVckU/uqISG3uTscgkQcXTeIN9YeVJyoaCl7A
         zKj67sA93xoBdrCn5C5jXdJufo2VXCIJY2kHP7iLx/xm7YwAjcj3Z6QR/wXS39Pna9ie
         b2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688138126; x=1690730126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7oJzLLPGW/Cx9f/CDqtoSXPOSWREn06ZdPTZhJC3Go=;
        b=g6nih9lEtPY1pxxHuDB5LxhxT0mSTjSDpEj/K9InMcIHDMO8bNxcTP3w/t5XJkwoJs
         LIO4EGv2OC5zMvRfZk27XZBYoPUPrgE0nQuEuvrNkR/CHr24xeIv2EC4WXnZC0M5Qkvk
         Ihdxk7bqWQcn5QazJyMR7LGlbmG4EZHtgIvCyzzEM74OxKsti+TXEIfhWpxHrHGR9086
         dDYJxcd7/UP5P6plLDZ876+T3GHW6q75x8P/MIVB7rXT//fM+J0HnOPYyTjc6N9C35Mo
         C4TJbJ+N09qKe+bpWNy8XmCOh5VRBZt1JjKJTUO9PmAWmRdworKb+rcPxDwi5YjRzdQH
         RkOQ==
X-Gm-Message-State: ABy/qLb+87P/mY1xe+XEZYYyHNKWfr2HT0/eNxq0kHZUXNpRV1Paf8Bs
        NFP/JZdWS8XNxu6N5bJ+X6gRMf57Iug=
X-Google-Smtp-Source: APBJJlHTHksxFR2/TcaLyjYYDz1o/aFwnGkFGVCI/XRMxF6grQX75vNH1cRAuBQ+JkPyf3jb4+BDxo/E2y0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ac0b:0:b0:c3f:b53e:b2c2 with SMTP id
 w11-20020a25ac0b000000b00c3fb53eb2c2mr22548ybi.0.1688138125852; Fri, 30 Jun
 2023 08:15:25 -0700 (PDT)
Date:   Fri, 30 Jun 2023 08:15:24 -0700
In-Reply-To: <CO1PR11MB5107FBC68DBA6877E390A633912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email> <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com> <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com> <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ6uKZToMPfwoXW6@chao-email> <8dec8b09-2568-a664-e51d-e6ff9f49e7de@intel.com>
 <CO1PR11MB5107FBC68DBA6877E390A633912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
Message-ID: <ZJ7xjE0qMjpYIiB/@google.com>
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception classification
From:   Sean Christopherson <seanjc@google.com>
To:     Gil Neiger <gil.neiger@intel.com>
Cc:     Weijiang Yang <weijiang.yang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023, Gil Neiger wrote:
> Intel will not produce any CPU with CET that does not enumerate IA32_VMX_BASIC[56] as 1.
> 
> One can check that bit before injecting a #CP with error code, but it should
> not be necessary if CET is enumerated.
> 
> Of course, if the KVM may run as a guest of another VMM/hypervisor, it may be
> that the virtual CPU in which KVM operates may enumerate CET but clear the
> bit in IA32_VMX_BASIC.

Yeah, I think KVM should be paranoid and expose CET to the guest if and only if
IA32_VMX_BASIC[56] is 1.  That'll also help validate nested support, e.g. will
make it more obvious if userspace+KVM provides a  "bad" model to L1.
