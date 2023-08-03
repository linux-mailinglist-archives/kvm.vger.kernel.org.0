Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9FA76F34B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 21:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjHCTQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 15:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjHCTQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 15:16:00 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B6230F4
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 12:15:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5635233876bso892516a12.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 12:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691090157; x=1691694957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QAbc+4fCOMN1wq3LOwJ4k1bsXl9R1Q+x4bhgj3rFIg=;
        b=DSNF3uKlxbN1/j9sGPdV4RLbiLmTPzUp9Zu3X+X+jI/CXp8qoKO4kiLFxh0eWH4ras
         3UHMbP1YaoUXHaU6RKc0xiD6OqP0/G8GaXsxhmkMXaXcobPCXbuINlBumVapPQ9eL9WI
         SQMF6MIyr2Twu3rQpgN63Ty4xEmvWMdFcq1qk0s/bO53R4WtT4D6mxqEq84CrHbE24tW
         R+R0wb7QBQEWXSd0EQn3phD4GyYVVYig+DH6wM230PxAw/bTqhOS8nPt+LaY5XqmbBEo
         2lNVu9E2Fm9D/OSL8FvXxR34+QmBLtfkxeWiU2TVRkIK5+koZ6XE0PUmvWk9wsqvFkyB
         PpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691090157; x=1691694957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QAbc+4fCOMN1wq3LOwJ4k1bsXl9R1Q+x4bhgj3rFIg=;
        b=Dzj2nj6Pqb2Yt7i47QrEN8XHrTIqqaaVGEUd24tJvwrChfZryTOMUpDRvO2F5CEfTn
         up2Y1xbgE+UY+LtN6exYa6KAK39UF34fhWMQliiwqIHYYXcwO6QNumHxDt+7+qwvlFsr
         PYSQGWUMdtTehh9lNwDSqBs0eo3TWQME8/oRG3yyZjZ/JmfeqPYxaD6znYRCbmn4uSmA
         p0taC9AYC4jKER+4MzeoYe79EXY8zzsnvN0SsMA9FRmSUHCRcOs089BUd2Ch4UAj6eMa
         osiD4x+PB9GgNV2NSn7fH1p57mjQnoK/ZpCpvOuRvgjlnacYj7lKO3+l8P6ivzNw5mkh
         HekA==
X-Gm-Message-State: ABy/qLZWEI/OMmKXeSYgUd2eP2T8Rr96H2oLMg7inXRXQUhaJ3KZHHoU
        yfKGUSxrbL8o72GVgXr6u2bxo8a+H7QN
X-Google-Smtp-Source: APBJJlHtGvcJEMYqDDCqDrlA6FqIV7ZBvnc2RG3ctaXexB6pNXaY+PGUAOnc1N44cMVGOG5WgF6ZzIYHZzSS
X-Received: from afranji.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:47f1])
 (user=afranji job=sendgmr) by 2002:a63:295a:0:b0:563:5065:9d40 with SMTP id
 bu26-20020a63295a000000b0056350659d40mr129290pgb.5.1691090157410; Thu, 03 Aug
 2023 12:15:57 -0700 (PDT)
Date:   Thu,  3 Aug 2023 19:15:54 +0000
In-Reply-To: <20230718234512.1690985-13-seanjc@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-13-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230803191554.205599-1-afranji@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From:   Ryan Afranji <afranji@google.com>
To:     seanjc@google.com
Cc:     ackerleytng@google.com, akpm@linux-foundation.org,
        anup@brainfault.org, aou@eecs.berkeley.edu,
        chao.p.peng@linux.intel.com, chenhuacai@kernel.org,
        david@redhat.com, isaku.yamahata@gmail.com, jarkko@kernel.org,
        jmorris@namei.org, kirill.shutemov@linux.intel.com,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, liam.merwick@oracle.com,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org,
        linux-security-module@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mail@maciej.szmigiero.name,
        maz@kernel.org, michael.roth@amd.com, mpe@ellerman.id.au,
        oliver.upton@linux.dev, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paul@paul-moore.com, pbonzini@redhat.com,
        qperret@google.com, serge@hallyn.com, tabba@google.com,
        vannapurve@google.com, vbabka@suse.cz, wei.w.wang@intel.com,
        willy@infradead.org, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
> +{
> +	struct folio *folio;
> +
> +	/* TODO: Support huge pages. */
> +	folio = filemap_grab_folio(file->f_mapping, index);
> +	if (!folio)
> +		return NULL;

In Linux 6.4, filemap_grab_folio() may also return an error value.
Instead of just checking for NULL, "IS_ERR_OR_NULL(folio)" will be needed.
