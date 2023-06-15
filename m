Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6AB7323A5
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 01:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjFOXbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 19:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjFOXa6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 19:30:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813EA1720
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 16:30:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25b79a5cf1aso865748a91.1
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 16:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686871857; x=1689463857;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vyL+qgKJrcKsdTc3WR8O7KWE3ZdhseNke0mLmEAF7qY=;
        b=GcNnMG4gLuWH2DzhqEsZ69wits+33+UN7SvejxrIqgg/c2BTzmlx5wx+ZDiyj+UcJi
         YcGr7b8cseUjr+AJqUqP+fautL1pmEdxqVjop/kzh/wWnRMexTz4nDKnhATbltXw0bO6
         RPNByW+psGHEvmmSVAPSeceAqArTPJ3m2kFtux1NSRQTOty5MXhMgq+gMjDj16PUTwYv
         v93cjHFn3xB2DJb1Fixja117EYkNx4PmnF8iZmSbG0dxmC4YpwzuDJilhTrPVfvj2Gq3
         ZT94rD+97BmgmG/89s0bsW+byYQGI7NChbbOz4Gh8gBO740udK+Mrh1Mt+Hy9VXDnr5f
         TEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686871857; x=1689463857;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vyL+qgKJrcKsdTc3WR8O7KWE3ZdhseNke0mLmEAF7qY=;
        b=XEhjZatlfPYtQ/8XWGmRWhpobMii8+OwlUThTh1oX7lwmpfzLK0GpZ20WME67eAY6f
         DpmKx0OPBqyoWhaXq6AwZXeHSURlbGzKWaDjKXiqFzOqPOFTuRHAbKfTMy0IAsg9G2IZ
         BfjqnnB9iOUsHb692VYZULe/BvIOIcXRrkUvOhJAuVAF69xvCd4feyHHrJEIB3au1yXS
         X1pvsXp93KPdYk1oSfDkCvxCVK+veXpz+zu2LV0NJzRJWPQp1IBmQdBljlKrtCsmOmDJ
         92KQ/fTC473FkuWJagFzmLReuGLxHV55Zwop+HNukZnWeiO4LRgqy0VZLTnQlHAfQqdp
         7AYA==
X-Gm-Message-State: AC+VfDz3NK1x/KqPKKILb1yYx+kly01Ba4gAWS6O/OC54LvW8owfK2kl
        swF+eEZkpVTf57gYp1BBR+lwSL54Sac=
X-Google-Smtp-Source: ACHHUZ4VSZccyzB174lDhurPUahLzt0d6P8rWLALZfCrAECY5/hEq1icU5LoFaW0qsZXVf4a3c1BpIqTI2M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2f43:b0:253:3b5f:fde1 with SMTP id
 s61-20020a17090a2f4300b002533b5ffde1mr1036267pjd.1.1686871856868; Thu, 15 Jun
 2023 16:30:56 -0700 (PDT)
Date:   Thu, 15 Jun 2023 16:30:55 -0700
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
Message-ID: <ZIufL7p/ZvxjXwK5@google.com>
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023, Yang Weijiang wrote:
> The last patch is introduced to support supervisor SHSTK but the feature =
is
> not enabled on Intel platform for now, the main purpose of this patch is =
to
> facilitate AMD folks to enable the feature.

I am beyond confused by the SDM's wording of CET_SSS.

First, it says that CET_SSS says the CPU isn't buggy (or maybe "less buggy"=
 is
more appropriate phrasing).

  Bit 18: CET_SSS. If 1, indicates that an operating system can enable supe=
rvisor
  shadow stacks as long as it ensures that certain supervisor shadow-stack =
pushes
  will not cause page faults (see Section 17.2.3 of the Intel=C2=AE 64 and =
IA-32
  Architectures Software Developer=E2=80=99s Manual, Volume 1).

But then it says says VMMs shouldn't set the bit.

  When emulating the CPUID instruction, a virtual-machine monitor should re=
turn
  this bit as 0 if those pushes can cause VM exits.

Based on the Xen code (which is sadly a far better source of information th=
an the
SDM), I *think* that what the SDM is trying to say is that VMMs should not =
set
CET_SS if VM-Exits can occur ***and*** the bit is not set in the host CPU. =
 Because
if the SDM really means "VMMs should never set the bit", then what on earth=
 is the
point of the bit.

> In summary, this new series enables CET user SHSTK/IBT and kernel IBT, bu=
t
> doesn't fully support CET supervisor SHSTK, the enabling work is left for
> the future.

Why?  If my interpretation of the SDM is correct, then all the pieces are t=
here.

> Executed all KVM-unit-test cases and KVM selftests against this series, a=
ll
> test cases passed except the vmx test, the failure is due to CR4_CET bit
> testing in test_vmxon_bad_cr(). After add CR4_CET bit to skip list, the t=
est
> passed. I'll send a patch to fix this issue later.

Your cover letter from v2 back in April said the same thing.  Why hasn't th=
e patch
been posted?  And what exactly is the issue?  IIUC, setting CR4.CET with
MSR_IA32_S_CET=3D0 and MSR_IA32_U_CET=3D0 should be a nop, which suggests t=
hat there's
a KVM bug.  And if that's the case, the next obvious questions is, why are =
you
posting known buggy code?
