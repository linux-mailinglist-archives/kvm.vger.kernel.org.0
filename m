Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF56D2493
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbjCaQCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 12:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjCaQCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 12:02:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF4DB44B
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:02:30 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x4-20020a170902ec8400b001a1a5f6f272so13148634plg.1
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 09:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680278550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=omBt8dkGmyrbtpTyfBXw/EDFrQqH5m7OcTU9r5l14Ww=;
        b=WJvma0w7ZW5baCkDOvXR2A9mHBW8wN/GMj822meEms/vhidsiGL3yWUZibE327LB2U
         L6qUNI0JkwzGGHMVpKAqwdz8y/Vvj63CFLuUOBt1nVuWUA6X8Fts4gSr1FCFmXX+QV5+
         KXWwZhnEQD7SPvJXJDoNFx8V4bO7PxFwTnrsy51zLhs4tP2mYtvX8y9vk7a+H00NhRKq
         VpIPlgdeG3O6T/5BeICv1sCg+B60yAv2fYCRQUXzPynsdw/NHYQYgRoU3sG0GNPDu5Zw
         beqWyk4X5R7DUmsIoMBM5tLvdhSrhEvnqnp5wd5/2nXGPayKxnysUHkqs/OvGolGxw28
         O5qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680278550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omBt8dkGmyrbtpTyfBXw/EDFrQqH5m7OcTU9r5l14Ww=;
        b=cb0te0BQ7V5IxnaBXYLWF4fRRXFxd+scnC68Cx4K20Eg9xv51tQLV+9RKpeIUYje4C
         Y9ZxbDwJFMN8mzJ9mC399t9z4K1JrFGozruQ/saXKD8J+w7Qz8Qe6kil+sG9puXmeyQW
         AIJPP1toUonnAGJ0EOMHGUkgFEMBIUFKTdHQHDKfvTKM6EAt5Eu1B/9v50HLFWqqpSK6
         oYK/ub6C9AqivW15jVgr+hiHymmGbAEoLpj/scAg/gsBqrYe6gdoxcIE+rLtGNu9r2qp
         OG8K74KAZxblVrbpvQLUTpGRABeoKUm474fJv5BBpBd19bPSo+3Sfg3nJvmHc945t7b8
         P3lA==
X-Gm-Message-State: AAQBX9cUsEx/gwbecp+/RJmXSXQbOx92MFh69S4phWDqcshFaBp4uKwx
        MRNJNmtXzpGx63HLvW5uDivxZBE5uWw=
X-Google-Smtp-Source: AKy350aMtlFGsA11MNEk25FDLnQJ60NC+ivbDw5HN2pm4HEDBpN5T2y0GpegvPyQEz6E6fnVcQgVcH1thK4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1203:b0:240:c387:6089 with SMTP id
 gl3-20020a17090b120300b00240c3876089mr2158651pjb.1.1680278549990; Fri, 31 Mar
 2023 09:02:29 -0700 (PDT)
Date:   Fri, 31 Mar 2023 09:02:28 -0700
In-Reply-To: <20230331135709.132713-2-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230331135709.132713-1-minipli@grsecurity.net> <20230331135709.132713-2-minipli@grsecurity.net>
Message-ID: <ZCcEFP+gRJ7Fcvxh@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86: Use existing CR0.WP / CR4.SMEP
 bit definitions
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org
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

On Fri, Mar 31, 2023, Mathias Krause wrote:
> Use the existing bit definitions from x86/processor.h instead of
> defining our own.

Please avoid pronouns.  E.g. in this case, "our" is really confusing because if
"our" mean KVM-Unit-Tests, then x86/processor.h is also "ours".

  defining one-off versions in individual tests.
