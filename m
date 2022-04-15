Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFC4502C6C
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354902AbiDOPSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiDOPSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:18:40 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670098AE46;
        Fri, 15 Apr 2022 08:16:11 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FC0dwL032547;
        Fri, 15 Apr 2022 08:14:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=SLD058U7BbpH/eYl8EkuzbYzPExn0NcUb4jr5Ti5XWs=;
 b=FoJugQoNkQYhIQnSjKcRD44BIN0HmZG6x5jPzWwYYXm/EA3OTsZEEEkSegAIS8oeRNPB
 srp5GMS8ZJc+3c14hIflqfMq6s3jVTcjOvgtoUREIVAwSUFhAELxB0MOJJ7zPmUJS2eI
 Affw+zUPAxMmptgRYmVAiqjO7UHUjSOZzzxcnWWgDu67kocju5BquhkiZ+JYqECXKr86
 Iw7L1lTCXc0O8+8n7vi3rqRjvqyqUmWUbRSB51AeBPt2kppytLR1oT/o0onsW9zsaN6n
 kg/XXCQDBzYn00rV8vTihRjDblOAmw2EGwy2Ft0AXsa5O98Cb922A5PfZ2KqicLe7Bav kQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb7p6nv3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Apr 2022 08:14:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzNhvLFn+pAZo4xiOOgPAEnwUgTmc3nsl423NSr8PDnOpaQi045q2K5v7j9G55XcnFhMqC2okvDBTafsckGILqKBylecRkjS8UsXRM2A3oIoBx8vx8O/kemLTH9U3QRFLPiXMK+vfdV0Bd3hpSkahF1Z4w7fnfjDjldy9GG2deKjigQXbYJhjYyq4qNgmQug7XzbH8TO7SOJpDO6W2VA/E4IcB2ml6abxBVt1oCN/1MjNuRQmd0PTfaPFeQdAwerKhC95E5FembL2exTQ+Z+mNp2cSWV4ykR85UE5WIX3wAFHCIdkIk0mv1MMuZXNl58VRHKJLbQS4famhvZ+vxa5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLD058U7BbpH/eYl8EkuzbYzPExn0NcUb4jr5Ti5XWs=;
 b=FGwez61hSfpGCHuFysEchYPPWpd+XwBecpM7a8qir6Gab6WrDYwIxUeRViB4mnOEQW3+oYmEvEOAIKF/3sXldclofI2GeRxNPAfSQi05GtFQSyx8YzDH8v+yhxxhX7ntdDyCdep8S5fKBHUzDbOvCS3LApFjh5KrIF4Ofy8cs0Q3J3MdWfHW3Hxvh9ynV9i5R6+toAh5saJGWi0Rp3H1nzCDfUm3BDI3KKqPyei7GCF7liisxrUqOpVA/2GRVFWR73QIj/+1WT1VdFyERATZPTcAFeBMTBFwX0uLP7CSK4Q9zhONSJCrDALNhi88BIV+/MRVJMvbrr/VuR7ZCtQyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH2PR02MB6118.namprd02.prod.outlook.com (2603:10b6:610:7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 15:14:15 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 15:14:15 +0000
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
Thread-Index: AQHYTcPBRnR1XLGIiE+ok0dVTwth9KzxDpyAgAAMyoA=
Date:   Fri, 15 Apr 2022 15:14:15 +0000
Message-ID: <0AB658FD-FA01-4D27-BA17-C3001EC6EA00@nutanix.com>
References: <20220411164636.74866-1-jon@nutanix.com>
 <YlmBC6gaGRrAZm3L@google.com>
In-Reply-To: <YlmBC6gaGRrAZm3L@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cde16dee-bfa0-404e-1a49-08da1ef29ab7
x-ms-traffictypediagnostic: CH2PR02MB6118:EE_
x-microsoft-antispam-prvs: <CH2PR02MB6118324585DC54800B121D80AFEE9@CH2PR02MB6118.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hnrk/637xQVUoXpNHi3DBOtEOjVm5GgUD7qsqQVaGCFkbeHZ2O9BUO2NPytd1bx8cpiKBjSDDMe7HFJSZNY4VJFy7pMpj+/0DVvCobxlj1jTs7dchfSJSL8C5uFKHzcF3KEM3VBDNHHyfXZ2jD1G6EHh14JFAVcmAb8nxvdNdVGRarXo0euNIhz08rZivj0qcqi95WSe+9Ok6WAtVVES13SLmaF6vKPQQxCBzDkrqvDTMWWmj/FEVOBu3DlSojxK7n54yk7No3234f5w/IckLD81iGXvUot6CtOeqbcFD8X1iZWzkcKV8L1F7XaPjV+H5rElnXuEjTJCJlH3NxbApJ0/rOAB7v1ytB9bZksGOQOCREm0prhTW7nqw3zPcox4sI0AvjxM22RySuOQFFMS9Cf3GtwWdfx7Fur5klI3kgJl5xeBbZV2LxK0DPXjTkf6p784edDEyA1k2kAJxmMz+L/A3zAlBTIAsf0Uvu5cKB7CZCldcy8oeR0Yk/ygRXLu7nGNmw6ZZmeq6MyZIo+TuL39AhriPZH+9AD+/4Qv8K2WQCxfJxw0lEK8RdSkgWA7zBnG+JeEgmSwS0sq4rGPOJ46I5DXR+syajr4H35W9hgRQU9wNdqx7cHwOTElPnfAhAOt+uC33N88OpqnCMzVmRmgIQegcgPXZRGZCTO8Ppr56pwZOWOJ7hZTYcvX/PfBWPnfzj5KiTkjAI0h5hhs9184wU2p11p9I2OtujgWLCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(91956017)(36756003)(2906002)(38070700005)(122000001)(7416002)(38100700002)(66446008)(8676002)(76116006)(66556008)(5660300002)(66476007)(64756008)(4326008)(66946007)(8936002)(508600001)(6916009)(54906003)(33656002)(107886003)(2616005)(53546011)(186003)(71200400001)(6512007)(6486002)(83380400001)(6506007)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXlCVWVheDJaWkFKdjhHcTZyUjgxTmZQUHF5cXl3U29yQ3VzelBUZ005a21x?=
 =?utf-8?B?cUxrUHoyVTlrcXY0dVNqcE0wbmRCVVVRQlVZdlJjOENSN3hucGhGYVRGdWN0?=
 =?utf-8?B?SVVLWlNPOEw4WDViK0U2eFhweHRsa25pR0VOU05Kb0lhUmFUaXlGM0tDK05m?=
 =?utf-8?B?ZzlnOUtYTVhkSWIvbDRVaVcvYXVyZVpaUmptdXRvcm1PZ3FQRzhDRG1JMFNJ?=
 =?utf-8?B?dDBDYkNIcDJoenJyZlYxanFNZTJvU0V0WmRJV094ekYveUttc2hUei9HNk0z?=
 =?utf-8?B?ZVRuR0hFQVc5Z2FMUzN3dnVIekF3M29MRGlmSXJTL00rQ3lpZ3FSdk56OGZO?=
 =?utf-8?B?S1JHTERLOTNSVFhNMllxNmJBWUc5NHRkaFhIVW5uVmFKeXM0Z05IekVFbm5K?=
 =?utf-8?B?MFNWQlV2WTJORVVldFNtdkdHd0dSTCtzQTk5SHB3QWJmY2hpQityWTVRM2NJ?=
 =?utf-8?B?UUJtWlByWldTM1BteWZiOEQ0VHVrSzYyYksxTGRHUU5ueHJMNEN1M1VkbzRr?=
 =?utf-8?B?c1pzT29odGlYQkFMV0lZN0s0Nm85SVY0a21KNDl6Vm1sZjJ4OFg4ZlJOaHRS?=
 =?utf-8?B?QjJZZEdMaHl4emhkUlN6VVlUZ3ZNcW0xVkMvUHlTN3lPK2pzRlZPWnJNRDVU?=
 =?utf-8?B?VmI4ak41cmpGaloyTWtSRVNQdnc2azExV0Y0ZXNMdFFHc3djSUZYZWpiNEZY?=
 =?utf-8?B?a05jWWFLaGd2SGpDTXVQZUlPMDNKZWJVU2w1UVkyVEtkK0ZhMGY4eEVGc3o2?=
 =?utf-8?B?M2xZVWlvdElNblBNakhhK3ZGYkZRNU9GYTJnMlB5VXd6MWNwNXdIaHpLYTlB?=
 =?utf-8?B?V2E3OVRBeDFGZjI3Y1NYc3lPNUxhRm9vTE1xWHNvbEp4UXVZZlJuSkFuTERE?=
 =?utf-8?B?ODJPL2VUTHlNZmp0dDYyemdhT1htdExSaW5aOUhRSTRib3d2eGd3Sy9EVEQx?=
 =?utf-8?B?R25ReWsxT1dCQ3lsekpaMjRkNGdiazlaT3FwVlJCUjZWL3l5RDdaRnBPekpy?=
 =?utf-8?B?U1pwNVN0elYzM2JmU2gzZTh6T1hCNmV6YmNBU0dMUjY1bk16UExDRHQxK2RE?=
 =?utf-8?B?ckZFeVpGTVNESXpWbCtWa0lHVUQ2NTBWQWpMejU2anI0cEt5L3NnblNSYXNu?=
 =?utf-8?B?ZFZLeXcwa1JOVHRnVUV4ZGdKQ0JwSnUxZ05Dek5uT09Fa25ESk8rS1N0b2lp?=
 =?utf-8?B?MHU3eWNhdzVUa1NyN2RSL2s1dUl2WWJDQWVTQ2hENXcxM0ZOcTNadTRiWXV5?=
 =?utf-8?B?UzBLcVY3Smw3V3dqSndwN0IzL3QwR3h0eWlEZjkyWTNoWVIvZm1PSFNBL0xZ?=
 =?utf-8?B?Qkk0bko0SlVkSHEwM2Q4OEk4LzU5WTVJaWU0NlJFalBpckFjQTNxOW1uZmpF?=
 =?utf-8?B?VGFFNTRGNXFvUEpIVGtLSW8rS3FiaksxSk9qZExrbXV5blBpM3hqejVWdFJK?=
 =?utf-8?B?MU1qTzhUUnhYSmg3clFRT2xSTGE3VUlQZVdKeThLeHJvQnNVTW1ubWh2L0VV?=
 =?utf-8?B?ci9CdStkSkltR0krb0FhemI4MkpzUHc1TC83eXNuOXFpcE43YzR0R1VKTXlK?=
 =?utf-8?B?STRoS2VKTkFndXFqajRpMmF6QzJLUUVRUE1TSHNGOW0xRkl4dVpOaDdsOTNK?=
 =?utf-8?B?ZkpBcFJkaEYra3dwOTR1ZlhsSXhKN0J4eUtuY2VZTzNobGZmR2oxeHdyekk2?=
 =?utf-8?B?TFBwZ1VxbEV3TmN2YXJweVZZTklDbXR5STRtdDBIS2VRQXI2VjZhNlRYVTRt?=
 =?utf-8?B?ZVdmZjBDU2pOTlVqTkJsZ1k4cFlSNzE2cDVxcXFWc1hCVmxSU0hrZnhOcHJ4?=
 =?utf-8?B?eCtNRTdPdTI5N2lUaUluWHR4UDJKQ1dIRmpHSHdGSkFlQVFwK05WRlFWZW5t?=
 =?utf-8?B?YnNsR1llZ2h1b3hZOXJtMXhJUTlBRmg2KzlGN3ZraksxR1JPUDMzWXpjbXlX?=
 =?utf-8?B?cTE4RVo4TVp5d0xhL2ZuMDhoOWpQTDIyZmt1OGF0bnpiT1dqN2tXa3J6c2Np?=
 =?utf-8?B?YnpFTFgzSG9qRk5jZVJsYkpxUkt2Ris1dDA3ckhwdFh6NW5YL28wRmZrRWd1?=
 =?utf-8?B?V3MxTUpWSWNyN3RkMGRFOVJmd25RUTRUL1VjN2xaZUdNYzlNcUtoc1VlZFB1?=
 =?utf-8?B?cWxzaXRoK2FWNGZkYm9OaFNOcXQ4ZXFMTWlBa1pSZnhqMFYrV1orYkZ5VXpO?=
 =?utf-8?B?T0cwRnk0bjNjZm5OS0YvS1RlSVJJQnp0VDhIdENWTFpUdldSQVN3aERBdHVi?=
 =?utf-8?B?ZnRoRWg4WDJPZnRES055cFhNbkJyWkFQUDNjeHYrR1VDc2ZoZ25QbmhoQ3BG?=
 =?utf-8?B?S09ZMWJRYXlQM0J2dTlUa0pkVFZTZk1OV0hnVFJYd0huNGh3eXBmTkRZaStr?=
 =?utf-8?Q?CoXEPFLivPWwtJMLeuOKBD3u2rm3zr2aFCGIhPlSfMhh0?=
x-ms-exchange-antispam-messagedata-1: fC/ZofknzC3fQ5gWyYXVlDlSpXu3dfRlJH4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00FBF05BFF4C824896903512C17EE19E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde16dee-bfa0-404e-1a49-08da1ef29ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 15:14:15.1081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qWpij/7zoDoxMfg4D/Pt2/3pQUQC/rLOYvQ+ElbgvaCfITSneZtsc0n98N5UImtCkg/CVJEIBZyUnAoG/ech1FLPjA+/J6Am4TY7iLgsdrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6118
X-Proofpoint-GUID: 619dFt8vHldPAq_y_Cv3yXKC7DMBCdfY
X-Proofpoint-ORIG-GUID: 619dFt8vHldPAq_y_Cv3yXKC7DMBCdfY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDE1LCAyMDIyLCBhdCAxMDoyOCBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBBcHIgMTEsIDIwMjIsIEpv
biBLb2hsZXIgd3JvdGU6DQo+PiBPbiB2bXhfdmNwdV9sb2FkX3ZtY3MgYW5kIHN2bV92Y3B1X2xv
YWQsIHJlc3BlY3QgdXNlciBJQlBCIGNvbmZpZyBhbmQgb25seQ0KPj4gYXR0ZW1wdCBJQlBCIE1T
UiBpZiBlaXRoZXIgYWx3YXlzX2licGIgb3IgY29uZF9pYnBiIGFuZCB0aGUgdmNwdSB0aHJlYWQN
Cj4+IGhhcyBUSUZfU1BFQ19JQi4NCj4+IA0KPj4gQSB2Y3B1IHRocmVhZCB3aWxsIGhhdmUgVElG
X1NQRUNfSUIgb24gcWVtdS1rdm0gdXNpbmcgLXNhbmRib3ggb24gaWYNCj4+IGtlcm5lbCBjbWRs
aW5lIHNwZWN0cmVfdjJfdXNlcj1zZWNjb21wLCB3aGljaCB3b3VsZCBpbmRpY2F0ZSB0aGF0IHRo
ZSB1c2VyDQo+PiBpcyBsb29raW5nIGZvciBhIGhpZ2hlciBzZWN1cml0eSBlbnZpcm9ubWVudCBh
bmQgaGFzIHdvcmtsb2FkcyB0aGF0IG5lZWQNCj4+IHRvIGJlIHNlY3VyZWQgZnJvbSBlYWNoIG90
aGVyLg0KPj4gDQo+PiBOb3RlOiBUaGUgYmVoYXZpb3Igb2Ygc3BlY3RyZV92Ml91c2VyIHJlY2Vu
dGx5IGNoYW5nZWQgaW4gNS4xNiBvbg0KPj4gY29tbWl0IDJmNDY5OTNkODNmZiAoIng4NjogY2hh
bmdlIGRlZmF1bHQgdG8NCj4+IHNwZWNfc3RvcmVfYnlwYXNzX2Rpc2FibGU9cHJjdGwgc3BlY3Ry
ZV92Ml91c2VyPXByY3RsIikNCj4+IA0KPj4gUHJpb3IgdG8gdGhhdCwgcWVtdS1rdm0gd2l0aCAt
c2FuZGJveCBvbiB3b3VsZCBhbHNvIGhhdmUgVElGX1NQRUNfSUIgDQo+PiBpZiBzcGVjdHJlX3Yy
X3VzZXI9YXV0by4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFu
aXguY29tPg0KPj4gQ2M6IEFuZHJlYSBBcmNhbmdlbGkgPGFhcmNhbmdlQHJlZGhhdC5jb20+DQo+
PiBDYzogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+DQo+PiBDYzogSm9zaCBQb2lt
Ym9ldWYgPGpwb2ltYm9lQHJlZGhhdC5jb20+DQo+PiBDYzogV2FpbWFuIExvbmcgPGxvbmdtYW5A
cmVkaGF0LmNvbT4NCj4+IC0tLQ0KPj4gYXJjaC94ODYvaW5jbHVkZS9hc20vc3BlYy1jdHJsLmgg
fCAxMiArKysrKysrKysrKysNCj4+IGFyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5jICAgICAgIHwg
IDYgKysrKy0tDQo+PiBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jICAgICAgICAgICB8ICAyICstDQo+
PiBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAgICAgICAgICB8ICAyICstDQo+PiA0IGZpbGVzIGNo
YW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zcGVjLWN0cmwuaCBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3NwZWMtY3RybC5oDQo+PiBpbmRleCA1MzkzYmFiYzA1OTguLjU1Mjc1Nzg0N2Q1YiAxMDA2
NDQNCj4+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NwZWMtY3RybC5oDQo+PiArKysgYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9zcGVjLWN0cmwuaA0KPj4gQEAgLTg1LDQgKzg1LDE2IEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBzcGVjdWxhdGl2ZV9zdG9yZV9ieXBhc3NfaHRfaW5pdCh2b2lkKSB7
IH0NCj4+IGV4dGVybiB2b2lkIHNwZWN1bGF0aW9uX2N0cmxfdXBkYXRlKHVuc2lnbmVkIGxvbmcg
dGlmKTsNCj4+IGV4dGVybiB2b2lkIHNwZWN1bGF0aW9uX2N0cmxfdXBkYXRlX2N1cnJlbnQodm9p
ZCk7DQo+PiANCj4+ICsvKg0KPj4gKyAqIEFsd2F5cyBpc3N1ZSBJQlBCIGlmIHN3aXRjaF9tbV9h
bHdheXNfaWJwYiBhbmQgcmVzcGVjdCBjb25kaXRpb25hbA0KPj4gKyAqIElCUEIgaWYgdGhpcyB0
aHJlYWQgZG9lcyBub3QgaGF2ZSAhVElGX1NQRUNfSUIuDQo+PiArICovDQo+PiArc3RhdGljIGlu
bGluZSB2b2lkIG1heWJlX2luZGlyZWN0X2JyYW5jaF9wcmVkaWN0aW9uX2JhcnJpZXIodm9pZCkN
Cj4gDQo+IEkgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8gZ2l2ZSB0aGlzIGEgdmlydHVhbGl6YXRp
b24gc3BlY2lmaWMgbmFtZSwgZS5nLg0KPiB4ODZfdmlydF9jb25kX2luZGlyZWN0X2JyYW5jaF9w
cmVkaWN0aW9uX2JhcnJpZXIoKSBvciB4ODZfdmlydF9jb25kX2licGIoKSwNCj4gdG8gZm9sbG93
IHg4Nl92aXJ0X3NwZWNfY3RybCgpLiAgT3IgaWYgImNvbmQiIGlzIG1pc2xlYWRpbmcgaW4gdGhl
ICJhbHdheXMiIGNhc2UsDQo+IHBlcmhhcHMgeDg2X3ZpcnRfZ3Vlc3Rfc3dpdGNoX2licGIoKT8N
Cg0KK0JpamFuDQpZZWEsIGdvb2Qgc3VnZ2VzdGlvbi4gQmlqYW4gYW5kIEkgd2VyZSBnb2luZyBi
YWNrIGFuZCBmb3J0aCBvbiB0aGlzIGluIG91cg0KaW50ZXJuYWwgcmV2aWV3IGFuZCBjb3VsZG7i
gJl0IGxhbmQgb24gYSBnb29kIG5hbWUuIEkgbGlrZSB0aGlzIG5hbWluZyBiZXR0ZXIuDQoNCj4g
DQo+PiArew0KPj4gKwlpZiAoc3RhdGljX2tleV9lbmFibGVkKCZzd2l0Y2hfbW1fYWx3YXlzX2li
cGIpIHx8DQo+PiArCSAgICAoc3RhdGljX2tleV9lbmFibGVkKCZzd2l0Y2hfbW1fY29uZF9pYnBi
KSAmJg0KPj4gKwkgICAgIHRlc3RfdGhyZWFkX2ZsYWcoVElGX1NQRUNfSUIpKSkNCj4gDQo+IFRo
ZSBjb25kX2licGIgY2FzZSBpbiBwYXJ0aWN1bGFyIG5lZWRzIGEgbW9yZSBkZXRhaWxlZCBjb21t
ZW50LiAgU3BlY2lmaWNhbGx5IGl0DQo+IHNob3VsZCBjYWxsIG91dCB3aHkgdGhpcyBwYXRoIGRv
ZXNuJ3QgZG8gSUJQQiB3aGVuIHN3aXRjaGluZyBmcm9tIGEgdGFzayB3aXRoDQo+IFRJRl9TUEVD
X0lCIHRvIGEgdGFzayB3aXRob3V0IFRJRl9TUEVDX0lCLCB3aGVyZWFzIGNvbmRfbWl0aWdhdGlv
bigpIGRvZXMgZW1pdA0KPiBJQlBCIHdoZW4gc3dpdGNoaW5nIG1tcyBpbiB0aGlzIGNhc2UuDQo+
IA0KPiBCdXQgc3RlcHBpbmcgYmFjaywgd2h5IGRvZXMgS1ZNIGRvIGl0cyBvd24gSUJQQiBpbiB0
aGUgZmlyc3QgcGxhY2U/ICBUaGUgZ29hbCBpcw0KPiB0byBwcmV2ZW50IG9uZSB2Q1BVIGZyb20g
YXR0YWNraW5nIHRoZSBuZXh0IHZDUFUgcnVuIG9uIHRoZSBzYW1lIHBDUFUuICBCdXQgdW5sZXNz
DQo+IHVzZXJzcGFjZSBpcyBydW5uaW5nIG11bHRpcGxlIFZNcyBpbiB0aGUgc2FtZSBwcm9jZXNz
L21tX3N0cnVjdCwgc3dpdGNoaW5nIHZDUFVzLA0KPiBpLmUuIHN3aXRjaGluZyB0YXNrcywgd2ls
bCBhbHNvIHN3aXRjaCBtbV9zdHJ1Y3RzIGFuZCB0aHVzIGRvIElQQlAgdmlhIGNvbmRfbWl0aWdh
dGlvbi4NCg0KR29vZCBxdWVzdGlvbiwgSSBjb3VsZG7igJl0IGZpZ3VyZSBvdXQgdGhlIGFuc3dl
ciB0byB0aGlzIGJ5IHdhbGtpbmcgdGhlIGNvZGUgYW5kIGxvb2tpbmcNCmF0IGdpdCBoaXN0b3J5
L2JsYW1lIGZvciB0aGlzIGFyZWEuIEFyZSB0aGVyZSBWTU1zIHRoYXQgZXZlbiBydW4gbXVsdGlw
bGUgVk1zIHdpdGhpbg0KdGhlIHNhbWUgcHJvY2Vzcz8gVGhlIG9ubHkgY2FzZSBJIGNvdWxkIHRo
aW5rIG9mIGlzIGEgbmVzdGVkIHNpdHVhdGlvbj8NCg0KPiANCj4gSWYgdXNlcnNwYWNlIHJ1bnMg
bXVsdGlwbGUgVk1zIGluIHRoZSBzYW1lIHByb2Nlc3MsIGVuYWJsZXMgY29uZF9pcGJwLCBfYW5k
XyBzZXRzDQo+IFRJRl9TUEVDX0lCLCB0aGVuIGl0J3MgYmVpbmcgc3R1cGlkIGFuZCBpc24ndCBn
ZXR0aW5nIGZ1bGwgcHJvdGVjdGlvbiBpbiBhbnkgY2FzZSwNCj4gZS5nLiBpZiB1c2Vyc3BhY2Ug
aXMgaGFuZGxpbmcgYW4gZXhpdC10by11c2Vyc3BhY2UgY29uZGl0aW9uIGZvciB0d28gdkNQVXMg
ZnJvbQ0KPiBkaWZmZXJlbnQgVk1zLCB0aGVuIHRoZSBrZXJuZWwgY291bGQgc3dpdGNoIGJldHdl
ZW4gdGhvc2UgdHdvIHZDUFVzJyB0YXNrcyB3aXRob3V0DQo+IGJvdW5jaW5nIHRocm91Z2ggS1ZN
IGFuZCB0aHVzIHdpdGhvdXQgZG9pbmcgS1ZNJ3MgSUJQQi4NCg0KRXhhY3RseSwgc28gbWVhbmlu
ZyB0aGF0IHRoZSBvbmx5IHRpbWUgdGhpcyB3b3VsZCBtYWtlIHNlbnNlIGlzIGZvciBzb21lIHNv
cnQgb2YgbmVzdGVkDQpzaXR1YXRpb24gb3Igc29tZSBvdGhlciBmdW5reSBWTU0gdG9tZm9vbGVy
eSwgYnV0IHRoYXQgbmVzdGVkIGh5cGVydmlzb3IgbWlnaHQgbm90IGJlIA0KS1ZNLCBzbyBpdCdz
IGEgZmFyY2UsIHllYT8gTWVhbmluZyB0aGF0IGV2ZW4gaW4gdGhhdCBjYXNlLCB0aGVyZSBpcyB6
ZXJvIGd1YXJhbnRlZQ0KZnJvbSB0aGUgaG9zdCBrZXJuZWwgcGVyc3BlY3RpdmUgdGhhdCBiYXJy
aWVycyB3aXRoaW4gdGhhdCBwcm9jZXNzIGFyZSBiZWluZyBpc3N1ZWQgb24NCnN3aXRjaCwgd2hp
Y2ggd291bGQgbWFrZSB0aGlzIHNlY3VyaXR5IHBvc3R1cmUganVzdCB3aW5kb3cgZHJlc3Npbmc/
DQoNCj4gDQo+IEkgY2FuIGtpbmRhIHNlZSBkb2luZyB0aGlzIGZvciBhbHdheXNfaWJwYiwgZS5n
LiBpZiB1c2Vyc3BhY2UgaXMgdW5hd2FyZSBvZiBzcGVjdHJlDQo+IGFuZCBpcyBuYWl2ZWx5IHJ1
bm5pbmcgbXVsdGlwbGUgVk1zIGluIHRoZSBzYW1lIHByb2Nlc3MuDQoNCkFncmVlZC4gSeKAmXZl
IHRob3VnaHQgb2YgYWx3YXlzX2licGIgYXMgInBhcmFub2lkIG1vZGUiIGFuZCBpZiBhIHVzZXIg
c2lnbnMgdXAgZm9yIHRoYXQsDQp0aGV5IHJhcmVseSBjYXJlIGFib3V0IHRoZSBmYXN0IHBhdGgg
LyBwZXJmb3JtYW5jZSBpbXBsaWNhdGlvbnMsIGV2ZW4gaWYgc29tZSBvZiB0aGUNCnNlY3VyaXR5
IHN1cmZhY2UgYXJlYSBpcyBqdXN0IGNvbXBsZXRlIHdpbmRvdyBkcmVzc2luZyA6KCANCg0KTG9v
a2luZyBmb3J3YXJkLCB3aGF0IGlmIHdlIHNpbXBsaWZpZWQgdGhpcyB0byBoYXZlIEtWTSBpc3N1
ZSBiYXJyaWVycyBJRkYgYWx3YXlzX2licGI/DQoNCkFuZCBkcm9wIHRoZSBjb25k4oCZcywgc2lu
Y2UgdGhlIHN3aXRjaGluZyBtbV9zdHJ1Y3RzIHNob3VsZCB0YWtlIGNhcmUgb2YgdGhhdD8NCg0K
VGhlIG5pY2UgcGFydCBpcyB0aGF0IHRoZW4gdGhlIGNvbmRfbWl0aWdhdGlvbigpIHBhdGggaGFu
ZGxlcyB0aGUgZ29pbmcgdG8gdGhyZWFkDQp3aXRoIGZsYWcgb3IgZ29pbmcgZnJvbSBhIHRocmVh
ZCB3aXRoIGZsYWcgc2l0dWF0aW9uIGdyYWNlZnVsbHksIGFuZCB3ZSBkb27igJl0IG5lZWQgdG8N
CnRyeSB0byBkdXBsaWNhdGUgdGhhdCBzbWFydHMgaW4ga3ZtIGNvZGUgb3Igc29tZXdoZXJlIGVs
c2UuDQoNCj4gDQo+IFdoYXQgYW0gSSBtaXNzaW5nPw0KDQo=
