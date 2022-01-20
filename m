Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393AB4945F3
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 04:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358259AbiATDBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 22:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358248AbiATDBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 22:01:01 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8435FC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 19:01:01 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso17262461wma.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 19:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kDUJCoHN2jIvYmjA1f6UxkDuEVqbItrdOJEBrZAlcd4=;
        b=s/LZvihPWgtp0kEzuXJdC9RwtoL1mEXE/lb/tF4wNpWOPqJ/pS5GqnbmPzLN7B/aJ4
         SLrQSPNVopYZYXhKfOeXIeP9+0aLPECgljkf7HtgcNNvGaH6wo5OLc42sykD2o4AxyBw
         OZ2EGruTwUc5OrhJn+GxwEHbTvuZqzZtfOcoTKcLCoCwyfjKj8SlX8rzC/UO/S38agO8
         i4/CvP+nGKVjJVN6AfZnYAiL8LV1vtjuc6F7MXClgfA/zfRRGktHJxE5f8gL0+tY9D4Y
         AXptThdvMyMzFWW8zWlMdzvF4VFh2M0LtvXZ5RHih5+oLLkdIbIscAjUcWZHliMijus+
         w9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kDUJCoHN2jIvYmjA1f6UxkDuEVqbItrdOJEBrZAlcd4=;
        b=07SR6rMHgklKJ9wnyU9ceOWv8ybcG/73hlNQpnbWA2YVJ6qjbYa2BQrITTtch9RHvq
         FF+mpCEXitDUFJJai9s6OwYJ54YtA1gMymH1YFVLxF/hpMqnCpH8F1krqdeY91BBMnyN
         EU3mpRXpZg38cQwzrA72NHFTAfpqWifheq4gyLmltj3+eRtVLsz65JnQb/33rY3Anco4
         K0VsjCdEHG1M6E0q/h4iPrxZiQeI3g1OHZxH5DPtqJsA9ba/6LSnWkBcyUljHfrbZJcb
         OE/tPAUcCFoZwQYjQqSWd2VWXMGjD2hAEGYhW2Htn5NxbTxXy0T8eYvxZh3VDWddm2q6
         y+Xg==
X-Gm-Message-State: AOAM532dYKWZb0ZHMb3gP+5vApJUzfJ8AXqMtBTAmSn2s6tuiczvDYtR
        1egsZZDtSKkA2M50uPgQ2l+Tz9bByE7iYfPi5ADghLEL6Tg=
X-Google-Smtp-Source: ABdhPJwgoFuLtD74DKVGsf+tLk7erzJiVVL1yBQce5kttVYQAMQiVG2TRiTHgFP7f2NXtX6SIQoYRClk3cn10PKPrBE=
X-Received: by 2002:a5d:6408:: with SMTP id z8mr7111818wru.149.1642647660000;
 Wed, 19 Jan 2022 19:01:00 -0800 (PST)
MIME-Version: 1.0
References: <20220119182818.3641304-1-daviddunn@google.com> <Yei3whU32mupq9RV@google.com>
In-Reply-To: <Yei3whU32mupq9RV@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Wed, 19 Jan 2022 19:00:48 -0800
Message-ID: <CABOYuvZsVLvVFNvRwjAtxfp-CuuNTxEVXoZP97+TCQm6__CMHA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Provide VM capability to disable PMU virtualization
 for individual VMs
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        Jim Mattson <jmattson@google.com>, cloudliang@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks Sean.

On Wed, Jan 19, 2022 at 5:15 PM Sean Christopherson <seanjc@google.com> wrote:

> I'm not necessarily opposed to this capability, but can't userspace get the same
> result by using MSR filtering to inject #GP on the PMU MSRs?

Yes.  It is possible for each userspace to inject #GP on Intel and
ignore on AMD.  But
I think it is less error prone to handle it once in KVM in the same
way we handle the
module parameter.  No extra complexity in KVM but it reduces the
complexity in clients.

> Probably worth adding a #define in uapi/.../kvm.h for bit 0.

> Rather than default to "true", just capture the global "enable_pmu" and then all
> the sites that check "enable_pmu" in VM context can check _only_ kvm->arch.enable_pmu.
> enable_pmu is readonly, so there's no danger of it being toggled after the VM is
> created.

Thanks for the feedback.  I'll incorporate both of these in v2.

Dave Dunn
