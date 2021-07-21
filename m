Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269983D15BE
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhGURQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 13:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbhGURQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 13:16:12 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA4BC061575
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 10:56:48 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qb4so4467604ejc.11
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 10:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vrMphr3tpItn2w3bBK1L8WnMR/wafltXE6Any2pLriw=;
        b=rtdiKAHwaRqh8X+FKuOHGfbcpYhyq06wimQpNcQgPkZTz6/eAvUT1D1HBNHj5YoaLE
         X+vmixOJr4r15Dzo1zBi6hI0mIbdzMsUdGxXCqFMnKc5ROVW3dXItOh2of/2WPOU8+Yk
         6V2CFYdkbmpsPZis/khwXfYZdxSav5Eai2B/Qj1bjP3yeYHdYbkjQXkMCXkWzO3pm9JG
         LVxyY1yhCYvmuCdyV/944q6XZ0Dbz/mXKkDAqlCUF+JXdM6e/0elAqQoszltebGx1Rbq
         6siHkU46e8dFc3XhRcnMXXQl+lv0FrdkasnCdiQWlL0cSBohyrZ5lqB197OkMaJYMuzB
         dNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vrMphr3tpItn2w3bBK1L8WnMR/wafltXE6Any2pLriw=;
        b=czP4on8F+64ckFm00HN/CWDgc9EqEjaHFI5z27SUSVJx+kk3zqZtDKYB8VaNEngK1+
         ++sizfXbmCBVVXZ2qNK8JOhNNQzq1AnPJ2OlCdLBZu79SE7v03pe12comAWE3ikCsrfj
         k7bCI4K/YE2ICl+pIwKpgbY5KC4iznJSMYss38E8nzoiKTv2YhLUOUeoqtzuwx4R07r7
         rZrtqexTMOVlqtStEQYWJ7auwvDttutKCFuE6Qv2pd7MWhNqXKxWCj1h0ybrmrGKv0Ph
         ruyk80mj4AaeSdO9ZYmd09ootL9yJdfg00HBTUbBPk8bZRANT3yeSX7hNlz3JU+khBvY
         izeA==
X-Gm-Message-State: AOAM531t6xJvLAiVcgbuX+JTQntX7hiw+4uD9kdR7n5B34udaKNN/Uic
        X+yIV73/tQcfPznNcuAxXismcw==
X-Google-Smtp-Source: ABdhPJztICbLBjabcxqrQBD4WycfWu5/hNk/dhR2NO6b/fMWzVqkTTn/NuY6CqSY8ILFXvSFOtrYAg==
X-Received: by 2002:a17:906:4ad9:: with SMTP id u25mr39222251ejt.174.1626890206835;
        Wed, 21 Jul 2021 10:56:46 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id p5sm6130708ejl.73.2021.07.21.10.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 10:56:46 -0700 (PDT)
Date:   Wed, 21 Jul 2021 19:56:25 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     maz@kernel.org
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com,
        tabba@google.com, oupton@google.com
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Message-ID: <YPhfyVUIKHW9xF22@myrica>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608154805.216869-1-jean-philippe@linaro.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 05:48:01PM +0200, Jean-Philippe Brucker wrote:
> Allow userspace to request handling PSCI calls from guests. Our goal is
> to enable a vCPU hot-add solution for Arm where the VMM presents
> possible resources to the guest at boot, and controls which vCPUs can be
> brought up by allowing or denying PSCI CPU_ON calls.

Since it looks like vCPU hot-add will be implemented differently, I don't
intend to resend this series at the moment. But some of it could be
useful for other projects and to avoid the helpful review effort going to
waste, I fixed it up and will leave it on branch
https://jpbrucker.net/git/linux/log/?h=kvm/psci-to-userspace
It now only uses KVM_CAP_EXIT_HYPERCALL introduced in v5.14.

Thanks,
Jean
