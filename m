Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4ACC694C1F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjBMQNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjBMQNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:13:40 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443711CF6B
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:13:32 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id h4so6143917pll.9
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 08:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FLmWkbZ6W8xK93xqtmOh8udk6K0hgPNMyGvF9HpUGfU=;
        b=ZlJP0CXIrViYhrOFoUe8xuxJbCEt1fD2D0ag1jFg9EH9IhedaSsCk+wuNH1cPGpUqw
         GqtxmbBVvTjiCldKXMRMytdxAr9C8SRJVZZcN5TNRsyrZfYH06BUi0abP+lDKyi7Sgh5
         TxBgdwAlw5pUkzGaAGO97t7MWGoj4VU2+y6G6oj4Cz55OG8QmjbWeVUUe+bPTxRi1qgp
         mRnpsN7/rkRP17Fmy8whdl0DvjBJcCVweRwWBtjxK7oAsXeYXED+tWs66vosozXFdzgD
         Mlgh1+D3hU9RH0BeIJEw6bDxhJ9j1JBouexdQGCGix99q9Ea1q7J+ivvXLgnagXpaSKV
         bHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FLmWkbZ6W8xK93xqtmOh8udk6K0hgPNMyGvF9HpUGfU=;
        b=w9p3jQtWn33xPIre5TQ8dCXTefgK2w1OwMB9ehvQ/G+tIr10zaK6ij0JcOJp2E/nSX
         fw9xO2YFAZHpQNFBbuHCwgZgmu8JplAn2K+ydfGtaGocze0bJRVgibbW6nLI6BVTReH/
         elnMRs6BvIc5BXT7IozOH07M8jXA7GXtd8Z8BhRtM3rf2+PyIF/7K+witq2yKFp7aOKW
         2f1Jq73HxUxPqbiLw18Ds4yUCo7eens5Aq3MbOqWLq6r05LMwBE97/yNS0G7LAecUvfE
         QhUOE71a5Gl3wgB02E3yeCWgtgpVGN5DSSxLJHU/OBHtmfeyDCcYN/+L3ahvAcGF/A6R
         whLQ==
X-Gm-Message-State: AO0yUKV1rIj3enxYWcrcmiMK4TD3/HbYGxkdNIupoCCL9BMZhjsEJlxN
        X9pk3ZyS0dA2Ys0FXkpvVPwnsQ==
X-Google-Smtp-Source: AK7set/I5nfPc3xL9FZQVQvjiiiD5NXupUx+Nqg2zvw8k3DSFQd6yGY6CYyWNbhl6VXjNSAEY+QrPw==
X-Received: by 2002:a17:902:e354:b0:198:af50:e4df with SMTP id p20-20020a170902e35400b00198af50e4dfmr440640plc.5.1676304811530;
        Mon, 13 Feb 2023 08:13:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e8-20020aa78c48000000b005a8a894ca96sm3393179pfd.64.2023.02.13.08.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:13:31 -0800 (PST)
Date:   Mon, 13 Feb 2023 16:13:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     lirongqing@baidu.com
Cc:     pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86/kvm: Don't use PVspinlock when mwait is advertised
Message-ID: <Y+php3UhTwEjXZcV@google.com>
References: <1676124399-16542-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676124399-16542-1-git-send-email-lirongqing@baidu.com>
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

On Sat, Feb 11, 2023, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> MWAIT is advertised in host is not overcommitted scenario, however,
> pvspinlock should be enabled in host overcommitted scenario. Let's
> add the MWAIT checking when enabling pvspinlock
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1cceac5..dfa1451 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1087,6 +1087,11 @@ void __init kvm_spinlock_init(void)
>  		goto out;
>  	}
>  
> +	if (boot_cpu_has(X86_FEATURE_MWAIT)) {

IMO this is a bad idea.  Odds are good that there are less-than-perfect VM configs
that advertise MONITOR+MWAIT but don't disable interception.  Ugh, but we've already
added this logic for other features guaraded by KVM_HINTS_REALTIME in commit
40cd58dbf121 ("x86/kvm: Don't use PV TLB/yield when mwait is advertised")

Why doesn't the host simply advertise KVM_HINTS_REALTIME?
