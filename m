Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1A1ED9B2
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgFCX5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:57:20 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:19455
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbgFCX5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:57:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG5EPodUJlXmtwwzP1yzprvdIbNsN55edeJDLVB9XwYI1MBiVd7kXrm8/CaE94flmtXbep47JEI612XwWhc4G5AWIwi5VkqEL2O0ZKkBChe3HS2OMGDwZ21qXVzQwTZtPdhD0fdkeT7zYE9OtdNoQjT13TPpDzEUxGTsc36kTX6yQ/PdQeLGXe5H/1ePxfmbgJYg0sab4r0nL1d0XU9sEjzDl8jhtI5bWpt05uE0oQH5rKV0dhLorENdHe761CZGDpWvpPYcTNPqPx5FAT96QWqLIR3LmNeCv2z2LPfjJuKwkVuQH7UzYuZQf5QVeLWwqByDHtihhvm9ZNbrtXLMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwGPWYC9GcM64KFTGVuXYfHICdfdExVV8HgNefDSw4c=;
 b=m3FEpkmY7BWLLj6N/4TaeZyprCPSe2YqtJlFETo26Bu1tvSVtnLYjD2BNten58aXBEWmhEvMwWgiUnnmWs2tK//BiZvs/sNleSUAz1JSgtJugH5u1J+u21REZDWCjmemjVHbpzKRCxXciRpejeaceR46d25TGhPPPlihtSqMzbWS46EcIZkATH968MEe8fAjhW5+UTNjtiQa8mIm/vi3s6YNrwselYvWXrULhf00T8PhWc98okOG9sqto+zgC4WlF9DPDMEMo+U7WSNY6N5DkFrCBXFCXSqg48BGwUR+emrtOLSCAK7UJxAkGhBlA263eNpKlyhv3PZ/X77tyCZ9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwGPWYC9GcM64KFTGVuXYfHICdfdExVV8HgNefDSw4c=;
 b=qfgAO3Ls/Srft/otVXPU2NJH/P6aQuwRwsWEjR3emO47Bna/M7ztt2bKDrQDuJwwq/N2Cz+fz0aUmBrb2HQ9Kcc2j9zyEQxIqqTXkQ8AHe1/lGpY2E71ZQOW4rY0KgJmjOBdUZVnQxtw0EP0yYe4JwoqFRlCUFE8aGm6UYwYvlA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 3 Jun
 2020 23:57:17 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::2102:cc6b:b2db:4c2%3]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 23:57:17 +0000
Subject: RE: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kash@tripleback.net" <kash@tripleback.net>,
        "geoff@hostfission.com" <geoff@hostfission.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <1528498581-131037-1-git-send-email-babu.moger@amd.com>
 <1528498581-131037-2-git-send-email-babu.moger@amd.com>
 <20200602175212.GH577771@habkost.net>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <15422b3b-47ee-f293-b40a-d102aa8a89c0@amd.com>
Date:   Wed, 3 Jun 2020 18:57:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200602175212.GH577771@habkost.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0069.namprd02.prod.outlook.com
 (2603:10b6:803:20::31) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.79] (165.204.77.1) by SN4PR0201CA0069.namprd02.prod.outlook.com (2603:10b6:803:20::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.19 via Frontend Transport; Wed, 3 Jun 2020 23:57:16 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09cf5bda-4fad-4974-4725-08d80819d829
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2591FBF61D15614075B53F7295880@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XicexYKArR9/DGkXIYyV2YcxOqB3sKXowZh1bmKlryWghm/dIkB/iH/m6kTSsmT5PrJqC8YO2Beze5IQkR4yWqKOFsNl0Ur1QHxv1ipwsNvRNEhGtuiWs7vha/UEjaD3dSitbVZA3cTpBmgDAHr8Nzjb3nehLkVFIYo2NUN0psELEXkPTsZj1USsblppfqE7J5trH0W+tLZkBfCIHIQmfkexC9oEC9hUXpC4BE6Fvi8O/sfdfnSu99HdnQMS5k6gq8xtFMbPUe7kU7yDSMy5ezhlMCIxuA4S6cgBkEl8MICqlH1kIU7j3SVwC0tGhjDdBYZopwzv2oPrBYFn8dwoi2YwCn/qI7CRnEgCpFcP6j5KwkQScGRMLeT+9znoiab5zknuqivmpEgIXHM4ajW6KdaxN0bAj05tUYDLUsneTMqeD6JH/XQUqVYnh3SYDXb1V0wneZMyynetJG//PGzhAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(31696002)(6486002)(478600001)(66946007)(45080400002)(16526019)(83080400001)(186003)(83380400001)(966005)(66556008)(2906002)(66476007)(36756003)(44832011)(4326008)(6916009)(316002)(26005)(2616005)(7416002)(54906003)(31686004)(8676002)(8936002)(52116002)(16576012)(86362001)(956004)(53546011)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dLUCAjd6/P59r9+wkDYG397sWDNEcWWO79u1pY3l2yKeDcEbJFXFoToxMpKR9hVW9A8AK6V2/LBG5o11faDE1QlReIEbNeN/j9zPfQ4sEN3dvyT3hEuxck9vUWgdb1pwUBSkScngxViGciINKpTELgCpr/pF0m2fTOZ+UWzeRmdDaP+F1sZOg0Bs1dszXKufHyd8rTcipcdLlhtgGX3swbCBA9yhAKvWe128PpNl3D5F00MI8L50jbtiapp4CVN+j0sM2z7BXEbzL2gzOaZ0UzsRTw1slzWFEE7/dYKVvAfJ5pIlOjOzJIXBfFe5FtYZkYCIxtOYVSCWfidw7V4kG4t5Y0eOI27saKXY8aAad8fNU9wYT4wV5x2oJtD/FHX71rszu9vBt1AlZ/3u4svhXGI/A6KWJTH0Nay0mi7mwJ63LhLCTwZF2E4KStt3anUZwaOKd7xz4tlWD2SycEpWvouIoS/3obnp6fPY7m91sto=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09cf5bda-4fad-4974-4725-08d80819d829
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 23:57:17.0021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cx1q3zIaBmKfhZXszbX/aa53penKzpJUI4NC0Bd9a9+IGjv2ERlFO3wKUR6xwEyF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Started looking at this. Let me know if you have any ideas. Will respond
with more details later this week.

> -----Original Message-----
> From: Eduardo Habkost <ehabkost@redhat.com>
> Sent: Tuesday, June 2, 2020 12:52 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: mst@redhat.com; marcel.apfelbaum@gmail.com; pbonzini@redhat.com;
> rth@twiddle.net; mtosatti@redhat.com; qemu-devel@nongnu.org;
> kvm@vger.kernel.org; kash@tripleback.net; geoff@hostfission.com; Dr. David
> Alan Gilbert <dgilbert@redhat.com>
> Subject: Re: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
> 
> On Fri, Jun 08, 2018 at 06:56:17PM -0400, Babu Moger wrote:
> > Add support for cpuid leaf CPUID_8000_001E. Build the config that closely
> > match the underlying hardware. Please refer to the Processor Programming
> > Reference (PPR) for AMD Family 17h Model for more details.
> >
> > Signed-off-by: Babu Moger <babu.moger@amd.com>
> [...]
> > +    case 0x8000001E:
> > +        assert(cpu->core_id <= 255);
> 
> It is possible to trigger this assert using:
> 
> $ qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -device
> intel-iommu,intremap=on,eim=on -smp
> 1,maxcpus=258,cores=258,threads=1,sockets=1 -cpu
> qemu64,xlevel=0x8000001e -device qemu64-x86_64-cpu,apic-id=257
> qemu-system-x86_64: warning: Number of hotpluggable cpus requested (258)
> exceeds the recommended cpus supported by KVM (240)
> qemu-system-x86_64:
> /home/ehabkost/rh/proj/virt/qemu/target/i386/cpu.c:5888: cpu_x86_cpuid:
> Assertion `cpu->core_id <= 255' failed.
> Aborted (core dumped)
> 
> See bug report and discussion at
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> redhat.com%2Fshow_bug.cgi%3Fid%3D1834200&amp;data=02%7C01%7Cbabu.
> moger%40amd.com%7C8a2724729b914bc9b53d08d8071db392%7C3dd8961fe4
> 884e608e11a82d994e183d%7C0%7C0%7C637267171438806408&amp;sdata=ib
> iGlF%2FF%2FVtYQLf7fe988kxFsLhj4GrRiTOq4LUuOT8%3D&amp;reserved=0
> 
> Also, it looks like encode_topo_cpuid8000001e() assumes core_id
> has only 3 bits, so the existing assert() is not even sufficient.
> We need to decide what to do if the user requests nr_cores > 8.
> 
> Probably omitting CPUID[0x8000001E] if the VCPU topology is
> incompatible with encode_topo_cpuid8000001e() (and printing a
> warning) is the safest thing to do right now.
> 
> 
> 
> > +        encode_topo_cpuid8000001e(cs, cpu,
> > +                                  eax, ebx, ecx, edx);
> > +        break;
> >      case 0xC0000000:
> >          *eax = env->cpuid_xlevel2;
> >          *ebx = 0;
> > --
> > 1.8.3.1
> >
> 
> --
> Eduardo

