Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3370871E
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 19:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjERRpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 13:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjERRpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 13:45:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D86210EC
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:45:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso2797266276.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684431936; x=1687023936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WQzTFP1RC3/tfWA0w7bguLLG8lFnT5FIHPo6B2Lf8Ag=;
        b=VpVPg93dEFqXNhcVdA4Xmhk1P800XWr2Ih3sIhCjsrlKx1xuBR8BfPJM6cQJ8iWFN+
         l7V8aTO4+Q/tUkxXMpjaX081IH24WjveSXyEjLXIs2WaghY+o8y1otzQbGZ48TAKN/AO
         UNxIEzuvNUkPOxWbqkYWhFJhUGRt7kAiJVtDtsl6eK8ObQRzw/lc5TNH7WDuT39cSu9j
         SEPWAI7OemYDihQuOrkA9+NtHcz98c59GL4SWeTrCryVIJVmI9JWr+fZfb6grMGsfS3o
         gpAaX4UK9sdHRo6UGVsO6o0TFEbXR+lz9iCvbMvcxzLIsO2Py06qiDZa911rxvKXtSc+
         J/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684431936; x=1687023936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WQzTFP1RC3/tfWA0w7bguLLG8lFnT5FIHPo6B2Lf8Ag=;
        b=JHChYRh8eNrJru8WeHXfQcvKz1bmxCag/akecs7mXvTEONSG39Rv/evOTAoWKoYvAt
         ibtfIDXlntgndqDEx/dGtQNAjxv48cmLwCMimmpMKcf5vLC4BWTRcd+NadwfDzhc1hmd
         drvyxzHCq3Wzs52DAX0LKZ5Dn4q1I4yxVjjph6xDkAzBNLfj/6CTzx/FtdYZxd/cPv1f
         WzCHnnyNcc20hxeCF3BBxZqUEf5AwYpBU+ECHMY9HvDL8BH2GvneMUDJpic86vhyuDUi
         BVAMH16+d33N07NgbI3mLduAvZJ1X8MOtv09mhnu3U5B7RzXWkYzP/KqPZwLbCD/ubSv
         2jMg==
X-Gm-Message-State: AC+VfDyuhdfbt1xrz90DneNGa3U1QvbkyuuzLqUTolLNO8zCXh1+KVzZ
        XgA90Uzhw5BsbnS4nn828GaLpaQ6lyQ=
X-Google-Smtp-Source: ACHHUZ4mV7Ub1P0BypUYeexPRLsbECnF+7L3840vcDgfoGJzZRbixYrlE4Ezn2sZXGD3Q7Vf+G7eCNJnx9U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d7cd:0:b0:ba7:e9b6:2994 with SMTP id
 o196-20020a25d7cd000000b00ba7e9b62994mr1646199ybg.7.1684431936329; Thu, 18
 May 2023 10:45:36 -0700 (PDT)
Date:   Thu, 18 May 2023 10:45:34 -0700
In-Reply-To: <20230518170653.704562-1-mizhang@google.com>
Mime-Version: 1.0
References: <20230518170653.704562-1-mizhang@google.com>
Message-ID: <ZGZkPqC7SK4AdEGV@google.com>
Subject: Re: [PATCH] KVM: SVM: Remove TSS reloading code after VMEXIT
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023, Mingwei Zhang wrote:
> Remove TSS reloading code after VMEXIT since upstream KVM after [1] has
> already been using VMLOAD to load host segment state (including TSS).
> Therefore, reload_tss() becomes redundant. Because of that, also remove the
> relevant data field tss_desc in svm_cpu_data as well as its data structure
> definition.
> 
> [1] commit e79b91bb3c91 ("KVM: SVM: use vmsave/vmload for saving/restoring additionalhost state")

This should be

Fixes: e79b91bb3c91 ("KVM: SVM: use vmsave/vmload for saving/restoring additional host state")

to make it clear that the code could have, and should have, been removed by that
commit.

Can you also explain what happens with the TSS busy bit?  I'm staring at a comically
long internal discussion about this patch, I would likely to capture the important
bits in the changelog.  Doesn't have to be super verbose, e.g. just an explanation
that makes it abundantly clear reload_tss() is fully redundant.

> Reported-by: Venkatesh Srinivas <venkateshs@google.com>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Tested-by: Mingwei Zhang <mizhang@google.com>

Heh, you wrote the code and sent the patch, so it darn well better be tested :-)
There are scenarios where a Tested-by for the _original_ author is warranted, e.g.
if someone else tweaked and reposted the patch.  But in this case, there's no need.
