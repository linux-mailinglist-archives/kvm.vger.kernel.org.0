Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572F2660A8F
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbjAGAHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGAHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:07:03 -0500
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218522ADE
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:06:58 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pDwjd-004mcn-Fw; Sat, 07 Jan 2023 01:06:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=vA0+IwmT6m3ENlTuagWmPGTpoBf1fpIfQmA0/lQXItg=; b=o2Hw5DkgavB5iArppdSyIPNq/x
        agl6GmlLe8uZUmkUlAytbnDDD7+GdNiNvHiOlf+I1zT9wnfIUTrRHn1sNgxwcA2eER4+ubMu5Jsjy
        PnAUAncBZPOUjVB4/RQnRpZd+0A7Y4awyameV16jB2kNtqYzW06gYAUcJfpK6/IsOOnWAnU7bLyYP
        pEuCw7z3fwUf5HpbslJOT45UsPM7Wh9UFzOEpB05kATL85iflZgDu/NVkTfql0tSej4hkEqYOVUdv
        b8n2xK8sDXeepLP1GeKAxTjF8MBsLlOykBBSF9/PUf+mGXvtJKsyQzRSARx4TooDa5OBDFJDeCs1D
        bcXyaodA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pDwjb-0003UW-Jq; Sat, 07 Jan 2023 01:06:51 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pDwjS-00024S-FV; Sat, 07 Jan 2023 01:06:42 +0100
Message-ID: <1896ea19-9e3a-36d1-ab22-306d03ea8da9@rbox.co>
Date:   Sat, 7 Jan 2023 01:06:41 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        paul@xen.org
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co> <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com> <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
 <Y7dN0Negds7XUbvI@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <Y7dN0Negds7XUbvI@google.com>
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

On 1/5/23 23:23, Sean Christopherson wrote:
> Ha!  Case in point.  The aforementioned Xen code blatantly violates KVM's locking
> rules:
> 
>   - kvm->lock is taken outside vcpu->mutex
> 

FWIW, I guess this looks like a violation of the same sort:

kvm_vcpu_ioctl()
  mutex_lock_killable(&vcpu->mutex)
  kvm_arch_vcpu_ioctl()
    kvm_xen_vcpu_get_attr() / kvm_xen_vcpu_set_attr()
      mutex_lock(&vcpu->kvm->lock)

> In other words, I'm find with this patch for optimization purposes, but I don't
> think we should call it a bug fix. (...)

Sure, resending as such, along with minor fixes.

thanks,
Michal
