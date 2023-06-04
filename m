Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF657213E2
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 02:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjFDAaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 20:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjFDAaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 20:30:03 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB0A19A
        for <kvm@vger.kernel.org>; Sat,  3 Jun 2023 17:30:01 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q5bd8-007gYS-Ev; Sun, 04 Jun 2023 02:29:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=ajmFOvwxptlWBTZW4DWkzyimVQmkTbolr3tsod6TmuY=; b=D6C5KOOFud2dCyCRvWq8yvA0M5
        3Qdd2ChbHfPYr6iWwpQtq7q/I8ROPJiFd2XtNQ5wHkSr6JqfKUafkGDHn7bzTypkvAhZEKrBWHqKz
        P4+i3GWWmIRhDJXk/PEvfXsbNaMBsuItGQco5Xz1ERCaV8bD84r7tF9TapYQLg86bYn0ojPiQGeBO
        82Wa7EwqVG+D8g8RQLSyYGH95MGtQW5/ERxbj/qKstVGpq5JIpGwZ9gecWn6xazC0U5ZzF0RLH1o2
        mfb9bQeNKtfahXFdPtVNDl/IddZ8PghjTCO7Ngq6hZZYKTwFQ3o/Rtpe+tBALiRUSVCfUPCtSLrJC
        LCxC7vFQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q5bd7-00034M-VD; Sun, 04 Jun 2023 02:29:58 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q5bcz-0002z3-Co; Sun, 04 Jun 2023 02:29:49 +0200
Message-ID: <002f1c33-e899-1d17-bfb4-24a116451fe6@rbox.co>
Date:   Sun, 4 Jun 2023 02:29:48 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v3 2/3] KVM: x86: Retry APIC optimized map recalc if vCPU
 is added/enabled
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230602233250.1014316-1-seanjc@google.com>
 <20230602233250.1014316-3-seanjc@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20230602233250.1014316-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/23 01:32, Sean Christopherson wrote:
> +	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map (if clean)
> +	 * or the APIC registers (if dirty).  Note, on retry the map may have
> +	 * not yet been marked dirty by whatever task changed a vCPU's x2APIC
> +	 * ID, i.e. the map may still show up as in-progress.  In that case
> +	 * this task still needs to retry and copmlete its calculation.

s/copmlete/complete ?

Speaking of nits, if you're planning to do some more work around
kvm_recalculate_phys_map(), there's that old comment typo I've failed
to notice earlier:

"Apply KVM's hotplug hack if userspace has enable 32-bit APIC IDs."

enabled?
