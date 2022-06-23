Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC48C558AB7
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiFWV3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiFWV3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:29:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D65D15251E
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 14:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656019757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6PfW9sxpQj/mvhni+b0KRiNmHNGj39/jQBs8n3G3n/E=;
        b=G9n2sKu65HFeFOjYwXX/lVkXa3PO89IcJK+V6wTfLYC52pXy5Vc3NLSKzBTTgdAQjWKZ7j
        9coT5/8chT+dJXQIsvfe1+R20pe40b5aL9YgLsERctTGI0EzhQnaFQyRZpZhl9UjyvkMzd
        P1VtHfnvfkQP8G9ybrjNUhTh+Zhkfxo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-Mj-IYl5gM0irSAZ62dzDeg-1; Thu, 23 Jun 2022 17:29:16 -0400
X-MC-Unique: Mj-IYl5gM0irSAZ62dzDeg-1
Received: by mail-io1-f72.google.com with SMTP id r9-20020a6b8f09000000b0067277113232so326280iod.18
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 14:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6PfW9sxpQj/mvhni+b0KRiNmHNGj39/jQBs8n3G3n/E=;
        b=BpLp2mVRJ0rpDwJgM0ebsqUNJ0qwN95qIAUbSJUlWyDHMaYrEr25zyXQkqfkPDw9wh
         OWxvY/yJsEi/3pNgC7BHX/uMO6eRLm3Gtu8QG8NPiuAqOnxpkpBGHuVEtuxQA8Np3aHW
         RlGRxYJIMP4nzG+91lnYBoV/pjikeRrnaHfph67b/2r6I/v3cANM/XZi7aNtn8AbKRY1
         jyijLKMscpYrOUI6YeFd7mXw1o4G/bSzgvwzqdfDE1P6bc+PwfHpqNJ0NMqY/m6veUFn
         V/gUfzRPnmA9nSzTUcOqRZCQ+PWaDo4dMuBeeDVzMzP9wvnbR49VZVqmloX1v/PpnAhi
         dxXw==
X-Gm-Message-State: AJIora/Jr6XzHEzhC13kKVRlLnY215YhdjNSkR+1g1eelXugQKLHnzBe
        pO0PfNU/QjvQ9F9jWv/YxenxHCnCiTYo+THxrA65UJvKXD/mLAjV+eal1R9Bb/1wuinjvaJOxPd
        MR4JHi9HHukKH
X-Received: by 2002:a05:6602:13c3:b0:672:6e5b:f91d with SMTP id o3-20020a05660213c300b006726e5bf91dmr5280353iov.68.1656019756044;
        Thu, 23 Jun 2022 14:29:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vtJvEhlzlRfOF8b92vaohNpblje8osM0+m8TcPa0obERTPPu0deqheKeigL7E2U8Aqg0jxfg==
X-Received: by 2002:a05:6602:13c3:b0:672:6e5b:f91d with SMTP id o3-20020a05660213c300b006726e5bf91dmr5280339iov.68.1656019755753;
        Thu, 23 Jun 2022 14:29:15 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id h7-20020a0566380f0700b00339cfcf4a49sm202645jas.141.2022.06.23.14.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 14:29:15 -0700 (PDT)
Date:   Thu, 23 Jun 2022 17:29:13 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Message-ID: <YrTbKaRe497n8M0o@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <YrR9i3yHzh5ftOxB@google.com>
 <YrTDBwoddwoY1uSV@xz-m1.local>
 <YrTNGVpT8Cw2yrnr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrTNGVpT8Cw2yrnr@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 08:29:13PM +0000, Sean Christopherson wrote:
> This is what I came up with for splitting @async into a pure input (no_wait) and
> a return value (KVM_PFN_ERR_NEEDS_IO).

The attached patch looks good to me.  It's just that..

[...]

>  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
> -			       bool atomic, bool *async, bool write_fault,
> +			       bool atomic, bool no_wait, bool write_fault,
>  			       bool *writable, hva_t *hva)

.. with this patch on top we'll have 3 booleans already.  With the new one
to add separated as suggested then it'll hit 4.

Let's say one day we'll have that struct, but.. are you sure you think
keeping four booleans around is nicer than having a flag, no matter whether
we'd like to have a struct or not?

  kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
			       bool atomic, bool no_wait, bool write_fault,
                               bool interruptible, bool *writable, hva_t *hva);

What if the booleans goes to 5, 6, or more?

/me starts to wonder what'll be the magic number that we'll start to think
a bitmask flag will be more lovely here. :)

-- 
Peter Xu

