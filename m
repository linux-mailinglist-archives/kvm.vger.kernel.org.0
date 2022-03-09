Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEDA4D38EA
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 19:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbiCIShL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiCIShK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 13:37:10 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DFC16F97D
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 10:36:10 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id h10so3563399oia.4
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 10:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8iMwrOtI+LFtrFbhkhVNCC/uOBQHXBnNjFzC1DvTtM=;
        b=IpmCotXa8tKYGH0gYOITZr+N6koJZ/F/CfEW0a/AxwxTKIQhq7gLjNJD1uQec1+k8f
         K32AFGVopArK4NWBcruyzEJgK60hU+qIowQVgBGQA1+xeV69Ve5QsSswDjqaHUGuAqYZ
         85E5cbuOIa/3YdA35eeG/pv4CrRRupWMJt5LI7PJX2DZyqoRG4mSafXux/0vTqaDOroL
         EvwPJqKZk8fefUgdQthFm7h3BteTrFWv56BFnTv/syUo40YofyIshiweIqnMc6BAtXT/
         acqWpmlgCo+iBXAN72hXByQu2ERMT+OezvrlGXVCUS/wjwjZ3pSGvUMIuNyoqtPU52Bw
         wMfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8iMwrOtI+LFtrFbhkhVNCC/uOBQHXBnNjFzC1DvTtM=;
        b=psxcpiDo0Uhd7FxFD6EwcAikwNAHpbI+qxvYCEtz6CtgU60y1gvjfFz/XH4J+NxXlH
         nhltWTJX+8JTudvFUEAkKEZzwE9YrEu43LT+qzVVPiMvjMXWpmskAYVFm7j9UwbG1ZyD
         SjEduwIEX3o11xjzlE0bKwi14AkcVECYjMpiy5anmk8aGTLS1syGhzbwikeyOKa7ssGL
         gSsxeKVDOD+4pUjx03aTDdKrttmXg4kEXeURUVa/tkY2EiBElX2WZ+cAZcDy48Xb8QMi
         bAISanGz/HuKf0IWoI5fbNRlKqhFNlvtgsHMJuQtXcbFl599u5MSCZCd4DJHED34Jrsm
         rK1Q==
X-Gm-Message-State: AOAM530w6suacAxCp4WYy9WjuThGa61R6LEmXUGVqyY5hEMNJktQ9/l9
        gXlPymndnuqjNg9/9SNCY4BBOSFlg0jQMsoEv8XHNg==
X-Google-Smtp-Source: ABdhPJwurfjKqG25XIm9UeHv36S6Eg2vUyQg6y7E2KtZaRUwZcLl0iflVGOD4NYqrgSmugKdO/pIP8Jc++hIOITqMXU=
X-Received: by 2002:aca:3f09:0:b0:2da:4be9:96a1 with SMTP id
 m9-20020aca3f09000000b002da4be996a1mr1070320oia.13.1646850969432; Wed, 09 Mar
 2022 10:36:09 -0800 (PST)
MIME-Version: 1.0
References: <20220301143650.143749-1-mlevitsk@redhat.com> <20220301143650.143749-5-mlevitsk@redhat.com>
In-Reply-To: <20220301143650.143749-5-mlevitsk@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Mar 2022 10:35:58 -0800
Message-ID: <CALMp9eRjY6sX0OEBeYw4RsQKSjKvXKWOqRe=GVoQnmjy6D8deg@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold and
 count when cpu_pm=on
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
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

On Tue, Mar 1, 2022 at 6:37 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> Allow L1 to use these settings if L0 disables PAUSE interception
> (AKA cpu_pm=on)
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

I didn't think pause filtering was virtualizable, since the value of
the internal counter isn't exposed on VM-exit.

On bare metal, for instance, assuming the hypervisor doesn't intercept
CPUID, the following code would quickly trigger a PAUSE #VMEXIT with
the filter count set to 2.

1:
pause
cpuid
jmp 1

Since L0 intercepts CPUID, however, L2 will exit to L0 on each loop
iteration, and when L0 resumes L2, the internal counter will be set to
2 again. L1 will never see a PAUSE #VMEXIT.

How do you handle this?
