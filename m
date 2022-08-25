Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A915A0774
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 04:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiHYCvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 22:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiHYCvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 22:51:52 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3067D9CCCD
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 19:51:51 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11d2dcc31dbso15127713fac.7
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 19:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cZ5gzNCrmdm3hLAPODSo3m8ewJ0Yui1XSuajAwlxh4E=;
        b=JQ4b7CBxWO7nskQf5m+6YvtLrJeNJcHsCNDT7BpIszut0+dYBhEt+GVITxHEMQyCGS
         a1IsOxh/8/92ZfwljodwkTWc4Nv+tnPKeMdGHX6M8uqQuf5950C03dhiyRVoWrSY6kn+
         Tdb1qY/XexGGue2BHOyvHrYYM4x3AyQ+THW4IL6pnIIktKXE7u9E7pDYguV/Sr89OoRj
         aIk/b3HE5dH+DkcSgKKpM1InPEpSXnSPOPpTOlOJJ00i22Cq/Je9rJs2UbhAKYs0kU8j
         h9SEe31FmmJ2jOvaa4z+ZpVOSUGzo7kSgUxwiquPw99yLyzHtkcUCPEudegUNbt8cnHw
         cluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cZ5gzNCrmdm3hLAPODSo3m8ewJ0Yui1XSuajAwlxh4E=;
        b=itM4BksDD8FFMyDFqf/1URk3wDBT4FbzumnLDoM69OT4g421//nPLEpjjox5BanWsv
         zHbCg4++DOGi7wtZ/EME9jRDyP27y/VITuohiF2mFLiEY6nfOK2LrbE5ug3hIYtsXK7A
         XnijOfzwqU4JQFO2UIJFYb9qHdJgOV1Oqzsw8j3wVvYI/gAcfKVfvyKKIRh9j+9aI8ax
         LYHR9x6PzRzqd+jO8nGhzsl67sLJj4s0l7k4Fxwqe3YDieItv9FzHIXGWToIxYiAQ7eI
         zF5BMtM47sng6VGPNXKYHh0sNOwXEg8Z3alszZBo/XPamck9nDhguAnuG6/M/zazqPRM
         LF3w==
X-Gm-Message-State: ACgBeo31ggdpnrRIDAtGo6UUhw/XRWtA7xS84y8MsnRfbvZbfJF83YGG
        YfZc2ighR7Er1q+x11d00VFg8UJZBqmxa5XjDl/F9Q==
X-Google-Smtp-Source: AA6agR7vXKkTOGXcGEwZmzfAc5VUk0nraiOrDnZju3zQi5V4WprV0/ul8/7Z0aqc6ZWW6iZJyMIiYITSg9m+8k1wtME=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr5053901oab.112.1661395910321; Wed, 24
 Aug 2022 19:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com> <20220802230718.1891356-2-mizhang@google.com>
 <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com> <CAL715WLQa5yz7SWAfOBUzQigv2JG1Ao+rwbeSJ++rKccVoZeag@mail.gmail.com>
 <17505e309d02cf5a96e33f75ccdd6437a8c79222.camel@redhat.com> <Ywa+QL/kDp9ibkbC@google.com>
In-Reply-To: <Ywa+QL/kDp9ibkbC@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 24 Aug 2022 19:51:39 -0700
Message-ID: <CALMp9eSZ-C4BSSm6c5HBayjEVBdEwTBFcOw37yrd014cRwKPug@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending interrupts
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 5:11 PM Sean Christopherson <seanjc@google.com> wrote:

> @google folks, what would it take for us to mark KVM_REQ_GET_NESTED_STATE_PAGES
> as deprecated in upstream and stop accepting patches/fixes?  IIUC, when we eventually
> move to userfaultfd, all this goes away, i.e. we do want to ditch this at some point.

Userfaultfd is a red herring. There were two reasons that we needed
this when nested live migration was implemented:
1) our netlink socket mechanism for funneling remote page requests to
a userspace listener was broken.
2) we were not necessarily prepared to deal with remote page requests
during VM setup.

(1) has long since been fixed. Though our preference is to exit from
KVM_RUN and get the vCPU thread to request the remote page itself, we
are now capable of queuing a remote page request with a separate
listener thread and blocking in the kernel until the page is received.
I believe that mechanism is functionally equivalent to userfaultfd,
though not as elegant.
I don't know about (2). I'm not sure when the listener thread is set
up, relative to all of the other setup steps. Eliminating
KVM_REQ_GET_NESTED_STATE_PAGES means that userspace must be prepared
to fetch a remote page by the first call to KVM_SET_NESTED_STATE. The
same is true when using userfaultfd.

These new ordering constraints represent a UAPI breakage, but we don't
seem to be as concerned about that as we once were. Maybe that's a
good thing. Can we get rid of all of the superseded ioctls, like
KVM_SET_CPUID, while we're at it?
