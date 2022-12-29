Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F463658890
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 03:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiL2CMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 21:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiL2CMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 21:12:45 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BD9B2E
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 18:12:43 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pAiPQ-00HWrM-EL; Thu, 29 Dec 2022 03:12:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=y7RAPx28QRbazXIKyVTwHIcXUMEWW3VfqXO3yEz0moA=; b=GPaCi0NUclEhlQd3DsJTNESR9B
        hif/pZQ2cmVeBWjMLt77LMUIUDb+pI9CfZ13taupJG/tINTst4NPQRlgN8/suvkyzHAraTjOOgwIq
        DEfk8cT6tUF/k7IObwqXZ03Z7GWz6KpxJ+VuAwgEKxDFkd+qF8g7rS8NKo0agdD5GI14gzKxYfhw6
        dsTUa8yvWO3RV8pxsdNH+WnqJjnKq5aNcW5UhCLaA5pBdS0LKHZYNFZjtf+1BkVWFNBt10F0Ngjtb
        yuFflvGXcvKZ7CZhgPBtWCRpnkaUH4B3BmT3M76jg8nIwJRrR3Bo0S88m8xbLrwK352mxB80xH/Eh
        e88mugKQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pAiPJ-0000yR-OJ; Thu, 29 Dec 2022 03:12:33 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pAiP0-0005Cq-3s; Thu, 29 Dec 2022 03:12:14 +0100
Message-ID: <2ac40491-7efc-64bf-d7b8-b10dc4346094@rbox.co>
Date:   Thu, 29 Dec 2022 03:12:13 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: pl-PL, en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
 <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
 <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
 <4ed92082-ef81-3126-7f55-b0aae6e4a215@redhat.com>
 <9b09359f88e4da1037139eb30ff4ae404beee866.camel@infradead.org>
 <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <6d2e2043-dc44-e0c0-b357-c5480d7c4e7c@redhat.com>
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

On 12/28/22 12:58, Paolo Bonzini wrote:
> On 12/28/22 10:54, David Woodhouse wrote:
>> But what is the general case lock ordering rule here? Can other code
>> call synchronize_srcu() while holding kvm->lock? Or is that verboten?
> 
> Nope, it's a general rule---and one that would extend to any other lock 
> taken inside srcu_read_lock(&kvm->srcu).
> 
> I have sent a patch to fix reset, and one to clarify the lock ordering 
> rules.

It looks like there are more places with such bad ordering:
kvm_vm_ioctl_set_msr_filter(), kvm_vm_ioctl_set_pmu_event_filter().

Michal

