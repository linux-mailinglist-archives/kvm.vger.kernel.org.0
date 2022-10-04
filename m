Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BC75F492F
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 20:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiJDSWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 14:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJDSWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 14:22:10 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF0557E39
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 11:22:09 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id m11-20020a4aab8b000000b00476743c0743so9320736oon.10
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pjPqPtWhi1XRi39ewNA3ilgZVEPOXvL7Gk41mzKrCKc=;
        b=qlUzFD59c5iepU8YIIkyWn198JUABfqxyCGoBSEcQyq1q0/EpPAAIDlrbRdAzf/nEV
         ZG3j4siZlQc3qVQ4MttYi+dagV0zdFz5dzh+CnVoz4ptytRUkiq3C/h1x/T5cpyDgjUL
         MZTWvN806z0IoQotFx4pJlDwKtxFcByBhcfWZ7aKeEXi6H6WZck6lI/Szs8oMA21zcid
         3bLExwLhqelYkCsnfzP1cM8XDWo3ygIMHxwPbOaz5uq9UQYFYW+nl/4GQUaD1x+gcZBB
         7RhrtxViMBK4ULtWL+EqGgz9/wpX+hfCZBVzCEaQIZE+Qa2WQg2uttlOAxMXMue/n4kJ
         cD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pjPqPtWhi1XRi39ewNA3ilgZVEPOXvL7Gk41mzKrCKc=;
        b=GIftPTLWwFw7Mx0dkZ1nXvyToAS0nOTdyi1q8ddg0t7LhJEY8623YEp/IgBKGvDbrN
         aG8FXB/0D3uXB03lyTHxszhWuAfcJoxk5OzfdA/FzhaeSKpG6MAmbaKNvBaxloVSHxWU
         yR+a2IdlbYtl3InRyQEDkuHmxsYYh4yamEVfbKjafNGUuo+Bqt4WNywZ7S41hKCPQPxG
         xXXc6lvb7J/R7XuWX4duIrZZOGfpIdjYs8vBAsCFOJA7nMBFy4biTk7Xdyw77RiF5k6S
         l9pGbAlGvXzABuGH4r4ye4j0b00cI9HBp1n3nJ6KXJnt12lW50UwO+4EL5wi+ol+TGoD
         /4uw==
X-Gm-Message-State: ACrzQf0LgilyCdEO36SYH/HUo5LvkWwQnbMjHavCKTNCKwpUOtFQ4XoP
        PBdo1376cns10V7QuZWSiZ3yIffBmGhbXR1dkjxU9KG5BK8=
X-Google-Smtp-Source: AMsMyM4am+nVPEHPqmOdvpPpMnN46oy1DA1DJItnPfIOgT4WdacXo476dek5DVbFcztiC7Kk6fed6vhYc90uIFURkQ0=
X-Received: by 2002:a05:6830:2705:b0:659:ebb0:ecad with SMTP id
 j5-20020a056830270500b00659ebb0ecadmr10055063otu.75.1664907728427; Tue, 04
 Oct 2022 11:22:08 -0700 (PDT)
MIME-Version: 1.0
References: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
In-Reply-To: <547a1203-0339-7ad2-9505-eab027046298@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 Oct 2022 11:21:57 -0700
Message-ID: <CALMp9eRTp9Jemy91o0S9Fz4JYFdQ5rM36g4uWhp5LsncCQHRwA@mail.gmail.com>
Subject: Re: Finish removing MPX from arch/x86?
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Oct 4, 2022 at 10:45 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> We zapped the userspace MPX ABIs and most of its supporting code in here:
>
>         45fc24e89b7c ("x86/mpx: remove MPX from arch/x86")
>
> But, the XSAVE enabling and KVM code were left in place.  This let folks
> at least keep running guests with MPX.
>
> It's been a couple of years and I don't think I've had a single person
> opine about the loss of MPX.  Intel also followed through and there's no
> MPX to be found on newer CPUs like my "Tiger Lake" 11th Gen Intel(R)
> Core(TM) i7-1165G7.
>
> Is it time to zap MPX from arch/x86/kvm/?

Until Google Cloud retires all of our MPX-capable hardware, we will
require MPX support in KVM.

Removing that support would leave VMs with MPX enabled in XCR0 with
nowhere to go.
