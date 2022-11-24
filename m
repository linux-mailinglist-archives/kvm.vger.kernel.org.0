Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F69863752D
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 10:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKXJ3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 04:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKXJ3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 04:29:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2AF11DA18
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669282116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nwwFwGwSJbL4GBh4ZmeJhuJEhOaLvLB3qhw7Yb6ctDo=;
        b=fJij3klFe7+qlssCeeKrP6iy4gPJfGkb4zxFIpwpCCRAsU4WmfiS/ql42OkkyA07lJOtYx
        +xOxefxky7WekRHvYwiVuZnWI23HYGz36iAwTdAteOgzzsuhAk3Gjvt746HnESpvf+ExLx
        ixfaVmfAUcBqtoms9nLRS7uFeiJ1IPU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-336-6Or84r7FM32aDNEwrUvxgw-1; Thu, 24 Nov 2022 04:28:35 -0500
X-MC-Unique: 6Or84r7FM32aDNEwrUvxgw-1
Received: by mail-wm1-f72.google.com with SMTP id h9-20020a1c2109000000b003cfd37aec58so701079wmh.1
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 01:28:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nwwFwGwSJbL4GBh4ZmeJhuJEhOaLvLB3qhw7Yb6ctDo=;
        b=1twFFZwOyC0Y0olFaZuBKzXfeMBS5vNEXddQDRWfZaZf53oU27KpyVe/l80mCPAtXf
         NdUeTJ2SPUA1+z0FWU0DmZZCr0vQoNz4I5EIbvyTTtuJIYmbE6BtXcfXk2x03hRVeg94
         dvRZFBtxZtG9upuCr5WvYl96y/pnGNlZHpmlnrSsOD7/Um2vh+djO48EVXwoInhrCNtj
         JFCcBBhEWd3NQZCQq2K79g0w3m2pO58kWzTJpWr1l2npufdoKYdKVMy/AzPXjkZyqyj0
         tcGxYtYsu7h08HkLDinbkCimEASlsSn2METia99z/YJPWcLSkeWBBYtRGfbbRVQ8pnvG
         4Vew==
X-Gm-Message-State: ANoB5pm6X8klTjh00ifV3rOsGRaHTSAKT/I0EFfEm2q7M429L3gG+VU4
        nn9tlh7HvVFSY1br3EM39b/+qIoLVL8c/1mTFSbN0FA6u/GfkIOMzaGv+HmJ29J1mA2QYak05ic
        /RilD2Vp6QNvz
X-Received: by 2002:adf:fe4a:0:b0:241:b408:dfa5 with SMTP id m10-20020adffe4a000000b00241b408dfa5mr19677637wrs.318.1669282114102;
        Thu, 24 Nov 2022 01:28:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4CV/OAvldLnBZHzuq50T9To6rgJTV4hUK8v5ztm32IUm0M6pfVLG05mAi4tX1ac4rCc2JnDw==
X-Received: by 2002:adf:fe4a:0:b0:241:b408:dfa5 with SMTP id m10-20020adffe4a000000b00241b408dfa5mr19677623wrs.318.1669282113850;
        Thu, 24 Nov 2022 01:28:33 -0800 (PST)
Received: from ovpn-192-146.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k17-20020a05600c1c9100b003c6b874a0dfsm1415480wms.14.2022.11.24.01.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 01:28:33 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Subject: Re: [PATCH v2 2/6] KVM: x86: hyper-v: Add extended hypercall
 support in Hyper-v
In-Reply-To: <CAHVum0fZZwsCEL-bMM2phfiukSF0_M_-DiTEhYg562FYSnf6_g@mail.gmail.com>
References: <20221121234026.3037083-1-vipinsh@google.com>
 <20221121234026.3037083-3-vipinsh@google.com>
 <87bkozosvh.fsf@ovpn-194-185.brq.redhat.com>
 <CAHVum0eW4WMHe1vNsWn-2xbMxgckFwu_pOQR7hs0NbFj3sM8Tg@mail.gmail.com>
 <87wn7koik7.fsf@ovpn-192-146.brq.redhat.com>
 <CAHVum0fZZwsCEL-bMM2phfiukSF0_M_-DiTEhYg562FYSnf6_g@mail.gmail.com>
Date:   Thu, 24 Nov 2022 10:28:32 +0100
Message-ID: <87leo0og5b.fsf@ovpn-192-146.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> On Thu, Nov 24, 2022 at 12:36 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Vipin Sharma <vipinsh@google.com> writes:
>>
>> > On Tue, Nov 22, 2022 at 8:29 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> >>
>> >> Vipin Sharma <vipinsh@google.com> writes:
>> >>
>> >> > +/*
>> >> > + * The TLFS carves out 64 possible extended hypercalls, numbered sequentially
>> >> > + * after the base capabilities extended hypercall.
>> >> > + */
>> >> > +#define HV_EXT_CALL_MAX (HV_EXT_CALL_QUERY_CAPABILITIES + 64)
>> >> > +
>> >>
>> >> First, I thought there's an off-by-one here (and should be '63') but
>> >> then I checked with TLFS and figured out that the limit comes from
>> >> HvExtCallQueryCapabilities's response which doesn't include itself
>> >> (0x8001) in the mask, this means it can encode
>> >>
>> >> 0x8002 == bit0
>> >> 0x8003 == bit1
>> >> ..
>> >> 0x8041 == bit63
>> >>
>> >> so indeed, the last one supported is 0x8041 == 0x8001 + 64
>> >>
>> >> maybe it's worth extending the commont on where '64' comes from.
>> >>
>> >
>> > Yeah, I will expand comments.
>> >
>> >> >  static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
>> >> >                               bool vcpu_kick);
>> >> >
>> >> > @@ -2411,6 +2417,9 @@ static bool hv_check_hypercall_access(struct kvm_vcpu_hv *hv_vcpu, u16 code)
>> >> >       case HVCALL_SEND_IPI:
>> >> >               return hv_vcpu->cpuid_cache.enlightenments_eax &
>> >> >                       HV_X64_CLUSTER_IPI_RECOMMENDED;
>> >> > +     case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
>> >> > +             return hv_vcpu->cpuid_cache.features_ebx &
>> >> > +                             HV_ENABLE_EXTENDED_HYPERCALLS;
>> >> >       default:
>> >> >               break;
>> >> >       }
>> >> > @@ -2564,6 +2573,12 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>> >> >               }
>> >> >               goto hypercall_userspace_exit;
>> >> >       }
>> >> > +     case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
>> >> > +             if (unlikely(hc.fast)) {
>> >> > +                     ret = HV_STATUS_INVALID_PARAMETER;
>> >>
>> >> I wasn't able to find any statement in TLFS stating whether extended
>> >> hypercalls can be 'fast', I can imagine e.g. MemoryHeatHintAsync using
>> >> it. Unfortunatelly, our userspace exit will have to be modified to
>> >> handle such stuff. This can stay for the time being I guess..
>> >>
>> >
>> > I agree TLFS doesn't state anything about "fast" extended hypercall
>> > but nothing stops in future for some call to be "fast". I think this
>> > condition should also be handled by userspace as it is handling
>> > everything else.
>> >
>> > I will remove it in the next version of the patch. I don't see any
>> > value in verification here.
>>
>> The problem is that we don't currently pass 'fast' flag to userspace,
>> let alone XMM registers. This means that it won't be able to handle fast
>> hypercalls anyway, I guess it's better to keep your check but add a
>> comment saying that it's an implementation shortcoming and not a TLFS
>> requirement.
>>
>
> I think "fast" flag gets passed to the userspace via:
>   vcpu->run->hyperv.u.hcall.input = hc.param;

True, for some reason I thought it's just the hypercall code but it's
actually the full 64bit thing!

>
> Yeah, XMM registers won't be passed, that will require userspace API change.
> I will keep the check and explain in the comments.
>

Thanks!

>>
>> >
>> >> > +                     break;
>> >> > +             }
>> >> > +             goto hypercall_userspace_exit;
>> >> >       default:
>> >> >               ret = HV_STATUS_INVALID_HYPERCALL_CODE;
>> >> >               break;
>> >> > @@ -2722,6 +2737,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>> >> >
>> >> >                       ent->ebx |= HV_POST_MESSAGES;
>> >> >                       ent->ebx |= HV_SIGNAL_EVENTS;
>> >> > +                     ent->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
>> >> >
>> >> >                       ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
>> >> >                       ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>> >>
>> >> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> >>
>> >> --
>> >> Vitaly
>> >>
>> >
>>
>> --
>> Vitaly
>>
>

-- 
Vitaly

