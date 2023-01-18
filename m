Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2986E672A9C
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 22:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjARVfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 16:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjARVfn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 16:35:43 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3518664688
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 13:35:42 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c26so22881497pfp.10
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 13:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6gn4Scs3BgxMPupT17oFLEaus/3MoMxttHnGXbn+ads=;
        b=LFjKFrSUAIXVGuEsqjuRm+OOfwryKjjHlfdfMX4eGZeiMOIJM05uIUXIWC04vYEMuZ
         TbegWEwnC1BrrmPC/ETVEnmEmeYc1/wdC+7G/X5kwwJL/GzPiw6n2yVXIeJiOz68pH6E
         Lo88be/1dzYylVkjftxk1BePiRb6mgaOGEPeb1nTlvMquRHoAbfLJQ8B51XZnZeFIlKf
         kPRke3CSom0Sp/wo4ahS2WmM7e1hj/aB+7idJaHhDWUWpP4hUOYbR6svKTZhERA2xlRO
         pFavDPYgHd2brkGDuQKS3Pk+YKbJUdY/57TktJ6/myz+36yJOCcQ4x2xuXW4gKgaOOT6
         DQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gn4Scs3BgxMPupT17oFLEaus/3MoMxttHnGXbn+ads=;
        b=UTqAQjUZOGJQFH7M/0XCKgdzaMSPWdp2GnkAHBcLVeNXUQBInzbxjCR8zzd5dTCduf
         XEbQ8z7h5dDHABL0+KtPJnyfX/a30g8wOlcR8l8cweS6H2Q7H2W+fUBoHV+brmaq81hd
         ju9MnYIMrkwAao3+G95QXfRkIiG0N6M1pHKxpd/arhkCxba81s6zz2CoPUt3orBojBNg
         VjGMkjpIBBDcvGLwTc46bfjbAeBqX/oK419TjVJe/VkQNx62z1SXDAPIDTDQDN3QmP0G
         iwf0uLB8rhpC9XWuuRz7bhWjZpByT6XIlsNUki5bxaQvNeIqqLGRXC6rHxMtgVc2lotL
         7pDA==
X-Gm-Message-State: AFqh2kpst5qFpXUGa+KMjdBW0c4JBo5ldiUb3mmk18eTCMWXF5EFXu7c
        SyIW7rR+MII8ogI6SW9TThl3FQ==
X-Google-Smtp-Source: AMrXdXuZFF7FxEcWOvvZFJ0aWMw0Wo3l6xqVgGyrHXjEa6RyV1zK927RN2SqBqTKO0Z1+APKZcEvmw==
X-Received: by 2002:a05:6a00:368a:b0:581:bfac:7a52 with SMTP id dw10-20020a056a00368a00b00581bfac7a52mr2962867pfb.1.1674077741564;
        Wed, 18 Jan 2023 13:35:41 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z188-20020a6265c5000000b0055f209690c0sm21772039pfb.50.2023.01.18.13.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:35:40 -0800 (PST)
Date:   Wed, 18 Jan 2023 21:35:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
Message-ID: <Y8hmKe5ojuqL94ex@google.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
 <Y8gT/DNwUvaDjfeW@google.com>
 <87bkmves2d.fsf@ovpn-194-7.brq.redhat.com>
 <Y8gclHES8KXiXHV2@google.com>
 <878rhzerod.fsf@ovpn-194-7.brq.redhat.com>
 <ae135ae1-191b-1d58-f12d-38694889664c@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae135ae1-191b-1d58-f12d-38694889664c@uipath.com>
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

On Wed, Jan 18, 2023, Alexandru Matei wrote:
> On 1/18/2023 6:25 PM, Vitaly Kuznetsov wrote:
> > Oh, indeed, I've forgotten this. I'm fine with 'vmx->vmcs01' then but
> > let's leave a comment (which I've going to also forget about, but still)
> > that eMSR bitmap is an L1-only feature.
> > 
> >>
> >>   3. KVM's manipulation of MSR bitmaps typically happens _only_ for vmcs01,
> >>      e.g. the caller is vmx_msr_bitmap_l01_changed().  The nested case is a 
> >>      special snowflake.
> >>
> > 
> 
> Thanks Sean and Vitaly for your insights and suggestions. I'll redo the patch 
> using your code Sean if it's ok with you and run the tests again.

Yep, absolutely!  As requested by Vitlay, please also add a comment in
evmcs_touch_msr_bitmap() to call out that the eMSR bitmap is only enabled for L1,
i.e. always operates on (e)vmcs01.

Thanks!
