Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEC6A214B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBXSSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 13:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBXSSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 13:18:21 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90E213D42;
        Fri, 24 Feb 2023 10:18:18 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pVce7-004j43-RD; Fri, 24 Feb 2023 19:18:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=SaM1RArNpxF0bC4kUesx9RtDxraWtr9KMwyM5Tj/y2Q=; b=Q7gT6fxChjvL6tDQq2nHGMuP25
        Z+mAzG9wg/J2F9eVVH6mhi19xNR94YJsN32y7Hr86kTGtcncwA2akUTqjwA3AKNyl/1OLpW5jPl+h
        ImAwdPt5Vp5vaO/4mV9GFv1rB21pGIGewwuwGjRvDmanNFK1/jzmzH3gj1NE5w14gGKCnjO2QKQY8
        ycEm+p1R0R3NHosSaI6vCjhb2LDBHQwh8P8zvAR9GXbfKbobIVpTE/iZMiF3+t+HmQ8CA1bwhzijm
        O725bDbu7dj+ku1FA7F1eC17t6tnK4y11OIz5e0y7R5BCESNtv4wTNaY7y7CT7eJ4Yfmw53x3IFP7
        S8Ondrbg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pVce7-0004FH-1b; Fri, 24 Feb 2023 19:18:15 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pVcdv-0006kh-S3; Fri, 24 Feb 2023 19:18:03 +0100
Message-ID: <747f1eac-c620-d7cb-86a1-a2c575cd2ef9@rbox.co>
Date:   Fri, 24 Feb 2023 19:18:02 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
Content-Language: pl-PL
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, David Woodhouse <dwmw@amazon.co.uk>
References: <20221228110410.1682852-1-pbonzini@redhat.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20221228110410.1682852-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/12/2022 12:04, Paolo Bonzini wrote:
> While KVM_XEN_EVTCHN_RESET is usually called with no vCPUs running,
> if that happened it could cause a deadlock.  This is due to
> kvm_xen_eventfd_reset() doing a synchronize_srcu() inside
> a kvm->lock critical section.
>
> [...]
>
> +	/*
> +	 * Because synchronize_srcu() cannot be called inside the
> +	 * critical section, first collect all the evtchnfd objects
> +	 * in an array as they are removed from evtchn_ports.
> +	 */

With the recent changes regarding the locking order (locking.rst:
"synchronize_srcu(&kvm->srcu) is called inside critical sections for kvm->lock,
vcpu->mutex and kvm->slots_lock"), is this comment still valid?

Or is there a rule that forbids synchronize_srcu() under the newly introduced
kvm->arch.xen.xen_lock?

thanks,
Michal
