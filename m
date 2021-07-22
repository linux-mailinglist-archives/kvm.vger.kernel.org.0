Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7AD3D2B73
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhGVRMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:12:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhGVRML (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=raFWkEmfEsnXA+zlkTsH/h7na1SeJw58CnlfHE/P3Ws=;
        b=gnVvuK8fqaIZG7AlrSswYZfYKicFKpztwpCe6yBY46ppedYykjBdcohQp96pQZtseHxNox
        63t8nJqQ8sH9DEMO5HUZEaPAk3UzIB4Ssle4fHMqetWqm0lkoIFCpnavEgzJxJkXMKzY0N
        c7aJRzTX5cD+5VINxuHbeGRgtXuXTuM=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-feiMbvB4O-6AnHM-qh13_A-1; Thu, 22 Jul 2021 13:52:45 -0400
X-MC-Unique: feiMbvB4O-6AnHM-qh13_A-1
Received: by mail-oi1-f198.google.com with SMTP id t11-20020a0568080b2bb029025af6d05d99so4469219oij.10
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=raFWkEmfEsnXA+zlkTsH/h7na1SeJw58CnlfHE/P3Ws=;
        b=s/LkNjtNrVjtw0awWaWggtUC75WADiBfP3+/P7IJIP2UfPP8OPvPt1yqLPEpM1cXNl
         1aA4POdxrJpOa7dFj2f7yah3ubcASk0lBpxrcon3W/oAE+owRfbPuI7XQnfh6MHlCurg
         BSOt/YAgjH+JC9A7SbSi4tWZZtV9PLb0AeMLsGgxcsUNZ2C50Y2cR2wNQrZSfdHQAJLr
         ShnX6hYZd1+m2UOq495x1JfUCGlahMEozciJZTnFZrFLspmrO2Xr7ix83BkDLBvwU1sJ
         uoOjPUNGGQXODMimuhfIoyGCNTH5Gc4LFwJe1boqhIsgmdKtrykjrPrzvqjSivDoHx+O
         Up5Q==
X-Gm-Message-State: AOAM53220M1fmAChttk/Q+BtUok+gqqec1NnZ9acjNhg4g56irLIknBS
        QZT6MXQRnMWyheokufEam+A8Hpalq7MQ/JMO5FArcEF3dRgKTT0PEywwJ28nNcr5ORiTgKlPGAW
        qEHFJ7n4EmqjKj4+uyq7MbAI6LmuT/rZFPjiZo2eh3KkLPG9KwTs2H+B/ZgDxcg==
X-Received: by 2002:a05:6830:438b:: with SMTP id s11mr636074otv.133.1626976364333;
        Thu, 22 Jul 2021 10:52:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYxdgdIkzUJlEvp1X0rIRGzY1SrQ7Xzkw/4Mpg1l/IcSoHndZi3iNwTfJV7xrpAXc4vqTTRA==
X-Received: by 2002:a05:6830:438b:: with SMTP id s11mr636051otv.133.1626976364091;
        Thu, 22 Jul 2021 10:52:44 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id b2sm2175904otf.40.2021.07.22.10.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:52:43 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 04/44] vl: Introduce machine_init_done_late
 notifier
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <80ac3e382a248bac13662d4052d17c41f1c21e3a.1625704980.git.isaku.yamahata@intel.com>
Message-ID: <e85e1aa1-0171-3236-4ce8-54b97b59b49b@redhat.com>
Date:   Thu, 22 Jul 2021 12:52:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <80ac3e382a248bac13662d4052d17c41f1c21e3a.1625704980.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce a new notifier, machine_init_done_late, that is notified after
> machine_init_done.  This will be used by TDX to generate the HOB for its
> virtual firmware, which needs to be done after all guest memory has been
> added, i.e. after machine_init_done notifiers have run.  Some code
> registers memory by machine_init_done().
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   hw/core/machine.c       | 26 ++++++++++++++++++++++++++
>   include/sysemu/sysemu.h |  2 ++
>   2 files changed, 28 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index ffc076ae84..66c39cf72a 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -1278,6 +1278,31 @@ void qemu_remove_machine_init_done_notifier(Notifier *notify)
>       notifier_remove(notify);
>   }
>   
> +static NotifierList machine_init_done_late_notifiers =
> +    NOTIFIER_LIST_INITIALIZER(machine_init_done_late_notifiers);

I think a comment here describing the difference between
machine_init_done and machine_init_done_late would go a
long way for other developers so they don't have to hunt
through the git log.

Connor

