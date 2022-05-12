Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67982525441
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357388AbiELR6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357380AbiELR6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:58:06 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0442313325A;
        Thu, 12 May 2022 10:58:05 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CF4tSv023467;
        Thu, 12 May 2022 10:56:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=am1n7mgaQ/nNaMTn6t1yergl2WoJEq+FrHs4kMTPK5E=;
 b=w6oiIjyw63yeeeyeJNOJHRiWqqgsLBbOpPiy3Ah1O7Ykt27n7OHoISYj2NixtFxGa5+h
 n4fJGQBMs0yBdU+J0C92wLOIvY6j6uvuw/FdBViE+DAn8m3XuUfx2IpInpFVZ3aEJSrC
 8Ku6Adgqm8iHpZ6Q7NNwEvRsW+B1c/XCvKyEFl74+S4+agMe+FX8KBspkffe0Yx7NTkt
 2IGqwOIgWqn7LljLiS/TTPwoyr8Faew+pza7AVBCTFXreVQtjqv7fhxleLZifeZIaKkx
 roni2VuYFEZcKKyPYu4dhAqGj7iMST76k/763gxbEpFOlL4/iqcMRbcvvb368bHew7Xv 2w== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwr3fujay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 10:56:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEi2u4BcWAY3u/Wup4xWii6cQ8NddtMnkiWbSxKqs2VUr4oHzoN02rOIEKmQO21IrpmMNKk3vk35pzLliTr1Kn7Oqj8s7LmyqUOgdRPckjRtew5UL1tqe5D5aPyYYhocmozjz+lSMSrEVQNgtAGDTH9es0zznDlEWWdDkh/ygbJ3ZYc9B9+76KJH2aiSjZxNBrZLUS0gAhKj+WCCvpk9w0ipQL2RuuQfL3Dl4GfdLoPO/H7Z69l1lWdoJSNlPrAs2mUhwWD4sOailZEoBz4PxeNpvO+v4xi+QMV0bXpP+sYyEGeFlzDlBTHzyQtwAMdQL5xyKaAKMlnBAzSMI2EC3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=am1n7mgaQ/nNaMTn6t1yergl2WoJEq+FrHs4kMTPK5E=;
 b=hpaHlMHqpCUTjPymTrzKbwl3IHd3B1yPwEKtt6Ndm6C9p817Tpxxc64s+y1b3hx0vPN3URQQltgGgWtkwCfkGGJG2ILBKowilfJmKSyltIx9jM00aS9/CSonVYwHi7fYs6sb3YPuEFpQQSjdJstaY6FDewLMGH6tymjb5hUqDG69YRfzc3YmcKgc0uipZOmnCHq8IhDnnWZnGGZWZPcmwCkM4ln9u9j38nng10VNWAllaAd9QsQyh+VAByMooggEDWFrxQe6U0b2wW0xKjWn3LtTj2x0gwhVBe+Q7d+zMVWo/7kJtXOK+DDvv4+tM8sYBngtfljYr73cJgtRwRQmyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA2PR02MB7577.namprd02.prod.outlook.com (2603:10b6:806:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Thu, 12 May
 2022 17:56:57 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 17:56:56 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Topic: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9ICAACHkgIAAD+oAgAAIS4CAABD0AIAABkcAgAARGQCAAK85AIAAU8oAgAAV5oCAD5/VAIAABTSAgAANIYCAAwF4gIAARoQA
Date:   Thu, 12 May 2022 17:56:56 +0000
Message-ID: <0E8D003F-BA2A-4310-91FF-677D26105E6A@nutanix.com>
References: <YmxRnwSUBIkOIjLA@zn.tnic> <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic> <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic> <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
 <Ym1fGZIs6K7T6h3n@zn.tnic> <Ynp6ZoQUwtlWPI0Z@google.com>
 <520D7CBE-55FA-4EB9-BC41-9E8D695334D1@nutanix.com>
 <YnqJx/5hos0lKqI9@google.com> <Yn0PQe48qczUMZoL@zn.tnic>
In-Reply-To: <Yn0PQe48qczUMZoL@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8d2a4b2-5e2e-4c43-59a3-08da3440ce3d
x-ms-traffictypediagnostic: SA2PR02MB7577:EE_
x-microsoft-antispam-prvs: <SA2PR02MB75774703F29B88278969CA06AFCB9@SA2PR02MB7577.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KGe5589p/E+/2S7LW1Zek4xlSC+Q0yUP3BLRj3wh/MFzB4Jap05knuRgmxVXWVsjrNRKAVhR0rhRI08LUG4IQtiNrhzn/H1IYCgnNNijo86UbQ/9PwtA2IpZVTwBw7DYw0QGd9wY/E8eNCIxCGFxd++9HbqgFPKaaqfJzJEN1Pvax+WlWv6x++0wDZzHb7WOCediTfjZz3XW8yCAkkeI+12EpHQiL4sR4FlehiZRJ917W7lXs+Jh1Ao8ECS9HjKaNAuNAEy4eA18qCOGFMaHBr0QjEwGfnvYjb/YIvq1IOPdXwC18L73EEe9N6ouvZA0VGWrvYcEagtxNyUxlApH+ods0fa+u2ZePasqsbypZ8yVAm4I7E4vvI/EfYKFpCmWNVxL0JurAfAwukxRVF6hZnfpGxmbXc7Jt3s1PU+7k4sgqf47p/3LvEtQ834X/Pg2fPqgsgxyr7DqxQ8Z4rtx3SuuBfV4saot+x4FTs+uDFpcpIiaJ/RMwB8zmPKfQr1Zcmf5EOO4LhiRc0HrmlEIJ/h0UxBczUXKu0wBWmEMCQegTyq1+q9NxksDBRofeN5UOiiw3UKvtut7fTe5Pm2DKgHNRLM2TrNZq/Ka7PPk1gThBmUE0QtadmlP8FWNKicp46gq6bamJE2LJaXBtZlAgVntv3Jx4I6JRiXrwGixmnFChr++2gq5upn2OFjjAbJyDIoJIqlHdPWv+mMyr5dHN5VgqLBdt1Gtm3Ph0cEGas+6XsttZmIq3wMii/elkZOnZ6RFv4tQsc5vUxEsJ1hwR67S8COFxcNUdA++krFfuQwH29jsr1bQEA7fDbOG4j5G5Py4AqB1FAK9TI8xJ1S1jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(8676002)(91956017)(36756003)(8936002)(316002)(66946007)(76116006)(4326008)(66556008)(64756008)(33656002)(66476007)(6486002)(966005)(6916009)(71200400001)(54906003)(6506007)(5660300002)(7416002)(508600001)(2906002)(38100700002)(38070700005)(86362001)(122000001)(53546011)(2616005)(186003)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGlDVW1HMzBIUTVxZEpIbXZpNTFBTzVYVk4yZzNIWmNVSlAveUExeXBpSzdP?=
 =?utf-8?B?RC9JazBBN1l2bEZuZjVpOVFmMkpKSi9KVWV4RGpsNHBPRHhNZy9aQmZKRm92?=
 =?utf-8?B?NXowYXhUYURKYUJEZWtwdkswOW5ZNGQwVGkyb1hwQTJRNjBNMS9uaE5HTWsw?=
 =?utf-8?B?dXRYUHgwTFVtMXc0NUJkZlRCSjB3U3hPWkQ3cXcvV1Vuait0dUhFeW1PZnZa?=
 =?utf-8?B?SURFUTArZDVsWXIrbG53bVlZYWNTODJhNU5oL3VQUk8xeHprazBJRXdhM2xK?=
 =?utf-8?B?S1cwd2lzTTQ0ZDJGaTJHWHVRc1RISXlYc3JkK3FjeU90Z05xVUNxSE1XM1hX?=
 =?utf-8?B?ZTN1Mmw5YWNiUGVIaEw5QjZRaDlZMW1ja2h2OGdHa29nVGxhWThRVEVCL0Jy?=
 =?utf-8?B?MGFUQ1lWQUFvTGJkZGlNd2ZCWGtaaHJHYk9zYWlXOU8zbmxmYXg2OVRQTTY4?=
 =?utf-8?B?SW52ZDYxQXVvZVQ2QjU4cmQxY3lpOTczcjlsVmM5V3JoeXQrRFBPUHNZWlIw?=
 =?utf-8?B?bkpBQWR6eWN3c3dEQmpmbS82UVZwZnlqQ2NNZ1F4QjR2bzJZazJVb3RhbjRU?=
 =?utf-8?B?QTE2NTVKcXp4UnN3QzNtcG5qWEpUUnlKOTZraWNxNUxNd3U2WkFRc2s1MGwy?=
 =?utf-8?B?cGlrWitTY2pGN0lMeDh3a1NMaXFGYlBIS2REY0lyejZlNmVsTXQzZVU3R1FG?=
 =?utf-8?B?eDdpUjRENE5jYnZTVXJwQ0RMV2NSZHlzVWRyaDgxRXZ3VkpuZW1iazZUUXBM?=
 =?utf-8?B?TlNCaUlIYkg0MzVhYnVLay9CN3dMM0VITFA3WCtzNWN1VHE0QlRaTjZIbElS?=
 =?utf-8?B?Z0FJcmVUS3hkcHMyTDZoSmdpeVc2cXR6dG40SmtqSlZvWHBIWXVYUE82WHM5?=
 =?utf-8?B?UmFUL1E3TGYwLy9XcHArQXhMRml4TlVzZGp2bG9MU2QyWGRtZi9RendrU3ZE?=
 =?utf-8?B?c1h4Z1JRVlpnZ0FDeVUzVlM5djYzOW5pYlhianp6VndNUFViUE52WkF1bHh1?=
 =?utf-8?B?NG5XcmNhN2QrNVk4RkNXZGJ5eCtyclVQNzRnb3NPWWlsSXNHQ3R0QlZtM3R0?=
 =?utf-8?B?QkgyVEJPYzFJL1Y4Mnk3V09pZi84OVhqL014QWhoajB1ek93MmR6cVlXRkI5?=
 =?utf-8?B?cDRBT2pJTC9xNEtPYUdHQ2lwRnBXQTN0OEpiN2JuWXRkUEs5OTk1OWFWdkVL?=
 =?utf-8?B?TVB5cXNRdGwva2lpYzdmdzU0OXlLRm0wemc0bko2Q2JtTEhXc1ZHQ3B6MlJz?=
 =?utf-8?B?MzFNZ2RkRnFDaGRkc2pnZ2ZNNEdtazMvNWFLQUtxaHM0VktoZnpsM21vSmNu?=
 =?utf-8?B?MThOK3RwYzFFa3NRcFFEK2tZaWJubjQvTXloeGVkWForUXo3ejUxUlFKSkpK?=
 =?utf-8?B?RzBZSzVMeDJFWEFBbXc3TmpxS1pFVVR5M1NJWENQY21GeHUyb2QwVm1GczNC?=
 =?utf-8?B?TVNkdldvZlNCM2lucm5mZ1NXMkNheWhwRHJVSnVCQngycVM2eVpiOWM2ZVVJ?=
 =?utf-8?B?WHU1NDlOWWZTZHMrd2dVN1plKzJiSDZneXR6UzhLdmswYWJZdW82SjZBVWpR?=
 =?utf-8?B?OVZBcE9ZSVNXS25jSXB5Y3J2eHU4d2NiZG9sVmIwSzZMb2d1b1EzN2JaWlRC?=
 =?utf-8?B?cFVhSXRCMkZobXRRclYwMVRSZzBaM0NxU0hSRzIvb3FmTnJHT0pYaFAvdll3?=
 =?utf-8?B?Zlgza29saWU3VWZUVjNCZmVlMnFXMWJzd3J4eEJGSnFKZDRlVFdWSVlVWTVn?=
 =?utf-8?B?TmN1NlFmWGNkbjFoc2I4ZW12eHgvZEFaNWdBY3QrMjNmeDg0ejdSZHcvL3JL?=
 =?utf-8?B?RVRZZDF3TXNuMXh4VCthWVZKVW5xNDEyRDJtdy90NlQxeStudk5iTzJwN0tW?=
 =?utf-8?B?TDhqRVRXaGs3SGpidE5tWlJUQ1lmRDNidktCR3JBcmVZV3RpZUNYMnRnYWxB?=
 =?utf-8?B?MmtBYmRLclJTWm42ejlMZTNaU1R0VDcvUGdvaTlxYmF2MVMvQnZWKzY5ZUNG?=
 =?utf-8?B?OUdobXBEclM0RVJtTllPVmFKVDYrbkdXY3RHQkhTeWdadDFZRExDeFVaNkhm?=
 =?utf-8?B?YjRDUUEyQitQKzdDTmVLekdGQkpIWGtxOC9jRFMySmRyaGZjT3lvOTA1U3Rn?=
 =?utf-8?B?T2RUUCtzY3pYNXl2eVhNRjVZS1lOVXVRa1pDQjZkaUM0b1l3ZmJ5amh6UEpL?=
 =?utf-8?B?RU5OMUtnL1A1QXJpaUZGYVdFaVJEZlVIR21lYlYrZ0lCZnVzM2hEMzJpVktv?=
 =?utf-8?B?VzJ5WFFVUldRdHk0emw1ZGdyNUhLb2pFL3NURHVqQTROUEJhd2g1QTJkdVZO?=
 =?utf-8?B?dFZoZkNvTlhucUlrdXNYOEpudjZoaUt4NmhNdmt0YnpITVNadDY0aHpuQkFY?=
 =?utf-8?Q?lCNxVzqRiUHzQXLOok6tWjNRcm5hpi9TEOyvYi9jcVyRH?=
x-ms-exchange-antispam-messagedata-1: dv0UHN+yVU0TS3A49dnBEfgs9NbkzlaszMNZ8Lqsiae3sToyT8IiLToG
Content-Type: text/plain; charset="utf-8"
Content-ID: <0716550EC11FD141B311F8B3B537CBE8@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d2a4b2-5e2e-4c43-59a3-08da3440ce3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 17:56:56.8712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L+16w3DZBQ/3vC3tOVAtUMM2N7Ct7nOJI7fPbEeG7CtSc/5WorkgGQ3U7ECCPcADfcz1yWq+FA9RDifgO7nIDQ291l/Zuxq7QdvX3QHc/oY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7577
X-Proofpoint-GUID: 4vTuNH3xhxSKr-0tPUdjCf5_3wKciXUn
X-Proofpoint-ORIG-GUID: 4vTuNH3xhxSKr-0tPUdjCf5_3wKciXUn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_15,2022-05-12_01,2022-02-23_01
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

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCA5OjQ0IEFNLCBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFs
aWVuOC5kZT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIE1heSAxMCwgMjAyMiBhdCAwMzo1MDozMVBN
ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPj4+ICAgIHg4Ni9zcGVjdWxhdGlv
biwgS1ZNOiByZW1vdmUgSUJQQiBvbiB2Q1BVIGxvYWQNCj4+PiANCj4+PiAgICBSZW1vdmUgSUJQ
QiB0aGF0IGlzIGRvbmUgb24gS1ZNIHZDUFUgbG9hZCwgYXMgdGhlIGd1ZXN0LXRvLWd1ZXN0DQo+
Pj4gICAgYXR0YWNrIHN1cmZhY2UgaXMgYWxyZWFkeSBjb3ZlcmVkIGJ5IHN3aXRjaF9tbV9pcnFz
X29mZigpIC0+DQo+Pj4gICAgY29uZF9taXRpZ2F0aW9uKCkuDQo+Pj4gDQo+Pj4gICAgVGhlIG9y
aWdpbmFsIDE1ZDQ1MDcxNTIzZCAoIktWTS94ODY6IEFkZCBJQlBCIHN1cHBvcnQiKSB3YXMgc2lt
cGx5IHdyb25nIGluDQo+Pj4gICAgaXRzIGd1ZXN0LXRvLWd1ZXN0IGRlc2lnbiBpbnRlbnRpb24u
IFRoZXJlIGFyZSB0aHJlZSBzY2VuYXJpb3MgYXQgcGxheQ0KPj4+ICAgIGhlcmU6DQo+Pj4gDQo+
Pj4gICAgMS4gSWYgdGhlIHZDUFVzIGJlbG9uZyB0byB0aGUgc2FtZSBWTSwgdGhleSBhcmUgaW4g
dGhlIHNhbWUgc2VjdXJpdHkgDQo+Pj4gICAgZG9tYWluIGFuZCBkbyBub3QgbmVlZCBhbiBJUEJQ
Lg0KPj4+ICAgIDIuIElmIHRoZSB2Q1BVcyBiZWxvbmcgdG8gZGlmZmVyZW50IFZNcywgYW5kIGVh
Y2ggVk0gaXMgaW4gaXRzIG93biBtbV9zdHJ1Y3QsDQo+Pj4gICAgc3dpdGNoX21tX2lycXNfb2Zm
KCkgd2lsbCBoYW5kbGUgSUJQQiBhcyBhbiBtbSBzd2l0Y2ggaXMgZ3VhcmFudGVlZCB0bw0KPj4+
ICAgIG9jY3VyIHByaW9yIHRvIGxvYWRpbmcgYSB2Q1BVIGJlbG9uZ2luZyB0byBhIGRpZmZlcmVu
dCBWTXMuDQo+Pj4gICAgMy4gSWYgdGhlIHZDUFVzIGJlbG9uZyB0byBkaWZmZXJlbnQgVk1zLCBi
dXQgbXVsdGlwbGUgVk1zIHNoYXJlIGFuIG1tX3N0cnVjdCwNCj4+PiAgICB0aGVuIHRoZSBzZWN1
cml0eSBiZW5lZml0cyBvZiBhbiBJQlBCIHdoZW4gc3dpdGNoaW5nIHZDUFVzIGFyZSBkdWJpb3Vz
LCANCj4+PiAgICBhdCBiZXN0Lg0KPj4+IA0KPj4+ICAgIElzc3VpbmcgSUJQQiBmcm9tIEtWTSB2
Q1BVIGxvYWQgd291bGQgb25seSBjb3ZlciAjMywgYnV0IHRoZXJlIGFyZSBubw0KPj4gDQo+PiBK
dXN0IHRvIGhlZGdlLCB0aGVyZSBhcmUgbm8gX2tub3duXyB1c2UgY2FzZXMuDQo+PiANCj4+PiAg
ICByZWFsIHdvcmxkIHRhbmdpYmxlIHVzZSBjYXNlcyBmb3Igc3VjaCBhIGNvbmZpZ3VyYXRpb24u
DQo+PiANCj4+IGFuZCBJIHdvdWxkIGZ1cnRoZXIgcXVhbGlmeSB0aGlzIHdpdGg6DQo+PiANCj4+
ICAgICAgYnV0IHRoZXJlIGFyZSBubyBrbm93biByZWFsIHdvcmxkLCB0YW5naWJsZSB1c2UgY2Fz
ZXMgZm9yIHJ1bm5pbmcgbXVsdGlwbGUNCj4+ICAgICAgVk1zIGJlbG9uZ2luZyB0byBkaWZmZXJl
bnQgc2VjdXJpdHkgZG9tYWlucyBpbiBhIHNoYXJlZCBhZGRyZXNzIHNwYWNlLg0KPj4gDQo+PiBS
dW5uaW5nIG11bHRpcGxlIFZNcyBpbiBhIHNpbmdsZSBhZGRyZXNzIHNwYWNlIGlzIHBsYXVzaWJs
ZSBhbmQgc2FuZSwgX2lmXyB0aGV5DQo+PiBhcmUgYWxsIGluIHRoZSBzYW1lIHNlY3VyaXR5IGRv
bWFpbiBvciBzZWN1cml0eSBpcyBub3QgYSBjb25jZXJuLiAgVGhhdCB3YXkgdGhlDQo+PiBzdGF0
ZW1lbnQgaXNuJ3QgaW52YWxpZGF0ZWQgaWYgc29tZW9uZSBwb3BzIHVwIHdpdGggYSB1c2UgY2Fz
ZSBmb3IgcnVubmluZyBtdWx0aXBsZQ0KPj4gVk1zIGJ1dCBoYXMgbm8gc2VjdXJpdHkgc3Rvcnku
DQo+PiANCj4+IE90aGVyIHRoYW4gdGhhdCwgTEdUTS4NCj4+IA0KPj4+ICAgIElmIG11bHRpcGxl
IFZNcw0KPj4+ICAgIGFyZSBzaGFyaW5nIGFuIG1tX3N0cnVjdHMsIHByZWRpY3Rpb24gYXR0YWNr
cyBhcmUgdGhlIGxlYXN0IG9mIHRoZWlyDQo+Pj4gICAgc2VjdXJpdHkgd29ycmllcy4NCj4+PiAN
Cj4+PiAgICBGaXhlczogMTVkNDUwNzE1MjNkICgiS1ZNL3g4NjogQWRkIElCUEIgc3VwcG9ydCIp
DQo+Pj4gICAgKFJldmlld2VkYnkvc2lnbmVkIG9mIGJ5IHBlb3BsZSBoZXJlKQ0KPj4+ICAgIChD
b2RlIGNoYW5nZSBzaW1wbHkgd2hhY2tzIElCUEIgaW4gS1ZNIHZteC9zdm0gYW5kIHRoYXRzIGl0
KQ0KPiANCj4gSSBhZ3JlZSB3aXRoIGFsbCB0aGF0IEkndmUgcmVhZCBzbyBmYXIgLSB0aGUgb25s
eSB0aGluZyB0aGF0J3MgbWlzc2luZyBpczoNCj4gDQo+IAkoRG9jdW1lbnRhdGlvbiBpbiBEb2N1
bWVudGF0aW9uL2FkbWluLWd1aWRlL2h3LXZ1bG4vc3BlY3RyZS5yc3QgYWJvdXQgd2hhdCB0aGUg
dXNlDQo+IAkgY2FzZXMgYXJlIGFuZCB3aGF0IHdlJ3JlIHByb3RlY3RpbmcgYWdhaW5zdCBhbmQg
d2hhdCB3ZSdyZSAqbm90KiBwcm90ZWN0aW5nDQo+IAkgYWdhaW5zdCBiZWNhdXNlIDxyYWlzaW5z
PikuDQo+IA0KPiBUaHguDQoNCk9rIFRoYW5rcywgQm9yaXMuIEnigJlsbCByZXZpZXcgdGhhdCBk
b2MgYW5kIG1ha2UgbW9kaWZpY2F0aW9ucyBvbiB2NCwgYW5kIG1ha2Ugc3VyZQ0KdGhhdCB5b3Ug
YXJlIGNj4oCZZC4NCg0KVGhhbmtzIGFnYWluLA0KSm9uDQoNCj4gDQo+IC0tIA0KPiBSZWdhcmRz
L0dydXNzLA0KPiAgICBCb3Jpcy4NCj4gDQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50
LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcGVvcGxlLmtlcm5lbC5vcmdfdGdseF9ub3Rlcy0yRGFi
b3V0LTJEbmV0aXF1ZXR0ZSZkPUR3SUJhUSZjPXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj1OR1BS
R0dvMzdtUWlTWGdIS201ckNRJm09NTVJRFNwRkU3TjFkMGVPWUlMLVVoZ3hvRmc1SlQ3SEZDRXgx
N3JOZm84WERBb0pnajR4SGpUenZxS2VjNlppNiZzPTRpanJwZWlMZkdKUml5T3BZWTBQbi1CeHZH
RXF2TzJUN3hhTnlDMExtTWsmZT0gDQoNCg==
