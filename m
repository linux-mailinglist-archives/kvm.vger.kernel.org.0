Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E871353B789
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 12:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiFBKxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 06:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiFBKxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 06:53:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50812131F3F
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 03:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654167193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OjqpVh3lm31oZf7mBPFt7qggokjq9T2QJT/DfHShU/g=;
        b=NzYVs4bd8eXHoHVoTvIl4DY7rHXmuIR2b0EpzasWJk8Y+CBwcKBvmCLWsbF6mq3ldtJX4F
        N34PadggZDQgNxT8xNLR4f2ELV/uTB0wCAz8ceoqDTC16yGUTqy3iitAMqYKP0zEZs95AO
        9yTxPbLXLsJB1LsI5TpkxUElOOhs6u8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-9K-qKx8CPvO8HMjQGt-pBA-1; Thu, 02 Jun 2022 06:53:10 -0400
X-MC-Unique: 9K-qKx8CPvO8HMjQGt-pBA-1
Received: by mail-wm1-f72.google.com with SMTP id c125-20020a1c3583000000b003978decffedso4964730wma.5
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 03:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OjqpVh3lm31oZf7mBPFt7qggokjq9T2QJT/DfHShU/g=;
        b=4Vgbr9BaPKWhrkrkus19365HPo6bLJoQsOgiYiNRqJeJfos3kfwMujgJSZ6/3cARmQ
         2pjaprJap4dtioZnQsIs3ZF7V/oBteHa4Xs0gKsY7KX8ZZDdFScyRqB491jyYlK6lNmx
         750sBvEgv1c6p6NXB11/o3Cx5MKh6yyy3EXg4P+rS3D4zjbS8MkE/j7oq4nTvVqIg5MQ
         3yE1DWqgVchkZ42RXMEwDFyUOAJpzoycEnLIybePr6o8imV4/iNeDOXkXK5viO2mSOPs
         3pZu0/ar2qcQPkC8dxfFBRONf+GldEwzzIpo+YpjkwQzJ8pqP54+/EdkQdEDpL0Ckor4
         /EIg==
X-Gm-Message-State: AOAM531G1iRffcVIv5k9AcWhvrlkFygeQyNN6zG1sqDEdsHh5xb+CTB1
        qYJrqsMs6RtlY0x8YxIF7mRb9dgKASAqIvhR8t+6OZq7c07/Q8vujh4/ISGJRprRD09LFskN9eM
        Dyxb0MzgNxufk
X-Received: by 2002:adf:d1af:0:b0:210:2a6d:ca99 with SMTP id w15-20020adfd1af000000b002102a6dca99mr2992266wrc.575.1654167189252;
        Thu, 02 Jun 2022 03:53:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJze4agD0gjR/EYbwlzEYeVnsLJPtYcAMPst1XT87KADdbndqzjNCPT6CthG1+MXYuXTj121qA==
X-Received: by 2002:adf:d1af:0:b0:210:2a6d:ca99 with SMTP id w15-20020adfd1af000000b002102a6dca99mr2992250wrc.575.1654167189015;
        Thu, 02 Jun 2022 03:53:09 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-179-51.web.vodafone.de. [109.43.179.51])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c290600b00397470a8226sm4673725wmd.15.2022.06.02.03.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 03:53:08 -0700 (PDT)
Message-ID: <c34ea319-2493-724d-460c-490881ac34b6@redhat.com>
Date:   Thu, 2 Jun 2022 12:53:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 0/2] kvm-unit-tests: Build changes to support illumos.
Content-Language: en-US
To:     Dan Cross <cross@oxidecomputer.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
 <20220601215749.30223-1-cross@oxidecomputer.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220601215749.30223-1-cross@oxidecomputer.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/06/2022 23.57, Dan Cross wrote:
> We have begun using kvm-unit-tests to test Bhyve under
> illumos.  We started by cross-compiling the tests on Linux
> and transfering the binary artifacts to illumos machines,
> but it proved more convenient to build them directly on
> illumos.
> 
> This patch series modifies the build infrastructure to allow
> building on illumos; the changes were minimal.  I have also
> tested these changes on Linux to ensure no regressions.

Thanks, this version survived the CI, so I've applied it now.

  Thomas


