Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F514648755
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 18:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiLIRJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 12:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiLIRIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 12:08:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D6C18361
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 09:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670605644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hojLz9t3au/qqPytj+gNDvtXE0hfeHRqSZoktJ8ZVLI=;
        b=I2CVxnfSP53Ws99ZJzpUPlpAoJgI03WeRbk6LhZAypv+wa2d+DJ29NnofIK5ubQ8yjpKy1
        VAtS9ZDQ+RcV3QD3pd7QxxS6k1uCVSRUkyUKw2tGCs5KQ0jXqwbD7Ojup7aNgA1xPGA0e6
        w8QrytUp78iupr9pr0qgrhfm+wsgVQE=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-RX1JrfLQNhC9hA7eitQ6rw-1; Fri, 09 Dec 2022 12:07:23 -0500
X-MC-Unique: RX1JrfLQNhC9hA7eitQ6rw-1
Received: by mail-vk1-f199.google.com with SMTP id g20-20020a1f2014000000b003bd84abc0d1so1869916vkg.19
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 09:07:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hojLz9t3au/qqPytj+gNDvtXE0hfeHRqSZoktJ8ZVLI=;
        b=rFk4Tu22xZVbC7v9PY7pIRJ+zsrKzq2PYOi4aqTbA031b0o6dgcl8uEtje20ujd2cP
         BEtnaMINKlSFLrQl8EMkHxJknRl/QPxr9pMwBSbTXrvjUH/Deal+U49axMljaZ0S6aQU
         CimP32g915uMqJA2Ip60LNt5TkrOM8i4BSrPB8K/mTF1yDMllMm0mM4CdU96n7czwSa+
         oqpILC0LpctpcPdjCGscxGo6Hi00UHuw8nZdiG+t8heTANK1cxfEweMkvB4f65yH4hfe
         BUlt/COP9DmII1Ol52RzGL2dJOGt4I1Q7eg565zlZ7XCOovjaeIpizxbcjPuFKQDQ5VH
         EiXQ==
X-Gm-Message-State: ANoB5plWgsNzZLlPtfnTJTer5OjjhbxnTY92PAzT8SKeMV6ngsmT9xgp
        mEAcM/BtO/bJg5cO5mkHaCe5Jk4XAt2AGPAy1UqoJQNRPUFi6czNegxNeMqA/kqD3Sr6FVvkkXr
        O3+B+Rfuk3K2wDDkJdBzZfGmDmWgJ
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id n21-20020a67ee95000000b003aa2354b5d2mr45546854vsp.16.1670605643012;
        Fri, 09 Dec 2022 09:07:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5zz6uhq0KfiH7V7TqkPbJSPeXdssw5wlXfqjy07mP6JlwmbeZfTCfhWp5bmBRLBRYOfMVw/rtjU5EJ/PG8pbE=
X-Received: by 2002:a67:ee95:0:b0:3aa:2354:b5d2 with SMTP id
 n21-20020a67ee95000000b003aa2354b5d2mr45546820vsp.16.1670605642739; Fri, 09
 Dec 2022 09:07:22 -0800 (PST)
MIME-Version: 1.0
References: <20221205155845.233018-1-maz@kernel.org> <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com> <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
 <Y5Nq0a2JxUP+JuP+@google.com>
In-Reply-To: <Y5Nq0a2JxUP+JuP+@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 9 Dec 2022 18:07:06 +0100
Message-ID: <CABgObfbAwaseKFYUSAwowGzP7Hh4bw6QDZrj+76HJ9pzHP3Jtw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 9, 2022 at 6:05 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> Mind dumping what I had in v1 and applying this instead?
>
> https://lore.kernel.org/kvm/20221209015307.1781352-1-oliver.upton@linux.dev/

Ouch, five minutes too late... I can take care of the difference but
it'll have to wait for Monday.

Paolo

