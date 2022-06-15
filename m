Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C453654D38E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 23:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346316AbiFOVUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 17:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiFOVUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 17:20:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C4C5548E
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:20:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so3177485pjg.5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bZ2jijzUr9kP3/+ZB7xrTeqibuRh4MlSOX5jIQq32bA=;
        b=hGrtgly/BOuSL45qMp6NrqVzp7fv+eS2iXR3r0BTW8yJJPS/eeZb0GCsR/HW8IjMHX
         GMNra6ylJThbP7YVHHn76cObux4NeOI158i+A3PvD/c98qtxWvA/XsD0PcJnwZuOgBAC
         eBlSAMv/ClM304Os1PeT0YaWY2yH0F5yqkmlRoEF1RXjaK7oDQO5pgxJboCTpYcXv+Qo
         nxFsIU0Kn73DoamB8RxVEM2BXyEzDbvgVbdnt5kU1GV8mx7gVeaCbGNbg877chHsvKnA
         l79rZK4Eyal+Wjcdj0SY7q8yfAfYhuDLR4TupWoJYTCWwebWWXjEgmAagc5mcdHY8ZNx
         H/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bZ2jijzUr9kP3/+ZB7xrTeqibuRh4MlSOX5jIQq32bA=;
        b=QGqrG6E5dv4H1BtJwkB+RNpzj9c7Qwug3cpFIvTkkDhJ/w8anaj+ixD+tMLo/ctCbO
         f/4Mjfjp+EQwefh3+/dA0PYowyOdiPA3rejlDmXdQm6jiR2Daxldc/yDSvoxmLAViP65
         ubC98Y1dFGXhz6QXqd8iaGazOneGIUvssBT9hSuIu116X8ky6Nz/VC8gO+z//TRRSxYs
         yRSNVnxYP7LcpGLmudMvmcnWpaMOI04upWrOrR6RQm2UC2Hi44PqdmojZQXW9yqncoAg
         wriuyIrLGG1+rzVOD5coTZmoM9iK2m1ljj2CCQmJuCbXLPWzMXs+8RKJ1Py/UF/zRpJN
         iQAg==
X-Gm-Message-State: AJIora+L1VIYBK04Ygzfnrpr54lIcMgbqj70FUvk6iP0HnxV1nIhsba/
        LSxdxbncM7NgG5u8C9fljd58eM3cUCDwHw==
X-Google-Smtp-Source: AGRyM1uC97bspuSAdV15Dx6QqXD59NMwG9t5kOqV7nxRMHiwvAn8FuG8UtWsDnNQiJPRsqs/wWroJQ==
X-Received: by 2002:a17:90b:4c10:b0:1e8:d377:4998 with SMTP id na16-20020a17090b4c1000b001e8d3774998mr12453231pjb.227.1655328039337;
        Wed, 15 Jun 2022 14:20:39 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090a931200b001e8875e3326sm2249512pjo.47.2022.06.15.14.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:20:39 -0700 (PDT)
Date:   Wed, 15 Jun 2022 21:20:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 02/11] x86: Move ap_init() to smp.c
Message-ID: <YqpNI9nXv1RKmn7T@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-3-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426114352.1262-3-varad.gautam@suse.com>
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

On Tue, Apr 26, 2022, Varad Gautam wrote:
> +	printf("smp: waiting for %d APs\n", _cpu_count - 1);
> +	while (_cpu_count != atomic_read(&cpu_online_count)) {

Curly braces aren't needed.  And to make this more robust, I think it makes sense
to do cpu_relax() in the loop so that it's more obvious that this is busy waiting.
