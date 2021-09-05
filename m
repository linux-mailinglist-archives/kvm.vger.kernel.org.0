Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226CC401011
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 16:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhIEOAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 10:00:55 -0400
Received: from mail-dm6nam12on2058.outbound.protection.outlook.com ([40.107.243.58]:62273
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232209AbhIEOAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 10:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NG2BPWhG5XbOOcbu/j1PMIIoF3nvkWs0ONV4SlxFVGcMuaQRuYawn0zsU64YXGdA80OEZ4c1J3GXigAvFYVyq+jcfjicb5+OJgU9Xz6Nnms/ehg+L05PxHMf+YzTwHU3FB/jLioLSpnHHzq/W/zPHrgVPXCHy8irow7kG8JjxqPJ1bTMr+CLzxHS83k/Eo0G6+z+/BZUEDLDV+IgtrGLDfkF/QhoYF1NRq/Ys5DwkoYVomSzrJ1c/siP+vba5n88Q8+lDz9QDxbRg7K6SrwETU2n6CQam+vFtuPiKzRAGUVvRNFw3IyTB/vJ8C7upzs603ooOeJXPMqqV2ZPPXzMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3ndnraWYtquLoJOxdG/D7wPrtuwjqsxsSBhDtKTV0gY=;
 b=O3wnwe8GqB39HedT9CfSzv+dbYBtp04VybQV16GFF3XGEUuHPkJynZW4t2bvKLWjCBGMYjpcqwOlvq6JVvesbtDYK9DW6/OonXSK6Y0oifKp3JFOIcnNY2yTQALZRDrHNKm95U68lYgbm28WU9vwXH+m/82NTciZiAqbhzIdMzkxzmPO8iqkAXsuLkLTDyEoOaM5AnIBSKWKspQ/No4VxtihcEqnB8BM52k6IJdnnoA3nR3IfDmzm7Q51GgVn9iloK0wPePux0KKLoNYFvW6MNA0bMynBHAGVzwKlXmoJcZmikVTbDIsqrOelA8ZqgUQXFrJsf7IrFTY4/Om6awyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ndnraWYtquLoJOxdG/D7wPrtuwjqsxsSBhDtKTV0gY=;
 b=bUCcnTH6GmwpB7inMiZO80NqbGBs+PrSDEH0DoWFSpZEeEtsEL3PIvbx1lYavBDM6g3UY7wA2v4y9coI2rfFfp0VD6FmszW3j/wvVWRw/PLKQKONtEPr6oFScdTA/GGRBcISkW2CtS9rC5FzhpBbacGYOJSrDJjj8cvgn2jUlZg=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 5 Sep
 2021 13:59:45 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4478.025; Sun, 5 Sep 2021
 13:59:45 +0000
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
To:     Dov Murik <dovmurik@linux.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Pavan Kumar Paluri <papaluri@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
 <66c9694a-bd1a-0a12-8c1d-326d34daaac2@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <dbc82551-4b10-90ae-3a89-97c418049408@amd.com>
Date:   Sun, 5 Sep 2021 08:59:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <66c9694a-bd1a-0a12-8c1d-326d34daaac2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0027.namprd05.prod.outlook.com
 (2603:10b6:803:40::40) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0027.namprd05.prod.outlook.com (2603:10b6:803:40::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.9 via Frontend Transport; Sun, 5 Sep 2021 13:59:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71fca138-9d3c-456b-4c37-08d970756a55
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271700164E2AF7FF628788B5E5D19@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2L+0iBvn8VYQVk3bHz+N65i6WG3I7BiMS0FSEV9tyJsrhmYH34iySWqV8yNDnLtDUIU/4vwYIkysSX4e0Gwg5vbeDi6kjTwCxfADIFgxoVd+ymTujxgq2toEzt3XEYFM59ChJ6U2D1FY+KUma+qgIOAGFFyze0HOmhytv9iA94FWxuRZWz+dvSs6r6haQbfSWQ7eNfbGDq1g/OC/sp3MRunRKbU8NLNS2MKLyCFM8i1QX/8unX3Akn6NXTkUHL3BJiXn7xS4cgvuTDvtIoLO7+9p2+JuP87LhRxWe0vdkqyIXHObfOJS9k6yKvwGsSJjzVAFhGysV+q4Hq1PZGEa4VHTPkT8gfq/zbPilccJ8++3T5soSbJn9TuOwNLzonH4AsCLXZB52TpjYyz+DWft9Yj+xyv0GWvLOy0YkAD4G95gL8dZl5rxmiK4AFZgTXl0YBITztXhT/yKNpgmnbRx8EoVjZMKeAN7wcgvRYoCnd2oAQftW/6EiWkb96x2GOge8yXPEsezuizEpSF/GAZQIKPUK+ARmPDUoAzTMqz06cYdbL0hD6rgbWORbSvGiZHRbBaWvK4phc88KTp3NKK/IzqVYiCyYDNqSnF1svrcbW7vStKVMlFQcR6My49hUlM4L7WUz3iiLSxlkfH00ThZQ1d3A/NgfGPnacDizRxevj/7Usosp8ud/iHE6wJfcAi2qB0BNqda8VAJAqDzZ1SRCBNaj3wisasZ0Oxht7veLSMQ5jzwT8Eg2bSs1uqF96I6kioCEQCkP5eLawp4d66WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(956004)(2616005)(44832011)(54906003)(36756003)(186003)(6512007)(316002)(31686004)(38350700002)(7406005)(7416002)(8936002)(6486002)(86362001)(2906002)(38100700002)(66946007)(26005)(66556008)(6506007)(4744005)(66476007)(31696002)(8676002)(478600001)(53546011)(52116002)(5660300002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajVaaVlBV3lKUlJBVE1ucWhyTXBpa1RpWDZETXhBTFNrVG1jVVVUVm5ndWtS?=
 =?utf-8?B?U05pTG56c2RNMFlBTVhPN2lnOEtUR1Z5TTFlWi9ONlJaTDVvdzRIU01uQTV6?=
 =?utf-8?B?Y1dxNGJhYW9nSWMwOUU2NWN3alJOUWF2bnpzeWhuRjBKbE9HTFc2WDhaMzFj?=
 =?utf-8?B?a093eWpBam91TVZHQ3JpWU5xS3dMbmZUWnkyaDV2NjhKeHZnMlFuL1ZlMzNX?=
 =?utf-8?B?TEl0M0RqL2dmV2tPWFh2Z0hVVWpYNUlKOHQ0Z3NsWmhxcHc3Rk1laFdQU21Z?=
 =?utf-8?B?ZFhjOGNTeFJES3BkQmJ2ditqcmxudXZhcUpmWXgyUHFNSklQVmtxR0g1TVI2?=
 =?utf-8?B?OFhRTHVTZlgzKzROZTRJajM3TWprZ294L0ZJL0trVDJ1MUJZNXlzTU1jNWd5?=
 =?utf-8?B?LzRqZTR3OWJGalBXWVRSQnQrcGo1ZkpXUFVPMGVCci91cTJocEJtNmdWZUJZ?=
 =?utf-8?B?OE5UT2JUSk1IMlIwMm8rQkhQMzJpcjZRUEUxQlZBblJndVN0WDhmTzUzZkdr?=
 =?utf-8?B?Sk5UT3dJa0xhQmhLdWdxa3FvRkdidi9TcU1FN3pPY29OQktLaE9ZeUlCaHNM?=
 =?utf-8?B?clZDdDJlbGFxNjRSbUdhOUN5NVVURUJKTE1zRmVubVAwNHJWc3NGYjZ6TnZ2?=
 =?utf-8?B?YmE3anNwdGxaV2hPMFdxNk95ZUw1Um9nSWMxNGdISncrU3pwbWNNeHVhc0pu?=
 =?utf-8?B?SFA1NStabFBSa3RFNXNCM08yOW1zOTBVTFl0VzdRZ05TSTJ2V1o3Yjh3YWJV?=
 =?utf-8?B?Ni9QYnBMTFZmNUJQODdHU3o3SXJXTlhKMkxJVWF4VG8rSmU2L2hheHJhcUJ0?=
 =?utf-8?B?OWlOM2UvbUQ2djhjMUdkYmlDdGhQKzFrVHFBMzg2UGxpZDlhVXNMVDRkSEkz?=
 =?utf-8?B?Rk9ZWVVNWnZ2cDNPdFhHVVRDdWlaVjZENnF4blE4WHQ2ZTIzOUJ1b1dhQ2VU?=
 =?utf-8?B?S3g2ekhvOWJRd3dOK2t5VUpCZzBBOEduZEtQU0I5NzVvQ2lxUENPRUxPcXl0?=
 =?utf-8?B?QXVGLzBJTjBsWWpRL2FsdnNjQ041RVlvbU9RUW10MFIxMXZqTjdNVFVJUENB?=
 =?utf-8?B?Vm5yd1B0QXVkeWJwOHFvRUxpSHhra2Fqa0w3clFXR1JRbHRqekt4N0l0dWdT?=
 =?utf-8?B?d2dTY3huMzhqZGZHeFozUWpURFlDL1FCRGp1RTVDcE9uMGVLR2RScGtnU0ZB?=
 =?utf-8?B?SWZkY2FkWmFJUHgvMUhIN0RiN0VZMkU2REZEWFRseDhMclRtK3pLbkpVOENY?=
 =?utf-8?B?WVRIemR2Q2FrVXpIWk1EMC9vZU1iRXNIbVZRalNad3RlREhWRDRTYks4b3By?=
 =?utf-8?B?Wktxb0lvbG52dmo3eDd2V0VoRjJJNmprMDgzcndoaktWaHZ5MnIyYVc5U0V4?=
 =?utf-8?B?NUQzNmFZTGljeHR0RjZPNVJwTDhSZTI4YlI1NlF5amI2aDYveTZUMFBJWUpr?=
 =?utf-8?B?UDZ6S21kcCtEMEcxZnR1QXFZNFFwSm4xWlN2enRNeTYweUtZZks5ZVZlQ3Bl?=
 =?utf-8?B?RnYrY3BZYkdnR3grV0cyZnpENVNycWkyQ3hwemNPT1RsRzlidkoyaTVNOVEv?=
 =?utf-8?B?YmR0ZTdRNzRSdVZDUHRINGpBWnZDOVVTcTFVSjZZbTBVSC9aTjVEdjBKckk0?=
 =?utf-8?B?ekp0RjNEMWNmUU1ReUx2VHJwbUdYYzJydk9OYWlpZHdaUmh3MXIzV1Vzd2Fr?=
 =?utf-8?B?QkVpSFZpVUdIVkdIbmZubnpmUWp0TnZxRnl6b0lPZVkvajF1NC80cmx4cE5Y?=
 =?utf-8?Q?gfm8d0alQCeTi0tOxpHDBDFG9k1O8jxcAu36QrB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fca138-9d3c-456b-4c37-08d970756a55
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 13:59:44.9573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSFC7mtBuKJIdKyKHwl2AMsTZqUYtA0vGw5hSTe3FA6s9OGlHrduqm2HMiZPH+KavhJz0ddLRa/e2r868xrhOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dov,


On 9/5/21 1:56 AM, Dov Murik wrote:
> + /* enable the restricted injection */
>> +   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
>> +
>> +   /* enable the restricted injection timer */
>> +   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)
> Typo in these flags: s/INJET/INJECT/
>
> Also in the actual .h file below.

Noted. thanks

