Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3153D1A2983
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 21:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgDHTor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 15:44:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49289 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729156AbgDHToq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 15:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586375086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYYuwLAboUvtz1WhP7yhVmIyNIoHfRUcQsmccBnO09E=;
        b=K9Y4Lzsy2CgWrCOFQQUVWjVuQTKAt6K242ReokOrRcW7hyQWXxqziuQGwzrTvSFahHeMyr
        pKjhIKsjKl96ZrJ3eb5PvkJdy9M3oN9t+TZLGHWCi9l9yEwhcoTrHFg/TMYgzCl07oH6WZ
        NF1SL9BLRPE9u9MFpB3g9u1Us9ww7No=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-AsNEqCDVP4-u-6VbAH3FpQ-1; Wed, 08 Apr 2020 15:44:41 -0400
X-MC-Unique: AsNEqCDVP4-u-6VbAH3FpQ-1
Received: by mail-wm1-f69.google.com with SMTP id a4so810222wmb.3
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 12:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mYYuwLAboUvtz1WhP7yhVmIyNIoHfRUcQsmccBnO09E=;
        b=XPGCayYkSNhEnjEWwAPoIwtMuAzXc+cz8tSHIcd9AgE2XvKqozSpVhWxO+oK7bof2d
         kjqIJEL4nl0P/NfOChyGpAJmbntXc0ABHa4AUnx1DCclSIINOTCrv+wvDOEQrb6J8yoH
         Y3ZZW77FieWGWx0hzuPhl+MS45lD3bH3SAuCUOoh84afNR1GU4eMAyYoMthRXkMVf8Fe
         IqSEE8iHFpWNbx7bVe1nJmcQ8wxbwACos6yWVGKb9RRvTX5IhSnoE4TFBLbBnieF9Kqo
         YLoPobAqSBGx64TxwMbSndu9242GtsAg+AoZenty9jHZyv1Ee12aOpFBMJyC/rh91A2J
         JR2A==
X-Gm-Message-State: AGi0Pub/rlJ5SbY3C9GgsBqGAf+f9JQOEuOvJwClxZmSDKYvajWuSjQB
        nBbGK0fwdJiwrqg8oQBPTBWbwWXwT8/MrvqugmZB6kw1aqQThZTrI2eV5O6vyctQscPRUWluarT
        ++RWT+t66kXei
X-Received: by 2002:a5d:66c4:: with SMTP id k4mr10871376wrw.53.1586375080349;
        Wed, 08 Apr 2020 12:44:40 -0700 (PDT)
X-Google-Smtp-Source: APiQypIlH1aPoYyskSLdulU2tyWq3L8x3JFlR6vFlGhIt4V5eB9TSlTUoLEINUgOmGMdu27vvjmcVQ==
X-Received: by 2002:a5d:66c4:: with SMTP id k4mr10871361wrw.53.1586375080112;
        Wed, 08 Apr 2020 12:44:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u7sm724203wmg.41.2020.04.08.12.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 12:44:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dzickus@redhat.com, dyoung@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
In-Reply-To: <20200408151808.GS2402@MiWiFi-R3L-srv>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com> <20200407110115.GA14381@MiWiFi-R3L-srv> <87r1wzlcwn.fsf@vitty.brq.redhat.com> <20200408151808.GS2402@MiWiFi-R3L-srv>
Date:   Wed, 08 Apr 2020 21:44:37 +0200
Message-ID: <87mu7l2256.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Baoquan He <bhe@redhat.com> writes:

> On 04/07/20 at 02:04pm, Vitaly Kuznetsov wrote:
>> Baoquan He <bhe@redhat.com> writes:
>> 
>> >
>> > The trace is here. 
>> >
>> > [  132.480817] RIP: 0010:crash_vmclear_local_loaded_vmcss+0x57/0xd0 [kvm_intel] 
>> 
>> This is a known bug,
>> 
>> https://lore.kernel.org/kvm/20200401081348.1345307-1-vkuznets@redhat.com/
>
> Thanks for telling, Vitaly.
>
> I tested your patch, it works.
>
> One thing is I noticed a warning message when your patch is applied. When
> I changed back to revert this patchset, didn't found this message. I didn't
> look into the detail of network core code and the kvm vmx code, maybe it's
> not relevant.
>
>
> [ 3708.629234] Type was not set for devlink port.
> [ 3708.629258] WARNING: CPU: 3 PID: 60 at net/core/devlink.c:7164 devlink_port_type_warn+0x11/0x20
> [ 3708.632328] Modules linked in: rfkill sunrpc intel_powerclamp coretemp kvm_intel kvm irqbypass intel_cstate iTCO_wdt hpwdt intel_uncore gpio_ich iTCO_vendor_support pcspkr ipmi_ssif hpilo lpc_ich ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter pcc_cpufreq i7core_edac ip_tables xfs libcrc32c radeon i2c_algo_bit drm_kms_helper cec ttm crc32c_intel serio_raw drm ata_generic pata_acpi mlx4_core bnx2 hpsa scsi_transport_sas
> [ 3708.640782] CPU: 3 PID: 60 Comm: kworker/3:1 Kdump: loaded Tainted: G          I       5.6.0+ #1
> [ 3708.642715] Hardware name: HP ProLiant DL380 G6, BIOS P62 08/16/2015
> [ 3708.644222] Workqueue: events devlink_port_type_warn
> [ 3708.645349] RIP: 0010:devlink_port_type_warn+0x11/0x20

What's in the patchset you're testing? Is it Sean's series + my patch,
or just my patch? In case it's the later I'm having hard times trying to
see how this can be related, but in case it's the former the fact that
we do stuff a little bit differently on kexec may actually be triggering
the issue above. I still think that it's not causing it, just
triggering.

-- 
Vitaly

