Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7689D6748A5
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 02:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjATBMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 20:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjATBMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 20:12:00 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407744DCFC
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:11:59 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g205so2884539pfb.6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KLLOuv1S5xTn1rjXYscOd3PZw73M1sWaf11TFHQjeg8=;
        b=oc7HVVLv88ufQU5NguQWqr8Yr0B+TbXhg3pHSzEF3mb1513AIEvN+qVrl93YRQjYTi
         JZPwF2tZVOQ0WA5KVzRKqwyqSZJE6bERKsncHfxssopTBFL3Rr28s343sD9KmnDt1ec6
         N8MHya73KVh3JsGmouPFO9RdobrdGOLt+nSG4hXI+DN8Yjz48Mka8QQeLqTAM9VdN/OS
         LldSrQ3e5IniqwA7PZ1T1c1mubkhdWVT1fYdx4xwpWsFI+2YQ75JjDIvZRcJRcEa/7ol
         UUwHH/M6Nl/H+tlIDND9uRJNZEWj2VVUmhiqzGcHaFTHdVvUu5s1XoxuVzQFxC/C15Fp
         EycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLLOuv1S5xTn1rjXYscOd3PZw73M1sWaf11TFHQjeg8=;
        b=r+TzizsaPPLvrqc4JLWbYCqkAQwr0uEnxbWUjjs7otwdIT2uCc/V9Ug41Jhjf7p1/7
         8jiIxxmO55wH9lC6mABcOAOKX3IcWgIqp2Y5VwD4PxJpKC8IrHGfD64+dLQdLGX0zW4P
         F8VO9aBSC1ldF4gKlG1AGQ9tInNRVl3W1uUG9HTs4UE9pDjMZksZDSSMoY+e6AXUCRXg
         tTpWjvWgCy9A6VK5Jj9kTrujAiK/uH0maqWClEbsuioBR2UcAVdsBWfQGM84w6fCcKcv
         EsFSAfQLvMO7rVozhrti6J9CQel+Jdj2KpNKGJ/srwd+xU7kRFjb3N25kZHtmCAisULa
         /Znw==
X-Gm-Message-State: AFqh2kqk2Idq4ABvSnySUsFUdcYZqltHN2+1ghbqRj4G5fhXZH+eYN8k
        oq/0uTb2phMuKfry7BU+wY9E6A==
X-Google-Smtp-Source: AMrXdXtsYDh4XwQKTw1fk+Yq+6SQ99wH8Qs5JDgrnN4pwtbfObWS2/M+QfH5uPvgXUrSV2Ay0gYgfA==
X-Received: by 2002:aa7:8692:0:b0:582:13b5:d735 with SMTP id d18-20020aa78692000000b0058213b5d735mr18721pfo.0.1674177118583;
        Thu, 19 Jan 2023 17:11:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k18-20020a628412000000b0058103f45d9esm21477938pfd.82.2023.01.19.17.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 17:11:58 -0800 (PST)
Date:   Fri, 20 Jan 2023 01:11:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/8] KVM: x86/cpuid: Use fast return for cpuid "0xa"
 leaf when !enable_pmu
Message-ID: <Y8nqWl+kOvc8WPdK@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-9-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111102645.82001-9-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Although when !enable_pmu, KVM will have zero-padded kvm_pmu_cap to do
> subsequent cpuid leaf assignments, one extra branch instruction saves
> a few subsequent zero-assignment instructions, speeding things up a bit.

I doubt my motivation was performance, I'm guessing I suggested adding the explicit
!enable_pmu check because relying on kvm_pmu_cap to be zeroed isn't obvious.
