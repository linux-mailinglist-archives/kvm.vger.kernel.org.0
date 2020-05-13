Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0637E1D1889
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 17:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389378AbgEMPB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 11:01:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44347 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389054AbgEMPB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 11:01:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id 50so20766386wrc.11;
        Wed, 13 May 2020 08:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ySQYNCFJieFw49hebY3MJRxVr5zT7izYFnFzCl37LtQ=;
        b=ukoJt9BWtiaSr+NEzfjybj9b4MErjJAgb8nUVyNDbzC8uDPL7csNpDS5DjiMPOK6r/
         uM7+A+RMBf8nupqkzmxFOFtcyyton1BaSom4eqnWqJMo/l6PsxqMP4NIZD/J18TjLakn
         fS4NwDlU5TXwwX5DRBA2L94a208OP1MwxWdGDxk78KG/x4cjlz0u+LmZOZZsn3ivUAA/
         jSFQVs7AsPGz7et5kUV/tnwOEjVLzLe2LhoeWVKJEew0NPCDw4ZrOw+F5AHJgBa8GHQa
         o011hVUFQTviWTibkrmVA9lMDBHlgMRPg15oHebaeI9urXBIiCmfbgUwvxET6CdVwqED
         BFVw==
X-Gm-Message-State: AGi0PuYsqTDNKAv+GGejJ0YvIn8PMN7mcuCnFbvMpj4jNGsumnSjtpNA
        CnjB25RhodowmpbjXdPPj/U=
X-Google-Smtp-Source: APiQypJgZBp+xJJRlLfto0u7+TAJ63AvPCwqvbP8TiD3U2a/e+i8K84AM43rOUVJ7f2Lh/Wjf6YJ1g==
X-Received: by 2002:a5d:6841:: with SMTP id o1mr31448481wrw.412.1589382115833;
        Wed, 13 May 2020 08:01:55 -0700 (PDT)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b2sm25334319wrm.30.2020.05.13.08.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 08:01:55 -0700 (PDT)
Date:   Wed, 13 May 2020 15:01:53 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: Re: [PATCH] x86/hyperv: Properly suspend/resume reenlightenment
 notifications
Message-ID: <20200513150153.2xi4v2ekpv7zmofo@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
References: <20200512160153.134467-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512160153.134467-1-vkuznets@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 06:01:53PM +0200, Vitaly Kuznetsov wrote:
> Errors during hibernation with reenlightenment notifications enabled were
> reported:
> 
>  [   51.730435] PM: hibernation entry
>  [   51.737435] PM: Syncing filesystems ...
>  ...
>  [   54.102216] Disabling non-boot CPUs ...
>  [   54.106633] smpboot: CPU 1 is now offline
>  [   54.110006] unchecked MSR access error: WRMSR to 0x40000106 (tried to
>      write 0x47c72780000100ee) at rIP: 0xffffffff90062f24
>      native_write_msr+0x4/0x20)
>  [   54.110006] Call Trace:
>  [   54.110006]  hv_cpu_die+0xd9/0xf0
>  ...
> 
> Normally, hv_cpu_die() just reassigns reenlightenment notifications to some
> other CPU when the CPU receiving them goes offline. Upon hibernation, there
> is no other CPU which is still online so cpumask_any_but(cpu_online_mask)
> returns >= nr_cpu_ids and using it as hv_vp_index index is incorrect.
> Disable the feature when cpumask_any_but() fails.
> 
> Also, as we now disable reenlightenment notifications upon hibernation we
> need to restore them on resume. Check if hv_reenlightenment_cb was
> previously set and restore from hv_resume().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Applied to hyperv-fixes.

Thank you all.

Wei.
