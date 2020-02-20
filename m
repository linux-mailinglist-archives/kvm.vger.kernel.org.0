Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA21E1654C1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 02:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBTB6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 20:58:40 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46578 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTB6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 20:58:39 -0500
Received: by mail-lf1-f68.google.com with SMTP id z26so1700321lfg.13
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 17:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=APKRCoSFNxgib98sarPirgAXkcwav8pwl6BIBPHcdbs=;
        b=NKdThx0bPVxpHUb69NDgwzZbIykBF1BDDoum+P7X0dNF/aReMWIoaxxfBX+ziIRcbt
         x69msV8BMwWGab0wDYywrLJLsx/6grxnE3BGe7sgxSI7V+I+zyj+2xzEXqkIis0+TaFk
         EsjKXVvbxnwgjXISXG8ERjXHmQLzZLqzzdNODf4EhAujT0WmSSn/4BLd3qSjAyREfzzd
         nSg41EKqK5Jj9FTLdFL+RtPxEG4/PzuP5HVihs61P4gWBTvswmlsPMTVswBUm8i29ctT
         xXgphN+c00ABnXeMpTFqm4fNETxtJx9E0OEDQiL2ry1pOZm8kd6OOVvuEw5a8uAOzaWd
         IYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=APKRCoSFNxgib98sarPirgAXkcwav8pwl6BIBPHcdbs=;
        b=i+DMzuCHp2mz0SK3Rr1kgyv6A8pGSGTt2sQtTW7N8C8TieQk1yy34VdTUTKmvfLm9b
         vThHlDDcjbrob2NxEwvRg/aKQOeOP8qmqeW1afFZjWKz+xsihbRKuY+ave+68aoifsMn
         9TwomLns3lpcezvXYXp+f0H/zBp968qQcOVVz0jVgHjRpEeJcvNAXSZ8lhucoSugv99G
         PduylnBCDiX1Y/j0h/B+K6fV0I4ITUoTC9DW3Y2dyj1xr+a70yt3gUj/nYwAC8MiExxz
         TWQ7WRUe8gQSTYoTv24iV9hJ+fJPYpxBnlnRqq1dh2diJ3TUO8/jQAtn5P8EpUKESNJN
         oBTw==
X-Gm-Message-State: APjAAAWExbryctfEWEJDzP58yiCjTHKDU/V6yD64PAjNm+VAw/KesErV
        Mt9Dp+ghFhq7P1LLveTqq6bsgaWrgK+5ecSRn2CaDw==
X-Google-Smtp-Source: APXvYqxhcK30GYHUtU/QVX8+NpEMN+/95AGHygz0x023NJRD6I1ewYSL8zwfq/EFS3IR7n9vr06IsIXLyn2e2AKiMKo=
X-Received: by 2002:a19:dc1e:: with SMTP id t30mr14962222lfg.34.1582163917327;
 Wed, 19 Feb 2020 17:58:37 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581555616.git.ashish.kalra@amd.com> <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
In-Reply-To: <a22c5b534fa035b23e549669fd5ac617b6031158.1581555616.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 19 Feb 2020 17:58:00 -0800
Message-ID: <CABayD+ch3XBvJgJc+uoF6JSP0qZGq2zKHN-hTc0Vode-pi80KA@mail.gmail.com>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor need to know the page encryption
> status during the guest migration.

One messy aspect, which I think is fine in practice, is that this
presumes that pages are either treated as encrypted or decrypted. If
also done on SEV, the in-place re-encryption supported by SME would
break SEV migration. Linux doesn't do this now on SEV, and I don't
have an intuition for why Linux might want this, but we will need to
ensure it is never done in order to ensure that migration works down
the line. I don't believe the AMD manual promises this will work
anyway.

Something feels a bit wasteful about having all future kernels
universally announce c-bit status when SEV is enabled, even if KVM
isn't listening, since it may be too old (or just not want to know).
Might be worth eliding the hypercalls if you get ENOSYS back? There
might be a better way of passing paravirt config metadata across than
just trying and seeing if the hypercall succeeds, but I'm not super
familiar with it.
