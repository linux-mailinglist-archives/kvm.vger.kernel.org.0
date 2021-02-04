Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D746230F31C
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 13:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhBDM0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 07:26:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42486 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235804AbhBDMZ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 07:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612441472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=desXTW/pheCLBSR65rhQYJIsfviRlHkrz8lMFVWRLBk=;
        b=TdadVFVn8jc+k5Z9lmE2lJK6XbZE4WlGrZ4f+dA3EnvyFqJjCfTwFaD9CJS7Iud39Bkzi5
        HkHmVSe2dPGKj/HhARzyS/+FV5WN0xa725UDNajHiOj0Ht5aBwY4t/PwpMIizSU7w4Nqjp
        oivYIkZZ4sdUNkjVq+9TIpn5s8yZ4XI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-_z7pg8taNwuv7k1xKWWKSw-1; Thu, 04 Feb 2021 07:24:31 -0500
X-MC-Unique: _z7pg8taNwuv7k1xKWWKSw-1
Received: by mail-ed1-f69.google.com with SMTP id f21so38383edx.10
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 04:24:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=desXTW/pheCLBSR65rhQYJIsfviRlHkrz8lMFVWRLBk=;
        b=X4d7kOtdD97ZrCde78fZ4zGQcck0516r2oh53PKQ8b0ZGHjCndSbT1oSZInZDS0os6
         PyK/57X0mlRhWuH63Iprq7hnkPILT7DaCNQCNlrOUlkBO7qRAG5zApiFNJ6mG+kv+nq+
         8ASSqUW/YLYf4fGnMEQ1ov1L+KeeqvMmEgTZjnTLbbyNrSOXWyL6W2fD4prnehl+MjGD
         dKymNbtrEI6eFYfISPsEYWeH6zX1WXweWSITpAac2PWUYcu5SJqS64ZbpdjDfzxay82z
         pkotl/Z1G9YdzI/eXHmIn2pyHGUFCyEq+46eAe4lDPPIKe+K0YtcwqeG7Ad/8GQmJcNd
         QndA==
X-Gm-Message-State: AOAM533wOfKeFBc40GZyxTNVepCqkshFMHrBB/wHhXAtumXA2+FEkA5L
        uBcoZ29HF3T7pWSs9tFK4sBgWuwD4j/gEmg6qG50iG7m4oStWlcla7X155VKV3DEmfvQfGKZU53
        PKqEq0ylv5pa6
X-Received: by 2002:aa7:de14:: with SMTP id h20mr689335edv.95.1612441470392;
        Thu, 04 Feb 2021 04:24:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLQh5NF5zE0G7M0wrnnvFKe8qybVOeTgdq6IqrjOcxWzSyXAbk1exP3/8+tQKXH8iU+CnZ5w==
X-Received: by 2002:aa7:de14:: with SMTP id h20mr689326edv.95.1612441470229;
        Thu, 04 Feb 2021 04:24:30 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y20sm2297293edc.84.2021.02.04.04.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 04:24:29 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Kechen Lu <kechenl@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: RE: Optimized clocksource with AMD AVIC enabled for Windows guest
In-Reply-To: <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
Date:   Thu, 04 Feb 2021 13:24:28 +0100
Message-ID: <87zh0knhqb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kechen Lu <kechenl@nvidia.com> writes:

> Hi Vitaly and Paolo,
>
> Thanks so much for quick reply. This makes sense to me. From my understanding, basically this can be two part of it to resolve it. 
>
> First, we make sure to set and expose 0x40000004.EAX Bit9 to windows guest, like in kvm_vcpu_ioctl_get_hv_cpuid(), having this recommendation bit :
> -----------------------
> case HYPERV_CPUID_ENLIGHTMENT_INFO:
> ...
> +	ent->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
> -----------------------

This also needs to be wired through userspace (e.g. QEMU) as this
doesn't go to the guest directly.

>
> Second, although the above could tell guest to deprecate AutoEOI, older Windows OSes would not acknowledge this (I checked the Hyper-v TLFS, from spec v3.0 (i.e. Windows Server 2012), it starts having bit9 defined in 0x40000004.EAX), we may want to dynamically toggle off APICv/AVIC if we found the SynIC SINT vector has AutoEOI, under synic_update_vector(). E.g. like:
> -----------------------------
> if (synic_has_vector_auto_eoi(synic, vector)) {
> 	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
> 	__set_bit(vector, synic->auto_eoi_bitmap);
> } else {
> 	kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_HYPERV);
> 	__clear_bit(vector, synic->auto_eoi_bitmap);
> }
> ---------------------------------

APICV_INHIBIT_REASON_HYPERV is per-VM so we need to count how many
AutoEOI SINTs were set in *all* SynICs (an atomic in 'struct kvm_hv'
would do).

> Curious about what current plan/status of upstream is for this. If
> that's doable and not current pending patch covering this, I can make
> a quick draft patch tested and sent out for reviewing. 

I checked Linux VMs on genuine Hyper-V and surprisingly
'HV_DEPRECATING_AEOI_RECOMMENDED' is not exposed. I'm going to pass it
to WS2016/2019 and see what happens. If it all works as expected and if
you don't beat me to it I'll be sending a patch.

-- 
Vitaly

