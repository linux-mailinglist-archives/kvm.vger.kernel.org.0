Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776704AC961
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 20:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiBGTX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 14:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbiBGTVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 14:21:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDD4C0401E2
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 11:21:24 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id qe15so4369743pjb.3
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 11:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dQAmEJaTjsYYRj2/TdOMTdvz+CnRCYyBekCT/t8kf+I=;
        b=sDoAX6Ob3ofOrHoMs08opCxUyc5qyAleP2EdPje331+PoY9+p3tHS81w/wOhERj1v0
         1Y6NHxbgaGvbgf+GfnJonkDP7YDfJ7F+4UwhIwJr9YvU3XI+g6x+OAqYPgV5Kyd8LPEc
         2VM2Ol0xD8wL7lCq0lEkbawbcKHzGYyegUbVYJ9sDWvQ2MfxhMVLb8G21aVb2qOXVrz2
         u0tCqjBaemKygGUudLqVQY4NcLRMDUy07FR6V8y3EUjNhDHMRXQReXGQdTzNKbit5/io
         hwEVTkStMysseSIvXNrYRYfppmCk9nI2r7dhQnk21INNuuVRU666S9oLYoDOF5teROrm
         Ul1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dQAmEJaTjsYYRj2/TdOMTdvz+CnRCYyBekCT/t8kf+I=;
        b=aDNKt8yiizYDy6LTwkPNk9eZW6rGBa2qm6ctr/MFpk5jVCmTf56u7jUQbgG7LufTxs
         QFyEjr/WoL7Z8MV+hx6oBP6uIlYWAB/AVzXwStMfFW35y79zVp6AchCOM1qZKDQc89sw
         9JC6Sv0AsE7ljIyUw+x3/PX8/tDSziA01fUcM2Lkfg6Bmus9tagzvI02u1SCDITgz/M/
         VjlpDlLY2ss15kVbSNCIG63omWPtLoMgb9nsPB5VfRb5I+ESfMGzITcFOoIBwpTmymoZ
         ZydPnib9pSb34beuAffphLJCi2AN7iawPX4+TCGDVc8KGft213ARfxwitlcaskXzaD9G
         zLzg==
X-Gm-Message-State: AOAM530k1LWE9LzktiukCojO0UKtllv3m7kn6vceI8h0BzOZyxjWycWG
        +tzgsaL1XOvn7yYioNkyieu7pA==
X-Google-Smtp-Source: ABdhPJxXhdfSruO+ikpUuqBs1S04IgVhjGiIXc1y929u282qTpqJFP/GTOHlzX5pIpHxgc7zLNgqcQ==
X-Received: by 2002:a17:903:11c7:: with SMTP id q7mr1135434plh.83.1644261684169;
        Mon, 07 Feb 2022 11:21:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h14sm14265846pfh.95.2022.02.07.11.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:21:23 -0800 (PST)
Date:   Mon, 7 Feb 2022 19:21:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/emulator: Defer not-present segment check
 in __load_segment_descriptor()
Message-ID: <YgFxL1uTKPCUpokQ@google.com>
References: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
 <117283244eab58e94d589af58a5f2b245b8c0025.1642669684.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <117283244eab58e94d589af58a5f2b245b8c0025.1642669684.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 20, 2022, Hou Wenlong wrote:
> Per Intel's SDM on the "Instruction Set Reference", when
> loading segment descriptor, not-present segment check should
> be after all type and privilege checks. But the emulator checks
> it first, then #NP is triggered instead of #GP if privilege fails
> and segment is not present. Put not-present segment check after
> type and privilege checks in __load_segment_descriptor().

For posterity, KVM doesn't support CALL GATES or TASK GATES, so the "early" #NP
check for those is missing.

> Fixes: 38ba30ba51a00 (KVM: x86 emulator: Emulate task switch in emulator.c)
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
