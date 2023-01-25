Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E995067A808
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 01:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbjAYAzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 19:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbjAYAzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 19:55:17 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDAF4FCD3
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:55:14 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w2so12380779pfc.11
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j0YF0rWx8S9a0HEtMkweR4tK/cDvp3r9Bqf6MxKm/rI=;
        b=iJdyzVPzXz7h7S2WmtKKe+sd89SWrr9Ja4izpE/zN0otMQqHEA3Y/IPBHZPQT5xz6+
         pYIZQ35132YOfOcYSwSquRJy6ykUFEUE5dm8kPf9IL601tHGdSl/8UiKcovVtgHIWUNu
         FBD37YuIHNIszZ9y223b4NON1cKk/h2iO8W1vdgz4pptrCQP91idtwlpS54fEcfh572Y
         Tz3+vaNovlgYsC/YS4r8tctZ5qgkozwrI84kyaJ83rbzxqJccOo4mQp+mI1AIG1HlI0H
         51sDPRqpO2e7idF9lwlJBH7V7nsBb0nx/LKFYaj4nWxHXXzSsRPJvFsNwn8HVIndmVaY
         xl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0YF0rWx8S9a0HEtMkweR4tK/cDvp3r9Bqf6MxKm/rI=;
        b=ps/4WNQ+WWs/KC0T7RruIAHDBAzfbHSRDqpYCecdzjulbffaHhgJG+QEDDkgApa/PW
         VgRyiIuVeWWxWaND79C3Hx3S8T6q9n3kBsyVtyhXFODzZP90F2rzkGqbpmWgMJpy6/rG
         hqlrkVYfoe4CcmIYfWLaTc5CR759AY5HxdcVaSqMVbWi9T9gyJ5fq0qkpfR5ibDuffgK
         D8WxWE40eHjOXkm8tpCKXU/B/Ck45jTDBDKY138VhfQS4MzUc4Z5fjv9dD+auRfhs8DT
         E1Rhz3ICFv/tgF5GrCT/s+e/9xweUWsXvAXQij9ShDwxFStWKUz8PldnLuTfIsrAi+e8
         bIiw==
X-Gm-Message-State: AO0yUKUb87UXyeAQhjRvFvatyqgc6BbAa178jDgsPhdXBlsxTXnY3EnN
        hwFbPFQSFVddH1Ov9BWmu0ogfw==
X-Google-Smtp-Source: AK7set96ycG9wMPCfmKtz1r3i9fIEVzq+oHYyjZvNRqCKM8r+LLhsBZ/PuMv3+HddeGW9X3vMp2Log==
X-Received: by 2002:a05:6a00:23cb:b0:581:bfac:7a52 with SMTP id g11-20020a056a0023cb00b00581bfac7a52mr465724pfc.1.1674608113769;
        Tue, 24 Jan 2023 16:55:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f20-20020a056a0022d400b005877d374069sm2288340pfj.10.2023.01.24.16.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:55:13 -0800 (PST)
Date:   Wed, 25 Jan 2023 00:55:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com
Subject: Re: [RFC PATCH 0/7] SVM guest shadow stack support
Message-ID: <Y9B97dZnFnjEHhVf@google.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
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

On Wed, Oct 12, 2022, John Allen wrote:
> AMD Zen3 and newer processors support shadow stack, a feature designed to
> protect against ROP (return-oriented programming) attacks in which an attacker
> manipulates return addresses on the call stack in order to execute arbitrary
> code. To prevent this, shadow stacks can be allocated that are only used by
> control transfer and return instructions. When a CALL instruction is issued, it
> writes the return address to both the program stack and the shadow stack. When
> the subsequent RET instruction is issued, it pops the return address from both
> stacks and compares them. If the addresses don't match, a control-protection
> exception is raised.
> 
> Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
> collectively referred to as Control-flow Enforcement Technology (CET). However,
> current AMD processors only support shadow stack and not IBT.
> 
> This series adds support for shadow stack in SVM guests and builds upon the
> support added in the CET guest support patch series [1] and the CET kernel
> patch series [2]. Additional patches are required to support shadow stack
> enabled guests in qemu [3] and glibc [4].
> 
> [1]: CET guest support patches
> https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/
> 
> [2]: Latest CET kernel patches
> https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/

That dependency chain makes me sad.

Outside of a very shallow comment on the last patch, I don't plan on reviewing
this until the kernel side of things gets out of our way.  When that finally
does happen, I'll definitely prioritize reviewing and merging this and the KVM
Intel series.  I'd love to see this land.

Sorry :-(
