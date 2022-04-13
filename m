Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189224FF9E3
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiDMPV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 11:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiDMPVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 11:21:49 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD78B220EC
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:19:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n8so2261387plh.1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 08:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O1vdxtged0mAWh2PhZ+beuzTwi3xXh29880vj3vinHc=;
        b=gz2IBXAXXiD0iUlmZJeXbxJiDyRUqakoJUp5U5fCazgA/7ytIFSkiLzmRUEe0gNgjo
         CLewmifEScz7NyM5wtBdzk0yk7ye2KRLGFxGtSYVSX3qyPnB9Z4Ag9xTlWMs1znyxSUF
         2EFrL9V8IVrTiNJXRphvzLvvcIwCtcyGEE2Nnvn5nGseYb9BMgqPLmGvkq2+aNOxJuM7
         FKsWtQHqNTW7ohNqeyTZyJDUjOcWFNX1dkF4UFRX+CXmrJF5S+Gvupe6tjRd2QauYOLg
         HJlYTHlc9sopiSuBXQss2ga7Rjiii7ZHH9O7txg+NyDBkQmx17am0mP4DR0OxIwrmxUs
         7AUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O1vdxtged0mAWh2PhZ+beuzTwi3xXh29880vj3vinHc=;
        b=yEdIOnyBcJEeVWOCOxvvwQBqX99M6/UjZE9B+WX4A/6u5AE3b7qUfC8VrplCf9UzEA
         INDdx6eo1sUxNdDS3afLuD1iWD84RCj8YJun0W/rXzIL1whoUf14VK23i6dXK4yh+zzV
         vMzvjza42THwldO+m2GHNqaqQisynyKjY7IHbZYKYCRXI7v9vFSUdgZ8SDsaUDfjMYIR
         YBEIUrz6fE7zlbBmQEWWfJiNF2ocOApRlofFnnB32ZvqdaghKbwsCD7Ns01UbSHqLYwg
         5OCvAONaG90EwvLbpy3EBoMawY/yypGqHsyDYSVTouIvR4ZxlO6yVxceQ5JXSgAs87xE
         sLoA==
X-Gm-Message-State: AOAM531WrsfaoV9KKW7M1HEAcrkvUv1Rebsb6XJg/7m6qEy/+0y5TFF9
        f6XQOd1QMFkifVuhl78gweb3FA==
X-Google-Smtp-Source: ABdhPJy/8O6i5PscXRGqHtDPE8FW4wbED8af4wYj0dLz3jZCT1h5NTexxVLF5+hJqIJd/V7Su2Svdg==
X-Received: by 2002:a17:903:2446:b0:158:471a:b63d with SMTP id l6-20020a170903244600b00158471ab63dmr20458816pls.47.1649863167043;
        Wed, 13 Apr 2022 08:19:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x2-20020a63aa42000000b0038265eb2495sm6280517pgo.88.2022.04.13.08.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:19:26 -0700 (PDT)
Date:   Wed, 13 Apr 2022 15:19:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 02/10] x86: Move load_idt() to desc.c
Message-ID: <Ylbp+ku+Dty/S4MC@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-3-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173407.13637-3-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Varad Gautam wrote:
> This allows sharing IDT setup code between EFI (-fPIC) and
> non-EFI builds.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/x86/desc.c       | 5 +++++
>  lib/x86/desc.h       | 1 +
>  lib/x86/setup.c      | 1 -
>  x86/cstart64.S       | 3 ++-
>  x86/efi/efistart64.S | 5 -----

I belive setup_tr_and_percpu in x86/cstart.S can also use the common load_idt.
