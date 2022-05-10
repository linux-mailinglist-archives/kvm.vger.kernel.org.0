Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2534521DD4
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345278AbiEJPRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345327AbiEJPP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:15:29 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983F61E21A0;
        Tue, 10 May 2022 07:50:28 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ABoSio001157;
        Tue, 10 May 2022 07:49:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=PInWRIFfxBvOjjQis0SxufAyyGOPWIfFL1Eow32KP+s=;
 b=R9Gt/SeYWVQThMe5vnGiiXqvRBlLVZtHQsA4/+Kysrpcaea+ZT61GfktzFuCZdqJyucc
 H3GONcii3oQk+BjGYWYXFZ/o9el8fEGTc8APZRh9nmiWZNiDjHJXt5VvmDKWHeCrtrcB
 K5/WK/vil+3Zy+pRxTVepiiXWc7zf6RIXnGLe5JgPyKF625j6ScDZk8qZsxcsuIyeCTZ
 SFO11u0Y6QLR9T1aZGqSsIhy/Fhl6jJUtbmF0QqE/oDDouPuxYVLJJRX6OVQbIke2sEW
 9kqBDieqCLOTKGOqS5+/p/15yUK42MznffvtPu1ZS7sAG7Y5uAjKKVlWF60RXI8SUcGP xA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwqufnxeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:49:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3xT4sc8aCf0yQXh4lWPRf1lTMVfk9juMq70qv06yAd7dAwIVNu83A9fKwVb8jKKiO1JOviT0w7PqZGy5dfd8eHbppA5e81UBtFVk6F4lbWrpt3PkBbBlf6AbJiiNbeDYPaKCWiWaEOWGS74D6zKEE/cB7NF8OcZXve1HDJb9B9GMVZwVzQp1kCwzmZUE1JCZjsSNpW23cckKK3T2UWlE91Z0TYVnkAT6X2C1PoyJQBiFWnxzEp89y3Ga1WtUuzfX/f3ZJ8QQkYLpoy7KbyqJHHSLHZLgws6y/uZV3CM0hDxB4afGh0g4ZWWcAL3lQo8D/DbW5Nc/gXv9i2Y1qxyFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PInWRIFfxBvOjjQis0SxufAyyGOPWIfFL1Eow32KP+s=;
 b=S7gw4Hm8AfKS+e/ICbBS1WT4PwR9qcbsyvT5+ppiKRvlEXwoQWJ1EdwyUCJCzVJqlEdfvnuZu/WWhs551RBnzE94SQHR+p7JCFuQR4ROWBbVnTEFNHxzQBAXRG6ToEquWaJfG3VbfIMPd9EFErPl+jN8L1MRrdw2CnZ/QK6KMVspDbIpbZO/9AWBD80S0RlTAhbZURThFRfUdKKZzOMCNc2eTD4Es5KRinG5U8NdJdHNlEgawD7kQ+GtFaagIRud5UxdqbVAsngztV7Zxv2GkIN1H1TSk8xoYX8yQACsPzD/0JeiA3V4h5baoZNi8O55/Q1N7ZxLDw7MpmNKM+by5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB4369.namprd02.prod.outlook.com (2603:10b6:208:4f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 14:49:15 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 14:49:15 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Jon Kohler <jon@nutanix.com>, Borislav Petkov <bp@alien8.de>,
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
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9ICAACHkgIAAD+oAgAAIS4CAABD0AIAABkcAgAARGQCAAK85AIAAU8oAgA+vYoCAAAePAA==
Date:   Tue, 10 May 2022 14:49:15 +0000
Message-ID: <DB45B96F-91F6-4A78-A00F-4E422075FF63@nutanix.com>
References: <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com> <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com> <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com> <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com> <Ym0GcKhPZxkcMCYp@zn.tnic>
 <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
 <Ynp1E73OZtXudLUH@google.com>
In-Reply-To: <Ynp1E73OZtXudLUH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 778bf276-b6f8-4de8-d3b4-08da3294411c
x-ms-traffictypediagnostic: BL0PR02MB4369:EE_
x-microsoft-antispam-prvs: <BL0PR02MB4369CA477FBD10E658511ED2AFC99@BL0PR02MB4369.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9aW4n80HaRK4ni3lS7bA9+D8TgNQ78BiCfkwpT7dwXuk0bCHCSga02HOSddAhPV6Sz1YN3b+fAWCITQTADu5zeCxQ3L5xPlha/l4bROCjAWN24p59OnPqbMsoekUQp8BEEWNcxJwCzNgCPonpYKaKw34rA/PGTAwg7KaPBzKhU8g35jwIv7u8I61l4BHUC7wm8Krz8V7lifQKxwn21TFXQN6P5jLbB2ye22+YokOB80FCIvGdTv4MlwB1oI1sjhAHc5hypdldktlGXXXIPdrPEacyqFPmUhccZ4THZxu15R94zlf9CV6D0RJQbB/ip5NY0zeSbB1djOiaK4Um7MLh8ZFGQtNH96unGGPqL4gy5lnWLsz84VxIjxVQxGK96Z6cUgdNfl4XDrpwehuBKd0oHzP2yNom43kcJG+meaBmVdCyCI8hdPEKSyoNw0JExTl//DZBB6AEX8W4+/z/8lAHEedoi43Q2elQXmuHTlGQF4CFDFblB8ON094w4Fw6hnMc7622fcsisN90MxgFRXuDcwtcoVcA09RV3SnjbjYfQsSCSDaZkBFMRAyE72ofp+3D59LETZs4BrmZYwvtHXu5V1qCGHY9zfoXglc+r20hykpn+5+nAqDDKnVFXKbKfFFOSrNYFTnQ/On7/F0Pqe06BgMFM7RNZc0pUfkodxhf+SCZ9aW75RJmpZxcqsJJEWSAmxgiS8bNulxvFDjsExdm5233rYIyQdrysmahd4mhHEt3yFJNeb3dG2rk7/HM9Hm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(86362001)(64756008)(54906003)(76116006)(66476007)(66446008)(66946007)(6916009)(66556008)(6486002)(8936002)(316002)(2906002)(4326008)(8676002)(2616005)(6512007)(122000001)(53546011)(6506007)(508600001)(71200400001)(33656002)(38070700005)(36756003)(83380400001)(5660300002)(7416002)(186003)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXowbDU5UC9HeG5ieG83bkdmKzREak12VXV2TnpkdzVjUlRPU01sUFRMbU9U?=
 =?utf-8?B?YnNPTkVPVWpsQTBIczgzYiswZ1VkRXFqM2ZUYUZlb2JacndIUW1POUFjTVpm?=
 =?utf-8?B?bU1sV3dmd3JQc3pvaE5VbXJ3T1Z6ZElvZ0FTcUJSanhRVXZPTzlYa01WWEI0?=
 =?utf-8?B?NlJCd1N0RXVYU1JndDhDRTVWYi9wTHN1b2l4QXAxUFREWENzQUdsY0hhdW5N?=
 =?utf-8?B?UWhpOUs4MWhvQTNEL05pcVVHcXBEajllVlVMVEE3VzZtNDY3Q3dGMlRZaFk1?=
 =?utf-8?B?YjlDcFdvKzRnNThnNjFSUEZSWXkrWDlERXV5WmJMakoxOHUzSWQvQ1h5dHc1?=
 =?utf-8?B?Z1JGb3JOaXFjQnRKM2E4b1poRHBIUGtnalVEVFg0ZmhhdmQwMkpEdnRDY0ww?=
 =?utf-8?B?UjNOL0NPSjBoRWlBbmtqN1g5aHJ4a1ZoSnlCaldIL01SanM5U1NtbE5mSHYr?=
 =?utf-8?B?WlcxeVVsR0sxOHBmdUVpMUxRMWw4UWdIelJrdGxQSHdMT1g0QUtUOUNjRWla?=
 =?utf-8?B?MExNbGFaZkxCc0cxZmhHbUhCbDByQXBwL3NzWkZ1WVp4ZE9POUlPSDByeU9H?=
 =?utf-8?B?TmV0U3h1cVRVMjJ1dUVlcWZCMlNRb05mRUpZUzBGM25HQWhxaFp2RDhZVFQ3?=
 =?utf-8?B?UXhLdmxVbnRXakMvOWIxOTAyaUtSYisxQ1RGRTZPNXk0UzBIMVIralNZa3lj?=
 =?utf-8?B?ZHhOaXU3M0QyOUFNUlZzMnJpMk5hd045SWNNdmYzeFBob3ZrN20ybW5KVVZ3?=
 =?utf-8?B?TmpPblpsd2oxOCs5RWg4N2wvaDRQejIxcEVtdTUyK1JLU3VId1NpWHBweVlV?=
 =?utf-8?B?ampRTFhDek9IRFZ4TmJNWGd2YnhITDVyTWhSL3lHKytnZXVFQm1BeUxzOFBI?=
 =?utf-8?B?cndjOFNiOUVzYnVFeW5vNmpKSzluVFBoOUxBZ3IxWWEreG5OaFFkcXVmalZS?=
 =?utf-8?B?eVZ4ZERxTTJzcWVGU1UzVVc2eXlQREFuQ0VPbEJkNEpsa2s1RzAxemtGQnEz?=
 =?utf-8?B?ZWQ1SHk4THBvSStXbC9ld2tDeFF0Mm43Ylh5TDlRNzUvUndIVDVTWTY4c21p?=
 =?utf-8?B?Q3dUTURCaXdXeEt2dnp4cmJmVjlIRzIxaHlYTko1alM2OVJaTU1OUi9PelJV?=
 =?utf-8?B?eGhKZ01CNWVQM1JBTHRWSW1UcUI3eExzOHpYRTFoQnlZdVNZTGt5d0ZXek9v?=
 =?utf-8?B?bnJnUlZzRHV4cUhzbFA0RVVPMU5VOFJJUlBxL1BkWWhRRDJBc1pnTVQ0ZnlV?=
 =?utf-8?B?NG1qN2RxaXVCdy9zTzFzQVNiU3pDU1R6NHBmM2lMclg4b3MzSitpNEp0cWJh?=
 =?utf-8?B?MkFoTXNxVi9icEJTTUlrWnc3djNSd0dTUHBMUGNmSVR6VWZ5Y0ZJTW1ad2kw?=
 =?utf-8?B?NVNQWThmQys4WnJERyt1ZUNrVmFBNVRmMTFiS1RsUWxLSnBVZ0FscHkwYWo5?=
 =?utf-8?B?SnZiMktOQ3hsRDZYeGJRclcxbmhOZHRSR213dUl2dXd4d2dVRzhSR0dscWV0?=
 =?utf-8?B?S1JGVGNoL1NiVHUzL1dlR0dkV2ZnbjAxVVVzWUovQ3JlMHFjS1oycmU2VStS?=
 =?utf-8?B?RGZoTGpZeitYYm9abUpOL20rcERxZzFzNWwrYWcrdDhXdFRHcVFkVVJ5NlE5?=
 =?utf-8?B?Rkt4aERZdk9YUEJYbGlTSWszTVhPUkhDWTBkc0RFL01sYjRKY2tQZis1Yjla?=
 =?utf-8?B?YXpsUTk0QkJDNk9pNVgzYjZQMVUxRzVpelM0S2ZTSVA0NmVKVTREMldIMks2?=
 =?utf-8?B?VXpvdVBodEJNbGl4dUNJNjU0QmVBZW8rVXNGYVZXQ3VhVW03NmJhV2pCMm5N?=
 =?utf-8?B?T2Vrd1dkSVo1M24wSXJnYmZKakZ3Wm9kVGYweHRwYkV5bTJXVlNuYWxHU0RL?=
 =?utf-8?B?eHdGRm9vU0xIK1dEb3RqRjhZUGw1bndpNXp5TTV1cFpjTWxCMDFqODRSS1pk?=
 =?utf-8?B?d0tqMmtHYklBRUxGd2Zwbk1PTDJubytZb2hzZkkzTC85ajZ1elNCZkF1VVY3?=
 =?utf-8?B?T0s0VjRkSXFnc0lvMUVxUE96WWlkdmNRV3huU0FZUzZ5aVB0WnRRdm91REk3?=
 =?utf-8?B?eE03NlJzQ2JLbHRTdTZDVGtqZStBRXI3Yk9DdXo2M3FQZVE5ZlYzVi9lWk1O?=
 =?utf-8?B?U2c4WU1ERXllWFYrbXp1NFlZTlZRanlmTnNGeXhuNGNOT1JBK1Fudjh5Q3lq?=
 =?utf-8?B?SGlEQVBTWWNrRUxQbEZWRFJJWkVwRXdjbzhpRkRYTVZlcjEwR0IydVNwdGNI?=
 =?utf-8?B?QnN6bVRadUV6OVgrbHJqZzBNNmpEYlZldlhka0ZtdS9iVEp3aXY3dTVFS3ph?=
 =?utf-8?B?aWwvenFneVIrZjRjSmVrbTZjQkJvMHkxeXlhd2NpdDBwbkFuRW9idDZjNGxG?=
 =?utf-8?Q?mHmKc2T/HFL8+hyRCTPRgsouPxsMOEczR237ITlZQ9cuH?=
x-ms-exchange-antispam-messagedata-1: N+5/wkiwLqk9fgkjor0INUd5g0MS4mvNzYDwF2RbObtkguBPPT6QOeDm
Content-Type: text/plain; charset="utf-8"
Content-ID: <2ABD868E1EF9DD46BF83BFD79EF9C987@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778bf276-b6f8-4de8-d3b4-08da3294411c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 14:49:15.5147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bqNzGJO7Ir6GxsLOW6B4q2lhUSpXFBljFfev/XPz82QE+S+x+lS1KZ4KYOg8HwdD8ObdROiG80HPwdEsiNq1V86zo5q2t7K+hfeaTUiTQcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4369
X-Proofpoint-GUID: vqy7wBOHF-JqaTEjpVRztRo5g47oraAY
X-Proofpoint-ORIG-GUID: vqy7wBOHF-JqaTEjpVRztRo5g47oraAY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDEwLCAyMDIyLCBhdCAxMDoyMiBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gU2F0LCBBcHIgMzAsIDIwMjIsIEpv
biBLb2hsZXIgd3JvdGU6DQo+PiANCj4+PiBPbiBBcHIgMzAsIDIwMjIsIGF0IDU6NTAgQU0sIEJv
cmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPiB3cm90ZToNCj4+PiBTbyBsZXQgbWUgdHJ5IHRv
IHVuZGVyc3RhbmQgdGhpcyB1c2UgY2FzZTogeW91IGhhdmUgYSBndWVzdCBhbmQgYSBidW5jaA0K
Pj4+IG9mIHZDUFVzIHdoaWNoIGJlbG9uZyB0byBpdC4gQW5kIHRoYXQgZ3Vlc3QgZ2V0cyBzd2l0
Y2hlZCBiZXR3ZWVuIHRob3NlDQo+Pj4gdkNQVXMgYW5kIEtWTSBkb2VzIElCUEIgZmx1c2hlcyBi
ZXR3ZWVuIHRob3NlIHZDUFVzLg0KPj4+IA0KPj4+IFNvIGVpdGhlciBJJ20gbWlzc2luZyBzb21l
dGhpbmcgLSB3aGljaCBpcyBwb3NzaWJsZSAtIGJ1dCBpZiBub3QsIHRoYXQNCj4+PiAicHJvdGVj
dGlvbiIgZG9lc24ndCBtYWtlIGFueSBzZW5zZSAtIGl0IGlzIGFsbCB3aXRoaW4gdGhlIHNhbWUg
Z3Vlc3QhDQo+Pj4gU28gdGhhdCBleGlzdGluZyBiZWhhdmlvciB3YXMgc2lsbHkgdG8gYmVnaW4g
d2l0aCBzbyB3ZSBtaWdodCBqdXN0IGFzDQo+Pj4gd2VsbCBraWxsIGl0Lg0KPj4gDQo+PiBDbG9z
ZSwgaXRzIG5vdCAxIGd1ZXN0IHdpdGggYSBidW5jaCBvZiB2Q1BVLCBpdHMgYSBidW5jaCBvZiBn
dWVzdHMgd2l0aA0KPj4gYSBzbWFsbCBhbW91bnQgb2YgdkNQVXMsIHRoYXRzIHRoZSBzbWFsbCBu
dWFuY2UgaGVyZSwgd2hpY2ggaXMgb25lIG9mIA0KPj4gdGhlIHJlYXNvbnMgd2h5IHRoaXMgd2Fz
IGhhcmQgdG8gc2VlIGZyb20gdGhlIGJlZ2lubmluZy4gDQo+PiANCj4+IEFGQUlLLCB0aGUgS1ZN
IElCUEIgaXMgYXZvaWRlZCB3aGVuIHN3aXRjaGluZyBpbiBiZXR3ZWVuIHZDUFVzDQo+PiBiZWxv
bmdpbmcgdG8gdGhlIHNhbWUgdm1jcy92bWNiIChpLmUuIHRoZSBzYW1lIGd1ZXN0KSwgZS5nLiB5
b3UgY291bGQgDQo+PiBoYXZlIG9uZSBWTSBoaWdobHkgb3ZlcnN1YnNjcmliZWQgdG8gdGhlIGhv
c3QgYW5kIHlvdSB3b3VsZG7igJl0IHNlZQ0KPj4gZWl0aGVyIHRoZSBLVk0gSUJQQiBvciB0aGUg
c3dpdGNoX21tIElCUEIuIEFsbCBnb29kLiANCj4gDQo+IE5vLCBLVk0gZG9lcyBub3QgYXZvaWQg
SUJQQiB3aGVuIHN3aXRjaGluZyBiZXR3ZWVuIHZDUFVzIGluIGEgc2luZ2xlIFZNLiAgRXZlcnkN
Cj4gdkNQVSBoYXMgYSBzZXBhcmF0ZSBWTUNTL1ZNQ0IsIGFuZCBzbyB0aGUgc2NlbmFyaW8gZGVz
Y3JpYmVkIGFib3ZlIHdoZXJlIGEgc2luZ2xlDQo+IFZNIGhhcyBhIGJ1bmNoIG9mIHZDUFVzIHJ1
bm5pbmcgb24gYSBsaW1pdGVkIHNldCBvZiBsb2dpY2FsIENQVXMgd2lsbCBlbWl0IElCUEINCj4g
b24gZXZlcnkgc2luZ2xlIHN3aXRjaC4NCg0KQWghIFJpZ2h0LCBvayB0aGFua3MgZm9yIGhlbHBp
bmcgbWUgZ2V0IG15IHdpcmVzIHVuY3Jvc3NlZCB0aGVyZSwgSSB3YXMgZ2V0dGluZw0KY29uZnVz
ZWQgZnJvbSB0aGUgbmVzdGVkIG9wdGltaXphdGlvbiBtYWRlIG9uDQo1YzkxMWJlZmYgS1ZNOiBu
Vk1YOiBTa2lwIElCUEIgd2hlbiBzd2l0Y2hpbmcgYmV0d2VlbiB2bWNzMDEgYW5kIHZtY3MwMg0K
DQpTbyB0aGUgb25seSB0aW1lIHdl4oCZZCAqbm90KiBpc3N1ZSBJQlBCIGlzIGlmIHRoZSBjdXJy
ZW50IHBlci12Y3B1IHZtY3Mvdm1jYiBpcw0Kc3RpbGwgbG9hZGVkIGluIHRoZSBub24tbmVzdGVk
IGNhc2UsIG9yIGJldHdlZW4gZ3Vlc3RzIGluIHRoZSBuZXN0ZWQgY2FzZS4NCg0KV2Fsa2luZyB0
aHJvdWdoIG15IHRob3VnaHRzIGFnYWluIGhlcmUgd2l0aCB0aGlzIGZyZXNoIGluIG15IG1pbmQ6
DQoNCkluIHRoYXQgZXhhbXBsZSwgc2F5IGd1ZXN0IEEgaGFzIHZDUFUwIGFuZCB2Q1BVMSBhbmQg
aGFzIHRvIHN3aXRjaA0KaW4gYmV0d2VlbiB0aGUgdHdvIG9uIHRoZSBzYW1lIHBDUFUsIGl0IGlz
buKAmXQgZG9pbmcgYSBzd2l0Y2hfbW0oKQ0KYmVjYXVzZSBpdHMgdGhlIHNhbWUgbW1fc3RydWN0
OyBob3dldmVyLCBJ4oCZZCB3YWdlciB0byBzYXkgdGhhdCBpZiB5b3UNCmhhZCBhbiBhdHRhY2tl
ciBvbiB0aGUgZ3Vlc3QgVk0sIGV4ZWN1dGluZyBhbiBhdHRhY2sgb24gdkNQVTAgd2l0aA0KdGhl
IGludGVudCBvZiBhdHRhY2tpbmcgdkNQVTEgKHdoaWNoIGlzIHVwIHRvIHJ1biBuZXh0KSwgeW91
IGhhdmUgZmFyDQpiaWdnZXIgcHJvYmxlbXMsIGFzIHRoYXQgd291bGQgaW1wbHkgdGhlIGd1ZXN0
IGlzIGNvbXBsZXRlbHkNCmNvbXByb21pc2VkLCBzbyB3aHkgd291bGQgdGhleSBldmVuIHdhc3Rl
IHRpbWUgb24gYSBjb21wbGV4DQpwcmVkaWN0aW9uIGF0dGFjayB3aGVuIHRoZXkgaGF2ZSB0aGF0
IGxldmVsIG9mIHN5c3RlbSBhY2Nlc3MgaW4NCnRoZSBmaXJzdCBwbGFjZT8NCg0KR29pbmcgYmFj
ayB0byB0aGUgb3JpZ2luYWwgY29tbWl0IGRvY3VtZW50YXRpb24gdGhhdCBCb3JpcyBjYWxsZWQg
b3V0LCANCnRoYXQgc3BlY2lmaWNhbGx5IHNheXM6DQoNCiAgICogTWl0aWdhdGUgZ3Vlc3RzIGZy
b20gYmVpbmcgYXR0YWNrZWQgYnkgb3RoZXIgZ3Vlc3RzLg0KICAgICAtIFRoaXMgaXMgYWRkcmVz
c2VkIGJ5IGlzc2luZyBJQlBCIHdoZW4gd2UgZG8gYSBndWVzdCBzd2l0Y2guDQoNClNpbmNlIHlv
dSBuZWVkIHRvIGdvIHRocm91Z2ggc3dpdGNoX21tKCkgdG8gY2hhbmdlIG1tX3N0cnVjdCBmcm9t
DQpHdWVzdCBBIHRvIEd1ZXN0IEIsIGl0IG1ha2VzIG5vIHNlbnNlIHRvIGlzc3VlIHRoZSBiYXJy
aWVyIGluIEtWTSwNCmFzIHRoZSBrZXJuZWwgaXMgYWxyZWFkeSBnaXZpbmcgdGhhdCDigJxmb3Ig
ZnJlZeKAnSAoZnJvbSBLVk3igJlzIHBlcnNwZWN0aXZlKSBhcw0KdGhlIGd1ZXN0LXRvLWd1ZXN0
IHRyYW5zaXRpb24gaXMgYWxyZWFkeSBjb3ZlcmVkIGJ5IGNvbmRfbWl0aWdhdGlvbigpLg0KDQpU
aGF0IHdvdWxkIGFwcGx5IGVxdWFsbHkgZm9yIHN3aXRjaGVzIHdpdGhpbiBib3RoIG5lc3RlZCBh
bmQgbm9uLW5lc3RlZA0KY2FzZXMsIGJlY2F1c2Ugc3dpdGNoX21tIG5lZWRzIHRvIGJlIGNhbGxl
ZCBiZXR3ZWVuIGd1ZXN0cy4NCg0K
