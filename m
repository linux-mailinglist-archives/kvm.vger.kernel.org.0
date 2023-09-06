Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB055793665
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 09:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbjIFHiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 03:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjIFHiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 03:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0502FCC
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 00:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693985853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+G7SCEl+RQAMOAXPLnGsTEkk0k/teSfrbOvDIMaHxM=;
        b=BI2nLzildci29SgYpdlqUGYHNjIer3zaeQmbcpQgoE9zovWceVmS0VgCsck0zS0SIkzGAg
        Hjr1MYazP1i6ytRQ9tvbNTxkR3lb7mWT3WLMyJl8hDVJMoHYlOxRC8hBZNchmkYXDKZkXw
        ydm6gxB2rW5v99ukTbTSGggVpn0gYpk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-x7o9iqtLPoqnBUG-PZ4jag-1; Wed, 06 Sep 2023 03:37:32 -0400
X-MC-Unique: x7o9iqtLPoqnBUG-PZ4jag-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31f46ccee0fso245435f8f.1
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 00:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693985850; x=1694590650;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u+G7SCEl+RQAMOAXPLnGsTEkk0k/teSfrbOvDIMaHxM=;
        b=BnKC8+N+nf+zkdCp1STCvBBxLXWjpO8iKWWfaWT7qSCF4E2RfbY2ST68MbFzKOH3WR
         B3QEKrvR4I8e2ximNx0OuhwfycSOl+xUnHWTXXz3g3jMT6yZGI7FnSLzwIHnll9llZjL
         O2Fkf4v373G+rECAXyV1Rdxi4GOsJw3qN+DqKOzC4jdBDl8Da+c5fwBQx8NQO9JoCw1Q
         tc0e0y0xOkAuv74Y9gC4kwEwXEg4MxY7m780CokX5FIhi6vi/bKIBX3wEMtmz4q5l3gE
         nG5y3h4A9JD3l3nFkoEaqgU/SdWsxdSheZsyFECVfT/QOo4eK6OZeEidqxUxfW2ni1Oh
         5ChQ==
X-Gm-Message-State: AOJu0YxLak6I51aiM0NrvPRTr3dRbCwCqzgn3PHtJ497Eh9crn06Cggh
        NzGFNXp+aXHFGWpej580KSGqdCoaEVuDtgRRiGJZmXqFBMB3nFL3IExh3hZq399cWGagjobJd38
        u+vHurNX8v3wp
X-Received: by 2002:a05:6000:3c5:b0:31f:651f:f84d with SMTP id b5-20020a05600003c500b0031f651ff84dmr696717wrg.12.1693985850719;
        Wed, 06 Sep 2023 00:37:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1DSLXnwgNrv0EcncvQZhdHSbHRQqVhH+cXARLZ7z4S+sxICbZle9GKSg+Vg9thxtE+EUG8g==
X-Received: by 2002:a05:6000:3c5:b0:31f:651f:f84d with SMTP id b5-20020a05600003c500b0031f651ff84dmr696701wrg.12.1693985850322;
        Wed, 06 Sep 2023 00:37:30 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70c:6c00:92a4:6f8:ff7e:6853? (p200300cbc70c6c0092a406f8ff7e6853.dip0.t-ipconnect.de. [2003:cb:c70c:6c00:92a4:6f8:ff7e:6853])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d56c3000000b0031762e89f94sm19274463wrw.117.2023.09.06.00.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Sep 2023 00:37:29 -0700 (PDT)
Message-ID: <411a4c35-4f65-c166-0eb0-994b8e39f9c6@redhat.com>
Date:   Wed, 6 Sep 2023 09:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 0/2] KVM: s390: add counters for vsie performance
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230904130140.22006-1-nrb@linux.ibm.com>
 <a41f6fc29032d345b3c2f24e19f32282dd627e5c.camel@linux.ibm.com>
 <169390280362.97137.14761686200997364254@t14-nrb>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <169390280362.97137.14761686200997364254@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.09.23 10:33, Nico Boehr wrote:
> Quoting Niklas Schnelle (2023-09-05 09:53:40)
>> On Mon, 2023-09-04 at 15:01 +0200, Nico Boehr wrote:
>>> v3:
>>> ---
>>> * rename te -> entry (David)
>>> * add counters for gmap reuse and gmap create (David)
>>>
>>> v2:
>>> ---
>>> * also count shadowing of pages (Janosch)
>>> * fix naming of counters (Janosch)
>>> * mention shadowing of multiple levels is counted in each level (Claudio)
>>> * fix inaccuate commit description regarding gmap notifier (Claudio)
>>>
>>> When running a guest-3 via VSIE, guest-1 needs to shadow the page table
>>> structures of guest-2.
>>>
>>> To reflect changes of the guest-2 in the _shadowed_ page table structures,
>>> the _shadowing_ sturctures sometimes need to be rebuilt. Since this is a
>>> costly operation, it should be avoided whenever possible.
>>>
>>> This series adds kvm stat counters to count the number of shadow gmaps
>>> created and a tracepoint whenever something is unshadowed. This is a first
>>> step to try and improve VSIE performance.
>>>
>>> Please note that "KVM: s390: add tracepoint in gmap notifier" has some
>>> checkpatch --strict findings. I did not fix these since the tracepoint
>>> definition would then look completely different from all the other
>>> tracepoints in arch/s390/kvm/trace-s390.h. If you want me to fix that,
>>> please let me know.
>>>
>>> While developing this, a question regarding the stat counters came up:
>>> there's usually no locking involved when the stat counters are incremented.
>>> On s390, GCC accidentally seems to do the right thing(TM) most of the time
>>> by generating a agsi instruction (which should be atomic given proper
>>> alignment). However, it's not guaranteed, so would we rather want to go
>>> with an atomic for the stat counters to avoid losing events? Or do we just
>>> accept the fact that we might loose events sometimes? Is there anything
>>> that speaks against having an atomic in kvm_stat?
>>>
>>
>> FWIW the PCI counters (/sys/kernel/debug/pci/<dev>/statistics) use
>> atomic64_add(). Also, s390's memory model is strong enough that these
>> are actually just normal loads/stores/adds (see
>> arch/s390/include/asm/atomic_ops.h) with the generic atomic64_xx()
>> adding debug instrumentation.
> 
> In KVM I am mostly concerned about the compiler since we just do counter++
> - right now this always seems to result in an agsi instruction, but that's
> of course not guaranteed.

Right, the compiler can do what it wants with that. The question is if 
we care about a slight imprecision, though.

Probably not worth the trouble for something that never happens and is 
only used for debugging purposes.

Using atomics would be cleaner, though.

-- 
Cheers,

David / dhildenb

