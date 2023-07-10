Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9567B74E241
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 01:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjGJXjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 19:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjGJXjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 19:39:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857B3BF
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 16:39:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57059e6f9c7so74537847b3.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 16:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689032353; x=1691624353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RPV4yRyL4/s25LnuLR3Abqfyd1kD/q0hgy+72dsX+RI=;
        b=JivYvyrNd89WKD5Iym+pt7XI1Sezwfj50YlasTQvKOyw47y1vDafeSAYj0SHh61TPT
         n41hTixKVN2lV8jfA3eQbgTRSfcQbZHM/yFrpzObIWgYNXIgOoSuSYjTQ2JYz1U7lNwi
         W50TcrtbvoMVAnEkPNWj/lCI6eJdgc/qSZwhKpGRrkR1I20ve1J967fFpqSP5Z/bZYfc
         zRZkZMqcz+Y5JJiQ+0FCHWUP8fsbxn2ORjg4Un9uo6YddqTF4OtBi97a4G9xSL5rt9TE
         nE472U3K5mJbYtZnbMe893KLsDFgEVaKVYPsRB/XujaEchDANnMBNv49EJTsGlFlSEzt
         /00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689032353; x=1691624353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RPV4yRyL4/s25LnuLR3Abqfyd1kD/q0hgy+72dsX+RI=;
        b=OY3IhFGBUQd7eAUPn99p74SHObVpnBn7dYeSqlvLoGepsJxReXh0vsvOy4pf/EtwZA
         LVVF97HhBgPf/gb0UQRk2pda/Ja/MEYHiA4C0HHdEob6EA7UZ3q06WJ5Q0jjwm7DNMvt
         ri2eFOTQ++BHXTmsyb11RqEtdkxQNA5fWVs3GFrks+2H7L84/SYVwiPn6JcwRrXVSr28
         J0K4q6VwWE9IvUNfcDhtlqFYjGaXhymoF2yIgjkbsTpdlt9A6pvShEt/a1Pxd+rLzJS9
         UbfLLCynv+p1uKnlqEtUYsjNOACVbRbbYcfz0IWIjrqlzmrCcUFoGBQxt5dddep5n6BN
         mV3g==
X-Gm-Message-State: ABy/qLazn3pCaClcBeX1YQfypJAhROiBrVfv1lVc0LjhklT5w5G1XoF5
        zUkcIh3b/u7mnffHU83gELb9p52kRJM=
X-Google-Smtp-Source: APBJJlHRU33B//Lf94Rxl2oQGlfI56m0S4fCd6asV6MRwDJRFDxF49UkUqsUhBgexG6JJ3xXpcGAp2uOpko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b384:0:b0:56c:ed45:442c with SMTP id
 r126-20020a81b384000000b0056ced45442cmr191609ywh.5.1689032352836; Mon, 10 Jul
 2023 16:39:12 -0700 (PDT)
Date:   Mon, 10 Jul 2023 16:39:11 -0700
In-Reply-To: <0000000000001f8ae4060029cff1@google.com>
Mime-Version: 1.0
References: <ZKyGn5UsJaAx7Ghy@google.com> <0000000000001f8ae4060029cff1@google.com>
Message-ID: <ZKyWn0h9hDzfU0cs@google.com>
Subject: Re: [syzbot] [kvm?] general protection fault in vmx_vcpu_run (2)
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+42a71c84ef04577f1aef@syzkaller.appspotmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> SYZFAIL: wrong response packet

Heh, well that wasn't helpful.  I'm going to close this, worst case scenario
syzbot will provide a fresh new reproducer.

#syz invalid
