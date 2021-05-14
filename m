Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3E3381410
	for <lists+kvm@lfdr.de>; Sat, 15 May 2021 01:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhENXHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 19:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 19:07:37 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA01C06174A
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 16:06:25 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id p20so308286ljj.8
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 16:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Owdkm20O79PlykIyit66QYvMD3Y28QrpwNYI4FamRhg=;
        b=YNmOydQi9rcAD8YxKva1QHfQhxtA8KCFr3emQ6It1PF/3EpSfAxhtQNxG5+IgDCKnq
         lEgrdDox696tElk4oTEQ785XzFGkuZIrnEYbIdWsSFGw2CfbZW2tfa6k6/kgIDd5dTdy
         4U74cjzRA99jtTCMlHqe+AXvlkVm8vfuXXiv5Y4zUArKtnYAobp5MP/y3nXIbIkRxXuE
         yItew7LU9UwT9att2SmGw+Ze//F/4w+3eNv9ISw8szGhTUpSA8l5eaxKmALI5YjtcGOm
         kE58UX08P96mZgz6vMXQjTEmFiVLCuey/XbxkJz4Ri/IAnMSfxFwZD4obHnUj5YXOMYm
         fqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Owdkm20O79PlykIyit66QYvMD3Y28QrpwNYI4FamRhg=;
        b=FQWcBKd74AvcyTLeY+yc2k2vYCOMUvARoFlaI7UdkNXWFdkCmKxU5QlAWyPpctkf5X
         SrDcJZrdE299DkRmg3PATFtmZZKbFzdmz7V7gg91D1zQ0ZSeLCZbIsqf5BaC0hyWRnNQ
         ulv3wlG6eCye6b19IHmPIKPcFdd6yrFGL/bO4N0Han6WK44BgNAIe3tMpPqpQMhNPI1M
         LCmK2HHKV8bNqt2vv+TJ4jbxkH18S6x/Vb7HUACrxyy1ln2HgMmJrbQMpg1z7LGLUhq/
         vQ8y4z3KY6FGrJFnildOeZpBvDlUUCFVd27mMJ7k2TOzdIWnaqPOfLi24dQE/F8fl9Bk
         RmQg==
X-Gm-Message-State: AOAM532v7D3eg10BmleXHcmbnmQIWs/Gw3CgNniuPZzP3kOoH46kozkb
        h8tQRG2th0jWgvjUU9NAYYWEXh3KsBhApfoRQel44A==
X-Google-Smtp-Source: ABdhPJw1LckCubjtA+4YC+4+xrdHdl6i4QmJ3KwgSsYPI/Kvl9K54AOy0cEIEYHOBAQCILITBdBe7CW7HNGUvdQwbDU=
X-Received: by 2002:a2e:a365:: with SMTP id i5mr40075227ljn.344.1621033583251;
 Fri, 14 May 2021 16:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
In-Reply-To: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 14 May 2021 17:06:11 -0600
Message-ID: <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
> exit code and parameters fail. Since the VMGEXIT instruction can be issued
> from userspace, even though userspace (likely) can't update the GHCB,
> don't allow userspace to be able to kill the guest.
>
> Return a #GP request through the GHCB when validation fails, rather than
> terminating the guest.

Is this a gap in the spec? I don't see anything that details what
should happen if the correct fields for NAE are not set in the first
couple paragraphs of section 4 'GHCB Protocol'.
