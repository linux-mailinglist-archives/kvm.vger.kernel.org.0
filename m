Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3458C58B029
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiHETEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiHETEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:04:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1913B7B783
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:04:01 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t2so3419530ply.2
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BUYKpxJyiOtJFBunJ05WlmO0A1IF2A4Ebr5PfaULMVE=;
        b=OrqtE7X9d6ueps6hGET9eoykhba9z/Og3RcUy4atHyCTjtRtPGInxkHKq3PX3xFD6t
         8+N7dxWyle1388CQvl5O3QuOd53xeFtsPXw2e1jI2KdSTyWCzb1NldV/lwb32OefUP+Y
         yvnZxouU5BDQa+bB7LJyrKJKvKclP3DCPc+jomcCp1ERvCf/h86ZhGRRDEoa79M9tpBo
         FAz3k9PJbRtISWvDjd/aRQhMoWtoApxE6+6OGJm5ewoMRHUqTH4JMCNBV4VvPx02n45u
         ZLigAdAWqm8s1MapPhk1SSvszVsA9YLpi+bJUD8mdJ6cTYBsoo8LuE9CN7LGadu2xgnA
         6izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BUYKpxJyiOtJFBunJ05WlmO0A1IF2A4Ebr5PfaULMVE=;
        b=oXQVn4pE7P118eG4zVukjGsEVW79/Z7geDbb+IQ/0zD0aI7jd3NfA6KO1DXVd5Jspy
         zf2FqII4lx0mZZkKZnNuQsp+PDBKmSj9pmqnATVomXm2QY4S/wcy2JillkEO5kKD77ry
         BI0BBEi4ICdvKjI64Hxt+L8gH7+M0kn6ErTMk9FIAXYZWGNQAcpTDB/QcViWOa9QeNS9
         JqUV3h6lIkYCwV9kDP+90Ve99Mqh5pd3iDCsJgvPSafZ2t+y5KP4T4fvPGY5yYMaKgrD
         T/ob8WvQoEthBGOnnP+iijlXFWopZ3T6dr3Mt4Z2I+60BiynW541m7LpzseqiAPyjzyq
         2x9A==
X-Gm-Message-State: ACgBeo2Yk6CmqyHBJaef3JrgxeMxIKh6Ogn/5QKvxfX33ZUzzHnSA8pv
        gv4ztdnIyfB48xolG0qXXIOlQiwrf7/8JQ==
X-Google-Smtp-Source: AA6agR5/km+TzSr69vIvEj7V0e3pJmrmLDt+cb1/qZ4J5kBcek37Vab77wG5huCHoqHNjK6VGd0mPw==
X-Received: by 2002:a17:90b:180f:b0:1f4:e294:d322 with SMTP id lw15-20020a17090b180f00b001f4e294d322mr17555205pjb.163.1659726240448;
        Fri, 05 Aug 2022 12:04:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d50400b0016f12cc0ecdsm3425960plg.274.2022.08.05.12.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:04:00 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:03:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 3/6] KVM: Get an fd before creating the VM
Message-ID: <Yu1pnPkiAtOM80Jx@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-4-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720092259.3491733-4-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> Allocate a VM's fd at the very beginning of kvm_dev_ioctl_create_vm() so
> that KVM can use the fd value to generate strigns, e.g. for debugfs,

s/strigns/strings

> when creating and initializing the VM.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Typo aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
