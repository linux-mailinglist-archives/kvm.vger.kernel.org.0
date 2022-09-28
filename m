Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF85EE9C9
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 00:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiI1W6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 18:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiI1W6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 18:58:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129FE1176FB
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:58:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so2893046pjh.3
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=BZ6EQG6wD8sUmqPjitqmyu++W/RGy6iplNgWMvWzXf4=;
        b=m8zYfoNhV+in4y+BB1K0qwova98LPDFEuSyKTkHcvcsG+AZDWkWEZ6S57LiVlgW3Bb
         T4ICo9b5NEuGfEu0UeZNTv791NwRREykFZh6sJ9UKIrwOguS9NUge3VLupvuNTVWZKAo
         OT9jhqycUIVpxw8bPJMHAy7u/wICUvwI0pY4Lm7EkNRlEapWQYtmrpkjvVR56eoLEM/Z
         iiz6GbqZKXxohLx0tybkYILFxHfPzZGq7SKBcsRlpVIUuPWGNu20ZnrA4Rodr9x2mqyM
         ejlnjaK9ELGp4XMvIWSXA+TddvCgULpbgtQAhD6kEUbwo7kGxG+d2ctGGMdU2F3NsiFs
         SFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=BZ6EQG6wD8sUmqPjitqmyu++W/RGy6iplNgWMvWzXf4=;
        b=2Kwi5qqLbu+qqvXHGFnhZYihcabIOP+yRW1zHqPasuyJvwitKFh0lIxmd9KcCdDyj3
         XhvXcX/0vF1zePBz5Yyv26/ff8k/bouW80DCiXs1JtKDfnIrSjW5+BKLWgZv3Da0fTxZ
         NObxv7WDxLzpHMaLUgDVA1596AYYzeoZ61+pLQ+M7msaiOLgAHghxeCUtWr7AxRw6Ata
         lF1ETcd3NtG6LRAa54hOtfKZRoN4BwJ4PiKEBNPtY2kHSYPmaJoKPqXjXp9nxCI6oaxJ
         /QyW1p0FtYXTx2BNOn/iPuqqHxyo3RsjQWlcZBiXIsdcMB0N0wH3MQyrJ7eRYQscRMOK
         y4pA==
X-Gm-Message-State: ACrzQf1R7Oytkr7XalWTaWqaRmTJpibfEsbYRjhW6vnzN4NMJUsn/KqP
        8o1PscYWCfe+Gz4AZ44WaTU/Zw==
X-Google-Smtp-Source: AMsMyM50vr7dDI1WPdLVgFzg3nj8pnYSmxQzT6iGC/3ufmpUBDcKA3S/EHWDofnmi5XyJErO4Dt2rg==
X-Received: by 2002:a17:90b:1b07:b0:203:5860:b441 with SMTP id nu7-20020a17090b1b0700b002035860b441mr12786559pjb.103.1664405880517;
        Wed, 28 Sep 2022 15:58:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g1-20020aa796a1000000b00537eb00850asm4568823pfk.130.2022.09.28.15.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:58:00 -0700 (PDT)
Date:   Wed, 28 Sep 2022 22:57:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: selftests: Skip tests that require EPT when it
 is not available
Message-ID: <YzTRdBI7WmEVdJ6d@google.com>
References: <20220927165209.930904-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927165209.930904-1-dmatlack@google.com>
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

On Tue, Sep 27, 2022, David Matlack wrote:
> Skip selftests that require EPT support in the VM when it is not
> available. For example, if running on a machine where kvm_intel.ept=N
> since KVM does not offer EPT support to guests if EPT is not supported
> on the host.
> 
> Specifically, this commit causes vmx_dirty_log_test and
> dirty_log_perf_test -n to be skipped instead of failing on hosts where
> kvm_intel.ept=N.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Need to sync with Paolo on who is grabbing what.  In case it's Paolo...

Reviewed-by: Sean Christopherson <seanjc@google.com>
