Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EDE52C491
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 22:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbiERUgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 16:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242784AbiERUf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 16:35:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F9CDF04;
        Wed, 18 May 2022 13:35:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5LCmcqN4lKC2Lj7ECLeQLj1Yv726fLVrHTWHF8xS2FCTwfRte/KnZz2X+xY/XJ0w5I7O+qGXzxWf+XIIwCC4Lp/vjQF3N9RbU+ehPap3FMxR9eCH3mmFTAFMA+s4VYtW9mPV8ZgWKoewHCHuD6TrqQm5+EESYRm6NMJPKSKvTDbZTRFrpdPselDfzVk9QC+QqiEP7LZujQYBsGTeoDiN8FWaU65PwTtGcFGfeBGg5TMpi1UTBMMrXinGdE0XNZyNvJ4b8VLFgOyJ55DzLgBWQ9UlnmWPBSQg3b3Oe7bcHON0lgBjS4Xlk74AL+yxpo8UUDBbnNODj0J+wVSm58wng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UyegvX2uEdN0Gt/WIDNwL7n9IKXEpSMwD/76L4agVc=;
 b=Uqi9y6EJhhcmdnzn7TtxJqNnWXiNWhxROHoZSxw7pO8Rb3CXF/B02yKgFNjbEY3fc96cZZ6loTItxbJMYW5PCNVPY8f/mjV89yAH/Kx9EGrQhj/JRGtvhPQcwBzBCvdIS9Qi340qk6qHDgYjeSDey3bjE/lhe52smFwsSsohHzL1VgEmbOWwlJSpWYcSD/xgVnThzZ1wRU4O3hEg4ZsnKrStaiR84tQaA2sLnrFq9uw1R9wROqzxbNYUxQKY8gss+1zL0KFfRMryDruYrHBOTR4eb5i+ii97u7oTOG3BtuCNiuWS+5/iWxFtScYMIEIPxGlsglz7jy6ptPfp0aSz7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UyegvX2uEdN0Gt/WIDNwL7n9IKXEpSMwD/76L4agVc=;
 b=AC4X98HaR2hYqUhQ077IqjtxkGIAk16B9b54S35yv4TW5XNbsxLTar76a7yWTny5E3SbbFqreE5lB0sh+0TF4gzUgTZmK2b3SxRJLuP0YaPK/j64F5holGzqK4QovgoCFLgPtSYnI9CbnXqh1nbNXY0po4eQNeV4gme0t92TUio=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BYAPR12MB3575.namprd12.prod.outlook.com (2603:10b6:a03:ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 20:35:51 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0%6]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 20:35:51 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Marc Orr <marcorr@google.com>
CC:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
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
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>
Subject: RE: [PATCH Part2 v5 27/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Thread-Topic: [PATCH Part2 v5 27/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Thread-Index: AQHYavTg+uv5TSMjBEikm8/VzrSqoa0lFKPg
Date:   Wed, 18 May 2022 20:35:51 +0000
Message-ID: <SN6PR12MB2767AE3F8CE57B42BAE37C138ED19@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-28-brijesh.singh@amd.com>
 <CAA03e5HmBHbt4YhE+0Sd0UKf_Nqeip4fRj73pdPfSSmNaKZvBQ@mail.gmail.com>
In-Reply-To: <CAA03e5HmBHbt4YhE+0Sd0UKf_Nqeip4fRj73pdPfSSmNaKZvBQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-18T20:24:29Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=7cb7f854-2c91-418b-8e95-5cc056685dc0;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-05-18T20:35:49Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 309411ec-7803-4006-b8c3-9fcefae57531
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14e5a9bd-21d6-457f-67ab-08da390dffa4
x-ms-traffictypediagnostic: BYAPR12MB3575:EE_
x-microsoft-antispam-prvs: <BYAPR12MB3575739601654021088C092D8ED19@BYAPR12MB3575.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ezFF3mqGf6MgeTnP3aVOnOS0CjmwJiGz3dNfJc5ZkHt0Wrzz8QaCBMVz/HdrKMRyDx2Pxtv9OqM5vacWsLK8YSUanAJDAqs4qC4v6KiWzm/Jz7hXC4h4RJGF1AQz7+4LiJkRjHQb5l+Sh0vfPE8Fqx7tOd6nkzuKuHS5Ya6cv1WLivhxMlu/6VtBhYDQbO6tLCEYh9ol2eOqY2otYNuLpmESmnWgvS9hmbP0yrR5D0Q3YbYFu8AqOi+tnnHx1C1oNTEDwYy8fAYXS54eMWP7gkXitWaf2/x1WMrPffwm+/GmacD1OZpFMtLV89LCpSbRIWcoFxvuPnay7/9NYefB7n8qLJQ1NnUDbKHus5P3+Sor6QrfTmHRU8WaUVYaFhL+46NsVJc6zrm6rs6W5JDJTNYHZAJ1csUo9epyeUNw1lq4iPb9QkH6XW+42SCjRRQg84QPYBgS/mFBSpbmDsLmSHhuOIPgbU91HmgUk9UUZ828ftM+EYwA3/BGUxQlX5Z63Zw5PEEc+7y8elq2CWnqeQdcfVA97A7m6ryAmJB5X3fcaJYS9eK1V7HFVy9ZlsGBlrQbT5gHXRKi02n7mZL1xKYA/zMTQpu9lMHAePOaGF/igyy3p9I25jdar7A3DIpno84Nab7JG1yRpXQxyFO56mFwcjAl5FFCXf//jvqUOr0pOd7hwxMx9qjUHj/BKcsvHZkq4xSyUbO8E2Byg52vQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7406005)(71200400001)(7416002)(316002)(9686003)(54906003)(122000001)(8936002)(86362001)(6916009)(508600001)(55016003)(52536014)(38100700002)(5660300002)(26005)(38070700005)(64756008)(4326008)(33656002)(53546011)(66556008)(66476007)(66446008)(8676002)(2906002)(83380400001)(7696005)(186003)(6506007)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1FIc3cxb3Bhc1pjaDVVcWIyOFJ1U2lDeEMxVXkxQmdOL2dkM2VuMVBLeW1V?=
 =?utf-8?B?di91aFZmWG1POWMrOHhvQWk2S0ZvTVBsaVptQnV3YWt0aDZlR1RsZGdDOGxB?=
 =?utf-8?B?V1F6d0w3aTZPYXJCMDRKa3U0a09oOFJuVVhyQi9zL2tMWXBER3NFUzVIQVcx?=
 =?utf-8?B?MTdJMzBmdm9sRmhDcFhNbDE1NFM3TjZiMmNBc0E4ME10TXZQOUQ0WDU2T0k3?=
 =?utf-8?B?SVVBVk52bjlBVVBJYUtLUDhTb3BGTGJtZWhQbTlyWExZZlZxNUZ2b2lacDg2?=
 =?utf-8?B?L1JOeGJXYXVkVXgzYlZydUlrbFlaZTkxS2txTzVmZmxCalZDUGp2Z0lybXEv?=
 =?utf-8?B?dEk5Z2RiK1lXWExtNzgrSXVuY1UzbzV0aWs5Y1JybTM4bjQ0NkZycmcrWDZ5?=
 =?utf-8?B?ajhzQWVoQjBmcjRkKzNoR2FuYVllYndOdHZvVVhOeWpySnhDSGlCcTRyNkxn?=
 =?utf-8?B?OXBXSFdmdmhoTGJhM245bG8xTDZEZTFjemRJM0VkR2ljUUVDRnZXNjlqWFJB?=
 =?utf-8?B?RGdNalhnanpTUmwxZjBBMmloR1R0aEhPeXF3NkRYcVFhYzYxbmRlTnFJWlRD?=
 =?utf-8?B?MkNqemtobmNGZXVBWkRpRi8zUnYwQnRwWSttcW5yaUkzN2MrdjFxM28vN2Vq?=
 =?utf-8?B?dUNTN2xoNjVmbzdXQTd3R0M5c1FFV2E1OFV4UnA4WmZDenBUOUx3RWIxdWhw?=
 =?utf-8?B?RW9RQjgyN21SSENveW55NFJhUkFvaWFIZFlLK2VhVXZFbEs2eVpTSzh4U3h5?=
 =?utf-8?B?NVNOWVQ1UzEzT2lrbTFZdXNubDJIT3RqM1hLQXhOcGJaanBSOWpGUEhUSTUv?=
 =?utf-8?B?QUl4Zzh0LzE2a3V5OUd4R2JYNWlmMEFuTURRaWU1dWVFdkZQeFV5S1JZZGdT?=
 =?utf-8?B?L1Q5bHdnSFQ4T3MwcVVpV1F1bUIveTZXczlmdm5aUTRTc0UxM1VXS3l3ejgy?=
 =?utf-8?B?aFdzakhNVThSRG8zL0YxT3IxbjBvVmNkQ0NjRjg2N1QxZHN5bXJUUzNsWU9t?=
 =?utf-8?B?T3FOR3NFVHZxeExidlUvbWx1S2hhZEdQK0xzVHZrN1ZUK2RlR0ZzaVI0Mldm?=
 =?utf-8?B?SGwzNWN2ZngwNzlWRVRvZm1IcHdjUE43dzVPTDBkeXdodjkwamJqRk92TU9z?=
 =?utf-8?B?eTBseFVTOTJ5QUxaODA2NlFSekFtQmhDbkZEN2J1ZHJ5RzdHUFVOMWJEZEdL?=
 =?utf-8?B?cndxaHgvaEZzbDd0clNZZVV4VDZzN0M0d1NrbGR5cm55M3VkeFhvUEVjc1pt?=
 =?utf-8?B?SGVEd1FRRTV4YlBYTVkrOGJ1c1ZWN3JIcXNKc3Q4WFZWcUhaL1pNMFVCYko4?=
 =?utf-8?B?QzZyUVZrRXdYT3JWM1ZFQkt5S2d0cmJaeXRweEJDZ3NmejNPc3FYaUdqV1VP?=
 =?utf-8?B?QTJYd0RDbitFV3QvS3FSS3hGTmpqNng5UWgzYnlzUnJtRnJjU2tGcTFnU1NO?=
 =?utf-8?B?NVJ1WDRyY25NSUN5VE9nbWFEN2Rub3hJdUZWamhEa2krOHpVYTl4M0NET1R0?=
 =?utf-8?B?RmY3aHM2V2x1enNBd1dHeEZFL3BNb0RqUHlBWHhDU0tRMFM0Um5yd0lrbEEx?=
 =?utf-8?B?Sis3K3RrVDFwd09Bb0h0TEhVUlRycUpWc3ZkNkxZTnZoODVlRHl5VlZybHo3?=
 =?utf-8?B?WkFLUXVUaklCejRYOTdHMk4waUE2ZGJZOXVZNTl5OWpOdE1TSEFOZm13Y2w1?=
 =?utf-8?B?aWNrUEprZnlTNUtuSjlzR3hZZFQxUmI4Yk42Vnp1bDNUQS9tTkd6NnZwd0p2?=
 =?utf-8?B?Rzk1TGR0QU8vZk1JSXlqZUVHZlNCYmRPQVNpVGt4cWMzMzhwTFpCSEJUM09i?=
 =?utf-8?B?dk5DaEwyQi9VU3RXNytYTnpsOGRSQXUvVGEyZGdYamJvNnJNbmdxQm9ISmNC?=
 =?utf-8?B?UWFEMnNGT0RoSDNhMFc5MWZNWDFaMGpMWXp2a3JBeHBiZzNkK3MxNDVIangr?=
 =?utf-8?B?cVdwelY4TkNYamplWExJTzRzYkZMcnkrU0dTa0t2OWlxWGZpSXRmRVJITHVx?=
 =?utf-8?B?N2d2aFEwZUtUTFZ5cWV3YkpWU0w5UXRwTWczVFVtNjJjN3B3RnlWc1Z4citI?=
 =?utf-8?B?cHFqdnRLbThBVmZuYjFmWmNkVXYyaTBpZE16amFiVTAzUzFwWHhhZm5XSG4v?=
 =?utf-8?B?b1NIWVNYZVJIVVVKSXNyaFU4UGJ3M2VFdnl6aEZPVE5OWG9CSGJTam5uanY1?=
 =?utf-8?B?YUFqU2dqMGU1YlJ0blE3ZGxvZURldWVMSm9MdnU1b0x6K2NlL2NyMjRrRjVl?=
 =?utf-8?B?cTFhUW9mRGVtd0NvMWFqTFc1RmhycEdiWVN0Z0h5MVdxWGRoZ3crSDZzeWV1?=
 =?utf-8?Q?bHcFGZz5fjON8mvTUJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e5a9bd-21d6-457f-67ab-08da390dffa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 20:35:51.2200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yRU+8RYQnHz2F4x4fnQXIk93EmQ8q48Dl7O2UR3QBxebEr34fgxa8c2CD/NcUnu18QkMNrd6NLg09UbaE94MBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3575
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIE1hcmMsDQoNCi0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBNYXJjIE9yciA8bWFyY29yckBnb29nbGUuY29t
PiANClNlbnQ6IFdlZG5lc2RheSwgTWF5IDE4LCAyMDIyIDM6MjEgUE0NClRvOiBLYWxyYSwgQXNo
aXNoIDxBc2hpc2guS2FscmFAYW1kLmNvbT4NCkNjOiB4ODYgPHg4NkBrZXJuZWwub3JnPjsgTEtN
TCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IGt2bSBsaXN0IDxrdm1Admdlci5rZXJu
ZWwub3JnPjsgbGludXgtY29jb0BsaXN0cy5saW51eC5kZXY7IGxpbnV4LW1tQGt2YWNrLm9yZzsg
TGludXggQ3J5cHRvIE1haWxpbmcgTGlzdCA8bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZz47
IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPjsgSW5nbyBNb2xuYXIgPG1pbmdv
QHJlZGhhdC5jb20+OyBKb2VyZyBSb2VkZWwgPGpyb2VkZWxAc3VzZS5kZT47IExlbmRhY2t5LCBU
aG9tYXMgPFRob21hcy5MZW5kYWNreUBhbWQuY29tPjsgSC4gUGV0ZXIgQW52aW4gPGhwYUB6eXRv
ci5jb20+OyBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPjsgUGFvbG8gQm9uemluaSA8
cGJvbnppbmlAcmVkaGF0LmNvbT47IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUu
Y29tPjsgVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVkaGF0LmNvbT47IFdhbnBlbmcgTGkg
PHdhbnBlbmdsaUB0ZW5jZW50LmNvbT47IEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29nbGUuY29t
PjsgQW5keSBMdXRvbWlyc2tpIDxsdXRvQGtlcm5lbC5vcmc+OyBEYXZlIEhhbnNlbiA8ZGF2ZS5o
YW5zZW5AbGludXguaW50ZWwuY29tPjsgU2VyZ2lvIExvcGV6IDxzbHBAcmVkaGF0LmNvbT47IFBl
dGVyIEdvbmRhIDxwZ29uZGFAZ29vZ2xlLmNvbT47IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5m
cmFkZWFkLm9yZz47IFNyaW5pdmFzIFBhbmRydXZhZGEgPHNyaW5pdmFzLnBhbmRydXZhZGFAbGlu
dXguaW50ZWwuY29tPjsgRGF2aWQgUmllbnRqZXMgPHJpZW50amVzQGdvb2dsZS5jb20+OyBEb3Yg
TXVyaWsgPGRvdm11cmlrQGxpbnV4LmlibS5jb20+OyBUb2JpbiBGZWxkbWFuLUZpdHp0aHVtIDx0
b2JpbkBpYm0uY29tPjsgQm9yaXNsYXYgUGV0a292IDxicEBhbGllbjguZGU+OyBSb3RoLCBNaWNo
YWVsIDxNaWNoYWVsLlJvdGhAYW1kLmNvbT47IFZsYXN0aW1pbCBCYWJrYSA8dmJhYmthQHN1c2Uu
Y3o+OyBLaXJpbGwgQSAuIFNodXRlbW92IDxraXJpbGxAc2h1dGVtb3YubmFtZT47IEFuZGkgS2xl
ZW4gPGFrQGxpbnV4LmludGVsLmNvbT47IFRvbnkgTHVjayA8dG9ueS5sdWNrQGludGVsLmNvbT47
IFNhdGh5YW5hcmF5YW5hbiBLdXBwdXN3YW15IDxzYXRoeWFuYXJheWFuYW4ua3VwcHVzd2FteUBs
aW51eC5pbnRlbC5jb20+OyBBbHBlciBHdW4gPGFscGVyZ3VuQGdvb2dsZS5jb20+DQpTdWJqZWN0
OiBSZTogW1BBVENIIFBhcnQyIHY1IDI3LzQ1XSBLVk06IFNWTTogQWRkIEtWTV9TRVZfU05QX0xB
VU5DSF9GSU5JU0ggY29tbWFuZA0KDQo+IEBAIC0yMzY0LDE2ICsyNDY3LDI5IEBAIHN0YXRpYyB2
b2lkIHNldl9mbHVzaF9ndWVzdF9tZW1vcnkoc3RydWN0IA0KPiB2Y3B1X3N2bSAqc3ZtLCB2b2lk
ICp2YSwgIHZvaWQgc2V2X2ZyZWVfdmNwdShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpICB7DQo+ICAg
ICAgICAgc3RydWN0IHZjcHVfc3ZtICpzdm07DQo+ICsgICAgICAgdTY0IHBmbjsNCj4NCj4gICAg
ICAgICBpZiAoIXNldl9lc19ndWVzdCh2Y3B1LT5rdm0pKQ0KPiAgICAgICAgICAgICAgICAgcmV0
dXJuOw0KPg0KPiAgICAgICAgIHN2bSA9IHRvX3N2bSh2Y3B1KTsNCj4gKyAgICAgICBwZm4gPSBf
X3BhKHN2bS0+dm1zYSkgPj4gUEFHRV9TSElGVDsNCj4NCj4gICAgICAgICBpZiAodmNwdS0+YXJj
aC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQpDQo+ICAgICAgICAgICAgICAgICBzZXZfZmx1c2hfZ3Vl
c3RfbWVtb3J5KHN2bSwgc3ZtLT52bXNhLCBQQUdFX1NJWkUpOw0KPiArDQo+ICsgICAgICAgLyoN
Cj4gKyAgICAgICAgKiBJZiBpdHMgYW4gU05QIGd1ZXN0LCB0aGVuIFZNU0Egd2FzIGFkZGVkIGlu
IHRoZSBSTVAgZW50cnkgYXMNCj4gKyAgICAgICAgKiBhIGd1ZXN0IG93bmVkIHBhZ2UuIFRyYW5z
aXRpb24gdGhlIHBhZ2UgdG8gaHlwZXJpdm9zciBzdGF0ZQ0KPiArICAgICAgICAqIGJlZm9yZSBy
ZWxlYXNpbmcgaXQgYmFjayB0byB0aGUgc3lzdGVtLg0KPiArICAgICAgICAqLw0KPiArICAgICAg
IGlmIChzZXZfc25wX2d1ZXN0KHZjcHUtPmt2bSkgJiYNCj4gKyAgICAgICAgICAgaG9zdF9ybXBf
bWFrZV9zaGFyZWQocGZuLCBQR19MRVZFTF80SywgZmFsc2UpKQ0KPiArICAgICAgICAgICAgICAg
Z290byBza2lwX3Ztc2FfZnJlZTsNCj4gKw0KPiAgICAgICAgIF9fZnJlZV9wYWdlKHZpcnRfdG9f
cGFnZShzdm0tPnZtc2EpKTsNCj4NCj4gK3NraXBfdm1zYV9mcmVlOg0KPiAgICAgICAgIGlmIChz
dm0tPmdoY2Jfc2FfZnJlZSkNCj4gICAgICAgICAgICAgICAgIGtmcmVlKHN2bS0+Z2hjYl9zYSk7
DQo+ICB9DQoNCj5IaSBBc2hpc2guIFdlJ3JlIHN0aWxsIHdvcmtpbmcgd2l0aCB0aGlzIHBhdGNo
IHNldCBpbnRlcm5hbGx5LiBXZSBmb3VuZCBhIGJ1ZyB0aGF0IEkgd2FudGVkIHRvIHJlcG9ydCBp
biB0aGlzIHBhdGNoLiBBYm92ZSwgd2UgbmVlZCB0byBmbHVzaCB0aGUgVk1TQSBwYWdlLCBgc3Zt
LT52bXNhYCwgX2FmdGVyXyB3ZSBjYWxsIGBob3N0X3JtcF9tYWtlX3NoYXJlZCgpYCB0byBtYXJr
IHRoZSBwYWdlIGlzIHNoYXJlZC4gPk90aGVyd2lzZSwgdGhlIGhvc3QgZ2V0cyBhbiBSTVAgdmlv
bGF0aW9uIHdoZW4gaXQgdHJpZXMgdG8gZmx1c2ggdGhlIGd1ZXN0LW93bmVkIFZNU0EgcGFnZS4N
Cg0KPlRoZSBidWcgd2FzIHNpbGVudCwgYXQgbGVhc3Qgb24gb3VyIE1pbGFuIHBsYXRmb3Jtcywg
YmVmIHJlbw0KPmQ0NTgyOWIzNTFlZTYgKCJLVk06IFNWTTogRmx1c2ggd2hlbiBmcmVlaW5nIGVu
Y3J5cHRlZCBwYWdlcyBldmVuIG9uIFNNRV9DT0hFUkVOVCBDUFVzIiksIGJlY2F1c2UgdGhlIGBz
ZXZfZmx1c2hfZ3Vlc3RfbWVtb3J5KClgIGhlbHBlciB3YXMgYSBub29wIG9uIHBsYXRmb3JtcyB3
aXRoIHRoZSBTTUVfQ09IRVJFTlQgZmVhdHVyZS4gSG93ZXZlciwgYWZ0ZXIgZDQ1ODI5YjM1MWVl
Niwgd2UgPnVuY29uZGl0aW9uYWxseSBkbyB0aGUgZmx1c2ggdG8ga2VlcCB0aGUgSU8gYWRkcmVz
cyBzcGFjZSBjb2hlcmVudC4gQW5kIHRoZW4gd2UgaGl0IHRoaXMgYnVnLg0KDQpZZXMgSSBoYXZl
IGFscmVhZHkgaGl0IHRoaXMgYnVnIGFuZCBhZGRlZCBhIGZpeCBhcyBiZWxvdzoNCg0KY29tbWl0
IDk0NGZiYTM4Y2JkM2JhZjFlY2U3NjE5NzYzMGJkNDVlODMwODlmMTQNCkF1dGhvcjogQXNoaXNo
IEthbHJhIDxhc2hpc2gua2FscmFAYW1kLmNvbT4NCkRhdGU6ICAgVHVlIE1heSAzIDE0OjMzOjI5
IDIwMjIgKzAwMDANCg0KICAgIEtWTTogU1ZNOiBGaXggVk1TQSBmbHVzaCBmb3IgYW4gU05QIGd1
ZXN0Lg0KICAgIA0KICAgIElmIGl0cyBhbiBTTlAgZ3Vlc3QsIHRoZW4gVk1TQSB3YXMgYWRkZWQg
aW4gdGhlIFJNUCBlbnRyeSBhcw0KICAgIGEgZ3Vlc3Qgb3duZWQgcGFnZSBhbmQgYWxzbyByZW1v
dmVkIGZyb20gdGhlIGtlcm5lbCBkaXJlY3QgbWFwDQogICAgc28gZmx1c2ggaXQgbGF0ZXIgYWZ0
ZXIgaXQgaXMgdHJhbnNpdGlvbmVkIGJhY2sgdG8gaHlwZXJ2aXNvcg0KICAgIHN0YXRlIGFuZCBy
ZXN0b3JlZCBpbiB0aGUgZGlyZWN0IG1hcC4NCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBBc2hp
c2ggS2FscmEgPGFzaGlzaC5rYWxyYUBhbWQuY29tPg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL3N2bS9zZXYuYyBiL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMNCmluZGV4IGNjN2MzNGQ4YjBk
Yi4uMGY3NzJhMGYxZDM1IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zZXYuYw0KKysr
IGIvYXJjaC94ODYva3ZtL3N2bS9zZXYuYw0KQEAgLTI4NDAsMjcgKzI4NDAsMjMgQEAgdm9pZCBz
ZXZfZnJlZV92Y3B1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiANCiAgICAgICAgc3ZtID0gdG9f
c3ZtKHZjcHUpOw0KIA0KLSAgICAgICBpZiAodmNwdS0+YXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0
ZWQpDQotICAgICAgICAgICAgICAgc2V2X2ZsdXNoX2VuY3J5cHRlZF9wYWdlKHZjcHUsIHN2bS0+
c2V2X2VzLnZtc2EpOw0KLQ0KICAgICAgICAvKg0KICAgICAgICAgKiBJZiBpdHMgYW4gU05QIGd1
ZXN0LCB0aGVuIFZNU0Egd2FzIGFkZGVkIGluIHRoZSBSTVAgZW50cnkgYXMNCiAgICAgICAgICog
YSBndWVzdCBvd25lZCBwYWdlLiBUcmFuc2l0aW9uIHRoZSBwYWdlIHRvIGh5cGVyaXZvc3Igc3Rh
dGUNCiAgICAgICAgICogYmVmb3JlIHJlbGVhc2luZyBpdCBiYWNrIHRvIHRoZSBzeXN0ZW0uDQor
ICAgICAgICAqIEFsc28gdGhlIHBhZ2UgaXMgcmVtb3ZlZCBmcm9tIHRoZSBrZXJuZWwgZGlyZWN0
IG1hcCwgc28gZmx1c2ggaXQNCisgICAgICAgICogbGF0ZXIgYWZ0ZXIgaXQgaXMgdHJhbnNpdGlv
bmVkIGJhY2sgdG8gaHlwZXJ2aXNvciBzdGF0ZSBhbmQNCisgICAgICAgICogcmVzdG9yZWQgaW4g
dGhlIGRpcmVjdCBtYXAuDQogICAgICAgICAqLw0KICAgICAgICBpZiAoc2V2X3NucF9ndWVzdCh2
Y3B1LT5rdm0pKSB7DQogICAgICAgICAgICAgICAgdTY0IHBmbiA9IF9fcGEoc3ZtLT5zZXZfZXMu
dm1zYSkgPj4gUEFHRV9TSElGVDsNCiAgICAgICAgICAgICAgICBpZiAoaG9zdF9ybXBfbWFrZV9z
aGFyZWQocGZuLCBQR19MRVZFTF80SywgZmFsc2UpKQ0KICAgICAgICAgICAgICAgICAgICAgICAg
Z290byBza2lwX3Ztc2FfZnJlZTsNCiAgICAgICAgfQ0KIA0KKyAgICAgICBpZiAodmNwdS0+YXJj
aC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQpDQorICAgICAgICAgICAgICAgc2V2X2ZsdXNoX2VuY3J5
cHRlZF9wYWdlKHZjcHUsIHN2bS0+c2V2X2VzLnZtc2EpOw0KKw0KICAgICAgICBfX2ZyZWVfcGFn
ZSh2aXJ0X3RvX3BhZ2Uoc3ZtLT5zZXZfZXMudm1zYSkpOw0KIA0KIHNraXBfdm1zYV9mcmVlOg0K
DQoNClRoaXMgd2lsbCBiZSBwYXJ0IG9mIHRoZSBuZXh0IGh5cGVydmlzb3IgcGF0Y2hlcyB3aGlj
aCB3ZSB3aWxsIGJlIHBvc3RpbmcgbmV4dC4NClRoYW5rcywNCkFzaGlzaA0K
