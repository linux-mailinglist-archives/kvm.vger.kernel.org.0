Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCE96AA0E9
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjCCVN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCCVN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:13:27 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95679028
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:13:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id z2so4063978plf.12
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 13:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677878006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uswt4nX1qrmy1/u6M47FWTThK1Yjw6p+0KSZ7GQSmr0=;
        b=K9Bnt95blV04CMyZl+/RIzBakAqHSrsUpLUTvmLaUkbpoYyk/iYQhWp4yDFLDSt86K
         PhQvLo1zWWUKhxDnwxZ/c59Q9rLBLgfr5S1r6iY2NHk6TQmd4+Krwq9oiJ+iQC/8C68x
         Zp/ddnSAtgQJiPYZ4jEyDS0HxUbm8WAQ1EIImuRmoysSroL9LZo92Y3t8scUnjsubmzq
         e7+dXr13LIbCar4LNnqnintaZ9QeeCQtODl8TjPc2rb+Bp+ybPGpFaExt5WFPA9bRBye
         CCyVhTRBM8Y3ecmIymOIYM7k5ZZKwrBYGFK9Y1PHP2yn9Are+ALL1rkc50YGfyEqahHq
         loqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677878006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uswt4nX1qrmy1/u6M47FWTThK1Yjw6p+0KSZ7GQSmr0=;
        b=4OqXP7ufUhFO5W+cRbunLB7vyiru1ucjFSClkI5lzdixpRnbJi6lbT3FXI5jkl5wJ+
         Sxf0FJSSBDGD27xB+W9sxSFSfbwLuOoqsqkpXe7axDNe9ibEdt0g4KLea69hY7QaR7s6
         PTyZzwbmUq4GGHn/jEuE/7ng+ez3DbGhW1UML2v0cgk2YS3Id1J1LXCe85wx8H2vj6d2
         6c65Oj0B/nThu+YMxslMd+QexxRY39ieY7/sg8rpXmEQ6bDfb02LFCzCA/PONXzC0e+q
         TBsqCxAwrvnR8SSJ3kkh/OEhozxZj0EsRVs+RQN4KNW1IhxMqRePuHH5MgLzsOXWYnff
         JfCg==
X-Gm-Message-State: AO0yUKV56eDOCNNZNc4xsb93TAPyHA3PLSSSbvypU++JqzNop0IMyAX/
        3UHqxXx4QaGAhBfhRk2D8COg7A==
X-Google-Smtp-Source: AK7set84FwJNdJl9mGQ0f2ILiLTlDqJ+BjGoFMVvUpKdj3rGKgH+rqsLjDFFttzRrryfwkUBOMiOiA==
X-Received: by 2002:a05:6a21:3385:b0:cd:238f:4f4b with SMTP id yy5-20020a056a21338500b000cd238f4f4bmr4095791pzb.23.1677878006092;
        Fri, 03 Mar 2023 13:13:26 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id v15-20020a62a50f000000b005b02ddd852dsm2083846pfm.142.2023.03.03.13.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:13:25 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:13:22 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 1/8] KVM: x86: Add kvm_permitted_xcr0()
Message-ID: <ZAJi8kqs39yCYPxq@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-2-aaronlewis@google.com>
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

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> Add the helper, kvm_permitted_xcr0(), to make it easier to filter
> the supported XCR0 before using it.
> 
> No functional changes intended.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
Reviewed-by: Mingwei Zhang <mizhang@google.com>
