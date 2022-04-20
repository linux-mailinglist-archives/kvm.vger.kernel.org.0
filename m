Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94296508D88
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 18:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380696AbiDTQo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 12:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380608AbiDTQoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 12:44:54 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4BE45508;
        Wed, 20 Apr 2022 09:42:07 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i20so3027560wrb.13;
        Wed, 20 Apr 2022 09:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+ou1ou1zV9UaV2Zj7tsZVE0ZuabN20IH6pOGkZC7FGM=;
        b=ZGfOw2Oxxo9b4JYyBgKxTh+/uMVBGNG9Q/dljYIqhRg+IYvE3cvcuoqHhos10MMFFv
         m0qDlPj7ubAXrs86bEDpUSy4oSoLh6QBCsjVoLyb2qW8Njw+2wP5bigWFiCJLP/JoZEY
         UcVMQThCCwzQhzTQAXuVMsfBO4fidkgLNJD+SzYlbNG/z+zMSe4yipazjqENYHhA+pcy
         HFtUJm4ZOB7dX5fH8x8Zqp4G7M9Cj5hJkprZX+8/39swie8RLAn8iiYZV5KgL9GX8seM
         UgjBSq47hSeD0hZ8IKsB+nuv0jW7LfyU969xLNIj7CSnaz0gMQHG3Fk3TX3ZldYMfrDh
         G+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+ou1ou1zV9UaV2Zj7tsZVE0ZuabN20IH6pOGkZC7FGM=;
        b=LkQBp0nLIgxph4fjAVZiY5hn4Qcaoh2vwEz+/RNL8U6EQg5I3rsMlL8Z+dMMBq9N6m
         frLFT6Ab6OeglrybDcrEzezNabbF5TpFe3AbC19j/n7tnz4Ip2DLovSRJbc8XB01nHH/
         ATgaANZRxoveoSUtrqvOsSS8Pc558sq4WY2C6dUbJ6oramDFw7ObiE+04Cvr/tLT595M
         P6quj9uXFB3bweWxeNl8T6YSpkHCJyMD2r6Hbspn6csZvBg75gMEgOxwLR5C8CuE1hpV
         Tq75SNJtXsPq4NAZN4urNvPDjxGYMXySsv9rvokfd7M2y7UNq7muqFgbRoq3zKyOc7Vn
         NPug==
X-Gm-Message-State: AOAM532dvLKuuEStKvNuyjbiwe79yW8U6G+EDGHo0qDT4fwKxTB6AUI9
        N7Hg+p9JCJnwTO01ddEdr0o=
X-Google-Smtp-Source: ABdhPJwddJlv85690FDtb2F9R7/n0XYYswhWBDPE9VCI8YgTgGJzNni/RVAm3/lL0vc+eyZ/zGWwsw==
X-Received: by 2002:adf:e346:0:b0:205:97d0:50db with SMTP id n6-20020adfe346000000b0020597d050dbmr16526628wrj.257.1650472926236;
        Wed, 20 Apr 2022 09:42:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e16-20020a05600c2dd000b0038ed449cbdbsm326460wmh.3.2022.04.20.09.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 09:42:05 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <36ffc0e3-ac2d-be99-002b-916c1e0797b8@redhat.com>
Date:   Wed, 20 Apr 2022 18:42:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH V2 0/2] KVM: SVM: Optimize AVIC incomplete IPI #vmexit
 handling
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220420154954.19305-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/22 17:49, Suravee Suthikulpanit wrote:
> This series introduce a fast-path when handling AVIC incomplete IPI #vmexit
> for AVIC, and introduce a new tracepoint for the slow-path processing.
> 
> Regards,
> Suravee
> 
> Change from v1: (https://lore.kernel.org/lkml/20220414051151.77710-1-suravee.suthikulpanit@amd.com/T/)
>   * Rebased on top of Linux 5.18-rc3
>   * Patch 1/2:
>      - Update commit shortlog to be more meaningful
>      - Refactor to remove x2AVIC related logic for now, which will be included
>        in the x2AVIC patch series.
> 
> Suravee Suthikulpanit (2):
>    KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible
>    KVM: SVM: Introduce trace point for the slow-path of
>      avic_kic_target_vcpus
> 
>   arch/x86/kvm/svm/avic.c | 74 ++++++++++++++++++++++++++++++++++++++---
>   arch/x86/kvm/trace.h    | 20 +++++++++++
>   arch/x86/kvm/x86.c      |  1 +
>   3 files changed, 91 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo
