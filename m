Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F19455E848
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347673AbiF1QCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 12:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348124AbiF1QCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 12:02:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E90F13701A
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656432100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JGJSJfbr5IZYXtadU3vbyg4xqHn1JyJrxNS5REcEGD0=;
        b=frTryki/2ehmsSk95bOVZvkMgTSf8Jw/0nI1SUiTYutFx9nK1O9DdHv+q79r4XwLt/gV5H
        vSh5QLgifPVA0Ei0QNtuZn+ES3FHwSF8i1U0rACN/iAgo5B003QkNauzf8xJSSUY1cT/32
        Ku5jVf21yt5u0GiKVrM2dmF2KdGJlQE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-RlTj9u1AOEaJaDoyOm0l8g-1; Tue, 28 Jun 2022 12:01:38 -0400
X-MC-Unique: RlTj9u1AOEaJaDoyOm0l8g-1
Received: by mail-wm1-f72.google.com with SMTP id p24-20020a05600c1d9800b0039c51c2da19so5982657wms.0
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 09:01:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JGJSJfbr5IZYXtadU3vbyg4xqHn1JyJrxNS5REcEGD0=;
        b=C5Pq8A2GRRL9asHdRtk8CnOGf7NPZ2NjRmKAOPP2VxE2CG26a7/yOQNaxfbn53pApc
         1k3Y6Qi4UpajLUg5f/G70iFt+/vZDRuhTmVOnWzHXgxe4yQ7Bip2dDIa3ECMU8bHTmEe
         6RyClcftkWwVp+BEkd3QTWuSL+FAHRajK66inDCcLTPFuuRTSexJUrUuecpbVqlU+9Fw
         a1o96Of/9pZdq+5+2YyDx/QjeRiM1yspru32R9aClY8V3afUvfO1Fcb7wBFutO0mttbi
         6TjTe1QWwq3SaCb7sWd2TRBIDKO8dhiD1+N0oMdDiJivk6EkCrME+GZeL56pDawSYlsH
         51gQ==
X-Gm-Message-State: AJIora9e//eFj6JezD57/bILPurfxNaKCo4/ZXTvArPvcFKTVmVWoFam
        p2XqdBgAICyeXUE3hJmu9qP+57ZFdLfgwLhFQwCA6Nxgr+kpaPd67ohdB1rW9Pnyn2pwo76xNtH
        vPgLD3O/2bFti
X-Received: by 2002:a05:6000:1f81:b0:21b:a1b5:776 with SMTP id bw1-20020a0560001f8100b0021ba1b50776mr17518003wrb.201.1656432096919;
        Tue, 28 Jun 2022 09:01:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sA2iKj4+d2oyW9nuIAY6VibtPWKOXWK1EHitza3iry3e5bn2dFQxdxpa4VzAIODzGDvB5VAQ==
X-Received: by 2002:a05:6000:1f81:b0:21b:a1b5:776 with SMTP id bw1-20020a0560001f8100b0021ba1b50776mr17517967wrb.201.1656432096618;
        Tue, 28 Jun 2022 09:01:36 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d5588000000b002102f2fac37sm14097073wrv.51.2022.06.28.09.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:01:35 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested
 VMX MSRs
In-Reply-To: <CALMp9eSBLcvuNDquvSfUnaF3S3f4ZkzqDRSsz-v93ZeX=xnssg@mail.gmail.com>
References: <20220627160440.31857-1-vkuznets@redhat.com>
 <CALMp9eQL2a+mStk-cLwVX6NVqwAso2UYxAO7UD=Xi2TSGwUM2A@mail.gmail.com>
 <87y1xgubot.fsf@redhat.com>
 <CALMp9eSBLcvuNDquvSfUnaF3S3f4ZkzqDRSsz-v93ZeX=xnssg@mail.gmail.com>
Date:   Tue, 28 Jun 2022 18:01:34 +0200
Message-ID: <87letgu68x.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Tue, Jun 28, 2022 at 7:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>

...

>> Jim Mattson <jmattson@google.com> writes:
>>
>> > Just checking that this doesn't introduce any backwards-compatibility
>> > issues. That is, all features that were reported as being available in
>> > the past should still be available moving forward.
>> >
>>
>> All the controls nested_vmx_setup_ctls_msrs() set are in the newly
>> introduced KVM_REQ_VMX_*/KVM_OPT_VMX_* sets so we should be good here
>> (unless I screwed up, of course).
>>
>> There's going to be some changes though. E.g this series was started by
>> Anirudh's report when KVM was exposing SECONDARY_EXEC_TSC_SCALING while
>> running on KVM and using eVMCS which doesn't support the control. This
>> is a bug and I don't think we need and 'bug compatibility' here.
>
> You cannot force VM termination on a kernel upgrade. On live migration
> from an older kernel, the new kernel must be willing to accept the
> suspended state of a VM that was running under the older kernel. In
> particular, the new KVM_SET_MSRS must accept the values of the VMX
> capability MSRS that userspace obtains from the older KVM_GET_MSRS. I
> don't know if this is what you are referring to as "bug
> compatibility," but if it is, then we absolutely do need it.
>

Oh, right you are, we do seem to have a problem. Even for eVMCS case,
the fact that we expose a feature which can't be used in VMX control
MSRs doesn't mean that the VM is broken. In particular, the VM may not
be using VMX features at all. Same goes to PERF_GLOBAL_CTRL errata.

vmx_restore_control_msr() currenly does strict checking of the supplied
data against what was initially set by nested_vmx_setup_ctls_msrs(),
this basically means we cannot drop feature bits, just add them. Out of
top of my head I don't see a solution other than relaxing the check by
introducing a "revoke list"... Another questions is whether we want
guest visible MSR value to remain like it was before migration or we can
be brave and clear 'broken' feature bits there (the features are
'broken' so they couldn't be in use, right?). I'm not sure.

Anirudh, the same concern applies to your 'intermediate' patch too.

Smart ideas on what can be done are more than welcome)

-- 
Vitaly

