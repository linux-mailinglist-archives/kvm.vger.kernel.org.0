Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425A9690F2B
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 18:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBIR1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 12:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBIR1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 12:27:51 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85601633C
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 09:27:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id be8so3602304plb.7
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 09:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mt8a0Rl3erq9+Dr/Cmy9rAt9EFtIjcwoFiRBF/7IB3I=;
        b=a/MPey0EqRCkzNnrvafc65sjTU46gsZEE0WSL2uobtUow7jWOj87hM9y/ehxQuEWTD
         t8rPofOJgJS8UHnCDM4U6WYpw7db7UH+kL65KD5jvJF2GTjv/SBv7PjebfFENUajWSDg
         qLyzOCUld75zaebYoQ/Buh28FtorlTX1VGfnOt1OI0CtuoAjA58KdEUkXM/V/LJg3b7a
         PghD3IcFU/V0sOQ1XQ0mJ1fmy3ukc5LHSz+wXCxSoJtcKnS0Z9LpCMJomYbP7naVplDd
         RqNsGz3pQVZO+qqOIjlAIqwKo93qC68udpSgHqKGRXgzzJGS1L0j7i/l4QgPWPA9q3GA
         gVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mt8a0Rl3erq9+Dr/Cmy9rAt9EFtIjcwoFiRBF/7IB3I=;
        b=o6ua+MjwQSBaxnVbe/hYv3oMUAX/o3nxdePLjvtXGEzLYDk8LG268T+MYrJFru0bdd
         qVP8TowS8Z9wwGssREast5f1fasN1AyhMGSilBLZPJyvJFPc9xb+FvMf1PP84B4fjoMH
         9C38BatvdNSzCv2AWERKLhsC5nMFEeae+Xl6eO/ff4DqYGKDY/a4UjVkpbLJPkrLNl5m
         F/p6mtlQw499CdZjN7UTiF/0BM4WioL7pbtQWXsUlrg0+vPUgvPgV9TKzU5EB0Li8lkv
         Z4fxJnpPu87jCsbvOv3AgzgFaVrdsys5xlQqEK2Q/kxj4aaQgMg/LnTS3RnIj3CNhsoc
         oFMw==
X-Gm-Message-State: AO0yUKXb0nuTp7dJJ7sevDfhHYAE08p6pABWxkaxxRslI1dGQSN4Nk9D
        oOep5n2+IorrtkhsR6YVCd86iA==
X-Google-Smtp-Source: AK7set8zkXvGrkMdAb4lAjOOw5urcslii+fxgorqc2AEfu3klDwJfc5HZoAwz8XccGV7TvhCHDeDeQ==
X-Received: by 2002:a17:902:db0e:b0:198:af50:e4e2 with SMTP id m14-20020a170902db0e00b00198af50e4e2mr177686plx.8.1675963668088;
        Thu, 09 Feb 2023 09:27:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jc12-20020a17090325cc00b001931c37da2dsm1766012plb.20.2023.02.09.09.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 09:27:47 -0800 (PST)
Date:   Thu, 9 Feb 2023 17:27:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        yu.c.zhang@linux.intel.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
Message-ID: <Y+UtDxPqIEeZ0sYH@google.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <Y+SPjkY87zzFqHLj@gao-cwp>
 <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
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

On Thu, Feb 09, 2023, Robert Hoo wrote:
> On Thu, 2023-02-09 at 14:15 +0800, Chao Gao wrote:
> > On Thu, Feb 09, 2023 at 10:40:13AM +0800, Robert Hoo wrote:
> > Please add a kvm-unit-test or kselftest for LAM, particularly for
> > operations (e.g., canonical check for supervisor pointers, toggle
> > CR4.LAM_SUP) which aren't covered by the test in Kirill's series.
> 
> OK, I can explore for kvm-unit-test in separate patch set.

Please make tests your top priority.  Without tests, I am not going to spend any
time reviewing this series, or any other hardware enabling series[*].  I don't
expect KVM specific tests for everything, i.e. it's ok to to rely things like
running VMs that utilize LAM and/or running LAM selftests in the guest, but I do
want a reasonably thorough explanation of how all the test pieces fit together to
validate KVM's implementation.

[*] https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com
