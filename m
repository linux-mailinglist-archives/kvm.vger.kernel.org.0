Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E888F73C3E5
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 00:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjFWWSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 18:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjFWWSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 18:18:32 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34772269F
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 15:18:31 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-25eb77bccbfso586065a91.2
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 15:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687558710; x=1690150710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mj7gT4pHcHTYHuiGyjzIPdldK7uwKkEsb4SrQHW5+SA=;
        b=Sps2XRR6fmfomVCI+TF4w+QePG0mmoi5JN/AKa93y6+EFjXVxxwChZc5aWV6Kj49M8
         Zxj9iOdM1+YEfwvUWAoHRZXUQrOSDTF4bxS9c3GYbxaZe2UAlBGNZl9J6t6gOYEEVgX9
         Zq+QboeFeZBRNBJcGwyzxoBt2dcIi87CSspFR4H/8CyxB+GQFqVAhRT3PPaQBeJWkdNu
         UvUvhiOfX2niTzVKlemEK+sfkpBLTDN/mV0iG12dkcKxRxulhBGRGpjnwLOwBA8Hufpc
         nmh4Z1m0w9MKeuARqzb9Kul/i9cjfH3VZO7BaOgKv6GKJH1iRyHMwe59Ka1V6AV5+Ffw
         dMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687558710; x=1690150710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mj7gT4pHcHTYHuiGyjzIPdldK7uwKkEsb4SrQHW5+SA=;
        b=ZtODrdw8Mz1Godk1DyLIm6QELw1udllskC2xYYFq9AkjPzvogI5I830eyi2dIPWjY2
         iiEeY6WfT0sxagyHOVqi3534fiFsKU0mVyY6yGOz2FwxAhGr4nglVZmEcx4sb5ySpKt+
         BitJu+K3SmctI9GRYDATcDjoQKSO/uy0hNVzhBaZDz1vAL3mz04BUkIEdwTbXyFY6a5k
         CbmIp3pCsL5cWMWhefwEPNO2ZtwZgbQwdRhu/bcxktWOycobpTwc/cwGwSwQssJehU/j
         uOnOmR9IeSwriMDHbW6NpOSf+t1ZDz94FW+Dh/yKMFF5svnV7OEaFwVHCKr1mL/uBRpT
         FL0w==
X-Gm-Message-State: AC+VfDzirKjq1/fcsYu4dzEG2WSo0Nhks5n4+/9w0quD1h90bOd8oHs9
        C2hXgH36n0FdJrrzL32uxaep3z/rdm4=
X-Google-Smtp-Source: ACHHUZ46TT1FeT6gOPViLTwUfS+blvVlh1AdCYgrROR9OSlBn102s3to2/Rcbxsp+gEcv0kS3C7gX9F/698=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d482:b0:25e:1d89:76a3 with SMTP id
 s2-20020a17090ad48200b0025e1d8976a3mr3222708pju.6.1687558710649; Fri, 23 Jun
 2023 15:18:30 -0700 (PDT)
Date:   Fri, 23 Jun 2023 15:18:29 -0700
In-Reply-To: <9ef2faeaa38e667bd4daa8ee338d4cade452c76c.camel@intel.com>
Mime-Version: 1.0
References: <20230524155339.415820-1-john.allen@amd.com> <20230524155339.415820-7-john.allen@amd.com>
 <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
 <ZINGaJnNJ54+klsD@johallen-workstation.lan> <9ef2faeaa38e667bd4daa8ee338d4cade452c76c.camel@intel.com>
Message-ID: <ZJYaNSzup+yuYxNy@google.com>
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
From:   Sean Christopherson <seanjc@google.com>
To:     Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc:     "john.allen@amd.com" <john.allen@amd.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023, Rick P Edgecombe wrote:
> On Fri, 2023-06-09 at 10:34 -0500, John Allen wrote:
> > > Is setting XFEATURE_MASK_CET_KERNEL here ok? The host kernel will not
> > > support XFEATURE_MASK_CET_KERNEL. I guess after this there is a small
> > > window of time where host IA32_XSS could have non-host supported
> > > supervisor state.
> > > 
> > > Sort of separately, how does SVM work with respect to saving and
> > > restoring guest supervisor CET state (I mean the CET_S stuff)?
> > 
> > Apart from a minor exception involving SEV-ES, we are piggybacking on the
> > state saving/restoring in Yang Weijiang's x86/VMX series. So by inspection,
> > it looks like guest supervisor support is broken as the supervisor XSAVES
> > state and MSRs are not included in that series. I currently don't have a
> > way to test this case, but I think there are operating systems that support
> > it. I'll work on getting a guest set up that can actually test this and
> > hopefully have working guest supervisor support in the next version of the
> > series.
> 
> Hmm, interesting. VMX has some separate non-xsaves thing to save and
> restore the guests supervisor CET state, so Weijiang's series doesn't
> use the xsaves supervisor CET support.

Heh, that and Weijiang's series is a wee bit incomplete.

> Also, since the host might have CR4.CET set for its own reasons, if the host
> handled an exit with the the guests MSR_IA32_S_CET set it could suddenly be
> subjected to CET enforcement that it doesn't expect. Waiting to restore it
> until returning to the guest is too late.
>
> At least that's the reasoning on the VMX side as I understand it

The APM doesn't come right out and say it, but I assume/hope that S_CET is saved
on VMRUN and loaded on #VMEXIT, i.e. is the same as VMX for all intents and
purposes.

The host save state definitely has a field for S_CET, and VMRUN documents that the
guest values are loaded, I just can't find anything in the APM that explicitly states
how host S_CET and friends are handled.  E.g. in theory, they could have been
shoved into VMSAVE+VMLOAD, though I very much doubt that's the case.

John?
