Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561F450A5EB
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiDUQko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiDUQkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:40:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F3914888F
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650559072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=brgeju7NODhN/2dLIKQ/IUJ0B+QHaX9FBW60LEyuxpw=;
        b=g5HhzwzLkYARRJTuroHs4ILD2WekEzvIBN0rZc0waA3+ia8Vrp4rdqFMp6HlXTKEDd+P3i
        o0c6lqUIW27fbRuHnQteZ7wAYYy8m/mhyP8lOcEmWhG223UKz4Y2gbTJ3xUxnNd2uMqt9j
        n99VdYxmebfrwgriR/5aLyO7Q5h+3hg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-r5CXuQOEPqmJbJHgmx9DwQ-1; Thu, 21 Apr 2022 12:37:50 -0400
X-MC-Unique: r5CXuQOEPqmJbJHgmx9DwQ-1
Received: by mail-wm1-f70.google.com with SMTP id n37-20020a05600c502500b0038fdc1394c6so2531650wmr.6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=brgeju7NODhN/2dLIKQ/IUJ0B+QHaX9FBW60LEyuxpw=;
        b=B0a8a+/PhVnnNi3XNOzOdqu58ucyE8yL5F+w0RIErEtuVJ7MRXqbBNyDyKPART6qLF
         8WgufCAVcNwfRQ2PGOLwTAVQBlu2vbzhQClE6i1zKtU5zaD/ZkQGktrN+Utam8D0gAw1
         zTZyR6iaco3TO3v4aMtMFpCgRH0egt5s8HwBkXUVoA3r/1/vB+VVcef+y3bGdxXbqs1u
         uDDi34Bp3w4IRBrEtCroCJqfKCd1TvKHigQJEqd60OzMJfhKluQQIo8cOvxOLjc+RE37
         HTsLSxUhAeCaqzj8gc9ELQp+5NwEapIWZLaZImGwVn+EoGCQJsxwIau+QMQJLeOjUc+/
         QHWg==
X-Gm-Message-State: AOAM531VnZxXdhF2LNWNvx3V3o/b/r837D9zCrkbOLLCdF+5FKz0J8ch
        YnfXCQ2YQKIO6J9w5xnj/E0RnqMhxshxAY5dM/18jHYaJS9Q8H+xVV5+F5cNMbTtr0A40XsnXxF
        7SRjG0MNsQIO6
X-Received: by 2002:a7b:c384:0:b0:38e:6b47:58c4 with SMTP id s4-20020a7bc384000000b0038e6b4758c4mr9375203wmj.134.1650559069612;
        Thu, 21 Apr 2022 09:37:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvIVdBeolfle0+MQhnrKJDPjFQuSaQU4IprZ5TNOACBXAXD4rsWSDLK/lc/MIeOlpdQg3O+A==
X-Received: by 2002:a7b:c384:0:b0:38e:6b47:58c4 with SMTP id s4-20020a7bc384000000b0038e6b4758c4mr9375186wmj.134.1650559069366;
        Thu, 21 Apr 2022 09:37:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c3-20020a05600c148300b0038ebc8ad740sm2812873wmh.1.2022.04.21.09.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 09:37:48 -0700 (PDT)
Message-ID: <bf1ba747-ee89-35b4-7095-eafa91536b4e@redhat.com>
Date:   Thu, 21 Apr 2022 18:37:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>, Oliver Upton <oupton@google.com>
Cc:     "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <CANgfPd8V5AdH0dEAox2PvKJpqDrqmfJyiwoLpxEGqVfb7EEP9Q@mail.gmail.com>
 <CAOQ_QsieUXOFXLkZ=ya0RUpU8Mv2sd9hmskwEW99tH26cjjX_A@mail.gmail.com>
 <CANgfPd80wTYX92Q9dP7irMdZW+Y0_VNFQ19xJaf5DvndEaa7dw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANgfPd80wTYX92Q9dP7irMdZW+Y0_VNFQ19xJaf5DvndEaa7dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 18:30, Ben Gardon wrote:
> Completely agree. I'm surprised that ARM doesn't have a need for a
> metadata structure associated with each page of the stage 2 paging
> structure, but if you don't need it, that definitely makes things
> simpler.

The uses of struct kvm_mmu_page in the TDP MMU are all relatively new, 
for the work_struct and the roots' reference count.  sp->ptep is only 
used to in a very specific path, kvm_recover_nx_lpages.

I wouldn't be surprised if ARM grows more metadata later, but in fact 
it's not _that_ surprising that it doesn't need it yet!

Paolo

