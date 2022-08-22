Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC459C556
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbiHVRtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiHVRtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:49:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F5E10FEE
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661190555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3xSDWxfBjyEfhtAEfTlhLAY/YWALs4HvvQAyUG8PC+M=;
        b=Vy6kMxjn12HdfqgVjpB2VM6yrFRaFN/+7mYvQhRp5rT6Ps0O7IGtwY5DmYvWXuxRur178i
        Vak0ub5n0GXP+VRsm4zl0YmAfqQi2Y9gh8iXcKbAilaS1wWe2hjRwTowG2moB81zmbD+jv
        i04P9IZ6n+WHtxQ4Hzawev+8Ar6y6uo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-bw98Px4IP12h-g5sBo9pKQ-1; Mon, 22 Aug 2022 13:49:14 -0400
X-MC-Unique: bw98Px4IP12h-g5sBo9pKQ-1
Received: by mail-wm1-f69.google.com with SMTP id h133-20020a1c218b000000b003a5fa79008bso2412601wmh.5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=3xSDWxfBjyEfhtAEfTlhLAY/YWALs4HvvQAyUG8PC+M=;
        b=vwA7iuqZ4vCEdOmQSYZz7J0Zl/FVFaZjpSB9A0itxD6X0XWDc87GErZ4ELTDbKXmNF
         zSHHk3Py38ejrIjlq7Hy3ft09IZKSETQMgKyvaPruMfpRE4AVMQ3Es7esdnlqVPZ9r1W
         m8WSEuHn8eYaU+xb0prG1pd4qSajjXNieLvZ8Gf3hqhnJ8vND9fBwKYL/V58cCb1psOx
         093Qq6x6vGQgdSFltBiP0jkkfuwqP8DqIBzuSonDWAthE4ClwPoHH0+IDBF3yBzdJAD9
         oxS30rvaSOB9d6EtXMOOkH60L+C8YuC5Rdabf/l8fCmrPbA9FtEkHkv7H9pQu3aKXdNX
         EVaw==
X-Gm-Message-State: ACgBeo2st7MOXey9fqM0DqVNoxvEfxnMZ2nFMYsP8m5ZQ131x+n5iG72
        xV4Dq+bKglX3JjpWuVXxgWZqqQxs+IpiYeQ/30MIO/j6IX6QhWLsscQFDZfSW6GnabMXCuWJXTN
        uJeCJKK1rrZxv
X-Received: by 2002:a05:6000:15c1:b0:225:332e:2741 with SMTP id y1-20020a05600015c100b00225332e2741mr10757788wry.652.1661190553097;
        Mon, 22 Aug 2022 10:49:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4xFIAVXPnPKasrFFdR+B4EQ5mrWYLX3zcijcSe83qx+KB5dJcqbY6no5xqmrQ94aSSV0WKSA==
X-Received: by 2002:a05:6000:15c1:b0:225:332e:2741 with SMTP id y1-20020a05600015c100b00225332e2741mr10757779wry.652.1661190552895;
        Mon, 22 Aug 2022 10:49:12 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y2-20020a5d6202000000b00224f67bfc95sm12022998wru.62.2022.08.22.10.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:49:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
In-Reply-To: <YwOzxYLMeFuN23W+@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
 <Yv5zn4qTl0aiaQvh@google.com> <87sflssllu.fsf@redhat.com>
 <Yv/CME8B1ueOMY5M@google.com> <87ilmkslzd.fsf@redhat.com>
 <YwOzxYLMeFuN23W+@google.com>
Date:   Mon, 22 Aug 2022 19:49:11 +0200
Message-ID: <875yikxj6w.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > But that also raises the question of whether or not KVM should honor hyperv_enabled
>> > when filtering MSRs.  Same question for nested VM-Enter.  nested_enlightened_vmentry()
>> > will "fail" without an assist page, and the guest can't set the assist page without
>> > hyperv_enabled==true, but nothing prevents the host from stuffing the assist page.
>> 
>> The case sounds more like a misbehaving VMM to me. It would probably be
>> better to fail nested_enlightened_vmentry() immediately on !hyperv_enabled.
>
> Hmm, sort of.  If KVM fails explicitly fails nested VM-Enter, then allowing the
> guest to read the VMX MSRs with the same buggy setup is odd, e.g. nested VMX is
> effectively unsupported at that point since there is nothing the guest can do to
> make nested VM-Enter succeed.  Extending the "fail VM-Enter" behavior would be to
> inject #GP on RDMSR, and at that point KVM is well into "made up architecture"
> behavior.
>
> All in all, I don't think it's worth forcing the issue, even though I do agree that
> the VMM is being weird if it's enabling KVM_CAP_HYPERV_ENLIGHTENED_VMCS but not
> advertising Hyper-V.

I keep thinking about KVM-on-KVM using Hyper-V features like eVMCS, eMSR
bitmap, 'l2' tlb flush,... when I can't sleep at night sometimes :-)

...

>> 
>> Thanks for the thorough review here and don't hesitate to speak up when
>> you think it's too much of a change to do upon queueing)
>
> Heh, this definitely snowballed beyond "fixup on queue".  Let's sort out how to
> address the filtering issue and then decide how to handle v6.
>

Yep, let's keep the snowball rolling! :-)

-- 
Vitaly

