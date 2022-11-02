Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E6161694C
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiKBQi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 12:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiKBQiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 12:38:20 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8005863F6
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 09:33:22 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v3so1740903pgh.4
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 09:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bSpvtaO5+biFCdXjgWOU/VG7HbNWLZ5uq+eRXSvuuCM=;
        b=QFzFFdsD02xgwNnv6w/5D3h0dWbBgJ42EmoGbAgWbOReIP7ibvMB1sHHN5oEGVDyK2
         bk3kncpJvgSara7MPPqv92ajq9XrSKjcvnywOsb4pV2qvmxneWfV7ARhIkMOGJwlrz8R
         1Wwd/25n0QydVBeAVmeDEjCCXnRkwe9F3P5rzk+d4bD1ddvkvul8tu19r92ToFUVyoGx
         nlwWSse6N6Jrp3BrkQdIfBw3LZGgL0c72+hR7wt3XtF30HeXkl7FuQ+WbQd2KaROGHaG
         irDvrqhCVigzw0R9bF16EmQWLdUFa8qhbnJy8fQMwqr8Dq2eNuzsKxKGR7dvUWm40Zes
         M5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSpvtaO5+biFCdXjgWOU/VG7HbNWLZ5uq+eRXSvuuCM=;
        b=XZm04GM77UL91rgpPt8ZfRTf/ALZenlr/XPdf5z6v6JVowahDJiuvfeaN/hbmVEpgG
         7ue8Rf2jNynjAsMtWQbMMmderWL/61KYUwlPfWFrSgqkUzO3mZ9AoUbWVVEUWQRWSL1M
         GDNxPINA9SacCVmt4n94UcsADdQMA+mAAJofMGZx6gfXIYapuPBI9apD4xrY3oB2CZVQ
         cPzfeEZRzynICWsUPvj/6+tLLGJoBcGT1nnb2qnXHf56P9i+ie+7sXIeZkwUqYfhgb/7
         C9FEXYiFSAbaeKrfy9+pbViyCjOshJMTIatRpgpeV9GF5zofmPQO647fUa07e4MsSxvf
         Py1A==
X-Gm-Message-State: ACrzQf0k5Nz++htqf/POG82Y1dAq0N0T+jSWKwdKZDoUtKgU8pkhudPx
        7OUgnmazHh8Wa1fFrh22e6sK3A==
X-Google-Smtp-Source: AMsMyM7/IFIrAzLF68OTsZpwvpWxXuJLq80r9JuhA6FJpKg68htFc94IYvOx1OmW0dUzBtPQISiKSQ==
X-Received: by 2002:a63:fc12:0:b0:45f:a6e3:7559 with SMTP id j18-20020a63fc12000000b0045fa6e37559mr22400123pgi.237.1667406799666;
        Wed, 02 Nov 2022 09:33:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b00186a2274382sm8586776plx.76.2022.11.02.09.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:33:19 -0700 (PDT)
Date:   Wed, 2 Nov 2022 16:33:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, oliver.upton@linux.dev, james.morse@arm.com,
        shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 1/9] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Message-ID: <Y2Kby0yXu0/Zi2P1@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-2-gshan@redhat.com>
 <Y2F17Y7YG5Z9XnOJ@google.com>
 <Y2J+xhBYhqBI81f7@x1n>
 <867d0de4b0.wl-maz@kernel.org>
 <Y2KZdDAQN4889W9V@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2KZdDAQN4889W9V@x1n>
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

On Wed, Nov 02, 2022, Peter Xu wrote:
> Might be slightly off-topic: I didn't quickly spot how do we guarantee two
> threads doing KVM_RUN ioctl on the same vcpu fd concurrently.  I know
> that's insane and could have corrupted things, but I just want to make sure
> e.g. even a malicious guest app won't be able to trigger host warnings.

kvm_vcpu_ioctl() takes the vCPU's mutex:

static long kvm_vcpu_ioctl(struct file *filp,
			   unsigned int ioctl, unsigned long arg)
{
	...

	/*
	 * Some architectures have vcpu ioctls that are asynchronous to vcpu
	 * execution; mutex_lock() would break them.
	 */
	r = kvm_arch_vcpu_async_ioctl(filp, ioctl, arg);
	if (r != -ENOIOCTLCMD)
		return r;

	if (mutex_lock_killable(&vcpu->mutex))
		return -EINTR;
	switch (ioctl) {
	case KVM_RUN: {
