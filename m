Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25575EBBB4
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiI0HjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 03:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiI0Hi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 03:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A1B67CB4
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 00:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664264337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GyQ7MTY6w6UVeTjuMMQPlEFUMTLxq0n0wD/7sfCc6UI=;
        b=NgzLBsjLgwxR+nmZkS11j5H8vyb1hHSJT71utmmKksabVcgDjUK44r1SW4S/n49DIiG3pa
        LCEs8zI03Fz5tIZNvDeOnp5T/N9khF/zoGdRWaRgsIZl6wK9TB4CBFd0ZQznkPiWCyvz7i
        8OpBYgozHCTOiHNschQ0MIzWv1+o1g8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-TD4GyJJIOOaqIz5_1QL4Lg-1; Tue, 27 Sep 2022 03:38:53 -0400
X-MC-Unique: TD4GyJJIOOaqIz5_1QL4Lg-1
Received: by mail-qk1-f197.google.com with SMTP id r14-20020a05620a298e00b006be796b6164so6726557qkp.19
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 00:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=GyQ7MTY6w6UVeTjuMMQPlEFUMTLxq0n0wD/7sfCc6UI=;
        b=WfhW0PpFagq1DGcGXKS9YQmS0S//UFyH9+dLwgxnh66IavlI7tTDjxqVH7/mU+zEzU
         tgkokYhlqXoBdfjpuOIjPlj6qT2sraLVuJyjWgD9nnCNpv1FAefu8cz8EzSUOBAfEZxt
         jt4khTYBAo3w+xSMi785yCFFZwz4r3rDXTMS+fbMxM1ebAo6XoE37MoEsNhHz+3HoO0u
         4/dmNqxFL48zFjh5OqsW+K+haBJ/QxFGrhsqsYXSR5ijT4r+itgiqo9cmdJDASgtVYGR
         CJIPDSck1AQ7cvGn73SWNJpXFjnFM+Yl3QfPh0OfiGnHltXwzyUau1lXy63qPR5DdgzZ
         D2Bw==
X-Gm-Message-State: ACrzQf27fPQvE1ADCB4Kbg9aJxzX5v6qPe2vWsiX+MhyHbhUC68j3I/z
        HFKIG+I5jZjdDvlO8dL9aUk7T4FVw30G3gf7F1k81g97Q7oJgwA5sINSKNtZRBge4PzpN6mKyV9
        1Rw6KSagrCv0H
X-Received: by 2002:ae9:e914:0:b0:6cf:68a0:58a3 with SMTP id x20-20020ae9e914000000b006cf68a058a3mr15973847qkf.290.1664264333349;
        Tue, 27 Sep 2022 00:38:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6W/2SNgwjXkD+qSZ8ng7DrYaEd2pctVRaoUmbpDBPnf8EKX6LmR5f6l7Xr1FYaLCqylJNGdg==
X-Received: by 2002:ae9:e914:0:b0:6cf:68a0:58a3 with SMTP id x20-20020ae9e914000000b006cf68a058a3mr15973829qkf.290.1664264333052;
        Tue, 27 Sep 2022 00:38:53 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id v15-20020a05620a0f0f00b006ce7316f361sm519262qkl.118.2022.09.27.00.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 00:38:52 -0700 (PDT)
Message-ID: <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
Date:   Tue, 27 Sep 2022 09:38:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
 <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YzIZhn47brWBfQah@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 26/09/2022 um 23:28 schrieb Sean Christopherson:
> On Mon, Sep 26, 2022, David Hildenbrand wrote:
>> On 23.09.22 15:38, Emanuele Giuseppe Esposito wrote:
>>>
>>>
>>> Am 23/09/2022 um 15:21 schrieb David Hildenbrand:
>>>> On 23.09.22 15:10, Emanuele Giuseppe Esposito wrote:
>>>>>
>>>>>
>>>>> Am 19/09/2022 um 19:30 schrieb David Hildenbrand:
>>>>>> On 19.09.22 09:53, David Hildenbrand wrote:
>>>>>>> On 18.09.22 18:13, Emanuele Giuseppe Esposito wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
>>>>>>>>> On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
>>>>>>>>>> KVM is currently capable of receiving a single memslot update
>>>>>>>>>> through
>>>>>>>>>> the KVM_SET_USER_MEMORY_REGION ioctl.
>>>>>>>>>> The problem arises when we want to atomically perform multiple
>>>>>>>>>> updates,
>>>>>>>>>> so that readers of memslot active list avoid seeing incomplete
>>>>>>>>>> states.
>>>>>>>>>>
>>>>>>>>>> For example, in RHBZ
>>>>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1979276
> 
> ...
> 
>> As Sean said "This is an awful lot of a complexity to take on for something
>> that appears to be solvable in userspace."
> 
> And if the userspace solution is unpalatable for whatever reason, I'd like to
> understand exactly what KVM behavior is problematic for userspace.  E.g. the
> above RHBZ bug should no longer be an issue as the buggy commit has since been
> reverted.

It still is because I can reproduce the bug, as also pointed out in
multiple comments below.

> 
> If the issue is KVM doing something nonsensical on a code fetch to MMIO, then I'd
> much rather fix _that_ bug and improve KVM's user exit ABI to let userspace handle
> the race _if_ userspace chooses not to pause vCPUs.
> 

Also on the BZ they all seem (Paolo included) to agree that the issue is
non-atomic memslots update.

To be more precise, what I did mostly follows what Peter explained in
comment 19 : https://bugzilla.redhat.com/show_bug.cgi?id=1979276#c19

