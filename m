Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC555B8F26
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 21:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiINTJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 15:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiINTJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 15:09:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0BF81B35
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:09:24 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so15366141pjl.0
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Vf0GqOOK3uEkXN9WNsKg2nCcJ7gEgVHu0tfubCGolLk=;
        b=Ix8wQG8P2YBtgMuYLRU2gZVvgfG/KvQdltCQJtYPe3r5Nw2RASFGCYjRlBE363g4Uq
         LBRcA+z6swJhD/p979NxWvW0gtGKcRoxyYeoVs0n9+dgeFCd10TJG4Qs+FDhubksdM4G
         44OOmlLoTGNzjI8X53X2M4UxQlVrwxh1eYRrZW/RHfyZxu4M5YOlR4bSELZPHPlEQyCj
         gEHni2QM+xiJzfsEK0UED68GE9ZfQoaxwt5/VnDKK2DcPzG2EKEPdvh5ZSVmAJIfkaMR
         FaycXB4gSxuQqBflbF2VfX4e9FiWR+KmGd8I49K4txy/xTIHr3+DairQNiYpIAyZOu1g
         lvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Vf0GqOOK3uEkXN9WNsKg2nCcJ7gEgVHu0tfubCGolLk=;
        b=WsSKCWGeLyBeNUn8E3bkYtXXeQrokuBla5C9mCOJtHKBw0MMxY548vvWi++4aAsOe4
         pwIrEneH9hUePXSnpR+9gMoFtxHe/KGTL9EUxH6Z/SlsruvJMsbQX/gNXhAchKJJfhAQ
         k05KRL8jSv6eUde5poIb08knuDar6yDGBvevE+C8EmlhAzw8PyGjXBjpo6BQ7ND+1WtK
         MzX3PpdOfxnLOpglR9WQfq6HLwp9A/x/0B3i6WjBRg4/9rfXP33QcYO+wbVL+cua3Xy/
         7enpNMQIQ8RV64a94DLiG8XQIDXq1RTypsJIdZ3Ewmc8I+9B3jvEq2GTC03T1GerZC0x
         HC8g==
X-Gm-Message-State: ACrzQf37o3FO1O0w5gmtIDwvHm79HTcRlm9WKvtqHsityRUciP8mrWOz
        ObDjf6FNy+XYZdEJs/rE3SWGiKeqH9BuTSKH2kL//g==
X-Google-Smtp-Source: AMsMyM4Ala40C7jBkQ2I54dEklxAZPC8zv+v2oEl63bhkLcXaIOX+9pXi8KM9ZGWLSuVRjS6+nBHZJGan+C2gOXb0UM=
X-Received: by 2002:a17:90b:1d02:b0:203:2d73:8efb with SMTP id
 on2-20020a17090b1d0200b002032d738efbmr766863pjb.214.1663182564226; Wed, 14
 Sep 2022 12:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-2-vannapurve@google.com> <YxpaFfw4jbwwvEI6@google.com>
In-Reply-To: <YxpaFfw4jbwwvEI6@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 14 Sep 2022 12:09:13 -0700
Message-ID: <CAGtprH-3qyf4hn+J=G3RFtvYwDdH+Zd3deDnnCycobyyF1V30A@mail.gmail.com>
Subject: Re: [V1 PATCH 1/5] selftests: kvm: move common startup logic to kvm_util.c
To:     David Matlack <dmatlack@google.com>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>, drjones@redhat.com
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

On Thu, Sep 8, 2022 at 2:09 PM David Matlack <dmatlack@google.com> wrote:
>
...
> >       print_skip("__NR_userfaultfd must be present for userfaultfd test");
> > -     return KSFT_SKIP;
>
> exit(KSFT_SKIP) to preserve the test behavior.

Ack, though this change should go away in the next series with common
selftest init using constructor attribute.

Regards,
Vishal
