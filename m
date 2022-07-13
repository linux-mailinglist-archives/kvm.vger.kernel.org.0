Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B3572E5C
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 08:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiGMGqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 02:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiGMGqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 02:46:09 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F21FDF3A5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 23:46:08 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id i186so9895589vsc.9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 23:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eVhC/3eC5T+uVY5zCPqJvEHAiZQx991cN+OGRmvdPJ4=;
        b=R2tlFJo7b92QRtPKgzqkJ7RZkVZ64HxIrmYSKOcn98ummWgwZOep3MNQ0ANWNxgsX4
         CLmUFuc8SccnfpSjG2SJKnWsNnr+se/++AM4yV37ysq65KpqkBSFtELhmuw4rX0tC8ka
         HSOX8qtjeirynX7RSruFMax3bZARnKRfpATEDI6W7DTENR7y8mb+lIuh13N8/j59Ip09
         VvxTSs18jQhoGAcQY5F3N9Sp4gMQLx8d6EzCfLg0JE2brKOUhMFa3I9G6kuIUz2rX69N
         DMPBxWfgxvGBXL8fbBZnLw9tmjGp+PPM+ReRly+sBKcwoRmqWs3b5Uy5fuCYCtHYD9ne
         8PoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eVhC/3eC5T+uVY5zCPqJvEHAiZQx991cN+OGRmvdPJ4=;
        b=OcFJqCZj7DpUG+a+0gkUZmzgXQAYHOvk98Ng5Y+rTkBuQuvk6N0jO1vEkYDgXVCZIR
         ZED7WfytltivHsEmuzIqqlXbM2IrNXO9fU9h6BZBGgBPYH7yVqtIt3BhO0A0nh6PRguT
         /TI25UNqbn7zp6qvs2ZUuhdCT4Gccs4y9T+FAuNRz1zHOuSRfJb+ITeSQSTLgJJ5eyLu
         pT5292MmoAdbZwhO9MW6M6a8/I5hicWfbPGCzZy6giWEhU88cYr9xJPno9el5D0A5Akv
         aGue4awgGnC5YHUDa9G4gzb6uOv5cL5NAXw3hrcYu4rG6tXje9CfQuPBcjsjkva9XfJo
         4kMQ==
X-Gm-Message-State: AJIora+Vap5zzbTU0YcMpXeTK5u1qHISjs711KaxNZ6MkO0iGAYakt4p
        cYUFP4mv/lVX6o2bOHxqX0V8aOUWXgJ6Pe7A5Zcx4A==
X-Google-Smtp-Source: AGRyM1vAIc+192gcPmhZ/OUxmzIY9hA9We6tz01rgpw9y2ihdWpQBLwpMt1VyVjBA74EqAPZkTaTemOlXd0RKxVwCxk=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr522722vsh.9.1657694767428; Tue, 12 Jul
 2022 23:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-12-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-12-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 12 Jul 2022 23:45:51 -0700
Message-ID: <CAAeT=FwQtdDY6RAnjx=gJjghvZwF8ud_dCu+ymcKiHD6fm2-Sg@mail.gmail.com>
Subject: Re: [PATCH 11/19] KVM: arm64: vgic-v3: Use u32 to manage the line
 level from userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Despite the userspace ABI clearly defining the bits dealt with by
> KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO as a __u32, the kernel uses a u64.
>
> Use a u32 to match the userspace ABI, which will subsequently lead
> to some simplifications.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
