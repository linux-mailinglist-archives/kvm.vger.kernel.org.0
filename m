Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EE92FD639
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388005AbhATQ4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 11:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389902AbhATQgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 11:36:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DB0C061757
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 08:35:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l23so2529732pjg.1
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 08:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JlixcYoHW4Z0fDOypVjt+k/RzFyLIGGaYIsPPyEDmtA=;
        b=kiUbWi2Y/tw5HB/SPzF8PCMPP4iwKt9x6KHIDxh2jc0Kr+A7L7jlKuSOXONu0APQAn
         t7nD5ylrF/seaYBSZPEl+pA2OK7ZlsHDGwPQv8l+QzTf1VAVPHnyZxs+CFKTUui6c7N2
         Tf8IMWQemacCb7UNQs3wWXZYhiwNjE6vi44Lsi23Ywqk4Z9x/QnowUm5qdzfbTzrG0b1
         iMiT/Wxnbe3Tq61yESgxXv03KDjmfT6gYMyCKBvOwzXyrvA1Huonk/Qb8hhxhDf73OpA
         nMJQMWqkNvA3YdB8gF6ACqrm339J4Gffn4VlJI3t+Uyj+ZJ+HoZORc+6C5C+OVja9YRG
         fiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JlixcYoHW4Z0fDOypVjt+k/RzFyLIGGaYIsPPyEDmtA=;
        b=twkDbR1FblqqEK5EzpUNYqG0zyUjfKvauiMuTFfQr+9evUNIh/T2Z/alMK8PB/V+6S
         at+cLYWQgtAA/exqLWcISgAYhC+YdarQYYzSs/qKSHTBSagPrufAaoDMeImw4AyKoY18
         k22Ea4ZeEH16SnUUZ4agnTQysxeKB5bxSqaslPhxEf4ktd+UrNYbJrk5c+mDBv2c+Eyg
         Q5NDOlQEgwF/AxMkqsroWFhyra/iBu5SgexEZ9LBOH9Od7oJ4WlgO4RSkcCPSxmBssLs
         KTUhAg8Ny5cqS2mqHIdOUHt1xlnvuyxtiMyeDWxfkL5ZnbjOy+xjGzPxbcZycKGb5g1z
         7bww==
X-Gm-Message-State: AOAM531VIjOMV5kIavorN/knuucgzzTyPisAV31n+3dqzvKUtx31I8yD
        NRAho9OF1lths/92VVu9Ibd4MA==
X-Google-Smtp-Source: ABdhPJzZbs1JiU9eeCn0Q6AG2mfq6aHzox/28oq3WFdAQIFNbYAaNMpTggajWXVCHeJn/3AKL5ePRg==
X-Received: by 2002:a17:902:d891:b029:de:369c:6bc7 with SMTP id b17-20020a170902d891b02900de369c6bc7mr10756044plz.31.1611160542240;
        Wed, 20 Jan 2021 08:35:42 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id j6sm2882089pfg.159.2021.01.20.08.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:35:41 -0800 (PST)
Date:   Wed, 20 Jan 2021 08:35:34 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
Message-ID: <YAhb1mYB3ajc2/n9@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <YAaW5FIkRrLGncT5@kernel.org>
 <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021, Kai Huang wrote:
> I'd like to take this chance to ask: when this series is ready to be merged, what is
> the properly way to merge? This series has x86 non-sgx (cpufeature, feat_ctl) and sgx
> changes, and it obviously has KVM changes too. So instance, who should be the one to
> take this series? And which tree and branch should I rebase to in next version?

The path of least resistance is likely to get acks for the x86 and sgx changes,
and let Paolo take it through the KVM tree.  The KVM changes are much more
likely to have non-trivial conflicts, e.g. making exit_reason a union touches a
ton of code; getting and carrying acked-by for those will be tough sledding.
