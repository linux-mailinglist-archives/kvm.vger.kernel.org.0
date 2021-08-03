Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7751A3DEF10
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhHCN3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 09:29:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44591 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236260AbhHCN3m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 09:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627997371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KcuyzBZVCsQzdOpIzaT9GhZQ70W+KOCymEeOniqVHmM=;
        b=E0a6+saCo8bQujt9Uh/bgJai7jcYSPmIP9U/fGsDUq7BOOx6eq+qiLSNzCfM8LT+JvZOrd
        To1YU1V65tgKBeyCTZRrMWfKBupii0ayLCN9nHH8CXStdUzyuWVz2d5PtbSyJoqgPDTYO/
        O/i/fY1qr5ezc2WBjX0BFmrqnDmvbCA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-gOG_8LJwPuyQIAoW-Ql7Vg-1; Tue, 03 Aug 2021 09:29:29 -0400
X-MC-Unique: gOG_8LJwPuyQIAoW-Ql7Vg-1
Received: by mail-pl1-f199.google.com with SMTP id u4-20020a170902e804b029012c4b467095so16618129plg.9
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 06:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcuyzBZVCsQzdOpIzaT9GhZQ70W+KOCymEeOniqVHmM=;
        b=RRXNX+GhehOl9vmYYmABUghb7CuW0oS4rfdmsaB9Ayu5/thMJ82OrQMDUjFGds8WPd
         d7D/xXnzhAUnEpbD97mhmQftrwDpwNzob4+BNpapNN4rjVpy3D1H/e4LKtQ36wgyZ95l
         kTJP18BpWun8GQk0KWT4TKu1gbKUSA0oKrLcJa5ZiTdwAzMCPLbbhtlHS6KOde1Nt5Hx
         SzfKAvGJOXf0DSsgfdqCxNXqhABeE65fMhf1r1f6y0NA10f55l1hHq+/If3lCppMU3Qj
         3cZJvZLwt2xClG/O1vSA56CpzcK1kUTS95dlzmNr13J58t7PdkV2cmSEBfXIWTilLu4F
         T2EQ==
X-Gm-Message-State: AOAM531eUhbQLn6yPcjqA3wC1WWphgVpmWfLKIIpTnwmyaxYCjB1zUs1
        O+AJTU26gl9ia8HtFswinpPC2hcqL2iLcUneWZ2m4V8+soxYi7xbZoNiiPXkv1SGPfVK+6iWLlM
        ueRyTViQRUyL75pNU/cWgc2iD82Xa
X-Received: by 2002:a17:90b:e10:: with SMTP id ge16mr19921910pjb.150.1627997368681;
        Tue, 03 Aug 2021 06:29:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzxa98h40WXZjb7MbKGaow2kMLBjuSDMzy/SK9GtPRKrme9h8m7Mim/oH4cNzNd2U3c+ZjB2RXr7Hl4V6qgAU=
X-Received: by 2002:a17:90b:e10:: with SMTP id ge16mr19921886pjb.150.1627997368395;
 Tue, 03 Aug 2021 06:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210730043217.953384-1-aik@ozlabs.ru> <YQklgq4NkL4UToVY@kroah.com>
 <CABgObfb+M9Qeow1EZy+eQwM1jwoZY3zdPJfZW+Q+MoWmkaqcFw@mail.gmail.com> <YQlAl7/GSHWwkzEj@kroah.com>
In-Reply-To: <YQlAl7/GSHWwkzEj@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 3 Aug 2021 15:29:16 +0200
Message-ID: <CABgObfamvoMai1b9hrPkt1uwgw0kozhU5V_Vvk1__k_sGnx4LA@mail.gmail.com>
Subject: Re: [RFC PATCH kernel] KVM: Stop leaking memory in debugfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> So userspace can create kvm resources with duplicate names?  That feels
> wrong to me.

Yes, the name is just the (pid, file descriptor). It's used only for
debugfs, and it's not really likely going to happen unless a program
does it on purpose, but the ugliness/wrongness is one of the reasons
why we now have a non-debugfs mechanism to retrieve the stats.

> But if all that is "duplicate" is the debugfs kvm directory, why not ask
> debugfs if it is already present before trying to create it again?  That
> way you will not have debugfs complain about duplicate
> files/directories.

That would also be racy; it would need a simple mutex around
debugfs_lookup and debugfs_create_dir. But it would indeed avoid the
complaints altogether, so I'll prepare a patch.  Thanks,

Paolo

