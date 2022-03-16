Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651C14DB7C9
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357721AbiCPSLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 14:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357722AbiCPSLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 14:11:10 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5F06B0B5
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:09:56 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id h126so5953832ybc.1
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7XMutS1ghlFhAcs8/x/Pe4DRiYkYF5xHdbcHJcH98bI=;
        b=N8TA6UWt/HOTEUiK2WpWKW40MkVKi/M/jIZRss20ZggSq7GJz5XtmemrF++vDpZ813
         HVY1KkL9Dav4FNanRmYAdoNHzAu1hhSfkElr97BrORfOqAILEz3t/M/znBJ60sAXUo0O
         tGqTGc1Xrwtxt8mt2Eysga5G+Swqou1oK3q4q7cvyss/ocyzimgw4ez0YOOOQr9a9/Jt
         dynAZdRFrx1DWJeCwtxC5v5udwc4o/hgHgN7CcUsvOUkE/F8afr2RxZD6ERHo7iHmdc9
         hb4CoWBRf6K2Z9LixnudJLtjOP5o+awJY6SrI+buRJjdPepgL3Qv1OnZk89Uxg9MfMXd
         I1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7XMutS1ghlFhAcs8/x/Pe4DRiYkYF5xHdbcHJcH98bI=;
        b=2pPKYHG5knvaZMsGjcDecI0/FULpta5Onhgp9zA8I85mnUIArJbIySfqzxm+8uv8qy
         gvyY/qk5u+H8kyny+xiIidKDXKTw3Z0+smH1pgbegm6l7D1siA/Z5WmthvliFbAf172k
         Nv9f6JAzCc1QNzCxD8OoNgLxl7NmnNrpzAFPfgjpJQj4k4YDSwu5b92bbaM3C0kB2D8U
         zif+v3ljXgGL1we4m4+o4UPSAPxJ+NnzbLPo1GgrNtw6VyDmRuVT2LJYWpaSRxyJTKP5
         6Lm5Dc2Hp4MVfqPjApDFeG1TP/scrCn1UHa2bi6O7fB/EziioEN4aNiGo3gYSMLGc34Y
         zr4Q==
X-Gm-Message-State: AOAM532WisqKWDkzFHZeietCEqBk0nQf1u0Sk9bioOPXZ87N0Yw1p9RX
        GaPKBwp9QaJcw9jAHueUWIDL8k9W17uGRdh7HMIaRg==
X-Google-Smtp-Source: ABdhPJzKmoZaOsrzO1wchwLd6WsW2qXHfdiZHlUIC3mlysLp2Pr0Fg01zSB0WOL7T6g+DtckFOBF0OW7YHskbDSV6HQ=
X-Received: by 2002:a25:7b85:0:b0:628:beb3:d877 with SMTP id
 w127-20020a257b85000000b00628beb3d877mr1302980ybc.8.1647454195715; Wed, 16
 Mar 2022 11:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com> <20220311060207.2438667-7-ricarkol@google.com>
In-Reply-To: <20220311060207.2438667-7-ricarkol@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 16 Mar 2022 12:09:44 -0600
Message-ID: <CANgfPd9d=C65y=hbpcf5y68d=u+p0LTtk3OO+q8reGmjv8TEEg@mail.gmail.com>
Subject: Re: [PATCH 06/11] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
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

On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ae21564241c8..c25c79f97695 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -702,6 +702,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>         sparsebit_free(&region->unused_phy_pages);
>         ret = munmap(region->mmap_start, region->mmap_size);
>         TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +       if (region->fd >= 0) {
> +       /* There's an extra map if shared memory. */

Nit: indentation

> +               ret = munmap(region->mmap_alias, region->mmap_size);
> +               TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +               close(region->fd);
> +       }
>
>         free(region);
>  }
> --
> 2.35.1.723.g4982287a31-goog
>
