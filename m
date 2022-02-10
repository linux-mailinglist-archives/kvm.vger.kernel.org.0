Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335E54B13EF
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 18:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245053AbiBJRMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 12:12:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239761AbiBJRMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 12:12:16 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD556E6E
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:12:16 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x15so8967653pfr.5
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 09:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1lVmIdPT7KTxg61LkVafGnAu8y+soi2FYSLquMI2dHQ=;
        b=V7JKyk1udAsyqRsAu366UMQjbG28qOhKcaKeq4l10ARRqPSsh+jXlPKbzBOS6Xi9Wr
         yxuYaCadvljSPqOWiwC38Ocpi+nMAZHSW3nQvRE0sXwtlFXxaKykVie4d4Q8ouhStvtO
         1iAu6Xtf3OpaZYuECrk/FC3w30aid9ax/yug1flPF1mlC9nzje/GF13WTmwmZeIJ0cjF
         vGxDwNR7WAkosoOxxuWfR4oUY+jBym15Os/6V6KykL5QSG2bhe4fsYBK2P7fC5QXhqll
         IpWFksA7iCtkNzE8pG0Ce1hnfWKDtQrF63p6hECr3x5NpMcERD/Vk6I/vRpo+FQxU5UG
         Gkcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1lVmIdPT7KTxg61LkVafGnAu8y+soi2FYSLquMI2dHQ=;
        b=dQH/tt63VVwMCDwSJW9QZkbbveYJYAxMICfH9n0tQ4eaWp0hStDtLP/HHwGW0gL4YR
         HYXfCwO8N6vXAS4KnnkjcDdEVIfuASxwpT0KwVxVEIS88ffBpmYuW5bsklBsGjZ8HCcz
         zpZUBwRxYHqE/QY5Ec/ZeX/3xRDu1Y9NsPxXUzNwmuVRUFE79dfldx/9gwbd1XQBTuUz
         Ln4v5GUQtc4dl9WU5XoXypcR6A67DoOfaGKlNaU7xqb6XBYse7WX8hdw5lLwNl+yzN5e
         KbkQRRzOgUQgfu9w1jWylkpavGme1ALkLoYXSIjGBkIVua5DYv2dMPstPVlbUl5Z+Si6
         OruA==
X-Gm-Message-State: AOAM533l0R7E2ZSFbhwWfTTVane7HwUK/GLTICcX+4Qh0wJmr/c0UIp4
        ySkpkbaYUxlxOpV33VDU2QTeWg==
X-Google-Smtp-Source: ABdhPJxUmbqcVgfzOxybpLonGXtjzuulc35EMKexlnqw7VAzpge1/7d5xSC+1PlkbRRnc5u6k6JXaQ==
X-Received: by 2002:a63:5503:: with SMTP id j3mr3148876pgb.378.1644513136146;
        Thu, 10 Feb 2022 09:12:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l12sm25221731pfc.182.2022.02.10.09.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:12:15 -0800 (PST)
Date:   Thu, 10 Feb 2022 17:12:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     David Dunn <daviddunn@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: KVM: x86: Reconsider the current approach of vPMU
Message-ID: <YgVHawnQWuSAk+C1@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <2db2ebbe-e552-b974-fc77-870d958465ba@gmail.com>
 <YgPCm1WIt9dHuoEo@hirez.programming.kicks-ass.net>
 <YgQrWHCNG/s4EWFf@google.com>
 <39b64c56-bc8d-272d-da92-5aa29e54cdaf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b64c56-bc8d-272d-da92-5aa29e54cdaf@gmail.com>
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

On Thu, Feb 10, 2022, Like Xu wrote:
> On 10/2/2022 5:00 am, Sean Christopherson wrote:
> > On Wed, Feb 09, 2022, Peter Zijlstra wrote:
> > > Guests must not unilaterally steal the PMU.
> > 
> > The proposal is to add an option to allow userspace to gift the PMU to the guest,
> 
> Please define the verb "gift" in more details.

Add a knob that allows host userspace to control toggle between host perf having
sole ownership of the PMU, versus ownership of the PMU being "gifted" to KVM guests
upon VM-Entry and returned back to the host at VM-Exit.

IIUC, it's the same idea as PT's PT_MODE_HOST_GUEST mode, just applied to the PMU.

By default, the host would have sole ownership, and access to the knob would be
restricted appropriately.  KVM would disallow creation any VM that requires
joint ownership, e.g. launching a TDX guest would require the knob to be enabled.

> How do we balance the performance data collection needs of the
> 'hypervisor user space' and the 'system-wide profiler user space' ?

If host userspace enables the knob and transitions into a joint ownership mode,
then host userspace is explicitly acknowledging that it will no longer be able
to profile KVM guests.

Balancing between host and guest then gets factored into VM placement, e.g. VMs
that need or are paying for access to the PMU can only land on systems that are
configured for joint ownership.  If profiling the guest from the host is important,
then place those guests only on hosts with sole ownership.
