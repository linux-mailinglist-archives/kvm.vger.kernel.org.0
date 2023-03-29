Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F6B6CD6F1
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 11:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjC2Jvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 05:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjC2Jvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 05:51:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE75130
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 02:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680083458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NtBkk6KWmoO6CmyNxnlbjhXGVRjK5Cguqp5kilmaOXs=;
        b=YCv/zT+o9kRK09y7gvemkHtobmQZmjf18iIJ1PpV49eblA7MWvRGdbun+gJw59artuhcEW
        x9Y38Zy8hZ8JoY2wbqmfDjgvXGerdPbKMiVdYXyC9kF892rbCuG4mqDoPgyK0WJKXkl2my
        H86CKxL+KDchWYXO+4AzkPkqSrkD12A=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-GjTetyQTP5-dL-A86l_h3w-1; Wed, 29 Mar 2023 05:50:56 -0400
X-MC-Unique: GjTetyQTP5-dL-A86l_h3w-1
Received: by mail-qt1-f200.google.com with SMTP id l13-20020a05622a174d00b003e4df699997so7755576qtk.20
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 02:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680083456;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NtBkk6KWmoO6CmyNxnlbjhXGVRjK5Cguqp5kilmaOXs=;
        b=kSutolDF8aIU90rWOsRpIYBb5+isPomeW0EX+54I9f1JvJ0xx5I8AAvZJ8Xn8WlOf3
         XuPzYQ76Var0J6H54zdltow5jBTrBUYaAuFiIDZWNqTiIp09P7wITEy+cfAk32MZcD+o
         1kFbLDCmog2RCVghVkHX0YM/vpUwG2ILVonGh1rRrQuJyCOvjDd13bsX7qUDGcVGB66C
         WkFKZDYN4xJvHVyJRYWxUyE6A9S3y2dR2Jr3gF+pCLe9zOWd58pGZlJ93WK7OrK+Lc7N
         c3X01RH6bc5Tx7L1Bdra3XyC+HsJdbLYGxumwaRGhc1G0J+W8CVEVyHoHPSWS/OZt+bK
         SRzg==
X-Gm-Message-State: AAQBX9cCkNNGiw2GBWIXz+rxbdfz93RTvkCSlzPPb0EX398HI6bQP4gX
        ABvNhp4ILQe6aqE1ncVSRd6hD5ZOoJAhbX+I8cd+kLyqUPL15Uo0dStHeLZBR4Os4flytT1jTcX
        0bmYUbPtn0sw0
X-Received: by 2002:a05:6214:234b:b0:535:5492:b427 with SMTP id hu11-20020a056214234b00b005355492b427mr29641669qvb.28.1680083456347;
        Wed, 29 Mar 2023 02:50:56 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z+CabtRe1XajGyxOHiDgDue/tsqMlAclIAx10kh1zbhPNlZC3bKBSkB8/p2FlwAQlBGWZhNA==
X-Received: by 2002:a05:6214:234b:b0:535:5492:b427 with SMTP id hu11-20020a056214234b00b005355492b427mr29641663qvb.28.1680083456130;
        Wed, 29 Mar 2023 02:50:56 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-177-100.web.vodafone.de. [109.43.177.100])
        by smtp.gmail.com with ESMTPSA id ct10-20020a056214178a00b005dd8b9345e0sm4494859qvb.120.2023.03.29.02.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 02:50:55 -0700 (PDT)
Message-ID: <0dcae003-d784-d4e6-93a2-d8cc9a1e3bc1@redhat.com>
Date:   Wed, 29 Mar 2023 11:50:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Cole Robinson <crobinso@redhat.com>,
        Sean Christopherson <seanjc@google.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: The "memory" test is failing in the kvm-unit-tests CI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


  Hi,

I noticed that in recent builds, the "memory" test started failing in the 
kvm-unit-test CI. After doing some experiments, I think it might rather be 
related to the environment than to a recent change in the k-u-t sources.

It used to work fine with commit 2480430a here in January:

  https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3613156199#L2873

Now I've re-run the CI with the same commit 2480430a here and it is failing now:

  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4022074711#L2733

Does anybody have an idea what could be causing this regression? The build 
in January used 7.0.0-12.fc37, the new build used 7.0.0-15.fc37, could that 
be related? Or maybe a different kernel version?

  Thomas

