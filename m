Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241503E956D
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhHKQEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 12:04:11 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:15073
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233215AbhHKQEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 12:04:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqH1hd2p5ADdCy2+2row0j1Ht5yXJLZxaL781XMYfBNPW9QVAHJyCCS3GZc7tMkYj7mjqx247yKzPCE2Jdn9FmGMfbBe+NR4iZxvtU16lzL1O5/y7MhdTxRsIis8bVPuqwrHXaELwFTahC7aFL/SQqR1nFnBY/mhGfbTRHwypOdmUKEOdyUDlecPnBoPhLYZEZBaQ5K4JUnf0V9hgakRwL088nGkj1dXEzWb9b9s3J7M5oy8W+9SDvwcTr9wirX67RVjdvui7hc5Wu5XaubSXbSLGKlOvA/WsXwuf5VrPt8DammakCnCEJZs60b9c6zbCuGHhuGQpOTQGBYxgnrqKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJMFkKuRbbSeSKkXnPCeZ+rBiD/oWuk4C1m9wyFAMHs=;
 b=U4y9rzDlKPfywyL8CeIXZ1Pkpl93m5ElX0UVjjyCxz+a/VcCaFamPVeP9LZ09iiNSKkFzMKqWhmWER8DEClDafqjxp8Ez+Jt5EN4hc8PmaNKgJ7p1ocSvUSGnpAbn+wd5oeeDHxkkhUBcPU8jFTlw6IlH08c9mxqwWKfuffxDdWrZ3nlQAEBYUc4Xzy+oIr5dtRBsuiiKkeg4c3Iq9O8TCuWwSa1ob91T2e7gA+/cvWSXSF+QdYRu8DA7bj6NIXCuBlsvbwgrVV/IKP0n/712/6HOu836uCGcVQJUo+4Jx1Oxil/KiCGn1hswnLQTF0/mNv9N0KeBODfILcVlSeaTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJMFkKuRbbSeSKkXnPCeZ+rBiD/oWuk4C1m9wyFAMHs=;
 b=U6EeOCvL7bslZ9PEbd6FGn3W4qyQfBB2YiguclaQkc7t6OvZa0ElfaP9I05xRcNlZGRpZjlupcfaMjcxSBaAJBnCDuSxzxNfRK3R1YfRZc2Fu6vHaFrDbD45btTtTklLlidERvRYDgrGZHfTU2/DAk2LgmR+HFcL/OJ1e/y+W+8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1550.namprd12.prod.outlook.com (2603:10b6:301:8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Wed, 11 Aug
 2021 16:03:45 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.026; Wed, 11 Aug 2021
 16:03:45 +0000
Subject: Re: [kvm-unit-tests PATCH 1/2] x86: access: Fix timeout failure by
 limiting number of flag combinations
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     thuth@redhat.com, drjones@redhat.com, kvm@vger.kernel.org
References: <162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu>
 <162826611747.32391.16149996928851353357.stgit@bmoger-ubuntu>
 <YQ1pA9nN6DP0veQ1@google.com> <1f30bd0f-da1b-2aa0-e0c8-76d3b5410bcd@amd.com>
 <7d0aa9b1-2eb7-8c89-9c2b-7712c5031aed@amd.com>
 <4af3323d-90e9-38a0-f11a-f4e89d0c0b50@amd.com>
 <b348c0f6-70fa-053f-86fa-8284b7bc33a4@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <29220431-5b08-9419-636e-d4331648aed1@amd.com>
Date:   Wed, 11 Aug 2021 11:03:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <b348c0f6-70fa-053f-86fa-8284b7bc33a4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0027.namprd04.prod.outlook.com
 (2603:10b6:803:2a::13) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SN4PR0401CA0027.namprd04.prod.outlook.com (2603:10b6:803:2a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Wed, 11 Aug 2021 16:03:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7c736f2-720f-42e4-dfae-08d95ce198be
X-MS-TrafficTypeDiagnostic: MWHPR12MB1550:
X-Microsoft-Antispam-PRVS: <MWHPR12MB15501186CBB3C5DC4F8FAB5695F89@MWHPR12MB1550.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcixKr+doQIwo97v1C1Davi/HVCMl5kiXuU/hVJOtaObYWN2Zaro0t9tI7NUzml5bgH0uSIbH0wkVK5QeJnLtJWe5m3XQg3wmgtM8GMEDQ56CeVYvjBaurnLcLyIRJwe8JTw4xEpuYovl8AAaWNKlWSazWTGVCrrE8owE0GjRfqkEa0gmeXglHvwO0bGENc2uknb46PddDTEYfrTZBgun9pWfhETod+kcULYCikr3mLkZ0vWMfeSy8E4efTWR7drDys/K6qVzRUuaIvbI34w+o83rWAhpWBdRcknMs9yuxzYVjFyd06si4gdV8gahuzq7TJM0+bI6Zfk1VvUPqYkKA0+gvHnWKiuDF1Gg1RHTdXdfPLGgott/68LbmImuCdXVKZvPou6LKPXE4QI0BtFjHEsZecgyGE/aX4L/6zbJsKBYJmJJJVUYypq1iaGCvSFaoJYERI4z8wFjgV5EVL9AgcMlvxLHHlEf0JHUkTzDykqhrDpCm8AJKcRAUhuHfl6O6dCmJ7aTVQHgiAEedyQoG4yZeA77ukC04HG6Mkp2UBzN+5uQnBB/e6bFO2PjWwoh1+pqYiUCgVwFNt1VF7gfpYVHReyCOLEt1r/LIXLPvH3BKW17m0T7NfaAFTHI42Oyn5UmoedVpMW14cOEryOg1BaAkkhK4ZBZ61Hjcwl5PnSCTC47arM/qiV36RgAue+lXMDkKrs/DAjEGG7wyxogZxOcu8sVzI4oWs+SGfXSJEYpsXWT9ObDTIgvnY5L45G/3LL3pcECofsQPOhV+sJcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(316002)(31686004)(16576012)(5660300002)(2616005)(956004)(2906002)(44832011)(53546011)(8936002)(36756003)(26005)(31696002)(4326008)(6486002)(38100700002)(52116002)(186003)(8676002)(110136005)(86362001)(66476007)(66556008)(66946007)(478600001)(38350700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG5rMUtESHdZVXlXcjB2ZEJGWXJ6WG9wR0poZ1FSaVhRNUNHTk9sWVRtcEFX?=
 =?utf-8?B?OUVvUW5pOXdCV3JiZGM4WDFma1pNZDVQSStMNUE1MVA5ejdBRUpnY2lUeHgr?=
 =?utf-8?B?aEhHMVFjMTc2WExjZVUxZVlXcDdSeWZDcjhrTnFiSHd0emkvR0Q2VHBNOTA2?=
 =?utf-8?B?ZFhLVEtudGJCRFhNLzNNTFZDUUZ3Z1FDM3FZdGtCaE9sS3BCYjJ1QzVSL05y?=
 =?utf-8?B?cWtMTWRDV05YOTBMek45VnRuNENRTmJMSjg0TG9vNTVRc2RnaXBFaXBpSllt?=
 =?utf-8?B?a2d2cjZndjd2SGdtSU5nWm9DQ1pMY2lwSkZGb1VSb2hlTUYzM3lGaUtBUENJ?=
 =?utf-8?B?TjJ1clNkWjVmRlk2SWx2akpuL0Noa0hyR3VWTmJzcFZiSXFqclI4MCs1Ukdi?=
 =?utf-8?B?eDkydDE4SURrQks5dXhydFJ6aCtJWkp6b0FqbHluSVZteWh5NHU2NkljcWs1?=
 =?utf-8?B?SmtnTjZlOVpuenZOcDhZWG9HS3RERG1DSG1INDJyYTBsQlVYUlFXNXhRRVdE?=
 =?utf-8?B?bE1PUmhlYUt2dnI5Q2N1cG11N1Z6SnVIMHZkZUxxZkFXQkhCMzQ4WmR1TWtp?=
 =?utf-8?B?YWdrN0lFT2FVRGw5cjh3NzJSek91TnVMN3J0Q3hWSVFPZXkwSDhndm1KejRU?=
 =?utf-8?B?MHdDdGVIK1RwMWdOeW90RXJLeDY0SWt5NlJTTWJMR3I3K0ZBci9Gb3VWeFhm?=
 =?utf-8?B?aDRiWnRBTmU1dURYMGVubjZNZEhBU1Fha1pqS3BLSlBIbTdqUkZLdEdvU1hU?=
 =?utf-8?B?SjNLVXBsZ0ttWktpVWg2WHZPU2p4SEZvdlZNTFhETDBKbUx4UTB1dUJ3TG43?=
 =?utf-8?B?MVdNZ3p6dU9IcXB4OGV2WlpuNUNETEpraUo0aEJMeHJNYVZyZU93S2pGYVU2?=
 =?utf-8?B?YmsxSkNyOVE2M3cvRHFTK0J0VUpYRjNROUxPa0RTRExFNkJLai9ocnBFSDl5?=
 =?utf-8?B?amxTeGY0dVQ0SnlxY2xYMDdBNTRCMHRYL0lHZ2VCWnF4SWt6MTVObGU4S2tC?=
 =?utf-8?B?dFBhYVk3Zlh2VTRrKzBlZ1djQVB2ckVOUDg5WDlKa3A3b2tBaGpuTmNLVkRP?=
 =?utf-8?B?Z2N2SDZOZjd3dVZIb0VUeWZjTHlrdUEyRXB6OGljV3FmTThoRjIyZm54b3JV?=
 =?utf-8?B?elNkQXlwZDNyU01WR3JQM28xelkyRWdlMzd4Mjg2RVY4OS8wQ0IrV0pyVmor?=
 =?utf-8?B?RjNBSkpoVFA3RkFHRW5tS0x5ODc1eGljZy9YdStQZ0RmZTNZd1A3eHB2RWQy?=
 =?utf-8?B?Q1hRRDlSRFhvb0R6anBMMmRoanFkdmdubzRwL2kvQVY2ZEFuVzJTNE5qd1ZD?=
 =?utf-8?B?SVgxTVdqeis5Vy9zSzdnTFFUYnVrbWs2K1F0ZTU3bXozVUtVUjg4Ui80Y1pE?=
 =?utf-8?B?dWQrWkVzVTBWZlZpT3hVSEk5YlhIdHZpUXZZVDIvTFc5MHhWQkIrYXF4SFQz?=
 =?utf-8?B?bUpDVmtvWE5ESUM3VE1QUEdLdUdiYmFzdHhCVDU2cEhOUkJqUGdXd1Q0OVlL?=
 =?utf-8?B?cFR2MFBCOHpNb3NRZkV1d0dlWmpnRFl1SzhuZGp6Y0NYTUJwWGRrMlpLVlZU?=
 =?utf-8?B?S2MyTFZwZ0t1UXZ0dGRlbGVxRWd2R1ZMK0JwaU5qbjlHbHBQaVlYblJQdS90?=
 =?utf-8?B?dC9LWkhNYnhwSTZvMTgwQWZEUnZCV1p1UmZWV2cydS9HZGUvaU81anQwOFlI?=
 =?utf-8?B?OW1hSTZTOHhXazkvSXBISVBvOVJqeGVMS0J4bnlJaW1JVVl5YjY4QURVSmhm?=
 =?utf-8?Q?FERpzNf2U2u7daZ5U+uyppx5+ozur66DrNsto+Z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c736f2-720f-42e4-dfae-08d95ce198be
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 16:03:45.1172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oynAfAn+pwcP9DzJaA0THMmYkjlt/dX+XXyV0jecYJtSGr27YKQvLi8AuykrkKD2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1550
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/11/21 2:09 AM, Paolo Bonzini wrote:
> On 11/08/21 01:38, Babu Moger wrote:
>> No. This will not work. The PKU feature flag is bit 30. That is 2^30
>> iterations to cover the tests for this feature. Looks like I need to split
>> the tests into PKU and non PKU tests. For PKU tests I may need to change
>> the bump frequency (in ac_test_bump_one) to much higher value. Right now,
>> it is 1. Let me try that,
> 
> The simplest way to cut on tests, which is actually similar to this patch,
> would be:
> 
> - do not try all combinations of PTE access bits when reserved bits are set
> 
> - do not try combinations with more than one reserved bit set

Did you mean this? Just doing this reduces the combination by huge number.
I don't need to add your first PTE access combinations.

diff --git a/x86/access.c b/x86/access.c
index 47807cc..a730b6b 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -317,9 +317,7 @@ static _Bool ac_test_legal(ac_test_t *at)
     /*
      * Shorten the test by avoiding testing too many reserved bit
combinations
      */
-    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13)) > 1)
-        return false;
-    if ((F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
+    if ((F(AC_PDE_BIT51) + F(AC_PDE_BIT36) + F(AC_PDE_BIT13) +
F(AC_PTE_BIT51) + F(AC_PTE_BIT36)) > 1)
         return false;

     return true;

