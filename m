Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670AA683241
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjAaQIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjAaQIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:08:40 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EEC51C70
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:08:39 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 78so10395209pgb.8
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZwzQw+dgVC2vRpw+NV0dxautpTUAiPpH5V6r2tyc8E=;
        b=YOsfaN60LZ9377foPupCxLl6LPuiM04Y7PztaoKExWsh5b3u/oBjBQbcXKMHYP5Zd5
         bNeRE/MaRmdxoBxehDqN923qQw23T/v9T2a9J2bqVD4gijGFrfnI+ydN9wtIRMcIqJxk
         sRkuJtVDXxqBXN0ZbDJrhmZ2pKLIychlK6aHIH1yV6XX/2KH2DHx+wxzApmyD0h9ygXk
         /ctr1tEh+QBmVuIFOvXHAsoK7eeD8IDGB3e55vozb5JEvD3Q6rs4EdUA3ZllWNq2Jr1J
         3iQ4SdPh8XSIxovM8/Rqxp/+T8omQvObfi+YmWkTsEBLZOsWQf3CQMa1+o71Dj7gCqcA
         rQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZwzQw+dgVC2vRpw+NV0dxautpTUAiPpH5V6r2tyc8E=;
        b=Phbi6toVr6qLfQDWY1diG60oNqQbdNpGb7Pt2SZdU8sqkDhenqTd3jjqdaX372z3rk
         DzWZ2Qv37yG+khfXk5DPWtLhQFg1Gb+hdr5gxbB+T5JBakfGURUkpmQjt3LzGXJFqtDu
         CtT6Au8Xiy8V2Z03Js4K2M+lBF+9s6OQJo3pWEoQ5ZZbZ/Wi3GmIcWiG4m7J4R0d8ijS
         2VY1VNCoNKNFRSjI8E8UXhSDA38NHDu4krTIubdjncevC6yA+iUbwkCBRzsiThSIGdei
         YVMbGy3sSTYxD+RAem6cLAd3OGek+cFGdXH4uLiaQB5CvKEcFF5pc6DJsNxwC0Cxd3YG
         12QQ==
X-Gm-Message-State: AO0yUKUIqL+eRpEq7BBtrVCrKT7MdlFC1wHtr1E1fm3StpV/wc5PJSQj
        afwZC7hP58KAjqHirmI+xd2yHQ==
X-Google-Smtp-Source: AK7set/zoe63YwCCy5KCroP0uOa0k8JPUwFnOcCv8ZhCF+1W4GzlVmr/jXt7eT2Bxu/zVYHgo/E8IA==
X-Received: by 2002:a05:6a00:1990:b0:592:5ec4:8b33 with SMTP id d16-20020a056a00199000b005925ec48b33mr1281866pfl.1.1675181319202;
        Tue, 31 Jan 2023 08:08:39 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ck11-20020a056a00328b00b00593906a8843sm7054854pfb.176.2023.01.31.08.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:08:38 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:08:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 2/6] KVM: x86/pmu: Gate all "unimplemented MSR" prints on
 report_ignored_msrs
Message-ID: <Y9k9A1CmEmqBjqLx@google.com>
References: <20230124234905.3774678-1-seanjc@google.com>
 <20230124234905.3774678-3-seanjc@google.com>
 <89c214e1-a7b4-a0e8-8fb9-c769dbf30ed4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89c214e1-a7b4-a0e8-8fb9-c769dbf30ed4@gmail.com>
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

On Tue, Jan 31, 2023, Like Xu wrote:
> On 25/1/2023 7:49 am, Sean Christopherson wrote:
> >   arch/x86/kvm/hyperv.c  | 10 ++++------
> >   arch/x86/kvm/svm/svm.c |  5 ++---
> >   arch/x86/kvm/vmx/vmx.c |  4 +---
> >   arch/x86/kvm/x86.c     | 18 +++++-------------
> >   arch/x86/kvm/x86.h     | 12 ++++++++++++
> >   5 files changed, 24 insertions(+), 25 deletions(-)
> 
> Nit: those changes don't just involve PMU, better to
> remove pmu suffix from the patch title for more eyes.

Ah, right, I got a bit overzealous.  Thanks!
