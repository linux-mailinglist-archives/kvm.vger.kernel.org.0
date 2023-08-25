Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CB67890A0
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 23:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjHYVoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 17:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjHYVnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 17:43:50 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A4026BD
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 14:43:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-565e5961ddbso1160056a12.2
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 14:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692999827; x=1693604627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gUkq9l1hQ47wY3yGj1dwdm5geOu41+610qOHq9w1Q7k=;
        b=SZDELniJs7eK8tPGP42S7m/uzvzCpd4pjoWwK4PQouFi7h/e3ddOCG3yhkA8aBt70a
         XUlypou7F3ktA9EjPDVpPbXSEoBJdP0Rki+6kXXak7wsx68WWRwq6j2gDSmgq5bBtRZG
         0tXYXg5CLOxQ18BOt7mj8AzhTIGLrqQTkDiRvTYzM1lpLgxDCH0JjBo2O1I5J2PLf45i
         iMhOtfuocS21DSHwbA7kmnF1PRY+p8TqbiRzRe1Kcla08n0bSeyQMts06Ve0BIw809GN
         5bnPpe0P0R9ymEJbJxRv4YI8PLDTFHj870ntSR/rvLxhAnLLUGVJkDRM8AU3ResVPQmf
         PwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692999827; x=1693604627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gUkq9l1hQ47wY3yGj1dwdm5geOu41+610qOHq9w1Q7k=;
        b=C5H72hYwqKKFcFWbuSvj/QS7WYMhVP8JCRkQZUvKwK505j1AexJhp7EKz5UIzT+myZ
         PlZ37XkzVcO/Nc1SilwqBxLCb/aK5BXQ0wS4EeJ6lVyaVTeWZq3L8gXp3Oc3gsbdZFji
         6Mfd3CX/49oajIuO0gSHORvbKkOkmoAtnIb5bJjORYd2ADKRFiaZx2ZL2DJ3cZ3LCJNd
         umlvNkAmg09c1XQ/ts8KNEc71zsHKJSjnKZyercJTii/mf4lckLNUhuImIs8SG3R+u7v
         IjExb7IkGPMU22B7SMNFJPJDS30ELamJhM5KoYYzHS5aMRxo0bc1jkxhCSPXRiaEZanr
         qq2w==
X-Gm-Message-State: AOJu0Yypom0FG/YSFmmO0alzHgRwSJ/VmQhvm5MGH/bOYfWs9CK4EiBK
        ywgl/bbiBdv4sTyjqeoj9lTW7jJRUs0=
X-Google-Smtp-Source: AGHT+IHbg1WAhJS8yHIPWqbqKYja5/h2pRycp2kzC53Q6kOly5HmQzy62FLBoM2UyqwHaTJimXoq6osJ5/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3ec6:0:b0:565:f8bd:cbc8 with SMTP id
 l189-20020a633ec6000000b00565f8bdcbc8mr2052248pga.6.1692999826860; Fri, 25
 Aug 2023 14:43:46 -0700 (PDT)
Date:   Fri, 25 Aug 2023 14:43:45 -0700
In-Reply-To: <20230714065326.20557-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065326.20557-1-yan.y.zhao@intel.com>
Message-ID: <ZOkgka+DX4KNm5Mp@google.com>
Subject: Re: [PATCH v4 07/12] KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Yan Zhao wrote:
> For KVM_X86_QUIRK_CD_NW_CLEARED is on, remove the IPAT (ignore PAT) bit in
> EPT memory types when cache is disabled and non-coherent DMA are present.
> 
> To correctly emulate CR0.CD=1, UC + IPAT are required as memtype in EPT.
> However, as with commit
> fb279950ba02 ("KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED"), WB + IPAT are
> now returned to workaround a BIOS issue that guest MTRRs are enabled too
> late. Without this workaround, a super slow guest boot-up is expected
> during the pre-guest-MTRR-enabled period due to UC as the effective memory
> type for all guest memory.
> 
> Absent emulating CR0.CD=1 with UC, it makes no sense to set IPAT when KVM
> is honoring the guest memtype.
> Removing the IPAT bit in this patch allows effective memory type to honor
> PAT values as well, as WB is the weakest memtype. It means if a guest
> explicitly claims UC as the memtype in PAT, the effective memory is UC
> instead of previous WB. If, for some unknown reason, a guest meets a slow
> boot-up issue with the removal of IPAT, it's desired to fix the blamed PAT
> in the guest.
> 
> Besides, this patch is also a preparation patch for later fine-grained gfn
> zap when guest MTRRs are honored, because it allows zapping only non-WB
> ranges when CR0.CD toggles.
> 
> BTW, returning guest MTRR type as if CR0.CD=0 is also not preferred because
> it still has to hardcode the MTRR type to WB during the

Please use full names instead of prononous, I found the "it still has to hardcode"
part really hard to grok.  I think this is what you're saying?

  BTW, returning guest MTRR type as if CR0.CD=0 is also not preferred because
  KVMs ABI for the quirk also requires KVM to force WB memtype regardless of
  guest MTRRs to workaround the slow guest boot-up issue.

> pre-guest-MTRR-enabled period to workaround the slow guest boot-up issue
> (guest MTRR type when guest MTRRs are disabled is UC).
> In addition, it will make the quirk unnecessarily complexer .
