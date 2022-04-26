Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E01E510439
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353327AbiDZQuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353258AbiDZQs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:48:58 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFB631347
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:45:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s137so16531186pgs.5
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MV2rXZYLANBXwWeawR7/zt+GNp0SI8c9yVGczUHqvv4=;
        b=r6w70AWNjkDBjBmqpgOgNvViaDdxusKCzQdUf8+ddzjZNEbVGB8BNzpSpqmLQV9kkX
         t4Ll9moZ9exXPwffqEsab82NSUfL+cfMq0xaxpI6TdOwLRjQIUIGTczdgqYcxMw/8abU
         czt2suDXv5z0FQnG+QMIb1xhXHOowYVpJ2SGzfp0Bnd3YMxW0EhuJVSq6G4jrpl5X7ul
         wns8TD6ndZ0w96ijqoZ4aqUeQSkToYuSQg08AVOqdT0QhcO4Kx+TqT6GClaJY2ZguyRm
         sG1hZ9XqcqU0JjayjIOurnmSOFU8PQ0jGW94nRzP5rMpW1LWYKFxEej2QU9jVPn3EO3G
         rAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MV2rXZYLANBXwWeawR7/zt+GNp0SI8c9yVGczUHqvv4=;
        b=CYL8jGxngJUyk4BMsZ+TIbhx4Zqc8W5lRzLvdD7jkun2lw8ZZjMQghm2/pLdYH5uNk
         h36GZ5r+Ri69UaWPwUO/tfvKyZ0qiwr98nRo0Uu3nRuLS84fZDblTPoA1YiUjXh3DUmQ
         Odwd+PnJc8BVYNqNncGGkh7ZCYLhvQy519IbTaR5XLBX9uatR1yasGyj+hRDfVly9LF4
         wRayb5RQ2Ks50E8FSq4+GLJ+vFH62edXXd2IRkhcquBmOfk/ThS1fYs4kWG2P4ukiw6M
         Xua3YvIAYOIWPOZhgzpsywmeQITissHld6/WG2U5Srgf3OVtph4ljUE9Q+Z4DyP+jJmP
         8fjQ==
X-Gm-Message-State: AOAM5328X3NV++Sn7Csl8nBup0ra+0SNO3K4iDFnoIHDjg8NXCur0oI1
        MgFuSALQz69SI3Onl06t4UzZdg==
X-Google-Smtp-Source: ABdhPJy6h8hmHiUoYJVyLyaGoSTs+QoXckuB7nplL6Nv2HvHXWguabqu4OG0Yk00CbUeHnNbatbU2Q==
X-Received: by 2002:a62:c545:0:b0:50d:2d0f:2e8a with SMTP id j66-20020a62c545000000b0050d2d0f2e8amr16084158pfg.12.1650991507582;
        Tue, 26 Apr 2022 09:45:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090aab0900b001d2bff34228sm3452391pjq.9.2022.04.26.09.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 09:45:07 -0700 (PDT)
Date:   Tue, 26 Apr 2022 16:45:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
Message-ID: <YmghjwgcSZzuH7Rb@google.com>
References: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> [  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
> [  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM

This is my fault.  memremap() can sleep as well.  I'll work on a fix.
