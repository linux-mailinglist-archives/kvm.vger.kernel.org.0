Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F11E26E4C2
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 20:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIQS47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 14:56:59 -0400
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:45408
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbgIQS4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 14:56:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az1aIDAZZr7Kq9VaJ9hFBOxARvn86lWH6y14QfXZq8xwy9KvrozF98Q4MdgGi61hV1ItED7uH1BYWsPKXfUTyb/YFfHggXamGNgxiDMM5dlUG2/9JbOv8c2mxZgdmQkCC9ACylEppe3WWxZ4c/KyyCPKKOvWX0ooqS4wTNw8naifTitdbFeMhy55hAe6JKQGXmM4PuYtC0yjoKTKMiUzd71cqzSbSYuhUIMGlj0vPfOLoKl12mKySpZt6rQvEGKrrr5X3ghX1Nv+8v2QNrqt4mOvpzD5GS62MoF+we8kW814Quc3bl0Zc/CL/ncdurjEsjvFdXVdq0C3TOHDeuD9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6+vN5WkjkKWb52Yf7oLvo87VA6rbdHjTCKbEGppwF0=;
 b=ItxYxEtvlTPm3vgH0cprelzjg93B3U/A4FaxwRbtLaSmvI7ug3GEPfMfLZ9sDe2AvFR+X4Mj9Tjyv3gQHN+pScdkZWET9uiE9vhYq35YmEJwQwJdgSeRnMLD/+u88l3LbJR2on81ILiwZSH5Ll5z0FKh8K90szQZ3kicvZxlQgmd61WiFN+CjizyNE9PElk56n+fwrS+mXVc8XSam9eFqhgrDXgir7Loj+4SLA7zb7GpXXiWR2/xG9+vTf6AK9BC4xhj+SjMp90G9U6+ao++k2Nc7NKhv6t/wO8ODgTx+5OSEcyHN81fr6hexCB4hzmOxiEYkQDt0j3pAK9SXM3z8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6+vN5WkjkKWb52Yf7oLvo87VA6rbdHjTCKbEGppwF0=;
 b=KKs3uGuSHNh9x1O4aPhdsN7WlcMlf5Wbu4gVLq28sypriulqLu4X9m87Hoqz2PEEPNvW5GUOVRdYjtCta5e7GXh63GKXn6UcdDMdY5LIeLdkr/K53staq8W55VSQsWt/iykuA7ylJFlQOjeCuKJU47JrhUtsOFe5dAEOzwCIufw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4700.namprd12.prod.outlook.com (2603:10b6:5:35::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.14; Thu, 17 Sep 2020 18:56:24 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 18:56:24 +0000
Subject: Re: [PATCH v3 0/5] Qemu SEV-ES guest support
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
 <20200917172802.GS2793@work-vm>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <de0e9c27-8954-3a77-21db-cad84f334277@amd.com>
Date:   Thu, 17 Sep 2020 13:56:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200917172802.GS2793@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0072.namprd02.prod.outlook.com
 (2603:10b6:803:20::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0201CA0072.namprd02.prod.outlook.com (2603:10b6:803:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 17 Sep 2020 18:56:23 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ee6e962e-b5ef-40bb-5b5d-08d85b3b5f94
X-MS-TrafficTypeDiagnostic: DM6PR12MB4700:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4700AE1085883FAFE60774FEEC3E0@DM6PR12MB4700.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fN5+CYh9wNcIQyRqtXj1U/TRdG6kfS3/bGpa/5a+baNPZsIWgy7Tse12X8ylm1x2oHRb8zL19kl0SmMY+oCqXx1wcssGnluxaP8e6k4OpACNoYp8cc4kJSAtyOFiO5ycYtPpEIHNWqcyW74IXdpUkGOW26pzWHxBf5bZscwp1j4sTLEZyjrxQ37XdGiJNdN/ly3TLeyOj9PGrrExPyeQ5Rw+l2LmaoJyGlEF5mYXoHEw4AsA7sFFyI/c4c2yHEq4dTKJb0YFsOaphlDzKWh7ED4D9jZQp5fFTFXyqCTKA1ZqO4TBnpaUZF8borUbl3VEACWqU+T2g7FisRUhC7xKJk3eNXm5K7QYHt3YaNpo1bY6cOzH6dGKp3M+cbtU4FkjF7sfpCRo5ngyW79/LzWv3in9vpBDR/ybCdbi8D8Hrrzhz2/VG1WMERWoM/QPV+9Qoozd4PSsRnBxfM9lZcThWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(66556008)(66946007)(66476007)(6506007)(5660300002)(53546011)(54906003)(45080400002)(8936002)(2616005)(2906002)(83380400001)(956004)(6486002)(7416002)(8676002)(186003)(31686004)(4326008)(52116002)(316002)(31696002)(6916009)(478600001)(26005)(16526019)(36756003)(966005)(86362001)(6512007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: K7yekP+xFK1ptrpfdLoEZhGzqVheYHGRReVqYMxoVgwu2BzbkfdVeOgSM/X2LfjnJAsaPHdnlMCLmjs1+SibJqEyKz3opbs4/Ausk1jwXNmZc459bdOgz8t8SmHlA+xXZZH0iSeGGDTG0DbAZ/xO8Qvgt26KciTjlvZ0pki/pUaBmuW3fFP8x4W37PNpA64rjJMf/heYX1YzuIvA5kz9aJsS4jUt95ohglyCsA4To5udhhPtLNQNOEuDUQoV/wT5qxnceXqPQn39o0LfZ0SH93XfjENeGNWDGBN68aKVJQkF1L4tmdZHgwhD/ZPZLY6k39bQofNy+1H+ENsMiKvL/HMuw+jb5v0MxFY93qg2WzfxEVSJuYEoAoxIbCYCMWqks0zZQNjiHCl21YRO9J4nFgO2WgfSS6s2COalEPdv4B0vrCS+35BVyK3ydde+vYOcoMid8h1n47ET9+eoD4GJiIqdE1zpv1jZAw3dzkgPSywIXRCA+Mx4BffAmp3yJQOvfSi12UlD8tRFBnupM5Pluifuo6p7TOqZJxjuNzZAHDEYhPy4NG3WVPEY65NQUnZWZgGhSkK7iwWTtyHnZhmznl8qHGhLDm6edUcQI8N1KSMKF3EGO79SO44QWdnObgjoE4N+ifLMeC13VqCfOJR7Fw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6e962e-b5ef-40bb-5b5d-08d85b3b5f94
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 18:56:23.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCzVuwMJ4KzU+isMwLozZSlKoJauxMqyt3A+ZkDFxaRoagHCr/tTpacYTQxhhCnmBuUKpyCh4qLpHtMoowPwcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4700
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/17/20 12:28 PM, Dr. David Alan Gilbert wrote:
> * Tom Lendacky (thomas.lendacky@amd.com) wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This patch series provides support for launching an SEV-ES guest.
>>
>> Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
>> SEV support to protect the guest register state from the hypervisor. See
>> "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
>> section "15.35 Encrypted State (SEV-ES)" [1].
>>
>> In order to allow a hypervisor to perform functions on behalf of a guest,
>> there is architectural support for notifying a guest's operating system
>> when certain types of VMEXITs are about to occur. This allows the guest to
>> selectively share information with the hypervisor to satisfy the requested
>> function. The notification is performed using a new exception, the VMM
>> Communication exception (#VC). The information is shared through the
>> Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
>> The GHCB format and the protocol for using it is documented in "SEV-ES
>> Guest-Hypervisor Communication Block Standardization" [2].
>>
>> The main areas of the Qemu code that are updated to support SEV-ES are
>> around the SEV guest launch process and AP booting in order to support
>> booting multiple vCPUs.
>>
>> There are no new command line switches required. Instead, the desire for
>> SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
>> object indicates that SEV-ES is required.
>>
>> The SEV launch process is updated in two ways. The first is that a the
>> KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
>> standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
>> measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
>> each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
>> invoked, no direct changes to the guest register state can be made.
>>
>> AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
>> is typically used to boot the APs. However, the hypervisor is not allowed
>> to update the guest registers. For the APs, the reset vector must be known
>> in advance. An OVMF method to provide a known reset vector address exists
>> by providing an SEV information block, identified by UUID, near the end of
>> the firmware [3]. OVMF will program the jump to the actual reset vector in
>> this area of memory. Since the memory location is known in advance, an AP
>> can be created with the known reset vector address as its starting CS:IP.
>> The GHCB document [2] talks about how SMP booting under SEV-ES is
>> performed. SEV-ES also requires the use of the in-kernel irqchip support
>> in order to minimize the changes required to Qemu to support AP booting.
> 
> Some random thoughts:
>    a) Is there something that explicitly disallows SMM?

There isn't currently. Is there a way to know early on that SMM is 
enabled? Could I just call x86_machine_is_smm_enabled() to check that?

>    b) I think all the interfaces you're using are already defined in
> Linux header files - even if the code to implement them isn't actually
> upstream in the kernel yet (the launch_update in particular) - we
> normally wait for the kernel interface to be accepted before taking the
> QEMU patches, but if the constants are in the headers already I'm not
> sure what the rule is.

Correct, everything was already present from a Linux header perspective.

>    c) What happens if QEMU reads the register values from the state if
> the guest is paused - does it just see junk?  I'm just wondering if you
> need to add checks in places it might try to.

I thought about what to do about calls to read the registers once the 
guest state has become encrypted. I think it would take a lot of changes 
to make Qemu "protected state aware" for what I see as little gain. Qemu 
is likely to see a lot of zeroes or actual register values from the GHCB 
protocol for previous VMGEXITs that took place.

Thanks,
Tom

> 
> Dave
> 
>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F24593.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292398926&amp;sdata=B2naGIEXuhD7a%2Fi4NDsRzeHwvDvNJ%2FP7nf5HmAzk9CU%3D&amp;reserved=0
>> [2] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdeveloper.amd.com%2Fwp-content%2Fresources%2F56421.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292398926&amp;sdata=0HrHZxdTEK%2FWM1KxxasMAghpzTNGvuKKSlg6nBgPjJY%3D&amp;reserved=0
>> [3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
>>      https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Ftianocore%2Fedk2%2Fcommit%2F30937f2f98c42496f2f143fe8374ae7f7e684847&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292408916&amp;sdata=ISAjIahZH4izDHnXgdWDX0GK61kwgtTw%2BEE%2BS8FBls0%3D&amp;reserved=0
>>
>> ---
>>
>> These patches are based on commit:
>> d0ed6a69d3 ("Update version for v5.1.0 release")
>>
>> (I tried basing on the latest Qemu commit, but I was having build issues
>> that level)
>>
>> A version of the tree can be found at:
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FAMDESE%2Fqemu%2Ftree%2Fsev-es-v11&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7Cb07b788e09054a91143308d85b2f1a89%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637359606292408916&amp;sdata=pWd8HAZkAILIMRb1i5TNz9XoHyrhCgRu%2Bq%2BXN2NJ4ag%3D&amp;reserved=0
>>
>> Changes since v2:
>> - Add in-kernel irqchip requirement for SEV-ES guests
>>
>> Changes since v1:
>> - Fixed checkpatch.pl errors/warnings
>>
>> Tom Lendacky (5):
>>    sev/i386: Add initial support for SEV-ES
>>    sev/i386: Require in-kernel irqchip support for SEV-ES guests
>>    sev/i386: Allow AP booting under SEV-ES
>>    sev/i386: Don't allow a system reset under an SEV-ES guest
>>    sev/i386: Enable an SEV-ES guest based on SEV policy
>>
>>   accel/kvm/kvm-all.c       |  73 ++++++++++++++++++++++++++
>>   accel/stubs/kvm-stub.c    |   5 ++
>>   hw/i386/pc_sysfw.c        |  10 +++-
>>   include/sysemu/cpus.h     |   2 +
>>   include/sysemu/hw_accel.h |   5 ++
>>   include/sysemu/kvm.h      |  18 +++++++
>>   include/sysemu/sev.h      |   3 ++
>>   softmmu/cpus.c            |   5 ++
>>   softmmu/vl.c              |   5 +-
>>   target/i386/cpu.c         |   1 +
>>   target/i386/kvm.c         |   2 +
>>   target/i386/sev-stub.c    |   5 ++
>>   target/i386/sev.c         | 105 +++++++++++++++++++++++++++++++++++++-
>>   target/i386/sev_i386.h    |   1 +
>>   14 files changed, 236 insertions(+), 4 deletions(-)
>>
>> -- 
>> 2.28.0
>>
