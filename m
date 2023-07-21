Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E0575CA17
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 16:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjGUOeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 10:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjGUOeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 10:34:20 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17007269F
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 07:34:19 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 46e09a7af769-6bb0cadd372so1031009a34.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 07:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689950058; x=1690554858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HcKRa4T9+0IogfQ5a0Rh0uaXhOy8Hgp0I8tUhfZX4s=;
        b=fhz4O5sbh2HaJF5ZngyQvoKFKJxP4WqQSbiCboRkfwdc6mthIKQmJucOGLj+NkZsIp
         l7Rc9jUctR97GDmW5YA3O0IkKtBLmFyHWiqMv4r7VAreksZOZgGuh6NTAINdyAtPYm5W
         LYPP8dcrOH8v9KvRHru3aTkUTDcTT34rOmVDbTDIB+T645/wGiMHsnE3BOEzzHDx3YIx
         Rc2A3xhyp4nPTB/K3zV9c+ikwWjW/1OJ0cdRaBlr6bKXRurRGoZl3vrIq0CLL3dqXIOL
         6gSUHaheasus0R8ptoqtIWv537lUw/VdZOIvpQjNsOVcrD3ne4yz4pzVPYXcFGO18arp
         SRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689950058; x=1690554858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HcKRa4T9+0IogfQ5a0Rh0uaXhOy8Hgp0I8tUhfZX4s=;
        b=AYhhcJx7Eps2oA0oANHWH+90c15sKB4lwB0/opftGbRBMst2UUQW8tLV53DB5JK+mP
         nBeCRFelUdG9CsiQK9OMrGfuxPGobz5XcysjeFI/Nc14ejaobZwRJJAZR2jOhlQ3YL5/
         e5p8qxCTFM1ibZP6cz65oLCu+1ELa6l/9P8rEAuCyn94xko05iubLcKCUopjYd8bsfw+
         dKO1ETLcsmxyaGwv9tOaubHruEFR5JmSOLhiJTc/3iX/ns5k/mpIy/sWfX9nJWl6BR73
         NC10EtxLGTDzVnPrq2fgNxtcAWV+qK/VKV3gXkEfCbFmKYK01rGGZEOqRslLHP8YdtCg
         Q4tw==
X-Gm-Message-State: ABy/qLbWvtXHoWNA3SAvezUofLuQD/Ftb0R6dh4mD3UDbDgH5Pz+YizR
        WYVa+/vg+EIDwJcaHrCvekxhXLouWNogPzfq
X-Google-Smtp-Source: APBJJlHkP2CfUbWYv6LfM/5UoLIDsS0l+fYw17/yvCVhVksEXGeGaesklGCUB0zsHzSUXoVsmx/vXg==
X-Received: by 2002:a05:6830:205a:b0:6af:7760:f2d0 with SMTP id f26-20020a056830205a00b006af7760f2d0mr247622otp.32.1689950058192;
        Fri, 21 Jul 2023 07:34:18 -0700 (PDT)
Received: from localhost.localdomain ([49.205.129.56])
        by smtp.gmail.com with ESMTPSA id cx3-20020a17090afd8300b002640b7073cfsm4278652pjb.14.2023.07.21.07.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 07:34:17 -0700 (PDT)
From:   Amaan Cheval <amaan.cheval@gmail.com>
To:     seanjc@google.com
Cc:     brak@gameservers.com, kvm@vger.kernel.org
Subject: Re: Deadlock due to EPT_VIOLATION
Date:   Fri, 21 Jul 2023 20:04:07 +0530
Message-Id: <20230721143407.2654728-1-amaan.cheval@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <ZHZCEUzr9Ak7rkjG@google.com>
References: <ZHZCEUzr9Ak7rkjG@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hey Sean,

I'm helping Brian look into this issue.

> Would you be able to run a bpftrace program on a host with a stuck guest?  If so,
> I believe I could craft a program for the kvm_exit tracepoint that would rule out
> or confirm two of the three likely culprits.

Could you share your thoughts on what the 2-3 likely culprits might be, and the
bpftrace program if possible?

I ran one just to dump all args on the kvm_exit tracepoint on an affected host,
here's a snippet:


```
# bpftrace -e 'tracepoint:kvm:kvm_exit { printf("%s: rip=%lx reason=%u isa=%u info1=%lx info2=%lx intr=%u error=%u vcpu=%u \n", comm, args->guest_rip, args->exit_reason, args->isa, args->info1, args->info2, args->intr_info, args->error_code, args->vcpu_id); }'

CPU 3/KVM: rip=ffffffffa746d5f8 reason=32 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=3
CPU 3/KVM: rip=ffffffffa746d5fa reason=1 isa=1 info1=0 info2=0 intr=2147483894 error=0 vcpu=3
CPU 0/KVM: rip=ffffffffa746d5f8 reason=32 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5fa reason=1 isa=1 info1=0 info2=0 intr=2147483894 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5f8 reason=32 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5fa reason=1 isa=1 info1=0 info2=0 intr=2147483894 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5f8 reason=32 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5fa reason=1 isa=1 info1=0 info2=0 intr=2147483894 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5f8 reason=32 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa746d5fa reason=1 isa=1 info1=0 info2=0 intr=2147483894 error=0 vcpu=0
CPU 0/KVM: rip=ffffffffa7b88eaa reason=12 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 3/KVM: rip=7ff4543b74e4 reason=1 isa=1 info1=0 info2=0 intr=2147483884 error=0 vcpu=3
CPU 0/KVM: rip=ffffffff94f3ff15 reason=1 isa=1 info1=0 info2=0 intr=2147483884 error=0 vcpu=0
CPU 0/KVM: rip=ffffffff94e683a8 reason=32 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 0/KVM: rip=ffffffff94e683aa reason=1 isa=1 info1=0 info2=0 intr=2147483894 error=0 vcpu=0
CPU 0/KVM: rip=ffffffff95516005 reason=12 isa=1 info1=0 info2=0 intr=0 error=0 vcpu=0
CPU 3/KVM: rip=7ff45260dd24 reason=48 isa=1 info1=181 info2=0 intr=0 error=0 vcpu=3
CPU 3/KVM: rip=7ff45260dd24 reason=48 isa=1 info1=181 info2=0 intr=0 error=0 vcpu=3
CPU 3/KVM: rip=7ff45260df88 reason=48 isa=1 info1=181 info2=0 intr=0 error=0 vcpu=3
CPU 3/KVM: rip=7ff45260df88 reason=48 isa=1 info1=181 info2=0 intr=0 error=0 vcpu=3
```

I've also run a `function_graph` trace on some of the affected hosts, if you
think it might be helpful to have a look at that to see what the host kernel
might be doing while the guests are looping on EPT_VIOLATIONs. Nothing obvious
stands out to me right now.

We suspected KSM briefly, but ruled that out by turning KSM off and unmerging
KSM pages - after doing that, a guest VM still locked up / started looping
EPT_VIOLATIONS (like in Brian's original email), so it's unlikely this is KSM specific.

Another interesting observation we made was that when we migrate a guest to a
different host, the guest _stays_ locked up and throws EPT violations on the new
host as well - so it's unlikely the issue is in the guest kernel itself (since
we see it across guest operating systems), but perhaps the host kernel is
messing the state of the guest kernel up in a way that keeps it locked up after
migrating as well?

If you have any thoughts on anything else to try, let me know!
