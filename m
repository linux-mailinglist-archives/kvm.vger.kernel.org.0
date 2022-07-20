Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127F957BC47
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiGTRGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 13:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiGTRGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 13:06:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68673C146
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:06:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x24-20020a17090ab01800b001f21556cf48so2663351pjq.4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 10:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mxHGrxH+znEL4PRhhQoMwVhj8V9iLKntKa0rkmrwJv4=;
        b=fbjdnhZvC9kMvbvM6vh8zZy9HlHhttZKk16gK14eiFO7kO/GvZqF55tSu1EGa3IRyn
         Xs932CjVdzCoN1Xha0K4yCLixViV0VU/msLYPWQgtckwqb4DQ/X1CrGQtQdwN/rOKu2l
         IZCjoghDzCbTLLjk8RetbSQLcZSxSUvRpsKLKMNvjc1x161i8fuGGaHFHlvxl/yz3w6+
         LAVy2FbXMFIy9bHp7nWTF7EmFceYnDgw5QRkKFpIWhrHoFmtb+Zl0YatFAxx+R32uXSq
         4UkR0eSGoms2o1c+B1/5RBi32z/8yNaM+L47J7W4d+KrnOpWb7LWRu6PhP1K1vkFG+E5
         P4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mxHGrxH+znEL4PRhhQoMwVhj8V9iLKntKa0rkmrwJv4=;
        b=BHKlMeA+WJaJdxyHg5e2QZ2astlPcX3BmDWZS06fJRpwwOFN4XU4ctb2FtjqyorBlD
         QjgR7c7VGBlW3r/SfEjGDwgHRSCmMNtv7Q7Jq6DyXLV5rlKnSKEDooDOgen2CmHqg8SK
         kSZKOykaBpIH1N/H52HyBnhBcts7dz+vFJmS5R4Cul6JXcX+0EWdHqs+xYtZr53ohL/S
         IHvi9CmqRYeT4D7gRkpfIfjbi9Wb/Ju8ouCLq9I/DrGtzl89+xqCsUUEhsKgZTiTN/wa
         acCkqLh6/40CL9e7WCltQSthD8Eg+5ojjToXbgPQF5IuLyA4dVFOY9Q8M5aeakKDMLnE
         9kNw==
X-Gm-Message-State: AJIora/dMxYnPx17ENcAQNj0otZRuquPOPszp8PhHkJAm7e6rZQMIRrE
        sG07xx0w8OjcYpHFhzD8zyJ0fg==
X-Google-Smtp-Source: AGRyM1solFLAy7ymWlgW+LsLC2BHsNXqOFRXkS+mSO/KJNk/bJkM5O1Crk8ZbcCIbzEVLo5ouruAmw==
X-Received: by 2002:a17:902:7795:b0:16c:b506:d41b with SMTP id o21-20020a170902779500b0016cb506d41bmr33616432pll.72.1658336772073;
        Wed, 20 Jul 2022 10:06:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f11-20020a17090a664b00b001ef82e5f5aesm1941383pjm.47.2022.07.20.10.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:06:11 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:06:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 6/7] KVM: x86: Add a new guest_debug flag forcing
 exit to userspace
Message-ID: <Ytg1/zdSPYQ2lYS/@google.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-7-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622004924.155191-7-kechenl@nvidia.com>
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

On Tue, Jun 21, 2022, Kechen Lu wrote:
> For debug and test purposes, there are needs to explicitly make
> instruction triggered exits could be trapped to userspace. Simply
> add a new flag for guest_debug interface could achieve this.
> 
> This patch also fills the userspace accessible field
> vcpu->run->hw.hardware_exit_reason for userspace to determine the
> original triggered VM-exits.

This patch belongs in a different series, AFAICT there are no dependencies between
this and allowing per-vCPU disabling of exits.  Allowing userspace to exit on
"every" instruction exit is going to be much more controversial, largely because
it will be difficult for KVM to provide a consistent, robust ABI.  E.g. should
KVM exit to userspace if an intercepted instruction is encountered by the emualtor?

TL;DR: drop this patch from the next version.
