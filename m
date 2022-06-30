Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61AB561A52
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 14:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiF3M2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 08:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiF3M2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 08:28:09 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D2D2E093
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:28:04 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1048b8a38bbso25515481fac.12
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 05:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fars46ihWldzKhsiNp4tOcZid3mM1cwp7AwPJo3kkUU=;
        b=bTOtzm38zOtR3lMJW1aUnOeqOXAUTvOMcGRyLA35X+GYu3K7EZz4uGRDNM2vzbbqjh
         L7JLqK8qBPUQeSkSuoTYml3Gh8QEP6uFYZduWKa9pLcI7C5poyh5Yh7yoA/PMkxN2Uj9
         ioPX/n+0mjFoTzx7Q4v8Q2ApT8aBTBhAJ1mv8bNDH8O2G5H7aHRNvgJEiJqZb0XWexM2
         /7BLF+h9ajFd85J0ib+Ji8Tf/NF4utGZzBfrXV/tViCcEI2YY980y0HJFYgJrgnYRIlj
         Y6gY7n/JhxOtE3rhYHqU/joag5k2eFjwUXYfz9R7d7LpOVjy3XUCSuqCue7/n5RjaSYc
         RRXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fars46ihWldzKhsiNp4tOcZid3mM1cwp7AwPJo3kkUU=;
        b=eUnMO9SI2sl/gaN+GYmszCiVHIweAsq0ABDHrmTWwMIv2BGOGqkyeYyiKS+4v3Erx8
         mS5Kns7w8LwHd54L/2fNVOtF12qWniSXG0QNAFr5OfndV7nxKisCOlehmWP9+Zkd9jmR
         1Cw6TCKvgq/6rtH1ZcK+ueTbOqvereBYq10oZ2tcUYwFTXu6W5m9VbyTuuhiPMoDkPFt
         IS2yLb1myVVGIKmSl/i37qWE7Aa0cQQBFUx9VNLu83mvAfUZkWUCSs6F+7B83r3JUDiT
         5QkY1lox8d/ZtF2xASB089Qt3JYTQituJ8+c3c71Q2revI9fWZDnyzlCiWijtllAU3gB
         yeaA==
X-Gm-Message-State: AJIora/nOFns4xUXL6w0bmLG/V0xiEEXtEt7YvMMbiYu2OoQajejP/aY
        1bPDdvUG7aqDGXwowJxEJGT7///wMw8enIH3otdQXg==
X-Google-Smtp-Source: AGRyM1v1MxDC1t3LTB6jb9AsKX5TiYcjEhwXDUUunBTCUOP5R8BGTgMAFtLCPbF2ta6bXigG8/gfBLKUJSoOFCozPIU=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr6252583oab.112.1656592083389; Thu, 30
 Jun 2022 05:28:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-29-vkuznets@redhat.com>
 <CALMp9eRCbgYVGtAwpDWhytQSjeGeAOuqKZXVg3RpV92uKV5u0A@mail.gmail.com> <87tu82siuw.fsf@redhat.com>
In-Reply-To: <87tu82siuw.fsf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jun 2022 05:27:52 -0700
Message-ID: <CALMp9eQ+L1HPXcw1mysx3tYeN-=mGrZCxjZWDcJwtdfZZ6z8Dg@mail.gmail.com>
Subject: Re: [PATCH v2 28/28] KVM: nVMX: Use cached host MSR_IA32_VMX_MISC
 value for setting up nested MSR
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Jun 30, 2022 at 12:36 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Jim Mattson <jmattson@google.com> writes:
>
> > On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> vmcs_config has cased host MSR_IA32_VMX_MISC value, use it for setting
> >> up nested MSR_IA32_VMX_MISC in nested_vmx_setup_ctls_msrs() and avoid the
> >> redundant rdmsr().
> >>
> >> No (real) functional change intended.
> >
> > Just imaginary functional change? :-)
> >
>
> Well, yea) The assumption here is that MSR_IA32_VMX_MISC's value doesn't
> change underneath KVM, caching doesn't change anything then. It is, of
> course, possible that when KVM runs as a nested hypervisor on top of
> something else, it will observe different values. I truly hope this is
> purely imaginary :-)

It is also theoretically possible that a late-loadable microcode patch
could change the value of the MSR, but Intel wouldn't do that to us,
would they?
