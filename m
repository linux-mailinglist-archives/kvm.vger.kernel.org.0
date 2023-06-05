Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD072308F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 21:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbjFET5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 15:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjFET5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 15:57:36 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAEC90;
        Mon,  5 Jun 2023 12:57:34 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355FQM1a006659;
        Mon, 5 Jun 2023 12:57:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=MpJqNxHIP2nkSmZ7863Po7ZGIGZFKMJfJuE5lzI05VY=;
 b=rpB3TrEnIdlPf7MMmuqUJ/7+MnsXafIdQA4vTTlOjvDbC5k63GhXXEVabkx/5ePlIdNt
 GUbhOCvIIXU+mY6mWDXh7w93RSQ0Jbu9gDERx0OKXiYIyWoSWj9BaDvnowynFWbWjDFN
 wUlogcLB27rZIVM9Mwd0H0Fqf5l6Gl0LwitNWIJk2z0qisdU8llVXJZWjGir++uOiv/v
 mlBOoseoXwpLbEfkcnMCNzmQK0G2m1WcuYQFJmSYcVhmgHlkR2YPgT8JPTQnqlA4orqV
 6h4SJsyYnUnu4wSmwKcDfYvE4QFY/KS2k2SeuZVpznGR/4l2P85QGDWQ0SsoFfVf09BH eQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3r04ucuyv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 12:57:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6yClI4ZY7W+jW6gs5xcy6Nmvx45tJeU5cdZjtFsrCOxEBrg/ggKai9IlOriWRaY0IorbLnpsdx2cELOIlMqbBgXclwkcQnLNFP/fGWUIvKUHaQaIoLRKHdf4O4I9e1xCABw9+mZ+j32AXB/9gd0bSDluw2aImhAoBbBriebHxDA4wQ+1E/RN33WPnvmR26CpG/liEqwbkA096qsxU6ZtLZBHfScoPA8l7ymA7uSagPqelj7ELhdfYGdzK8ik/jFk2uLJLnPxkfxoD5+eS5gIbqQE9DxW5LHo52lqONDFgwJ9WDXwPC2slAR6BDfmpKGFySbtUSFhXnTk9k5x5bUBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpJqNxHIP2nkSmZ7863Po7ZGIGZFKMJfJuE5lzI05VY=;
 b=TEMTa9LGcMd1fUWAa5FK5fsZURJ218sNmWH8YjDpgCaZalKnu04WUDUr12/cfXoCSCa4YSXTSyzPu2IyBw2tk1lA597KOLGB3hIrlyfc8BU82nTggECTCMFPXsTaW4l72rnavpBlIVHboHlI6bWQAK9IXp+N6tP6qU4nVLUsQntsliorccOg8AlLHi0zn2NDgXGCuvT2+145se/1mMS0lkx0/YRBNx4/+CetqHbEscuNI4nQJHFdKszRmLkf23b8YRkBtx5ImVazViKceMqiA9DKa5y50bORxxwsTBmUNJRlfKShvSCqFEsy62GXJRr9y1nqlyw+zAtBp28xJr5ZVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpJqNxHIP2nkSmZ7863Po7ZGIGZFKMJfJuE5lzI05VY=;
 b=hIr2yz5ZahsEZ3Wrl+a1tM1IpOUuFzphioH4fRuWt2WF1rRh9xeRiOfRnbXDaN2e6ytWNKDzjk3Ic1rJ10948kphOmYwT8hWtPaj8hyN348NiMyZDN6+0Qc6rRn6LNOvxC+t8x+w1IRDJkwkTt/Dc8Tyk/bWF/LzHILXU9Ih+0JPmxoY39CRB6Ikar490iDQIqG1ee5+H+NQ8EETo8k8cG9ALsMiZfzmF3Xlyt7KpOzpnkKvxI67/Ew1OBXKWBne6lt++n+2hUmQns7gnrrz0xo6PzUDocpg6fRuqp78yYLSVjetv9bf6hnEkqgoE6qibXXBrDWNbVM4zDCY30iEaw==
Received: from DM6PR02MB4585.namprd02.prod.outlook.com (2603:10b6:5:28::17) by
 CH2PR02MB6790.namprd02.prod.outlook.com (2603:10b6:610:7d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Mon, 5 Jun 2023 19:57:03 +0000
Received: from DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1]) by DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 19:57:03 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Topic: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Index: AQHZk9DFtRNtW0r2UU2DHIN38zEv2a91BL4AgAALIICAAAxDAIAAAnMAgAAJaYCAADIWgIAG8nEAgAAjbwCAAADigIAADoeAgAAQ6wCAABfigA==
Date:   Mon, 5 Jun 2023 19:57:03 +0000
Message-ID: <CC026331-99A9-4DF7-9C27-F4C8A5641385@nutanix.com>
References: <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
 <20230605163552.hi5kvh5wijegmus6@treble>
 <E704D6D6-3B03-40FA-8CDB-5FB58871BABC@nutanix.com>
 <20230605173101.iflfly3bt6ydvvyk@desk> <ZH4qBjLi0egsuC1D@google.com>
In-Reply-To: <ZH4qBjLi0egsuC1D@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR02MB4585:EE_|CH2PR02MB6790:EE_
x-ms-office365-filtering-correlation-id: e610170d-5265-4640-ade3-08db65ff087d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2O5qyk5Ju5uv7vYE8G5qshR5dZm9ZEi5lA+x8GpkFktjOB/i1RGmfctc1s/9aPfIsDtqOMbch14MY+L9Y8aIjZ+bw60EeBhPzZPpsH4zhNwI/fBdxJ+FhYQXaqsDdgadA3Czv5GNxF10juFZaJET8ON0mtQN+ZESIom7CxSy5Ac6Qgd5KUY906RyraLWmnvFwFLhuQA+FTtrQSMu4gXyqwgeNntUvr+Xhzwjfg/vfvJ0Dwkxlm92YqBJ9st7UZrdzx/1osKPGr2iCOP+CP0KacU5XO08QM1rrUUp2jRUviT8gI1/oaNGFudnEpzrRdju2kWXghWiLjxQim0jWh0DwwUq4hxcdPGtEJvHzX3eD6veww7mRw6ychZdLmnGZBFDNksXQd6GSKPWbQl1epO12S5mfl7JFkDgo7WQL+qshtCb4qLStoBRkcYelpFnoxAZM+dg46F8QLu/3jZhImJE/IEq1vkfli84jUr4fjCPXYVjekRBwHkUGMu7EZbqdIgCilmoZF7OHxNj/WV2+DfTDi5G/Si9Q0quyNeylUXT031Vj+3CPPcGYwjfZUPIZi8E8ULTlTXR+GJV07qCjmE/9ZniIyRBYGneLA0SGuan/60ZmrVW4zdRZVMz6KMhXmobTL/mWvMRk1bgxrWcnX/Pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4585.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199021)(54906003)(71200400001)(478600001)(8936002)(8676002)(5660300002)(7416002)(36756003)(38070700005)(2906002)(86362001)(33656002)(66946007)(4326008)(6916009)(91956017)(122000001)(66446008)(66476007)(66556008)(64756008)(76116006)(316002)(38100700002)(41300700001)(83380400001)(6506007)(6512007)(53546011)(2616005)(186003)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dERYMUdJbTU1RmRHWnFtLytGU2trLzZ5YzBnNlVBOW9rT2FCTURKNE1mck9n?=
 =?utf-8?B?U1FncmZ4RVRVZUNHOEttYWQxazZoZUFBbElFb3dyejd5VkFzQjExRXFCeXAx?=
 =?utf-8?B?eE0xZ042SFYzRGg0Y20wZElhZU9NWWtPL0ZJVHFoWFlIT25PbExhNVdtU1VY?=
 =?utf-8?B?Q1l2cXQzSVEwcFV3VUtzbGU4M0VuTVVLS1NhbzV3Q1ZSakR6YTFmc1JmWmlB?=
 =?utf-8?B?d2ZWQy9TSUxWK01mdXVQaEFWR3NPVGJRK293c1hPOEQ4SWtqRUlJcEVCaUYz?=
 =?utf-8?B?Ulc5dzkwejNXWEl1UlordmdaYXIvUWVnVGkzS0xVZG9WaGhZK3QzNGQzTmsy?=
 =?utf-8?B?RmpYT3N5dk1kU0hFUTZFYWlKd0hVNHBZWFdFZHVXTHkvNHFralFURkdDQ0M3?=
 =?utf-8?B?YWhyM3lGdUdxcFVLaCtSQk00b0p5ZkZiOE9JdG1zR09tSDZ2dDJsaWpRcHNV?=
 =?utf-8?B?WXNRNHRLb1NzSzV3NWF5aGhNOXBEaFhoYTJFU2hsbzJndTJLVzhFMjRaWHZN?=
 =?utf-8?B?VUUvcGQyOFBQR1BMYlFic3pUOGdIWXV4Rmd4WW16SXVwQWw4WTd6Mm9iWnJt?=
 =?utf-8?B?TWxsdzQybDk5cytmaDF5RDJDYU5hdlQrUEplZmk5aW9uVEszREhFdWViaFhH?=
 =?utf-8?B?VzE2MUtXa3hzRmx0aThBVTRQNTZkWW1PTTJweUtUVmExUEY3ZklKejd5YWxh?=
 =?utf-8?B?VithRG9CZmVpc1hvR1pNMVZ6RVRYRE5ZcW5mV1l4Z2ZmZWcwWTJlankvRnla?=
 =?utf-8?B?OC9yZkFJU2xUN2w3YWxrNEdvUDRKNlF3azJMZnVWYkJGWGtkbktvQmoybDVz?=
 =?utf-8?B?Vko1b1d0ZHpYUHlmUTlTRVdKVUs1VFU5RFBwekRabC9LOE4yMEloZHlhMzl2?=
 =?utf-8?B?VXBYMW5ibGJ6eHlqYXFSOTB2V3YrUFpPWURxLzVZS25wa21VQkxRalFaQWhh?=
 =?utf-8?B?ckVNdVlIWjh2ckpJZmlFSmIralNxYXgybWtkaHZibmdlSWI4TG00NkFNN2dP?=
 =?utf-8?B?YityZnpRSlVJek1uNE9TMlAyYUhwVko2QkxyKy9SU0RsQnZzWW93bVdYY0J2?=
 =?utf-8?B?TjJGYk54bC9oNnAydHlkSFQyRW90YzVTUGRwWHhhcDh3K3JDVkhRbnJGa2do?=
 =?utf-8?B?N2RJNVh1VXowRTZvSGFlSHpPMVBqTGVrMTZWSFduSEY1cHV0eFpUeDA5cXll?=
 =?utf-8?B?UkFPR2E3M1hWWXF2akRwanRjUEY0ZWtLZTNFTWIvcG5tdVFsL2ZSRFFaWWQ4?=
 =?utf-8?B?ZE1LMitodlpod0JnZG1zd0NFeWlyN3paSGJSbS91ZjI1bG5MS3VvSkVHVENX?=
 =?utf-8?B?ck5STlZ5cGRJWms5WkZvWktGQXlJTlAwTmcxdlg2c1EvVDVuQkMzLzlWazFZ?=
 =?utf-8?B?SWYwWWpFbFg0L2JKbTlmVlREWnFjVXBQZnBpOFJ3SW8zYTdJUENnc0pVcjlp?=
 =?utf-8?B?cTJhWWlicWNyM096SjRLdlVMQkVXYWtuem1TdE8vOG5UWHRVUmtVOWdkN1Q1?=
 =?utf-8?B?WUVGOC9aamJkd1dkdDVvWlBwWWlXOGxrWGJHMnpuNGtuVFVlYW1QdEF0bm03?=
 =?utf-8?B?TW01dmJjUitOSlhZRHQvc0FLVXlyZG5NcTNGUGpVNmE1d1BsUXFRVmdYbXpI?=
 =?utf-8?B?UTRBRlJVNFdPMnBLOHA2ZENKZnFIQVhIWHFuQnVFRUN0dGlvdzVKT2ZoVS9a?=
 =?utf-8?B?ZkJCVUhYTGoyU08wRXhLZlZ0SGtRSklTMHJraG15RnhTR2UwWU9JcGRzRmhD?=
 =?utf-8?B?S2J3bVJRb0tTMGR5SmV2VzZRK3BQVVR0eVZmT0Z3TGwyOTJNeXNvUmRFWitG?=
 =?utf-8?B?aWxFTkd2NlNzYzdGTC81V2k1KzlFWk9hNS9yVnQ5SmJ5TC9vUXNteFo1eVhl?=
 =?utf-8?B?OVJGaDcrWlBzWlNsdzN3NVp2VnU4UDg5RnpCYnFXVU1ZS05zT1hzQVBHc1Vx?=
 =?utf-8?B?Z3dwVzFuYk42SkJFd2ZRYnNqMnV2b3VGaTFxUytUek9hZVlId1FRNy9EMEx6?=
 =?utf-8?B?QnBycUtoOERtVmJleEU5cWdFdU1vdGZ6WHdxR0ZLaHRsbGROR1BWc2RSQTdq?=
 =?utf-8?B?d3VaWlVtK1BITE9IQ2ErQjd4Znd3QnZLUkVIcTEvWXJJbzV2NGpUelRuQ2Zq?=
 =?utf-8?B?b3JpSVJUUXZ4YXBXS3owWStPeEZnYWtGSTFuNytpVk9EVjQzNXRmQ0p4bk53?=
 =?utf-8?B?MmhCYjA4R1ZUbGZjaFNYSnNScGdWOFNBMWc3d040Lzk0QmtFMjZ1aU0xWlpU?=
 =?utf-8?B?dmJNc3ZXTi9ua3lHdDI5dHg0Mk5nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB47DB89AB664A4CB7245C0F28417D0C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4585.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e610170d-5265-4640-ade3-08db65ff087d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 19:57:03.6362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnzKiMQ25R94VCNLWmmFqyxSkZ73DjXPiZCcgOyW7Eb4fUa46S8zXcBUBBln3vgC+PB06JUW/2CCx41mdycHpGaduMyIjdV6eVAGbYwD3hU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6790
X-Proofpoint-ORIG-GUID: G9cIe4waMePUMoJjbWwYI4kBaLuaAP-l
X-Proofpoint-GUID: G9cIe4waMePUMoJjbWwYI4kBaLuaAP-l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_32,2023-06-02_02,2023-05-22_02
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

DQoNCj4gT24gSnVuIDUsIDIwMjMsIGF0IDI6MzEgUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIE1vbiwgSnVuIDA1LCAyMDIzLCBQYXdh
biBHdXB0YSB3cm90ZToNCj4+IE9uIE1vbiwgSnVuIDA1LCAyMDIzIGF0IDA0OjM5OjAyUE0gKzAw
MDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4+Pj4gWWVzLiAgVGhvdWdoIGluIHByYWN0aWNlIGl0
IG1pZ2h0IG5vdCBtYWtlIG11Y2ggb2YgYSBkaWZmZXJlbmNlLiAgV2l0aA0KPj4+Pj4+IHdybXNy
K2xmZW5jZSwgdGhlIGxmZW5jZSBoYXMgbm90aGluZyB0byBkbyBzbyBpdCBtaWdodCBiZSBhbG1v
c3QNCj4+Pj4+PiBpbnN0YW50YW5lb3VzIGFueXdheS4NCj4+Pj4+PiANCj4+Pj4+PiAtLSANCj4+
Pj4+PiBKb3NoDQo+Pj4+PiANCj4+Pj4+IENvbWluZyBiYWNrIHRvIHRoaXMsIHdoYXQgaWYgd2Ug
aG9pc3RlZCBjYWxsIHZteF9zcGVjX2N0cmxfcmVzdG9yZV9ob3N0IGFib3ZlDQo+Pj4+PiBGSUxM
X1JFVFVSTl9CVUZGRVIsIGFuZCBkcm9wcGVkIHRoaXMgTEZFTkNFIGFzIEkgZGlkIGhlcmU/DQo+
Pj4+PiANCj4+Pj4+IFRoYXQgd2F5LCB3ZSB3b3VsZG7igJl0IGhhdmUgdG8gbWVzcyB3aXRoIHRo
ZSBpbnRlcm5hbCBMRkVOQ0UgaW4gbm9zcGVjLWJyYW5jaC5oLA0KPj4+Pj4gYW5kIHRoYXQgd291
bGQgYWN0IGFzIHRoZSDigJxmaW5hbCBsaW5lIG9mIGRlZmVuc2XigJ0gTEZFTkNFLg0KPj4+Pj4g
DQo+Pj4+PiBXb3VsZCB0aGF0IGJlIGFjY2VwdGFibGU/IE9yIGRvZXMgRklMTF9SRVRVUk5fQlVG
RkVSICpuZWVkKiB0byBvY2N1cg0KPj4+Pj4gYmVmb3JlIGFueSBzb3J0IG9mIGNhbGxzIG5vIG1h
dHRlciB3aGF0Pw0KPj4+PiANCj4+Pj4gSWYgd2UgZ28gYnkgSW50ZWwncyBzdGF0ZW1lbnQgdGhh
dCBvbmx5IHVuYmFsYW5jZWQgUkVUcyBhcmUgYSBjb25jZXJuLA0KPj4+PiB0aGF0ICptaWdodCog
YmUgb2sgYXMgbG9uZyBhcyB0aGVyZSdzIGEgbmljZSBjb21tZW50IGFib3ZlIHRoZQ0KPj4+PiBG
SUxMX1JFVFVSTl9CVUZGRVIgdXNhZ2Ugc2l0ZSBkZXNjcmliaW5nIHRoZSB0d28gcHVycG9zZXMg
Zm9yIHRoZQ0KPj4+PiBMRkVOQ0UuDQo+PiANCj4+IFdlIHdvdWxkIHRoZW4gbmVlZCBGSUxMX1JF
VFVSTl9CVUZGRVIgdG8gdW5jb25kaXRpb25hbGx5IGV4ZWN1dGUgTEZFTkNFDQo+PiB0byBhY2Nv
dW50IGZvciB3cm1zciBicmFuY2ggbWlzcHJlZGljdGlvbi4gQ3VycmVudGx5IExGRU5DRSBpcyBu
b3QNCj4+IGV4ZWN1dGVkIGZvciAhWDg2X0JVR19FSUJSU19QQlJTQi4NCj4+IA0KPj4+PiBIb3dl
dmVyLCBiYXNlZCBvbiBBbmR5J3MgY29uY2VybnMsIHdoaWNoIEkndmUgZGlzY3Vzc2VkIHdpdGgg
aGltDQo+Pj4+IHByaXZhdGVseSAoYnV0IEknbSBub3QgcXVhbGlmaWVkIHRvIGFncmVlIG9yIGRp
c2FncmVlIHdpdGgpLCB3ZSBtYXkgd2FudA0KPj4+PiB0byBqdXN0IGNvbnZlcnQgdm14X3NwZWNf
Y3RybF9yZXN0b3JlX2hvc3QoKSB0byBhc20uICBCZXR0ZXIgc2FmZSB0aGFuDQo+Pj4+IHNvcnJ5
LiAgTXkgb3JpZ2luYWwgaW1wbGVtZW50YXRpb24gb2YgdGhhdCBmdW5jdGlvbiB3YXMgYWN0dWFs
bHkgYXNtLiAgSQ0KPj4+PiBjYW4gdHJ5IHRvIGRpZyB1cCB0aGF0IGNvZGUuDQo+PiANCj4+IE5v
dGU6DQo+PiANCj4+ICBWTWV4aXQNCj4+ICBDQUxMDQo+PiAgICBSRVQNCj4+ICBSRVQgICAgPC0t
LS0gVGhpcyBpcyBhbHNvIGEgcHJvYmxlbSBpZiB0aGUgZmlyc3QgY2FsbCBoYXNuJ3QgcmV0aXJl
ZCB5ZXQuDQo+PiAgTEZFTkNFDQo+PiANCj4+IENvbnZlcnRpbmcgdm14X3NwZWNfY3RybF9yZXN0
b3JlX2hvc3QoKSB0byBBU00gc2hvdWxkIGJlIGFibGUgdG8gdGFrZSBjYXJlDQo+PiBvZiB0aGlz
Lg0KPiANCj4gSXMgdGhlcmUgYW4gYWN0dWFsIGJ1ZyBoZXJlLCBvciBhcmUgd2UganVzdCBtaWNy
by1vcHRpbWl6aW5nIHNvbWV0aGluZyB0aGF0IG1heSBvcg0KPiBtYXkgbm90IG5lZWQgYWRkaXRp
b25hbCBvcHRpbWl6YXRpb24/ICBVbmxlc3MgdGhlcmUncyBhIGJ1ZyB0byBiZSBmaXhlZCwgbW92
aW5nDQo+IGNvZGUgaW50byBBU00gYW5kIGluY3JlYXNpbmcgY29tcGxleGl0eSBkb2Vzbid0IHNl
ZW0gd29ydGh3aGlsZS4NCg0KVGhlIChzbGlnaHQpIGJ1ZyBoZXJlIGlzIHRoYXQgb24gc3lzdGVt
cyB3aGVyZSB0aGUgaG9zdCAhPSBndWVzdCBzcGVjIGN0cmwsIHRoZXkgZ2V0DQpoaXQgd2l0aCBM
RkVOQ0UgKyBXUk1TUiB0byBTUEVDX0NUUkwgKyBMRkVOQ0UsIHdoZW4gaW4gcmVhbGl0eSB0aGV5
IHNob3VsZA0KanVzdCBnZXQgTEZFTkNFICsgV1JNU1IgdG8gU1BFQ19DVFJMIGFuZCB0aGF0cyBp
dC4gDQoNClRoYXQgd291bGQgYmUgc2F0aXNmaWVkIHdpdGggUGF3YW7igJlzIHN1Z2dlc3Rpb24g
dG8gbW92ZSB0aGUgTEZFTkNFIGludG8gdGhlIGVsc2UNCmNvbmRpdGlvbiBpbiB0aGUgbGFzdCBi
cmFuY2ggb2Ygdm14X3NwZWNfY3RybF9yZXN0b3JlX2hvc3QoKS4NCg0KVGhlIG9wdGltaXphdGlv
biBvbiB0b3Agb2YgdGhhdCB3b3VsZCBiZSB0byBzZWUgaWYgd2UgY291bGQgd2hhY2sgdGhhdCAy
eCBMRkVOQ0UNCmRvd24gdG8gMXggTEZFTkNFLiBKdXN0IGZlZWxzIHdyb25nIHRvIGhhdmUgMngg
TEZFTkNF4oCZcyBpbiB0aGUgY3JpdGljYWwgcGF0aCwNCmV2ZW4gaWYgdGhlIHNlY29uZCBvbmUg
ZW5kcyB1cCBiZWluZyBmYWlybHkgc25hcHB5IGJlY2F1c2Ugb2YgdGhlIGZpcnN0IG9uZSAoYW5k
L29yDQp0aGUgV1JNU1IpLg0KDQpTbyB0byByZWNhcCwgZml4aW5nIOKAnHRoZSBidWfigJ0gZG9l
cyBub3QgcmVxdWlyZSBtb3ZpbmcgdG8gQVNNLiBPcHRpbWl6aW5nIHRoZSAyeCBMRkVOQ0UNCmlu
dG8gMXggTEZFTkNFIChwcm9iYWJseSkgcmVxdWlyZXMgZ29pbmcgdG8gQVNNIGZyb20gdGhlIHNv
dW5kcyBvZiBpdD8NCg0K
