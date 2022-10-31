Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21861326F
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 10:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJaJTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 05:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiJaJTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 05:19:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE40AE58
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 02:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667207912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wEf8cRb4TLYPYASggaPulamyqh6fRxomZhqUsJe70lA=;
        b=VPVVfq+W1vljk2rJ0G4btBT9+XWT1U3DxP7CTJRBVBugp3LxzanpHYcY+fyj+k4qEGpsr0
        C/kmbdnuvT3YfH5mX6xY7vdgf2+1EIZPmiTqm9kA7WOzaQNlZj2PHwH/AphxOZZbtwiHLC
        5RPaHT8Htl8IQ7rafuGJqWqnXHiAi6w=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-536-qd4vPACCOp2nSCkrxM_25Q-1; Mon, 31 Oct 2022 05:18:24 -0400
X-MC-Unique: qd4vPACCOp2nSCkrxM_25Q-1
Received: by mail-qv1-f70.google.com with SMTP id h1-20020a0ceda1000000b004b899df67a4so5425396qvr.1
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 02:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wEf8cRb4TLYPYASggaPulamyqh6fRxomZhqUsJe70lA=;
        b=70NgypN+3kC01JWJ4i413Urbv8WkJ0r47OOjS1xzJh9kEXq2XL0tqkVpw9sENSRQxU
         4BWF6wr4zeYtKZNE3kjRF+oViqcFBbQ6cetVbNOiW/wHWEYFmReQTZl4xBfNvZ9XKALy
         ALofEX6yy1coTGiPDCCwY27LuKKtS0veWCw6r6+7W1lEizLcnf2fNdbMvPp9uCclbRSY
         hO93fgmx6Pb7KSlf9S0mzjzwi1+hBriwVLVesJcixFxIGWJHqL5jgHhUH2LzmRtWo0eM
         UFltvhBjLIcTrSBDazeKr+N5AcTB2EtdkCJ+759VFjBrCtxpVDoJUrgjfXPX5MqYUVbu
         lgIw==
X-Gm-Message-State: ACrzQf0p6NqI+vWoFsSzsCNH5x/HTMp3t69wKEPLamsHOgvPjag9w9mZ
        9zeseEeuBXehDPxPytyDkAeYAbVH0hxlGX+GtBBcz1jEgs0o9bKbNop9aS525Cvzddlfie9obsH
        VIJy1H7GnaJ3d
X-Received: by 2002:a05:620a:199f:b0:6ee:bbd2:4c50 with SMTP id bm31-20020a05620a199f00b006eebbd24c50mr8364035qkb.500.1667207903664;
        Mon, 31 Oct 2022 02:18:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4olZT6py2Dkvc62FgswOCrOLSA+9D1FbQFn4jFwUP7lTvfqZXuIVpxdtJRuQF/qYD1vFf9DA==
X-Received: by 2002:a05:620a:199f:b0:6ee:bbd2:4c50 with SMTP id bm31-20020a05620a199f00b006eebbd24c50mr8364026qkb.500.1667207903435;
        Mon, 31 Oct 2022 02:18:23 -0700 (PDT)
Received: from ovpn-194-149.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g1-20020a05620a40c100b006cebda00630sm603594qko.60.2022.10.31.02.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 02:18:22 -0700 (PDT)
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
Subject: Re: [PATCH v12 00/46] KVM: x86: hyper-v: Fine-grained TLB flush +
 L2 TLB flush features
In-Reply-To: <Y1m1Jnpw5betG8CG@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <Y1m0ef+LdcAW0Bzh@google.com> <Y1m1Jnpw5betG8CG@google.com>
Date:   Mon, 31 Oct 2022 10:18:19 +0100
Message-ID: <87zgdcs65g.fsf@ovpn-194-149.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Oct 26, 2022, Sean Christopherson wrote:
>> On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
>> >   KVM: selftests: evmcs_test: Introduce L2 TLB flush test
>> >   KVM: selftests: hyperv_svm_test: Introduce L2 TLB flush test
>> 
>> Except for these two (patches 44 and 45),
>> 
>> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks! I'll take a look at 44/45 shortly.

>
> Actually, easiest thing is probably for Paolo to queue everything through 43
> (with a comment in patch 13 about the GPA translation), and then you can send a
> new version containing only the stragglers.

Paolo,

do you want to follow this path or do you expect the full 'v13' from me? 

-- 
Vitaly

