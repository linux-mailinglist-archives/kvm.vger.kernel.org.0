Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B7D203CAA
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgFVQfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:35:43 -0400
Received: from mail-dm6nam10on2048.outbound.protection.outlook.com ([40.107.93.48]:6189
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729522AbgFVQfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 12:35:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWA9bVMqY4tq82kTB/+uV+O2TLkyfoZFbH/zId5hD4n2wjJbj2hJiTCjf9W0hYRxU30tkuB9w+gMhVZh9B+ZLM+pSXrk/JNNpDz49x4TbLvt9ZuSj/OeBjw0mZlUMzfLnDWSLoscxExE+hvaQJpRK/CrEcCqZuGUfrwQXIRnAwVX0olYyOhp2LFHdPbge1qP9M9D/Ukr8+R1F764FLlwAbIJI0GHQMlRn3fucKgu5iYlFJuvXR5GOETHMX6l3q6HnnmS/i6xWlibwLQZYU3GzEXrW5AQTW1hkKPj28CvYYvGXZbDODmIwEkGWqf15hmsIoGj7VeBc8TBQxxnejgVAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOEj/p68ARkN6uUpH8AO2Nl7liuGNmSHIS0K+3cHoqE=;
 b=M3z9jDr5DvTs1jfJudQKEILuuPZiU3xm2usGrZI/MW1TTWLP4DC58GEgqO1CRKR7Nd2FRxLjvOpXYJ6z10p715CJy1lljOpzrdxD6ikN/QFRhlIUvUVwF4k3ukOlwsskKG1qymvjADN0NJgRS2IQECD6VSzivK7SHLsePc2sbe4xZytIpdVP9ETZyWGdpS5CJfFaDvTlAeGMkQ4aJtKc3DeeMlk9XG3yiw90URJEcMQrbsq6YHyLHKbht9XFY0KpRQZcg1TveNxlHqn96m+cksGtiAHDZAJr1hsqyTvqzBIk6LKT2MYV37JFvg0A09E6ecmHgP1dx9cKYjvXpU+IWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOEj/p68ARkN6uUpH8AO2Nl7liuGNmSHIS0K+3cHoqE=;
 b=qCxFvMEXGZNay1Wmow3foe3PN5DzvMH4LDVDiV8Bw3usXapH8z7xlLo46wjSYm6UJZISBr2EzBeC/aagUS2/Ik9DOqoO4QkL6LP3ZBiXe3tlScYshNU9laeRL2gS/wcdBQmKjsdbJh2WzDCl1FFXdgYSlX5mrU9EtF5j/itRuhg=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Mon, 22 Jun 2020 16:35:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3109.027; Mon, 22 Jun
 2020 16:35:40 +0000
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <a5793938619c1c328b8283aab90166e352071317.camel@redhat.com>
 <08594d32-9be2-b4d6-1dac-a335e8bda9f7@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <53dc2f58-1373-b0ef-9888-713712c6a85a@amd.com>
Date:   Mon, 22 Jun 2020 11:35:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <08594d32-9be2-b4d6-1dac-a335e8bda9f7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:3:23::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR13CA0018.namprd13.prod.outlook.com (2603:10b6:3:23::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Mon, 22 Jun 2020 16:35:39 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 925f6d12-0dfa-435b-3c57-08d816ca4cf8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB337018AAF8CB37A01551C17CEC970@DM6PR12MB3370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ogpyri1y91EnDHUBPxeMFjk1ZCwNAMT9sQF2jwhQyiaQEiLeClPEfPRU6i2e0aioOx7+fa3+G5r2uMCOhC3q8engks6Pb8rdG/g1pw8wLuGBb7U8gkWjvlNCTn6lUev9feZYNZ/BSU63NlOby4Q+exRaykM7ZkTSa4FnfLQ4REqiW+TfhQJyWy7BHg6fg21foRvHBw9+ujs0LqtvT5mMhPHfOGvjpU46nd24GPXpVAGYH2zxXVBUZ+C2kZ+XQO4foyJVFbudZRfSY6UMNiRdyp7YV9MIdGdytv9AQMATSPwS9/K/4mmf54Sz+6hO9vDcgz4z6fx+Mn4BX699xYcpVG/rDMvsEPwbD16kSqrnn08mr9vNWQbX8QUYuoC5Q7bN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(316002)(478600001)(4744005)(110136005)(66946007)(8676002)(4326008)(66556008)(52116002)(66476007)(36756003)(83380400001)(26005)(16576012)(956004)(8936002)(5660300002)(86362001)(31696002)(2616005)(6486002)(53546011)(186003)(31686004)(16526019)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: duoI6pCEkYYd3NsM60/dBDLrVDRJwCQbuRs7UZIQRdefV5463XP/hokQzdgUlJQU+RBKEfgfoPvxTPWavbxgZH9reJL/BT8AZNx7f2Hze7DAAIMsDsQf770sttxODpg2eBucecAe19owaioX6lrE0Gn3gQm4cUHt36YeDkDmklq7ZBTyPR8hgxqHvkNHicn9mch2mdKf4H4JMiFdqJox+e8qQMZrBjPD/3x9tlWrhk0F8mOa8sUISYzJiEr8KWqoSMnwv+ZVtl4DFN8x7VEuW/uWkd0MffWRAemiD/RaFOfjdaSiEpzOcvQrlxXD4sXjPDkVBdD4r/HV4lfSR2FXlghSVIfnG7/WblWQv2n4TbUchSKE2fQT9yHYzAsQtTgXRkGpAALF8ZX1Fjp3cBtCWAY+fA6CgeZGfnLq7hhKsmEaInEW7Qv8YdUgciTYPmBykS+anb76ZiuhCn7XprJG6AZUGo8SvUSZW/p/VqREHVA=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925f6d12-0dfa-435b-3c57-08d816ca4cf8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 16:35:40.5056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DN6VbBOzHsqqOUqFgcecuAp4K3AzKfouFPKWSxzomhpw5XzODlBO/aADZHBiOnhIQmaOOrwCMmo2Qy1a7534QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/20 10:23 AM, Paolo Bonzini wrote:
> On 22/06/20 17:08, Mohammed Gamal wrote:
>>> Also, something to consider. On AMD, when memory encryption is 
>>> enabled (via the SYS_CFG MSR), a guest can actually have a larger
>>> MAXPHYADDR than the host. How do these patches all play into that?
> 
> As long as the NPT page tables handle the guest MAXPHYADDR just fine,
> there's no need to do anything.  I think that's the case?

Yes, it does.

Thanks,
Tom

> 
> Paolo
> 
>> Well the patches definitely don't address that case. It's assumed a
>> guest VM's MAXPHYADDR <= host MAXPHYADDR, and hence we handle the case
>> where a guests's physical address space is smaller and try to trap
>> faults that may go unnoticed by the host.
>>
>> My question is in the case of guest MAXPHYADDR > host MAXPHYADDR, do we
>> expect somehow that there might be guest physical addresses that
>> contain what the host could see as reserved bits? And how'd the host
>> handle that?
> 
