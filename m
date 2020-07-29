Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB6623168E
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 02:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbgG2ACg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 20:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730282AbgG2ACf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 20:02:35 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6F1C0619D2
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 17:02:35 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v6so7450159iow.11
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 17:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BysJeb3iQD5vGPtfIq4YN/NdeUFzN5qXc6Nj007yDgY=;
        b=KYuNfQWUvhero7fgC1nxKXVhzoZXAdiQlBMDENFrmySZLwslRvGkVqsN1JrS5PBW2i
         GYse/5I9omCMOE8bYAYz+ffQpz4PrdLxuKfyEs/MOuMZvppHfhizZ6PZ527VAP6vvlsQ
         XZ2ib5mZnf7621v96nwP5AXioRD9tsIs3B5T0jkLqg/4pqvqdr03VvHHg02oZYmQqjfa
         BUTa/le0+qXZ7O0kJou4+l57zvPrnRI2eTRyG7ude8A86HyQxp/SdlIPGDcz/JK9Cv+H
         Z2/Vqf0YGElj/7BE/huc2eCEAVQDyDg7vSV2oCXj7zQay1nsm7C8qvU81MIgiRsvYA4l
         4Hqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BysJeb3iQD5vGPtfIq4YN/NdeUFzN5qXc6Nj007yDgY=;
        b=gJBGfZWcOCvUE6ir8XFNmu9MgfwtaH/6ZJPWFZFM0wrG9XoJoour0+Y6yF3sNS+bSD
         SGFppZckRcWb/SGwsQi7Db9O5vZ4Ifdt5o4rmWIZpnepVNwaHFaXZtbquWvKIn2MsQ+/
         rYr/Usis8jmY9n3lsqx9NvvvdL6YL4EtFwgbMSpoleGb3mPv64WMfBoPnsEVW1q5F+u4
         bILZuxS+uwr131h3TE/amcRQX2OUNBuPZKvj595v8fZB9be5SoSi+2y2yXyTq5DZk9oK
         HdiraWv/yp86hCfPzVDfoB3PgBsNYxoNrDEYgCXO4MAIluNkabd/2BLNrdjxR3zqBKWF
         zgug==
X-Gm-Message-State: AOAM530vcrzeQ/zBsvYfe9VUgNocN8vFpg2VEYr12RJnl6Reup5YFOpj
        zBV6AIX5RYSTLDeEP2D0jFVrdfWgUQJw2aVkAgE5jA==
X-Google-Smtp-Source: ABdhPJzoW6X8J7Se9DegIA8iSwEkK+p8RiSH15MOOKLa7qwtDBxfbi0pP0OJQF6u2lxbV7D+YQtNAv0cYgpJb+viEHA=
X-Received: by 2002:a05:6638:1685:: with SMTP id f5mr11856670jat.48.1595980954633;
 Tue, 28 Jul 2020 17:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597951369.12744.9730595628680359060.stgit@bmoger-ubuntu>
In-Reply-To: <159597951369.12744.9730595628680359060.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jul 2020 17:02:23 -0700
Message-ID: <CALMp9eQvQ4D3t0uaqY_S1nKS6bt2DPUgKScBL3ODiUFLxd2LFw@mail.gmail.com>
Subject: Re: [PATCH v3 07/11] KVM: nSVM: Cleanup nested_state data structure
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> host_intercept_exceptions is not used anywhere. Clean it up.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
