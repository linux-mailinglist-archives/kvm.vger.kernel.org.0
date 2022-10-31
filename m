Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A97613D37
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJaSTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJaST3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:19:29 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D9112AF0
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:19:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso10957577pjc.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOyTl6aXXBw3N02vi1H1U0/pA9Tj3+GtHzAXsfbpKO4=;
        b=OS+ZtRicLj9seSGMwetF0z5KFsfsqgmhodIcro7sqvXhQhJS6KQLD0cbf8Tu8jaD12
         bhxLNtE0mxjgzaJO/z1aPMEm4m+SW5d3uCVqDpSDXd7DQPoHCN84IDth1n73QbkgWVbF
         2X2B1k0LDa43IgZOuKYkoL3LMy6sqyKHxRN4E4/hL+LT6BsnE3axj49LsoWo+Bnngbqk
         ZFlazXTl0syLyTEl+7TXzHxPG78vCyvW9IcAsKTujJ6nxDkmDds2EQML/5GUMlrUuiXq
         NhuthhsKQHx2Cryzst/CgpCwk/tiuEsZVX/DylFsmbyd2lP36TE7uh0YBEAb8WVMxyyZ
         A5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOyTl6aXXBw3N02vi1H1U0/pA9Tj3+GtHzAXsfbpKO4=;
        b=aPHcFqcTrKzUaFWWHNOh3rACw9qvZqbFhi5YjVUyuKEIkj7Is/48EZiK8agn6BI4LY
         ksMcFxaJn4Y3AFXdu5loNd0Jm7yNntR6OwA2laKYF11F5iN/LKVhJI2MA2mR0TQT9I60
         ejcST410Q98j/GxjSTs6UDiqB9xYzBpNm4zUAg2nfBd/bXaIp7kjudQy44jebvQd6Bu9
         lLGwXWCRarEpbcAgILlppqcMwKCOt+wxflsHjp//fiHRPxFmcqzOd+zJ5BWyBfifQx+D
         GQP+jPvbf79H0mwgWwqCP+9QflKrL0BoI+t53VtVfqn/TeGvLbAIvUxgjylaQA7+Ii+g
         HPqg==
X-Gm-Message-State: ACrzQf34mF1tfUi7DyGtawJLkGX9A+eYlQ7Xtd64v+IQ8xDBBl/6BOuK
        UQ62GBylTxHQae/RjIiarnXs0A==
X-Google-Smtp-Source: AMsMyM4M5qHvIPcUWshH0iuuBV9bcKZR1HaZbk9bZrFoFwDXVVb3ojtXvfmQkPWjoUNX/ZXDA+uM3g==
X-Received: by 2002:a17:902:d591:b0:186:fe2d:f3b7 with SMTP id k17-20020a170902d59100b00186fe2df3b7mr15956325plh.68.1667240367534;
        Mon, 31 Oct 2022 11:19:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x189-20020a6263c6000000b0056b8af5d46esm4901077pfb.168.2022.10.31.11.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:19:26 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:19:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/10] KVM: selftests: Explicitly require instructions
 bytes
Message-ID: <Y2ARq+1EFCrqJgBQ@google.com>
References: <20221031180045.3581757-1-dmatlack@google.com>
 <20221031180045.3581757-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180045.3581757-3-dmatlack@google.com>
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

On Mon, Oct 31, 2022, David Matlack wrote:
> Hard-code the flds instruction and assert the exact instruction bytes
> are present in run->emulation_failure. The test already requires the
> instruction bytes to be present because that's the only way the test
> will advance the RIP past the flds and get to GUEST_DONE().
> 
> Note that KVM does not necessarily return exactly 2 bytes in
> run->emulation_failure since it may not know the exact instruction
> length in all cases. So just assert that
> run->emulation_failure.insn_size is at least 2.

Heh, I suspected this was the case.

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
