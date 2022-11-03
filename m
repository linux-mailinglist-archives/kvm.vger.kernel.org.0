Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6CC618B5E
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiKCWZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiKCWZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:25:37 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A796617D
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:25:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id v17so3278854plo.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 15:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PO6xlmxvka0CVGc5nO1Kud7KkxoU59ZTMUWaXaIsCuU=;
        b=b9tUlcxIEtOZfXUQNLUzylQxZJ6cIokU+gy0w+a+x5jfcDQZxyD/+L7ft0n4KmSSOP
         UgoR/NIvpT31Zrc1i9HIoGAx02lJTRZosFC3UfwuxRwDeh6k32j14kjfL7MkfEM6vSyu
         +JRQ9SRZXxwYLr2Bb42boUmTG7Ol9QvH3/sxOjSO+LMLQxnNVwxZAQyG9NAgUPnkuJtL
         PrHtehXJfAkInlWF8gfMdsmk7yjtqX2LX0gX4SZJxqBp16STqiRyTzf9XsLspr3GlPLk
         ZuZWwuFkTYc0j+1Fve0J+HhbfA7/tXKVgicAOqUZB3s6teQWv7u0Gz6Aa+rNRoHtv8Ot
         j6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PO6xlmxvka0CVGc5nO1Kud7KkxoU59ZTMUWaXaIsCuU=;
        b=nkj0HNXNv6Sb1kBlw4mYY+diws1cDmx8LbIzdK1MKT26HDt4HONqmciIgVc8Xl/G7g
         vvAUEr32g1O+j0fVKGJ8wKCGe9nPgcBXIZrlAUSoFVyDbbTa9m1koFdzkU/oLm7tXO+p
         +FPQ51dUm9IpO6d3slsB0RfkGdEeXtPnR4yKzvQKl0okKxslDc3qNtn1lQQHQqKrkagx
         i3qA8XmEZAi+MHDcdsIy3ZrhD1WVu6SeftX9ONDAeOF/EG3P18dpE01bMPNSNw9wwTGa
         TYGjMnRsFKSoMLrL8xNdzl9hYrh1Mx5KuZldTMIrFrp7trwtZdBvmD+QBx8QtjwAqNqN
         YBHA==
X-Gm-Message-State: ACrzQf3nXypIS+YI2liq/S0Z7eOER5LlmGVgOlDkmJDqjJqp+2dopcc8
        csyDv0UwUstJtYSeU2hYOolC2J6O0qb5Jw==
X-Google-Smtp-Source: AMsMyM68njOrKyWTO4YrkdUs2xYcRNgqXrvH8bSZ6MYrY73blOQTr3+/xBM64zpqs7VbDcKa//4mpQ==
X-Received: by 2002:a17:902:ef43:b0:186:99be:2ee9 with SMTP id e3-20020a170902ef4300b0018699be2ee9mr32322793plx.148.1667514336592;
        Thu, 03 Nov 2022 15:25:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 3-20020a621703000000b0056ba02feda1sm1288792pfx.94.2022.11.03.15.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:25:36 -0700 (PDT)
Date:   Thu, 3 Nov 2022 22:25:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     jarkko@kernel.org, Harald Hoyer <harald@profian.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Only dump VSMA to klog for debugging
Message-ID: <Y2Q/3A1DSzSJkRAy@google.com>
References: <20221103210421.359837-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103210421.359837-1-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022, Peter Gonda wrote:
> The KERN_CONT documentation says it defaults back to KERNL_DEFAULT if the

State what actually happens.  Documentation is sometimes wrong, and just saying
"the docs say XYZ" makes it sound like this is a fix based on code inspection,
whereas you encountered a real problem.  E.g.

  Explicitly print the VMSA dump at KERN_DEBUG log level, KERN_CONT uses
  KERNEL_DEFAULT if the previous log line has a newline, i.e. if there's
  nothing to continuing, and as a result the VMSA gets dumped when it
  shouldn't.

> previous log line has a newline. So switch from KERN_CONT to
> print_hex_dump_debug().

Jarkko pointed this out in the original submission, but the buggy patch got queued
without the fixup.  This is a good opportunity to throw in a link so that it's
clear that the change is aligned with the original intent.

  Link: https://lore.kernel.org/all/YuPMeWX4uuR1Tz3M@kernel.org

> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Harald Hoyer <harald@profian.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> Fixes: 6fac42f127b8 ("KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog")

Fixes: usually goes before everything else, and this should probably Cc stable@
as well.

With the above tweaks,

Reviewed-by: Sean Christopherson <seanjc@google.com>
