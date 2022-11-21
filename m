Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48388631CBB
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiKUJVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKUJVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:21:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658F331DFC
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669022409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdgJ5y84un0dxE16l6OGDGeAUqGk2IR8t+PQvnMvyk8=;
        b=gXhvzKkWrHVtPcn4XhTavEvPQhw7pqvG2jwAeDZlulDmlrbyf7n0Ica8Gbu3/NvDPQPdpn
        bn7KatW0vp25AVcuCINMZaiASpV+ISuSlx1oF7U4yJOFqGfy7Gqa2zO8Gy7X4Wo62JaMZI
        KRJ/OI0XENHJgmEdi2LU1TRwfaliIO4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-258-HbM35D7VNkq7uOQqRfgmHA-1; Mon, 21 Nov 2022 04:20:07 -0500
X-MC-Unique: HbM35D7VNkq7uOQqRfgmHA-1
Received: by mail-ej1-f70.google.com with SMTP id hr21-20020a1709073f9500b007b29ccd1228so6243821ejc.16
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:20:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdgJ5y84un0dxE16l6OGDGeAUqGk2IR8t+PQvnMvyk8=;
        b=E+lBcY9xkVVsB7ItDxJoH99sqNGNHBcZsWK+OjMvR7ElM8m3wLbJCqE8RZj+vGo4Yr
         XE6XrbSmz6IF+fIEB6UPv3i2RRENRkYqxhZgJToFcDjH9c593FLR75Sd1McHozgLp0Tx
         kspbeNQW1m1xRZ495UqwGGF2QTJPljRA382LPEVAYmMlHU5/4uAd9FTJdZMgHxouitFM
         ODX7OgJpxjo9GexMG6sVYYVm4isgpUf1U+qY+tUjNSeHp1ITOCzMOGLrNrBYCB63D9Kh
         FGp6X9xHWQyf7Lr15r84jEWrjY8T1evnvqPB0KIqlObGKj6ru4ANXJLRAZSU/+2b5rXt
         TidA==
X-Gm-Message-State: ANoB5pl8p7VPEaKcopEnhbOEs5JNjBHSt06DqOjeFQy0XTTCTwjITseR
        VTSbCzntMgEP1eTqSOK/rERiX4TK6d2W62OZnF6tw3ZDo0FnB2RlB5lTqpVsQnDYfJnQGnXN+1T
        hIgkXuTGfYqGY
X-Received: by 2002:a17:906:5db2:b0:7ae:d58b:30f8 with SMTP id n18-20020a1709065db200b007aed58b30f8mr13990195ejv.564.1669022406155;
        Mon, 21 Nov 2022 01:20:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf61iiGXfcqgJKHipQflCYjzAMqWdvWLfMLKk4Usv9Wnz0qvc5vyCuQYyHAHiOaJtDP3HU22rA==
X-Received: by 2002:a17:906:5db2:b0:7ae:d58b:30f8 with SMTP id n18-20020a1709065db200b007aed58b30f8mr13990183ejv.564.1669022405979;
        Mon, 21 Nov 2022 01:20:05 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o11-20020a170906860b00b007ad4a555499sm4776979ejx.204.2022.11.21.01.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 01:20:05 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 00/48] KVM: x86: hyper-v: Fine-grained TLB flush +
 L2 TLB flush features
In-Reply-To: <01da30b6-4716-c346-70d2-9557bf4b09d5@redhat.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
 <Y2E5chB/9pZcRWi6@google.com> <878rkuskoj.fsf@ovpn-194-149.brq.redhat.com>
 <01da30b6-4716-c346-70d2-9557bf4b09d5@redhat.com>
Date:   Mon, 21 Nov 2022 10:20:03 +0100
Message-ID: <87edtwmzp8.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 11/1/22 17:29, Vitaly Kuznetsov wrote:
>>> Applies cleanly to e18d6152ff0f ("Merge tag 'kvm-riscv-6.1-1' of
>>> https://github.com/kvm-riscv/linux  into HEAD") and then rebases to kvm=
/queue without
>>> needing human assistance.
>> The miracle of git =F0=9F=98=84
>
> Some more work was needed to apply these, but that at least forced me to=
=20
> go through them. :)
>
> I'll push them shortly to queue.

The eagle has landed! I'll give it a try to verify that nothing got
broken along the way.

Thanks!

--=20
Vitaly

