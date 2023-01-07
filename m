Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5760E660B02
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbjAGApI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAGApG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:45:06 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2316B5F9
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:45:05 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c4so3457444plc.5
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 16:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HbPeHNGhm1FFaL0tIDHA9L86W10r/gsa7msSV54cRFk=;
        b=S358T91+YyddBmJ1eN3LaxAekHtLioEs+fE1SGbITz/kvb8CR6twcTwjsWVuP4z+m3
         XTyFLfUVMd8WjCxqmjzBsTuEpUTvy6+NcfrCv9zwJ9SAyqxoCufIQbvOInT8GEhEfeDl
         CcaLNuzMqIaHaZKORp6e4nKPigB/7shKK6tupT1Ay6idy/ZMkhAksdmp0j0MqwzspyRD
         GrYUHC9tn4VGCwPo/5o/ZDBn3Uf+7pZESfA4GC4Hy7PN/EBbRVJfbO3zQqL+ABbObYE9
         lR5cNbUNJionBTLYUcdiGn3WHHZKqNJehMHmNKrI2oCumlUIY5r8lt/21j3xjBIoTs8D
         I+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbPeHNGhm1FFaL0tIDHA9L86W10r/gsa7msSV54cRFk=;
        b=O6OQOswipR+b6MhEeojbswHCT6jRJph+nnlLrQLkwViacvgbltJx3nV+YXr/mzINcU
         j1xWWo4i4ioVmBwMbDFWNReO1M5ZaCMd1nwKsZ5mpVi98DT2aHbd1LMjCEISHB2XQ6Wf
         8gMUBdksM1ycgZVK1mJkrRRTg3ivjM23kzZNnCHPOSE5He8T59m5nIznLrtTKe7Bsdpe
         SWBjgwPtCPnCaiIba2R2U+ZcK998BAAvVzDebjxRwq9+Lyubm2X/56eUw32/dQZYb/sn
         OuN+uQ2+Zi8VaJWluHPqjV5j+7Rhg7ZEdeywbYVKHCdVL+IzPiAcY5o5Bza6XzoE2myP
         zQJg==
X-Gm-Message-State: AFqh2krMuJ5XAwr4mKGZONZOtmu1p1tzFnIyDd33R1bZ30uB+9nwiqW3
        +2XocRE6l745Qxs+7NXrHjiwLg==
X-Google-Smtp-Source: AMrXdXsjcAxGcuzQzXDoD1vx+0Adzx+pao800hcfJu9lJBKUpbB9lMN2RfYMiY25h88II3AZn/n6jg==
X-Received: by 2002:a17:902:d08a:b0:189:3a04:4466 with SMTP id v10-20020a170902d08a00b001893a044466mr58372plv.2.1673052305114;
        Fri, 06 Jan 2023 16:45:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090322c200b0017f73dc1549sm1443954plg.263.2023.01.06.16.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 16:45:04 -0800 (PST)
Date:   Sat, 7 Jan 2023 00:45:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: MMU: Rename get_cr3() --> get_pgd() and
 clear high bits for pgd
Message-ID: <Y7jAjXcjDXlgAX+0@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-4-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-4-robert.hu@linux.intel.com>
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

On Fri, Dec 09, 2022, Robert Hoo wrote:
> The get_cr3() is the implementation of kvm_mmu::get_guest_pgd(), well, CR3
> cannot be naturally equivalent to pgd, SDM says CR3 high bits are reserved,
> must be zero.
> And now, with LAM feature's introduction, bit 61 ~ 62 are used.
> So, rename get_cr3() --> get_pgd() to better indicate function purpose and
> in it, filtered out CR3 high bits.

Depends on one's interpreation of "PGD".  KVM says it's the full thing, e.g. the
nEPT hook returns the full EPTP, not EP4TA (or EP5TA).  I don't think stripping
bits in get_cr3() is the right approach, e.g. the user might want the full thing
for comparison.  E.g. the PCID bits are left as is.

Changing get_cr3() but not nested_svm_get_tdp_cr3() and nested_ept_get_eptp() is
also weird.

I think my preference would be to strip the LAM bits in the few places that want
the physical address and keep get_cr3() as is.
