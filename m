Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6620F76593F
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 18:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjG0QxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 12:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjG0Qw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 12:52:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B582D7D
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 09:52:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d1ebc896bd7so1090163276.2
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 09:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690476775; x=1691081575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WsySOxfW+9cLK59nPUktjlvVqp+91KMZ0gu0oOBMYls=;
        b=ncAeo22G2nfV3c53Tf7GUNv0YxUbW3b5uCm01t2pNmO0SMGLFldBXysMP/iwRODsaU
         y3jznLgcAVZA5jGfjHX+ywAoxYx8T8TgD8dhDBnh9QlVj2HzBb4zE3rcgrWeCl/iHfFB
         4Yaui9MCJIol033J4aWUARq9UXAhRRwFcgH06SqxTw9lx5pGQSAHyOOwvfyea7vqWSwh
         CHg0ybtnoWhtSlfeV2cP0FiyEprHgLyFO2xEa+Qx88aQJC7h8X+SwlK724zBPzqDimbh
         BS9OhBwLR3o8lbbXUFXzmmhJTAxZ3HIEFhvECh1gKQ0fTP9+ta2r1A7Yl74sQSsv9KFj
         9ugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690476775; x=1691081575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WsySOxfW+9cLK59nPUktjlvVqp+91KMZ0gu0oOBMYls=;
        b=dnvPpSJsSD+HKELIcHsrQ7t1hLwCvyebKy+hSOWVON9G0c2t8DuuTO/YjHUh80yLtL
         Ft5B1WGYwH01kUJZBkWYiQ+2MpMVQZnD5svfxVqjSl4WwrsXTznxwXas0hFgVeIBBEbb
         m1lUuYNFJZVZqK6MMOkjEAOD4H8uTmy/sssHdXjm5dN/pXeZSreOTwJ8F4glfrXjChL+
         397Yc3bbo0IXEze/TRNhivpRdMLSgjf6xe6RMpHqx9OkP59z8OIZx+OEE7uHz7st4rD8
         Pc+mFI/p+Q1ZHHN4BRe79ioZfTe5V4E6J39pBmAMlcTj5bTETs5UNVw5GGMetbUXf8lf
         t7hw==
X-Gm-Message-State: ABy/qLbKFEQ9eEA9A+BwH6zvXEfuoiw8NPCW0FClliPFzFnx/RVVmar/
        S+bhMbUnlVg5opyLEzu6BU/i3ZH88JM=
X-Google-Smtp-Source: APBJJlGyP/KYscXFnhAsV1pI2R0yeiv1E213sDogZ3EBC+D1vyBfUWAIjsBwUnj3tbUuPl3BVeINCk4yZtQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2905:0:b0:d07:cb52:a3cf with SMTP id
 p5-20020a252905000000b00d07cb52a3cfmr35145ybp.5.1690476775015; Thu, 27 Jul
 2023 09:52:55 -0700 (PDT)
Date:   Thu, 27 Jul 2023 09:52:53 -0700
In-Reply-To: <7d4a5084-5e1e-22dd-c203-99f46850145a@cs.utexas.edu>
Mime-Version: 1.0
References: <7b5f626c-9f48-15e2-8f7a-1178941db048@cs.utexas.edu>
 <ZMFVLiC3YvPY3bSP@google.com> <27f998f5-748b-c356-9bb6-813573c758e5@cs.utexas.edu>
 <ZMF5O6Tq1UTQHvX0@google.com> <7d4a5084-5e1e-22dd-c203-99f46850145a@cs.utexas.edu>
Message-ID: <ZMKg5WosmBu78Vgv@google.com>
Subject: Re: KVM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 7
From:   Sean Christopherson <seanjc@google.com>
To:     Yahya Sohail <ysohail@cs.utexas.edu>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023, Yahya Sohail wrote:
> On 7/26/23 14:51, Sean Christopherson wrote:
> > On Wed, Jul 26, 2023, Yahya Sohail wrote:
> > > On 7/26/23 12:17, Sean Christopherson wrote:
> > > I do know that the emulator I'm copying state from likely doesn't consider
> > > all bits in the control fields, so it's possible that they're in an invalid
> > > state. When I ran the model before with the value for cr0 copied out of the
> > > emulator I also got KVM_EXIT_FAIL_ENTRY, but with a different value for
> > > hardware_entry_failure_reason = 0x80000021. I fixed this by changing the
> > > value of cr0 to be (hopefully) valid.
> > 
> > What were the before and after values of CR0?
> 
> Before, CR0 was 0x80000000.

Yeah, CR0.PG=1 with CR0.PE=0 (paging without protected mode) is invalid.  But
KVM fails to reject this combination from userspace without the series/patch I
linked earlier.  That would explain why the VM-Enter fails instead of KVM rejecting
KVM_SET_SREGS.

https://lore.kernel.org/all/20230613203037.1968489-1-seanjc@google.com

> It appears the paging bit was not set even after
> I "fixed" cr0. I have now made sure the paging bit and the fixed bits are
> properly set in CR0. CR0 is now equal to 0x8393870b

How did you get that value?   AFAICT, it's not outright illegal, but only because
the CPU ignores reserved bits in CR0[31:0], as opposed to rejecting them.

> That being said, I'm still not sure how to go about debugging the
> VM_EXIT_FAIL_ENTRY with hardware_entry_failure_reason = 0x80000021. The
> entry in the tracepoint log (see above) of L0 (when running the VM as L2)
> does not seem to be very helpful (unlike the invalid CR0 messages I got
> before when CR0 was invalid). Is there any more information that can be
> gleaned from this log entry?

Probably not.

> Any other way to get more information as to what piece of state is invalid?

Enable /sys/module/kvm_intel/parameters/dump_invalid_vmcs, then KVM will print
out most (all?) VMCS fields on the failed VM-Entry.  From there you'll have to
hunt through guest state to figure out which fields, or combinations of fields,
is invalid.
