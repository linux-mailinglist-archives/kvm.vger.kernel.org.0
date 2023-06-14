Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE17309D1
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 23:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjFNV2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 17:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFNV2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 17:28:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EEB2688
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:27:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b3bb3dd181so25941995ad.3
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 14:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686778071; x=1689370071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vi/7hmjTrTZ9KkULGSIwFNzyIkPs6ZSrGwYo1vsf4LY=;
        b=TOv1Wi0OzaxGH6kqqwft5pXdVjMAM/MiDgT/EMigAP6UWlnGu7xMRdzjFEeJmPqlWL
         RTMguNIvf07SQMEHLrmAq4s538RBa8g1hlLJBVpqAYDMU7MXO/cI0vJfKZcRp7+Lt3PP
         rBCkWOYHX/q3klthqhVRiMb2noZUa6qOCtAC86kXBsVW/1JVqW2M55oQy089ISYIUowd
         /0HnJnD9FuOU8/oC54Cf7PVSQQmfS1FsVszS9TBP9uGWz7cNYoT1Wjm5N9i2YrbzBWGB
         wl3xERsZlBeaYSbULQx5juqMja79hOySYoERJKr6GgCd3cvL84OlDeYeUVp9stiYEMlN
         Wrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686778071; x=1689370071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vi/7hmjTrTZ9KkULGSIwFNzyIkPs6ZSrGwYo1vsf4LY=;
        b=Hv3Ym8aOnZ9n7mYysDo1yoj3iUXg3AP3V3zsAG3XBcjAVsPWiq3N1txcJgfMmsCjvL
         zZToSNmdadwWd0A3SS/Ww5DuDjRt0pRDW6th+DJkxPA1/BTyFH2Suxh8vC2OcJDB+pXO
         RHb1F2pBHsA9V1u7cxLjbFF5fpBlh2hxkygPlBMBYEiQZny8oaPLLuuHG8qRKNWV/k+p
         oCabCEeuTErEG+BG2HdYbgwerCiR0nBYGRQ1DIuwJg0h7jfqKLpPzgPNs3GVFOJ3SlPF
         MGGJX2x0q81sleWNWez2GGoGrgovLi7kTVCI7l6x3NGUevNKNmX2vnyDnWA3hyc95+Uz
         GEiA==
X-Gm-Message-State: AC+VfDxnLjmZ+qcvwRVBZ7qxWXDlwBNvxnvnOTrOhZWEPGplBiOB15SM
        6UCLkdUcCF2hhv3lxwPrHBQEgCi0594=
X-Google-Smtp-Source: ACHHUZ5UF2epLMEIrkVLE9C35fy0CnP3TmO7JnKYJ6T3BpN/XCXz9TqLP32SSuRUgyULc0pTuDBD4I0wRGo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f807:b0:1b5:bd8:5aaa with SMTP id
 ix7-20020a170902f80700b001b50bd85aaamr277193plb.1.1686778071544; Wed, 14 Jun
 2023 14:27:51 -0700 (PDT)
Date:   Wed, 14 Jun 2023 14:27:49 -0700
In-Reply-To: <9ccc37a9-4f0b-f662-4d1a-467d18bbe48e@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-6-aik@amd.com> <ZGv9Td4p1vtXC0Hy@google.com>
 <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com> <ZGzfWQub4FQOrEtw@google.com>
 <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com> <ZHDEkuaVjs/0kM6t@google.com>
 <64336829-60c5-afe1-81ad-91b4f354aef3@amd.com> <5e7c6b3d-2c69-59ca-1b9f-2459430e2643@amd.com>
 <ZIj5ms+DohcLyXHE@google.com> <9ccc37a9-4f0b-f662-4d1a-467d18bbe48e@amd.com>
Message-ID: <ZIow1a0rVQ1FC4sH@google.com>
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023, Alexey Kardashevskiy wrote:
> On 14/6/23 09:19, Sean Christopherson wrote:
> > On Fri, Jun 02, 2023, Alexey Kardashevskiy wrote:
> > > > > Side topic, isn't there an existing bug regarding SEV-ES NMI windows?
> > > > > KVM can't actually single-step an SEV-ES guest, but tries to set
> > > > > RFLAGS.TF anyways.
> > > > =20
> > > > Why is it a "bug" and what does the patch fix? Sound to me as it is
> > > > pointless and the guest won't do single stepping and instead will run
> > > > till it exits somehow, what do I miss?
> > 
> > The bug is benign in the end, but it's still a bug.  I'm not worried about =
> 
> 
> (unrelated) Your response's encoding broke somehow and I wonder if this is
> something I did or you did. Lore got it too:
> 
> https://lore.kernel.org/all/ZIj5ms+DohcLyXHE@google.com/

Huh.  Guessing something I did, but I've no idea what caused it.

> > fixing
> > any behavior, but I dislike having dead, misleading code, especially for so=
> > mething
> > like this where both NMI virtualization and SEV-ES are already crazy comple=
> > x and
> > subtle.  I think it's safe to say that I've spent more time digging through=
> >   SEV-ES
> > and NMI virtualization than most KVM developers, and as evidenced by the nu=
> > mber of
> > things I got wrong below, I'm still struggling to keep track of the bigger =
> > picture.
> > Developers that are new to all of this need as much help as they can get.
> > 
> > > > > Blech, and suppressing EFER.SVME in efer_trap() is a bit gross,
> > > > =20
> > > > Why suppressed? svm_set_efer() sets it eventually anyway.
> > 
> > svm_set_efer() sets SVME in hardware, but KVM's view of the guest's value t=
> > hat's
> > stored in vcpu->arch.efer doesn't have SVME set.  E.g. from the guest's per=
> > spective,
> > EFER.SVME will have "Reserved Read As Zero" semantics.
> 
> It is not zero, why? From inside the guest, rdmsrl(MSR_EFER, efer) reads
> 0x1d01 from that msr where 0x1000==(1<<_EFER_SVME),  _EFER_SVME==12.

Oh, lame.  So the guest gets to see the raw value in the VMSA.  So it really comes
down to the GHCB not providing support for STGI/CLGI.
