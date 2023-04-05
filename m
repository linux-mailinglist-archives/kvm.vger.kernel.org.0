Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED8D6D8B03
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbjDEXQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjDEXQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:16:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9E46A45
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:16:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k199-20020a2524d0000000b00b7f3a027e50so21925013ybk.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680736586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rPrPddlYdd9ZtnbOQydqmAa8JEN+Kau69/ytm87mS1A=;
        b=Po8oOZVk2MN7dc9eO2elCnLjWgfykdkJriOiGllIpGqAStu5qqWssYdaqKqueez4D3
         sc03k4fqhu9oQYubvTuBiPOlxQYKMj1V6XAbQ4P1WJlXbAtDWpDcC86AIpQ0xJVHRbna
         SiQ46QYJBzSMRKRRVNM7l6F4+C+pIppHwasL5rLqgkA66t0zK6OV77yWhMxmpFWJu5g4
         KvVcgJK9URLkQ3xAmY1IMa6BT/nQLI2VpL7bWXSqtMDZtLCPJ8LRdzjwtS99cG/Z6kxx
         fm3iRIdbiKkgyRtfNCMc8irfJsvubvI6QbT+4zjNQSqKB4kJzYIpLWM5sO2b/6gpME9d
         bN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680736586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rPrPddlYdd9ZtnbOQydqmAa8JEN+Kau69/ytm87mS1A=;
        b=ZziKZtcxhuQc7grRJ3NExN6EqzeyPZuR6tC27UtNJjSfWqxsDFzFq0JmfW9GhyuEKf
         Ys/sb9opkPlksB1gM7hVnU8iKrd44mX/hW0DzHTktxNOKAd34ZUy4jd9OS4uEHD7Ndzi
         KDaFKNrUQn/5JzsluJuD4snbLEJxz+DrX1y0929BdQWUcscVO0eZzjChnZV4SXGELyiV
         uLCtrykzqUvxxtkWEBKz++VMehz+uIQZC6VlsKK2SgdDvFXIu4xLRdy+xnVBb73U9q20
         aSi/pCE5GxcnMUOeutsEcAAHmc+5XTYSaEMAPM8Q4Yc+mJT7N/4rNQCCWd3Ayvq8wo+H
         F02w==
X-Gm-Message-State: AAQBX9dj+pZnPFfApyXS9JTODsl0wekcuIrd5MWikkfMq8tOE1ek4zMN
        hN+XMv+3fl4wOc4PdNWysWQgjx5mKcg=
X-Google-Smtp-Source: AKy350YeV5yMuxlilC+GxPerGyv5VMXDlFcgVHoNmJ1/EyPhHdrFbAJK4qu0c8lIS8P2Tx07aoCn4speT/c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7717:0:b0:b78:8bd8:6e88 with SMTP id
 s23-20020a257717000000b00b788bd86e88mr747091ybc.6.1680736586377; Wed, 05 Apr
 2023 16:16:26 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:16:22 -0700
In-Reply-To: <20230404032502.27798-1-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230404032502.27798-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168072256808.509947.17252100246012267472.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode in
 SGX handler
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kai.huang@intel.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Apr 2023 11:25:02 +0800, Binbin Wu wrote:
> sgx_get_encls_gva() uses is_long_mode() to check 64-bit mode, however,
> SGX system leaf instructions are valid in compatibility mode, should
> use is_64_bit_mode() instead.

Applied to kvm-x86 vmx, thanks!  I'm still dumbfounded that ENCLS is allowed in
compatibility mode :-)

[1/1] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode in SGX handler
      https://github.com/kvm-x86/linux/commit/548bd27428b9

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
