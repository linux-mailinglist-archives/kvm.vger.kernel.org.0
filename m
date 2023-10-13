Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A6B7C8BD4
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjJMQzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJMQzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:55:38 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600B4A9
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:55:35 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6b496e1e53bso556966b3a.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697216135; x=1697820935; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SqpC3O39vWA5duvUzqUKP8E1siQNepZhPn4u3Os8+q4=;
        b=RU7X/bN2TE0sR2S0pHwbe+KI1fUlsj4j9qUV5hwQXLYLGibXDJ0Z0J/Q6/a8WfFcCM
         fExWeAqmNIAeDGO8q7GOrxOPd/uO72AUz/SQBP4Gh6ZqPpxzDjLyevO/FVaxfs5atX2U
         lV+MZGKEvs6tkcW+kotZhOh8zvbU8JsTCQrPd8J+7j51MMQAqMn7+yN+Nz/VN0GOKuLk
         lQoxUyg2pIhgGyqHva4FLAo6q4MU+jH3537wG6TheF6PdgYGKN46nE+d8VBMWQzd19yx
         Xx74ONT+lhQYu1d9vyTtP/nzw9HWaXKbFtrtnP3HzLgN1WMXUGgYbRMAZ5pZ78ffTt0o
         54gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697216135; x=1697820935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SqpC3O39vWA5duvUzqUKP8E1siQNepZhPn4u3Os8+q4=;
        b=I8XzEyYe3Pi6Mf1n89lDQ95i6nXthzOsa/nGqeSBizQjkFbm16BvoBnZiIidQ4mWl3
         i2unW1FAthgzBK0gvZI1Z9y2d96+z8CnM8W1bqwvDOtGAbCMBeZ3kGzBYZIHt64W/YT+
         Had0By2EKgPosXLnTC392SRnnLuv90Z1bGq54Vc5X9xbxTyyhMxDgEHj7kpY+5vNLORN
         9iyXsjd9ZsX2qFpmJ6PCHFXDMOda8rnAm3S5AR6x5mJyr1gJ0Vr9qBwnVwxn5Wb568FE
         9itlIH42h28JeH1N9TUOMWND5kJJV/dOoCgFZ9+lDrfKYktqKPKA3bocEBYKjZHH6R9M
         MROA==
X-Gm-Message-State: AOJu0YymB844oM3gjNkpMYeeGmmZPbZ89J8pHksB5/ZaaASZu9LdxjjD
        kbI/drDQ9Q4CrNqHHlqsDHHALGhd80g=
X-Google-Smtp-Source: AGHT+IGj5xI/++tlsxAohTj1c+Qq338n1HPZhLbwf3cqW8PuGxWCGz5IRSyv9cGVcgL/NLV+GP5fOnU9smg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e05:b0:68f:cb69:8e76 with SMTP id
 fc5-20020a056a002e0500b0068fcb698e76mr640155pfb.2.1697216134809; Fri, 13 Oct
 2023 09:55:34 -0700 (PDT)
Date:   Fri, 13 Oct 2023 09:55:33 -0700
In-Reply-To: <7c4b1c78-de74-5fff-7327-0863f403eb7e@redhat.com>
Mime-Version: 1.0
References: <ZSQO4fHaAxDkbGyz@google.com> <20231009200608.GJ800259@ZenIV>
 <ZSRgdgQe3fseEQpf@google.com> <20231009204037.GK800259@ZenIV>
 <ZSRwDItBbsn2IfWl@google.com> <20231010000910.GM800259@ZenIV>
 <ZSSaWPc5wjU9k1Kw@google.com> <20231010003746.GN800259@ZenIV>
 <ZSXeipdJcWZjLx8k@google.com> <7c4b1c78-de74-5fff-7327-0863f403eb7e@redhat.com>
Message-ID: <ZSl2hdfF8XSXss3h@google.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023, Paolo Bonzini wrote:
> Your patch 2 looks good, but perhaps instead of setting the owner we could
> stash the struct module* in a global, and try_get/put it from open and
> release respectively?  That is, .owner keeps the kvm module alive and the
> kvm module keeps kvm-intel/kvm-amd alive.  That would subsume patches 1 and 3.

I don't think that would be a net positive.  We'd have to implement .open() for
several file types just to get a reference to the sub-module.  At that point, the
odds of forgetting to implement .open() are about the same as forgetting to set
.owner when adding a new file type, e.g. guest_memfd.
