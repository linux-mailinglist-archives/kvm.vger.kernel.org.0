Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44313A2F59
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFJPcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhFJPcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 11:32:33 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C24C061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 08:30:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id o9so77308pgd.2
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rk5wfRvJVKJdMnbOaJy4V5qWnwJU3HYRmmh+2TN5+1k=;
        b=As6FMwpWU+r0zvLETxnPGn4GsPMXpNUhxyGinqEO5adiLVQ/ovYPPNOqEwv9jI+I4s
         zZGL/6j2yPbdHQxChQSOyvTTRtn7F081Q85lIQnmFq8/h079N6OAILgWMfDBy9INkyr0
         XwUmLz+RXJ7lsEaOyRZRul76gQhuTRKK/zEVteWMmp6AZ/K6ryN9dN8Tvwxdw/A0UKq8
         7rZkFoRyTpRrC/BOzjjzjMWC+aMY48cccETE7N91gcNzHtAzb8dc3vKXUtjgYw6oHNey
         +B42lHcrRZLLYoLZakIOa5JMbE+cVuiSFqD46OBDRNmyYRfuKcdoASKbq3o+D4MFE5AB
         9sqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rk5wfRvJVKJdMnbOaJy4V5qWnwJU3HYRmmh+2TN5+1k=;
        b=j//emCtrbarMEbZmRSyPpJPnDAQB3MPG7kgo+Q7WBPt7dtaUhtEvn+T1FdBr/T/e9+
         Ie57H3ixCK7XE1gAQWaUwx8ZlGaiOC0Qwbl8uX4A9M+8hVLMBffVT8z8qZ4I5Iq/J2YB
         pUXa/SNcQ2Y7MpTIPa+lnupLzFKGWll2nXev5MZ3WIKk0lxU/6CS4bHHJrdJwrWerxRz
         WB6HFTDO8lvFK/7jkjrtYCKavDihNuyBYBRpcxK/r7exx+HHV1m6KCw4jJ4SOs30xZNv
         YtSpMzSDyPfRAfsg1SeXb3zRAs/hLQasWOr3yA02U5KObUItVOylEWTLMtQ77MO1LKIT
         gEUQ==
X-Gm-Message-State: AOAM5306DdQwGtSLmiStF9Ep7oqh73//+z+cPl4icpvAvKz65bCCWJHi
        51JOAod52uDM5RihmRkUlMqeIQ==
X-Google-Smtp-Source: ABdhPJyO4WF/eusmKVpie/u9Ap8R+gQWZfdzUbiZxiWBJOG3QfBVrCBQK4y81moCl0Mu/g5SSXf0jg==
X-Received: by 2002:a63:5553:: with SMTP id f19mr5341596pgm.419.1623339036001;
        Thu, 10 Jun 2021 08:30:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 18sm2704883pfx.71.2021.06.10.08.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:30:35 -0700 (PDT)
Date:   Thu, 10 Jun 2021 15:30:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM
 emulation fails
Message-ID: <YMIwF/so0I+w60kt@google.com>
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-3-seanjc@google.com>
 <87eedayvkn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eedayvkn.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021, Vitaly Kuznetsov wrote:
> why don't we have triple fault printed in trace by default BTW???

Or maybe trace_kvm_make_request()?  Not sure how much pain that would inflict on
the binaries though.
