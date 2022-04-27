Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A959E510DC0
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348478AbiD0BKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240618AbiD0BKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:10:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCE25F8CC
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:07:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so2814871pje.1
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KS3ddZxfe0D8M3i7Q9GojLU+AJO05rtpc1S56kLC+K0=;
        b=rxDXGr1MrTrvYA+lvaTJN9sRk4tOaYKbT0tvupF2tfu557YQ36JjS3xInpWCIbIn5p
         wlj7dvbtiodWMtY3wIUv4d/YtypgJ1fHSXI0RT5LEQDBcArHTl0Xa1JVHbq28epmCc1h
         Utj2jgCMJRkLAXycYswt1AHCTQOXITIPk84H9sNmiLvMF+vBi7S0OZf9z9q1a8LS9c8w
         QpKnrQWu9gLtqWai0c14lxFs+bFgZoKF71aCIpimROZmLl5/2eH+CYH65TKYi3nFKanU
         vyuX4gUGzYlSYQ40R/uTPR9MNB7LvgrKfnOVgEN5ssSubZJSXQgYXXnk8Zn9UhCp4ng4
         Oj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KS3ddZxfe0D8M3i7Q9GojLU+AJO05rtpc1S56kLC+K0=;
        b=J8yEMhiGWu8Eg7roLKg7TOV2HEIGwnVUVI8ttda9vntFJvoyaEHifbgbsIGE/1EC6y
         4mg9WjYH9m9rB7o1fjYO/uUPhk3eNAnqTfQIw0p63dJp7gicttvu8PFEmER/wXLXfrbv
         O527cz2Q9MQYyqu4VAgNPyi2I/gc3xakKiYCC6Nw4ZuR1wbchJ5DzgNo7UQUq1dKYl5x
         4YtO/Iu2gptC6kNxu7fgooPBqByXv708nC8vgoo7MB5TEV4Z9UrjSW0MMe871JkG7BK1
         cNnIctLhAI8ohH51g2gFZEe9dOJKpxjL57BlTP56paN14evgTO1pAnQaLN+yiIDQzxE6
         UEPg==
X-Gm-Message-State: AOAM530Qom7dOAEq6tLua0aHDXWBHzgbdMQdf1+28wesawTY8ekz6o0w
        nIj9mP3HvgDs9wpf5XhMArn/Vg==
X-Google-Smtp-Source: ABdhPJw3+Oz4d/HGSaoEf/qRrjxlG25UEscPZ8shPamOnz9AQJRpC0kAsf4c2BccznU5xZVXArwScg==
X-Received: by 2002:a17:902:bd4a:b0:158:9eb3:2ce3 with SMTP id b10-20020a170902bd4a00b001589eb32ce3mr26128104plx.55.1651021632651;
        Tue, 26 Apr 2022 18:07:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j19-20020a056a00235300b0050a858af58fsm17716996pfj.145.2022.04.26.18.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:07:12 -0700 (PDT)
Date:   Wed, 27 Apr 2022 01:07:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: replace `int 0x20` with `syscall`
Message-ID: <YmiXPDLILqA6H79n@google.com>
References: <20220424070951.106990-1-darcy.sh@antgroup.com>
 <20220424070951.106990-2-darcy.sh@antgroup.com>
 <YmbFN6yKwnLDRdr8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmbFN6yKwnLDRdr8@google.com>
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

On Mon, Apr 25, 2022, Sean Christopherson wrote:
> On Sun, Apr 24, 2022, SU Hang wrote:
> 
> Why?  As gross as it is, I actually think INTn is a better option because it
> doesn't require writing multiple MSRs, and can work for both 64-bit and 32-bit KUT.
> The latter is currently a moot point since this code is 64-bit only, but the UMIP
> test _does_ support 32-bit, and it's do_ring3() should really be rolled into this
> framework.
> 
> Furthermore, we really should have a test to verify that KVM correctly emulates
> SYSCALL at CPL3 with EFER.SCE=0, and forcing EFER.SCE=1 just to get to CPL3 would
> make it impossible to utilize this framework for such a test.

And a concrete reason not to apply this patch: it causes the nVMX #AC test to fail:

  FAIL: #AC handled by L2
  FAIL: #AC handled by L1
