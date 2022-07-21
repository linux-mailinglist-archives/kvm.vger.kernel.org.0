Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5957357D173
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiGUQZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiGUQZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:25:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C9584EEC
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:25:45 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id e132so2111573pgc.5
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5OeVO50J7VroLT736lBfkoQjjuYlp1AvuRN18nKvUnM=;
        b=YMkM6vDLPLjmGcZQHgSmri+i2/nAPH+/qCTfgudw2H+zVQTjyTbi07IY4iX3Jp5NLk
         OsvNgm0HxSQ0nRBBzaMovnt/g/rt+hqEaEoYl4unXO5xMrENsjB7ovNTLyuwr/EQhO5Q
         Bng5DtDV1UUvxGtSghiWDgwWQdE0iq6DPKdQxiss1L6qI58lbXmEZc1/cN9/fkCn+WAE
         uX8edVy7nXpmcxOpMQ0Gt0pbMvlclinuPpLfVZRrf83tDmq45etKijsNaRhegnVWwt5R
         VJeWouHPEUlRz/f9rHFLue7LrGb7t67Ah1qTrZZp3MMPdCDo4l9oi0ogfYfsNiIGDfxk
         6Oag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5OeVO50J7VroLT736lBfkoQjjuYlp1AvuRN18nKvUnM=;
        b=aMDHZYL2MpOVpD3iYtFF0gziJ+lWSX0V976AlQ5OBMM9aj73j6qzhE4ZjCuElQNJ+x
         zVLPEctVS5TMWd2TPMHVc5AOwsZxF4wz67BI2VvNw9B4VtVrKbqX9TUIzU73MLMTGrKL
         39gYGnL2pTyOP7V500aw024rppgSmuvn1A2VYcNP3tQ5McZ8euDJdu/MimKnq4iazDD+
         lwxOJ0bgCenQT4Kxz9zQCzsdocVu4jSth5zfqiKh1sSKrLuIXziHPBhigoLhMDC7kox5
         A1T9etN5vvpgGOOKEbcvZhY17J4Yt2wU8n4QO/6JLbEiweu/kxsNYhPxIAHUq1ZvMLG6
         v+UQ==
X-Gm-Message-State: AJIora8nCjoFjfC7f8TtFvX5LWUUfl0evGSeUaLvPRzpfP25caVwA5Kd
        T4VnPP+w0q5dRWCOrpilIOOeAg==
X-Google-Smtp-Source: AGRyM1ssGZStH5RKI0f7tLkGUTHVJhb80FN2mRQMENDsdJFujfu+pZ3MuEs/4tNXiZ1Rt1cUk09uYg==
X-Received: by 2002:a63:4a12:0:b0:419:9ede:b7a0 with SMTP id x18-20020a634a12000000b004199edeb7a0mr36227511pga.167.1658420745211;
        Thu, 21 Jul 2022 09:25:45 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id i8-20020a170902c94800b0016d2dc52eb1sm1987771pla.18.2022.07.21.09.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 09:25:44 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:25:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Message-ID: <Ytl+BGei3zUlHY6l@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-5-santosh.shukla@amd.com>
 <Yth5hl+RlTaa5ybj@google.com>
 <c5acc3ac2aec4b98f9211ca3f4100c358bf2f460.camel@redhat.com>
 <Ytlpxa2ULiIQFOnj@google.com>
 <413f59cd3c0a80c5b71a0cd033fdaad082c5a0e7.camel@redhat.com>
 <Ytl6GLui7UQFi3FO@google.com>
 <23f156d46033a6434591186b0a7bcce3d8a138d1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23f156d46033a6434591186b0a7bcce3d8a138d1.camel@redhat.com>
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

On Thu, Jul 21, 2022, Maxim Levitsky wrote:
> On Thu, 2022-07-21 at 16:08 +0000, Sean Christopherson wrote:
> > So we have a poor man's NMI-window exiting.
> 
> Yep, we also intercept IRET for the same purpose, and RSM interception
> is also a place the NMI are evaluated.
> 
> We only single step over the IRET, because NMIs are unmasked _after_ the IRET
> retires.

Heh, check out this blurb from Intel's SDM:

  An execution of the IRET instruction unblocks NMIs even if the instruction
  causes a fault. For example, if the IRET instruction executes with EFLAGS.VM = 1
  and IOPL of less than 3, a general-protection exception is generated (see
  Section 20.2.7, “Sensitive Instructions”). In such a case, NMIs are unmasked
  before the exception handler is invoked.

Not that I want to try and handle that in KVM if AMD follows suit, I simply find
it amusing how messy this all is.  A true NMI-window exit would have been nice...
