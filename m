Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF305BB537
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIQBLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 21:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIQBLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 21:11:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4988B98D
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:11:44 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h188so21822843pgc.12
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 18:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=n13QfpMRXmDif9Ywxtk6V+caQ5bgGbqn2A0+iIQn+tY=;
        b=qfLW6F3pou51VzTJ/QQ0Pwe6CKNy5zHahGOLfniT+u8khdm4jo1kxuRCM79N/0HyX2
         mdDOeeCGadOrIebMCsjDcEx+UvnxNAqyw6icMgqQi35WQKCopCQnLVctGe72tv5pZJAB
         ydz7M4Us/1MwczwjsNnFU7igVoS6nA9nZVbV/IgVQHOF9GHWbWxDNF2wDYc0a7vMa3B/
         xOztEEIFh7NlTbmr8ISMoW1MLcbgvOxIvpehIUGG77sBNlDpeMpVmLNOrYPE6DCKXaWu
         zvR1Rz78zbboKaofQ1vfxa+OUpgx5flMBrZlfpd4L+oA/jkzDIFVQkuuKb9bH16ZhZk4
         KZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=n13QfpMRXmDif9Ywxtk6V+caQ5bgGbqn2A0+iIQn+tY=;
        b=PXZInK6XwVsfWc2ewpmXM5F2bHItYQlsMWXSiy3tul3f1Jp7AidBNSL77PlaB2EHmo
         ji4ioXlv8nv0+0jy+FSRoL7bziqpcfAhHkok41X87hwaRJNbAwkY07MoRYdpdt+ZHeZs
         d1A/jvDxq2a/8vG1O4lwKSWMAmhV+Uan9+Qj0WSEugDHAXDHVKb7u1aRoByvrkjgkovJ
         yYrvxBAG/tPt7LFuyfc+lht38MqVEYj02trZQxWmJB2Kz8BfqQOhu8jhpWt0idbJvWDc
         OJU/3Zx1WpomHh4TezwN75KbH3G5vHRiEE+rsV4G99ol3DHYQvo0HDEIT/AGEtGw2+LT
         4Czw==
X-Gm-Message-State: ACrzQf0CnfWBA6PWQXACwMXFFx4Xns6EPoXeU9bMgQgm1oee3+cLgB+p
        xQpiImqAlzFbkgQQk60OT02GWg==
X-Google-Smtp-Source: AMsMyM4kI354lqIKYGsxpElBQcSqRNND/4C9RtIg6LWogqDiQy5mexXv5di4E2fDO2qy88aBtkCQtw==
X-Received: by 2002:a63:4e5e:0:b0:439:a09d:92eb with SMTP id o30-20020a634e5e000000b00439a09d92ebmr6723155pgl.369.1663377104335;
        Fri, 16 Sep 2022 18:11:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 133-20020a62198b000000b005321340753fsm15175215pfz.103.2022.09.16.18.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 18:11:43 -0700 (PDT)
Date:   Sat, 17 Sep 2022 01:11:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v4 0/5]  KVM: x86: Intel LBR related perf cleanups
Message-ID: <YyUezO4WQSArXPI+@google.com>
References: <20220901173258.925729-1-seanjc@google.com>
 <Yxnx8InRcF94zi0n@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxnx8InRcF94zi0n@hirez.programming.kicks-ass.net>
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

On Thu, Sep 08, 2022, Peter Zijlstra wrote:
> On Thu, Sep 01, 2022 at 05:32:53PM +0000, Sean Christopherson wrote:
> 
> > Sean Christopherson (5):
> >   perf/x86/core: Remove unnecessary stubs provided for KVM-only helpers
> >   perf/x86/core: Drop the unnecessary return value from
> >     x86_perf_get_lbr()
> >   KVM: VMX: Move vmx_get_perf_capabilities() definition to vmx.c
> >   KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
> >   KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs
> 
> These look good to me; how do you want this routed, if through the KVM
> tree:
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks!  If you don't anticipate conflicts in the perf headers, I'll take 'em
through KVM, patch 01 introduced a new warning that I need to resolve (hopefully
it doesn't throw a wrench into things).
