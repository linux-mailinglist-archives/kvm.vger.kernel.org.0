Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B294E676F
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351975AbiCXRGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiCXRGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:06:13 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3817B0D11
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:04:41 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j2so9632568ybu.0
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2oWKmkfOWvxUnDra7Y+PB5WR2ZpUOaT3XNR+3ADMGVQ=;
        b=AjhT77S4UyfQs2EucIciQpHpbBjbeMDxGx4qyANZJ9f5UjGs+Vq3pEDBSVwSeVOEyc
         xy/cE1twoFjLoMS1Yl8/JAlnvbpxCve3OeNFLBA43TFtauWRAFVdwbbv1FOjKVzIlLGV
         SFkWwPUFuPoX+qzDS7lhFFT8O9E7bM2xMabmHtESeY1yOzJs8k73gc5/h1o32JTltPJt
         rn1X6IwSmldaBzp5F+1nOduB2HPA6RWJiTRHcQwvPJBWJTObtj+dCYBPal+PG43ELNI6
         pn0nK5b5Mf3qbUNAOsjUvxQFNIeBzdy+b8xyuavsrwL9FzngmUNbWBAfsvtHRMKWF3Ok
         e+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2oWKmkfOWvxUnDra7Y+PB5WR2ZpUOaT3XNR+3ADMGVQ=;
        b=zelkcPtPe/1n2BhKXkWqiObxqQMl5LT4jtEzVrDBM6x64Rljc4wk8FJ6STPu7nMmRl
         g41j+LEx+6V/BWUrNZKQSf2vkFnhVkEwz5qiwXrPvhJVp+7EQi4aU1vo6dFLwWf3CoBP
         QiI4xZ1+lhNk0mm9KnJ1bHFjOEw+qM+JAjg05skQRZo2neoL8moXMXrZ4bplKXfPGleN
         1gP1jSeyV5rP8D6gnCmQ7aEEuR8Wp5jTwIEHT8qRWN8yGwi6XxRxApnd2O9/RPPhLsao
         UVyjGV/pbc3lAWQf7CsmZlNylJx2nHFMBDoDtKNNUzis58/XrpWUNJEfJFNcmGUFspFl
         s2Gw==
X-Gm-Message-State: AOAM533CNBAVGhYa2yig45ef6lorSfl0ujwCAS0dJmOoSyAfs9jakkyZ
        GlLl9Y9gAEOg/Qv0kEmv0MGbjhwbF8BJExLFFPaHqw==
X-Google-Smtp-Source: ABdhPJx4QO2adUVPIQLJqcmbG3j2RaYOsBWpQ8MyrkefRdlsvv2nPVXBlAAhccFX7iodZ0q091RZshB2aAGcnPm0HSU=
X-Received: by 2002:a25:2449:0:b0:633:c9aa:b9de with SMTP id
 k70-20020a252449000000b00633c9aab9demr5322435ybk.255.1648141480639; Thu, 24
 Mar 2022 10:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com> <20220323225405.267155-6-ricarkol@google.com>
In-Reply-To: <20220323225405.267155-6-ricarkol@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 24 Mar 2022 10:04:29 -0700
Message-ID: <CANgfPd-YQ9PRpp0py3_oM6FUzgd4wbf9y_Wz0Go-GxFUEi9hSw@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
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

On Wed, Mar 23, 2022 at 3:54 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e18f1c93e4b4..268ad3d75fe2 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -679,6 +679,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>         sparsebit_free(&region->unused_phy_pages);
>         ret = munmap(region->mmap_start, region->mmap_size);
>         TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +       if (region->fd >= 0) {
> +               /* There's an extra map shen using shared memory. */
> +               ret = munmap(region->mmap_alias, region->mmap_size);
> +               TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +               close(region->fd);
> +       }
>
>         free(region);
>  }
> --
> 2.35.1.894.gb6a874cedc-goog
>
