Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28546BB7B4
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbjCOP07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 11:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjCOP04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 11:26:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036E03252B
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 08:26:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n203-20020a25dad4000000b0091231592671so20578787ybf.1
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2yqRC6qbo8cvknlxHZKANZNmM890Fy3vkfMCJNph5rs=;
        b=gsI5J9geXqxFD1aSVUbnlJ5hLkSPB8642vl1u7JiuRJfeYClwh7YTd/ONwhZuSbSVT
         OilsLA3NH6KJAHAkYV0qbLeOwvNZm74pTaQ907zE3ZyHBLRcO+J670bLL+WjvjB+f2z9
         KfkpOg5Skk/7vEyQsGLvi4YNZm0klrH8TYW8svlaoRpVQMQciyB14nojzSQRPA8x96aE
         zBSYv798Am/CeTfo/1UqjNHj9U0yWQn3W4Rhw43Pb0lg6d6xzGpqPN1hGOZkRxK8LHcV
         PjDW9VN+VuHF+J95p/DmWp1+dIkykJnEx/z46EhaI1bE4gnUWTg0szzY3RBgT5wbMS8I
         2HoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2yqRC6qbo8cvknlxHZKANZNmM890Fy3vkfMCJNph5rs=;
        b=tJLD3BG75KdnXgDkPubIXVNnvBxm1+bkhyff1ekErj2xrdoQgCiii2T2iMQo/3Q/kz
         g2a7MqI3IwS5DwA3RoRjUx9lgC/hpPQ8OnaVnRbC64O1xxEtI5Cjua0brJHxTI3eANnt
         gc8K00XgeTzfer9uu5hQ9rwJ/+xPFFLnrYULOk3XTt+6uenTfhd+KEtSSxP2QQ2tpIwb
         MVOojs6M1YN9g8rkuQnkHF9abnWvPHWNKiPNx/KfxLpkF4xCJXysNjxqmxontXgzzQif
         6LR4XVrDZYHNTpiELlO5+9kamIvh+3QGR3uPS7Ao9/BNTt0rcDe5VS3b6lFI3fhJptKI
         2R8A==
X-Gm-Message-State: AO0yUKVhhAhjL+avwM9pvCXb7+ZIawA9/i+a62nK2Lk5td2Q0qC1b7bp
        vlBWYiHQ7smqEkrPuK44kD4mgW8wHF0=
X-Google-Smtp-Source: AK7set8X+IPd7ygj8LYpkgCO05n9OjffsSGyuvvpdVY3XMj2ZgOHLT8eCOGtJn39bzOC/BoGT3rBxi2zBk8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3f01:0:b0:b26:884:c35e with SMTP id
 m1-20020a253f01000000b00b260884c35emr12045087yba.4.1678894014306; Wed, 15 Mar
 2023 08:26:54 -0700 (PDT)
Date:   Wed, 15 Mar 2023 08:26:52 -0700
In-Reply-To: <01086b8a42ef41659677f7c398109043@baidu.com>
Mime-Version: 1.0
References: <20230215121231.43436-1-lirongqing@baidu.com> <ZBEOK6ws9wGqof3O@google.com>
 <01086b8a42ef41659677f7c398109043@baidu.com>
Message-ID: <ZBHjNuQhqzTx13wX@google.com>
Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
From:   Sean Christopherson <seanjc@google.com>
To:     Li Rongqing <lirongqing@baidu.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Mar 15, 2023, Li,Rongqing wrote:
> > Rather than have the guest rely on host KVM behavior clearing PV_UNHALT
> > when HLT is passed through), would it make sense to add something like
> > KVM_HINTS_HLT_PASSTHROUGH to more explicitly tell the guest that HLT isn't
> > intercepted?
> 
> KVM_HINTS_HLT_PASSTHROUGH is more obvious, but it need both kvm and guest support

Yeah, that's the downside.  But modifying KVM and/or the userspace VMM shouldn't
be difficult, i.e the only meaningful cost is the rollout of a new kernel/VMM.

On the other hand, establishing the heuristic that !PV_UNHALT == HLT_PASSTHROUGH
could have to subtle issues in the future.  It safe-ish in the context of this
patch as userspace is unlikely to set KVM_HINTS_REALTIME, hide PV_UNHALT, and _not_
passthrough HLT.  But without the REALTIME side of things, !PV_UNHALT == HLT_PASSTHROUGH
is much less likely to hold true.
