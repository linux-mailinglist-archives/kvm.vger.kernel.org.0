Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197AA51B4A3
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 02:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiEEAba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 20:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiEEAb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 20:31:29 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7081C396A9;
        Wed,  4 May 2022 17:27:51 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244Nxbh7002787;
        Wed, 4 May 2022 17:27:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=nKiqFk1NFS1OJolykA7rdwrXVwjk7s0w2Qs0VbXl8Dg=;
 b=kqCgZ/85RHJTr1Irb++yTkYxDu5dVoWLejhHAAI4ZCs/564g/q6ERCWXOklz5/y03wBv
 r4KdGk8fGcpaeh9bn+3E8FInZczUpeUFYbjq3Q5kf/VvqQbwtUAM/RZoluilpK+HH32Y
 rBP3Kg56ustSZ7zGsZXTpFbfi3G6II06FvRpFn00IOX0zgI9BmSvBt2xrtGRt0Cp3AJV
 An2kosgPv4XnbiXlsatxukN5Er7qtQ2Pyw+7CFwR2E3bXp1E2hdhwtDFFULC272BWQgy
 zPM67EhTLcJyJsppMPbFI8S+5lzKyMg0blGgsMJNEgvRziFMjxUEd50YL3V7hxXtJHjI tg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fs4ny138d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 May 2022 17:27:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Otrcw0oTt9fxkKO7Xvx1kKesd669DMRtobTC1OGqRnqsYPgQ61ypTILes1H5jgr1AvTnm0c1eBT8dp6SmBOQFOE8i1Fw88bfVs+kNSoemFSbm2FPc78hRemk/kf5EFkEBSc0FLKi5vby0uTy9vUV8QOuAivqCiv4auVYQQ9yC40t+v74AAFK0ItqnZiMdk3+v3YtL0lXQu8iq9FGY3tJgs6bFa5a/Iq1UjIpyy9mgSEGdVzdGuHau+w6qy1O7AquJJXo1Fwh564mp8ttV7X43wER6LV/ijqIv3yJnlYOm+Gpiog4S/Nu/HbQ52n2yDeEP8i6Pn0zk9MNK01t/P3kyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKiqFk1NFS1OJolykA7rdwrXVwjk7s0w2Qs0VbXl8Dg=;
 b=bvMpwEWQNpHfCoEV72EFpr0tXD+lNUN64HLqYLFjGDL1bhHb/5P/xYJIUua+0v6Q0+La9l7vj5pbAWrEUkX50b/vGcO1ivDw56OL9Cek/VINXD16ZAQcULqjmp1zyXc0y7l8iYDWDjZZOLAvXfIHwOL9d3Bp6fLUtqXPHZR4Ae4VgoCE8/FwHZvRXQ3q6l8hNF6EXtuOnlPm9TbEjgT10epGFrGX5touOu6HUw9QkpwWOm4MOK72OApNZrmrvBJqG/D0rJYJetMkG0ro0HDNign4MPDq8Up2rBCzZTBnt9xzvUgVaKB0cQSo5gHmUUUMytsGTmTiDCiQMhv6O/Oe2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM6PR02MB5611.namprd02.prod.outlook.com (2603:10b6:5:7f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Thu, 5 May
 2022 00:26:58 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 00:26:58 +0000
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
Thread-Topic: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
Thread-Index: AQHYX+SdgNMP1X+6KkawcgehKjrXJq0PQWOAgAAse4A=
Date:   Thu, 5 May 2022 00:26:58 +0000
Message-ID: <8E192C0D-512C-4030-9EBE-C0D6029111FE@nutanix.com>
References: <20220504182707.680-1-jon@nutanix.com>
 <YnL0gUcUq5MbWvdH@google.com>
In-Reply-To: <YnL0gUcUq5MbWvdH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40c2f2b0-c66e-44f7-89c6-08da2e2df745
x-ms-traffictypediagnostic: DM6PR02MB5611:EE_
x-microsoft-antispam-prvs: <DM6PR02MB561125B7640EFF2F173A18ECAFC29@DM6PR02MB5611.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DPgawNitCWRdb0W2LxoNJ6K7Yhx2TqgVXbo7WMKioJIJUuHFIJVdUx4SADoFeI8G6h3yPgYmtnUHP3AaSsuxfvpcAb50/8vl8kjnuYUozr3YiOBXqIGWB1d5x/6EvF8dTzHvYPUqV8JeBpqU94R3gDctUm5fAMJieJiPcHaSAed/EPA5Gyw8UQvdCW1VoBtOiSzRwV5njd+ak+oD0jR2HSuG35z4ovXwzMxHUMvrxvJ6ucEwwVHKeSGOdMtAfj0Uxemia7Xq1j7GnmxB5EuXoNoxa+4Sfv/eudrHFKbU5eL+PIR6jy65m2s2ggk8cW8TIS+3VhfvG1h5VOnFPkjGPQfBV0yFznpg0nOFWES/JfjHmeupll5oBy+wCBGl4TOktUB7AU9N2CpEfgrnalEIinkpawqiHrDY7B/N3vv9Y85h0UQYeX100iFU28ag+ZN7RmclxxY2mdHCNLTilCx1p5RqnpNs+k7piPx8LSD+ADTLfwbcXqY7urIt7Sb4kklZfS5PH4SHKm4bD7EYFe/+fX21LGLE+gVS3wCSTqZrIpfc6iF2QIls0pxRYiPp42/NbQPpszUFCbXXz80JSi+dSN5inZRHCPWeOGUx5fg0yhNnN/9Z3ftthSnaB9iv974AU5YURhwIwQPwKKp1GEIBFI4Rz/JyN7Y4ej3zyGkAHVvjMXnvdH96tqmTTjbYTDCZj/2/18FLWoZpzvYmyifATJryKvW0LPk1dH4eUKNypgo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(122000001)(66446008)(38100700002)(38070700005)(6512007)(8936002)(71200400001)(53546011)(2906002)(76116006)(66476007)(64756008)(6486002)(33656002)(8676002)(5660300002)(4326008)(7416002)(6506007)(66946007)(66556008)(316002)(83380400001)(54906003)(2616005)(36756003)(6916009)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzZ3QW5LckZpd2N2MldBYUNLQzZKcGw0WlBsU3Bnc082NXpTRDRMUVJkVWhi?=
 =?utf-8?B?UFRYQTJuVG82THRVZkJGa25ML1VWbk1Rbm5hemgxNE54S2RIZVNXTmg3WDhr?=
 =?utf-8?B?UXVramc4Y0dQMm1NemxTOHJQNytGVGVvL3A1ZXYzU2xIWEs1d2VZdzIycVZS?=
 =?utf-8?B?azJBUmJTc2dPcnR2THZmMjFZZFRnZytBSFV4M3NZemJVc21vWUVUcFRYaXY0?=
 =?utf-8?B?K2IxbXlCNzZsQmRrdHVtUTZGSnBuZC9mcFFyT3Z1elBrSDVWeG5wTVI3Uktv?=
 =?utf-8?B?cUhlZE5ab3Y3ZmpNbW85bk1qWXh6cHFIQkdXOFJweXZHLzN3cFVwbnRnVUdp?=
 =?utf-8?B?Y0kyS2EweWRKWGF0UVNQUCtDQTRDZUl4NGJuYkRxbG5GUDlINTRBYURTaGNC?=
 =?utf-8?B?VHozOUc4c1l1amx2S1VrRHFIYXNtQWxKQUZCbkYrcjAvcjk5UzI4eGMyTzEw?=
 =?utf-8?B?ZVkwL0FVWXdUZTM4TkhrRUZycFlrUVIxSm9tMmxOaytpSjVSWW9jdkZqUWsv?=
 =?utf-8?B?dmQweVVHSnI0ODdwUEpoK29scmI5ZTBCVXMwaWtQSGxML2Fobm5HeEJ2cGJY?=
 =?utf-8?B?Y3BOZFJCd3NlVzZmQTBRZkZlMzBHeUZNWk1qNDF5cDNvSWdWaVRRZW5Eblhj?=
 =?utf-8?B?b2JFMStubUZKZ0FhMWdYK1QvUm81UFY3eWNBSy9UQ1haTUM0d3grVHBaWEFU?=
 =?utf-8?B?eUtLTmd2UGxCSkYycTVNSldSY2VraW9Zam1ocUdoUzNjRjJ0eU1yeGpYby9r?=
 =?utf-8?B?RDBHdXo1R1pvM2hRckhHZFdmd0grNExGM21NckhwRk14VWFGNzdzQ3cwVUta?=
 =?utf-8?B?cUlSbk5vdE1VN1JZeFdCd2d2R1h6UVN5bk03bFh6TGplaWNBVlJEd3Joellt?=
 =?utf-8?B?Umd0UHM5Q1E1L2t1OGNESXppNVNTZkt3UzhvRFVhSktNU1M4Um5RcFFlWEhD?=
 =?utf-8?B?S1c4Nlk0TjNqNUZrK1VoOThaaHB3RU1OdzlGSEVXNTVEWCsyRm5zbzJFalFH?=
 =?utf-8?B?Ukd1K0VDaERnOFp0ZGZkQ2htVW9peGp4VmQzUHJRVFREdGtUcnp5K1AwWkZw?=
 =?utf-8?B?UjdJYXBheGpkSkptVS9KSFpySVduUE9ad3BlY1RnY2krRVRBTm1OMXBDM3hm?=
 =?utf-8?B?SEtRN1hwdTBIcE5sSGprdDQ0aklEazB0U3QrMmhNYVFTQmFBOUJSN2h4ZDVY?=
 =?utf-8?B?d3JRSWx2b3BEZSt4VUZETVFrZ2pEQ0FGbit5bWNFU0N2ak9ESDUrTi9hZGsz?=
 =?utf-8?B?NzdpSjhZNlllanpIVlFGNWluenNvOUI5NTZvcVBpd3RZTkZOVXZlNEVJOUpP?=
 =?utf-8?B?S2VpT0NBWWhEc2NLYlUrWWJsVWJKUzlabHd5NXdRZDQ0TXpsbzRTcC9xTEdu?=
 =?utf-8?B?NGI3ZStuWmYzUjJQS3dGR3haWjM1ZHpxU09nWWxsOVdhajJDTlEvSFVGL3Bk?=
 =?utf-8?B?WkhKSXd3MjRwUGVpMzdOS096cllnS0hsdmZUTng3VnZtcTN6anozSVVrNVJ3?=
 =?utf-8?B?ZE5vNFNldHBCSGZlRjQzU2I1ZHNxUlIwNkd6RkZrS2I1Z3pxeG9rWkNXNUlN?=
 =?utf-8?B?OXUxN1E0SCsxZHVUYXAzdzcyd2duL21oSTJXTEJjcFMzWDM5eExEQitSV212?=
 =?utf-8?B?ZzFUR0g1b0NJVS91eHVhYmU0L010ZkdraFQxSTJPV3gyZXA0d25CSmF2a201?=
 =?utf-8?B?UXZINHNSZ28zNXpKZm1BUVVSMEp4SzJtOTFBcVZJSHZLZUg3dUU4TCthZjFT?=
 =?utf-8?B?cElQaThXU2t4Y3ZSSjY2QkNKbDEzU0NYaFNUd1hMeDBPeDRkako0Uk1hWUxO?=
 =?utf-8?B?Ujh1Y1F2RGVod1VYUHlpaEM5ZW5mbFRxT1U0V0dsR2Uyd1V4UG9OSW96bHJi?=
 =?utf-8?B?ZTgrNjVCdHRQODUzR2loNXFwNjJKRnJlQm1od2txem1ESEQrTjB0Z0YxK2FP?=
 =?utf-8?B?cER1eTkva2FiUWJkMFladENkaUt0b3JIVWdQZk5hYzM0bXVTdDFja2xacDZm?=
 =?utf-8?B?OTJ6eEdJOVpwNWpZcE5XNU5aVnRlanQ4TkdwNmxHMjR0MG96OEdGSkFwUnZB?=
 =?utf-8?B?K2N1VUwwMlVpeEgvdG5xYkRiZ1J5WitVZ01KbFNTZk1SMG1pdDhSdWh2dXU1?=
 =?utf-8?B?eUhvRlc3TThVUFZDQ2p3RHNYTGdJN1g5M1pFVEtnbzI4MFB2ekxGYytKeUFR?=
 =?utf-8?B?MXhvZm5DaUFMTWhNbDhsdEg1VjE0djhXL1o4ZkNqKzhQMGViQTQ1RnV6M2Nu?=
 =?utf-8?B?d3ZQN0F1cGhZVGJsNFYrYlpHRkhvT3JaZ1RXRTJ6RVRaSTJmMHNKZzBuZUFQ?=
 =?utf-8?B?UDk2VWxaOUhvL2NUZEpjY0dVOER3c0plbFpaditGVVo0VzFCQzF4ZktjUWhS?=
 =?utf-8?Q?hXHlfpzCjAbULriW68IurAR+vto1sSl45WyLI2BEq9cFg?=
x-ms-exchange-antispam-messagedata-1: V7vZUosMX8N8uTBWHJ5Sx69W1+kl08TKck/r6QMaxRPf+So6rhOi035p
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFD06753D711F048BB56DEB535FDB258@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c2f2b0-c66e-44f7-89c6-08da2e2df745
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 00:26:58.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iLfLXwIVaC+dcKkSQey7Liue/ugRx5lUbWgBYB1FkdZdnFEMlZ80h75NCpU3PIUQB32WS6bJRasoeJZg4PsvwnZPQK2odQpt65/gWO0s94c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5611
X-Proofpoint-GUID: C0OCsUvKSKcI4Bo49mZm-UdiCsQ_OLmk
X-Proofpoint-ORIG-GUID: C0OCsUvKSKcI4Bo49mZm-UdiCsQ_OLmk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_06,2022-05-04_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDQsIDIwMjIsIGF0IDU6NDcgUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgTWF5IDA0LCAyMDIyLCBKb24g
S29obGVyIHdyb3RlOg0KPj4gVGhlIHRyYWNlIHBvaW50IGluIHJlY29yZF9zdGVhbF90aW1lKCkg
aXMgYWJvdmUgdGhlIGNvbmRpdGlvbmFsDQo+PiB0aGF0IGZpcmVzIGt2bV92Y3B1X2ZsdXNoX3Rs
Yl9ndWVzdCgpLCBzbyBldmVuIHdoZW4gd2UgbWlnaHQNCj4+IG5vdCBiZSBmbHVzaGluZyB0bGIs
IHdlIHN0aWxsIHJlY29yZCB0aGF0IHdlIGFyZS4NCj4gDQo+IE5vLCBpdCByZWNvcmRzIHdoZXRo
ZXIgbm90IGEgVExCIGZsdXNoIGlzIG5lZWRlZC4NCg0KU3VyZSwgdGhlIHRyYWNlIGRvZXMsIGJ1
dCB0aGUgc3RhdCBtYWtlcyBpdCBzZWVtIGxpa2UgdGhlIGhvc3QgaXMgZ29pbmcNCm51dHMgd2l0
aCBkb2luZyBwdiB0bGIgZmx1c2hlcyB3aGVuIGluIHJlYWxpdHkgaXQgbWF5IG5vdCByZWFsbHkg
YmUNCmRvaW5nIGFsbCB0aGF0IG11Y2ggd29yay4NCg0KPiANCj4+IEZpeCBieSBuZXN0bGluZyB0
cmFjZV9rdm1fcHZfdGxiX2ZsdXNoKCkgdW5kZXIgYXBwcm9wcmlhdGUNCj4+IGNvbmRpdGlvbmFs
LiBUaGlzIHJlc3VsdHMgaW4gdGhlIHN0YXRzIGZvciBrdm06a3ZtX3B2X3RsYl9mbHVzaCwNCj4+
IGFzIHRyaXZpYWxseSBvYnNlcnZhYmxlIGJ5IHBlcmYgc3RhdCAtZSAia3ZtOioiIC1hIHNsZWVw
IFhzLCBpbg0KPj4gcmVwb3J0aW5nIHRoZSBhbW91bnQgb2YgdGltZXMgd2UgYWN0dWFsbHkgZG8g
YSBwdiB0bGIgZmx1c2gsDQo+PiBpbnN0ZWFkIG9mIGp1c3QgdGhlIGFtb3VudCBvZiB0aW1lcyB3
ZSBoYXBwZW4gdG8gY2FsbA0KPj4gcmVjb3JkX3N0ZWFsX3RpbWUoKS4NCj4+IA0KPj4gU2lnbmVk
LW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gLS0tDQo+PiBhcmNoL3g4
Ni9rdm0veDg2LmMgfCA0ICsrLS0NCj4+IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMg
Yi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4+IGluZGV4IDQ3OTBmMGQ3ZDQwYi4uOGQ0ZTBlNThlYzM0
IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+PiArKysgYi9hcmNoL3g4Ni9r
dm0veDg2LmMNCj4+IEBAIC0zNDEwLDkgKzM0MTAsOSBAQCBzdGF0aWMgdm9pZCByZWNvcmRfc3Rl
YWxfdGltZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiANCj4+IAkJdmNwdS0+YXJjaC5zdC5w
cmVlbXB0ZWQgPSAwOw0KPj4gDQo+PiAtCQl0cmFjZV9rdm1fcHZfdGxiX2ZsdXNoKHZjcHUtPnZj
cHVfaWQsDQo+PiAtCQkJCSAgICAgICBzdF9wcmVlbXB0ZWQgJiBLVk1fVkNQVV9GTFVTSF9UTEIp
Ow0KPj4gCQlpZiAoc3RfcHJlZW1wdGVkICYgS1ZNX1ZDUFVfRkxVU0hfVExCKQ0KPj4gKwkJCXRy
YWNlX2t2bV9wdl90bGJfZmx1c2godmNwdS0+dmNwdV9pZCwNCj4+ICsJCQkJc3RfcHJlZW1wdGVk
ICYgS1ZNX1ZDUFVfRkxVU0hfVExCKTsNCj4gDQo+IElmIHlvdSdyZSBnb2luZyB0byB0cmFjZSBv
bmx5IHdoZW4gYSBmbHVzaCBpcyBuZWVkZWQsIHRoaXMgc2hvdWxkIHNpbXBseSBiZToNCj4gDQo+
IAkJCXRyYWNlX2t2bV9wdl90bGJfZmx1c2godmNwdS0+dmNwdV9pZCk7DQo+IA0KPiBJIGhhdmVu
J3QgdXNlZCB0aGlzIHRyYWNlcG9pbnQgb2Z0ZW4gKGF0IGFsbD8pIHNvIEkgZG9uJ3QgaGF2ZSBh
IHN0cm9uZyBwcmVmZXJlbmNlLA0KPiBidXQgSSBjYW4gc2VlIHRoZSAibm8gVExCIGZsdXNoIG5l
ZWRlZCIgaW5mb3JtYXRpb24gYmVpbmcgZXh0cmVtZWx5IHZhbHVhYmxlIHdoZW4NCj4gZGVidWdn
aW5nIGEgc3Vwc2VjdGVkIFRMQiBmbHVzaGluZyBidWcuDQoNClllYSB0aGF0cyBmYWlyOyBob3dl
dmVyLCB0aGlzIGlzIG9ubHkgY2FsbGluZyBpbnRvIHNvbWUgb3RoZXIgZnVuY3Rpb24gdGhhdCBp
cw0KYWN0dWFsbHkgZG9pbmcgdGhlIHdvcmsuIFRob3NlIG90aGVyIGZsdXNoIFRMQiBhcmVhcyBk
byBub3QgaGF2ZSB0cmFjZXMNCkFGQUlLLCBzbyBldmVuIHRoYXQgaXMgYSBiaXQgaW4gY29tcGxl
dGUuDQoNClRoZSBuZXQgcHJvYmxlbSBoZXJlIGlzIHJlYWxseSB0aGF0IHRoZSBzdGF0IGlzIGxp
a2VseSBpbmNvcnJlY3Q7IGhvd2V2ZXIsDQpvbmUgb3RoZXIgb2RkaXR5IEkgZGlkbuKAmXQgcXVp
dGUgdW5kZXJzdGFuZCBhZnRlciBsb29raW5nIGludG8gdGhpcyBpcyB0aGF0DQp0aGUgY2FsbCBz
aXRlIGZvciBhbGwgb2YgdGhpcyBpcyBpbiByZWNvcmRfc3RlYWxfdGltZSgpLCB3aGljaCBpcyBv
bmx5IGNhbGxlZA0KZnJvbSB2Y3B1X2VudGVyX2d1ZXN0KCksIGFuZCB0aGF0IGlzIGNhbGxlZCAq
YWZ0ZXIqDQprdm1fc2VydmljZV9sb2NhbF90bGJfZmx1c2hfcmVxdWVzdHMoKSwgd2hpY2ggYWxz
byBjYWxscw0Ka3ZtX3ZjcHVfZmx1c2hfdGxiX2d1ZXN0KCkgaWYgcmVxdWVzdCA9PSBLVk1fUkVR
X1RMQl9GTFVTSF9HVUVTVA0KDQpUaGF0IHJlcXVlc3QgbWF5IGJlIHRoZXJlIHNldCBmcm9tIGEg
ZmV3IGRpZmZlcmVudCBwbGFjZXMuIA0KDQpJIGRvbuKAmXQgaGF2ZSBhbnkgcHJvb2Ygb2YgdGhp
cywgYnV0IGl0IHNlZW1zIHRvIG1lIGxpa2Ugd2UgbWlnaHQgaGF2ZSBhDQpzaXR1YXRpb24gd2hl
cmUgd2UgZG91YmxlIGZsdXNoPw0KDQpQdXQgYW5vdGhlciB3YXksIEkgd29uZGVyIGlmIHRoZXJl
IGlzIGFueSBzZW5zZSBiZWhpbmQgbWF5YmUgaG9pc3RpbmcNCmlmIChrdm1fY2hlY2tfcmVxdWVz
dChLVk1fUkVRX1NURUFMX1VQREFURSwgdmNwdSkpIHVwIGJlZm9yZQ0KT3RoZXIgdGxiIGZsdXNo
ZXMsIGFuZCBoYXZlIGl0IGNsZWFyIHRoZSBGTFVTSF9HVUVTVCBpZiBpdCB3YXMgc2V0Pw0KDQpK
dXN0IHRoaW5raW5nIGFsb3VkLCBzZWVtZWQgZmlzaHkuDQoNClJlZ2FyZGxlc3MsIHRoaXMgcHYg
dGxiIGZsdXNoIHN0YXQgbmVlZHMgc29tZSBsb3ZlLCBvcGVuIHRvIHN1Z2dlc3Rpb25zDQpvbiB0
aGUgbW9zdCBhcHByb3ByaWF0ZSB3YXkgdG8gdGFja2xlIGl0Pw0KDQo+IA0KPj4gCQkJa3ZtX3Zj
cHVfZmx1c2hfdGxiX2d1ZXN0KHZjcHUpOw0KPj4gDQo+PiAJCWlmICghdXNlcl9hY2Nlc3NfYmVn
aW4oc3QsIHNpemVvZigqc3QpKSkNCj4+IC0tIA0KPj4gMi4zMC4xIChBcHBsZSBHaXQtMTMwKQ0K
DQo=
