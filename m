Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602631A8C52
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633000AbgDNUSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 16:18:47 -0400
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:17642
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2632975AbgDNUSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 16:18:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Irjxsq4C6qm1qt7GoNw4KPs35LVaUwYud6D+8DkoDwEPeNJMR94QL9OhS5HiZLWPMOsa7mZfPN7G09O80B3nlWsFz6iMUiQYrgj5bHtWVbEU4TGiX5SZLptax/JPtCgz6Kj1n1SLMU73Pwe3nmqGXf+qltaMTvgYSwI0xotL/pJwtQEsKZ9L6e16tqxcybKRNdBEdvmmbgvziRlVIeCvpE1Hp85NNt78Zrd7gpXollPxn1gpaDxpNzoA3Vj6iYa80xKeRHC9v+ZnxEWGj9MGPNO4RmpEFLVACT+bE4yC0g7nowHY2VUmXmHhDChVMyCJ3QM68MJ8C+yvhiYOCklFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LSJ+GFqYf37nL0QD2n8SQP6nSPYLBlFMkuoebIc7n0=;
 b=AgX4NmDkdSnw0YRXGmYfK4KzJ5Dr98bJiPgQYF+GZcqagD7Qxw1bsEkQXD/e8C5g4CTbx+ti3kHf/Fc8XzNxx407RDgUspgQbT5Emly5JfdeDOkyFV7O5I8DYjUXxX10+AfoYoWLx8JL/DbpnSKsnp7dzX3AxZMTAziPRceMJsS2gs5SOFbkAhNjnbWy4Fewx1n3+D7yXHJ51F9X5At7Pf36rnIgyFxK0xKbzmuZEZrRzQ+N7NH3aiyTJI5IcaIA/Kp7WCTq0citIe/BLWsAl8OJSH2lQLZ46a9EFn01OvzrUf7K61UPAPfUzyvFe9PVYZYUlyq8zKxKnhw0WW6rUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LSJ+GFqYf37nL0QD2n8SQP6nSPYLBlFMkuoebIc7n0=;
 b=vs2SfulZw6HKxypJ7YSm8qN5Gj8mwS24RuNuN2G83JI09XUv8o7IU535AJs23x2mt1d2w4qoa0P35HUBu7Roah022W3gyIni1nIRbqBcfkgyeVUqi0ijk5mPt7ZTuWwenZH/l3YV9Wj4y/mIq/Q4AoHn2m1XZfcUcj5qDulSdB0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3369.namprd12.prod.outlook.com (2603:10b6:5:117::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 20:18:40 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 20:18:40 +0000
Subject: Re: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-41-joro@8bytes.org>
 <A7DF63B4-6589-4386-9302-6B7F8BE0D9BA@vmware.com>
 <09757a84-1d81-74d5-c425-cff241f02ab9@amd.com>
 <fbc91dfc-7851-c7d8-ccdb-16c014526801@intel.com>
 <27da7cf5-5ff4-a10c-a506-de77aeff8dd6@amd.com>
Message-ID: <fab36c45-3cdc-3ec0-a76d-4a2a2fbfdfc8@amd.com>
Date:   Tue, 14 Apr 2020 15:18:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <27da7cf5-5ff4-a10c-a506-de77aeff8dd6@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0096.namprd04.prod.outlook.com
 (2603:10b6:805:f2::37) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR04CA0096.namprd04.prod.outlook.com (2603:10b6:805:f2::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.18 via Frontend Transport; Tue, 14 Apr 2020 20:18:38 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3fbe02e-aa70-46df-e1c0-08d7e0b105a2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3369:
X-Microsoft-Antispam-PRVS: <DM6PR12MB336911CEB9181C878EE6B408ECDA0@DM6PR12MB3369.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(31696002)(8936002)(2616005)(81156014)(31686004)(8676002)(6486002)(478600001)(186003)(86362001)(16526019)(26005)(4744005)(7416002)(6512007)(54906003)(53546011)(956004)(6506007)(66476007)(316002)(5660300002)(2906002)(52116002)(36756003)(4326008)(66946007)(110136005)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJLZ4sUAadPewVYoEvDRLakPJxqb8Cg44TncB67WKhuj1j/UdJUkgacuTWLwvKKacrq5xKWT3jNZKBedqFbAW/97YfqHiG3kGrIdV4uXvJdohbpwGxSrXd8vzdTzsDrVb+jPI8f0as7mL1Mn3/MRIzNm57Ke3KXPV51G9GFcUdii0yMLgivkfjYbGZux5RgrwK7VUITDu6bAc4r+UJf5SJkc1vLQoNbDff5a+lIVViLxfp13OHIJ7eoruu6MGn7y7mYDUgQB2v/R9WVhv2pgscpZrCeGbU40sKIH/7qg7TZ10ZjFhEZOcNhMRBhbMkvitKusaI7bZJHWliIaJnH6/6NJ8e0OcXB8B7+FqyebYWQMX3G9pQqSaBw/aDaFRmRyNxs0bY8MpoBaSpkGVay0dYNUn1/VTrSs+51MRgvRyt+P/am9a2ijD1tljIWxNpQr
X-MS-Exchange-AntiSpam-MessageData: SVinSn76/xQxl5el555qMLqsPAqxfletWLwb1f5+JTxrmWYn7UIooyUEAl04kduqOKI+bIEWfbap9LAAStg4DNzLf6wYboVUuiavoMN16stLqZUWTWcW+PQH69s/Svx2tLRzOlGOx3snlWp6jfnkVQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fbe02e-aa70-46df-e1c0-08d7e0b105a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 20:18:40.6597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NexKPymXl9HUzj8c12xbH7RcY851eEovXyME3a22AVXyGrg/sRzLBf6t4fzjDz/fmzQS7vnu4YMMlDqWo52q2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3369
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/20 3:16 PM, Tom Lendacky wrote:
> 
> 
> On 4/14/20 3:12 PM, Dave Hansen wrote:
>> On 4/14/20 1:04 PM, Tom Lendacky wrote:
>>>> set_memory_decrypted needs to check the return value. I see it
>>>> consistently return ENOMEM. I've traced that back to split_large_page
>>>> in arch/x86/mm/pat/set_memory.c.
>>>
>>> At that point the guest won't be able to communicate with the
>>> hypervisor, too. Maybe we should BUG() here to terminate further
>>> processing?
>>
>> Escalating an -ENOMEM into a crashed kernel seems a bit extreme.
>> Granted, the guest may be in an unrecoverable state, but the host
>> doesn't need to be too.
>>
> 
> The host wouldn't be. This only happens in a guest, so it would be just 
> causing the guest kernel to panic early in the boot.

And I should add that it would only impact an SEV-ES guest.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
