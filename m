Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A49E5A996F
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 15:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiIANxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 09:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiIANxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 09:53:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4832B1
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 06:53:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p8-20020a17090ad30800b001fdfc8c7567so5567468pju.1
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 06:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ErJ0HYTeWtEwPWkKjxUMjvfOzkq3x7pnzQs4DfaztQI=;
        b=gVBhlXo+kWUOUAdPW/8QSC/spoR7aDlJ+7CKxJMA9X4LfDMCbY0jOUYmO6zAh3erUc
         oDX28M1zm7XifH6YMEdep0LvM0DAR1RzZHK1dKgbF41FQwrbtMpSsXNHw8GmdWQmPLoR
         feQD2gsEzTxU2EY8Nh9t0hdI4ycnocSPLPo1OcTMrlIpjH6dPDOFTlzq+GCed9ZkdD7O
         2QH4VVZY1+/PuOV8c/EZxWWqQTLedlbdpCU4hEVh2OKSofLAKmn/mCoi53a+yjT8c/Kj
         z+FG2shz1RwkAqnaACpuZdnx6ThYZcxNI1PMQxDakoPYcFYBvOhi+ZLBfGSZ+ygoClXr
         2mHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ErJ0HYTeWtEwPWkKjxUMjvfOzkq3x7pnzQs4DfaztQI=;
        b=ea9Ss2Y1VKIWmVC/6Z3G+hkal6kkJhJ1Qn319hjOl3WcbvvPfuBZ3ShwUKW2AMssvU
         ttNgoe/Anygfp9HCpxkiaivQe3Rq7wv6z4thN5rO4T1rKcYNg7vUfh/DKCNJHqNnvPHZ
         Ba3skDLMXGClPojsvDjC0hwpcvTHQbq+yKIRJ1wl8QSLxB1K3nTrKpTMFjT7+25Ym3U/
         yuItCMhmdOp9r0D1rhb6vERWEy90su8a9Ky9vZ16+1DaLQ61hCPTGY/owFkigEo0rUBz
         y3j/soI1yMADPw402KGMb6upS8u9E3sU/4Ko1oHixO8mCfp1ZntNHXdSEMUPDY7CNY0p
         7XbQ==
X-Gm-Message-State: ACgBeo3Llxi6gQJUpXcwZUnaZ6ayradK6lhEZGpqzEOnSNTSmj7Ch4oj
        tjnZ3LlZ4n0gVZz3nHUBJrXnBw==
X-Google-Smtp-Source: AA6agR4Z7Z7RmmgguQab7+M3a9D+IP8AxhQm8Xs9dhC8dxIBwXv55n3Xcy8OAa6q4QCV1g5i38p46g==
X-Received: by 2002:a17:902:7845:b0:16e:d647:a66c with SMTP id e5-20020a170902784500b0016ed647a66cmr29779570pln.64.1662040412275;
        Thu, 01 Sep 2022 06:53:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k88-20020a17090a3ee100b001fd86f8dc03sm3359852pjc.8.2022.09.01.06.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:53:31 -0700 (PDT)
Date:   Thu, 1 Sep 2022 13:53:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
Message-ID: <YxC5WI9BW+dVyXw/@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-4-seanjc@google.com>
 <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
 <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
 <Yw+MYLyVXvxmbIRY@google.com>
 <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
 <Yw+yjo4TMDYnyAt+@google.com>
 <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
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

On Thu, Sep 01, 2022, Maxim Levitsky wrote:
> There was actually a patch series that was fixing it, but you said, just like me,
> that it is not worth it, better to have an errata in KVM, since guest should not use
> this info anyway. I didn't object to it, and neither I do now, but as you see,
> you also sometimes agree that going 100% to the spec is not worth it.
> 
> 
> I hope you understand me.

Yep.

And rereading what I wrote...  I didn't intend to imply that you personally aren't
operating in "good faith" or whatever is the right terminology.  What I was trying
to explain is why I sometimes speak in absolutes.  When there is a bug/regression
and KVM is clearly violating spec, it's not a matter of opinion; KVM is broken and
needs to be fixed.

Of course, one could argue that that's an opinion in and of itself...
