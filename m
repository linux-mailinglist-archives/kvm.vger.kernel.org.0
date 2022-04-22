Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3135750B0B5
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 08:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444272AbiDVGkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 02:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349475AbiDVGkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 02:40:47 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358763FD9F
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 23:37:55 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 12so8021369oix.12
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 23:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Gy0PoKl83zfyCtYYuOAMZ9akW2TpZpijzEJ0nCaYLc=;
        b=H9g5Xdbgklpv2cPKWlnYJLx0v6wJrwDULfh6HafEe6OF4+ketaTF7FY/ivalBbe8BR
         u0yKELBee6aYqkv+LqwbQ4LLBSDMlAljovgjQtQM0+lQNK4P9xNiEmRn9x2HYNkBH+Va
         RlXBFfVNIV6RGF1xXWBIfK/rLUeUi1mNkdxlPQzNon1iOOoEtj6ujPR8cbqcD2Xnmdjx
         tDL9DedC97azrsAzSsdM9S3gVfn1RdvtdkTANyEbJDiMjrpsCqPCo47z5k0E23qyP+1B
         MkmDb7At3vgSedCtMGr6sywuYN6NJ2So5GMLpcGlpTMrrmiaqlBBmqa2w3EgKoM6rsSY
         Ovdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Gy0PoKl83zfyCtYYuOAMZ9akW2TpZpijzEJ0nCaYLc=;
        b=4Am/T+JJhUMIX0hgQHW5ZTNASJkp8nUKgv9/nGBsubf8xcgiqGCghIYuTfawHo8KEh
         CJT1a0wapVYcJOPHu3oW1cxYWoPbDb7fiNEhmnsOiSqp6R491wB0Xe/lk2TP4UeaHq/w
         S/jOvqFn9JtPGuOCHNI9uyjYTvTTn/tkAS3iH17ONrRbGw9iW4Q9ShbevDkeCkrfjj7E
         DpUsE7wutay4OJEnTuWA8bkCnXPnaW6ACp8E5460aUrpkWRF9audO5TIU2eNHzmtIjB9
         AnItgNwA+cRdUgHYWHN8k1UYWgmFqJLCwAo6WEjS+OryND/MFTQ4im7nGIH7aRkaqBlu
         fNAQ==
X-Gm-Message-State: AOAM531/F2QQKfRYauofFnkImDCF7J1l8W5v7R6wo2E++CX/rqZTZZe6
        FkNIpizDD8FEDLt2x34UaWnEP0y0zyOXl3pTASKaOA==
X-Google-Smtp-Source: ABdhPJzEx0Qyr/AR0kCUamtLmnJEeX5smZGi6mRt3AHLeZ+1hXPbr3paI14aJNqCW7OgdXhRwAlrvapFNxD4VMOe6Uc=
X-Received: by 2002:a05:6808:d4c:b0:322:e7de:fffe with SMTP id
 w12-20020a0568080d4c00b00322e7defffemr5014104oik.107.1650609474337; Thu, 21
 Apr 2022 23:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com> <20220409184549.1681189-7-oupton@google.com>
In-Reply-To: <20220409184549.1681189-7-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 21 Apr 2022 23:37:38 -0700
Message-ID: <CAAeT=FwDJg5TJb048bCWmS2MM1j0oTXuf0-Gx8WO91JfRJymZw@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: arm64: Return a value from check_vcpu_requests()
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will introduce a vCPU request that could
> result in an exit to userspace. Change check_vcpu_requests() to return a
> value and document the function. Unconditionally return 1 for now.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
