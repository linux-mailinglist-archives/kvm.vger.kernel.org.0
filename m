Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BC05164F8
	for <lists+kvm@lfdr.de>; Sun,  1 May 2022 17:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbiEAPdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 11:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348033AbiEAPdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 11:33:47 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CC82BCF
        for <kvm@vger.kernel.org>; Sun,  1 May 2022 08:30:19 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id s12-20020a0568301e0c00b00605f30530c2so4513261otr.9
        for <kvm@vger.kernel.org>; Sun, 01 May 2022 08:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=BQlfLABNsJF54/gN+kM2fVilN466vkttvirPrEDwNHs=;
        b=kH9a3FOUH/UuuFg7tlYn7MG484B3DSOzgfTejmloLjg80TJSNDUCsFL0zCd5Fdq/3K
         RkEP/fo+seMQUywefOdgG8+2ft9VjR0jA0mOafgQWmspbaKiOyCFEGYRHCIr1rmEXdVB
         eckMfy4a5S9VhCpbS72C6oDDtMACiUEt0G3t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BQlfLABNsJF54/gN+kM2fVilN466vkttvirPrEDwNHs=;
        b=MwfToFWYhUlTKVNmMw3TCLG2N1G0adlSXxB9P9qCUoVGOX2AMkLQ/vGbyVNNPRRmtV
         S9P3vE/xht6BTrHS+yVzfXFhabmqGGaDgMVXGSqkL7s3tNfU2TEaE7yzIzPHfNeoGZFh
         8hYDv+Hn5xkDNi8S+xqsnfRFIgeSZw8V/J7p2jPI2lHYPkU3xZ0txzFfqsZnsrJIB8vp
         AQtioKFVMOKHE639dyivrtif9JhxMESDsv6M9dzAaJ7+jAW9UxRz4u1m0xu9epJGACRM
         XuM4V8itrONNjeGcOnGoTlJtG9fBGvI0EkNtyVgqNwJ0Mq2+7xGkfOerTrYY14Fgq8bh
         d/pg==
X-Gm-Message-State: AOAM531eX9dpDuPDgS7Ilc0KqlTyigrjP0KeM+Abv5OBy99Ejpk65rce
        3yDj4wlzcZKECQ9TaQP7HOTeH37aJUklxL4TJdwioj91lkM=
X-Google-Smtp-Source: ABdhPJwWdtKlWnvuJJakeRO9jomJKSkFNLMLlQU4sKRBxex4/zOoYuVCBIMM8VWr0xOAPSvsLLhJkuMYWtagm3xvnQM=
X-Received: by 2002:a05:6830:410f:b0:605:8c7a:678e with SMTP id
 w15-20020a056830410f00b006058c7a678emr2877622ott.377.1651419018633; Sun, 01
 May 2022 08:30:18 -0700 (PDT)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Sun, 1 May 2022 21:00:07 +0530
Message-ID: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
Subject: Causing VMEXITs when kprobes are hit in the guest VM
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello all,

I intend to run a kernel module inside my guest VM. The kernel module
sets kprobes on a couple of functions in the linux kernel. After
registering the kprobes successfully, I can see that the kprobes are
being hit repeatedly.

I would like to cause a VMEXIT when these kprobes are hit. I know that
kprobes use a breakpoint instruction (INT 3) to successfully execute
the pre and post handlers. This would mean that the execution of the
instruction INT 3 should technically cause a VMEXIT. However, I do not
get any software exception type VMEXITs when these kprobes are hit.

I have used the commands "perf kvm stat record" and "perf kvm stat
report --event=vmexit" to try and observe the VMEXIT reasons and I do
not see any VMEXIT of type "EXCEPTION_NMI" being returned in the
period that the kprobe was being hit.

My host uses a modified Linux kernel 5.8.0 while my guest runs a 4.4.0
Linux kernel. Both the guest and the host use the x86_64 architecture.
I am using QEMU version 5.0.1. What changes are needed in the Linux
kernel to make sure that I get an exception in the form of a VMEXIT
whenever the kprobes are hit?

Thank you very much.

Best Regards,
Arnabjyoti Kalita
