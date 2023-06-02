Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF57207E9
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbjFBQsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbjFBQsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:48:02 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF14196;
        Fri,  2 Jun 2023 09:48:00 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1q57wR-00464D-Dj; Fri, 02 Jun 2023 18:47:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=y+oDM7P40Ajk2tIw2Ui3M7/s/FajTZA8gaZHZh/VWfw=; b=WNxkiE6sjpiLZOmiKDqq3kJ1Ns
        yKbMf6EKcvkb8rcMwANtGqBE830cfL7YhKePNYkDvxJE63IYo9MdckFWaEUqQnD6lVVN8PAelRdR+
        DHiwbd5kV8hbHmMxFowSc+Vf+Zvv65ns5ds5OUR33H3rKqacIU0nUaWd/oWO9tCWAV8Z0mUWrr4ER
        53hAo+sPSI9/36MfboCM+0Q8/8GqwkJ4IZDd1HUgYoVERElqDEG+8MskNX4cF8rJhz6y9s7OLP3sJ
        OImlJAJQiKPNTII2badxB6eVvp9mgKyrO+S7LvVu3fgXvtOhnvvvi3zvG0RERlrRXwUq9VBiQ81Eu
        wm5wXOYQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1q57wQ-0004QY-J1; Fri, 02 Jun 2023 18:47:54 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1q57wG-0002Bx-FY; Fri, 02 Jun 2023 18:47:44 +0200
Message-ID: <8f319a1e-a869-b666-b606-c0b4764ef7b1@rbox.co>
Date:   Fri, 2 Jun 2023 18:47:42 +0200
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [PATCH v2] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>, dmatlack@google.com,
        mizhang@google.com, isaku.yamahata@gmail.com, pbonzini@redhat.com,
        Wei Wang <wei.w.wang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230307135233.54684-1-wei.w.wang@intel.com>
 <168565180722.660019.15543226381784798973.b4-ty@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <168565180722.660019.15543226381784798973.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/23 03:20, Sean Christopherson wrote:
> On Tue, 07 Mar 2023 21:52:33 +0800, Wei Wang wrote:
>> Current KVM_BUG and KVM_BUG_ON assume that 'cond' passed from callers is
>> 32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
>> provided by a caller is 64-bit, e.g. an error code of 0xc0000d0300000000
>> will be converted to 0, which is not expected.
>>
>> Improves the implementation by using bool in KVM_BUG and KVM_BUG_ON.
>> 'bool' is preferred to 'int' as __ret is essentially used as a boolean
>> and coding-stytle.rst documents that use of bool is encouraged to improve
>> readability and is often a better option than 'int' for storing boolean
>> values.
>>
>> [...]
> 
> Applied to kvm-x86 generic, thanks!
> 
> [1/1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
>       https://github.com/kvm-x86/linux/commit/c9d601548603

I guess this makes the !! in kvm_vm_ioctl_create_vcpu() unnecessary:

KVM_BUG_ON(!!xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0)...

Is it worth a patch (perhaps along with chopping off !! in
kvm_msr_allowed() and few other places)?
