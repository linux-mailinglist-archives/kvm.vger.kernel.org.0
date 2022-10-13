Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9591E5FD5AF
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 09:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJMHnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 03:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiJMHnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 03:43:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761EE12C8A2
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 00:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665646995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXWdlgPiKZdtloajnM9kce+ffCg7auTKtNFzfsnZZt0=;
        b=XYfKQEq9amdBwzIqqjTmSqz6IBmv/xhyWtramVOb/cPwiBb9PmKJ1ZFhFv1Ph13o5/baZy
        Y1SjB31gv+TsHVB1IpLQ8T2KpGFt1g5ZPkeWXXKMeGbYwW8cjy2LmgfdqT7OR7Ci1e12kt
        W1ALFR0fatoQz6rdFBYcggCRTTz2RCs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-593-De2R0kIxPbmMxtuL0Bucmg-1; Thu, 13 Oct 2022 03:43:14 -0400
X-MC-Unique: De2R0kIxPbmMxtuL0Bucmg-1
Received: by mail-wm1-f72.google.com with SMTP id l1-20020a7bc341000000b003bfe1273d6cso473088wmj.4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 00:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SXWdlgPiKZdtloajnM9kce+ffCg7auTKtNFzfsnZZt0=;
        b=vosvBgRqFWrva4q3KUdtNMRGz/llpkCWP5AnvE4s7FzgMVywRDJrQAqTwiotgtiaAw
         cs/VSYhJR8i6jCXL9/Lo14ptsl3BbTKrD6i1PDv4N7s40fsBIytwMMmYh3kHDyUgDtqC
         ntq9W6x7ysj5wPnpuviXD0JbnaMUCG3DR3qHpajkjD440QbSvtHEL46qKD6Y7Pyc5yrM
         VNP6/I+T0pyp8y39opiSx9XyYsSsfesgPyh+T4yDDiXNJjqJCm45KYFATVqXMH3XDsXp
         YI9Acekazwzi47gWvzYk9my4GtfQdskGtCiwOHlzMsQc+JN4LL13zfkjgyNO7nYNIaTB
         Hspg==
X-Gm-Message-State: ACrzQf3ROqcH6BaEa2nN79nMa8L4DtbV5nvYCDRqhGN9PBg9Qg/pv6yp
        dCtp92536SVhya0HFBZo29foNvQipWj3mTFG/eVw8/qW1gRShgSaS272Qf7cwra52qV3D9h0rwL
        aBl7c+OLIq3vr
X-Received: by 2002:a5d:4535:0:b0:232:3648:7771 with SMTP id j21-20020a5d4535000000b0023236487771mr3614231wra.342.1665646993065;
        Thu, 13 Oct 2022 00:43:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7u3l5fwviJkxhnWoyRDVIgzzas3DGCD8aBAIrgJcW2Qz/UfWuNQCeZOp0IQZhhlxWjJcOcaQ==
X-Received: by 2002:a5d:4535:0:b0:232:3648:7771 with SMTP id j21-20020a5d4535000000b0023236487771mr3614216wra.342.1665646992852;
        Thu, 13 Oct 2022 00:43:12 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d6388000000b00228da845d4dsm1324871wru.94.2022.10.13.00.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 00:43:12 -0700 (PDT)
Message-ID: <261aff0b-874e-0644-e0c8-97e0a9bfbe04@redhat.com>
Date:   Thu, 13 Oct 2022 09:43:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
 <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
 <YzYQe2Lc+l2KpLBl@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YzYQe2Lc+l2KpLBl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 29/09/2022 um 23:39 schrieb Sean Christopherson:
> If we really want to provide a better experience for userspace, why not provide
> more primitives to address those specific use cases?  E.g. fix KVM's historic wart
> of disallowing toggling of KVM_MEM_READONLY, and then add one or more ioctls to:
> 
>   - Merge 2+ memory regions that are contiguous in GPA and HVA
>   - Split a memory region into 2+ memory regions
>   - Truncate a memory region
>   - Grow a memory region

I looked again at the code and specifically the use case that triggers
the crash in bugzilla. I *think* (correct me if I am wrong), that the
only operation that QEMU performs right now is "grow/shrink".

So *if* we want to go this way, we could start with a simple grow/shrink
API.

Even though we need to consider that this could bring additional
complexity in QEMU. Currently, DELETE+CREATE (grow/shrink) is not
performed one after the other (in my innocent fantasy I was expecting to
find 2 subsequent ioctls in the code), but in QEMU's
address_space_set_flatview(), which seems to first remove all regions
and then add them when changing flatviews.

address_space_update_topology_pass(as, old_view2, new_view, adding=false);
address_space_update_topology_pass(as, old_view2, new_view, adding=true);

I don't think we can change this, as other listeners also rely on such
ordering, but we can still batch all callback requests like I currently
do and process them in kvm_commit(), figuring there which operation is
which.

In other words, we would have something like:

region_del() --> DELETE memslot X -> add it to the queue of operations
region_del() --> DELETE memslot Y -> add it to the queue of operations
region_add() --> CREATE memslot X (size doubled) -> add it to the queue
of operations
region_add() --> CREATE memslot Y (size halved) -> add it to the queue
of operations
...
commit() --> scan QUEUE and figure what to do -> GROW X (+size), SHRINK
Y (-size) -> issue 2 ioctls, GROW and SHRINK.

> That would probably require more KVM code overall, but each operation would be more
> tightly bounded and thus simpler to define.  And I think more precise APIs would
> provide other benefits, e.g. growing a region wouldn't require first deleting the
> current region, and so could avoid zapping SPTEs and destroying metadata.  Merge,
> split, and truncate would have similar benefits, though they might be more
> difficult to realize in practice.

So essentially grow would not require INVALIDATE. Makes sense, but would
it work also with shrink? I guess so, as the memslot is still present
(but shrinked) right?

Paolo, would you be ok with this smaller API? Probably just starting
with grow and shrink first.

I am not against any of the two approaches:
- my approach has the disadvantage that the list could be arbitrarily
long, and it is difficult to rollback the intermediate changes if
something breaks during the request processing (but could be simplified
by making kvm exit or crash).

- Sean approach could potentially provide more burden to the userspace,
as we need to figure which operation is which. Also from my
understanding split and merge won't be really straightforward to
implement, especially in userspace.

David, any concern from userspace prospective on this "CISC" approach?

Thank you,
Emanuele

