Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2571952F44C
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353422AbiETUOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiETUOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:14:48 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E7518540A;
        Fri, 20 May 2022 13:14:47 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KE6TpS023021;
        Fri, 20 May 2022 13:14:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=C3TpRGqlqTGiX4U6e/C0h4CqA8zhZduyIrhwuVvXgpM=;
 b=DvoRso3KH8V6sEURjv2pgluad2qgVEkYbR+6VUe+DJ/4nNhG6xrH+C1s+Os2VnnaWJ9Z
 1jMezdpa2PpwipZ39aB6TtFOozlSNJDV0Go/8hAYb9Jsuv4Tm6n6/6t0x+dKM0kpMW4s
 CzPG5gjUIfIqNtUAANPnXyGjoqdQPmCuKeIJIINGPdSo4NDRwBSAe0payYQrXWycwNdT
 uoQHJJCuso4lAb52LEeJxJvL69HNiSii1VGneMJrznWTc9Svbkct+Pl0kjR2VSDlrZJ+
 8CHGOxOvjf3sCm1Pem5QEV6g1LXw4KjBRCaKsWlifj+WAn86iocMeCtlL7UMFJfFZcLp 6w== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3g2brhx6re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 13:14:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDh2TeeY4QbHdlhI1CwSgUUcbviQn8i9r1cUBTSrHNhacfb5Bsjr3QqXAZ9q4FWPp6yn3Q/RVO9G6BuEfzdvdAZ7SONiddi6x8SFZ+gwq0o5fq05e6cwbhwGFDtds5gy2lV8Alxpgrp+y1LXp/SBwwECpk3oYPsRTkWYAZV3pb5jHZ+ijTKlVwTzus5Te90NPrM/T2voH57qr3d3ZOTycjzLrLpeDyqOVvXaTEIwl5aYCItF8hbjD5BVvkpL685NWVWFZ0yMhulEmlBzXd98eDfZhdC3LyE/kWQeK5Lkvcu7/VlTARuLi80dXtZcw++TKAm4SPXUPNo0rw1z3mZnJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3TpRGqlqTGiX4U6e/C0h4CqA8zhZduyIrhwuVvXgpM=;
 b=WIBcfciOc2KJfct5Wm98L6RRkctZeBbq/XZyvlzrIHCg2N4f7oSCgeAxs5RKgxT/tEMnYtGdBUtWLHVnQDveYSig9Me0BcNnIHuY0NfcrLIbNoh6lIGuRJs8pXxkCyfW8lgazImQCEP33FB+z4kDGvzra3JZ2IipM4j7tD8pbzQ1rdXdyRfjqlBv/IX70l795Ce3LOqdMC5hfspHA2titIucv1NAOCgLX+rg5mmpxiEf+emRIfTY9l1vbdSAlIM3qJDY/Yvpycofdibs8dUrkl7L85n9fx+NCnV3YlYAth21aqsvP03bxpX8qI0bXA5pg87FsX33lqBfiaAYI9xMug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN7PR02MB5043.namprd02.prod.outlook.com (2603:10b6:408:21::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 20:14:01 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 20:14:01 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Topic: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Index: AQHYZigD50jTp0T7q026slKeRH2Mca0j5MwAgADUdACAA4GpgIAAAt6AgAACMQA=
Date:   Fri, 20 May 2022 20:14:01 +0000
Message-ID: <13E3F717-2938-430F-BA8B-70DD87962344@nutanix.com>
References: <20220512174427.3608-1-jon@nutanix.com>
 <YoRPDp/3jfDUE529@google.com>
 <29CDF294-5394-47C7-8B50-5F1FC101891C@nutanix.com>
 <732266F9-9904-434A-857F-847203901A0C@nutanix.com>
 <Yof0sSy/xKrCY5ke@google.com>
In-Reply-To: <Yof0sSy/xKrCY5ke@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a82b30c-b819-44a3-2c25-08da3a9d4798
x-ms-traffictypediagnostic: BN7PR02MB5043:EE_
x-microsoft-antispam-prvs: <BN7PR02MB5043AC607B17C9582D577FD1AFD39@BN7PR02MB5043.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RyIVLeWrRf1j2/vDrHB8XwF+KKACH2RTRFrgQAhCbuYqqmjIWpdtV9Zb5Byofg60VOUwZMlsiLULT9gpgEelRIvV3Qs+szAJCEwG2iM/VfGf6yBDWGa1joa7+RDSSZqcU51PXRTnYqVutAz73rU1pAmUz+P/LyS1SqJzNHirEUNLNBZ/UXgA+MURNYF9DqqekaZBTZtpxAI7y5cjQNz7efXE+a3gco/0IM2C7gzKP6951uX9x47XtHs8ndKm4ANej6MQz7GsMgG7bIHYuqAzc/zYoQMWyDx0bJv16EssTR3KEaqI8Uz5NcxtZpq41wyXtMQQRQi7F1t76iVtPOMEldBBBUPN1hbAn5u5CKzlTfNzkvajNDwFKVFu7/pZ6Hp3pjQYB2embRCb5TrANZVgXBrEsCMFCJJoJPfbePovh1CG2UxGykgBCJI3zZadCnmsNmPEt1eShgJgEkG2kVvbnhHO5DCaznVToly1LGJBonsWkpqZywEf2LniLmjxEJczdIe8v/Ac3+omt3x5jTfAgmtRTL3DUlouZEuUqYVazlHZ2UFVeAGfHh7QvG+bij3b0Eu2oPQZ8Zd5dNTKJvgIppnrkQcq9Y+ZwnMJ/ZCdzB+XOrhdfjkO47OS0mdsd4e9+TZaGcEUCpMp2TRkwC2u57rzZD/4d5NyhHnp32NrIDeVUuxkKzuz4GFq2sV9veSJTdfnNEqOyB1bCZRvM5eSZdr+f/rwqbGtBf2sH1bdEp1vjKOQCKmrWot9o2fM2wWa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(2616005)(6506007)(38070700005)(7416002)(4326008)(5660300002)(38100700002)(54906003)(6916009)(2906002)(53546011)(316002)(76116006)(86362001)(66556008)(66446008)(122000001)(91956017)(186003)(8676002)(66476007)(64756008)(66946007)(83380400001)(33656002)(8936002)(36756003)(508600001)(6486002)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGlzTGtBK0MwNG1YVzNCbFB2aUVPUjdmbGg1M0hYVyt5ZVZ1ZE5sWXNycm5O?=
 =?utf-8?B?VVdSRDM4clYvR3c4eUE4RXBNd3ZzUzU5NTN1MTRzU0pHOGZ0WjFzTHRtdnRE?=
 =?utf-8?B?UE15UFB0ekN1c0VPeDIrRnZRWUhOUmJKUFFYZWRROFpGbmtUWDAza2daaFRu?=
 =?utf-8?B?TDFXN21QWFUvd1Uvd2RyMjJVZVVoUlVvYU9IcGUzU05PbE9zbGFXL0d3NDFm?=
 =?utf-8?B?ZGlmblhqTFN1RGUzY2lxZXp2Q09xY1RWUjl5OC9IUjBwb1ZOVTRobjM3U05s?=
 =?utf-8?B?WEZaemgzN1dzYVpZa1RWNzhDcVZhR2Z3eWppK0lWOFkycEIxblBteGYrVlFt?=
 =?utf-8?B?a2xmdDEySVBUdmY5SlhjRGpaamdUNlAxa0lOa1U3K21adVdKYlFGbndLTk1U?=
 =?utf-8?B?bmFsbHc2UllqY3pRMEdjNlRuRTRvcW13aVlCM1ZDQmI5aGdMWVN6ZVJrbVB5?=
 =?utf-8?B?NHZsTGpsN0tyVG1UdWhnREdyQ0wrT1JlRjg2T2RNWmVkMWlsbzhXNkxMaWZz?=
 =?utf-8?B?R0FpY0Y2UUZWQ1haMm9UNDZwMnova0NyclpYNVVKNWFyYlJRaVg2NGcyMjhp?=
 =?utf-8?B?SzFlNXY2ZXFWTE9ZY29YTEU2dFBDVzBYRFBHcmVaRlVNc29mOTFZNkE5SWxt?=
 =?utf-8?B?U3V2YmdNUmJPSHg1ejY0WlRxNGg2OTJ1T3pFdkRMNTNrZ2FVWmpRK0VMeXpw?=
 =?utf-8?B?aFoxLzBxWEluelFsR3RnanpJdEg5WkhxQU84NlY2aVdteit0T2IzemVFZHNB?=
 =?utf-8?B?U0E4NC93Uys2TWRmdTRFUk41a3dONGpGNUpVcHl6UFVraW5zNVk5NjBkaklT?=
 =?utf-8?B?b1FLZ3pPSVlRcjNiZ1hOT0J1V3UvMDZvbGFld0JEZmp6akpjZ0dJWXFhQXE2?=
 =?utf-8?B?MjV4VURXcjZ3dVpKSW9yZVZXSW9nRFhheVFjSFdJdldUbElMc293MlY0dm1v?=
 =?utf-8?B?TFR6dmtXNEFDT0hiRmxYTVpqK3BsVm40R245ZTlOZG9lNFdhOFhJS2M3RVlv?=
 =?utf-8?B?djZ3YmRhNXB4aVBGdk4zaG9RSGxldXhsVE5tQUJxREIwb1loNHc2ZjhHUDZZ?=
 =?utf-8?B?LzV2b285SkxDRXhoOWMyUG84VEhhSml0SytiSUZ0SkFOZG5Hd25JZSswaHlF?=
 =?utf-8?B?M1QxTUdVdWZQakVRRUtSejNpb2RmRzdwTFd4bGVGVTI2QTBvZmtaN05KQ2pY?=
 =?utf-8?B?L2NKZXJnQzN0czJkN0JHUkF2alFMbFQwT2IvNTZLZUYvRzBnT2VIUUtoL3ds?=
 =?utf-8?B?K05Ib1c5cytrcGVkUXJYa0RZSCtPRHl1NVlTcFdEOVVrcFpDOVJFYzB1Y3ZB?=
 =?utf-8?B?RVdHRkt4TnBMY1hJSTE4Mit4TVlCZ21NdnZsdEdkOEN4UkU0Rit6bThybUVC?=
 =?utf-8?B?SVNBc09tK0hsbVJiczQrdVo3eEZzTkl5RXF2MlF0Y0kwY0pzSDVqemFFaHB4?=
 =?utf-8?B?T1QyZnU1cVk0UUt0cXlmZE5vaDRiMzJkb1pIczd0OElac1BXRmRCdURzc1Jx?=
 =?utf-8?B?QjZJQnBKV0JmNTRYOFI0aVdsSTE2ZjJZRXVnMDUzaDNGR21OUmdDbWhlcjU2?=
 =?utf-8?B?R0xwa1AyVm9BTExmemsvdms2c1dVTmg0V2VqRVFPenFyQjZuQVZ4ajR4bHFq?=
 =?utf-8?B?dUp2cDZoYnBYUUVMdFl5Tlg3bFo5UEpDa09WV056SEZvVHFneFZoLytvRWs5?=
 =?utf-8?B?L1hFYmRSekZqVk8zd3dDRnBTMFRBb2gxOWRHYUR4SnM4YmJ5OC9obWJHL2wz?=
 =?utf-8?B?Yk56MmVvdGdtZDVlM3lvdS8ySjd4RUdmaitVTy9ZeFB3eVJvdDF6bGl2YVdw?=
 =?utf-8?B?WDg5bis0c2V2RlRmZU1aQmhqRklmL0xUenRncGw0dFd5SmtzcmZ6QXJ5c3pY?=
 =?utf-8?B?Tm9ESndvM0daVWhlZSt5OTVoYzRkVjY1R05wTE5rZlo3bWNzRkJPeVFkTndj?=
 =?utf-8?B?aTdaaUZxVUxmZjQrTG53bzcydElFL3FvZDM1VDA2NXBxL05UdStsSFRKSytz?=
 =?utf-8?B?ZGROaWFSbWZ5d1Y1TWRBR2tvS1EwSDF5L09VZFB2UXVtMWlVblpMNTE4VFFZ?=
 =?utf-8?B?aFRPNUxUY3A0NUxGRWdsQ2NydWpFOXJoc2hPay9pREdsSzkxQitOUUl1amo5?=
 =?utf-8?B?SlUyN0ZZRitPdlVKaFgwVW1MTEZLYVpQdmR5TS85dnZhNTdNRnRSVXZ0QXZz?=
 =?utf-8?B?ZmgrS3F5UjdFbnZiVVBKcU90dE5yUzlWcnhoU2VtU1gvTWd3N01scE9GMzcz?=
 =?utf-8?B?Q3lyMndzekFrWGZOS1FTTWtZd0ZRY0FqNHJlS2w0L1lvclBLdW1QYldKVllo?=
 =?utf-8?B?eGlpWVZEaWNkU2dEZjNMTGJld2JqK1piNTdZUXdxSjV2WG5uUGhWZ2JvWTF5?=
 =?utf-8?Q?+9uABAyi0bhv3IiqbbNBbbI1ib6drZnM0j5gSfFKfIx00?=
x-ms-exchange-antispam-messagedata-1: zeWHVKaL12OzieJ7lKXjT3IJrEbs5/vYz24yBmnw5Q8BUb3G5qK1Mx3J
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A8652C40A6C2F42B869AA09D8F45077@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a82b30c-b819-44a3-2c25-08da3a9d4798
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 20:14:01.1153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /NIsAetydT3ptLBUSKoIj0os6Q/Lp/tARSAvZovYp+KIaPk5Nay9QR14C8E57pUGNVT57/nx7yIhzQkUHjQNgJ5T9AhEJ6UUgCJ4Q16ZFgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5043
X-Proofpoint-ORIG-GUID: KTUbqfUK5EFbSSsoceES6hIXxc9Wmw7y
X-Proofpoint-GUID: KTUbqfUK5EFbSSsoceES6hIXxc9Wmw7y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDIwLCAyMDIyLCBhdCA0OjA2IFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIE1heSAyMCwgMjAyMiwgSm9u
IEtvaGxlciB3cm90ZToNCj4+IA0KPj4+IE9uIE1heSAxOCwgMjAyMiwgYXQgMTA6MjMgQU0sIEpv
biBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4+IE9uIE1heSAxNywg
MjAyMiwgYXQgOTo0MiBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+
IHdyb3RlOg0KPj4+Pj4gKwkJaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9JQlJTX0VOSEFO
Q0VEKSAmJiBkYXRhID09IEJJVCgwKSkgew0KPj4+PiANCj4+Pj4gVXNlIFNQRUNfQ1RSTF9JQlJT
IGluc3RlYWQgb2Ygb3BlbiBjb2RpbmcgIkJJVCgwKSIsIHRoZW4gYSBjaHVuayBvZiB0aGUgY29t
bWVudA0KPj4+PiBnb2VzIGF3YXkuDQo+Pj4+IA0KPj4+Pj4gKwkJCXZteC0+c3BlY19jdHJsID0g
ZGF0YTsNCj4+Pj4+ICsJCQlicmVhazsNCj4+Pj4+ICsJCX0NCj4+Pj4gDQo+Pj4+IFRoZXJlJ3Mg
bm8gbmVlZCBmb3IgYSBzZXBhcmF0ZSBpZiBzdGF0ZW1lbnQuICBBbmQgdGhlIGJvb3RfY3B1X2hh
cygpIGNoZWNrIGNhbg0KPj4+PiBiZSBkcm9wcGVkLCBrdm1fc3BlY19jdHJsX3Rlc3RfdmFsdWUo
KSBoYXMgYWxyZWFkeSB2ZXJpZmllZCB0aGUgYml0IGlzIHdyaXRhYmxlDQo+Pj4+ICh1bmxlc3Mg
eW91J3JlIHdvcnJpZWQgYWJvdXQgYml0IDAgYmVpbmcgdXNlZCBmb3Igc29tZXRoaW5nIGVsc2U/
KQ0KPj4gDQo+PiBJIHdhcyAoYW5kIGFtKSB3b3JyaWVkIGFib3V0IG1pc2JlaGF2aW5nIGd1ZXN0
cyBvbiBwcmUtZUlCUlMgc3lzdGVtcyBzcGFtbWluZyBJQlJTDQo+PiBNU1IsIHdoaWNoIHdlIHdv
dWxkbuKAmXQgYmUgYWJsZSB0byBzZWUgdG9kYXkuIEludGVs4oCZcyBndWlkYW5jZSBmb3IgZUlC
UlMgaGFzIGxvbmcgYmVlbg0KPj4gc2V0IGl0IG9uY2UgYW5kIGJlIGRvbmUgd2l0aCBpdCwgc28g
YW55IGVJQlJTIGF3YXJlIGd1ZXN0IHNob3VsZCBiZWhhdmUgbmljZWx5IHdpdGggdGhhdC4NCj4+
IFRoYXQgbGltaXRzIHRoZSBibGFzdCByYWRpdXMgYSBiaXQgaGVyZS4NCj4gDQo+IFRoZW4gY2hl
Y2sgdGhlIGd1ZXN0IGNhcGFiaWxpdGllcywgbm90IHRoZSBob3N0IGZsYWcuDQo+IA0KPiAJaWYg
KGRhdGEgPT0gU1BFQ19DVFJMX0lCUlMgJiYNCj4gCSAgICAodmNwdS0+YXJjaC5hcmNoX2NhcGFi
aWxpdGllcyAmIEFSQ0hfQ0FQX0lCUlNfQUxMKSkNCg0KU28gSSBvcmlnaW5hbGx5IGRpZCB0aGF0
IGluIG15IGZpcnN0IGludGVybmFsIHBhdGNoOyBob3dldmVyLCB0aGUgY29kZSB5b3Ugd3JvdGUg
aXMNCmVmZmVjdGl2ZWx5IHRoZSBjb2RlIEkgd3JvdGUsIGJlY2F1c2UgY3B1X3NldF9idWdfYml0
cygpIGFscmVhZHkgZG9lcyB0aGF0IGV4YWN0DQpzYW1lIHRoaW5nIHdoZW4gaXQgc2V0cyB1cCBY
ODZfRkVBVFVSRV9JQlJTX0VOSEFOQ0VELiANCg0KSXMgdGhlIGJvb3QgY3B1IGNoZWNrIG1vcmUg
ZXhwZW5zaXZlIHRoYW4gY2hlY2tpbmcgdGhlIHZDUFUgcGVyaGFwcz8gT3RoZXJ3aXNlLA0KY2hl
Y2tpbmcgWDg2X0ZFQVRVUkVfSUJSU19FTkhBTkNFRCBzZWVtZWQgbGlrZSBpdCBtaWdodCBiZSBl
YXNpZXINCnVuZGVyc3RhbmQgZm9yIGZ1dHVyZSBvbmxvb2tlcnMsIGFzIHRoYXRzIHdoYXQgdGhl
IHJlc3Qgb2YgdGhlIGtlcm5lbCBrZXlzIG9mZiBvZg0Kd2hlbiBjaGVja2luZyBmb3IgZUlCUlMg
KGUuZy4gaW4gYnVncy5jIGV0YykuIA0KDQo+PiBTZW50IG91dCB0aGUgdjIganVzdCBub3cgd2l0
aCBhIGZldyBtaW5vciB0d2Vha3MsIG9ubHkgbm90YWJsZSBvbmUgd2FzIGtlZXBpbmcNCj4+IHRo
ZSBib290IGNwdSBjaGVjayBhbmQgc21hbGwgdHdlYWtzIHRvIGNvbW1lbnRzIGhlcmUgYW5kIHRo
ZXJlIHRvIHN1aXQuDQo+IA0KPiBJbiB0aGUgZnV0dXJlLCBnaXZlIHJldmlld2VycyBhIGJpdCBv
ZiB0aW1lIHRvIHJlc3BvbmQgdG8gYSBjb250ZW50ZWQgcG9pbnQgYmVmb3JlDQo+IHNlbmRpbmcg
b3V0IHRoZSBuZXh0IHJldmlzaW9uLCBlLmcuIHlvdSBjb3VsZCBoYXZlIGF2b2lkZWQgdjMgOi0p
DQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrL2NvYWNoaW5nLiBTdGlsbCBnZXR0aW5nIG15IGxl
Z3MgdW5kZXIgbWUgZm9yIExLTUwsIEkNCmFwcHJlY2lhdGUgdGhlIGtpbmRuZXNzLCB0aGFuayB5
b3UhDQoNCg==
