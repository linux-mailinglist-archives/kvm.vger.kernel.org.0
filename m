Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE527515535
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 22:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380555AbiD2UOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 16:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380541AbiD2UNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 16:13:43 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D3CB85C;
        Fri, 29 Apr 2022 13:10:22 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TGM7gh015639;
        Fri, 29 Apr 2022 13:08:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=7ACfy3u+JrxtgkDNNNoour/BNTOQYrcrk/1AI9fKYqQ=;
 b=FbkCWA1qDLYN54xpdCsi62Ef6VeaLakumG2PCl78c6OxVhwYMS1c5sL7ArkRRtCo8bRj
 2bY5gx0vg0ZJiFWPmd1w30uT7i60DDIIdXemeWxU1dffK13e4rvYKqx6/uC2pc64fLfl
 XiIZxiVzWNgRsXs8o4O8Oyna5MD0snFfBrir7KaELUZ9iyu5enM+nipJ/u+9WxhuN4Mt
 LezKq6b1WL8+AbIPOIEKBL8VKWkB8FoH2URevLb+Mh6briylh+4Wv9fJ6F6TUZKDATGw
 FAA25gO/IaKMWEBFXI+NsCAS80K2guLaZDY2D5gmk/3GeNmHoH8BcIWV52fmKr/a4ypV 9Q== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fps4ef1x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 13:08:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHZxdaQKnBWECImn/Bp3Vff1Czuo0P6DcQw2LSRthjN5N/xT7Q2RMwSg2mEyxGuEDO/qDjUKvCft9EZHkbY3W3ePOnc+gj3VazO/sZDgBNtrHi7lfZu2HplATFdbaE/rUYStLdd4+16M1l2eKvbWN4DS558wMycxi0OYSTN4R4t7wBuOLlW5u5i45Ib4lTvMukrhEvYPNC9CT5wBJMs9c0WUmETupvSkWqYY0TIAlp/2NYsUHuCw9fnMWbvPZBemFLhynAeWNxbXoDKwWO9yRv08d1BV4udd/liRJW+U4G65UNv4iao/dgbWzJgVStBdy5b3RKy7g5zhQFPi5Fa49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ACfy3u+JrxtgkDNNNoour/BNTOQYrcrk/1AI9fKYqQ=;
 b=IUKSFzxnd0BvoWcmXjapD6tob5R3PYFcUNBZEUxZjbNIdTpOkw2+ZbN99DF4B54Sac0qs7U/UsegnEanRZG1+6BAy37BHq9ddN/e+oKvEGbgF5gAgu4YP/mXA5RXgcuR7jtwIiC5zZR7xPMoD6jU477kRRbaw7/hchX8UnmZl0DBRmBbx6rdyPXdLIr228JiXVLZJWW2Zae0g6VUnOp6L7OcfutDPH/TI4qxCxmwe91LQsVLa2asV2v6Xc26GO2T1b5F0595JgAxdaJw5ThrCgbuInLX7gH9Q9/q05H+vMyXgJxT2u0g45YHey/GSKhP5BeZ+1SacPh04XBOicHJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM6PR02MB6619.namprd02.prod.outlook.com (2603:10b6:5:217::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Fri, 29 Apr
 2022 20:08:27 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5186.023; Fri, 29 Apr 2022
 20:08:27 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9ICAACHkgIAACgcA
Date:   Fri, 29 Apr 2022 20:08:27 +0000
Message-ID: <104170E0-104F-46DB-8EE8-68261265CBAF@nutanix.com>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic> <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
In-Reply-To: <Ymw9UZDpXym2vXJs@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05b0f662-e92b-4f20-1def-08da2a1c061b
x-ms-traffictypediagnostic: DM6PR02MB6619:EE_
x-microsoft-antispam-prvs: <DM6PR02MB661939DF8488BEF1676DD47DAFFC9@DM6PR02MB6619.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: stWK5v6q2x1m93XlAnjS8A2bEeK62VaS2w5Nlvm/knk4x18iIzerlChuevN2IW9zDBfxuy1DZeDQU6QU338HrI1KS7M3HdJr81gyBmlQDxm9Pa++qGB/IHP9NT/jmIu/SRMQNdhfrkmub7BdP9vU8KUbMvIbq2tsKV6V+lGleKgw5GrskgfalA46Ma4r8b2C12nXyaC2LmbB6TJaHHkZ7I1BTPIlfO0Tum7fhYGa1cm+Eu2ZRrVfWDHh81eCqotZGA031gQ/L6pRgcrKSl7kWHKRsWxUylFLmG5SmGl8DT0lc33vnFGtHOU5iaSVjvkDxP06OVC+Dl/lIUqZyv+PrwTBY8Dp9NU8W6hIF87PfIjwQPmm2yWsz5Mql86wly7knpEobUvPsAbkphw9bZJQ2QVLu7DIWOW5bCdBgJCo0wkp3dcgPbLJnYSlapNDUlVDLBC/FVtBxeqWG5UNwyHiakK+oXr0qkp1UdrtB0+OPsonRz1oFOwRBcdVwuvOITVV1mXDu9cswadQvXhLqw2VECVjq4t3bkBpgzwVdHu+zlRn/NHk5WU0PDypAFunHr8E+Jb5VjaCCc/BHc3/SazleJrMu3dvG6y/HTn38aTkgMZOIULNapRQGC9WaYtus+DRrKAHDezeakrDOtcZKuNDdAXQ0xvLgR6WdObVxqe6Ge5GvLLG8s8rCgIYMWondAMLe+EFL4QybpjSOkhT2K0xwh4lBf4FM7a6l1WACfm3MbXtHDzGZv40xD16Ga6naln/aqplVn46GM3yUByrN8ukMmSv1UUNpQ/q47xzfrBiUu6sbG+oIFi3GH341lX6KzBd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(966005)(6486002)(2906002)(7416002)(8936002)(38070700005)(38100700002)(316002)(508600001)(53546011)(122000001)(6916009)(54906003)(6506007)(6512007)(83380400001)(86362001)(71200400001)(33656002)(186003)(66446008)(76116006)(8676002)(66946007)(64756008)(4326008)(66556008)(66476007)(91956017)(36756003)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUZwQ1BDb3BtUENWOVZIeU83Z0dWanF2OHFwY2wvTVZGd1JVU1llS0liY0dm?=
 =?utf-8?B?TFh6SmJScUZzZnhuNnh0cUgwN0QrNlVLaFhPZi9yMldaaFA1WHVyN2NVZmg0?=
 =?utf-8?B?Y2FjdFZWNzY0T3BKczRreWQwK2Iyd05ZUVJ3b28yR3ZSaWk2eWxUMk5mY3du?=
 =?utf-8?B?ajB6bHNyYXoraUJFSTBJUGQ4bUpzT01FVk9uYUJMS1dYTVlzWmRYOTlrck5p?=
 =?utf-8?B?bzVrWG5Ea0Q0aTZ2bThtd2tJTWhuWHpwZkhKZDlTVENISit3eEl4NXhqUUU2?=
 =?utf-8?B?LzVrSWNiN1F3Qit1c0NSSFY3Z0RjNE82ZEl5YjJ4QTBmWkt0TG5aQlMvTmNC?=
 =?utf-8?B?WHRmdVI2Zk9VSXh0VnlFaU5XUmMrODlWZFRLazlCY2N1ZlpCZ0VxeFRBTE5W?=
 =?utf-8?B?a1haVUF0ZlFlTzZjVzB6TEFXTUl1eFVSZk02TWRmVDZWaWZibDJOem4vSUt3?=
 =?utf-8?B?WDFtdUFwOGJOODdqREhCWkM4R2FUZ2QvYWhHN3VwaDYraG45RGdlanhkSnd5?=
 =?utf-8?B?Y0QrSUZRejFnL1M5T2J5VWN5N3pPWHhQSEpxSXVTQ203RUhsUXE2c3E4U3M5?=
 =?utf-8?B?aU1WeGlQYm5HUUs0QytOTStWa0dNbm9pdVNOQXMrN0JiS1RCUUNocy9KaUdB?=
 =?utf-8?B?bXQwSmhaSzM0cjB1Mk9MQnF6dmxQYldnMk1OQjROZVM1cXY5RFliUWoxYi90?=
 =?utf-8?B?dXhPWlJaNnh5QmRMMXU5WkN4a2k1VXB3Q2FKRWFQTTJPVmZSNGVKanhjbzRK?=
 =?utf-8?B?MWh2MDIyN05uMXFKTnF1NnlSY1BzTU1hbXNzci9sL01OMUd0aGJpWE9QODR0?=
 =?utf-8?B?RmVQbmw5M2hTNWRXaXBENzVkWXUyaXpuWHJuRldPZFdaWWR3SkJqYXJVT2c1?=
 =?utf-8?B?Q0VPWEd3aGFhZUZuZHB5ZjFCTUxIbW4vVW1la3VlTWlDTGkzRjJSQVZYVGxS?=
 =?utf-8?B?RVBPRmNIR2R1RWdhUjZUa1JjVWFaUDlZWkg0ZFJUNm9WWDdNVlVYN1g2NXJB?=
 =?utf-8?B?S2k5YnU0Y2pSbithOGNMMFRWd3NuTk13V1p1a25sYUl1L2haUkViL081VEk5?=
 =?utf-8?B?YzBUM0d2ZE1nN3AzSWdIeUhSK3NDVlozYzhrUkVjNzVXUVBheFRPMGtLbDdk?=
 =?utf-8?B?ak9aS3pnbjBMT2c5ckdwaEdjVVhXYnp2cytlSjFLNnMyTkkwRWNueWpaU1ho?=
 =?utf-8?B?c2hBQlcvQ1djOEliNDBGVlExcnZRYS95dUJHODV1OEJwQ0h6NTgwVmU3THJh?=
 =?utf-8?B?VmV6cnJQdVBWWXh0cy8vM20rNmUwbzBkOWx3VEZjaCtWTXluQ0llekJvS3dr?=
 =?utf-8?B?WEV6RVNzbVQ1Wk44QkREajB5eU0yZGN1Y2F0cWkxelg5TEVyb2lDdmJRamdk?=
 =?utf-8?B?Y0grTk1udFZUSC9XbWdLdm1rVFl5Q2dlWHE4VkNHeHoxbFZpbUJhV2R5WWk2?=
 =?utf-8?B?R0V1OGo5ZHN3bFE2UHlUdGw5UUJnbFhCYUxWVzFyUHBvQWZhd21ZQWdPWDhv?=
 =?utf-8?B?cDhhRWc2MWs3eUtiU3YrYk96TTFTa1V1MzUxWklMTFp0MWFvMVFUb3cyZjg1?=
 =?utf-8?B?K0x2bnJlNDhXZkNBcmQyY2ttcE9UV3Flbk5Ba1J6Ykt5bjBobm5VUDk2Z2Nw?=
 =?utf-8?B?ZE9RaVlFTkpqTmxDNVFDK3ZWSXRaY2hha3lSZTk4SVA0ZExubzZRZGlXZVNY?=
 =?utf-8?B?ZWJiRjdHN1ZLQlZEejNtRUx3OG4wR3hFTldIY2NZTFdIMDNMMDR4OG5kbU1O?=
 =?utf-8?B?Um93UGN6ZlU5QW9LZjVST2JJVzRsaDZwaVZPbXpjUTNncldzbnpLVUo2OVlZ?=
 =?utf-8?B?aXJNMFI2U0l0YTMrWUFUSjdrUC9YdVVPZW0vOFhtakphNE11cEFzT3hHWVRE?=
 =?utf-8?B?ZFhjREtsdk8zZ293MjdLdFNWSjM3d3VDZ2Vqd2NiTnNwYkxLQ25CYnZCWWxG?=
 =?utf-8?B?VVBvVTd5RUh3NUFrenFZS1VlTzd6VzcrWVVrWkQvRXgzWXdUYWcvNFNnRVlE?=
 =?utf-8?B?OSt6ZTB3V1FMNlhuREtDNTlxREUrWm8zSXdYQ1hCK3RIenZwOGErS1pRdWFp?=
 =?utf-8?B?L0JlVnoxWFQzUGJvRFVTRkh3cTdGeGYzZ29Ob2JxY2JuWStheUh3b0JwVGlB?=
 =?utf-8?B?UFJibWxSN0Z1bisyMzBNQUM2NE1rNHJJdmRzV3prc3cySFJpV3pRbTlUZS8r?=
 =?utf-8?B?NmhZd1N3K2ZSc0krT214bkRDUUw2Z09wZUFlMExUN2lyT2RZWjZoUjM1R3BY?=
 =?utf-8?B?cjR3TlJlWnRGamZxVUVreko2STNFZDdtdG5ONTNzUjdZTkI0c2JJYzRhYTBN?=
 =?utf-8?B?QllpeDhuQ3N4d3NkL1FPYTNTTC9iUW4vRmN5cG55VUpJOWFmMHZDOHZHbm9u?=
 =?utf-8?Q?0l0suQNuUYJpaH+ftAtbSCy3JB1DIWbUlWrrG30Bbglfr?=
x-ms-exchange-antispam-messagedata-1: ZSfVpPBXj/SA4OjBy5Wi3RblkLTT893lbc58vDQh9kYYS7pQOQI7M4k/
Content-Type: text/plain; charset="utf-8"
Content-ID: <E666D9BF73F8F04A86E7A452D491767B@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b0f662-e92b-4f20-1def-08da2a1c061b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 20:08:27.5925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bu0VIxallsHyaRnF4j26bC12aWV4qiC0XOq6VPOZ/83DnHGqXZ5VXGZLnPO82DHmLbLygjQsbN73r7fkAHhps4zQ5TnLMF+dJpCLQMWwyOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6619
X-Proofpoint-GUID: rLumYy2uk9ZZFfE4M-b-xToXFbaJZvqd
X-Proofpoint-ORIG-GUID: rLumYy2uk9ZZFfE4M-b-xToXFbaJZvqd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_09,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDI5LCAyMDIyLCBhdCAzOjMyIFBNLCBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFs
aWVuOC5kZT4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIEFwciAyOSwgMjAyMiBhdCAwNTozMToxNlBN
ICswMDAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gU2VsZnRlc3RzIElJVUMsIGJ1dCB0aGVyZSBt
YXkgYmUgb3RoZXIgVk1NcyB0aGF0IGRvIGZ1bm55IHN0dWZmLiBTYWlkDQo+PiBhbm90aGVyIHdh
eSwgSSBkb27igJl0IHRoaW5rIHdlIGFjdGl2ZWx5IHJlc3RyaWN0IHVzZXIgc3BhY2UgZnJvbSBk
b2luZw0KPj4gdGhpcyBhcyBmYXIgYXMgSSBrbm93Lg0KPiANCj4gInNlbGZ0ZXN0cyIsICJ0aGVy
ZSBtYXkgYmUiPyENCj4gDQo+IFRoaXMgZG9lc24ndCBzb3VuZCBsaWtlIGEgcmVhbC1saWZlIHVz
ZSBjYXNlIHRvIG1lIGFuZCB3ZSBkb24ndCBkbw0KPiBjaGFuZ2VzIGp1c3QgYmVjYXVzZS4gU29y
cnkuDQoNCkkgYXBwcmVjaWF0ZSB5b3VyIGRpcmVjdCBmZWVkYmFjaywgdGhhbmsgeW91IGZvciBo
ZWxwaW5nIGhlcmUuDQoNCkxldOKAmXMgc2VwYXJhdGUgdGhlIGRpc2N1c3Npb24gaW50byB0d28g
cGFydHMuIA0KMTogQnVnIEZpeGluZyAtPiBhbiBJQlBCIGlzIGJlaW5nIHVuY29uZGl0aW9uYWxs
eSBpc3N1ZWQgZXZlbiB3aGVuDQp0aGUgdXNlciBzZWxlY3RzIGNvbmRpdGlvbmFsLiBUaGF0IG5l
ZWRzIHRvIGJlIGZpeGVkIGFuZCB0aGlzIHBhdGNoIGZpeGVzDQp0aGF0Lg0KDQoyOiBEZXNpZ24g
LT4gZG8gd2UgZXZlbiB3YW50IHRvIGhhdmUgdGhpcyBJQlBCIGhlcmUgaW4gS1ZNIGF0IGFsbD8N
Cg0KSW4gcHJldmlvdXMgZGlzY3Vzc2lvbnMgKHYxL3YyIHBhdGNoKSB3aXRoIFNlYW4sIHdlIHRh
bGtlZCBhYm91dCB0aGlzDQpub3QgbWFraW5nIGEgd2hvbGUgbG90IG9mIHNlbnNlIGluIGdlbmVy
YWw7IGhvd2V2ZXIsIHdlIGxhbmRlZCBvbg0KdHJ5aW5nIHRvIG5vdCByZWdyZXNzIHVzZXJzIHdo
byBtaWdodCwgZm9yIHdoYXRldmVyIHJlYXNvbiwgY2FyZSBhYm91dCANCnRoaXMgSUJQQi4NCg0K
SeKAmXZlIHNoYXJlZCBhIGJpdCBtb3JlIGRldGFpbCBvbiBvdXIgdXNlIGNhc2UgYmVsb3cuIEni
gJltIGZpbmUgd2l0aCBudWtpbmcNCnRoaXMgSUJQQiBlbnRpcmVseSwganVzdCB3YW50IHRvIGJl
IG1pbmRmdWwgb2YgdXNlIGNhc2VzIGZyb20gdGhlIHJlc3Qgb2YNCnRoZSBjb21tdW5pdHkgdGhh
dCB3ZSBtaWdodCBub3Qgbm9ybWFsbHkgY3Jvc3MgaW4gb3VyIGRheSB0byBkYXkuDQoNCknigJlt
IGhhcHB5IHRvIHRha2UgZmVlZGJhY2sgb24gdGhpcyBhbmQgaW50ZWdyYXRlIGl0IGludG8gYSB2
NCBwYXRjaCBmb3INCmJvdGggb2YgdGhlc2UgcGFydHMsIGluIHRlcm1zIG9mIGJvdGggY29kZSBh
bmQgY29ycmVjdG5lc3MgaW4gdGhlIGNoYW5nZQ0KbG9nLg0KDQo+IA0KPj4gVGhlIHBhcmFub2lk
IGFzcGVjdCBoZXJlIGlzIEtWTSBpcyBpc3N1aW5nIGFuICphZGRpdGlvbmFsKiBJQlBCIG9uDQo+
PiB0b3Agb2Ygd2hhdCBhbHJlYWR5IGhhcHBlbnMgaW4gc3dpdGNoX21tKCkuIA0KPiANCj4gWWVh
aCwgSSBrbm93IGhvdyB0aGF0IHdvcmtzLg0KPiANCj4+IElNSE8gS1ZNIHNpZGUgSUJQQiBmb3Ig
bW9zdCB1c2UgY2FzZXMgaXNu4oCZdCByZWFsbHkgbmVjZXNzYXJpbHkgYnV0IA0KPj4gdGhlIGdl
bmVyYWwgY29uY2VwdCBpcyB0aGF0IHlvdSB3YW50IHRvIHByb3RlY3QgdkNQVSBmcm9tIGd1ZXN0
IEENCj4+IGZyb20gZ3Vlc3QgQiwgc28geW91IGlzc3VlIGEgcHJlZGljdGlvbiBiYXJyaWVyIG9u
IHZDUFUgc3dpdGNoLg0KPj4gDQo+PiAqaG93ZXZlciogdGhhdCBwcm90ZWN0aW9uIGFscmVhZHkg
aGFwcGVucyBpbiBzd2l0Y2hfbW0oKSwgYmVjYXVzZQ0KPj4gZ3Vlc3QgQSBhbmQgQiBhcmUgbGlr
ZWx5IHRvIHVzZSBkaWZmZXJlbnQgbW1fc3RydWN0LCBzbyB0aGUgb25seSBwb2ludA0KPj4gb2Yg
aGF2aW5nIHRoaXMgc3VwcG9ydCBpbiBLVk0gc2VlbXMgdG8gYmUgdG8g4oCca2lsbCBpdCB3aXRo
IGZpcmXigJ0gZm9yIA0KPj4gcGFyYW5vaWQgdXNlcnMgd2hvIG1pZ2h0IGJlIGRvaW5nIHNvbWUg
dG9tZm9vbGVyeSB0aGF0IHdvdWxkIA0KPj4gc29tZWhvdyBieXBhc3Mgc3dpdGNoX21tKCkgcHJv
dGVjdGlvbiAoc3VjaCBhcyBzb21laG93IA0KPj4gc2hhcmluZyBhIHN0cnVjdCkuDQo+IA0KPiBZ
ZWFoLCBubywgdGhpcyBhbGwgc291bmRzIGxpa2Ugc29tZXRoaW5nIGhpZ2hseSBoeXBvdGhldGlj
YWwgb3IgdGhlcmUncw0KPiBhIHVzZSBjYXNlIG9mIHdoaWNoIHlvdSBkb24ndCB3YW50IHRvIHRh
bGsgYWJvdXQgcHVibGljbHkuDQoNCldl4oCZcmUgYW4gb3BlbiBib29rIGhlcmUsIHNvIEnigJlt
IGhhcHB5IHRvIHNoYXJlIHdoYXQgd2XigJlyZSB1cCB0bw0KcHVibGljbHkuIE91ciB1c2UgY2Fz
ZSBpcyAxMDAlIHFlbXUta3ZtLCB3aGljaCBpcyBhbGwgc2VwYXJhdGUgDQpwcm9jZXNzZXMvc3Ry
dWN0cyBhbmQgaXMgY292ZXJlZCBhLW9rIGJ5IHRoZSBzd2l0Y2hfbW0oKSBwYXRoLiBXZQ0Kbm90
aWNlZCB0aGlzIGJ1ZyBpbiBvbmUgb2Ygb3VyIHNjYWxhYmlsaXR5IHRlc3RzLCB3aGljaCBvdmVy
c3Vic2NyaWJlcw0KdGhlIGhvc3Qgd2l0aCBtYW55IDIgdkNQVSBWTXMgYW5kIHJ1bnMgYSBsb2Fk
IHJ1bm5lciB0aGF0IGluY3JlYXNlcw0KbG9hZCBvbmUgbWFjaGluZSBhdCBhIHRpbWUsIHNvIHRo
YXQgd2UgY2FuIHNlZSB0aGUgdHJlbmQgb2YgcmVzcG9uc2UNCnRpbWUgb2YgYW4gYXBwIGFzIGhv
c3QgbG9hZCBpbmNyZWFzZXMuIA0KDQpHaXZlbiB0aGF0IHRoZSBob3N0IGlzIGhlYXZpbHkgb3Zl
cnN1YnNjcmliZWQsIHRoZXJlIGlzIGEgbG90IG9mDQp2Q1BVIHN3aXRjaGluZywgYW5kIGluIHBh
cnRpY3VsYXIgc3dpdGNoaW5nIGluIGJldHdlZW4gdkNQVXMgDQpiZWxvbmdpbmcgdG8gZGlmZmVy
ZW50IGd1ZXN0cywgc28gdGhhdCB3ZSBoaXQgdGhpcyBwYXJ0aWN1bGFyIGJhcnJpZXIgaW4gDQp2
Y3B1X2xvYWQgY29uc3RhbnRseS4gVGFraW5nIHRoaXMgZml4IGhlbHBlZCBzbW9vdGhlZCBvdXQg
dGhhdCByZXNwb25zZQ0KdGltZSBjdXJ2ZSBhIGJpdC4gSGFwcHkgdG8gc2hhcmUgbW9yZSBzcGVj
aWZpYyBkYXRhIGlmIHlvdeKAmWQgbGlrZS4NCg0KPiANCj4gRWl0aGVyIHdheSwgZnJvbSB3aGF0
IEknbSByZWFkaW5nIEknbSBub3QgaW4gdGhlIGxlYXN0IGNvbnZpbmNlZCB0aGF0DQo+IHRoaXMg
aXMgbmVlZGVkLg0KPiANCj4gLS0gDQo+IFJlZ2FyZHMvR3J1c3MsDQo+ICAgIEJvcmlzLg0KPiAN
Cj4gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19w
ZW9wbGUua2VybmVsLm9yZ190Z2x4X25vdGVzLTJEYWJvdXQtMkRuZXRpcXVldHRlJmQ9RHdJRGFR
JmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT10Y3RV
WTN6Z1lFd1VjUFo4RTh2LUVpWGxvSzRQd1l2VVZCbFItYW1vUkJFVlp5bTZhMlN1cXlSWWJOR0Yx
X2FaJnM9bFFqeTloM0c2ZU9xcjJxRXVBVnZ0WDNMdUR4VzFrVkpIZGxrZXpDeTNzVSZlPSANCg0K
