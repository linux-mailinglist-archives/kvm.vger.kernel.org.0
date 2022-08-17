Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814EE5966D7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 03:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbiHQBhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 21:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbiHQBhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 21:37:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496FE956A2
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 18:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660700255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kwxwoIPUtHYvH8cJiGM07yEHhTrcrM/2a4je8bRPTjY=;
        b=Tly2uKe1Ve2Vc5L5t6itYEmtd2oiI4fP87u1YeR6uNow9tZZIX4v4mKsoNpq8UGD4Sbc8G
        OIL0SD/WsEUM+Mqdv2AEyOiuBAw8T6vzK4xPb1890rafaL7EINj2fDG6K8OSnPUNSz0A/B
        wCRK3TkfhK79L+2wFeGI9cDihEaKkVE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-668-wbN5pYM7NGi8azHGvC6s0Q-1; Tue, 16 Aug 2022 21:37:33 -0400
X-MC-Unique: wbN5pYM7NGi8azHGvC6s0Q-1
Received: by mail-qv1-f72.google.com with SMTP id b3-20020a0ce883000000b0047a2ae5b662so5401555qvo.15
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 18:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kwxwoIPUtHYvH8cJiGM07yEHhTrcrM/2a4je8bRPTjY=;
        b=T8b3tP+ZrcQxZo0HkI5IywlbJwPHOVeE7ngy8Sodogd7Mrh1HLaB70yZJTGELqw9Ie
         693lY+Ot7pkT6ZnWmg5AZVpY2Da6BbVAk3AzLm5OKpHZSis5Pj+BTtE/ifM9Hb2ihnQi
         36r6YEcAvq44X8JimJYRIu25ipS6CGhadeS2nKBUmt4Pp/r5cDKNv5c+qb5bXnDJmcxd
         HbVB0C0p/lZcUeSBJgP2qhm5hLUspOjB0NWF7mB2+Pb/GtB8M82VXG6ew93AsS4ewD+u
         ynTiBIl1o49iE/vasWJOaDpUFXjGf+R/qJ9qSr4mZ8ICK71AfAlFWXFFWKG8fNt8lEze
         OqTQ==
X-Gm-Message-State: ACgBeo1rX6eyeGtl+v/49xEP2hvOH1w+AmJdGj0EHP0FVTuxDLCDcIwr
        QBiXsRblFmice7yvIIavzSJq6FQkzuvW3qmiPSUb8NW1IULMrOefVWpAB/wlP6KxJq1ZcpuDxmd
        h9AeI5CEsWIlg
X-Received: by 2002:a05:622a:1107:b0:341:87c3:152b with SMTP id e7-20020a05622a110700b0034187c3152bmr21072705qty.621.1660700253262;
        Tue, 16 Aug 2022 18:37:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR78jn8XTvWMZrpe7oBTKwz8+yxUf3MhZKB3MfbNWTkSmTmr8nu7P26aUvbJWIaTrf78wnLnWg==
X-Received: by 2002:a05:622a:1107:b0:341:87c3:152b with SMTP id e7-20020a05622a110700b0034187c3152bmr21072691qty.621.1660700253065;
        Tue, 16 Aug 2022 18:37:33 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id d135-20020ae9ef8d000000b006bb0f9b89cfsm8310215qkg.87.2022.08.16.18.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 18:37:32 -0700 (PDT)
Date:   Tue, 16 Aug 2022 21:37:31 -0400
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>,
        David Matlack <dmatlack@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v3 0/3] kvm/mm: Allow GUP to respond to non fatal signals
Message-ID: <YvxGW9IujFpTX668@xz-m1.local>
References: <20220817003614.58900-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817003614.58900-1-peterx@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 08:36:11PM -0400, Peter Xu wrote:
> v3:
> - Patch 1
>   - Added r-b for DavidH
>   - Added support for hugetlbfs
> - Patch 2 & 3
>   - Comment fixes [Sean]
>   - Move introduction of "interruptible" parameter into patch 2 [Sean]
>   - Move sigpending handling into kvm_handle_bad_page [Sean]
>   - Renamed kvm_handle_bad_page() to kvm_handle_error_pfn() [Sean, DavidM]
>   - Use kvm_handle_signal_exit() [Sean]
> 
> rfc: https://lore.kernel.org/kvm/20220617014147.7299-1-peterx@redhat.com
> v1:  https://lore.kernel.org/kvm/20220622213656.81546-1-peterx@redhat.com
> v2:  https://lore.kernel.org/kvm/20220721000318.93522-1-peterx@redhat.com

Sorry, forgot to copy DavidM and Mike.

-- 
Peter Xu

