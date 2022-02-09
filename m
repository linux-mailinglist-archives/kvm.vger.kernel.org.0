Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC054AF88B
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbiBIRaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiBIRaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:30:21 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6A0C05CB82
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:30:23 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id k18so5267703wrg.11
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehqoee1bftUz/gLrW1kXxKGubBl5XYT7H+4O2R4yTN8=;
        b=VMjXDE+UO+gQWCOdpRAssrTMjmcChF0PkTsdA/pDVovwZVbHIhStx3JqiJ/a20KM4Z
         MwMrRkmTmt+j33cqEWQkKmi1eO7h0GgfsU9MNpgfa/L7MOEWCorP7gKfV/D9CEzZU079
         i48eTrcaUHLrmuRrdvGwn17XJEPvsMNG2zyh12JOAqSC2tbgGd4kcPBWQrrp1HcW8gBa
         QqvZfTgsYwqSwT39ryMehGflmq3B5cyMPJzNCcSpPsfCWt8/7E7Hnylj5HdbVEcq68ZX
         QLSr5kMCYnMhUgUhaGbal0MHlpi+Qz/5ioAiactY0Jr+3fT/omajQq45q214YCTd9/jF
         FDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehqoee1bftUz/gLrW1kXxKGubBl5XYT7H+4O2R4yTN8=;
        b=PI+8jfBfI3Z5TU4fZhzn0eWcjGrwnrH99Yq6yCPn1jH9g9JVsUN77oXJyz8BiVAT6D
         sEQs1JP+xh1dtTmYz3u5hAz1YhNgabIf9pNKycEI1Nyk29HnvXvY5uMmkUDIyj3nu7jE
         qMjw5eHGyLn8kbqlV35OUk2Q+PYOPP8HQxEVRQlrFOAdLmGsWeFZyTY4zkGNEapRoOy+
         Xb0/lgKy3otZuiQX4u5uzo47mEoT3RqzdvCibdsQi+xZHqG5PXrlHMy+Zg1OJ0Ppx2/+
         T/dxb/IBJDIbiHETMBz48eQkqpSylNwjGpWgF8b8iGNbidlRTBUr8YqUqyqvxqTf/4je
         gd3Q==
X-Gm-Message-State: AOAM533NL7chPMAYU90EHohpOiMC/PjUozw8x2n6F9FCB1YoPBt2/Wvp
        EtS3KNnBKROSj0Y9J3rxgr0qViNFIHRG5ChkmG8EkQ==
X-Google-Smtp-Source: ABdhPJxcHlYmbzhD+PWuni/5H/29pARK10fgORVYSpw8hGMRlwOSJkVIKE/ZpZ51NnJKmYGamVUCtwVVKxJAadh6KaI=
X-Received: by 2002:adf:ee81:: with SMTP id b1mr2877638wro.149.1644427821958;
 Wed, 09 Feb 2022 09:30:21 -0800 (PST)
MIME-Version: 1.0
References: <20220123184541.993212-1-daviddunn@google.com> <20220123184541.993212-2-daviddunn@google.com>
 <CALMp9eSuavLEJ0_jwuOgmSX+Y8iJLsJT0xkGfMZg6B7kGyDmBQ@mail.gmail.com> <09d8b472-000b-7150-f60d-ffb5706b164e@gmail.com>
In-Reply-To: <09d8b472-000b-7150-f60d-ffb5706b164e@gmail.com>
From:   David Dunn <daviddunn@google.com>
Date:   Wed, 9 Feb 2022 09:30:10 -0800
Message-ID: <CABOYuvZubA+Et9hzVrF03xCsNeAG4cz68_qG6KgAmTVHBvPoXw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, kvm@vger.kernel.org, seanjc@google.com,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

Thanks Like.

I just sent a new v6 series with these minor merge conflicts resolved.

Dave

On Wed, Feb 9, 2022 at 2:33 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> cc LKML and full list of KVM reviewers.
>
> On 25/1/2022 2:39 am, Jim Mattson wrote:
> > On Sun, Jan 23, 2022 at 10:45 AM David Dunn <daviddunn@google.com> wrote:
> >>
> >> KVM_CAP_PMU_DISABLE is used to disable PMU virtualization on individual
> >> x86 VMs.  PMU configuration must be done prior to creating VCPUs.
> >>
> >> To enable future extension, KVM_CAP_PMU_CAPABILITY reports available
> >> settings via bitmask when queried via check_extension.
> >>
> >> For VMs that have PMU virtualization disabled, usermode will need to
> >> clear CPUID leaf 0xA to notify guests.
> >>
> >> Signed-off-by: David Dunn <daviddunn@google.com>
> >
> > Nit: The two references to CPUID leaf 0xA should be qualified as
> > applying only to Intel VMs.
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> >
>
> Nit: It looks like we already have "#define KVM_CAP_SYS_ATTRIBUTES 209".
>
> Hope it helps a little:
>
> Reviewed-by: Like Xu <likexu@tencent.com>
