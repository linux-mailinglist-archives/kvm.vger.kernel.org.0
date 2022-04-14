Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3198450058B
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 07:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbiDNFnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 01:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiDNFnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 01:43:18 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F50946B3B
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 22:40:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 125so3853387pgc.11
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 22:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1hgtWRPVfebHCx6gQcTV3Yk+K2c4QLvXa3Krc4aE+I=;
        b=HBRAGQ+fdedq6sCWFdaUuiingyGqdqgL2NwOwh7l6M3C4+3PWTpWz9sRnQppY5X5es
         7zL11ImuBV9qw9CUu632h83AkbIugEf+Wh3BhJWXUIQvpLCrlUNg0ZRnRs/K0OIJJgIE
         U7waqA3D08+CyyXeODngDKP4KQqjF/RNNrraanYRpj42qi/53Gaz0k7e0FJd4LrbtxmL
         tH+zH7HWByi+PXc/ygxFCIGJ9NwqJ3hehDAjWHQsbAYUeXbzluepBluecyJ+Ur4mw+kk
         8AaTMogFL0FezD8IzqvmmU1nqmOhdEFT89J1yloUBBam5vF+xPbaa7Wa0piTFiQcyQt0
         1oRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1hgtWRPVfebHCx6gQcTV3Yk+K2c4QLvXa3Krc4aE+I=;
        b=AyGvcrUj7ajiFB1kxsF9uSi3eXlMnC6rD3S2Ij8K/1Q/euUhcfTFtVkJ8MCNaSElCV
         m12FvC/ymuffoGzA5JRly7HM+bV0l9yHULxopwiKlLZ36tzBrwlIhr00sGS2NLX34koM
         GxnwuUoSoPn+mohldyL5ipa3X0Z2ixlYyw5dlNwY7Z+iJQ//XLWH/wZ0eCMlGCVmqPDu
         fg/Wpm+wg2NG7ifGcwBR2tdI1PCmVeHsBSH6mBT9cnbT5ou17yU0l60byynpq1HzYEzi
         KV9ZmsdYalpdVwyoF5JYUmVP7rdacYulBTCzfLZlxgtcqC2eQzo94qR5+UvRoGZU2Ccg
         LICw==
X-Gm-Message-State: AOAM532wTlBcvm9FUg3c+KZeBC3e5ZGxw8R28ZDGci1RJ0h+sQqd20/Y
        ADNSF9WaqYiysfmUPJ4O+UM1hhwkQUgda3ZvXMLVBw==
X-Google-Smtp-Source: ABdhPJyisD+MrxCX0bQsCM+Yp8XfbbWBxwD7Q6y71Dzxvhi/l3pOb2vn2KwYoKHVe94g7haoXdRZFL7A2KgCb6+pK4o=
X-Received: by 2002:a05:6a00:9a2:b0:505:974f:9fd6 with SMTP id
 u34-20020a056a0009a200b00505974f9fd6mr2299540pfg.12.1649914854653; Wed, 13
 Apr 2022 22:40:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-6-oupton@google.com>
In-Reply-To: <20220409184549.1681189-6-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Apr 2022 22:40:38 -0700
Message-ID: <CAAeT=FxBMy9jopi5O-L54Rk9AajvwdCSBdNdMozZ_a_OcBB5aA@mail.gmail.com>
Subject: Re: [PATCH v5 05/13] KVM: Create helper for setting a system event exit
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
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

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that appropriately configures kvm_run for a system event
> exit.
>
> No functional change intended.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Acked-by: Anup Patel <anup@brainfault.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
