Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E7478CA86
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 19:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbjH2RQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 13:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237791AbjH2RQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 13:16:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C615CCF
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 10:16:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59285f1e267so645847b3.0
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 10:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693329340; x=1693934140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=szAtscjFMS4L+N9zWMLu0nK7Jc3CUSxoaHycgdXGaV0=;
        b=gyDH4Cz3RakTcFuZVyoHLj3LfGM3O6UX3cK6GxHf8h382DbiY0LJX8gqYIu3MhIYxn
         2GnmKLfCRtKbbBj2rxE9xE/HV9JGj9Xo4mqEzvA6z1wC5jNX2gY2yr+2ns1cqyQ0HpG6
         bnDUPXm6tuq8CSvYRmmCeM4KxOd/rfpd/R/nuGil+lhWakaivo31zZaf6IETHKTLY+nh
         NP89XobhKA58H+nEadY8iVCSuG04nDlkaOUz+oUTgqsFlipw+dA8KBFdXSWNOP2ilcPf
         YE0JSeijmCWf4blL78+lLfcBbvLzXw4Xc5lljp4OOqgsQvzcfgVoRt2TAOd+gOJBLww8
         DGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693329340; x=1693934140;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=szAtscjFMS4L+N9zWMLu0nK7Jc3CUSxoaHycgdXGaV0=;
        b=DO/BSsQ3e9rwEJavvYJ80J+PiyaiqCleIyIUQ+UK09Ide1gBc4eiTgFkcDdVeBdUbf
         W7P1PwkXNSUzo2wcvxS7MDymBFKLPH/viaSK1V/sPvInZRTVlVbEvSEBLVJZJL/UQ5Eb
         raEy41JzEtngk9/3ctakcg+0UAY4lgu7KVJBjvfNxBrRRlaANA8yS/JVyYLyo7DS15G7
         CjH8+qwXuvJv3eo6fiFPa2rT5AEi+cwJmx8PL3t8gaRAVjdLu7WAklodiCAnuM//4QU3
         Pi8oCkE9YOtatlZNVyuJszpd2YhmJCfpz0EjAJyC4Nv5sQLQkc9akqiR6lmrG/X6pNG0
         gl0w==
X-Gm-Message-State: AOJu0YzkEehTYN8dp2cyTiGp73lSq8IaAHgVdsQtJLqOWCWuKpIPEDz7
        HoW6dO8HS2DtWtrKHfel+sbzc4wEi6E=
X-Google-Smtp-Source: AGHT+IGNeQsynQnjXOrWGXLtyGL5rb3TVeLftv6yvSl9m5aWq7NpTcAuXPfAthH2U/JyinQ9f+puLzqHfTE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2ce:0:b0:ca3:3341:6315 with SMTP id
 197-20020a2502ce000000b00ca333416315mr118079ybc.0.1693329339751; Tue, 29 Aug
 2023 10:15:39 -0700 (PDT)
Date:   Tue, 29 Aug 2023 17:15:37 +0000
In-Reply-To: <aff7354d-af68-c283-b607-029218af183b@redhat.com>
Mime-Version: 1.0
References: <20230825014532.2846714-1-seanjc@google.com> <169327846893.3063999.9479426554624511592.b4-ty@google.com>
 <aff7354d-af68-c283-b607-029218af183b@redhat.com>
Message-ID: <ZO4nuQGJb2Fp/VCD@google.com>
Subject: Re: [PATCH] KVM: VMX: Refresh available regs and IDT vectoring info
 before NMI handling
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023, Paolo Bonzini wrote:
> On 8/29/23 05:11, Sean Christopherson wrote:
> > Applied to kvm-x86 vmx, gonna try to squeeze this into the initial 6.6 pull
> > request as I got confirmation from another reporter that this fixed their
> > problem[*].  I'll make sure to make note of this patch in the pull request to
> > Paolo, worst case scenario I'll drop this one commit if Paolo spots something.
> > 
> > https://lore.kernel.org/all/SY4P282MB10841E53BAF421675FCE991D9DE0A@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM/
> > 
> > [1/1] KVM: VMX: Refresh available regs and IDT vectoring info before NMI handling
> >        https://github.com/kvm-x86/linux/commit/50011c2a2457
> 
> I'm back, so feel free to add even the

/wave

I'll get pull requests sent out later today.
