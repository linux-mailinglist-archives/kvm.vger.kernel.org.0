Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A9045FC4B
	for <lists+kvm@lfdr.de>; Sat, 27 Nov 2021 04:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242917AbhK0DUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 22:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhK0DSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 22:18:07 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE62BC0613B8
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 18:07:13 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id m9so13704833iop.0
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 18:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LATOJn5m8fahTHVuH0nIk/gUvXuWjK1IVkO6R3jO5To=;
        b=CYaDQPAEmKgw7s4qm0zStzT+z/faJwJ2JfvXHuRpOrZBup6b077a8Usm24sqmsMJa6
         qbK1i1qtC4dbqCFG4F1KV54BrC/FZNSybFKQIZu/sDaTnoBCEP7/h97WXgd+F6B/vNby
         ZUb/5DqURd89rGUNQoRRGA9xu8olRGBE3+46ArXehk34WtHli/F/Ineib7DHDPdwJnc4
         73ouMIXROpUpnJjfDxGLWXLG+RDng3khSJrbWteO4I+YD1KGG9c+6nSo6liPo4Ps1BZ/
         B4kaiDRu+wEAlMmXlUJHohDy9uaFCsT1kdD05jfyH/OXpGkVe+QlvzpZDRfp1U1aw83P
         r2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LATOJn5m8fahTHVuH0nIk/gUvXuWjK1IVkO6R3jO5To=;
        b=bhUhnhFbxio1jYQBQOWY3oFlOG30xkiPscmfhyFs5GvmAkfKAfPEw/wtimWxHGVW4a
         MIASKrj446wJ15KnLRAblOqI5ByzJW3yzjjBNfHQ7/2+VSy8oiySDYy0cx2GUagAC+Ap
         VR9O2nssi46y/+/jP8ewPBo0HqXXK0GW+oVE/YN2AH/Ov2sbyXBZAI+R8T2uXkSCLZgL
         RonqyyuqoNxcc2m9CApdmr/rSljNOiAbTwe8yToZ5XwvKAUSCoRL6fXzfxUreNAmg8Ka
         Vl11CXvOutAdmHEz+ePeBT3Y1W2NX00DWDh4aInNOuj7wpK19qPwapTD7cWdeH/jvqrC
         vqRw==
X-Gm-Message-State: AOAM531NSeySjS7VT51t+itcVcGD8c87mnEZguPu12tkiWwFbiuFRfbH
        7p6kVz/wKexERBL+u/JEnY+pnak2ewYDyi1Q+RU=
X-Google-Smtp-Source: ABdhPJyCaN+AmVtbuMUEErrqdk/UtRn9GrtChLQISgDDVUUrnzUu74Rye6ETFCjFmk3Wj4kTvB1JBBLdOkdtZ2GuBTQ=
X-Received: by 2002:a05:6638:3048:: with SMTP id u8mr31579601jak.148.1637978833219;
 Fri, 26 Nov 2021 18:07:13 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-7-dmatlack@google.com>
 <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
In-Reply-To: <62bd6567-bde5-7bb3-ec73-abf0e2874706@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sat, 27 Nov 2021 10:07:02 +0800
Message-ID: <CAJhGHyD5uu9+77nWMmg7sW_s0uuO_zfPW+8MjWd__ZZzKpL34A@mail.gmail.com>
Subject: Re: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 9:02 PM Paolo Bonzini <pbonzini@redhat.com> wrote:

>
> I have a similar patch for the old MMU, but it was also replacing
> shadow_root_level with shadow_root_role.  I'll see if I can adapt it to
> the TDP MMU, since the shadow_root_role is obviously the same for both.
>

Hello, Paolo

I'm sorry to ask something unrelated to this patchset, but related
to my pending work.

I will still continue to do something on shadow_root_level.  But I
would like to wait until your shadow_root_role work is queued.
And is it a part of work splitting the struct kvm_mmu?

Thanks
Lai
