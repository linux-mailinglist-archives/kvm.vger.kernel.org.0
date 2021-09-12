Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15CC407C19
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 09:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhILHGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 03:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhILHGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Sep 2021 03:06:52 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D33C061574
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 00:05:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k17so3838509pls.0
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 00:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNpLnODXD3KMtIbZW9KjXBpb07wZf63uyRmwVpvp6IQ=;
        b=KS9b8sBMavB5IM/KGnAEWQlq7rcYa7fBiZ5xKnoY5Mef+At1q0wBN1hS5AW3dW2KDO
         ltQOtyijdPz/7V6QMRljKwGSuEFjsbpJMI6YxmWvpOAves6kHDJWe21DjFj3blFFVBBE
         NcAhkl+fdkP1Ww5MHqA9WYZ/SF6fwCG5QXN8cmxHVvPgFGWRWHivy4WoHgh54LuOrNo3
         RSwPItRUJ7XTMyUztTyG/md/pUYZ/siRmme/3DH8RLknVR7UfxtItclIvSa+P6X7KNu3
         n9A0utp4LeyUrBdIQIBFpsm3QKkjqS5IdCUiD4LyoFRHpwUsJQsAmJDslrNJ0et7xf9T
         SUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNpLnODXD3KMtIbZW9KjXBpb07wZf63uyRmwVpvp6IQ=;
        b=DiY8NQFmICZt+q3nopXYP2SDAkdkGWJL2+93weO5yGKUx22qg0vIb9zpZm9sU+Q60O
         a2uCRwlXNKX4GlQLKFL5VMkvgaTFMpgoe3w88czBxBPHeupUfsy1QoDVtwkQ+kfXaK0B
         hOIERW2Vkj/3j2/fUtM165CqmCnUbLn1HYnu2F4ea8YmvjA81bATiHHr97M/QIb5qgGp
         gO1Hb1erf4i5FM0q6qXk0gSEPCCl74i0jUhmvzTvEuXc8FFNu3XGkDrnbu+Sa5Pe8Cx2
         yuMoLuQlD+xTVGkWRCCB/0FKyiSqiD5tXKUsWxb00mg/iFIHcvWDc2ST41DdoKG74zT8
         xrnQ==
X-Gm-Message-State: AOAM532woj5w7zyhBvMTKmOONu0SK/+VYa2Eqo+vaHMmo94E8QNaCiVw
        Ka1MNHOQEeJ9AXsO02Gf+GHw8kgoEiWrO02Xmh/psQ==
X-Google-Smtp-Source: ABdhPJxdd84H/DsUuLXrFrUnP2cmjHGR9a4YQXIREdU5uKBdYshF8RaY9FwAu6nWcCNUpa+wHuqKzNOa3l5fx2WmBN4=
X-Received: by 2002:a17:902:654c:b0:13a:5661:3d33 with SMTP id
 d12-20020a170902654c00b0013a56613d33mr5222572pln.40.1631430338122; Sun, 12
 Sep 2021 00:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-10-rananta@google.com>
In-Reply-To: <20210909013818.1191270-10-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sun, 12 Sep 2021 00:05:22 -0700
Message-ID: <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu and all,

On Wed, Sep 8, 2021 at 6:38 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on. As a result, introduce
> get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> backend, the VMM prepares a map of vcpuid and mpidr during VM
> initialization and exports the map to the guest for it to read.

How about using TPIDR_EL1 to hold the vcpuid ?
i.e. have aarch64_vcpu_setup() set the register to vcpuid and
guest_get_vcpuid() simply return a value of the register.
This would be a simpler solution to implement.

Thanks,
Reiji
