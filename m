Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8107C4DE6E0
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 08:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242443AbiCSHyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 03:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiCSHyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 03:54:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D47B1D251A
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 00:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647676381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xPJF5XRAPjdkpZjMJBS0Ip6i9Qgqkim9241FNjYIWas=;
        b=MGyk3B2ZS6BMDKeWlBhKA32QnGKMSEUUDOKUD3kIZY8TYCPHfb4JpWuzW4gtzjWQ6/t0GW
        bOaLRhoG09LHcwezSggxL2NfvKOSD86keVyzII913MSZ11ygzbx6XjK33gXZszXv1+5AIu
        JYY9eUIXKzK6f+kTlAhLmK5I61fA7L0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-xvU2h8akPZmtfJdEYYHyrQ-1; Sat, 19 Mar 2022 03:52:59 -0400
X-MC-Unique: xvU2h8akPZmtfJdEYYHyrQ-1
Received: by mail-ed1-f72.google.com with SMTP id u13-20020a50a40d000000b00419028f7f96so3319784edb.21
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 00:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xPJF5XRAPjdkpZjMJBS0Ip6i9Qgqkim9241FNjYIWas=;
        b=qLvADupT997TtXIgqkWtyjBYVCWUJmIqRTG7drmZFJUiAPr+JcuViqwfmKtXyTyRML
         PisbCEsMMw38RJyt5Vawy0wfVnNaNOMEp4LomUu499IByTlDJku0VZHEn384LPbyaaMM
         o5j6YCz1E245TrKxn/WWVT8b9NERL8rd6/NQVW4ghCVjgWwxF+DOrCLOu51ZX7dZekVc
         TnVEYXWT+V/XYqnjyzBlNrjj7I+AyDGeiLPanq77UnrQcCH5amIcbzsAOMpSCnJY9s4O
         kAFC6ftRxKG1DL+mTHydmcaJTbCttyfojB+bU1IOvlrJAMjxdec4PsnqP/h6oImy10Mb
         tNAg==
X-Gm-Message-State: AOAM533eYMxFGtt+7OxNZ9IW8UVQPgV5FPRG48/yGjFi2bdKJVoHwxy6
        tlHRzD0RLQ8ig9JZaFvf7oNoQBy8nrFEYhXqKMnQdQ1hhVpGRqR8BSqFDvK0S9sDSpmBeVs0IIf
        Stmr/c4ycpoXn
X-Received: by 2002:a17:906:b155:b0:6c9:ea2d:3363 with SMTP id bt21-20020a170906b15500b006c9ea2d3363mr11815861ejb.729.1647676378548;
        Sat, 19 Mar 2022 00:52:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsLerQq653iaGVFXDPJvFwJESVYUyDbdqjW7klr24iw2XKDZDIoEB1v/dpcfwGHN+D/AbWaQ==
X-Received: by 2002:a17:906:b155:b0:6c9:ea2d:3363 with SMTP id bt21-20020a170906b15500b006c9ea2d3363mr11815849ejb.729.1647676378256;
        Sat, 19 Mar 2022 00:52:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id ec21-20020a170906b6d500b006d170a3444csm4497225ejb.164.2022.03.19.00.52.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Mar 2022 00:52:57 -0700 (PDT)
Message-ID: <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
Date:   Sat, 19 Mar 2022 08:52:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YjTRyssYQhbxeNHA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/22 19:39, Oliver Upton wrote:
> Hi Paolo,
> 
> On Wed, Mar 16, 2022 at 08:47:59AM +0100, Paolo Bonzini wrote:
>> On 3/16/22 05:53, Oliver Upton wrote:
>>> The VMM has control of both the guest's TSC scale and offset. Extend the
>>> described migration algorithm in the KVM_VCPU_TSC_OFFSET documentation
>>> to cover TSC scaling.
>>>
>>> Reported-by: David Woodhouse<dwmw@amazon.co.uk>
>>> Signed-off-by: Oliver Upton<oupton@google.com>
>>> ---
>>>
>>> Applies to kvm/queue (references KVM_{GET,SET}_TSC_KHZ on a VM fd).
>>
>> A few more things that have to be changed:
>>
>>> 1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_src),
>>>     kvmclock nanoseconds (guest_src), and host CLOCK_REALTIME nanoseconds
>>>     (host_src).
>>>
>>
>> One of two changes:
>>
>> a) Add "Multiply tsc_src by guest_freq / src_freq to obtain scaled_tsc_src",
>> add a new device attribute for the host TSC frequency.
>>
>> b) Add "Multiply tsc_src by src_ratio to obtain scaled_tsc_src", add a new
>> device attribute for the guest_frequency/host_frequency ratio.
>>
>> A third would be scaling the host TSC frequency in KVM_GETCLOCK, but that's
>> confusing IMO.
> 
> Agreed -- I think kvmclock should remain as is.
> 
> A fourth would be to expose the host's TSC frequency outside of KVM
> since we're really in the business of guest features, not host ones :-)
> We already have a patch that does this internally, and its visible in
> some of our open source userspace libraries [1].

Yeah, it was a bit of a cop out on my part but adding it to sysfs would 
be nice.  Please tell me if any of you going to send a patch, or even 
just share it so that I can handle the upstream submission.

Paolo

> 
> That said, I do not have any immediate reservations about adding an
> attribute as the easy way out.
> 
> Ack on the rest of the feedback, I'll touch up the documentation further
> once we figure out TSC frequency exposure.
> 
> [1]: https://github.com/abseil/abseil-cpp/blob/c33f21f86a14216336b87d48e9b552a13985b2bc/absl/base/internal/sysinfo.cc#L311
> 
> --
> Thanks,
> Oliver
> 

