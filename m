Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0437D3F2E
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbjJWSYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbjJWSYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:24:23 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA2F9B
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:24:21 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6bd0e1b1890so2718978b3a.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698085461; x=1698690261; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pRUzO+vkA/3Zt2fqE2RqLUfgJAG2Koxv6V/JjBYAdSo=;
        b=udM3V4sCt/BN1axuSpiL9PRQuAI/CqASmIvE7/B9TXdV4y3TsnKD2CvHq95xhG4QhE
         8+Y6dhFkrLPjnnseMaXF05ub93djmLvwcxdpCK4wuCKKeLGn5iV/3egrkPQQSV8mwFTO
         jB/Ka3G9+jbkSnhohuCim6yXdN4lywd+NUVKIRSa/SB9hZ7MA+rQgQYphzvWcC9Sw6uy
         5SBt9o+oTrPXDk2/6Jt/ZBJvp5IFwawPPi2dSac38KtqNvIHUwyzkBOiI/b7s+eT8vjC
         fxzEaeonMUx56SlZTjAwU0KQUsv/uW49CLwp43Ue5mNkvjfz6f0L+RTPJiGD/HWHhW9P
         ZnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698085461; x=1698690261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRUzO+vkA/3Zt2fqE2RqLUfgJAG2Koxv6V/JjBYAdSo=;
        b=AgIWnAgg63eSv4qH/DRKWpVrDM+LviyNeuJCGauMG9rd9GWpCNfP8YTCv0T63tLtYp
         qTG8/Qb/rvB006jcal9dJF8Ts/cc+Y2u13hSdtXjJ9an+86CGtSUEAmyKvwQL2v2H7DG
         R6Q/BjfrIK9zk81qXuMfowJzrFqu6hGnhNczFQKEyqDTtiOA1+q6FqLsi0V2iUjtK/Fq
         uATCRcwp31sHmRqQH0UM/WKkeL7/2p+CQRQEtqc1XvLifPPd+lHECi6NUmzh1y2sWLTl
         2xXuRivQceKkUZOeh3l/dV54VpZUW22m492fN7gEyGnviN6Z22jvHP6HzOzBCbeOvZEj
         Sw+w==
X-Gm-Message-State: AOJu0YyouCePHFTXcJ1anXxmcxGLm4yp84KSAhdmdKrcIyMYptoe0PAq
        RKP2+ZZYCfRaHKjagZnwWAaOtV691JJXB2fmBDlOnA==
X-Google-Smtp-Source: AGHT+IGARxHq2zVxQ8Iid/WtBfTcT6aevXTje9qZk79/sXfRA5kbrUniRfbW0USHrmplTwKRjh9edQ==
X-Received: by 2002:a05:6a20:c19d:b0:16b:aad0:effe with SMTP id bg29-20020a056a20c19d00b0016baad0effemr358243pzb.62.1698085460734;
        Mon, 23 Oct 2023 11:24:20 -0700 (PDT)
Received: from google.com (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with ESMTPSA id p9-20020a63e649000000b0057412d84d25sm6055619pgj.4.2023.10.23.11.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 11:24:19 -0700 (PDT)
Date:   Mon, 23 Oct 2023 11:24:15 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/3] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <ZTa6TxJS2erGBxgp@google.com>
References: <20231018204624.1905300-1-seanjc@google.com>
 <20231018204624.1905300-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018204624.1905300-3-seanjc@google.com>
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

On 2023-10-18 01:46 PM, Sean Christopherson wrote:
> Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
> completion queue, i.e. when a VM and all its vCPUs is being destroyed.

nit:

  ... or when the guest toggles CR0.PG or async_pf support.

> KVM must ensure that none of its workqueue callbacks is running when the
> last reference to the KVM _module_ is put.  Gifting a reference to the
> associated VM prevents the workqueue callback from dereferencing freed
> vCPU/VM memory, but does not prevent the KVM module from being unloaded
> before the callback completes.
> 
> Drop the misguided VM refcount gifting, as calling kvm_put_kvm() from
> async_pf_execute() if kvm_put_kvm() flushes the async #PF workqueue will
> result in deadlock.  async_pf_execute() can't return until kvm_put_kvm()
> finishes, and kvm_put_kvm() can't return until async_pf_execute() finishes:
>
[...]
> 
> Note, commit 5f6de5cbebee ("KVM: Prevent module exit until all VMs are
> freed") *tried* to fix the module refcounting issue by having VMs grab a
> reference to the module, but that only made the bug slightly harder to hit
> as it gave async_pf_execute() a bit more time to complete before the KVM
> module could be unloaded.

Blegh! Thanks for the fix.

> 
> Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>
