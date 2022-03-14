Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25624D8559
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 13:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbiCNMtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 08:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242173AbiCNMsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 08:48:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D714438D98
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 05:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647261807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eudqKm2Y3v7ew9A9Kj5EXaC5PmAFpLSNV7O0yJqcVgU=;
        b=hX10doDIVDZusQnNh7VFowJXiskFHG8UZRlAsD47QncF2cARIVNQsJ6QNn5pumRk70jkT+
        e3S1ro5+jdVyKB9gRzWjn3jI3xMn8QNajuSI+6Jy4A86OEB6YAVCFl7qe/x/k0jCro22tW
        WDUKeBxK6XPeymM217kwdr3L3Rd5ZzA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-poxfUCT3P-GBzV_rSSzsyg-1; Mon, 14 Mar 2022 08:36:37 -0400
X-MC-Unique: poxfUCT3P-GBzV_rSSzsyg-1
Received: by mail-wr1-f72.google.com with SMTP id h11-20020a5d430b000000b001f01a35a86fso4298544wrq.4
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 05:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eudqKm2Y3v7ew9A9Kj5EXaC5PmAFpLSNV7O0yJqcVgU=;
        b=3LjJ4FDG0KodpivyTIroyx+F9/BeaK+I52SWCvUgQ3ypW9JHOIYuqBAkvmW1CYb/ud
         PZhkOzoCQzyjc1PIgN4tt3M3EAI7MNph6jLcXacu/eM8rJm7ZuoLl2ZWJmmblE9Oy8py
         g3gsLFVP2NcRgRx688s701CvD7Xl+YGDVeb8O6Og8G6c20G1/oblV5jrBnJSSGOH0730
         J8LmwZmckHnkilxpjJQxnLzV9zQkym6KMFWqXZaH+SRt63KwLVhZ0SXMy64fK90EkG2p
         Xc8LGoM41wfUhsCJfzp93jyiYe0gMj2WBYeBmW+K5F/UqIOJLytzjUk6juRFNN+E6YkP
         DLjw==
X-Gm-Message-State: AOAM532JvCzxTw6ejhcjP68/59sJytZm1wY5yF8Tsn85Jw9G0wITKT9P
        lGLMOz5p1RATCAWSBBPKOrcFi1eobqaOUEdgApi0zGo6WJbsoNmpWH/fzwdNNaYTK+TTZI5VObb
        ygkWLo1Z8s9TR
X-Received: by 2002:a7b:c922:0:b0:383:e7e2:4a1a with SMTP id h2-20020a7bc922000000b00383e7e24a1amr17333936wml.51.1647261396659;
        Mon, 14 Mar 2022 05:36:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3s9jCPtybq2regT3D5KjzyZFBWX/SRJSkBKui5JV8DKw/fbF4fnMqLfFLWMHS7YPNfozrOw==
X-Received: by 2002:a7b:c922:0:b0:383:e7e2:4a1a with SMTP id h2-20020a7bc922000000b00383e7e24a1amr17333925wml.51.1647261396481;
        Mon, 14 Mar 2022 05:36:36 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id u14-20020adfed4e000000b001e3323611e5sm12943506wro.26.2022.03.14.05.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 05:36:35 -0700 (PDT)
Date:   Mon, 14 Mar 2022 13:36:33 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, varad.gautam@suse.com,
        zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH v2 0/3] configure changes and rename
 --target-efi
Message-ID: <20220314123633.67upt7a2qkjvhh3w@gator>
References: <20220223125537.41529-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223125537.41529-1-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 12:55:34PM +0000, Alexandru Elisei wrote:
> The first two patches are fixes for stuff I found while working on patch
> #3.
> 
> Patch #3 ("Rename --target-efi to --[enable|disable]-efi") is where the
> configure option --target-efi gets renamed.
> 
> Changes in v2:
> 
> * Dropped what was patch #3, which made arm/arm64 configure option
>   --target available to all architectures.
> 
> * Renamed --target-efi to --[enable|disable]-efi instead of --efi-payload.
> 
> Alexandru Elisei (3):
>   configure: Fix whitespaces for the --gen-se-header help text
>   configure: Restrict --target-efi to x86_64
>   Rename --target-efi to --[enable|disable]-efi
> 
>  Makefile             | 10 +++-------
>  configure            | 22 +++++++++++++++-------
>  lib/x86/acpi.c       |  4 ++--
>  lib/x86/amd_sev.h    |  4 ++--
>  lib/x86/asm/page.h   |  8 ++++----
>  lib/x86/asm/setup.h  |  4 ++--
>  lib/x86/setup.c      |  4 ++--
>  lib/x86/vm.c         | 12 ++++++------
>  scripts/runtime.bash |  4 ++--
>  x86/Makefile.common  |  6 +++---
>  x86/Makefile.x86_64  |  6 +++---
>  x86/access_test.c    |  2 +-
>  x86/efi/README.md    |  2 +-
>  x86/efi/run          |  2 +-
>  x86/run              |  4 ++--
>  15 files changed, 49 insertions(+), 45 deletions(-)
> 
> -- 
> 2.35.1
>

Applied to misc/queue and MR posted:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/26

Thanks,
drew

