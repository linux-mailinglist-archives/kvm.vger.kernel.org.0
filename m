Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9675670A
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjGQPBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjGQPBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:01:22 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DEC10DD
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:01:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8b30f781cso23016835ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689606072; x=1692198072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=awVrl5eJJBUaHOpkIdpJlOUxBr+2lb1t7Fi22et+vDI=;
        b=62TszBwbCrmKp9ce3qtA6ABTpPRoOjs92XedF11+ir17wH+9sGGPreQUypg9ZHT9OQ
         65JT4vhtqkYYBsYhjSwYNotsEd9glkaJAvE1a8RAcnkolNGg4AjNsnbptWnjWDD+LoFR
         TZKW5SjoqKJWpx+DmhjhhSu8/RHi01PnzPhzuq/yLURvnHy0LGZNTEM6bjtgte8u2AA0
         2NWdcfcRiDgLhw52TXs4K2SYatZjuZ5xzxzAN4LHVczRYugtc8ibT+q5WXHaS0JuGWeI
         hBS2V1W97L9H3Omv1q60lLSfgPSlMJS1/kHYmVTOpd05tftkISveVeSZ5t9IKYTLocAU
         8fyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689606072; x=1692198072;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=awVrl5eJJBUaHOpkIdpJlOUxBr+2lb1t7Fi22et+vDI=;
        b=jbu3DYhtaiK2IzzLyO04co/oSWuO5YREVZ3EfRM8ZGUHY4LWzAXvvIw4LIVbSm4fnN
         sbmoahad7y6eKNr6bvMqhEsGbENSVxToZsDwPZbhJ1ZTGkQpYRy6mXgPuPR8BboU/lec
         ewaQLN9v4fjXBKjnpnZVtTvtHcR/PAljmhaezf+/NQzJpPiePagtAYNdRp4g7GMr9zHQ
         +pK/xaJYKHoov81zdsZXO5V13RsEs6xNfgqksQPYCONuK99YjX6i1nKmnNJGzB7sfysA
         55jsxwEhht35r5Cb+ctpdGdJMBCB6TE4EHwgns3Dyl2ZHUlmeO9xAh0z+E48CKISznbS
         r0pw==
X-Gm-Message-State: ABy/qLYq6KdRxkHCCCOYr0/l2g5FHdFTMpZe+eY+aOYu9d0IOmT9aM+J
        eeN4SMvZm+k4WjqKWpMIbnNQxAMVPa0=
X-Google-Smtp-Source: APBJJlG7mX5h/W7K/UVdgIbHnqq43NdWdweEZ0CbCSk2I3KtP+ryUEUUBbRSIlrQnLo28Z0z5DH6sB6rlJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:228a:b0:1b8:9468:c04 with SMTP id
 b10-20020a170903228a00b001b894680c04mr109688plh.5.1689606072434; Mon, 17 Jul
 2023 08:01:12 -0700 (PDT)
Date:   Mon, 17 Jul 2023 08:01:10 -0700
In-Reply-To: <b6f80cd4-acf7-bc87-087d-142e8c54b098@amd.com>
Mime-Version: 1.0
References: <20230717041903.85480-1-manali.shukla@amd.com> <b6f80cd4-acf7-bc87-087d-142e8c54b098@amd.com>
Message-ID: <ZLVXtqlOfJsGKMYW@google.com>
Subject: Re: [PATCH] KVM: SVM: correct the size of spec_ctrl field in VMCB
 save area
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 17, 2023, Tom Lendacky wrote:
> On 7/16/23 23:19, Manali Shukla wrote:
> > Correct the spec_ctrl field in the VMCB save area based on the AMD
> > Programmer's manual.
> > 
> > Originally, the spec_ctrl was listed as u32 with 4 bytes of reserved

Nit, either just "spec_ctrl" or "the spec_ctrl field", specific MSRs and fields
are essentially proper nouns when used as nouns and not adjectives.

> > area.  The AMD Programmer's Manual now lists the spec_ctrl as 8 bytes
> > in VMCB save area.
> > 
> > The Public Processor Programming reference for Genoa, shows SPEC_CTRL
> > as 64b register, but the AMD Programmer's Manual lists SPEC_CTRL as

Nit, write out 64-bit (and 32-bit) so that there's zero ambiguity (I paused for
a few seconds to make sure I was reading it correctly).  64b is perfectly valid,
but nowhere near as common in the kernel, e.g.

  $ git log | grep -E "\s64b\s" | wc -l
  160
  $ git log | grep -E "\s64-bit\s" | wc -l
  8334

> > 32b register. This discrepancy will be cleaned up in next revision of
> > the AMD Programmer's Manual.
> > 
> > Since remaining bits above bit 7 are reserved bits in SPEC_CTRL MSR
> > and thus, not being used, the spec_ctrl added as u32 in the VMCB save

Same comment about "the spec_ctrl" here.

> > area is currently not an issue.
> > 
> > Fixes: 3dd2775b74c9 ("KVM: SVM: Create a separate mapping for the SEV-ES save area")
> 
> The more appropriate Fixes: tag should the be commit that originally
> introduced the spec_ctrl field:
> 
> d00b99c514b3 ("KVM: SVM: Add support for Virtual SPEC_CTRL")
> 
> Although because of 3dd2775b74c9, backports to before that might take some
> manual work.

And

  Cc: stable@vger.kernel.org

to make sure this gets backported.

No need for a v2, I can fixup all the nits when applying.
