Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C16783697
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 02:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjHVALh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 20:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHVALe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 20:11:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1DEE6
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 17:11:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c091a563ecso2221655ad.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 17:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692663093; x=1693267893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDahN3fIo9Yc2+ep9dbY79il5/dZU78h3r7Exh1b6/4=;
        b=apBsYIrYcQqojTzwCJ7xKfnuVCfAF/GuYk7kFn6tI53jlWGmwtALrkRIRsm8pCl/7F
         GeKjNJPhPZRy4PIsI/hsdMROl6MxH778CRGhTS9SdlggYvBm4//aPjlzw9Kt9dpXBamj
         bZUS/rlCTRYuz+FDJ116UW0lrCoRegJiUfFwX/1qGVBlncvhw8TlX+Pw3tsRBJNlsknY
         piBuD9/nGQkOwv2YcR9pvCUEF5NMBVzs+a1aseLIvgw6gnvWl98qO/uNJzeDPJBVf7XV
         gKVPtNlGCaNutDu5eG3WxE4SGm6uq9yPijPQ76a1LwWgplOyzzpWTbi30cXu8XUuBS5Q
         EnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692663093; x=1693267893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDahN3fIo9Yc2+ep9dbY79il5/dZU78h3r7Exh1b6/4=;
        b=dNq/agxTZfJXGa8QJsHtq7OJThI0JV+5Dykna9oO9RBhdLkNzQzf5Rvd3yHwDT6BvN
         1PydUuFgw9C2xEzUiAIKz9gogS+POZMJ1md1L0SmBL9D80Vmb03ymXAdW8/QAWtssv2h
         w5Q4sRl7rq7UFZNZdt3SBuFbWTgfMgwQ/0uNegvgsytBZddR4VR7/MtNeYX3/n8rQZzS
         BlvZ2j4e0VJABxX4j+c0ah1iciNCdIwrhyap18H/6JiX15lwQL0BkpVvJ7G+Sdd8zUNh
         WgxoCPtWkLIVlu4Ro8VgfQUm1UKnlgWzl1GP9+R0jEEuAMLiThcQQdxFoPlww/mh0ZbC
         crZQ==
X-Gm-Message-State: AOJu0Yyd+Xgt3B4LNCba+Iyr95VjBapxtMhxLTPtOLLVfbQKfIRj8EQT
        QZiAIWjnVkJuLo462+Rae19W34i2XHY=
X-Google-Smtp-Source: AGHT+IEdudIlLLXKU6y6IS6E98aNVKycN71YT5OJnDrdI/xELeIkXfBqUv9/qgcLP6HmLGSetucc2ghlowI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c44b:b0:1b8:ecd:cb7f with SMTP id
 m11-20020a170902c44b00b001b80ecdcb7fmr3590974plm.9.1692663092756; Mon, 21 Aug
 2023 17:11:32 -0700 (PDT)
Date:   Mon, 21 Aug 2023 17:11:31 -0700
In-Reply-To: <ZOP4lwiMU2Uf89eQ@google.com>
Mime-Version: 1.0
References: <ZNJ2V2vRXckMwPX2@google.com> <c412929a-14ae-2e1-480-418c8d91368a@ewheeler.net>
 <ZNujhuG++dMbCp6Z@google.com> <5e678d57-66b-a18d-f97e-b41357fdb7f@ewheeler.net>
 <ZN5lD5Ro9LVgTA6M@google.com> <3ee6ddd4-74ad-9660-e3e5-a420a089ea54@ewheeler.net>
 <ZN+BRjUxouKiDSbx@google.com> <418345e5-a3e5-6e8d-395a-f5551ea13e2@ewheeler.net>
 <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net> <ZOP4lwiMU2Uf89eQ@google.com>
Message-ID: <ZOP9M2iNpvMbpKbW@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023, Sean Christopherson wrote:
> Below is another bpftrace program that will hopefully shrink the haystack to
> the point where we can find something via code inspection.

Forgot to say what it actually does: it's essentially printf debugging to see how
far a stuck vCPU gets when trying to handle an EPT violation.  The program should
be silent until a vCPU gets stuck (though I would still wait until there's stuck
vCPU to load it).  When a vCPU's "faults taken":"faults handled" ratio gets over
5:1, i.e. the vCPU appears to be taking EPT violations without doing anything,
the program will start printing.  Unfortunately, what can be traced via kprobe
bit limited because much of the page fault handling path gets inlined.
