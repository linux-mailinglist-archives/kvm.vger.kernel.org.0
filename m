Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136553D2B7D
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGVRMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 13:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31770 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230075AbhGVRMr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 13:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626976402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUGEDrvDrkdnybG4YE3OQFBFsKppcfcF1RVLI038sIo=;
        b=c4FnsIwxltA8eTkmGUXfKPSLsjTi7bmJ+e0+i5bD3+D9sX5x0LiTmj+VWrjJWt7wtIgS0s
        Mn7i4Fqdt97r6Ld/EpPQcEiNc+mpRTOZVmg7+HF/afChXI/N2v96fNSvU8FWaXMbUQ1nfK
        bV1+zRhLR0ljqEukzzdO5a27HiyH4T8=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-13aQCVnrPROQ7qRxZ9UUPQ-1; Thu, 22 Jul 2021 13:53:21 -0400
X-MC-Unique: 13aQCVnrPROQ7qRxZ9UUPQ-1
Received: by mail-ot1-f69.google.com with SMTP id 61-20020a9d08430000b02904b9e704387aso4143327oty.12
        for <kvm@vger.kernel.org>; Thu, 22 Jul 2021 10:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BUGEDrvDrkdnybG4YE3OQFBFsKppcfcF1RVLI038sIo=;
        b=iFslwSVGFs5F6e1luOWjZZ4O8rZQMNQlMkj5zT0MFdQ0oXerRNFp5F0cg7s41eec7c
         lUBEdyeQDaZEALG8S5GgHEsduogmqdfTMo4/IYQoQSZy8p0gaBe8BGaHfoOxspfsuYHf
         zvGkku1jMt7xD82rzYRgLK4wjtp9Mzd61fIiFvDJ1Zq3Zb3MhFcerXF7UsX5LQuG2is2
         amaSkN24fC1jPGSOpg+75+AdBPZTigzDqT1hCuJVu+VFTdfzZ7UQvAatKEY+txShM6zi
         7bP489/d8AjQhzNeAwfoRv0kUY9ZeCpcnuZ7qyeDVFrXATzj4bb1AWbCgaOjZIWPXAX3
         AMpA==
X-Gm-Message-State: AOAM531RSBC9d7lM9qfM9Yqo4AceUQmgi1g+Tan+TG/ufTL1CtkFjULK
        01DZw1va372w7ALtnch5n4EN+Jn8C780KFYeREq5VFShPrsxuGNezvncnQmosvNIBHA8995gjpe
        FCJ4ISm78y+9uR555JJ+3/DVrnFqngRtpA0+YTTr4zVrefKCo7uukNQlhcXZHXQ==
X-Received: by 2002:a54:488f:: with SMTP id r15mr857583oic.130.1626976400423;
        Thu, 22 Jul 2021 10:53:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVc9F1fOlsFQ9LMMFmUvcXX0lsG4ZB1b5VWL93dfX7guKilv+syk2srUjxQkEMcJAidUEAPQ==
X-Received: by 2002:a54:488f:: with SMTP id r15mr857561oic.130.1626976400271;
        Thu, 22 Jul 2021 10:53:20 -0700 (PDT)
Received: from [192.168.0.173] (ip68-102-25-176.ks.ok.cox.net. [68.102.25.176])
        by smtp.gmail.com with ESMTPSA id l7sm98923oie.32.2021.07.22.10.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:53:19 -0700 (PDT)
From:   Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v2 12/44] target/i386/tdx: Finalize the TD's
 measurement when machine is done
To:     isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, alistair@alistair23.me, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, cohuck@redhat.com,
        mtosatti@redhat.com, xiaoyao.li@intel.com, seanjc@google.com,
        erdemaktas@google.com
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <a9948a7cd4f002ba4c3161287b366f4378523502.1625704981.git.isaku.yamahata@intel.com>
Message-ID: <b4cc314b-1ba9-122a-f9c3-2d5b528f5f73@redhat.com>
Date:   Thu, 22 Jul 2021 12:53:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a9948a7cd4f002ba4c3161287b366f4378523502.1625704981.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/21 7:54 PM, isaku.yamahata@gmail.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Invoke KVM_TDX_FINALIZEMR to finalize the TD's measurement and make
> the TD vCPUs runnable once machine initialization is complete.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   target/i386/kvm/kvm.c |  7 +++++++
>   target/i386/kvm/tdx.c | 21 +++++++++++++++++++++
>   target/i386/kvm/tdx.h |  3 +++
>   3 files changed, 31 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index be0b96b120..5742fa4806 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -53,6 +53,7 @@
>   #include "migration/blocker.h"
>   #include "exec/memattrs.h"
>   #include "trace.h"
> +#include "tdx.h"
>   
>   //#define DEBUG_KVM
>   
> @@ -2246,6 +2247,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>           return ret;
>       }

This is probably a good place in the series to update the comment
preceding the sev_kvm_init call since TDX is now here and otherwise
the comment seems untimely.

Reviewed-by: Connor Kuehl <ckuehl@redhat.com>

