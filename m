Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8D4C69E8
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 12:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiB1LLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 06:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiB1LLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 06:11:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CA0B70854
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 03:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646046561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mk8A/cRIjUQBRWWsNYUbvFqswRRH6zL512hJ5ISpuac=;
        b=g7fHDQjLO4kMnSZTGIJyZPFuVdlFcVDLnGrD/n26W+m+T5iF7omRkpjau+I95UovaZYAW6
        yX9BOewRutl6EwKn27RF+gq/mP16oKcJUZri7pneB25L0jTQTP5t+ayQKV4YNnLbNty+Rd
        OCWpEHXQdjjXqT+L0yUjtqV51KEci1s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-C5_tr8sXPRWx2fIQb9UaDA-1; Mon, 28 Feb 2022 06:09:20 -0500
X-MC-Unique: C5_tr8sXPRWx2fIQb9UaDA-1
Received: by mail-qt1-f200.google.com with SMTP id w15-20020a05622a190f00b002dda0988c11so6089780qtc.1
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 03:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mk8A/cRIjUQBRWWsNYUbvFqswRRH6zL512hJ5ISpuac=;
        b=zz2sPHXJ0d4MBdmJyoj7Ix1CYBa+8R4/gwPyvS5uqbITW+SlpvvrVB6bwMGwG9vGM8
         uLnDnOdg2qG5YXWjgoSAyowSmLXONFLZJbX9DSic40E4b0Urs+iuJ+VxPOsZDSe6neQd
         YDlufSXjwi4jWGskvd264i7c6p6CwvUN8jcgX0itSYYhx9IfuKnFS8SdhCnsxq2YVqS0
         cOQYFosZxYx4iAQm4UVXMuzp0h2HFcFNm53/MqlHQa6Jgk1RbEAT44eAH5gfk4+KoVH3
         tid2lBqejRVeOT8uoozm1TQbRtQc/TaErqwGa5TVz14LallnJTDCYqnAGTqpPgzb/Gii
         zqVw==
X-Gm-Message-State: AOAM533sEfp4MXp59wOur2/NB6jt5JlzenlCIIb3pD0ZlqOnuhbwyn8q
        ALzW1H3CCychfPz+s706jTcFIL89Kzln7iPDf9CKIjO9ei1z6rCu2La513LuVKP5/SBR9wSosDZ
        yqVbXmuOIPjrO
X-Received: by 2002:ac8:590c:0:b0:2de:4c71:354e with SMTP id 12-20020ac8590c000000b002de4c71354emr16194172qty.315.1646046559789;
        Mon, 28 Feb 2022 03:09:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyF44gxifV5SBNXIq21oM3Wnww4M1ERoBoKJLH46fR/MI/Pe/poA+ls11pAGSqMnwJ88bUw7A==
X-Received: by 2002:ac8:590c:0:b0:2de:4c71:354e with SMTP id 12-20020ac8590c000000b002de4c71354emr16194153qty.315.1646046559535;
        Mon, 28 Feb 2022 03:09:19 -0800 (PST)
Received: from fedora (ec2-3-80-233-239.compute-1.amazonaws.com. [3.80.233.239])
        by smtp.gmail.com with ESMTPSA id t22-20020a05622a181600b002dd4f62308dsm6667218qtc.57.2022.02.28.03.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 03:09:18 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/4] KVM: x86: hyper-v: XMM fast hypercalls fixes
In-Reply-To: <YhypT9pGu600wRLf@147dda3edfb6.ant.amazon.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
 <b466b80c-21d1-f298-b4cd-a4b58988f767@redhat.com>
 <871qzrdr6x.fsf@redhat.com>
 <f398b5de-c867-98a4-a716-b18939cfd0ef@redhat.com>
 <YhypT9pGu600wRLf@147dda3edfb6.ant.amazon.com>
Date:   Mon, 28 Feb 2022 12:09:14 +0100
Message-ID: <87sfs3cko5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> On Fri, Feb 25, 2022 at 02:17:04PM +0100, Paolo Bonzini wrote:
>> On 2/25/22 14:13, Vitaly Kuznetsov wrote:
>> > Let's say we have 1 half of XMM0 consumed. Now:
>> > 
>> >   i = 0;
>> >   j = 1;
>> >   if (1)
>> >       sparse_banks[0] = sse128_lo(hc->xmm[0]);
>> > 
>> >   This doesn't look right as we need to get the upper half of XMM0.
>> > 
>> >   I guess it should be reversed,
>> > 
>> >       if (j % 2)
>> >           sparse_banks[i] = sse128_hi(hc->xmm[j / 2]);
>> >       else
>> >           sparse_banks[i] = sse128_lo(hc->xmm[j / 2]);
>
> Maybe I am missing parts of this series.. I dont see this change in any
> of the 4 patches Vitaly sent. Yes, they look swapped to me too.
>

There was a conflict with a patch series from Sean:
https://lore.kernel.org/kvm/20211207220926.718794-1-seanjc@google.com/

and this is a part of the resolution:

commit c0f1eaeb9e628bf86bf50f11cb4a2b671528391e
Merge: 4dfc4ec2b7f5 47d3e5cdfe60
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri Feb 25 06:28:10 2022 -0500

    Merge branch 'kvm-hv-xmm-hypercall-fixes' into HEAD

-- 
Vitaly

