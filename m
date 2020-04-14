Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DF41A8C44
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 22:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632942AbgDNURM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 16:17:12 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:9152
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2632807AbgDNUQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 16:16:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qs7RM8XH2pCPuJGKo2c3eM1rxaQDHbDfsMoQ5ZBaDAVki7NShby7NDDbe6egkD9Lr8Hx/p5uX7wnP4ZKUw2KsLkfo5WnRfJhEaIPtAmYmH0TPYst2gXMbUeLNC6ZtsBRMpyZHMcCjh3qx/yR/Efx40di9OhjoO3FJ3inQ88yYQ8BZW9mZU8uiiPjFFBS0+vObLt7HTBBrtfVOjObluLe6wi5d7OhIwyLbY1QEAWNSYvJQnlwHYKBtr//aiB6i3sgAaIl3bURRsc3A1ZmUvSR8g9P8YelZfY+TXge+NVn4ZJ6YK64n2Jn3UgZoSlgkbEs44OE79PTfdca89XdXK6tAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q/zZafQIeSjE5jy8JC2RW/iCuT2Ac7Rbg00PGi6+3Y=;
 b=fIIJO9VdqV5xaFE3e6QHEaFMo0quffCnm3Jcp0gYmUzRGevv85Zvkd9J1qijG4j3v66Ktt7uxILFU5/patH6MRcWonbq1GIF6mABCzeTj449gRy09VmoSizsRM0EFNNlGLWSE1745InR8qfneomh/ZOmRdCKIhjzMcqW5poUSWXjDG/A7n9qUwOIMYMcQ+fUIGJs78wXe54YRUgrT6fwbbeFXIdsCBMUroM70hp1kZ1ed3tTl53BjQ2w6UwcVq/zk4yie2yXCcLt+cGNouTLvstUvJr4pawVSq7nvUJ8ph1q/B6HwvPGWo/KCqtMfIRM89huV2PjBahkicoUNlYamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q/zZafQIeSjE5jy8JC2RW/iCuT2Ac7Rbg00PGi6+3Y=;
 b=3OzN6qi8KTSHTI5A52Ag6gROdNQ3W1kMlu/ZTgxOthR6plLaAaazhikmFdnOnD3CkoEAdRFD3Wy0xItGZaHCtS+ZuyerCrlGlntAhp3hVf23ETGid1JJ5rhnv728EG582l+LmzQ+fziXwYLQDrgZX3EKrm7DTyeKewWFhj5X7z8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB3369.namprd12.prod.outlook.com (2603:10b6:5:117::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Tue, 14 Apr
 2020 20:16:21 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 20:16:21 +0000
Subject: Re: [PATCH 40/70] x86/sev-es: Setup per-cpu GHCBs for the runtime
 handler
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <27da7cf5-5ff4-a10c-a506-de77aeff8dd6@amd.com>
Date:   Tue, 14 Apr 2020 15:16:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <fbc91dfc-7851-c7d8-ccdb-16c014526801@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0037.namprd16.prod.outlook.com
 (2603:10b6:805:ca::14) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN6PR16CA0037.namprd16.prod.outlook.com (2603:10b6:805:ca::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Tue, 14 Apr 2020 20:16:20 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dadc1b45-f405-47c6-9439-08d7e0b0b2a6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3369:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3369688DA65190233F88100AECDA0@DM6PR12MB3369.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(31696002)(8936002)(2616005)(81156014)(31686004)(8676002)(6486002)(478600001)(186003)(86362001)(16526019)(26005)(4744005)(7416002)(6512007)(54906003)(53546011)(956004)(6506007)(66476007)(316002)(5660300002)(2906002)(52116002)(36756003)(4326008)(66946007)(110136005)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JoBerQMKKbTBV5NobaiBwxq0OOKw6nPxlEx30JavU+cyFMr5rVhxIbvDRxx0Z9QW9+V36wJKkqiOSMnawuWu3sb9mqjd8ZlvBgcN8VbblxKmVX6jWzD3T97DVYvAOmLdul5+GRp7WJYxsjbeRlWlqRbXuukRiim/re0tYwlIPpTGSbRCEYx4L9zJ8MDdG1blio7wo9uqD9ARbLRhANnLBD08wK1G2FWy6ko+mYVPD1Mhp+85yVCPDVZxeSm2EQxOZCj2At0q3k5lOEkfxdOqi08BecOijnG75W3TMOgqKqM4tGVM2nFY6SZeLtje6GmsN2H19iR09iGfgMRWzPf49wEAWRYTeGtUGJagLgn5EUp6mOc24y/ZOozJLMt9FFmZ6IefTCmG2aJrcz8TNczeRgEODcsvedv2O4toC1mHfetYHTxg1ui8KnSfixzsl3wa
X-MS-Exchange-AntiSpam-MessageData: dc6IlbC2jonLSLcI7lBuGfYazMaRI9izIacvM9HJ7eLhuigXBAuf2PIZLML6XU0xktPDua7HoL3gQpmrDL7lY79lhPZjWkOLJOVsdciXOnivEsJ1uINH0ELb/sn0NjtoqCf/ixatMAo6zJ9DWJPpZw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dadc1b45-f405-47c6-9439-08d7e0b0b2a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 20:16:21.4260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DgKajX5jBVAMZuLEou1JohC8/3X2+Ebmh20JHR/dyh/eH48KHQ52RUBxtT3z3GSp29+8hMTpsvPnkizV+6lOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3369
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/14/20 3:12 PM, Dave Hansen wrote:
> On 4/14/20 1:04 PM, Tom Lendacky wrote:
>>> set_memory_decrypted needs to check the return value. I see it
>>> consistently return ENOMEM. I've traced that back to split_large_page
>>> in arch/x86/mm/pat/set_memory.c.
>>
>> At that point the guest won't be able to communicate with the
>> hypervisor, too. Maybe we should BUG() here to terminate further
>> processing?
> 
> Escalating an -ENOMEM into a crashed kernel seems a bit extreme.
> Granted, the guest may be in an unrecoverable state, but the host
> doesn't need to be too.
> 

The host wouldn't be. This only happens in a guest, so it would be just 
causing the guest kernel to panic early in the boot.

Thanks,
Tom

