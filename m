Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5400950A95A
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 21:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392032AbiDUTlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 15:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392025AbiDUTlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 15:41:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1239F4705B
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650569889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DBgurQd6wP9JubMGZ4g6gUot4E6ajHZvBQ1X3O5wbSE=;
        b=CSfcPPo1Y8cszyVY56WlsmonU1Z26ErwehC9VM6EROO7yZOFCaO9qD5plbJalr1jyoxrH1
        UzibVzltgAUolcv87IYv63M+0IVuj9k01Y7c19cgA2KScSC1yhEOWlReITyS+/Bpb91U6E
        jPt9kB/VnlEKNSkFP0ywLS9KjEJCIr0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-K7MpXDtgMFaD2Oy2HGWDYQ-1; Thu, 21 Apr 2022 15:38:07 -0400
X-MC-Unique: K7MpXDtgMFaD2Oy2HGWDYQ-1
Received: by mail-io1-f72.google.com with SMTP id n9-20020a056602340900b006572c443316so2930307ioz.23
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DBgurQd6wP9JubMGZ4g6gUot4E6ajHZvBQ1X3O5wbSE=;
        b=IUXVY5CrOxrQ+hjdPoJ136hkuaS+1jZQ4C/2bXbIcG7FAMNxlPGtEToXG3Hj5bOzPK
         g1f27vSIqcvCZl7PMv7uXbRzjXL84aDWSDbjkUyAc4pxKIRF9apfmpStyQXEs0h6zo+t
         RYEh38eE8gBOjEiI1KX15QEm3mMBavy/pQEaTiUkwYJZ9Cf/gOeob7oHPddAi8p68Eof
         ItiY+fWbUHqQEEMQEpjhZkFRWBxyTN6sw4UgtsFQyNa3+1U6mKUVB15O2/bWaImlG2Cc
         NpWtpm3bu0ihsxDxZ7IWOtqxuAphQ+4jh9GW/2K6EauTzJLSSyJvxypMLDEjsgW0GtEN
         Wk4Q==
X-Gm-Message-State: AOAM532lFNgWafc8tObj4MyMRLlC0qox7XHBrZ9qCmYJIEL/K0oJ6LqG
        O1FWxu8H/ugWXS96dku5DJ1MWVHzasDRcbV6uJxy7X6AQxzDlyTrIV/hRJNvPWzpY00fuRGoCrb
        gELyuXkJ3yhL6
X-Received: by 2002:a05:6638:1503:b0:326:7da5:243b with SMTP id b3-20020a056638150300b003267da5243bmr566476jat.69.1650569887068;
        Thu, 21 Apr 2022 12:38:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyZKps8B5QReZRJ3kIB/AilzJgiFB90U1CcvZ1PQzcYsgnT4SKiXeFpcS4ftkTo6QDrIUT8Q==
X-Received: by 2002:a05:6638:1503:b0:326:7da5:243b with SMTP id b3-20020a056638150300b003267da5243bmr566473jat.69.1650569886866;
        Thu, 21 Apr 2022 12:38:06 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id r14-20020a92ce8e000000b002cd66e0bbc1sm1186741ilo.33.2022.04.21.12.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 12:38:06 -0700 (PDT)
Date:   Thu, 21 Apr 2022 15:38:05 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Subject: Re: [PATCH 2/2] kvm: selftests: introduce and use more page
 size-related constants
Message-ID: <YmGynbRAdiFPPWl7@xz-m1.local>
References: <20220421162825.1412792-1-pbonzini@redhat.com>
 <20220421162825.1412792-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220421162825.1412792-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 12:28:25PM -0400, Paolo Bonzini wrote:
> Clean up code that was hardcoding masks for various fields,
> now that the masks are included in processor.h.
> 
> For more cleanup, define PAGE_SIZE and PAGE_MASK just like in Linux.
> PAGE_SIZE in particular was defined by several tests.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

