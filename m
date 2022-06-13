Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B81B549F68
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 22:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbiFMUfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 16:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiFMUdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 16:33:32 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E451E12082
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 12:23:51 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-fe023ab520so9671964fac.10
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 12:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YZDl+BeJBBUNeWrG7VoTjaSxaL0rjbKuIsna+kCnVcs=;
        b=C4a0u44356yrDzoiMXiH0yh1rCpFmnwV16f8JH9dgz0S7w1HwWuD1BLLwo2Vhx3ep6
         uHlXsNIo7Z79+xivE9s0T25Pik2MDVpcYx9KQ7pGfsg8DH9yauG5yHw6UZOGPhM8IMH8
         Tgh9ZKY0izl9GIBlPJpPtNOhc5Htc0GD0utqZA8kWGjaHXOrskn0RvCyJ2LlYWYS9RSQ
         OF/TViH3ts/9sg2i55v2tFtACPjALjxjZaGNmPeW7V/woz+bhoAgPvgzrF1qjjiIB4uu
         qsSZZTV/Acf3GfTkxzmENAD3BprAJGKhkaoZmKeNKJk5On4LF4SEIFLlTI62r+IeeHAU
         yQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YZDl+BeJBBUNeWrG7VoTjaSxaL0rjbKuIsna+kCnVcs=;
        b=4q/BZmy4Av5Ur8i56YoekqO0uBGDKp1LAfecW/NzVUtD4TNUngwPc6ygX8uHXleTLg
         Te8Ei3hGtTPl8XzvNJ+dr6dN8q3xeyAzkJi0IFZLrC36bcs/2+6y25qND3W6lRLtwijU
         AIj1Ok1YU+C+Sb9nDbK8gY7xn642E/y33vg8fuwnVfeE0KI67S/v4FK+HwjaREYY375c
         10yK1TBih5AuDuPTfw3eFxsLeX8PHIkyDX/Bi26ZLxRLy7/DbYisHOPoqpbgJZmObX6G
         5XRcBdJs5hiNjUn4bqrHFShY8CswsDfrtd+PH7I5vn6wMK0bUp7aAtuNT+tOmurGu0Jp
         3U8g==
X-Gm-Message-State: AJIora8xzk1XTsFOX4SF4RwKp1Egl2ffQO9IkEn1Z5NLuQpPDLO+gDbp
        S1osG+FH9/cHcD2+Ee8UW4Xl+73gUe18vwD+5bUJvQ==
X-Google-Smtp-Source: AGRyM1vqV3PQsIBk7abRGQ7bZp/MfN8B1K4jzpADb8cNiNLxbClWmSDAJ7JvffXirhfrpiJbld0bxmv1Lq5zRvEX5uI=
X-Received: by 2002:a05:6870:d60d:b0:f3:2e4f:4907 with SMTP id
 a13-20020a056870d60d00b000f32e4f4907mr186903oaq.13.1655148230894; Mon, 13 Jun
 2022 12:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <161188083424.28787.9510741752032213167.stgit@bmoger-ubuntu>
 <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
 <CALMp9eTU5h4juDyGePnuDN39FudYUqyAnnQdALZM8KfiMo93YA@mail.gmail.com> <5d380b11-079f-e941-25cf-747f66310695@amd.com>
In-Reply-To: <5d380b11-079f-e941-25cf-747f66310695@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 13 Jun 2022 12:23:40 -0700
Message-ID: <CALMp9eRnC1RgRwj64TJcXdhhL6g835N_-E8FbeHVre6aX=18-A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        fenghua.yu@intel.com, tony.luck@intel.com, wanpengli@tencent.com,
        kvm@vger.kernel.org, peterz@infradead.org, seanjc@google.com,
        joro@8bytes.org, x86@kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, krish.sadhukhan@oracle.com,
        hpa@zytor.com, mgross@linux.intel.com, vkuznets@redhat.com,
        kim.phillips@amd.com, wei.huang2@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 8:10 AM Tom Lendacky <thomas.lendacky@amd.com> wrot=
e:
>
> On 6/3/22 22:11, Jim Mattson wrote:
> > On Thu, Jan 28, 2021 at 4:43 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> >> This support also fixes an issue where a guest may sometimes see an
> >> inconsistent value for the SPEC_CTRL MSR on processors that support
> >> this feature. With the current SPEC_CTRL support, the first write to
> >> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
> >> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
> >> will be 0x0, instead of the actual expected value. There isn=E2=80=99t=
 a
> >> security concern here, because the host SPEC_CTRL value is or=E2=80=99=
ed with
> >> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
> >> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
> >> MSR just before the VMRUN, so it will always have the actual value
> >> even though it doesn=E2=80=99t appear that way in the guest. The guest=
 will
> >> only see the proper value for the SPEC_CTRL register if the guest was
> >> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
> >> support, the save area spec_ctrl is properly saved and restored.
> >> So, the guest will always see the proper value when it is read back.
> >
> > Note that there are actually two significant problems with the way the
> > new feature interacts with the KVM code before this patch:
> > 1) All bits set by the first non-zero write become sticky until the
> > vCPU is reset (because svm->spec_ctrl is never modified after the
> > first non-zero write).
>
> When X86_FEATURE_V_SPEC_CTRL is set, then svm->spec_ctrl isn't used.

Post-patch, yes. I'm talking about how this new hardware feature broke
versions of KVM *before* this patch was submitted.

> > 2) The current guest IA32_SPEC_CTRL value isn't actually known to the
> > hypervisor.
>
> The hypervisor can read the value as long as it is not an SEV-ES or
> SEV-SNP guest.

Yes, it can, but KVM prior to this patch did not. Again, I'm talking
about how this new hardware feature broke *existing* versions of KVM.

> > It thinks that there are no writes to the MSR after the
> > first non-zero write, so that sticky value will be returned to
> > KVM_GET_MSRS. This breaks live migration.
>
> KVM_GET_MSRS should go through the normal read MSR path, which will read
> the guest MSR value from either svm->vmcb->save.spec_ctrl if
> X86_FEATURE_V_SPEC_CTRL is set or from svm->spec_ctrl, otherwise. And the
> write MSR path will do similar.

You really are gaslighting me, aren't you?

> I'm probably missing something here, because I'm not good with the whole
> live migration thing as it relates to host and guest features.

AMD added a new VMCB field that existing hypervisors knew nothing
about. This VMCB field contains the current value of the guest's
IA32_SPEC_CTRL. Since the hypervisor doesn't know that this field even
exists, it cannot migrate it.
