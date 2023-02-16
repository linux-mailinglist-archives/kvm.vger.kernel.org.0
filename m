Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51948699F82
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 22:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjBPV4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 16:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPV4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 16:56:05 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04olkn2046.outbound.protection.outlook.com [40.92.45.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709FC5034A
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 13:55:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2UpKSo5hQe2k1NDzFSlqG9Xyi3CJmesd9R4ZmC9ur3HDeHgxFn6mRiYgdnv3jmC398+BulCvu23ITmiTSv18Q2HTqYayBzuaQVNiWHODJWBUUccmoMuQ1Ib1MJFuslgLRZeo5OkUmYSlM7LQipAPsq7ngVQo9He6vXwTUxC0zAuVHUNKh8LQpiOrAKYwdUbLrygiq3uAKcwVdBVdsEjU64bKhP/ZBFiOx3rK7PRReCm/V/kxFVR4sjjrG8ybD6uegRW9ZrLJAWd4HZnH37BwGDm8HT1KnC9rz23dEG+NnMJH7lORW7wezfmcETeHHsYaFDWmgrhtfgtZQytpj8DAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdRfmTqQVZQFtOtDGmkWLvsNrx9Cwmn4vA6zVP+sPJI=;
 b=bylh8FLHEJqFHKQKdMg0tVNsJC+qHno9rvkZtdfDPYnL7ySQ03NFtcIn4lXlN/VK2RUOkIbQltn+2N/dvEaI0BHNZaHYe5muZk1WNQFnsN0RU2f9YKPQ29n4nu+Yv3g9k0bbTrm4GTAyOf7McdZ6ByJnzq7yIMjK6Lqn98glOkuKIhJ8NkNGUGKgqQCGp8Wa5/L1rty92v9KzRgDp8Si3/F1ePBhVWJvNGz/ugU95QqLh5lu4jf8z6TJWxVbwn0SuPVmDmLLwv/mU/HbYoOnYv45YEmDDfhzlpRsFdiGQJ196F2IDzdqqoN49Lhw9Z20DccJ4BZZTZs6oHYOtANL3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdRfmTqQVZQFtOtDGmkWLvsNrx9Cwmn4vA6zVP+sPJI=;
 b=X3rJSdXPMbaU6lQB7JVuxZ/A1nIojZifu/wKzVKwMR1FhYC/UDZbECxSuFqjc0DyQilywMQKue0mHVhanOwtcxnJzuNbOe5o43PJDhl2soQtq1jfTyfJXKWcSJB88ZD7nQxLSvt5Hm8ITx60W5arQrbw0z1Ngu0byY7TSrytXqVjETLUmW7TSpyRrDCY8EVrObkdt8bpk5DH4buzyoPC3pq42mKI9NsArJcSmtUPQomudjItWNgVPbH4tOZfuC+E2PsdhXlMNnug9+5Mw5ywuXkO2UcHl1xSRFsMSD+oPU5potyrCUieWWsXalNf7s5ANdhSTe+DRCrHfPI5MR2W+w==
Received: from BYAPR12MB3014.namprd12.prod.outlook.com (2603:10b6:a03:d8::11)
 by CH0PR12MB5386.namprd12.prod.outlook.com (2603:10b6:610:d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 21:55:14 +0000
Received: from BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::a666:b29d:dedf:c853]) by BYAPR12MB3014.namprd12.prod.outlook.com
 ([fe80::a666:b29d:dedf:c853%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 21:55:14 +0000
Message-ID: <BYAPR12MB30149BF059D6CED415FA2963A0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Date:   Thu, 16 Feb 2023 22:55:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Content-Language: en-US
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
From:   =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat@outlook.com>
Subject: Nested virtualization not working
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [HYlcrUrln/puchQfl53usdi5WkmApqiw]
X-ClientProxiedBy: BE1P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::8) To BYAPR12MB3014.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::11)
X-Microsoft-Original-Message-ID: <81ca0c1d-205c-3b1e-af95-9406f53410b9@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3014:EE_|CH0PR12MB5386:EE_
X-MS-Office365-Filtering-Correlation-Id: 002b1b2e-b7b2-4736-8fd9-08db10687b72
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1eBd9G6A+0fdlUCX/+4Ru9zSLbGz5bak7ZqR698vdjeoaKo7EQd6y/hcZWeuJcj1yGK/nf+n1YIF9RoSVcwaaSmwGXDOY92ysdCLjLs25186TMVq2E1jawM5VMy1fKlUYkQIlEjYMn/AMyN4XOEaKJf2wrtAjfxbScQhOU4/Ks03BKfsNJqRVJifKHL36isxIpqSy61on9CtRtURMpKELSy58o4cdkMLeHwYS0QNKaZ5z1wIDqRVtXBii/mJ85dFCd2rTR1K3JXpqLiKzJ4iDHEqHdAZmf8gtuHoVRgkVHgN/U1gp7gJe1/Vmw9VWNjr7dPgvNUHVomZjZcd0Y3VBxzh6wIf/U+UQfUIopUEPCEtMGRTJNY9yxgPveKWhiVi2nr2agF7kSlLYDnTZEhVIPeX3+qgvitFHSAr1Tti2c9Zywbe6/0Y+m5p0OCuw9nS/warW9wSrwKLTgvICYWyup0Kl1u0ydlryAnwkSD73FOm9fHoKHng/AV+ivotu/pKjgHVKEY6Ur7nhX0Y+wSrw/7Ov+XkpB5nCrfU+T+erUFVJzA8L6h6CTDwN0n4TeX1vXxvYD4fLK6EjwOp3SiDyTnVSLUzCe3/I/BSIegTNas=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTI3RUFDMi9RN0lXcTdMYzUwZ3VaQWEzQm5jbzZpckh6Z2RZK1J6T05FRVFO?=
 =?utf-8?B?bS80bFN0K1JTR1EwaGJFT0N4N2g1bFRIbUtWZTA0cTdObUdQRWgrakJ6SFRJ?=
 =?utf-8?B?SlIvc0R5QXBvT2Q3Q2JWK1lyMDR3Q0FNb3pCUm1JWWRnZHhYd0RrV1crajRi?=
 =?utf-8?B?b2xDYW1KR3J4d3JnR3dpWUJqcUxXSGpzNzRoR2N4NzNJazFDRmlGaEQzNWIx?=
 =?utf-8?B?OVFRak1lQjA5b0JlTVpPRE5MV3dXSnZGUEVRZWdvMFVHK2toa0tCd25HVW1D?=
 =?utf-8?B?SEFPSzBYNzNadDRXZGxPUEJ5ZDBQenR2dGpVczJpQkRaUlU4UFhQRDV3d3o5?=
 =?utf-8?B?ZjZNeHcvaUZZTlQ3TVFCV3hINVU4OGFYRkxFSEtWeUhsMDlsMitEei9xbDU1?=
 =?utf-8?B?aVd6QytxSkptbm1YM2F2YndzbjdjeVNqQnROQVp5aGxsWmdlZm5QMzRCb1Js?=
 =?utf-8?B?SWNyQzVrcktpNmo4cFFSSHVXSjJzejhqNVlyd0hHd3dBNzZWUzR3M3BLOWxu?=
 =?utf-8?B?QWErMlRFVWx5ckpEa05ZZGYvTUFXWEljTytWNzRZOU1jVjBENWljeFc0OXVP?=
 =?utf-8?B?eEdiaUJjTHdjejM0dVJ1ZmtUS2xIaTNZYVR1Zk5TeFRNSmdjUVpRMzVyOTB5?=
 =?utf-8?B?eHA2RVdCS2JwOE1LOEwrV25QMHNuM2tCeEVzeitjczFIYkt0MFp3bmJjaE1y?=
 =?utf-8?B?UlZmUGFEdFg0U25EOXU4MVgvZEZQRUliOUhiNVd6TVRQQ240emdYcW9aby9J?=
 =?utf-8?B?dE92dC82Z1RXQWFNTVJIbnZRejZYeVZqTU5zN0J1MllJS1lXTFBqSG9PajZU?=
 =?utf-8?B?UHFWQllSbjhzY0JxUUhXcmZNaWoxWGY0MUY5VXJ0dlo5eTN6TkswRkdmQTlJ?=
 =?utf-8?B?ZFBpUjVJQnhZdTlrTFFYM3BZMUJWNDNCZ1FqWE43YTRaTDJXOXhYWWJWbUJv?=
 =?utf-8?B?Wnc2ZFE2dTBvUDZRaEFIdXhrRkV2dGJiaXVRSm43UHUvS2F5cDhtYjJmYTRL?=
 =?utf-8?B?WnpYV1ptbHF4MnhqUnJyWTR2M2tCdE1QRDZLQUFObkZRN3pUU2gxcmk2ZUxp?=
 =?utf-8?B?Znl4ZGF6eGo4UUxHZHRkeXU2RTh6aUFUZjZCeHlZVVpkTkRNYnAyYTV0MWxD?=
 =?utf-8?B?bHg4VXg0N2xHbjZENG11OFRGT2E1RE9vRzM4SlNMY1dxRmVUdDk0MlFNZ1J3?=
 =?utf-8?B?TFlJZFdOVS9YSmxmOUorWWo5MDREZjY0UkNyRnl4dnlQbzFLUm9aVmszY1c5?=
 =?utf-8?B?UGJNd05TQjhzQkFqRXBNanYrVDlueUFoY2ZMS1o0UVlPWVZrMkxDWFppS2Zi?=
 =?utf-8?B?OGM3SFhMNlZxQWJPTjFML05aNEluOE9kM2RXeU1zZ3BKSUFDUE8xcURMQmJS?=
 =?utf-8?B?Uit4dE1OWkg4T2cxM2pHYVF2QkFuQXloMFFkeE5Wc216NFRObFlRSEcyMDla?=
 =?utf-8?B?Y0NmdWFlbTE4STFFT2M4QUtxYzRGZVdDMWxSVGhDWTVSVjZyNGZLeWJHTDRH?=
 =?utf-8?B?eFU5UDc0QUZySnFtMVhpRjdaOTRnbDFjcnpCMitFQ2JSQnNBZ3BxN0M1YUNl?=
 =?utf-8?B?UGcwRWgyTmttQ1FIZjNobk5iWGpZVzhuYnFPMGdQMWYvb0tTZ2t6c2lvK0pH?=
 =?utf-8?B?SDBuQTk1azM4UGY4NStWYWRVWVN4bG50eTJBaHRIU2RDeTJMT0M1NzBuZk5N?=
 =?utf-8?B?cCs5U25HVkt5c3FZT05BTUx5cnhGOXdSRjFvZ3FDei9qQVZiek9odXZBPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002b1b2e-b7b2-4736-8fd9-08db10687b72
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3014.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 21:55:14.1180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5386
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I have send an email related to a different problem with my vm, however 
I also have this one: nested virtualization does not work for a win11 guest.

What I mean is, nested=y is set in the kvm_intel module parameters, 
"host" is used as cpu model, and vtx flag is exposed. Everything works 
(baring the other problem I've reported related to vm randomly crashing) 
until I enable things like hyperv.

At that point, the virtual machine starts boot looping and dropping me 
off to the windows recovery. I do not have any evidence of what's 
actually wrong except that a boot loop is happening. I can stop the boot 
loop by disabling vtx or nested virtualization in kvm_intel. Of course 
if I uninstall hyperv it also stops from happening.

The same happened on my older skylake laptop, although there I was able 
to turn it on with vtx enabled, except it didn't work. Also on this 
older laptop it worked until some qemu update happened. I don't remember 
which qemu version it was and the current problem I have might be 
different, as nothing helps.


My configuration is:

MSI vector gp76 with intel core i7 12700h, 32gb ram as host laptop, 
running fedora 37 with kernel 6.1 (bug present since at least 6.0), 
microcode up to date, kvm_intel with nested=y.

Guest uses machine q35, uefi firmware with secureboot+tpm, cpu model set 
as host/migratable=off, operating system is win11 64 bit. Bugg happens 
when hyperv is enabled (my target is possibly enabling wsl2 for testing 
purposes, that's why I want nested virt).


Qemu command line: (note i was playing with settings of this vm so 
currently it has vmx disabled, the bug doesn't happen until I set vmx to 
on, with all other parameters left intact, things like rtm=off were 
because of some other hints that this might possibly help, but it did not)

/usr/bin/qemu-system-x86_64 \
-name guest=win11,debug-threads=on \
-S \
-object 
'{"qom-type":"secret","id":"masterKey0","format":"raw","file":"/var/lib/libvirt/qemu/domain-1-win11/master-key.aes"}' 
\
-blockdev 
'{"driver":"file","filename":"/usr/share/edk2/ovmf/OVMF_CODE.secboot.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}' 
\
-blockdev 
'{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}' 
\
-blockdev 
'{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win11_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}' 
\
-blockdev 
'{"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}' 
\
-machine 
pc-q35-7.0,usb=off,smm=on,dump-guest-core=off,kernel_irqchip=on,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format,memory-backend=pc.ram 
\
-accel kvm \
-cpu 
host,migratable=off,vmx=off,rtm=off,mpx=off,hv-time=on,kvm-pv-eoi=on,kvm-pv-unhalt=on,hv-relaxed=on,hv-vapic=on,hv-spinlocks=0x1000,hv-vpindex=on,hv-runtime=on,hv-synic=on,hv-stimer=on,hv-stimer-direct=on,hv-reset=on,hv-frequencies=on,hv-reenlightenment=on,hv-tlbflush=on,hv-ipi=on,hv-evmcs=on,hv-crash,kvm-poll-control=on,pmu=on,host-cache-info=on,l3-cache=off 
\
-global driver=cfi.pflash01,property=secure,value=on \
-m 8192 \
-object 
'{"qom-type":"memory-backend-memfd","id":"pc.ram","share":true,"x-use-canonical-path-for-ramblock-id":false,"size":8589934592}' 
\
-overcommit mem-lock=off \
-smp 8,sockets=1,dies=1,cores=8,threads=1 \
-uuid 589e17db-9ea9-49ac-8a66-c75bbc39ddd3 \
-no-user-config \
-nodefaults \
-chardev socket,id=charmonitor,fd=29,server=on,wait=off \
-mon chardev=charmonitor,id=monitor,mode=control \
-rtc base=localtime,clock=vm,driftfix=slew \
-no-shutdown \
-global ICH9-LPC.disable_s3=1 \
-global ICH9-LPC.disable_s4=1 \
-boot strict=on \
-device '{"driver":"intel-iommu","id":"iommu0","device-iotlb":true}' \
-device 
'{"driver":"pcie-root-port","port":16,"chassis":1,"id":"pci.1","bus":"pcie.0","multifunction":true,"addr":"0x2"}' 
\
-device 
'{"driver":"pcie-root-port","port":17,"chassis":2,"id":"pci.2","bus":"pcie.0","addr":"0x2.0x1"}' 
\
-device 
'{"driver":"pcie-root-port","port":18,"chassis":3,"id":"pci.3","bus":"pcie.0","addr":"0x2.0x2"}' 
\
-device 
'{"driver":"pcie-root-port","port":19,"chassis":4,"id":"pci.4","bus":"pcie.0","addr":"0x2.0x3"}' 
\
-device 
'{"driver":"pcie-root-port","port":20,"chassis":5,"id":"pci.5","bus":"pcie.0","addr":"0x2.0x4"}' 
\
-device 
'{"driver":"pcie-root-port","port":21,"chassis":6,"id":"pci.6","bus":"pcie.0","addr":"0x2.0x5"}' 
\
-device 
'{"driver":"pcie-root-port","port":22,"chassis":7,"id":"pci.7","bus":"pcie.0","addr":"0x2.0x6"}' 
\
-device 
'{"driver":"pcie-pci-bridge","id":"pci.8","bus":"pci.1","addr":"0x0"}' \
-device 
'{"driver":"pcie-root-port","port":23,"chassis":9,"id":"pci.9","bus":"pcie.0","addr":"0x2.0x7"}' 
\
-device 
'{"driver":"pcie-root-port","port":24,"chassis":10,"id":"pci.10","bus":"pcie.0","multifunction":true,"addr":"0x3"}' 
\
-device 
'{"driver":"pcie-root-port","port":25,"chassis":11,"id":"pci.11","bus":"pcie.0","addr":"0x3.0x1"}' 
\
-device '{"driver":"qemu-xhci","id":"usb","bus":"pci.5","addr":"0x0"}' \
-device 
'{"driver":"virtio-scsi-pci","iommu_platform":true,"packed":true,"id":"scsi0","num_queues":8,"bus":"pci.4","addr":"0x0"}' 
\
-device 
'{"driver":"virtio-serial-pci","iommu_platform":true,"packed":true,"id":"virtio-serial0","max_ports":16,"vectors":4,"bus":"pci.3","addr":"0x0"}' 
\
-blockdev 
'{"driver":"host_device","filename":"/dev/pool/win11","node-name":"libvirt-2-storage","auto-read-only":true,"discard":"unmap"}' 
\
-blockdev 
'{"node-name":"libvirt-2-format","read-only":false,"driver":"raw","file":"libvirt-2-storage"}' 
\
-device 
'{"driver":"scsi-hd","bus":"scsi0.0","channel":0,"scsi-id":0,"lun":0,"device_id":"drive-scsi0-0-0-0","drive":"libvirt-2-format","id":"scsi0-0-0-0","bootindex":1}' 
\
-blockdev 
'{"driver":"file","filename":"/var/lib/libvirt/cdroms/virtio-win-0.1.225.iso","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}' 
\
-blockdev 
'{"node-name":"libvirt-1-format","read-only":true,"driver":"raw","file":"libvirt-1-storage"}' 
\
-device 
'{"driver":"ide-cd","bus":"ide.1","drive":"libvirt-1-format","id":"sata0-0-1"}' 
\
-netdev 
tap,fds=30:32:33:34:35:36:37:38,vhost=on,vhostfds=39:40:41:42:43:44:45:46,id=hostnet0 
\
-device 
'{"driver":"virtio-net-pci","iommu_platform":true,"packed":true,"mq":true,"vectors":18,"netdev":"hostnet0","id":"net0","mac":"52:54:00:98:17:54","bus":"pci.2","addr":"0x0"}' 
\
-chardev pty,id=charserial0 \
-device 
'{"driver":"isa-serial","chardev":"charserial0","id":"serial0","index":0}' \
-chardev socket,id=charchannel0,fd=28,server=on,wait=off \
-device 
'{"driver":"virtserialport","bus":"virtio-serial0.0","nr":1,"chardev":"charchannel0","id":"channel0","name":"org.qemu.guest_agent.0"}' 
\
-chardev spicevmc,id=charchannel1,name=vdagent \
-device 
'{"driver":"virtserialport","bus":"virtio-serial0.0","nr":2,"chardev":"charchannel1","id":"channel1","name":"com.redhat.spice.0"}' 
\
-chardev socket,id=chrtpm,path=/run/libvirt/qemu/swtpm/1-win11-swtpm.sock \
-tpmdev emulator,id=tpm-tpm0,chardev=chrtpm \
-device '{"driver":"tpm-crb","tpmdev":"tpm-tpm0","id":"tpm0"}' \
-device 
'{"driver":"virtio-keyboard-pci","id":"input0","bus":"pci.9","addr":"0x0"}' 
\
-device 
'{"driver":"virtio-tablet-pci","id":"input1","bus":"pci.10","addr":"0x0"}' \
-object 
'{"qom-type":"input-linux","id":"input2","evdev":"/dev/input/by-id/usb-MOSART_Semi._2.4G_INPUT_DEVICE-event-kbd","repeat":true,"grab_all":true,"grab-toggle":"ctrl-ctrl"}' 
\
-object 
'{"qom-type":"input-linux","id":"input3","evdev":"/dev/input/by-path/platform-i8042-serio-0-event-kbd","repeat":true,"grab_all":true,"grab-toggle":"ctrl-ctrl"}' 
\
-object 
'{"qom-type":"input-linux","id":"input4","evdev":"/dev/input/by-path/pci-0000:00:15.0-platform-i2c_designware.0-event-mouse"}' 
\
-object 
'{"qom-type":"input-linux","id":"input5","evdev":"/dev/input/by-path/platform-i8042-serio-1-event-mouse"}' 
\
-audiodev '{"id":"audio1","driver":"spice"}' \
-spice port=0,disable-ticketing=on,seamless-migration=on \
-device 
'{"driver":"qxl-vga","id":"video0","max_outputs":1,"ram_size":67108864,"vram_size":67108864,"vram64_size_mb":0,"vgamem_mb":16,"bus":"pcie.0","addr":"0x1"}' 
\
-device 
'{"driver":"ich9-intel-hda","id":"sound0","bus":"pcie.0","addr":"0x1b"}' \
-device 
'{"driver":"hda-duplex","id":"sound0-codec0","bus":"sound0.0","cad":0,"audiodev":"audio1"}' 
\
-device 
'{"driver":"i6300esb","id":"watchdog0","bus":"pci.8","addr":"0x1"}' \
-watchdog-action reset \
-chardev spicevmc,id=charredir0,name=usbredir \
-device 
'{"driver":"usb-redir","chardev":"charredir0","id":"redir0","bus":"usb.0","port":"1"}' 
\
-chardev spicevmc,id=charredir1,name=usbredir \
-device 
'{"driver":"usb-redir","chardev":"charredir1","id":"redir1","bus":"usb.0","port":"2"}' 
\
-device 
'{"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.6","addr":"0x0"}' 
\
-object '{"qom-type":"rng-builtin","id":"objrng0"}' \
-device 
'{"driver":"virtio-rng-pci","rng":"objrng0","id":"rng0","bus":"pci.7","addr":"0x0"}' 
\
-device '{"driver":"vmcoreinfo"}' \
-sandbox 
on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
-msg timestamp=on

