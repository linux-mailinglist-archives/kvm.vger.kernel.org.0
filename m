Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF06F57C596
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiGUH4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 03:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiGUH4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 03:56:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8AABC1F625
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 00:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658390158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JR52ASBNCBrVHKbWP37DJBPzWGapieKRruf6K/rMN8o=;
        b=LZiDSbvvz8gc1nEMOAZfhgr2nnx4I5ORWlErc/rjFRb8TzgMUDGrHXvn4AaxjPDBbMvEWT
        eAUQKTIKCftDJuETBjmPJyEHHGx1MLZ249wZOiXdS3jpmy2fkXQkIeURelA16cR3OekghE
        +0+3jUu9VAvQBZDxsnQHWT97M6cOe8Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-m7dxFzOaN_Gy2H-ocX2DAg-1; Thu, 21 Jul 2022 03:55:57 -0400
X-MC-Unique: m7dxFzOaN_Gy2H-ocX2DAg-1
Received: by mail-wm1-f72.google.com with SMTP id v123-20020a1cac81000000b003a02a3f0beeso2460333wme.3
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 00:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JR52ASBNCBrVHKbWP37DJBPzWGapieKRruf6K/rMN8o=;
        b=02kHmCqbvvVRhy4U1q6GnHeP+mjHq6jpcVLlOEbgjoGGlTwdnmF6ZjM68n+TK8mWum
         TPYHSzilky79t6aTfNQDW1891OMduilghjmLwlvcVD+2bPooGE+Eq/AH+boDiB/Corc7
         sARg3d8wRf8Kt1xNclX3EXoOIlNiKJada585pOm642d66zXbmT6sE37SJgMEectSDar4
         iJtp4zK1L3M5OlI+7lUsVOj6dHdioApaj1f7gTcEULrWhNW/sdOcOc4Yqzrty1dIRB79
         XWDXlQs+NzJwze/KKJOKDoKwFaDcbDv0twJoqI4+bH7NtEy+w5Ec5kGq0ppdGIIzdOqD
         V/zA==
X-Gm-Message-State: AJIora/FHoH2fgOxXo+H56LLbOKFIYsrR9X9ga/YIi2JhDTqy+MaTGly
        /bUMlLUaDkBKd1MOBJsy0w7DwDY006ulbzYH1CFpmT1Mj0n/YmBaUSlAlwT5LgkZC7iye55jWOB
        nENNORGguOZfY
X-Received: by 2002:adf:d1cf:0:b0:21d:a2cd:522d with SMTP id b15-20020adfd1cf000000b0021da2cd522dmr33169531wrd.383.1658390156187;
        Thu, 21 Jul 2022 00:55:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1snlMObRye/utAXAnPcAx+AMxu76AkR/vLHzIosTSZtStjILUc7qkiUYE61rN3+T+Uwyc9EOg==
X-Received: by 2002:adf:d1cf:0:b0:21d:a2cd:522d with SMTP id b15-20020adfd1cf000000b0021da2cd522dmr33169499wrd.383.1658390155583;
        Thu, 21 Jul 2022 00:55:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:e000:25d3:15fa:4c8b:7e8d? (p200300cbc707e00025d315fa4c8b7e8d.dip0.t-ipconnect.de. [2003:cb:c707:e000:25d3:15fa:4c8b:7e8d])
        by smtp.gmail.com with ESMTPSA id r5-20020a1c2b05000000b003a03be171b1sm952885wmr.43.2022.07.21.00.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 00:55:55 -0700 (PDT)
Message-ID: <59ea2abf-deee-0ce7-f14b-d1529eae4ce5@redhat.com>
Date:   Thu, 21 Jul 2022 09:55:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/3] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20220721000318.93522-1-peterx@redhat.com>
 <20220721000318.93522-2-peterx@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220721000318.93522-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.07.22 02:03, Peter Xu wrote:
> We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
> issue with it is that not all GUP paths are able to handle signal delivers
> besides SIGKILL.
> 
> That's not ideal for the GUP users who are actually able to handle these
> cases, like KVM.
> 
> KVM uses GUP extensively on faulting guest pages, during which we've got
> existing infrastructures to retry a page fault at a later time.  Allowing
> the GUP to be interrupted by generic signals can make KVM related threads
> to be more responsive.  For examples:
> 
>   (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
>       e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
>       generated to kick the vcpus out of kernel context immediately,
> 
>   (2) SIGINT: which can be used with interactive hypervisor users to stop a
>       virtual machine with Ctrl-C without any delays/hangs,
> 
>   (3) SIGTRAP: which grants GDB capability even during page faults that are
>       stuck for a long time.
> 
> Normally hypervisor will be able to receive these signals properly, but not
> if we're stuck in a GUP for a long time for whatever reason.  It happens
> easily with a stucked postcopy migration when e.g. a network temp failure
> happens, then some vcpu threads can hang death waiting for the pages.  With
> the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
> enable the ability to trap these signals.
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

