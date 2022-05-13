Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAB525D41
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 10:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377968AbiEMIWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 04:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243538AbiEMIWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 04:22:40 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0431725C2B7;
        Fri, 13 May 2022 01:22:39 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2fb965b34easo82774427b3.1;
        Fri, 13 May 2022 01:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/XAQKyGTIf3nEwzzm4MjG5cieNFIPfuDPs4NWHUGplM=;
        b=L8+p4daB2nhaQD22nDMvKv3YNfhcYWnHcT0dU91bolqi24ANNygzWpIg2kFxT4rGFs
         qSrhfOy9+9dpg9bo8BufAyZlQg0zjU6E7QuXNXUE4/8nQjH+CC4eNhcZKcyo24BjDu/w
         +CKk38Km/d1MZQfl2ydkviTY5D4ainaQrrz7VXw7uSBAS7awr+miiL+YnrLE1wABuIpE
         +Z36sD1jnmyupAo8l7EHS+kEP7fJA3rzebAymAuHPmILykxxUbnxm74pJf3Rc3S693EV
         uTgPRVMNDa27z2CheK1SOO+vmZzM2o7hPpjPGYkUVbR1842jLRRiBJ4Sdd5HS4gjmZTu
         rKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/XAQKyGTIf3nEwzzm4MjG5cieNFIPfuDPs4NWHUGplM=;
        b=HiAhsK4+euWLVQRgzUW58bRwG1391VebneRhEaXAHSL2vMb/HKvXKIK+RA0vL3U1AR
         Jlv4EvatEufiLVMLPvZK6GhZHVK8tHSZFHNc8cUeOdHkPECoT7QpnqPZbxmO2MAyn+Mr
         cktt+IaDd1WWT/rB0aGAVdb/X1K72fxMP8d+RYX6nzX4xh+Y2Ou50x59tz8MlVN39wS3
         7laGm/upkHvBTvLDwonv82d9INDI1Ebxudfg1669icGGzerzfITzQE/czCcaP56NzYgT
         JvujNgcnB0Q1ARH3wALxoyCo82FcC/uFPA5VXZwf433SS/2G3lh4hElSTUgkoNcB8k5B
         8paw==
X-Gm-Message-State: AOAM5301FIAyHDw3u6owOd22czCxSuQKRa1q57hKrn2kb13i57Zh93as
        4F9DqaTSJ6Aur6on0ny6MyVDHTS4hWwKvPW5CUfCCK0q
X-Google-Smtp-Source: ABdhPJziUamoq7ZAVgfQUQoRTxzcJqYbcD0+WGFzdiSXeagF82UQCp2srwF29h0yIFG7VnIlWLkOt69nfeC1cLfPlUI=
X-Received: by 2002:a81:ac57:0:b0:2f1:99ec:91a2 with SMTP id
 z23-20020a81ac57000000b002f199ec91a2mr4255592ywj.329.1652430158110; Fri, 13
 May 2022 01:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 13 May 2022 16:22:27 +0800
Message-ID: <CAJhGHyA3UxremNUH6x5NfUtNMG57zWMM776jzPfj9wfjqvXd2A@mail.gmail.com>
Subject: Re: [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for
 special roots
To:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 3, 2022 at 11:06 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
>
> Current code uses mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
> setup special roots.  The initialization code is complex and the roots
> are not associated with struct kvm_mmu_page which causes the code more
> complex.
>
> So add new special shadow pages to simplify it.
>

Ping
