Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2176B4E0
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjHAMiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 08:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjHAMiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 08:38:16 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F70C1
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 05:38:14 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qQodf-00GXS6-3W; Tue, 01 Aug 2023 14:38:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=hDKGQF7V2LpMS3kWl/pd7z6kPfWidZ4pHAFKe8+TPDE=; b=BI9wKATudmqEW80BfA17xknHMN
        GW3f1UV1ypEq5fkLxKeHS6Zc7G4s4A37TVXU3DLQZpJhBzfaByH9+Ml2dSrZ7KDdOuNMELH4APHXh
        oMw4eushhF4ponvTJt7BCmmP3jniHaw+1tDnURyaSkK6ey3e5jOADtRHvOaCJUxr/L2H+VrwcsB5v
        Jtext8fuQjX18lcgZqA+k5JbCU61TeFbgAUoRMXIUEWFzZCsOTPFEaICm7MmZOdWd1GceUVX8WBB7
        1ymhXCYKAgTKX9B9XB4+NsUpn/6gdR+djfmiKuR9EMK/iHMrtLCDBAcw5a5M5DGU5Oqtz/nPEkyfz
        liXXQJjA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qQode-0001nH-De; Tue, 01 Aug 2023 14:38:10 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qQodU-0005rW-Fd; Tue, 01 Aug 2023 14:38:00 +0200
Message-ID: <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co>
Date:   Tue, 1 Aug 2023 14:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-2-mhal@rbox.co> <ZMhIlj+nUAXeL91B@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZMhIlj+nUAXeL91B@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/23 01:49, Sean Christopherson wrote:
> On Fri, Jul 28, 2023, Michal Luczaj wrote:
>> Both __set_sregs() and kvm_vcpu_ioctl_x86_set_vcpu_events() assume they
>> have exclusive rights to structs they operate on. While this is true when
>> coming from an ioctl handler (caller makes a local copy of user's data),
>> sync_regs() breaks this contract; a pointer to a user-modifiable memory
>> (vcpu->run->s.regs) is provided. This can lead to a situation when incoming
>> data is checked and/or sanitized only to be re-set by a user thread running
>> in parallel.
> 
> LOL, the really hilarious part is that the guilty,
> 
>   Fixes: 01643c51bfcf ("KVM: x86: KVM_CAP_SYNC_REGS")
> 
> also added this comment...
> 
>   /* kvm_sync_regs struct included by kvm_run struct */
>   struct kvm_sync_regs {
> 	/* Members of this structure are potentially malicious.
> 	 * Care must be taken by code reading, esp. interpreting,
> 	 * data fields from them inside KVM to prevent TOCTOU and
> 	 * double-fetch types of vulnerabilities.
> 	 */
> 	struct kvm_regs regs;
> 	struct kvm_sregs sregs;
> 	struct kvm_vcpu_events events;
>   };
> 
> though Radim did remove something so maybe the comment isn't as ironic as it looks.
> 
>     [Removed wrapper around check for reserved kvm_valid_regs. - Radim]
>     Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> 
> Anyways...

Nah, from what I can see, it wasn't Radim's tweak that introduced the
TOCTOUs[1].

[1] https://lore.kernel.org/kvm/20180202210434.GC27896@flask/

>> A note: when servicing kvm_run->kvm_dirty_regs, changes made by
>> __set_sregs()/kvm_vcpu_ioctl_x86_set_vcpu_events() to on-stack copies of
>> vcpu->run.s.regs will not be reflected back in vcpu->run.s.regs. Is this
>> ok?
> 
> I would be amazed if anyone cares.  Given the justification and the author,
> 
>     This reduces ioctl overhead which is particularly important when userspace
>     is making synchronous guest state modifications (e.g. when emulating and/or
>     intercepting instructions).
>     
>     Signed-off-by: Ken Hofsass <hofsass@google.com>
> 
> I am pretty sure this was added to optimize a now-abandoned Google effort to do
> emulation in uesrspace.  I bring that up because I was going to suggest that we
> might be able to get away with a straight revert, as QEMU doesn't use the flag
> and AFAICT neither does our VMM, but there are a non-zero number of hits in e.g.
> github, so sadly I think we're stuck with the feature :-(

All right, so assuming the revert is not happening and the API is not misused
(i.e. unless vcpu->run->kvm_valid_regs is set, no one is expecting up to date
values in vcpu->run->s.regs), is assignment copying

	struct kvm_vcpu_events events = vcpu->run->s.regs.events;

the right approach or should it be a memcpy(), like in ioctl handlers?

thanks,
Michal

