Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EBD5F7292
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 03:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiJGBlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 21:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiJGBkz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 21:40:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD6AA4B98
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 18:40:54 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f23so3278812plr.6
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 18:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=psA+UjfPNNFZ4z+eBeZEC7iWY14Pqcje4PonnYU9M7M=;
        b=tbuceVX/H+PzhuayDzo0ykHHjxLNbJsg4T19hxiQSsdfkU48qf8ZZuz3sLTXWQfdEL
         pcIHj5O2ie5l4RAXMHP0YrRbHFrCm5I24YXoi/vX0aZEpHPPiQ7sCQzhTe0gFsYDpDb4
         F8LwHS1381/FWww8nQ+Q/fFcHFdgpHKbpFKOftwPMmDsntEFh6VyKkhDS1+yMh1yPZJU
         /UJzsMGPOEaFevtotpvmhcA2umPoHMAjyfeYeJ0HhaN62ca25GBn7pLZLLWS/ZOHhClY
         Wk6B/yi3nLhM/R6Fy8CT+sQ7VM4xOf4bcQot4+mpwfLyecUdlqKV/KoGkg33BpjLuZrm
         OdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psA+UjfPNNFZ4z+eBeZEC7iWY14Pqcje4PonnYU9M7M=;
        b=CTL/HI8m/vTauPlq6hFvCmGAkEbQ7fuQ6zwxV8Q+HP5+86k3n+nhzAWRU6UTGwcVh6
         lE/sSqeU4putsflQBSxmGfupS1nm0phfUbxSxFlwwA1cx2Xz1ktxaF+w7GmxPW7/dQ5m
         PdwnJj+ZslwyyKK/YdNR4u2Cg5ui+oSGIoJOUw6BhkzwawBkqgB2syEaIdORUrZioaz2
         O8oivhB9DfDgq9EO++Btfeb+/5rLrGokgQtpAxZZMxuQq28t4S0OiWxUtao0g3f3tp1u
         VCjB+y3LFL40A9kz3ZOoMJA7dr0WPPvbqdWtzDI1fCV4yM14i4x0b0/UC3MhN/ucQyDB
         qiew==
X-Gm-Message-State: ACrzQf0tdTHGr7H3+9pzXYrIJcKgJ6MLQlZ58TDsLYA5HpmsjjrQYMme
        5D88IhzfiEyC68ObabdeztDy3g==
X-Google-Smtp-Source: AMsMyM5jX+Gww3bP73OzQcH0vIQiFVHxId96yushgKidEcYGmx9RGQXlWH1eBEQeVkoI06GpeM0sIQ==
X-Received: by 2002:a17:902:b692:b0:176:d346:b56f with SMTP id c18-20020a170902b69200b00176d346b56fmr2222567pls.140.1665106854044;
        Thu, 06 Oct 2022 18:40:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g26-20020aa796ba000000b0056188850950sm270985pfk.180.2022.10.06.18.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 18:40:53 -0700 (PDT)
Date:   Fri, 7 Oct 2022 01:40:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v3 0/3] kvm/mm: Allow GUP to respond to non fatal signals
Message-ID: <Yz+DoQKUvfvG/q2B@google.com>
References: <20220817003614.58900-1-peterx@redhat.com>
 <Yz8+7/1uCzcGumBS@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz8+7/1uCzcGumBS@x1n>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022, Peter Xu wrote:
> On Tue, Aug 16, 2022 at 08:36:11PM -0400, Peter Xu wrote:
> > v3:
> > - Patch 1
> >   - Added r-b for DavidH
> >   - Added support for hugetlbfs
> > - Patch 2 & 3
> >   - Comment fixes [Sean]
> >   - Move introduction of "interruptible" parameter into patch 2 [Sean]
> >   - Move sigpending handling into kvm_handle_bad_page [Sean]
> >   - Renamed kvm_handle_bad_page() to kvm_handle_error_pfn() [Sean, DavidM]
> >   - Use kvm_handle_signal_exit() [Sean]
> 
> Any further comments from kvm side?  Thanks,

Code looks good, patch 2 just needs to be split up to better isolate the three
changes in there.
