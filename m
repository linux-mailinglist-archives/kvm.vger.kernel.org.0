Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549803F4F64
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 19:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhHWRT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 13:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhHWRT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 13:19:56 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF53C061757
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 10:19:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 18so15958622pfh.9
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IWL7Yh+mP65xmvAitJG8b6Di+ZqbYJAqwLYk9jhbuJA=;
        b=HxHnaTbLz9/e7xkXCnUYhY/tMz8hJs+Dx98kRcQoj8kkPcbBhBYtGEJKBn+3ayLFYd
         zJwdWA8cuMtmtCtYDqAbxn2DP1y69H+qQKCvveWQZJQeixoPrhQFJZNDajvWqu4ninzD
         /pSwkXlIXyDarPPlMI7K2e+Wf8F8Ln3mNo6jD1PW3CNu1vqjcq72RUTc62fugkMF6svz
         KFll8FmyuETvuMsjySSQYf/2z02qFnL2KJ+t0UpwGI8AUbumynMo84ICtCsSCw2uWpRm
         F6si4fM9HnkKxsr0CzIpMFeaz9pxXQyb84yG/ymKaipcPDi2bDhimAVzjf1saPcyVkM+
         BxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IWL7Yh+mP65xmvAitJG8b6Di+ZqbYJAqwLYk9jhbuJA=;
        b=CmN5soIwE+VvrBogxJ1DTRrZZNGwIdZDlSMt6WJAAPPUSSTGzfuKPShH57u0tKuQpg
         NFcYAiHZCHduri/9/nBq3qUBIouqOjQy42i/xQHbZ+k3zYjpkToAGDq+76QpHmyfPS6y
         hs8JEfRrBrn6uBoUW0x5e8lhkg+wh5EMECR/pRZF5XUHzvABxnS9YvAyou2ldk4Nnrxd
         Ygo1VW86ck4WnZL9AQFgGWSsxYsQh7PJJ1EiYZzrRm4/zUSpyQrkKmVU/Tcd0MQYWa9z
         tjsNvwfE573itYsEKTaiXwtkyzBmTQp0mOH4RjOcxA3rGQP4HwdLUJ1Vn+KqoAMk+VGt
         BPpQ==
X-Gm-Message-State: AOAM530EDA3cxtRAd+LBHRMFkTzVDysWTCzJ4KzrfINuMiSAG4lxlE4M
        Ut3OIl8m77mpBXBaxIFcWuDy0Q==
X-Google-Smtp-Source: ABdhPJxzIOCoUVt4Ja+vSdSKmWsDnBnppesoRISHVIhFr00eatLZ/wC33b0j+2gt2n/J4IpFJb6pHw==
X-Received: by 2002:a63:ef12:: with SMTP id u18mr32753706pgh.331.1629739152905;
        Mon, 23 Aug 2021 10:19:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z131sm17195346pfc.159.2021.08.23.10.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 10:19:12 -0700 (PDT)
Date:   Mon, 23 Aug 2021 17:19:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 V5] Add AMD SEV and SEV-ES intra host migration
 support
Message-ID: <YSPYinqcP3yr6SpO@google.com>
References: <20210823162756.2686856-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823162756.2686856-1-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021, Peter Gonda wrote:
> V5:
>  * Fix up locking scheme

Please add a selftest to prove/verify the anti-deadlock scheme actually works.
Unless I'm mistaken, only KVM_SEV_INIT needs to be invoked, i.e. the selftest
wouldn't need anything remotely close to full SEV support.  And that means it
should be trivial to verify the success path as well.  E.g. create three SEV VMs
(A, B, and C) and verify migrating from any VM to any other VM works (since none
of the VMs have memory regions).  Then spin up eight pthreads and have each thread
concurrently migrate a specific combination an arbitrary number of times.  Ignore
whether the migration failed or succeeded, "success" from the test's perspective
is purely that it completed, i.e. didn't deadlock.
