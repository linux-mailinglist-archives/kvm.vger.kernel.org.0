Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED69572DFA
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 08:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiGMGNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 02:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiGMGNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 02:13:34 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AB8C73
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 23:13:32 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id n9so6121218ilq.12
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 23:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:from:date:message-id:subject:to;
        bh=93bEO8kS43KvvN1XCr9SeImgidE1CgmWJqOaoWFZULs=;
        b=qj7bEapEQGxQwxx0YZ1B+a7DoCDVEVjN2APpasO16y4/j5Bpk/l1Y1f1iDaN2cWqCV
         dgNryNVMS3an5Q7UYRxV+XOFGn+x2YWDXzLOTY5xNKDHVkJf7bi09cqJYTUQa2StrBOz
         Sg6DkfV8UP97TU62L9HgF9WmgKYMcQ7XZC8tg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=93bEO8kS43KvvN1XCr9SeImgidE1CgmWJqOaoWFZULs=;
        b=vBMtP2mLHxXnzSDzzAsAoo7n5TYeaUBf8JPEoLU7rMO3a94MLcmMAWEe1wjO5Ta66N
         KaNUopOphcmYb2g9mccLkasud9Nuy7awhxW9BnHW5P1ydjm4w/8+eaLZlOQDjlK9LvnQ
         nnRFfric04/7mAPDsASViOqLIKlSGyFgZ6z2dmOSV3puNnQRJ+kEVfMfQzfJfysSs/iT
         ZrLX79BVZh357BwOdZ+r0rh1o5Gai2Un6xf/1z8lCpsXoa2eQ95QzxDNZ+wH1JRlujXO
         re87gw7uq+tZ0zyi9SaGgUI+rvrZasmWMHDOctb5cbvjPsmy7CIahKg8S2+ak3cz0Iy5
         D6ew==
X-Gm-Message-State: AJIora+C8hcMctKmboQ1AoyWYwD3BKK6h+WIrzpJJrH5D7oPqI141AdY
        oWq1AkclYaPG76AVKuk7Pe7SF/R5JPFRu31DiNTlxXuwOUM=
X-Google-Smtp-Source: AGRyM1vbvmgWaeZ8Z/1khIlRc1lodmBTFPL0nLJJf+yLSHeXp1sewc9U1BISqf/+b4kjqn9O7SZXeAyym3X/HNVh0cQ=
X-Received: by 2002:a05:6e02:1749:b0:2dc:1a2f:b20a with SMTP id
 y9-20020a056e02174900b002dc1a2fb20amr980722ill.277.1657692811855; Tue, 12 Jul
 2022 23:13:31 -0700 (PDT)
MIME-Version: 1.0
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Wed, 13 Jul 2022 11:43:20 +0530
Message-ID: <CAJGDS+Fwy1b1+qm+XFUe9BnGZb1Ga2Q6QQ8XfNp4G=jJuWTRUg@mail.gmail.com>
Subject: Regarding TSC scaling in a KVM environment
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear all,

How do I know if TSC scaling is being done when a VM is running in KVM
mode? If TSC scaling is being done, how do I calculate the multiplier
that needs to be added to host TSC to get guest TSC?

For more context, I am running IntelPT and collecting Intel PT traces
when a VM Is running in KVM mode and I see that the TSC values differ
by a multiplier when the VM is running in root mode (between a vmexit
and next vmentry) vs non-root mode (between a vmentry and next
vmexit). I use QEMU - 5.2.0 to run a guest and I use an Intel
Kaby-Lake microarchitecture.

For e.g. The first TSC packet that I get from Intel PT when guest is
in root mode is 0xb24d498c651
while the first TSC packet that I get from Intel PT when guest is in
non-root mode is 0x4b41048e77.

Best Regards,
Arnabjyoti Kalita
