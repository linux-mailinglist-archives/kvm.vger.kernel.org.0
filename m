Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B835A71F4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiH3Xme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiH3Xmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:42:32 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71CC58B58
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:42:31 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11f34610d4aso9746443fac.9
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=a74GqF8BVSSf3zmpTawpIfOrUFDwFz4s6FZjfrHKGTM=;
        b=R0aCs+4rk5LHgCsGhsdlyytOC9oIPZcfLj4d7VpCXfC0xU37FNDSXDS6tguRePwR8H
         D5ngX36wAjA7qJ7XJhfr31qXzupvVNBDl0QK5UvZqYUornswn40JV44j5gVBs3oFuR95
         LCOW89W2rzfzWO2EaI3ClpYrW20oXV3GrC/icjXJOw2d8YurpnOM6hvjCq+OzzJxwCCc
         PsYxS4EC6TEn/LzNUpYiLP4GXX8QJceYEjeGabFV57g8MZ7zAy3Jrmn8FfJqBuebrcWA
         L76O2mk0JOvryGahNpua4iKlYdGV9ZocVIgPkefFwlg4fKqbA8WKMAMNsDgt+JGRH6Go
         wLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=a74GqF8BVSSf3zmpTawpIfOrUFDwFz4s6FZjfrHKGTM=;
        b=OA5VhvDA/wYs/GVO/A72chfKL+hnIjr/Xiiz3hJlJklZ4XgOF3niys911RLU3dYEXM
         rBjwyf8OgZWwuJ6IvkFK6CP/cw6ti/EjJwMKvqtYtqFjHfkTU7EY3yWpuMXer2uyYI/7
         V7OVIjw9txQV4bjQFM8z0rQ0gcbOIFVrM5FgmL2mEVvJ/txRt32YIlM3uRNQqxQjijB8
         ZpJulKy5AUkG42TggDaDYGTO94BstsOSE0v0uCd3zVFRJh5MK5W0iL9E19agDTicH29T
         JRR0YUN0lFVSjnRj2cYlEtEV9UTPQbAsQEgLFZKmSqAhcxbJ1nZXBGODGkmefIy+Uzgt
         pZwg==
X-Gm-Message-State: ACgBeo216eyr5PGFsgsyo8+UtgtBQbbv03AyslswbgoBayqOlbIr7yqH
        I0MSarodukTjlsvchU+I2gwS/iJ5zOusOMDE/1N1zi0CiEB7Sg==
X-Google-Smtp-Source: AA6agR7Ntcix8731lkV5hLa80AqqOc60Q9gCp0OmYpnPW7nqQCRXKjP0vl5xReGeMfxSJ4uPxL2MAKGMVyxI/h/MT+U=
X-Received: by 2002:a05:6808:150f:b0:343:3202:91cf with SMTP id
 u15-20020a056808150f00b00343320291cfmr182383oiw.112.1661902950074; Tue, 30
 Aug 2022 16:42:30 -0700 (PDT)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 Aug 2022 16:42:19 -0700
Message-ID: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
Subject: BHB-clearing on VM-exit
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

Don't we need a software BHB-clearing sequence on VM-exit for Intel
parts that don't report IA32_ARCH_CAPABILITIES.BHI_NO? What am I
missing?

https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html
