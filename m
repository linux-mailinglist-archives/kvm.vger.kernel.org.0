Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4F452F020
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 18:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351416AbiETQKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 12:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351360AbiETQKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 12:10:01 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF90A17D39F
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:09:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m1so7746488plx.3
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 09:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=andrew.cmu.edu; s=google-2021;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=CNoVtKkPqSs/sShSf0ZnKCfPCLTTVoCx3jJgzKTezLw=;
        b=ClPA9QhvZy6svirmFvw1DS4oMKWGN8R0rRh2jc+Po1r/sZ3x9Ffe+mJDIm8TBZ/LDu
         Z8jxeiHP7CfzFzGPfr8MKw3daW67FyafI9ZG8WZhe72smLZ4p18felwl2XW81abXgOhG
         KCYxlNQ/2bcoT4bJvR9jOmYaWRtEA1mhBpDZFt3imr8jB2jQQGRhV6tMEQY9BCrsjISt
         et7NDnl/W8FR18orhnercklTjqVQsxn/Fr6ftasxiP7ncRSWYmpw5bL99slPbtCFljVP
         M0zKqXM+buwTbbZCmAnSMwK8QuF+yT9xxATIw5O3DPboIudfZFdKuxOgTG4X12eCsokF
         SCOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=CNoVtKkPqSs/sShSf0ZnKCfPCLTTVoCx3jJgzKTezLw=;
        b=UywJEJCECR62FU6gw1x6DcT1W90lIgQymTnVjiPENrOCVMusr+nifueEhhfPGvIVHh
         /zXzqYbcFicpbQaFVxB5IDk+Gq7hCuk8ddAY6ivZ5N3TYHkM9+OrHWcjD8qFmua6bgHh
         zQfiQlulcpt3Pi+lRL39ehfihinDWCQ6tW0wKe+p8SEMTztc3tstFUfYvmDMw36EFzQV
         B5EemMf/Ku6K7Txfw0ifTNXx5xsMIT4oCekjIK7Bi/B7JuSkXGOHphe6dmVTSXXOU2h2
         oH9uPfnCTWRAQuwmBeJaUyOY5IOWj4NRvZuNcKTTJ2BfTu1eElxbITcTadcX8lhS9FJ5
         265g==
X-Gm-Message-State: AOAM533Sgez9Dd9gRzjpMNFSEJPQDYOAo/oRR2ES98mAbX87WKOC5NF6
        vTY5y2SWEnyWsDptO6cES10Hzyr194NXmCC1oUA69LsUlsSw6S9Go+Lkx4YO5ew30KFuNuKzvSF
        tEBzxP7v5Z4VK5P3TQxynaIQkHd0V+8VL7a4HSufqoyTK3fRR3CFAoED37tHQ0Sw9QrAe
X-Google-Smtp-Source: ABdhPJxTjndeL1fdXAJmpoVl6yOW8jWKWO6OugVzjt1MNY4alS4Z78MXV8mmbhZmqf0Mbuw4eVTi9w==
X-Received: by 2002:a17:902:ee8d:b0:161:5c5c:d0e6 with SMTP id a13-20020a170902ee8d00b001615c5cd0e6mr10756080pld.32.1653062998818;
        Fri, 20 May 2022 09:09:58 -0700 (PDT)
Received: from ?IPv6:2601:646:8b81:2df0::af88? ([2601:646:8b81:2df0::af88])
        by smtp.gmail.com with ESMTPSA id t10-20020a170902dcca00b001619fbb0e6dsm5722422pll.40.2022.05.20.09.09.57
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 09:09:58 -0700 (PDT)
Message-ID: <4d0f6a4124f1acd23abe9b4411d8c4b664490297.camel@andrew.cmu.edu>
Subject: Unsure about whether 3 bugs are on KVM side or QEMU side
From:   Eric Li <xiaoyili@andrew.cmu.edu>
To:     kvm@vger.kernel.org
Date:   Fri, 20 May 2022 09:09:56 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I found 3 bugs while developing a micro-hypervisor using QEMU + KVM on
Linux. However, I am not sure whether I should report them to QEMU's
bug tracker or KVM's. Following https://www.linux-kvm.org/page/Bugs , I
am asking here.

Originally I thought that the bugs are in KVM, so I filed 2 of them in
KVM's bug tracker. But thanks to Jim Mattson's comment, I realized that
these bugs may be in QEMU.

Do you know whether the following bugs should be posted to QEMU or KVM?
For bug 1 and bug 2, if they should be posted to QEMU, should I close
these bugs in KVM and create a new bug in QEMU?

Bug 1: filed in https://bugzilla.kernel.org/show_bug.cgi?id=216002 .
This is an assertion error while debugging QEMU + KVM with GDB. The
guest is running a hypervisor (i.e. nested virtualization).

Bug 2: filed in https://bugzilla.kernel.org/show_bug.cgi?id=216003 .
This is another assertion error while debugging QEMU + KVM with GDB.
The guest is running Windows.

Bug 3: not filed yet. When I run a hypervisor as the guest, and the
hypervisor tries to boot Windows, I see the following error printed

error: kvm run failed Input/output error
EAX=00000020 EBX=0000ffff ECX=00000000 EDX=0000ffff
ESI=00000000 EDI=00002300 EBP=00000000 ESP=00006d8c
EIP=00000018 EFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =f000 000f0000 ffffffff 00809300
CS =cb00 000cb000 ffffffff 00809b00
SS =0000 00000000 ffffffff 00809300
DS =0000 00000000 ffffffff 00809300
FS =0000 00000000 ffffffff 00809300
GS =0000 00000000 ffffffff 00809300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT= 00000000 00000000
IDT= 00000000 000003ff
CR0=00000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000 
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
Code=0e 07 31 c0 b9 00 10 8d 3e 00 03 fc f3 ab 07 b8 20 00 e7 7e <cb>
0f 1f 80 00 00 00 00 6b 76 6d 20 61 50 69 43 20 00 00 00 2d 02 00 00 d9
02 00 00 00 03
KVM_GET_PIT2 failed: Input/output error

Thank you,
Eric Li

