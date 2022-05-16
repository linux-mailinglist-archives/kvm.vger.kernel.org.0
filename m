Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8C529214
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348367AbiEPVAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348749AbiEPVAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:00:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E2C55A16C
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652733280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6VxMvV7pokieRIb4BsoktuwX4VbN5vt6q5T20nx738Q=;
        b=NERlvu09f5GADVhRPqSn6cijqSQ+guta1GZJy4Ui2zhg6n73TCFZqWs//F/peuH6/5Jz9R
        Ta+8Rp7cADejFuBoa3+r6vf4PX8DG20gBazxlDWGa3rt97P9mugJZHSrbx5TO00RXMDIau
        FeuAED+RFnOLRMlWnXCV8rSbIIxlDbA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-dXLTWr11MTitbw00DbLPKw-1; Mon, 16 May 2022 16:34:39 -0400
X-MC-Unique: dXLTWr11MTitbw00DbLPKw-1
Received: by mail-il1-f199.google.com with SMTP id i5-20020a056e021d0500b002d12faa49edso1131736ila.9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6VxMvV7pokieRIb4BsoktuwX4VbN5vt6q5T20nx738Q=;
        b=ut6tBupFLF8/u1/4ULm9pBSl7kARbUm6pOSCchIa5TPXJV3mlY16ejn5IivV+OSTtK
         ALs4FCkdAyUjt7rLjz3/sJ4VJripKRP6X+iMl8bp5fWWWCqS2fomRKn3m9vw8AhIunmp
         vojLvXZrCr/4oQTzSFmQp7iyfuEYnx5LFta1+eoG4v+V8bYxdgAll0fFFBhgkCl46oVz
         tD/aoB5QSH1F5dHEMqzRFlZzjnlQtlR+id6G05Q58S6OxrGCNxK9925CtDoWbCEhaUrL
         TtjxOPFiTivamQXNSU9Ds9sS4cIc1SRSd89PuF04tP6aA9w23476rxVITEdvYLx0VGYV
         kepw==
X-Gm-Message-State: AOAM530RZJzuZYKzPBljt7Zi06Gcnq9npx4qQjiZ13eb2i46GhMG8OSf
        aHL3jCmMlCtNWlINnxBW1AvZvT6/3JH/Z/XAeVIhoWKomM/DWEjOjUjQb/ezabp1t+ce3M29f4l
        5Ej1BjGnTlpqr
X-Received: by 2002:a05:6e02:1986:b0:2cf:908d:3d0a with SMTP id g6-20020a056e02198600b002cf908d3d0amr10059327ilf.113.1652733278383;
        Mon, 16 May 2022 13:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5h9Z5dlUj/72GZAx3THbpnqu8ZH9DMeYqA54QDcJFQ6t0QCyMkA1/mVfiO/RqSr8AtzNAoA==
X-Received: by 2002:a05:6e02:1986:b0:2cf:908d:3d0a with SMTP id g6-20020a056e02198600b002cf908d3d0amr10059319ilf.113.1652733278166;
        Mon, 16 May 2022 13:34:38 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id e34-20020a022122000000b0032b3a78175bsm3038426jaa.31.2022.05.16.13.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:34:37 -0700 (PDT)
Date:   Mon, 16 May 2022 16:34:36 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/9] KVM: selftests: Refactor nested_map() to specify
 target level
Message-ID: <YoK1XDpp+WTG69Br@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-5-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:30PM +0000, David Matlack wrote:
> Refactor nested_map() to specify that it explicityl wants 4K mappings
> (the existing behavior) and push the implementation down into
> __nested_map(), which can be used in subsequent commits to create huge
> page mappings.
> 
> No function change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

