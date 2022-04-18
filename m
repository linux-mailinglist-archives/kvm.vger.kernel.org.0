Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EF5505E90
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 21:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiDRTh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236352AbiDRTh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 15:37:56 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B69538B1;
        Mon, 18 Apr 2022 12:35:16 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23IJW2ke004540;
        Mon, 18 Apr 2022 12:34:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=aOm3fGn6AgnXdBz7cq8BLQyboorMiDRrWfLUqGD5hdY=;
 b=UowIXER6mzo3eb08iUcJciRG51mba8BhBkekCXNhq20wKwbirN+vkrFiHL9lGHw1b0my
 /fdKmlWYhcpvuv/1sZNVYFOsvJmc41JAWQ1emhmYr72SFb3rbFSZAUQVsFkxiAtZhldB
 5VYMKv4J5fhH/f59SL9ENJLe0RLoVEuYLp7qVERcTJrREUoXMxxuq3EaihGAYWTCaJwM
 ez9yIsmGs9WNthxHOAf/QPtwbQZ7QrOidouU8ZMBgNwXYHrCERtlzPFw6ywf8aHSH9py
 N5l2Q2pYO8uC7sdj3FY6iV0PAtDo16oqLVe2K60wGzTNe9TKWX/dZuMF4lumEWWWgGer rg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ffsq7v219-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Apr 2022 12:34:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+svhv1uACcEExDveKuqD+lGNfvZp/jdPX0J+9mjVxTrPp97yStJw15jBf4AToBpvNNQ4kkGsyN6s9CY2TQ9zETXPErl4tGyOMZaJVfwM2SWQMpos7D+dPHNDfuaEYqi4OdhFvQxKxFvVPJK0cYsRJVxKHu+1BiAKtZ9SlEmW7ODq6XvXxRCQueVxNJgvrhSvaz+ioIwksnD2RlCoOWMrlRZTbGw3N/EU/yGsT1fQiOkUyGf1VNDTJbtUa8hYi0XN7dDfOmYTG1nf+wEJ3/Jjj7qQvxBpMyIVQYgkiRVMQOOqfAXqIeKjLebsRJoG3sQGPEx8q384FSRTcc1zFdwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOm3fGn6AgnXdBz7cq8BLQyboorMiDRrWfLUqGD5hdY=;
 b=GtH0GfxczVEzPUpD//lTSrOT4+SCbwVSnG3ifnEPo83pLmN4Ipv0zWKgdsSFsqQ6A1Pp9Ct4mfEEqhGlri4ryxZGtKHFCq5lBy0PHOJW+jFwOqq60o8w6jANaJa74Aex8edYsCrXaeEAz4MocX9jFKD8gKveJU2Edve46jZuFYeV/opdndkAHhisdwVMrcBjU7R/Uh4iPHa3oUNuak576Nf2OLyZAOKXEzQW+JpOw3EoAT0/YSoGWGPzosdfQt6IUp41q5vGl4jCuyD+OAf9qkXflZE4SEeYYDKBZvfLYzlmcNKh9Mq13I1JnozzABFsZy7+ymnY+3c8EFg6dwfBjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM8PR02MB7976.namprd02.prod.outlook.com (2603:10b6:8:15::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Mon, 18 Apr
 2022 19:34:06 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 19:34:06 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>,
        Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>
Subject: Re: [PATCH] x86/speculation, KVM: respect user IBPB configuration
Thread-Topic: [PATCH] x86/speculation, KVM: respect user IBPB configuration
Thread-Index: AQHYTcPBRnR1XLGIiE+ok0dVTwth9KzxDpyAgAAMyoCABMuqAIAAM++A
Date:   Mon, 18 Apr 2022 19:34:05 +0000
Message-ID: <DED31C6F-C0B0-4F62-B80D-E50459EEC17E@nutanix.com>
References: <20220411164636.74866-1-jon@nutanix.com>
 <YlmBC6gaGRrAZm3L@google.com>
 <0AB658FD-FA01-4D27-BA17-C3001EC6EA00@nutanix.com>
 <Yl2RnIjUTfQ0Avc9@google.com>
In-Reply-To: <Yl2RnIjUTfQ0Avc9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2510219b-0887-42bb-cc6e-08da217266bd
x-ms-traffictypediagnostic: DM8PR02MB7976:EE_
x-microsoft-antispam-prvs: <DM8PR02MB79767FC7AF2B22F0F35D0682AFF39@DM8PR02MB7976.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E889lK8mSfJzF0YBtv7vVo+UkSmYJiz3xOeGY1pB8fdYxN2qH7gpNZvvQeEsDO3XXo3RK0jq/zoUbVnhP/WgTEc8+flv/ptJvd+AG9kFWDBY1q3yp8N2RR8NB1E0nG/TB7aWahiuPEPaJJSxCujW7bXpxHXqpCc/fGVMnU9yNHpExoKem1kdilJ1fXzq0Ccy9S1esMkUEdHKptGSzi21ii+RRw1qdC2enD+cI5hsYHEFf3YVN/dkfJKnE4sdE1zTwTOO+CMepVNz+aHpaPPYtY+4Ex2FcJvAUVA4uSMhbogt48EZ6BKHIcoxkK8vZmwc1hyR3xLbX9bQlvC0ESaEparL+j3hrBXPfh8sBHVJQbplUTPd1H9+i7qNptbbHsDBS5D2I2xlFPtiko/1VSASxK+b8NRjzzuhEKJsbHgVDFqK9Y9R+S0Jlvn/OanlUDe6k0BuETL32aCmCb2d23kIY8l9A5h3t0xB0/P0jqfuJV/DA27lzj6sMTgh+rc7/Or38ku1Brh67GexvFg4Jr9Ugm3vrUAQzqu5LJ4SN8UFtgp7r0PFedcrCk+O9HvA4PvRU1LzShfcEYRUU0pZdvF3XeGk6Mgi/Jae6qPvZsXU9jjH3sWmbfzrru5pbzSLqpgJp8HX0msKShttKhHn/zBp9awXqe8RTaZ88hgk/lZq4OwuTpq1P5UmRi8NhYhUBVBFRb912Blck/Wco73Y+fm75tnO0Cfg+0JbrgTsHRpM7Ph4TttfMeIUXAGvqI8I4qjf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(107886003)(66556008)(66476007)(64756008)(38070700005)(38100700002)(186003)(86362001)(83380400001)(36756003)(7416002)(8936002)(66946007)(8676002)(4326008)(6512007)(91956017)(53546011)(66446008)(76116006)(5660300002)(2906002)(71200400001)(508600001)(33656002)(6486002)(316002)(122000001)(6506007)(6916009)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UldWajZMenlxOUlKN0dEdHNUS29HY0RLUU5kREswSWNjbTM2dkFkYnJsR0FQ?=
 =?utf-8?B?WkVVZTFZVXRqSkRGRzQyM0tZUmxRTVE2aFF5WC8rVGU2VlY1Q2dDRjYzTWUy?=
 =?utf-8?B?aVpCZkxka2pBMThoVWhwOW15MGRUVjlvVGNWNDZCQURiM083Q1pOU3U3TGFV?=
 =?utf-8?B?SUdlcVlYSkpYei9Ubkl2RUZLbWg4bUpuYlFWMlVLa0x1RUtZMnp2Um5oOCto?=
 =?utf-8?B?UHgxSmptQkhuSWJCeXZ1ZnVKc1M2cmtoeVpPd2crUHl4NWV1bjR1WlorbnFZ?=
 =?utf-8?B?b1BrTUJEeS9IYzBOWkloc2JEZVFNTWVEMDdKNmlSd1RjV2ZRQXBjQjl4aWNF?=
 =?utf-8?B?TkRnMmRIL2Rxa3lCRDA0RzRCNlNkSlBYNXplNzFaWGJ1MUZqK3hkcitUWWpl?=
 =?utf-8?B?RDk2d0l4bG55TlV6S2cxVkZsOXhXc0VocjZ3YWl6c1RWcDZpRXpYTTM4RnNG?=
 =?utf-8?B?V2JnOTdpaFV1ZXhyOHF2NTNHb1ZUOWY2cHNrVlhVUmQ4WVdhcHFBRmJETDZj?=
 =?utf-8?B?Zk4yV3hYMW5UdXc5RDVqbG05NjNaTndweUpCeVFtVytDVGNUYWhvS1BQK3R3?=
 =?utf-8?B?Rnk0eUpyOFlTSUhXRUhVelE1SDVSb1dhMDFlZDlobnp0a1V6dFAybWJ3K0g2?=
 =?utf-8?B?bEQxNHVCdjFiVm1tR1paRjF1dHYwY3llWjlZeXV2bmNjWXNwTmZ5OEJGbVpK?=
 =?utf-8?B?VjZGb3VFRzJmSVNWSVE3OHdsOUxyRnNMZ0U4V3FvU0IyT0pqdDR2Z2szRVl5?=
 =?utf-8?B?QzZmY05ZOThiUzNLaEVhRnJ1VWhWZHZ4bGdLTmVZRk1zY1dDcWhNaG93UzUy?=
 =?utf-8?B?YXVRVUpyc0NWV0tCWVNiRVYzQmxudnVjN0Q4NjhJeWgydlE1enkwU3pOZlpN?=
 =?utf-8?B?cmlUTHQrNWtiTXFNUTY1bnRSRjlONCt3UnFRMFpCbUMrSEhic1RnN1JuaXk2?=
 =?utf-8?B?blhZcDZoZm1BR3ArQjdCaWlJUUJaa2VOMVo0c0g4eXNuT3IveTRWbVNnSXdq?=
 =?utf-8?B?QTN3elBvd1ZlYmM4YnNGb1ZpQjlCbjRGZklRV08wR20xNjVHeDhtZzhmeUI5?=
 =?utf-8?B?TjBHTkoyaTZNa01MN25yaGVjMnVXaEZlS3ZQMXZmSmh0UExyY1NvK3I5Q0l1?=
 =?utf-8?B?bUQ0ZlYvUUM4dVp6am9JdVNpV0xidkRXVjJ0TitRczZhVWFJZmJwOGtoNDNF?=
 =?utf-8?B?QnQvOWlJYkNjVVErQllVUVl0S0gwUk13Wm5yd1pUSnptT2tid3c5ZTBIcFlC?=
 =?utf-8?B?N1pRek13RE56MnFjbHFqa0FJeFF5RkJ6YjNsckl1RHd0TUgxUzZ1S3hIcXcy?=
 =?utf-8?B?NWhMaGVBTFdrL1B6eForRlU5MHgrQ2tvZ3NjMTBCWit3N1l2YWZLb0dwNXYy?=
 =?utf-8?B?R2FSUlJlZk8wbVFyTXRvUHB2WjIwZ3d1b2o1bk1hL2dicEVsMnNxQllSKzFC?=
 =?utf-8?B?aklDRkljVWhMaTFTdHZuN2NmN0lwTkc5eklsUDNQZUVVRzNVMlUvTU1QcWl5?=
 =?utf-8?B?S3hKMTRuWExMNmllKzV4ejdWQXJJOHNub1NUK1p1K0wySWRiVS9TNjVOM25V?=
 =?utf-8?B?bThLaXpmOWdhSm9HcWJzNUlBSElwYU52VklEMmR3L1hxZ1ZHZWlubEY3TVFD?=
 =?utf-8?B?MkNKUjdzVFFpSnZTbHlpNHB0d05SMlNQTW42UXFWcHNkb2JtQnJhN25jNG9r?=
 =?utf-8?B?ck44QUdYblZhY3FPWXRGaUliUHREUGpMS3FDQlpuNlpMNnZXVE5rampKV0xG?=
 =?utf-8?B?eDlzTmtqYkR5VzBZbGE1UGoydCtadjl3YjFXRWc5dGxSZVhQV1BrbWdFNjZF?=
 =?utf-8?B?ekV6KzlUQ2NiQ2JoTGd0YVNrYjl3ZjgwUllnSVZsYUt4RCt1ZG5wd0FSNzhj?=
 =?utf-8?B?S2tRMkJURlM5dTFPeHVSWGN6blBaZ052TzgrRERpdnluS0VlMkhKL0ZUczRW?=
 =?utf-8?B?T2JrUDZ1eGpoV0ljT2VwcVU3cUpDRG9ONTFVM3IreGJlcUE5bFNLTkQ5RWlD?=
 =?utf-8?B?YmJIKzltaUtYRUZLMFVTRExRdmdMdXN6cnpYRUpxdHBSeGtycG4wenU2STJk?=
 =?utf-8?B?bGljRXNxZ3NoenV3SGVZRFlZNWpsN1lMQk9YUGRCUzFhb0xKYjVjT0RKSVZL?=
 =?utf-8?B?MEd4MU16VEJUSkwzWTZHbTNKbkJVWVRCeDlEQWh2S2VyZlZvTk1DOHBQL1h3?=
 =?utf-8?B?Zm5sVTBNZUpHdHVhUkhRcVJBRlc2Slh5aEFramdjQU9HZDB3MUFCU2NGMlNB?=
 =?utf-8?B?WTN2VmhhTHp5ZURGUUsxVWNiMWZ2cWp1K1pSODEzMzhIOVQ1d2VBRUlRQ25i?=
 =?utf-8?B?bkZtNmp0cVVHTTZPZnh1ek1WYXdGWE5MSGNYOHNNK2Jza1BGQnl5bmRWVksr?=
 =?utf-8?Q?2YN8Mm36Cqn0ii88UPFaxTJRgqqt67F0em9CqoIU1D33e?=
x-ms-exchange-antispam-messagedata-1: YSntIvCRtssvG0WoT8NpGrGriSk/LIpBUiYB7U3dRx1Clt8hHUBTLcOr
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1C740E100B7484EA4CE8B50AB49A5DE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2510219b-0887-42bb-cc6e-08da217266bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 19:34:05.8955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: js3gVGq/VILlQb5SnWNVzuzCwcarq5SfhbQQgVQnQ66asbkNiF1TqnQDJ6kowYvw5skIRpNzOID8MOoKN7Q6H1b1QUayi5eDALDZ4+B8LnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB7976
X-Proofpoint-GUID: 5wuAwK5YDn3xlvg_7MMyS3M9HcrkFvNO
X-Proofpoint-ORIG-GUID: 5wuAwK5YDn3xlvg_7MMyS3M9HcrkFvNO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
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

DQoNCj4gT24gQXByIDE4LCAyMDIyLCBhdCAxMjoyOCBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBBcHIgMTUsIDIwMjIsIEpv
biBLb2hsZXIgd3JvdGU6DQo+PiANCj4+PiBPbiBBcHIgMTUsIDIwMjIsIGF0IDEwOjI4IEFNLCBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4gQnV0IHN0
ZXBwaW5nIGJhY2ssIHdoeSBkb2VzIEtWTSBkbyBpdHMgb3duIElCUEIgaW4gdGhlIGZpcnN0IHBs
YWNlPyAgVGhlIGdvYWwgaXMNCj4+PiB0byBwcmV2ZW50IG9uZSB2Q1BVIGZyb20gYXR0YWNraW5n
IHRoZSBuZXh0IHZDUFUgcnVuIG9uIHRoZSBzYW1lIHBDUFUuICBCdXQgdW5sZXNzDQo+Pj4gdXNl
cnNwYWNlIGlzIHJ1bm5pbmcgbXVsdGlwbGUgVk1zIGluIHRoZSBzYW1lIHByb2Nlc3MvbW1fc3Ry
dWN0LCBzd2l0Y2hpbmcgdkNQVXMsDQo+Pj4gaS5lLiBzd2l0Y2hpbmcgdGFza3MsIHdpbGwgYWxz
byBzd2l0Y2ggbW1fc3RydWN0cyBhbmQgdGh1cyBkbyBJUEJQIHZpYSBjb25kX21pdGlnYXRpb24u
DQo+PiANCj4+IEdvb2QgcXVlc3Rpb24sIEkgY291bGRu4oCZdCBmaWd1cmUgb3V0IHRoZSBhbnN3
ZXIgdG8gdGhpcyBieSB3YWxraW5nIHRoZSBjb2RlIGFuZCBsb29raW5nDQo+PiBhdCBnaXQgaGlz
dG9yeS9ibGFtZSBmb3IgdGhpcyBhcmVhLiBBcmUgdGhlcmUgVk1NcyB0aGF0IGV2ZW4gcnVuIG11
bHRpcGxlIFZNcyB3aXRoaW4NCj4+IHRoZSBzYW1lIHByb2Nlc3M/IFRoZSBvbmx5IGNhc2UgSSBj
b3VsZCB0aGluayBvZiBpcyBhIG5lc3RlZCBzaXR1YXRpb24/DQo+IA0KPiBTZWxmdGVzdHM/IDot
KQ0KDQpBaCEgSeKAmWxsIHRha2UgYSBtdWxsaWdhbiwgSSB3YXMgb25seSB0aGlua2luZyBhYm91
dCBydW4gb2YgdGhlIG1pbGwgdXNlciBzdHVmZiwgbm90IHRoZSB0ZXN0cywgdGh4Lg0KDQo+IA0K
Pj4+IElmIHVzZXJzcGFjZSBydW5zIG11bHRpcGxlIFZNcyBpbiB0aGUgc2FtZSBwcm9jZXNzLCBl
bmFibGVzIGNvbmRfaXBicCwgX2FuZF8gc2V0cw0KPj4+IFRJRl9TUEVDX0lCLCB0aGVuIGl0J3Mg
YmVpbmcgc3R1cGlkIGFuZCBpc24ndCBnZXR0aW5nIGZ1bGwgcHJvdGVjdGlvbiBpbiBhbnkgY2Fz
ZSwNCj4+PiBlLmcuIGlmIHVzZXJzcGFjZSBpcyBoYW5kbGluZyBhbiBleGl0LXRvLXVzZXJzcGFj
ZSBjb25kaXRpb24gZm9yIHR3byB2Q1BVcyBmcm9tDQo+Pj4gZGlmZmVyZW50IFZNcywgdGhlbiB0
aGUga2VybmVsIGNvdWxkIHN3aXRjaCBiZXR3ZWVuIHRob3NlIHR3byB2Q1BVcycgdGFza3Mgd2l0
aG91dA0KPj4+IGJvdW5jaW5nIHRocm91Z2ggS1ZNIGFuZCB0aHVzIHdpdGhvdXQgZG9pbmcgS1ZN
J3MgSUJQQi4NCj4+IA0KPj4gRXhhY3RseSwgc28gbWVhbmluZyB0aGF0IHRoZSBvbmx5IHRpbWUg
dGhpcyB3b3VsZCBtYWtlIHNlbnNlIGlzIGZvciBzb21lIHNvcnQgb2YgbmVzdGVkDQo+PiBzaXR1
YXRpb24gb3Igc29tZSBvdGhlciBmdW5reSBWTU0gdG9tZm9vbGVyeSwgYnV0IHRoYXQgbmVzdGVk
IGh5cGVydmlzb3IgbWlnaHQgbm90IGJlIA0KPj4gS1ZNLCBzbyBpdCdzIGEgZmFyY2UsIHllYT8g
TWVhbmluZyB0aGF0IGV2ZW4gaW4gdGhhdCBjYXNlLCB0aGVyZSBpcyB6ZXJvIGd1YXJhbnRlZQ0K
Pj4gZnJvbSB0aGUgaG9zdCBrZXJuZWwgcGVyc3BlY3RpdmUgdGhhdCBiYXJyaWVycyB3aXRoaW4g
dGhhdCBwcm9jZXNzIGFyZSBiZWluZyBpc3N1ZWQgb24NCj4+IHN3aXRjaCwgd2hpY2ggd291bGQg
bWFrZSB0aGlzIHNlY3VyaXR5IHBvc3R1cmUganVzdCB3aW5kb3cgZHJlc3Npbmc/DQo+PiANCj4+
PiANCj4+PiBJIGNhbiBraW5kYSBzZWUgZG9pbmcgdGhpcyBmb3IgYWx3YXlzX2licGIsIGUuZy4g
aWYgdXNlcnNwYWNlIGlzIHVuYXdhcmUgb2Ygc3BlY3RyZQ0KPj4+IGFuZCBpcyBuYWl2ZWx5IHJ1
bm5pbmcgbXVsdGlwbGUgVk1zIGluIHRoZSBzYW1lIHByb2Nlc3MuDQo+PiANCj4+IEFncmVlZC4g
SeKAmXZlIHRob3VnaHQgb2YgYWx3YXlzX2licGIgYXMgInBhcmFub2lkIG1vZGUiIGFuZCBpZiBh
IHVzZXIgc2lnbnMgdXAgZm9yIHRoYXQsDQo+PiB0aGV5IHJhcmVseSBjYXJlIGFib3V0IHRoZSBm
YXN0IHBhdGggLyBwZXJmb3JtYW5jZSBpbXBsaWNhdGlvbnMsIGV2ZW4gaWYgc29tZSBvZiB0aGUN
Cj4+IHNlY3VyaXR5IHN1cmZhY2UgYXJlYSBpcyBqdXN0IGNvbXBsZXRlIHdpbmRvdyBkcmVzc2lu
ZyA6KCANCj4+IA0KPj4gTG9va2luZyBmb3J3YXJkLCB3aGF0IGlmIHdlIHNpbXBsaWZpZWQgdGhp
cyB0byBoYXZlIEtWTSBpc3N1ZSBiYXJyaWVycyBJRkYgYWx3YXlzX2licGI/DQo+PiANCj4+IEFu
ZCBkcm9wIHRoZSBjb25k4oCZcywgc2luY2UgdGhlIHN3aXRjaGluZyBtbV9zdHJ1Y3RzIHNob3Vs
ZCB0YWtlIGNhcmUgb2YgdGhhdD8NCj4+IA0KPj4gVGhlIG5pY2UgcGFydCBpcyB0aGF0IHRoZW4g
dGhlIGNvbmRfbWl0aWdhdGlvbigpIHBhdGggaGFuZGxlcyB0aGUgZ29pbmcgdG8gdGhyZWFkDQo+
PiB3aXRoIGZsYWcgb3IgZ29pbmcgZnJvbSBhIHRocmVhZCB3aXRoIGZsYWcgc2l0dWF0aW9uIGdy
YWNlZnVsbHksIGFuZCB3ZSBkb27igJl0IG5lZWQgdG8NCj4+IHRyeSB0byBkdXBsaWNhdGUgdGhh
dCBzbWFydHMgaW4ga3ZtIGNvZGUgb3Igc29tZXdoZXJlIGVsc2UuDQo+IA0KPiBVbmxlc3MgdGhl
cmUncyBhbiBlZGdlIGNhc2Ugd2UncmUgb3Zlcmxvb2tpbmcsIHRoYXQgaGFzIG15IHZvdGUuICBB
bmQgaWYgdGhlDQo+IGFib3ZlIGlzIGNhcHR1cmVkIGluIGEgY29tbWVudCwgdGhlbiB0aGVyZSBz
aG91bGRuJ3QgYmUgYW55IGNvbmZ1c2lvbiBhcyB0byB3aHkNCj4gdGhlIGtlcm5lbC9LVk0gaXMg
Y29uc3VtaW5nIGEgZmxhZyBuYW1lZCAic3dpdGNoX21tIiB3aGVuIHN3aXRjaGluZyB2Q1BVcywg
aS5lLg0KPiB3aGVuIHRoZXJlIG1heSBvciBtYXkgbm90IGhhdmUgYmVlbiBhIGNoYW5nZSBpbiBt
bSBzdHJ1Y3RzLg0KDQpPayBncmVhdC4gSeKAmWxsIHdvcmsgdXAgYSB2MiBhbmQgc2VuZCBpdCBv
dXQuDQoNCg==
