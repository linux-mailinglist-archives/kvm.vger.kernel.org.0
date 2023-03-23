Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F886C6F84
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 18:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCWRmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 13:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCWRlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 13:41:50 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025651C59A
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:41:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54574d6204aso49317257b3.15
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679593306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RR5WKW9I1IvB6+ghzOUZPND9temMEtY4XRSnnGvmpu0=;
        b=dB2oWfZZP0rPsQeDhvLYpOOiJ/HKCBLhNRZzVoYvFnDI6dT2d9UDErVIf69KXcq7dT
         kKp72Dh4kf9YHNZxQ0YP5vbR7C2fY97E0uN7bbgDo84tZCSAGYsk1XKYNWtaK+5Fv+aY
         ww2t7IVLOzQpGXq18WZD99cBbP4SxZRxA8Ama4mELQs18lR6fASufTIbIG4SN6dbx30v
         fOQ4eXYLmtNd16C0cUPtiJT2Y+W1C+yJt4vDIq1JsdKMj2bzBjo+LkUBRdwyQZ9ulO2F
         tCYOaTbuwmw9v95upie1yhqiqUfdbWpAFvu6ZZW9OF2K1v9mXuTmKiYqjLPYuH18MXAD
         V76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RR5WKW9I1IvB6+ghzOUZPND9temMEtY4XRSnnGvmpu0=;
        b=WofdxJPj7vLByNyPRvVnewVB7YeGoO7x78YIDTHik9LtqoIfe9fvvkoo8kUARiU8rN
         YncawfEv2wgTy1MxtOd/M9IhgfttdHsxnV8YcAnRRHENyaEThU8flcXnns26QDUduDqV
         cZkYIrgRFBhL9diy0FIYO0BI3bkacvxjnCOoSM5U/NfiTYokl3THcC7s/eW8r7xggXNX
         aQIOqzFfVWVT04gre+CXzMeQZoPQy36PlzN/CRDzNx4INvzeWql2AosnxcHeM+6JchwK
         lw+ZP5/Y2ZXDwhBEDf+gYwzNWCZYvC7QPh8MZABiuCvoU5+mb8yrtqSQmWvWRwUfpmXB
         D2uA==
X-Gm-Message-State: AAQBX9exS5PxbgXBmYKp7mJiTiFQ/5ak6iy+GeGPs4MAFh0X6EOEbomN
        6fIZHqRst264lkHDsBkhypI9c4wOg1E=
X-Google-Smtp-Source: AKy350b0gds9NaoQI62CJ+Txj57JmnnesdkWjQquGgbx7K36jakN+Y56s/PXmvEfCRmga5f47ZIgHIMDA3E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a8e:b0:b6d:1483:bc0f with SMTP id
 cd14-20020a0569020a8e00b00b6d1483bc0fmr2125380ybb.9.1679593306204; Thu, 23
 Mar 2023 10:41:46 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:41:44 -0700
In-Reply-To: <1ac1507d-ab5d-4001-886a-f7b055fdad39@redhat.com>
Mime-Version: 1.0
References: <20221226075412.61167-1-likexu@tencent.com> <c5da9a9c-b411-5a44-4255-eb49399cf4c0@gmail.com>
 <1ac1507d-ab5d-4001-886a-f7b055fdad39@redhat.com>
Message-ID: <ZByPWH5ayCT25vbN@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] x86/pmu: Add TSX testcase and fix force_emulation_prefix
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Thomas Huth wrote:
> On 14/02/2023 07.47, Like Xu wrote:
> > CC more KUT maintainers, could anyone pick up these two minor x86 tests ?
> 
> Your patches never made it to my inbox - I guess they got stuck in a mail
> filter on the way ... Paolo, Sean, did you get them?

Yeah, I have them.  I'll prep a pull request, there are many KUT x86 patches
floating around that need to get merged.  Will likely take me a few days though.
