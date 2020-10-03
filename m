Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF902282765
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 01:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJCX1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 19:27:15 -0400
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:2241
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbgJCX1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Oct 2020 19:27:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlTJPqiOHwElCpRpDnjYvzLSChykcZb0tht3jzAc9rlSZwKIC5RxjsLXdQQYekIgAr9kxTnC6WHZMQ+9y1zO0tR8TIOkYgTSjCJ2Kp4wEhMMSEqV7meutCN8XR+0BCxJKerw5cBh13SYsVo4sFIT9psyzmNfvGBzwoXEPrWicV5SlRE8yOC+6hLxwO8fUcRjnT05Tcva0bdPZksy9HsgxaabCxB6y3jY4/NEWwKXL9uiOVc8DLxyAyw2QaS7H84SNZNO0f1OGiYmbBj5VZd2g+pnZ5EFpjd2uuFHeNnt0K7toIsDTbeZEyRVrC3Ur9MaDfn9L0B4FAyqz3YYu8Xq/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlPft7uotBViOZZF+bb1egLehncEH2zh0UWEkMv5bFk=;
 b=KEn7+DIIj+loGjf8EXGgSY/R66Ew5eZ+xpZXhxlOtMqDCK4G38BJxVrpQ40EXQyIYK4yvRQ9cil/5QjuwC5KZ8c78Ws1PhFDL5eZoyFhBaa+3UDlTQhp9loBf4GkcuAThbZ2381KKDgjn4qz6tEVHe4a2BNsqPTBPCMJ2E5hiVDvqIFxei4tSkCGtjT7Bg9dNIlCOjVWhotzfngnRo+QRMcYGIDskGFtcMNj7MHoSir28a+jAlRfF8IF4K+fDWR5fbGIna7f5lQDPQxXXRkxRnQW8TjWKuLBIStAtRAdS+4+2fdXvoQeiqm8/XUbeMCsFh7wvtsgiQW49/C7WbM9mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlPft7uotBViOZZF+bb1egLehncEH2zh0UWEkMv5bFk=;
 b=U0vhLbbQsTZiJH2E4317TqG2E9jK5aCWLdyiTGWJUXFwCxu2EVBX522UJXZrWqLYuEk6EtEz/k5skkZyIbwBg2hiuznZZIrtvKft8s0SUUjWV+78IGkZLF8srt6BOfBj777Xc6e3pMfj9TDv+RwvK+AOwiGI6fLHp2Nn23MvQLY=
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB4219.namprd12.prod.outlook.com (2603:10b6:5:217::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.36; Sat, 3 Oct 2020 23:27:13 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3433.042; Sat, 3 Oct 2020
 23:27:12 +0000
Subject: Re: [PATCH] KVM: SVM: Initialize ir_list and ir_list_lock regardless
 of AVIC enablement
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     joro@8bytes.org
References: <20200922084446.7218-1-suravee.suthikulpanit@amd.com>
 <1b8ff096-85a4-3dda-61d3-9a44ca6bb360@amd.com>
 <dafba8d1-8e1b-a3d3-d95f-e5581b26066d@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <4bf20a74-4534-9074-688f-a8b55708d936@amd.com>
Date:   Sun, 4 Oct 2020 06:27:03 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <dafba8d1-8e1b-a3d3-d95f-e5581b26066d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.140.250]
X-ClientProxiedBy: SG2PR0401CA0003.apcprd04.prod.outlook.com
 (2603:1096:3:1::13) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (165.204.140.250) by SG2PR0401CA0003.apcprd04.prod.outlook.com (2603:1096:3:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Sat, 3 Oct 2020 23:27:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bccbb001-e98d-4e09-cce3-08d867f3db3f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4219:
X-Microsoft-Antispam-PRVS: <DM6PR12MB42193851C2C1E1058D0384D1F30E0@DM6PR12MB4219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wx4rh0puynmUnfIcTQq/b9mbKO1e3pmDo922CY8fm1qI1UWOGH141wvXo0ul1/UsfBgO7mh5BOfg07qzsRBGWtv6huQv9bykzykbeRs4UMnp+NMcRtfbRm82hhLSl+kCxinj44vv3KT1FY5IU7Bq7nAi4TeIv7oJ/Cuyz+mIMRvAXW0lKxbtB1D6+2UirTXEhzqL8TMJ8h42e3oSUARmH2+vwS08P3CiNlCiQ4r4tmrfPProuRR3gporc6J6rud2itPEVv593f+PwfTBZO5hsLX1/KUnpaQs54CuIJKxTdBfiCKuaBNNEDNghfAWE+8/Zpy1PvonHywPZpcct6J6HIaF4tcJWB8qHvcf5ExKP03OEUm0G2XFez1BT0OrUT0Wp800nUnRU6+5vHUCQbY0eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(376002)(39850400004)(6486002)(4744005)(31686004)(8676002)(5660300002)(53546011)(6506007)(36756003)(478600001)(8936002)(44832011)(6666004)(83380400001)(31696002)(52116002)(6512007)(16526019)(2616005)(956004)(66946007)(186003)(66476007)(4326008)(2906002)(66556008)(26005)(86362001)(316002)(26953001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Gj1PiQ3HPFqZiX9BHK9wTCJ2tcUY06O5iDwtdRe8beyCgE8urhLbqdeolcoSWr8iujB4lF7Ec5bQogizWwTeRp2Wq7ypN5N0PKuCx8UMV2SYxMvErnHgz8Kmvpr2Ldnkr/eZ1JVvVBcsjIjtiTFxbO3lH717pEvm5TjebUxiIEMpH+HdqMdhvr+sJSb8QncaUdDfF5xGZQqXvWSEKjuOiraR8fNJwKqa/0Zzwe2l06YMW6I6EA9l7JhdfoC+snQmvzKj1V1jOw281N9dzxmeP1OGTwMBCR/qXYNFbWgjZSefgOv2KuTevLvJonT1CSNC/mtCliJRm4c1A2wHgHrNu3iXcWwf2IQZcbk1+8H5nqMtMR9kUIg5e7+EI0gQiy4Scb5lpFCbFkLqhXwrrwURt2L/NeK56u5OGzSsX6xJ63OrJYdWe8enloOB09jGx7uIYEG+1HA89uJF9FHltoKmaof2LYA9eGfVKwbdCmMYvgSKCpO4QEC7aeTBr8l/yEeHot2uFh2xGZILXbE91TsrB2/KNi9/5L02u+q//8NAMZOLrtfM76FYWdBsZQ/vkfrJK2l7ZE6sUp/yHjsiaXVhkC/+KEDODqfyZpvp1hJAUez7ntz55bBQX0tumx2+tw4R5uDnEgHmsUsWSa3nYXS8ww==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bccbb001-e98d-4e09-cce3-08d867f3db3f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 23:27:12.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAqfjrYJLh99z6eqRq7kQ+d49EGyYEM40rr+mL4id7tRU21/9clO8nmDFOK7zkE4skg2ekSXgJaO/LdpPpvjaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4219
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On 9/28/20 3:01 PM, Paolo Bonzini wrote:
> On 28/09/20 07:53, Suravee Suthikulpanit wrote:
>> Hi,
>>
>> Are there any issues or concerns about this patch?
> 
> Yes, sorry I haven't replied yet.  Looks like Linus is doing an -rc8 so
> there's plenty of time to have it in 5.9.
> 
> The thing I'm wondering is, why is svm_update_pi_irte doing anything if
> you don't have AVIC enabled?  In other word, this might not be the root
> cause of the bug.  You always get to the "else" branch of the loop of
> course, and I'm not sure how irq_set_vcpu_affinity returns something
> with pi.prev_ga_tag set.

You are right. pi_prev_ga_tag needs to be initialized before used
(in case AVIC is not enabled). I have already sent out another patch
to properly fix the issue instead with subject
(KVM: SVM: Initialize prev_ga_tag before use).

Thanks,
Suravee
