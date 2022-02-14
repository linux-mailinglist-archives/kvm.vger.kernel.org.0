Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DD64B5D01
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiBNVfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:35:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiBNVfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:35:21 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB24415A20D
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:33:09 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id 13so717876oiz.12
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rc1rRmmpgLSHN2kKWyVfHB86Z+mbUxpEfCwrd9zmNvA=;
        b=M7uTq2D92yg6/1ARAfN3nl4VQoivxn4EDcYNJxWeaK0MUl0JKymNw4UY8hOe5ZN6MO
         Sippa1sxHloXGylIN0Ndv6usOgWE5hIbznVg7eCSxNoO1JmIVi+kFzQAceG8+iyI5n66
         EnfXmtuG7uEki1pwjTfPYmJDAg423j5tsE6dc9f2upxm8oz9Lhhcfk5CPYjDeGBulU5W
         CaTf98KCMzxmR9GKAavVgpgjfl8dZhlmRqcQqqG2+cKJIwMKc1ezk+zswmqPQ55kh8oG
         a156G4DeUDYHdIR9HL6dEcivdzO/JRbSbO4vJVo40RAiz3meOPqpKPMH2EkCc16oHeRJ
         Z22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rc1rRmmpgLSHN2kKWyVfHB86Z+mbUxpEfCwrd9zmNvA=;
        b=GBwqSiq3ss4SzveHtAyp6qcHQPXIBfXml6B/GE3Trb5fNHEHVDfDi/O6cKRzAtTJpK
         8r85vLxeJKF+IF1fPF4O3uyLGzjQYZN4ti5WZ/obC3h6Mq1wNJ3brjK8n0tu39s555DO
         r53s8GY7B1N+GA9VppPbj9YLkkT12b0UGtGwyr4HkCLKTBqiJkvK9GLyTeFrF1ITX1Wv
         MSIFYXRumEu5GSOBpxk9OJpd36WQZkvrCIAO6p5YcvKzgKDCgMALPtwMW6sbD0o0wngD
         FrMWuBq+rcZ4Yufg/mNWC7FlgWylAQHouSPt9KX9cc/+26SWNO0xZmxLVwBKzTIgvKfW
         G7cg==
X-Gm-Message-State: AOAM5333NKSoCPTfWc7Hh1o9NmOmBu+eqAfpzhN93G6Kt6ZfgX8Gc8B/
        WRv+cjHhA1OsRH5QW+UIpyZIre4bm+CBrg==
X-Google-Smtp-Source: ABdhPJwChT18M7cg2++5rR9/fTFym1nAHo5i+xunpUigXnKh2jCfVBudZHJqaxlaRaVjkq8TLRfZUw==
X-Received: by 2002:a17:90b:4c0d:b0:1b8:cc2e:93f2 with SMTP id na13-20020a17090b4c0d00b001b8cc2e93f2mr248145pjb.68.1644867013158;
        Mon, 14 Feb 2022 11:30:13 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nl8sm6350730pjb.18.2022.02.14.11.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 11:30:12 -0800 (PST)
Date:   Mon, 14 Feb 2022 19:30:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, aaronlewis@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] x86: Add routines to set/clear
 PT_USER_MASK for all pages
Message-ID: <YgqtwRwYbJD5f9nA@google.com>
References: <20220207051202.577951-1-manali.shukla@amd.com>
 <20220207051202.577951-2-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207051202.577951-2-manali.shukla@amd.com>
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

On Mon, Feb 07, 2022, Manali Shukla wrote:
> Add following 2 routines :
> 1) set_user_mask_all() - set PT_USER_MASK for all the levels of page tables
> 2) clear_user_mask_all - clear PT_USER_MASK for all the levels of page tables
> 
> commit 916635a813e975600335c6c47250881b7a328971
> (nSVM: Add test for NPT reserved bit and #NPF error code behavior)
> clears PT_USER_MASK for all svm testcases. Any tests that requires
> usermode access will fail after this commit.

Gah, I took the easy route and it burned us.  I would rather we start breaking up
the nSVM and nVMX monoliths, e.g. add a separate NPT test and clear the USER flag
only in that test, not the "common" nSVM test.

If we don't do that, this should really use walk_pte() instead of adding yet
another PTE walker.
