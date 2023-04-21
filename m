Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFDC6EAD9E
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 16:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjDUO7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 10:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbjDUO7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 10:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3B2146FF
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 07:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682089089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7LC096k61C4co5uiqlVvGHf+K8GD+8vxgAbqEN6QsgQ=;
        b=TEljugcNz5hdcoc8EivXz+i1qJzWLH/r73dO9TUUasUeOOUaaANgbURvOmtty99bWD4tAU
        hLLSG//9fnSv1zM69cxdMmw8+WiDA9u8YQyigy5OXpA653QJ7YCDE7EVK1YhueEdUAUERo
        5fVMYNNeFIHC4KDmJGRqAS/zY+Ikymk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-nNhynqggOMCg3TeHsUhOEg-1; Fri, 21 Apr 2023 10:58:08 -0400
X-MC-Unique: nNhynqggOMCg3TeHsUhOEg-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3ef3116d1dcso5180561cf.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 07:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682089087; x=1684681087;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LC096k61C4co5uiqlVvGHf+K8GD+8vxgAbqEN6QsgQ=;
        b=iJ9ZWGyNnXMGwzqqE6jsZQr3xYlO8ZoE2+g4ytXEew2cvfdctnJDR9fSopNyZu1n0s
         g1Mis7nGnd8GQBAyEKWo1UkPmOr0UBwhUNMKy781vleRCi/qGSGSbMV8fEAx9gD/TYOw
         c6O2r89vD2O1mgkKfTNaZ9Ft1eD3fMYUyvWRTOSmMO4ebzgRtKx1c/gdQw66PgjPMY0K
         R/47Mk6RFvFVx05+d9lHtL3B6nBxBgZ9otB5TlVYTAHP3uyZbsTCentTCFx1xJ060sP6
         8mbc9htypf9JOnLEC3FcS2eBzrcXXK6OnvnNP54qg7qirBI703OwAKo8J3nk7Imqmb4z
         /b2g==
X-Gm-Message-State: AAQBX9crp00dKCH9+KlvcM15h9As3nYqiH87e42MbHV4qvV4jvGdZ/MX
        7q9G3xQwHUw9rjRjeX8rgZhOzsjKhOeoh26nrYq0H+uNgvHe+nOt+sSMT4ZtNYkaqTV556w7btC
        zSynJi/dljsNe
X-Received: by 2002:ac8:7d06:0:b0:3ee:5637:29be with SMTP id g6-20020ac87d06000000b003ee563729bemr10128346qtb.5.1682089087584;
        Fri, 21 Apr 2023 07:58:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z+IcubMRrk1IJq5k7fg+CwcAga6nlSsWwbEUJWDqsGTpE2BqXmuDYKV5JvxqtA2eOIr2WmoA==
X-Received: by 2002:ac8:7d06:0:b0:3ee:5637:29be with SMTP id g6-20020ac87d06000000b003ee563729bemr10128329qtb.5.1682089087331;
        Fri, 21 Apr 2023 07:58:07 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id y7-20020ae9f407000000b0074e0e6aae1csm1385221qkl.36.2023.04.21.07.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:58:06 -0700 (PDT)
Date:   Fri, 21 Apr 2023 10:58:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/22] KVM: Annotate -EFAULTs from kvm_vcpu_map()
Message-ID: <ZEKkfa5vitypkRxU@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-10-amoorthy@google.com>
 <ZEGmWrnqI3SBUW7A@x1n>
 <CAF7b7mq-9yOqCRsJ96dm7NMFMLOYw=Q=Q5gMWukpde9ZqQCAEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mq-9yOqCRsJ96dm7NMFMLOYw=Q=Q5gMWukpde9ZqQCAEA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 04:34:39PM -0700, Anish Moorthy wrote:
> On Thu, Apr 20, 2023 at 1:53 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Totally not familiar with nested, just a pure question on whether all the
> > kvm_vcpu_map() callers will be prepared to receive this -EFAULT yet?
> 
> The return values of this function aren't being changed: I'm just
> setting some extra state in the kvm_run_struct in the case where this
> function already returns -EFAULT.

Ah, I was wrongly assuming there'll be more -EFAULTs after you enable the
new memslot flag KVM_MEM_ABSENT_MAPPING_FAULT.  But then when I re-read
your patch below I see that the new flag only affects __kvm_faultin_pfn().

Then I assume that's fine, thanks.

-- 
Peter Xu

