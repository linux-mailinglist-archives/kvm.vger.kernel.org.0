Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEBA475187
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 04:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhLOD7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 22:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbhLOD7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 22:59:17 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA24C06173E
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 19:59:17 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id v15so31418906ljc.0
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 19:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0tjE/40QVq1O5nmoJ1f6NdfWomQGy4kZlQAecDcJBAY=;
        b=lMukVHCCCrsBCkWUUA9h8abns1sXvGs2ZJHKiinYOvQYdFNeGuUp8oHFjQN+HNWJat
         MDG2wX/8wbhMg3aEKTaOWAer2dTwIdKaVnvDxTN8eH6yZ/SMTLT6t/kwD/E7yZIYZ4iF
         WBNLWMd/yvSTlanK4sCl2Dbk888/pFJnJbiLdAQYcrbEvLPSiz/f6xoj9jeN/+WHtxHD
         9fh2cBimdj63hJdEfLc2JdCD6p+XQhN4QF2mnhMs74pu9hxHxW84jxy8ww99NDN2oW0u
         dQpAAEnEeeUR0nb+ElfaACPB6LbOXwOLyQzQI6tSq+A2oORrD0u+8O/BuvacvLoHp1Dm
         sA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0tjE/40QVq1O5nmoJ1f6NdfWomQGy4kZlQAecDcJBAY=;
        b=lpXi1gBmhxLsfaGbc6hypzANsoB0kYXD/Ll62mw9JwwUwNROGPysOxe7FpA2NzA1FR
         PcyW5ss/psJzJB8dUcAILdfnobQIZ64hxJwgfH5VHIIFjO3wEF/6dd+bl4QUv0bDQeRj
         TDQrDS2l9ykiOvRNo10QvjLhMNWBifmYMzjpoLzOf9SV0/Mz4hpmhg5aiTVqPoelBwKN
         oG53AyeR9ML+AEQrOUnPEpNyyu4ZSgLywvvoQCXiBPAYY/hRzYHKsEr4SDb3Rwbe4DQG
         C6KUjt/yWYob8uYUP/YKSN2nY6YaXEFB2bTwjh83tShV1qQw++rBcGtv+siXTr2NSZvw
         ejRw==
X-Gm-Message-State: AOAM530ghPVR468UkZ11jND+asU2BLvIKDZYT46RdwpMN0058GFQMre+
        C/rwC2gBlSlS83sb2PNWS1LCiC5c3vXXgIIYEIdPkA==
X-Google-Smtp-Source: ABdhPJwQADB+Z5LoN6xoV02kzdHV72/9d8qqf3kqL6tB/YVGP/Y2TPgGWz4/q6/qmdLqzz/Rgx0Suo/MD99/j8Z1goQ=
X-Received: by 2002:a2e:83cc:: with SMTP id s12mr8308376ljh.508.1639540755235;
 Tue, 14 Dec 2021 19:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20211214050708.4040200-1-vipinsh@google.com> <YbjRb0XR7neyX/Gy@google.com>
In-Reply-To: <YbjRb0XR7neyX/Gy@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 14 Dec 2021 19:58:39 -0800
Message-ID: <CAHVum0ec420f4dMseNRCJqzfLV+5V6NpmaBibPZDzsc15S_3oA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021 at 9:16 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Dec 14, 2021, Vipin Sharma wrote:
> > +     WARN_ON(cgroup_attach_task_all(kthreadd_task, current));
>
> As the build bot noted, kthreadd_task isn't exported, and I doubt you'll convince
> folks to let you export it.
>
> Why is it problematic for the kthread to linger in the cgroup?  Conceptually, it's
> not really wrong.

Issue comes when a process tries to clear up the resources when a VM
shutdown/dies. The process sometimes get an EBUSY error when it tries
to delete the cgroup directories which were created for that VM. It is
also difficult to know how many times to retry or how much time to
wait before the cgroup is empty. This issue is not always happening.
