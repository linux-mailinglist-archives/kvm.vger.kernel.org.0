Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC56529232
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiEPVG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbiEPVGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:06:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A0F22F017
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652733771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/nt23jM7hIG+N9nsQves2L3gBYUAyKKkaoPRA1W+9F8=;
        b=gjjGQ3CjDCIHS7dBW5ruI1vLfwNb46zP9/Gc9pXzosya65KJazVI21clMfdGUBnnsV34lI
        e6uHC1n+l2Ojx5eW6v0rktV3eZq0cp4h0cpGeQ9JUnjNiQlsZMtqfA6rSjxsx6xaseWca6
        dwCY0F0EzNdidHu9iWnRwm+hyP/T24g=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-5d88X3wpPpihsM-HcbSfoQ-1; Mon, 16 May 2022 16:42:50 -0400
X-MC-Unique: 5d88X3wpPpihsM-HcbSfoQ-1
Received: by mail-il1-f199.google.com with SMTP id i11-20020a056e02152b00b002d115c069efso2101977ilu.22
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/nt23jM7hIG+N9nsQves2L3gBYUAyKKkaoPRA1W+9F8=;
        b=sYD8RtufKtFInwIpKXs8s3+8cGUxf9kzIm8KcZk8JUEP4tEmByVotlIidnEKGlwMwb
         0qHjN928sjWvxxYU0nj90LFED0qOnZwJrTeL9nHrOky7MAEIA/pi5N+z059v0zmgw7+X
         Z+xCl3dfvehI8dW/iORUBxuqjvShEd+7UvIxzBeUVtIbluOv+BWWFE3dp67bPgaiTk3Y
         eGqOMS55Qp9fTuWE2LftRzNFljqAAsE33VcoFcK0CwPJMzxSMauQztocmaC2XstOrQ/0
         L9Etk77eMyfc8PGWhNT8nzWPLe5jKM6N2GeFqoGnrTRVQAkcYd3DI+QXP1Cli2dbx0Zf
         Q1mA==
X-Gm-Message-State: AOAM532bhDMvRw9v2jijVclV/rn23RbUrMlDYThwixTT3IA96I1xuH3e
        6XLQYdu7JSnYnz8sBcI8Br8RATWF78IiqJIc+MQilTOBcM5ktDmwTCZulo1qySB9NAdNi9hdqg/
        DomT+hzApvHSd
X-Received: by 2002:a6b:3e41:0:b0:65a:4456:90b8 with SMTP id l62-20020a6b3e41000000b0065a445690b8mr8504626ioa.57.1652733769456;
        Mon, 16 May 2022 13:42:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwONENcIzaRwDzzrp1/uKIL9ylcrO9HFzhSidTjKtm1kgIEQyogb1DcJb35p6RLZH1A3bhjtw==
X-Received: by 2002:a6b:3e41:0:b0:65a:4456:90b8 with SMTP id l62-20020a6b3e41000000b0065a445690b8mr8504609ioa.57.1652733768845;
        Mon, 16 May 2022 13:42:48 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id c4-20020a92b744000000b002cc20b48163sm112211ilm.3.2022.05.16.13.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:42:48 -0700 (PDT)
Date:   Mon, 16 May 2022 16:42:46 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/9] KVM: selftests: Add a helper to check EPT/VPID
 capabilities
Message-ID: <YoK3RoJjKQmM/a14@xz-m1.local>
References: <20220429183935.1094599-1-dmatlack@google.com>
 <20220429183935.1094599-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183935.1094599-7-dmatlack@google.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 06:39:32PM +0000, David Matlack wrote:
> Create a small helper function to check if a given EPT/VPID capability
> is supported. This will be re-used in a follow-up commit to check for 1G
> page support.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

