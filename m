Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11FF4B952E
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 01:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiBQA5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 19:57:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiBQA5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 19:57:40 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB68244DA5
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:57:27 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id qe15so4053564pjb.3
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CgNYn9NC568YAEf6wiwntrOtraI16O3ffO2k05z/Sus=;
        b=kLnXwo9ZkVKfXczeyJAJjWVL5expJOFlAAeW+ISPcUhdjKvYwvcW3QTNPt2p1swyQM
         3YNGmacTsfKrXxbhwMpj4QM6kjxKJPI4GeU/tqP8j+DaWGy6DCJsiJTbxIY0kpRgY+6X
         i449G6Q+BzNtzQBc7MChTfLD/C8UrEFMogO7JDNHJILn5p0rARNfjfbJkwZN45Ta9HiV
         olWygVh4SLntrgT4YNMKBrQbC88gztw0AnmeKXbz5qccEHqufjZdorcFORwjmNihpqry
         Ezys4lK/oufRuzwO28Skk3ufCe4G6dHCp3t7P4Oio8d9SqmQyzt1duVK6bqBmeGIuFaI
         AtMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CgNYn9NC568YAEf6wiwntrOtraI16O3ffO2k05z/Sus=;
        b=nkrpptrOOf6Lo+8b2TghkZymuQQ1EIEDVwLbg7CPkZiSWK0j+SKXZyjwO/MKOk5Ntv
         YjAlEGVWK4/Ucpg+ZrjQYbI5Qzl01A68hLMl+z6QYRghxxJtrA/RxWeY+PEFDM2cDqCA
         HVcu+2blT0GxiHwgRMr0ArLzk3xKERiIUdAXfVhKwiYuAqSHwvJ9rRV9Gu5cwKFjjvRg
         ad4/9KJNC4Qpkct4Z6l6An18xKoOKgBLzIv3CnnwGvtsGqSlYLdSo/iOBtUQHmFbJKko
         cxUwUM8i2Gx6No/ec9rGINqED+0SSp1d0qHRAteRxDHxiEfd/Q+CMYFshDvZNJMMBxO/
         eD+w==
X-Gm-Message-State: AOAM530al6qLHaz7LIwFUCnsB9zKfoPur1SqaS3LjhKiKht5BJBB+eFu
        9iy7cFSjFnOw5H7D/TsBX2kq74MZ5UbYbw==
X-Google-Smtp-Source: ABdhPJwL3NyKcC5DMVMmLKPT8+8zaCyLoEBOdXWdZH5y1D6Q1rJsg2AlXAvEhpDFgKmY3lRGlulwhw==
X-Received: by 2002:a17:90a:6a4e:b0:1b9:8312:b533 with SMTP id d14-20020a17090a6a4e00b001b98312b533mr506053pjm.200.1645059446725;
        Wed, 16 Feb 2022 16:57:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pc18sm233991pjb.9.2022.02.16.16.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 16:57:26 -0800 (PST)
Date:   Thu, 17 Feb 2022 00:57:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v3 PATCH 3/3] vmx: Correctly refresh EPTP value
 in EPT accessed and dirty flag test
Message-ID: <Yg2dcnDN1BnLcP2p@google.com>
References: <20220216170149.25792-1-cavery@redhat.com>
 <20220216170149.25792-4-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216170149.25792-4-cavery@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022, Cathy Avery wrote:
> If ept_ad is not supported by the processor or has been
> turned off via kvm module param, test_ept_eptp() will
> incorrectly leave EPTP_AD_FLAG set in variable eptp
> causing the following failures of subsequent
> test_vmx_valid_controls calls:
> 
> FAIL: Enable-EPT enabled; reserved bits [11:7] 0: vmlaunch succeeds
> FAIL: Enable-EPT enabled; reserved bits [63:N] 0: vmlaunch succeeds
> 
> Use the saved EPTP to restore the EPTP after each sub-test instead of
> manually unwinding what was done by the sub-test, which is error prone
> and hard to follow.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks much for seeing this through!
