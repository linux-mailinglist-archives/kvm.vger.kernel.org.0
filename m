Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6166200B0B
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 16:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732907AbgFSOKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 10:10:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726275AbgFSOKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 10:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592575848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQGcTYNZ0qd2ZL6M4exRQEolMRV74PfXhnhqE6+gOjU=;
        b=AvBjJy69VReMQPVLUz7wBhOr0jXBJ9EK8oxomptNJw2eYsXutARoFLqXLazQW1HJH10+O/
        9pnezOQd+4/1HS3vpYX1W9emOgCLn06qXSaKPLv3yhIzICUGWlftLDSO0vYv4brT3zFSDq
        6xkezGQSqPASZCstu5QsKNob2UKM7mM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-f_3dPH-wOb6URru_YdNZ3w-1; Fri, 19 Jun 2020 10:10:46 -0400
X-MC-Unique: f_3dPH-wOb6URru_YdNZ3w-1
Received: by mail-wr1-f70.google.com with SMTP id a4so4327420wrp.5
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 07:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OQGcTYNZ0qd2ZL6M4exRQEolMRV74PfXhnhqE6+gOjU=;
        b=A2Bp2zR3PBQe4zgORWg0bFIJtall84sb9LScQnDl79uftCCowkdNbQ9KdVCliAJfvj
         y3sHkQKIv41DNrDWhmdKV1LUnznaMgDKIO8u7xT/xNBO2JL2GaRyjAqc1J83MiJqq9wc
         jMNfewe38a63OSL6vaoXXNWs1Vg99Cq4sPzqkMIrwq7lsAIOhc/VhBlKdazJKDlKlixm
         Su2XHtDzteO5d+F9CTMfmhr6zDEn/C2/3skmllVD4jDFJOQ+jM0p7gzM8bwMES5OaJRz
         89ELvsZPYV0WyEOMfJZr65nFudVQb2ut/d4TSehb/dPBWmsYm44x6uKkRbSRMcKNdjur
         jvTg==
X-Gm-Message-State: AOAM532BVHhY/BNrb1Aq/T6T6nFqTULRSt6QnY/3DqB1QWVsVUrLaLaW
        4qGPL0IUbMGfq1U/0U37xrRS6u/5d5N0s8+Bzn66Z3Y0WZ8DwYGujKLy5P5gTn0dQf5tom2fS3n
        4ayQC6bacQts5
X-Received: by 2002:a1c:4e1a:: with SMTP id g26mr3416506wmh.148.1592575845677;
        Fri, 19 Jun 2020 07:10:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2lf9yJVDZ3TMxLfmzqD+pzoOr6W+H3pQlOKmVqwKx1RlwQw91jzYg+uud8qh9pLidgwOIBw==
X-Received: by 2002:a1c:4e1a:: with SMTP id g26mr3416482wmh.148.1592575845471;
        Fri, 19 Jun 2020 07:10:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id e12sm7410682wro.52.2020.06.19.07.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:10:44 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: LAPIC: Recalculate apic map in batch
To:     Igor Mammedov <imammedo@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
 <20200619143626.1b326566@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3e025538-297b-74e5-f1b1-2193b614978b@redhat.com>
Date:   Fri, 19 Jun 2020 16:10:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200619143626.1b326566@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 14:36, Igor Mammedov wrote:
> qemu-kvm -m 2G -smp 4,maxcpus=8  -monitor stdio
> (qemu) device_add qemu64-x86_64-cpu,socket-id=4,core-id=0,thread-id=0
> 
> in guest fails with:
> 
>  smpboot: do_boot_cpu failed(-1) to wakeup CPU#4
> 
> which makes me suspect that  INIT/SIPI wasn't delivered
> 
> Is it a know issue?
> 

No, it isn't.  I'll revert.

Paolo

