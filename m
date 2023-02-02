Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E39B68730C
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 02:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjBBBdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 20:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjBBBdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 20:33:18 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97166F217
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 17:33:13 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t13-20020a056902018d00b0074747131938so332881ybh.12
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 17:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJ2suvTcnRqJyFH1jkuVoU3bY9GWNZHCdTTD+8pN/ek=;
        b=ab2NcTEqcbY7BhT+q9RKK8BMRghu34aBqxgrwqyQE9pKF+aD5Qh3pXIOp+Ca2Ct6V4
         CR7D8BIMFNycXHTz8bU9RNWJCl4Xb9h94tE2xZgVu4/ABKE8zMV3v5k1m5eUDjVUNYP+
         +qCv4S/lL4uRlD6jbps3dtQ1Ul7uTczt8pFhP0KgFOhUkWJS4L9UdgcWPpk72waZyOgz
         /YlQrSnMFinkTESaIfmgGoAOThbRxb0Fji0qeEvgTT69mxb/2HXF7ii7gGx1Y89GSRwG
         4Q6YaisfxkYxrFgZaXzE7lJzcoDhgQKklRkWWT2vuVHu7PTnLqtGJP2leiChCiJ2vHT1
         J1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CJ2suvTcnRqJyFH1jkuVoU3bY9GWNZHCdTTD+8pN/ek=;
        b=CHxWpusHL+i8KLmjz9e/DuuO6Y1NPr9T4YYwzhgd2mVmgMNrMIHJI0Ojc8W9WWeDie
         xJmDFEUb37E6MyuE1NgJSp/T4Zj0Viy4IkOQn1SdD/La5VdRDwS4l9ZJc8iZf7cGRw9x
         CQhevgPplMPwMgmdUuHalrJmqr3PByDXDF3O32cbnTIpDR80VNm+U7yIiYg1qaDremf0
         az77zkYc3vnv3r22rRtzxr2wlT9wHBpdL6/RbLraGciJSUOTuMtqmGFi3WjwN/kuwjId
         QDF2/eVPTz+hIN+xbQ8LvfW0ktnnOseOi0Yt3ijFLsMS2pqy2PfB2zl7qxgPSfDK+WBP
         jMIQ==
X-Gm-Message-State: AO0yUKXrRVmrLFuWmQ/IDMB8h6P1Qfz8fxybO2g1MZRrzUEgmkXV1p8J
        a8f4D25bQ8zRip7zLtfKOzA4AiiLGKE=
X-Google-Smtp-Source: AK7set9BpsXGFaQaIWNZQclxhRO3k0f4qDD0DIbvZ6nNKWBuTyun5Jle53OkdeNSGVkFVCMQzMEhbkT3UHI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8389:0:b0:835:7411:4e35 with SMTP id
 t9-20020a258389000000b0083574114e35mr516313ybk.203.1675301593015; Wed, 01 Feb
 2023 17:33:13 -0800 (PST)
Date:   Thu,  2 Feb 2023 01:32:31 +0000
In-Reply-To: <20221109082802.27543-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20221109082802.27543-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <167529856265.852656.15112384836454646847.b4-ty@google.com>
Subject: Re: [PATCH v3 0/3] KVM: x86/pmu: Enable guest PEBS for SPR and later models
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 09 Nov 2022 16:27:59 +0800, Like Xu wrote:
> Finally, SPR will go live in early 2023. Virtualization support for SPR
> PEBS (kvm.x86.vpmu.pebs_ept) has officially available in the Intel SDM
> (June 2022), and this patch set is validated on a late stepping machine.
> 
> Let's see if this new revision will satisfy everyone's appetite.
> 
> Previous:
> https://lore.kernel.org/kvm/20220922051929.89484-1-likexu@tencent.com/
> V2 -> V3 Changelog:
> - Add more commit message about the pdit/pdir stuff; (Sean)
> - Refine confusing comments on event precise level and TNT+; (Sean)
> - Use pmc_get_pebs_precise_level() instead of need_max_precise(); (Sean)
> - Move HYBRID_CPU change in a separate patch; (Sean)
> - Land KVM changes before perf core changes; (Sean)
> - Aalign code indentation; (Sean) // VScode is quite good for kernel dev.
> 
> [...]

Applied 2-3 to kvm-x86 pmu.  I want to get Paolo's input before proceeding on
the whole "disable vPMU for Hybrid PMUs" snafu.  IIUC, applying these patches
won't make the situation worse, please holler if that's incorrect.

Thanks!

[2/3] KVM: x86/pmu: Add PRIR++ and PDist support for SPR and later models
      https://github.com/kvm-x86/linux/commit/974850be0125
[3/3] perf/x86/intel: Expose EPT-friendly PEBS for SPR and future models
      https://github.com/kvm-x86/linux/commit/13738a364736

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
