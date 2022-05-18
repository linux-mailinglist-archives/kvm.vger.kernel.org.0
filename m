Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009CE52BE48
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 17:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbiEROSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 10:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238524AbiEROSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 10:18:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45AF38BE1
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:18:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l14so2191405pjk.2
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 07:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T44LQa+tdsY81YlsoTWuqbGpazoxA7x1xvqJtgBP6xE=;
        b=go3PVx9FclHV6pgT6zHtT7zmaO1mJ5PjOJvCAeLu9EiQYLH7kXa76SiCzXbMJ/Pc9I
         v1RFay5+sXS4oFntyH6SyyiME9Gx1fWwRUl911czo4wteRqYWdWIWDdDCYpInHF84P0I
         doTTQRmg2Cc5FpfLx3vjccpDLUB7bbvU5ELOrELtdR0qMRIkvjSQhp4DDvUQ4BDXPCV2
         OiQfZIeYIQxPXwtcgkFWgv89MrtrVWurO5k/0B0v01Rxeq2xdxUxbAPYw6SLjiiUSkay
         aFz+SANF/fmUqPid7YfsErfB/y+Tnndtyf7pikTWOCWmjsFhl7C5dKUK6iYTi1Z9xYNd
         4EQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T44LQa+tdsY81YlsoTWuqbGpazoxA7x1xvqJtgBP6xE=;
        b=Z3VHrYudVApMwGyfYgZaSzCbb6c5EggZGQKFDzUkNXJm59MQlaBK8WDbG6ZscMcRmE
         VEK+SHkPRMifqQQ+h2fXFFZSoKdYMTlKPHLPiSSelzgQQ0r0OYcdGFcuRsMZTItyRxWg
         P3rSzDBSs6mqMz1KcjKmpJllvNwaqsKyZJkL/5kgjE4l+rUa83HBqhZb5gVvgfZwwWA3
         6DGjnM6iRzDLDPCZBPcTjjovsL6HZsRC95vp4JHtrPnZl4ZXF65a6jpQCbI+StIsgnkR
         KP9Y64mH2ddaiwq5RfEGj0UBOqLiAwKdKRbVOrlXwuEHKkueqK0VN+K33wKLRxhsqhhr
         zKYA==
X-Gm-Message-State: AOAM532gglXuXz7xTWjvxVuL5Vt3c1eDNHBQ0rh2Mhg90mjhcIWF4dlh
        APhcTf0hkMeJYUk07drNJ7o01g==
X-Google-Smtp-Source: ABdhPJwQu3SVjNWFT45b9vXM/YfdGGG/pE9YS2sSmuAsLQbMrLbbGupNQ159s6hqz5+JeqOZ84YWMw==
X-Received: by 2002:a17:902:f60e:b0:158:5c4d:d9b0 with SMTP id n14-20020a170902f60e00b001585c4dd9b0mr28068707plg.63.1652883512083;
        Wed, 18 May 2022 07:18:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902d4ca00b0015e8d4eb228sm1774898plg.114.2022.05.18.07.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 07:18:31 -0700 (PDT)
Date:   Wed, 18 May 2022 14:18:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 04/34] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <YoUAM9UtfQlGOZxl@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-5-vkuznets@redhat.com>
 <165aea185dfef1eba9ba0f4fd1c3a95361c41396.camel@redhat.com>
 <877d6juqkw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877d6juqkw.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> > Or if using kfifo, then it can contain plain u64 items, which is even more natural.
> >
> 
> In the next version I switch to fifo and get rid of 'flush_all' entries
> but instead of a boolean I use a 'magic' value of '-1' in GVA. This way
> we don't need to synchronize with the reader and add any special
> handling for the flag.

Isn't -1 theoretically possible?  Or is wrapping not allowed?  E.g. requesting a
flush for address=0xfffffffffffff000, count = 0xfff will yield -1 and doesn't
create any illegal addresses in the process.
