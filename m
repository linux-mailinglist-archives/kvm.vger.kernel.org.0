Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C297178354
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 20:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgCCTrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 14:47:14 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:38256 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgCCTrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 14:47:14 -0500
Received: by mail-io1-f68.google.com with SMTP id s24so5005659iog.5
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 11:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYEGzJaqhNf5Si1WVdKYuss+VQrNfRTnUDch8h1VFp4=;
        b=GSAXVdrI94SUESSdBleH3jDgP6jRMnxgLq0+ftHpcgUnXl6qfl6zsTSineXHyhlR0d
         zfbbhVcRqrY5js/PG8qg3opRphcGnP8wYsOUWFeLe+98o3oLUozWOtOm7e8OS1KzR5Dp
         xgqbUSNbW4YiZ36A2rZyuTk/6vpP/9U/nAu/0/Viu/WxXB3gFdeZ+0hsfi62pyrqrzGn
         UwsnMjRIe3yYHfjvU983WhbxXUU5HyJPyblipc22n6c1RxWV25iMgxB7uAVyOI6mnc/l
         N3LWJwcwCZBXZQqgNvA19yhufVFMUbfpu2P6wJJFyn6sSheWUR1PUDjoKzWy3yvQ+/yk
         jMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYEGzJaqhNf5Si1WVdKYuss+VQrNfRTnUDch8h1VFp4=;
        b=LMfQHQRvmpZo+hYGCi0DRoOVTVVLRz28dn5njBXZ4H7NfMHgbt/0FEjcR3S+JhSoNR
         bkTMALuA6A+j2bxKXu3dyrPM/PRc1aS09M1bw7wDCeZH8QEHNAHIEi2rDUWgEk7XulYC
         RnC28bWX5dtOpf9pc7QRnowjZWMweZ/cBimSspNIA8tw5Pd3yjZM3O57izu4oujUb9T6
         ax+0tlsbKf4Wx0RwOI1g0mc7R5AUByqgE6xhS5pAYMx9pExLSwc0Fq/NxtcnFuUBbqW7
         GO39xuFyL+t7K95Fqob3pQsATD3eqKOYVWYtLiYgWSnZoSLKLuWkLjJ3sJmCHnC16mWo
         Y4wA==
X-Gm-Message-State: ANhLgQ0P7zaLKrksbwK/nKCkc2FtSMlfr1t4pyyb6VXnigrgC6lI+ecO
        IU9IfCvXNtji2KWFUvXmee1v7wjvmQVxfAZk6fwyQQ==
X-Google-Smtp-Source: ADFU+vsurLOTxbMmQh0mQALAJjNIg4PKrV6qg1gLP2CeSmwzyJeG4Gzbcu3Be16z4ljpWT0t36ooK5e+P5aI4MVWqI4=
X-Received: by 2002:a6b:e807:: with SMTP id f7mr5411334ioh.26.1583264833075;
 Tue, 03 Mar 2020 11:47:13 -0800 (PST)
MIME-Version: 1.0
References: <20200302235709.27467-1-sean.j.christopherson@intel.com> <20200302235709.27467-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200302235709.27467-2-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Mar 2020 11:47:01 -0800
Message-ID: <CALMp9eQthG5SMFhNuF4UJeRS+FXq16pD09fv=itNPX4sPgWN6w@mail.gmail.com>
Subject: Re: [PATCH v2 01/66] KVM: x86: Return -E2BIG when KVM_GET_SUPPORTED_CPUID
 hits max entries
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 2, 2020 at 3:57 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Fix a long-standing bug that causes KVM to return 0 instead of -E2BIG
> when userspace's array is insufficiently sized.
>
> This technically breaks backwards compatibility, e.g. a userspace with a
> hardcoded cpuid->nent could theoretically be broken as it would see an
> error instead of success if cpuid->nent is less than the number of
> entries required to fully enumerate the host CPU.  But, the lowest known
> cpuid->nent hardcoded by a VMM is 100 (lkvm and selftests), and the

I have an existence proof for 98. :-)

> largest realistic limit on Intel and AMD is well under a 100.  E.g.
> Intel's Icelake server with all the bells and whistles tops out at ~60
> entries (variable due to SGX sub-leafs), and AMD's CPUID documentation
> allows for less than 50 (KVM hard caps CPUID 0xD at a single sub-leaf).
>
> Note, while the Fixes: tag is accurate with respect to the immediate
> bug, it's likely that similar bugs in KVM_GET_SUPPORTED_CPUID existed
> prior to the refactoring, e.g. Qemu contains a workaround for the broken
> KVM_GET_SUPPORTED_CPUID behavior that predates the buggy commit by over
> two years.  The Qemu workaround is also likely the main reason the bug
> has gone unreported for so long.
>
> Qemu hack:
>   commit 76ae317f7c16aec6b469604b1764094870a75470
>   Author: Mark McLoughlin <markmc@redhat.com>
>   Date:   Tue May 19 18:55:21 2009 +0100
>
>     kvm: work around supported cpuid ioctl() brokenness
>
>     KVM_GET_SUPPORTED_CPUID has been known to fail to return -E2BIG
>     when it runs out of entries. Detect this by always trying again
>     with a bigger table if the ioctl() fills the table.
>
> Fixes: 831bf664e9c1f ("KVM: Refactor and simplify kvm_dev_ioctl_get_supported_cpuid")
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
