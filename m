Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32AC6743C4
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjASU4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjASUzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:55:40 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6223593D0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:53:55 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso2955909pjf.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2KcT1B8s7M/PNmZVbAhx+44siier/Z0Bi5IFTKZqhSo=;
        b=XAgJvIe5jiyVPT35+zzdOGbh0bAX75igSobjxQPQb3V2VEnDZbbJ4ZSiqmCnTUTORj
         iE3wGITERXtoEphfvXQN1afG7rdUqM6qPyC8k0mWW5OLWp7VxMWogiEmqzAcm4w7KUKP
         9URdCyHqDcmDv7cfQtHYBtj05bTcu6j7G3aeiE2aO8rGE/REg3X55SaIQDec+QXis4xh
         BJpzH3l0PQbAaAfoSnfE8sXJSCdbdRovRCmZnUQa5mdUxHSRgu399zysJZIYVuLcq8xE
         WNviQbgq00pQkJgFzX4ezG5ak7/hMHJ8Nr3WpI5167O+HmqBBz10A4Nrc+T3glWR8iZg
         0jAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2KcT1B8s7M/PNmZVbAhx+44siier/Z0Bi5IFTKZqhSo=;
        b=cOP1ebzgQUknkyK3TIE+pRc21pKeu8zrP1cDwV62sSg9kSwqoINgs45Fa2LY0bkmiW
         jwxjo3TIYEaoVoER8EIlqy+3zZVAAEjXz7cYhQBxL6/rmFMXywh8nK10UvqyD7JOeTMo
         lyP368z+DAObDYn3uSXL5TPOVsJ4ZkTYUeidTT6AFT9VbJOsNBLouksCoK7sVRf0zrsV
         ODzI2b/BJTEmyHj8HaW/Gj9Onmb0+WFXgOAwCVKwwy2MFgofYUgCoeGROwI6CMnP1vhQ
         RFb7TTiOC09kebovjnUdycG+aNEa9Mpom1CIsCmBf5ONcSbQViCOVdbs5cjw/1FnLCam
         RaCg==
X-Gm-Message-State: AFqh2krKBG4hur7JJ7j92VqzVM+2VK76sRcGmZLRf+5skh0NPc37CH8g
        6FSqqu/xd/PW9bhgwiKxJoPppQ==
X-Google-Smtp-Source: AMrXdXsvOKIW9T+xlMXLE2cFVBinBZzTPgRdQQsdFv6UMtL6T21qjfDkZACMu1CYoW/BXimgIfCTFw==
X-Received: by 2002:a17:902:f312:b0:194:d5ff:3ae3 with SMTP id c18-20020a170902f31200b00194d5ff3ae3mr54586ple.2.1674161634760;
        Thu, 19 Jan 2023 12:53:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902768400b001948720f6bdsm9641853pll.98.2023.01.19.12.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:53:54 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:53:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC 1/2] selftests: KVM: Move dirty logging functions to
 memstress.(c|h)
Message-ID: <Y8mt3uv5iF6i/DD1@google.com>
References: <20230119200553.3922206-1-bgardon@google.com>
 <Y8mqd7HUzXDnhXLV@google.com>
 <CANgfPd902Sd+LCd61D8=ba2ZTbJCRu3emLXtE212_8NWW6c3Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd902Sd+LCd61D8=ba2ZTbJCRu3emLXtE212_8NWW6c3Pw@mail.gmail.com>
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

On Thu, Jan 19, 2023, Ben Gardon wrote:
> Woops!

Heh, and top posting too.  Me thinks you had too long of a break ;-)

> I did not mean to tag this RFC. Sorry about that. I will include a cover
> letter in the future and can resend these with one if preferred.

Eh, no need, damage done.  I was just confused.

> On Thu, Jan 19, 2023 at 12:39 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Please provide cover letters for multi-patch series, regardless of how trivial
> > the series is.
> >
> > This series especially needs a cover explaining why it's tagged "RFC".
