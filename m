Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DD159AA5C
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 03:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiHTBEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 21:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiHTBEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 21:04:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CF8CD50F
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 18:04:12 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w11-20020a17090a380b00b001f73f75a1feso8994246pjb.2
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 18:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BUrdea1kLIkfiZpG8tpuUz4QLKR+4IyifY4DHnFC6SY=;
        b=j4ubyU+83qscGmhSUUADH/8jIqODtkI/06DREb2ZVMnCjXpWUJFCQJzeY2HcPrA46z
         uU6lhAEpaUwE04arEWagpgaSCFRcvpkCiQfUMcsZXA5CrsFze1YfBQFq18b+a6s/Go22
         Fodg1lKPz7G+jaeGYhNTGjfphPQtAd/xSej/fGAsqTtz2ZtVFEfgqsn1ynL0851cMFav
         MILyOqKcBReOc0eaurqbPBK9hWTEfjB/qIcTYbdW2+1ke6ayTwDUUoBCKaMkyBQFUSqL
         O89qZcJWq2Xabsh+LrvgKyoteoopMFwjhkaGZ8CynRXZvNbQJIuEt9/r3Blmq9k523Td
         gJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BUrdea1kLIkfiZpG8tpuUz4QLKR+4IyifY4DHnFC6SY=;
        b=vNId0tMBFYFkS9Txajm7n2zzN1jrHEUae+lXk4TBk56ZvYW3DP2IGSzxRvL2GqcGhh
         xocct21wPwkbGfbONmvsUXQd4Logf9ytFJDi4pUOiRHKdWTbBzcihPvbPMN5LnS9JEG7
         YMyTZGIVcx8s0IRTMwBgnP69TkDjDMKmj6t07BzmJJBFr3CpEEIX74qiQ41nY6N2LVxg
         vcCCFZtkUs+Mo6zQ5N+pWHGZmnq8gHts4wx0/asYVz6IGesj6NK725d4o3wYu2I6RJ/h
         +c71O4RIdfWEZz6ALNRfIG9YXj+q8raZalrwiU7GY5AaM1B7Xs+K88JewxSZE2dtAipM
         k9Zw==
X-Gm-Message-State: ACgBeo0IeXBbXvAWvMP6kxCFwlZqt3Rs5Udh5rg11cHaf3u4n+lwjvar
        hvmzuW0ZZURg7ms2A5wFu8Yxo3jVmg/I/RvMt+X+AA==
X-Google-Smtp-Source: AA6agR50YGjmv/MaOuxX7OVnBI89aWJK7jroSyJcnvNx2fEO88rtCe3d8I6iZSVbMOIzkySXAJtKBnPpAZZRW6oNj5g=
X-Received: by 2002:a17:902:f0d4:b0:172:aa2a:49ac with SMTP id
 v20-20020a170902f0d400b00172aa2a49acmr9662127pla.9.1660957452333; Fri, 19 Aug
 2022 18:04:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220805230513.148869-1-seanjc@google.com> <20220805230513.148869-4-seanjc@google.com>
 <YvhL6jKfKCj0+74w@google.com> <YvrAoyhgNzTcvzkU@google.com>
 <YvwHpjxS9CCEVER7@google.com> <Yv0Tk0WAdxymSyUt@google.com>
 <Yv65c/t23GqpLPg3@google.com> <Yv7PHx2qSB0PwkP/@google.com> <Yv/Wu46A98nz57YQ@google.com>
In-Reply-To: <Yv/Wu46A98nz57YQ@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Fri, 19 Aug 2022 18:04:01 -0700
Message-ID: <CAL715WJEsGUKei7Xhye5w2h03puhjCr92h2Jj4BJRi3LJtMtVw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] KVM: x86/mmu: Rename NX huge pages
 fields/functions for consistency
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> (nx_huge_page_disallowed, possible_nx_huge_pages)
>
> case (true,  in_list):     mitigation for multi-hit iTLB.
> case (true,  not_in_list): dirty logging disabled; address misalignment; guest did not turn on paging.
> case (false, in_list):     not possible.
> case (false, not_in_list): Any other situation where KVM manipulate SPTEs.
>

made a mistake: should be:

case (true,  in_list): mitigation for multi-hit iTLB.
case (true,  not_in_list): address misalignment; guest did not turn on paging.
case (false, in_list): not possible.
case (false, not_in_list): dirty logging disabled; any other situation
KVM zaps small SPTEs in replace of a huge one.

Anyway, this is not a blocking comment. But I just don't want to leave
a mistake in the conversation.

Thanks.
-Mingwei
