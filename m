Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D00F6BD68F
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 18:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjCPRAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 13:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCPRAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 13:00:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C05120694
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 10:00:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5416d3a321eso21504487b3.12
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 10:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678986034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EIyiTP515YO+SAb/YYaNaTIZKVonW7mEMVPUmLCvGc4=;
        b=KBjVA3Eu2UFFUIQDCQrfAjdteY3RK5qzSebhFhs3W1+EgFS1bDFd37Kx43+DB5CpvT
         4WbPhb10h6NF7zUh30wr3rvRRYeV9cnyn5uoF7yB9qXPbK/HlgvlnV2FhN53Dm7yEc/N
         QifUpguVM1mzD33tONAZkbteuEl1oltsto7C2Ktb2/wOlRnOYlNFjvXBOVbLerDCgHys
         YA+8Fz3vVtqHBaPI7iA2z/1bc1LEsTgJlnK790jMpbiNgcAMU8yjNkh4c1e7r0m9qxu9
         bgQ13NyiswPn0iJ0zOpn89Rb1riJRIXYnmvmwzxouAbniS9ugOLnBDlR8t/32RGVFir2
         fC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678986034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EIyiTP515YO+SAb/YYaNaTIZKVonW7mEMVPUmLCvGc4=;
        b=DapT4XqQsZBdvgMF9tlS/j7BPa1+G9/Splf4bbv7KhM348Dhj+1Zk4ahm5drDtrmjr
         TybyYgHVAcvrcNtXvVMBMOm3cJKSr6PPTMhEjbPjgm+w8yBvza1vreNDn5JnIm80tEnx
         tKzFXI+DO59ZThv7lZz0eeicmmNVFSV2rCK44vSXJ0/dhNYUNkNHR8UDH4MwWsADzwpX
         FPcSumy6lo8Wn15BTMEgp7oDsV+WVTs8d4gyjvyiShnv1dR/P8+QAa3/Fo4OFlbbRaS9
         P3a8xLGXfRk6AGpUs3PK8RPrHrpeVGxFNEtCIJb/juo2IYwPip+bj/oRqxF2+7MaYSwz
         6v+w==
X-Gm-Message-State: AO0yUKXHH6/QdOnA6R24kZKMhVUHyfqMAH7yKaDzih6tOctyEx/3nnti
        V0PqY14aASKePBwS7UU3CBW8VwHy3lI=
X-Google-Smtp-Source: AK7set9ttXnE7pwHbBwUz9bqtbHf0cxA73mk4TF9MMnBIaDIbJHkHQXpGGrBZJgZaPSu6ELq6SzHT22B9Ws=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e349:0:b0:544:8bc1:a179 with SMTP id
 w9-20020a81e349000000b005448bc1a179mr2605313ywl.4.1678986034495; Thu, 16 Mar
 2023 10:00:34 -0700 (PDT)
Date:   Thu, 16 Mar 2023 10:00:33 -0700
In-Reply-To: <9fccf93dd8be42279ec4c4565b167aa9@baidu.com>
Mime-Version: 1.0
References: <20230215121231.43436-1-lirongqing@baidu.com> <ZBEOK6ws9wGqof3O@google.com>
 <01086b8a42ef41659677f7c398109043@baidu.com> <ZBHjNuQhqzTx13wX@google.com> <9fccf93dd8be42279ec4c4565b167aa9@baidu.com>
Message-ID: <ZBMw94f2B1hiNnMC@google.com>
Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
From:   Sean Christopherson <seanjc@google.com>
To:     Li Rongqing <lirongqing@baidu.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023, Li,Rongqing wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > On Wed, Mar 15, 2023, Li,Rongqing wrote:
> > > > Rather than have the guest rely on host KVM behavior clearing
> > > > PV_UNHALT when HLT is passed through), would it make sense to add
> > > > something like KVM_HINTS_HLT_PASSTHROUGH to more explicitly tell the
> > > > guest that HLT isn't intercepted?
> > >
> > > KVM_HINTS_HLT_PASSTHROUGH is more obvious, but it need both kvm and
> > > guest support
> > 
> > Yeah, that's the downside.  But modifying KVM and/or the userspace VMM
> > shouldn't be difficult, i.e the only meaningful cost is the rollout of a new
> > kernel/VMM.
> > 
> > On the other hand, establishing the heuristic that !PV_UNHALT ==
> > HLT_PASSTHROUGH could have to subtle issues in the future.  It safe-ish in the
> > context of this patch as userspace is unlikely to set KVM_HINTS_REALTIME, hide
> > PV_UNHALT, and _not_ passthrough HLT.  But without the REALTIME side of
> > things, !PV_UNHALT == HLT_PASSTHROUGH is much less likely to hold true.
> 
> Ok, could you submit these codes

I'd like to hear from others first, especially Paolo and/or Wanpeng.
