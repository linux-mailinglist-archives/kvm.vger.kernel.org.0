Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6945A2665
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 13:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245545AbiHZLCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 07:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiHZLB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 07:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E0BDCFF0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661511510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jMnbTKtNSpTsqq0eZVxc5+MQ+KePmpUNSlwTet2oL2k=;
        b=bE9OteKOkVFMONTJmbeIcTAi1j1NFwELW2T3b3lZyvJlWfPe4RzqUYTFyQntcb3u5dEk1o
        Y7Jr4sW3Z0LO3A1iYWtSOhn4WvXEJfdSq+yybv6EdfN4n7ziWyVZ0W6bjd2zsjM+IvVXAo
        c+V8P4BvVUFFKLM/9A5PLfZgNKSv5u0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-lGdmfvi1MJ6wPznMg85eMg-1; Fri, 26 Aug 2022 06:58:29 -0400
X-MC-Unique: lGdmfvi1MJ6wPznMg85eMg-1
Received: by mail-ed1-f70.google.com with SMTP id c14-20020a05640227ce00b0043e5df12e2cso902134ede.15
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 03:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=jMnbTKtNSpTsqq0eZVxc5+MQ+KePmpUNSlwTet2oL2k=;
        b=Bnbxi3Gr/KNpDrMg4HX7ct1LYVCGcS0zVV/cKueTFUGyuG8m3SWoOIND+OMFQozQN2
         CLO6DtBNUlHPqfYxNEdgxjCAdn8GBG7wBhXPi4v3AG93Af7CBLBow85fgIWXVDd45OS7
         j3L+YO8cavdBQha+AYlwDT/1vnaWXArSo7fym6sBt3x31rds++cCS8ld6A+eEzAl4KNd
         jSawO3osZPmjENRFkQvF8dwIAndZUEQBvZt+V1UZQQuzap3AiGaLqnKZ6VdTZ4EXL5Ol
         CXZATaD2fsJVaKzS0qPqhqBSGoTxhEynzKA5uB6G/FKBDMrvCXtFwwZwskfbUI9CNGXr
         4vaQ==
X-Gm-Message-State: ACgBeo0YfBEYZa7W9irditS60msiL/SIk9BEZhNCUbueZZsvClUKX5EX
        dMI4kF2NwkjRXHHpSsdqgut2P4+CeaaG7GBGsl5B9tkhJvtrPNYSxb9+4tATzUr7ZOfY9cUG2jm
        2oa5l+eT5j0ei
X-Received: by 2002:a05:6402:5150:b0:447:933d:ec65 with SMTP id n16-20020a056402515000b00447933dec65mr6212669edd.80.1661511508657;
        Fri, 26 Aug 2022 03:58:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4J7blDIUmOh5lFPHJwf/tJLIYkgJgvljjD4T11ziyn6v4vnxonXD5Bpxyrz7ntlO6vhSx/Hw==
X-Received: by 2002:a05:6402:5150:b0:447:933d:ec65 with SMTP id n16-20020a056402515000b00447933dec65mr6212653edd.80.1661511508460;
        Fri, 26 Aug 2022 03:58:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p17-20020a50cd91000000b004479cec6496sm1102859edi.75.2022.08.26.03.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 03:58:27 -0700 (PDT)
Message-ID: <99364855-b4e9-8a69-e1ca-ed09d103e4c8@redhat.com>
Date:   Fri, 26 Aug 2022 12:58:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, peterx@redhat.com, corbet@lwn.net,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
        shuah@kernel.org, seanjc@google.com, drjones@redhat.com,
        dmatlack@google.com, bgardon@google.com, ricarkol@google.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20220819005601.198436-1-gshan@redhat.com>
 <20220819005601.198436-2-gshan@redhat.com> <87lerkwtm5.wl-maz@kernel.org>
 <41fb5a1f-29a9-e6bb-9fab-4c83a2a8fce5@redhat.com>
 <87fshovtu0.wl-maz@kernel.org> <YwTn2r6FLCx9mAU7@google.com>
 <87a67uwve8.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 1/5] KVM: arm64: Enable ring-based dirty memory
 tracking
In-Reply-To: <87a67uwve8.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/22 22:35, Marc Zyngier wrote:
>> Heh, yeah I need to get that out the door. I'll also note that Gavin's
>> changes are still relevant without that series, as we do write unprotect
>> in parallel at PTE granularity after commit f783ef1c0e82 ("KVM: arm64:
>> Add fast path to handle permission relaxation during dirty logging").
>
> Ah, true. Now if only someone could explain how the whole
> producer-consumer thing works without a trace of a barrier, that'd be
> great...

Do you mean this?

void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
{
         struct kvm_dirty_gfn *entry;

         /* It should never get full */
         WARN_ON_ONCE(kvm_dirty_ring_full(ring));

         entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];

         entry->slot = slot;
         entry->offset = offset;
         /*
          * Make sure the data is filled in before we publish this to
          * the userspace program.  There's no paired kernel-side reader.
          */
         smp_wmb();
         kvm_dirty_gfn_set_dirtied(entry);
         ring->dirty_index++;
         trace_kvm_dirty_ring_push(ring, slot, offset);
}

The matching smp_rmb() is in userspace.

Paolo

