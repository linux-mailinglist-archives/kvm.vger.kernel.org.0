Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5CB4D8DAE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 21:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbiCNUDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244829AbiCNUDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:03:14 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B70F3EA8E
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:02:03 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id r11so19667903ioh.10
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 13:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uWhSAiXtN2kud9zOcgRUJbOu6RBWnBBMw3VH5eaYAVk=;
        b=Z5wn1jQkI/tL2La22TjtqzWpSST81fZ9JcfOvXLTViP7hWAWBun1uo/L60hUZ9iA+W
         ni8c1XupVrx+ACPqZTP9bZzCN55x9A10H4PAwRVU8kMoHC84aaHcwfimlpYyD7ZfeBoY
         yZv/RuGavd53xyvNtorLgojnnZaQyWj2bc72UBvtfwe/6i9ljb5FBMkXn1vJzOVZ3974
         Zcrao9MJ597SPt/7ht67phLP+6X+0u150bJLMC7SEEHFZIWfYGMKY4fEeDtl9z2wiuot
         bf9zjyK+9hn3/IwDvngTcmKxVaONIFKuREe/M3XMiaZXrL258a836JAUj9Mmc9wsrOTL
         qCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uWhSAiXtN2kud9zOcgRUJbOu6RBWnBBMw3VH5eaYAVk=;
        b=SGfKk0aPWUrD2VB8P23G4W1hqQngHkvs+ubJI9lNXoFl4WgVjOEApzmTGqtxLneuiD
         qb3m5Z0yh82o9R8+PNLdmr3yjEvWGjwV8LbjQ7Xmc+TuZdNKVUxBXyb53ckiheTMSlV4
         +nv61+hkJKN0sDSp+0RcJCjXJenF6cflKKksJQFQISeUTPILZ5oYtYzIWu9n+6O3DPXn
         +UWJirRpLDMZsPHc0/DieMIvrvprmbr/hUHuoE8VXoqqJ/ED9sQ5EAiZiWiOrpW3huxG
         Y9DRI4wah6YKqueDchxRDbXVJ0G0FjXVVZIrHP5aACI6N69ct+vZGrW5QzyzfVSr+8Py
         //Eg==
X-Gm-Message-State: AOAM530lLkcbLf8xX6mn+EPBRHkhIGnFqV+5Zkz3sLeKUrRqDTUx0Jo6
        HlbVo/PgCqBpTHsvDrn+BBg2sA==
X-Google-Smtp-Source: ABdhPJx5zEqKVyMxJ+r6McoYCQD64sld7d8x7eq7OhmRF56lD4EEnSDeeaZi8lEf/y3UDHbyHhJz9w==
X-Received: by 2002:a5d:8d1a:0:b0:633:283d:8959 with SMTP id p26-20020a5d8d1a000000b00633283d8959mr19911675ioj.80.1647288122399;
        Mon, 14 Mar 2022 13:02:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f1-20020a056e020b4100b002c68e176293sm8273190ilu.87.2022.03.14.13.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:02:01 -0700 (PDT)
Date:   Mon, 14 Mar 2022 20:01:58 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 09/13] Docs: KVM: Rename psci.rst to hypercalls.rst
Message-ID: <Yi+fNr9w28Nz2j3G@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-10-rananta@google.com>
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

On Thu, Feb 24, 2022 at 05:25:55PM +0000, Raghavendra Rao Ananta wrote:
> Since the doc now covers more of general hypercalls'
> details, rather than just PSCI, rename the file to a
> more appropriate name- hypercalls.rst.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

You should move the file before adding to it IMO (switch this patch with
the previous one).

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)
> 
> diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> similarity index 100%
> rename from Documentation/virt/kvm/arm/psci.rst
> rename to Documentation/virt/kvm/arm/hypercalls.rst
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
