Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737DD7401E4
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 19:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjF0RIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 13:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjF0RIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 13:08:43 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC93198D
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 10:08:41 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56fffdea2d0so51770157b3.1
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 10:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687885721; x=1690477721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zmTYBHiq1aAEhFeB5lbw1u0SmbjoMvuQpM4GCZ6yf38=;
        b=IVA1fW9z3fvV2citHCS4ShP8SJ355AticUoDo8b4hCd7KVDGS3NOP0gYlyt4iz5YTS
         HAki00VvRLmzk1A388nL1Pqw2E6th3LdFtMjILyxEZmr6mdFs80Vlq4cbYPVMVjSULq9
         OguibegXP3fdCKzrispjaCvcaiHsItetv3OaZKsfWM4B3krqFqOCDKXyaU5FtaHoUa54
         lhfjc5h563F0SoDc6Y9XXlljkNAANgnzNQQElnZrKXuCxNX5naT2+Y041W0YBSdPOBmS
         EIOddBn7CiOslBCcl+66cqhgqclSDddd2PKx6mBJdkjOGd/lQ6yVYUwgjexWDhQ5WfHU
         Wr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687885721; x=1690477721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zmTYBHiq1aAEhFeB5lbw1u0SmbjoMvuQpM4GCZ6yf38=;
        b=DuWVyb282y/6fPAapbM9BYLqDnGSnACqiivY/TKZqPQk5+g0v+ipYrnENdHgyValKm
         TypMH2WlPT6xEZjqFfKb5jdqfoDAfOdWmJSWtwS3F8z6Fim16ZQxmo+MMC4ApDyfsBIw
         OwywFs+FMpIiEZOXgWnin8EbHFZi8Ng//iq7jT7i4wob8GxpebgpE2trtCxS3/7anjj7
         SYMVhEHTJcozJSidyyQXBh0m5lWl0nVfM18JQIkkWhegRNHyHvZmPv4r5CTiK1nzgonj
         rDx+AqRTTx4ULn+OqB98ISpPr7Y6eVUEQPTt8n/25aCyNQPeblSQS9K+/e/HRl4IpKIE
         hpQA==
X-Gm-Message-State: AC+VfDxUqaJvTNpNpkirHm2FrMcTmyIGSIpNmr25FU78wfi4zpoR5YW2
        QmRbxNrCH1X2GDpBdTRWP7MyBH/W6MY=
X-Google-Smtp-Source: ACHHUZ4x/kmMRFuVDQPoWm9oePlEoaxawv+Tl+xLy1w6ikaFM/ufb1HKrZ3JhOLWb11Z/yZ7OXbmMpfiMmA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4046:0:b0:55d:d5b1:c2bd with SMTP id
 m6-20020a814046000000b0055dd5b1c2bdmr10445571ywn.8.1687885720828; Tue, 27 Jun
 2023 10:08:40 -0700 (PDT)
Date:   Tue, 27 Jun 2023 10:08:39 -0700
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
Mime-Version: 1.0
References: <20230601142309.6307-1-guang.zeng@intel.com>
Message-ID: <ZJsXl6emfV2yr4rs@google.com>
Subject: Re: [PATCH v1 0/6] LASS KVM virtualization support
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023, Zeng Guang wrote:
> This patch series provide a LASS KVM solution.

... and depends on kernel enabling that can be found at

https://lore.kernel.org/all/20230609183632.48706-1-alexander.shishkin@linux.intel.com

> We tested the basic function of LASS virtualization including LASS
> enumeration and enabling in non-root and nested environment. As KVM
> unittest framework is not compatible to LASS rule, we use kernel module
> and application test to emulate LASS violation instead. With KVM forced
> emulation mechanism, we also verified the LASS functionality on some
> emulation path with instruction fetch and data access to have same
> behavior as hardware.
> 
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
> Chapter Linear Address Space Separation (LASS)
