Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA635FF51D
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 23:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJNVPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 17:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiJNVPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 17:15:07 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8F32DE8
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:15:06 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r18so5341197pgr.12
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 14:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PZCd+YWp6Rkdf8GaAemTwPAfWHSubBGbIoqG74NI1ms=;
        b=cRoXvbDvQMwnmouYRU9bA6BnbMqIjlR+t9dwtgHTh24hpPv7uk3XmVXIJbgw6P8Eg9
         uU3QY2KRaVJK0F92yWi4lVW7keg0Y9Lful81loNULOo4P9SHVXeJSgQyrCaLfy3IHwIO
         Obc5PDktwXnmgO12NR7VgdJPy/2idgNnHwyMniFZgxK7Es52QbzYDil5VIddOwZ9ycLV
         /tsBIK0Z4qWqa44E/uQID8GzRzZNBvLyhcV8n6p+8JmNYRddayZJ+2GJDUnWEp21MPsQ
         FphmiTX70hT3biWGoKJmjEUTUTIpadx1/5gtx6nTy/QFCJcUIglQuje8g1WsugdjDiHx
         c6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZCd+YWp6Rkdf8GaAemTwPAfWHSubBGbIoqG74NI1ms=;
        b=qkt0Ug9IieP3XWeK2QNZxGe7rzsycJlD8Qz9E414CGyEE+EPdSJQh17MtfR+cHlBTP
         DFen5O6uRxKSqk3mqJS/DaW3C2twArQD2TG+TfPaPqxztsiEZRBjOpHBwSIk3aN2r12z
         L7/agEWH6wo5M3H43x2Seb7r9xhbrScL/TeY+fMoXGyd6Cq27tlooYZkS/oMX1/XvRZA
         F7vrPFdNizSpBPBtZRMttGU2GGl9rkFHReGdjPyJg4bYcSFqQENHvEC604hNlqNb3BUB
         CCvn4ke1I0Y6R315eW7uHRp5bVUw3zBeb40y1wGAYWiuukhBLVmYlcX2EjPVmEqNdH17
         QumQ==
X-Gm-Message-State: ACrzQf02Twp/Y39Hzi9oBjsUKeaoGTbdXNZOfdisXGJXiVm3wfl9rC9s
        ZMHOTKHzAbYBcYjt4MTsnJirTA==
X-Google-Smtp-Source: AMsMyM6RmjeHSSzE4pJtJXoG7Eo99Kdim1xVs2z0jB4XgAle1pf8E0nfbUcXkYLxxP7MtTx96ZTsyw==
X-Received: by 2002:aa7:8d17:0:b0:560:485a:e242 with SMTP id j23-20020aa78d17000000b00560485ae242mr7099026pfe.31.1665782106003;
        Fri, 14 Oct 2022 14:15:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090341c200b0017f7bef8cfasm2127464ple.281.2022.10.14.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:15:05 -0700 (PDT)
Date:   Fri, 14 Oct 2022 21:15:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v9 01/14] KVM: selftests: Add a userfaultfd library
Message-ID: <Y0nRVTcWGybRAw+q@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-2-ricarkol@google.com>
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

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> +struct uffd_desc *uffd_setup_demand_paging(int uffd_mode,
> +		useconds_t uffd_delay, void *hva, uint64_t len,
> +		uffd_handler_t handler)

s/uffd_delay/delay, and then this prototype is easier to align.  Keeping the
uffd_ prefix for "mode" makes sense since that might be ambiguous, but like
"handler", I don't see much value in prefixing "delay".

struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
					   void *hva, uint64_t len,
					   uffd_handler_t handler)
