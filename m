Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E29850A553
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiDUQ1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390580AbiDUQO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:14:27 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731152B241;
        Thu, 21 Apr 2022 09:11:37 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23LEoZ6D009552;
        Thu, 21 Apr 2022 09:09:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=Nd3pvBUgx3ZkEcUrlTeAebKAUrQq3nmXGf6O8UblcTg=;
 b=dQoGaizJGIISMwPHLPLxIu6/jix3LvVrQC/swwaNCS7q0b69isendnSJpZx+/7xQj20y
 zfy0klNJfy0OYR0pf/DDsno394OO+R+N85wQyN0V9iDGPEwsDK3kBuZ6ka6MWL3SsAXu
 OveRqQnx8ptt8lozd4TpEy9GOwVw8r2/EVNyEL6X4CuUQw0pBCtvkozT2cl4sCw/Xf8M
 e7/aTT7m2sO/uEMA+YhCErUZBp0VQTxJIxAPF8Y43NwjnPEc6NT4OPh0lBec/91GD8/B
 vt8pStPZ5DCAH8s5dBAyd8ZSoJ+pXMGNzym5PNiXcmLS9UtQ7vzuMOQ3+Ac30PtpSL3z 5A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3ffuwh30xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 09:09:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZo5fQ4cronq7BRNuSdMfh3mlN89z7z2tP79wdchhgVqhxm0FHcFNDAiwSuWNFZ4yPHd6GsExus3IwH4WUZo03CnS1sWhSgTjWYbsaPS8VxWZuQgRk5BYZAfiRAiKr9mliDjgqjlry/BvTbU4JLyu0SWKeX49iPUoND4TRaN9PTl7TKoD34mSX98pkVRo+xJQmLC0MxXMj3v8bC93JjQz5ox7QAVpCvAKqp6h0MEti/Zpplv5sn1yK0UutoxwMcWZBC77kmf5iVt03AnjXIkF8qsyoAa+7GOXzk72YpB5xpqoEXhS37UnZcaKGguIln3gtQGcgyCSAn36WPXkRYc5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nd3pvBUgx3ZkEcUrlTeAebKAUrQq3nmXGf6O8UblcTg=;
 b=lAKywGR00eiv0OZaFExtzUE9zCRVJmIhv5ejO4FU7sDi6zElrJM2CAiV4jRm/bfDNJRbY37/ik+fLxCiMRVdYwkXdPRvBAsVnL7RivrHLfc6zqEaaMuJrv70CHI0ab4Jb/a1CDsAdHJ5k+s+6QnKDiMzY8ud3qnzKWb6rHXVLeaLIZi2DIIpPJkTIG2QyHaMqu5DNnV6zZ9LlVWvuNwOGkwCa+B2NzosGVlvwGtuQTOkLx80scGP47u9nVmRsmFhhtZF47muMrbv3op8BZH2ksv16XGCmEKC8GYAn1dntR7ro64HkJruxQ8qb0RB72ahpczKTKJc4aKv97KGVrD/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM5PR02MB2412.namprd02.prod.outlook.com (2603:10b6:3:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 16:09:08 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 16:09:08 +0000
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
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Topic: [PATCH v2] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Index: AQHYU5FPys8/+CxhhU+oMPFxgnRLvqz6f4iAgAANloA=
Date:   Thu, 21 Apr 2022 16:09:08 +0000
Message-ID: <66F7B701-D081-4F42-9EC1-774C88F9F8FD@nutanix.com>
References: <20220419020011.65995-1-jon@nutanix.com>
 <YmF2PRDi12KPsFOC@google.com>
In-Reply-To: <YmF2PRDi12KPsFOC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e24db70-d9eb-4e17-aeb3-08da23b14428
x-ms-traffictypediagnostic: DM5PR02MB2412:EE_
x-microsoft-antispam-prvs: <DM5PR02MB24129AD9B1C3CE808E3854CFAFF49@DM5PR02MB2412.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8qyKGU2Bl+OJo/pV7P+ndJ8451h2j6+gXbteZkHiI2pZr8SKIOkhC7u0AgR1MS7PPZ/wKB4XWQDzid3jf3EnP9fwCPcNUYLOmdx32746JNPQ19pvwSS0YmcVAJk1zlIRHsHOkTbfbaHCE5kX2z/k1jeHy5n/hk26ZNBNN2oOGhnItpF7L68O55WhByitJhDniMg3Sm/wQa40/p/Sp6V/SkjAbTESylxC+rHsmCmfYBw3RCM9KJWTcWCxC1svPpgMPyElv1jOPz9eOAlr3WQG2uoh3emIS2m0o487Yfv3vjTA4Hp9DKPTQCq3fCWiDeEzrk4Jc5sQ4Rne5HZurGHcjhqb0HRhboYZMuhk7irYDoUHXc6Zbi+/U4tU4+13PRJIbe9R1hW9ILYdvpSUYt8uu7muEakGjd9G6Zy9icgWfURiV1CYsKKlYxlUTgAfRy1TFWUqtbdg7PHLhWJtcCBwl7OjpjM/D2niYO8oc47t95f3PX2cwYDaFYlCQE3y0fn6CvhBeGahp+3G8Z0I3AHoXkfNrDDrtmJBP3ABRRFw7z4YgL5UIfBegJ9v5IWITs00VrP8c7vIcRB/hi+aO2Xk8UyDTR6c+Yi6gcEVDL69LzqoyleBnKr1HjtQm6WeUdYfgARefkCPIerac884dp53kMJ05qUKyEjNF7MU5HMCJ4rLpiYeStbSwdZ+42H2cjt8ZnVLgTU8J6YusNud769ipOGUU+vbagtyWj1YvUahagAi3OQCENmMf5AyPrPbV4GY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(6506007)(53546011)(2906002)(83380400001)(6512007)(33656002)(508600001)(316002)(38100700002)(38070700005)(7416002)(6916009)(36756003)(6486002)(122000001)(54906003)(86362001)(5660300002)(91956017)(2616005)(4326008)(8676002)(66476007)(8936002)(66946007)(76116006)(66446008)(66556008)(64756008)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWo1eFRBMEhYeWdLemkrWVRzeGcxTXpVaHM1Zm9Ga0doaFByeXpMeStsVm8w?=
 =?utf-8?B?Q2JYWjBEZjJmRSt4ZGczWm1Zelc1VDdIeWVGQk5IazU0QlE4TFZ3WjFaWXJu?=
 =?utf-8?B?N0dlSFVXL2RYN1RLSHVYQm9FZ0Fudzg5b1ZCZkVGOGtseUxVZTh0Y1pkWEgx?=
 =?utf-8?B?bG9YTkpSU052QUdVdDJzOGNxcStDQ2NXRTlqTTBQei83RW1OSkFVMHhNUy95?=
 =?utf-8?B?akJNeEoycEtNOFhQcXRRYlpXeExZY01ZRE9xRHVJM3QzRDhPZG5jVEZ2d3VM?=
 =?utf-8?B?QzJmdXhJeUE5d2xwUWlFQUVOV2xVRFNtZUt3REhtUUNJS3N0RnFKenJwU2JY?=
 =?utf-8?B?OHhhN2dwSlNtK2RhblRtQ0hCVjdxWk0vS3k2UHJhZmlLWS9wdXg3TG0weFdv?=
 =?utf-8?B?Z2RJeWlPTmZtcHBKaGZFR2dPQUcwMVNqbkR2MEtETTJBc3VCZTFvcTNLcWJG?=
 =?utf-8?B?YUM2Y3ZWYzJTV2JBaGJzcGdlZkZMZ013N2xkbHZzaWhCWVdNSzVHRGVkeWRi?=
 =?utf-8?B?N1o2VHIzLzk0dlZvWThtc1paUVg4K1ZoLzlnZGpHTFRPV2FYTVY1L0w5OVF2?=
 =?utf-8?B?Y2dGd0ZiT0QvelJ6MUxNOUoyWmljZXB0R29RVjFTWk1Ta2txWEF1Qjk5eGlz?=
 =?utf-8?B?K3h0NTl4U1JPVGdjSExNa21Fc2VQWXpwc3MrQzVzb3BCLytxUUc4UCtsNEpU?=
 =?utf-8?B?MGgrSktqM1c2SzNUc3huN0pFQ2VyU0ZWM0hReDErVHVBSFQrNjJiRTZpK3Fm?=
 =?utf-8?B?UVpJZVF3QzlpTnZrRWJ6QWpKbXBHVm5XWDBqVWFZaFpGcDVoblVVcDVmVC9R?=
 =?utf-8?B?WkZ1V2t1eXV3UGxlOURrSzA0QzJMZnNROHFhNWM5Q2w0U0wzcmVTQkNGbHhN?=
 =?utf-8?B?ZDVUUFdrY1ErUFFMKzgxQnUvb1NEa2NDU3FlOTlBalgrWEhTa0VNaFczTGdu?=
 =?utf-8?B?azROV0pwSEdDbG5abFhBTnA2bWxFRWJRM1N6dm5wZXcveDBodnRFT3Rhek9o?=
 =?utf-8?B?NCtyZVhsSzU4eE1BS3h0Tnh1eEtKb0xXQTQzMWhYMXFzOVdUWGFtUG1PTDdr?=
 =?utf-8?B?VTUwSFB2YXRmSWpGbHlCcitBbHhmbzcvTXZoSVRwMnJMYWpqZHpJbEpOUk83?=
 =?utf-8?B?dlQ2a1oycU5KYktXc0N0NzgzSlRWOVVGN2Z3TnBoeVNFKzNYUCtDOGFLbHVD?=
 =?utf-8?B?ZlJrVzd5MENqUVB6UUQ0OGh4TVh5K3dkZDB6SFNiazhxNmZvbUlMTzNtVWU3?=
 =?utf-8?B?ZWlSQTNORWJPU04wN01Cb0w1bEtMQXN6SkI0TXJZekM3OUVBdDN6d2xkbXl1?=
 =?utf-8?B?ZTJRZWRXdXRONU5mZlNjNUZXZWdpUXNmUlo0RkJMVndMUmZmSGx5SzlBRUV6?=
 =?utf-8?B?VzdvOTJkZGlyYkVPNXE3dGlPelA4NkZ1eVp3TU45UC9LN3VnZ1F2VXRYSTJN?=
 =?utf-8?B?eHBYNnZSZ2haUnkyYlhOZjlUelZ2RmRhNDBES0lBMVowMmhSWmJoZFoyaFpa?=
 =?utf-8?B?WG9WbWo1QkVwL1ZVUlRCZE5PaUkzaTZ1c0QxN3NvVWkyKzNMODZtcEtMK1pu?=
 =?utf-8?B?eGt4TXF4TnBqVnhZUjlYY2J2YTVhQkdhc0J2TDZOS2dRS2xwR1pRUEpMalZS?=
 =?utf-8?B?WWE0S0R5ZUtXbGJpZThxRytDSWt3M1VNY1JBUmMxSER4RUdrOWhrT2xSN2NC?=
 =?utf-8?B?c2c2K3Q0VEVsVGYyaWhUWVI2WXBXMDJLN2hZUTVkOVV0T0pCQks4QWw3K2pY?=
 =?utf-8?B?WDY0WG5yVXZUR0JGU01jWXVkMmpEelB3dFd4QVBqYTV5VDIzcXB3SjJPLy8r?=
 =?utf-8?B?THQ3OGllZi9pUEkrRGhnRXUrRDNrY1BFQVlsN0EwbHFpUjE3V3hhTVM2d2xp?=
 =?utf-8?B?bkNJUjlhWmJDenA4LzhjQkJDMFRXWnRmdExmaWZLZ25ocVRBZzJqS3FITGJG?=
 =?utf-8?B?ZmQ2cWlxSTlHdHo0U0gyNTlpbVdlcFJ4WmhvdXRFT2R4SXNPL3hKNk9EUGFj?=
 =?utf-8?B?eDMxNkVYYmZBZStzTnh1Q3hMNkpCU200L09ScUtmM2U2dWJqWEhUWlZ6dXNI?=
 =?utf-8?B?Z3Y3SThZeVJRMWVUbWVVcnh5Yk5lUEMyZnUzWjJWZGJhSWx5Y21ST0hQN2VN?=
 =?utf-8?B?QVNDakx4YXAxbDhjMG9kaUQyaHllYnpJNG5hTEZRZU9uT21nTmdOQ3pJaGVr?=
 =?utf-8?B?Y0pkOFFReVVnRDBEMWxkTWpXeWNPRVU5L2ZBL29meU10dDdMdTA2MVZIbUM4?=
 =?utf-8?B?WWpJYXdtTjUvRHloaVNLcFhOaTZ0dFBrMTY5aDE5SDVZUitnNGR1QTZ0Y2FC?=
 =?utf-8?B?NW5XSTJvODNLaWc2akgvUGlhUjBjN0VRRjhDSWRYbDIxWVRadWxrai9QckN3?=
 =?utf-8?Q?XWeJK1i4cWrSsTD0jr+1t9auQmyel7evsJDS9P/ZIZMRS?=
x-ms-exchange-antispam-messagedata-1: JGCh5/UknUgKV0G71NYtwnwQteJ5FjLE2w0U+qLdiSFq2tLpUOyoESIo
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ADF0226FA4DBC40B4F0214316C1DB30@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e24db70-d9eb-4e17-aeb3-08da23b14428
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 16:09:08.5421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RtI0fIFTjROMaznxeUB0xLZnotPIZjLzVoPKbJzdLi44asoznSpLNYC4GJRvF2MFk43jFcpLg5mQv+YuawE/HDJ/tGtzLAzTinGQAdUVVPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2412
X-Proofpoint-ORIG-GUID: 20hpF1k1-zAHkoh9juqbM0skjlaiexbc
X-Proofpoint-GUID: 20hpF1k1-zAHkoh9juqbM0skjlaiexbc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_02,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDIxLCAyMDIyLCBhdCAxMToyMCBBTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBBcHIgMTgsIDIwMjIsIEpv
biBLb2hsZXIgd3JvdGU6DQo+PiBPbiB2bXhfdmNwdV9sb2FkX3ZtY3MgYW5kIHN2bV92Y3B1X2xv
YWQsIHJlc3BlY3QgdXNlciBjb250cm9sbGVkDQo+PiBjb25maWd1cmF0aW9uIGZvciBjb25kaXRp
b25hbCBJQlBCIGFuZCBvbmx5IGF0dGVtcHQgSUJQQiBNU1Igd2hlbg0KPj4gc3dpdGNoaW5nIGJl
dHdlZW4gZGlmZmVyZW50IGd1ZXN0IHZDUFVzIElGRiBzd2l0Y2hfbW1fYWx3YXlzX2licGIsDQo+
PiB3aGljaCBmaXhlcyBhIHNpdHVhdGlvbiB3aGVyZSB0aGUga2VybmVsIHdpbGwgaXNzdWUgSUJQ
Qg0KPj4gdW5jb25kaXRpb25hbGx5IGV2ZW4gd2hlbiBjb25kaXRpb25hbCBJQlBCIGlzIGVuYWJs
ZWQuDQo+PiANCj4+IElmIGEgdXNlciBoYXMgc3BlY3RyZV92Ml91c2VyIG1pdGlnYXRpb24gZW5h
YmxlZCwgaW4gYW55DQo+PiBjb25maWd1cmF0aW9uLCBhbmQgdGhlIHVuZGVybHlpbmcgcHJvY2Vz
c29yIHN1cHBvcnRzIFg4Nl9GRUFUVVJFX0lCUEIsDQo+PiBYODZfRkVBVFVSRV9VU0VfSUJQQiBp
cyBzZXQgYW5kIGFueSBjYWxscyB0bw0KPj4gaW5kaXJlY3RfYnJhbmNoX3ByZWRpY3Rpb25fYmFy
cmllcigpIHdpbGwgaXNzdWUgSUJQQiBNU1IuDQo+PiANCj4+IERlcGVuZGluZyBvbiB0aGUgc3Bl
Y3RyZV92Ml91c2VyIGNvbmZpZ3VyYXRpb24sIGVpdGhlcg0KPj4gc3dpdGNoX21tX2Fsd2F5c19p
YnBiIGtleSBvciBzd2l0Y2hfbW1fY29uZF9pYnBiIGtleSB3aWxsIGJlIHNldC4NCj4+IA0KPj4g
Qm90aCBzd2l0Y2hfbW1fYWx3YXlzX2licGIgYW5kIHN3aXRjaF9tbV9jb25kX2licGIgYXJlIGhh
bmRsZWQgYnkNCj4+IHN3aXRjaF9tbSgpIC0+IGNvbmRfbWl0aWdhdGlvbigpLCB3aGljaCB3b3Jr
cyB3ZWxsIGluIGNhc2VzIHdoZXJlDQo+PiBzd2l0Y2hpbmcgdkNQVXMgKGkuZS4gc3dpdGNoaW5n
IHRhc2tzKSBhbHNvIHN3aXRjaGVzIG1tX3N0cnVjdDsNCj4+IGhvd2V2ZXIsIHRoaXMgbWlzc2Vz
IGEgcGFyYW5vaWQgY2FzZSB3aGVyZSB1c2VyIHNwYWNlIG1heSBiZSBydW5uaW5nDQo+PiBtdWx0
aXBsZSBndWVzdHMgaW4gYSBzaW5nbGUgcHJvY2VzcyAoaS5lLiBzaW5nbGUgbW1fc3RydWN0KS4N
Cj4+IA0KPj4gVGhpcyBwYXJhbm9pZCBjYXNlIGlzIGFscmVhZHkgY292ZXJlZCBieSB2bXhfdmNw
dV9sb2FkX3ZtY3MgYW5kDQo+PiBzdm1fdmNwdV9sb2FkOyBob3dldmVyLCB0aGlzIGlzIGRvbmUg
YnkgY2FsbGluZw0KPj4gaW5kaXJlY3RfYnJhbmNoX3ByZWRpY3Rpb25fYmFycmllcigpIGFuZCB0
aHVzIHRoZSBrZXJuZWwNCj4+IHVuY29uZGl0aW9uYWxseSBpc3N1ZXMgSUJQQiBpZiBYODZfRkVB
VFVSRV9VU0VfSUJQQiBpcyBzZXQuDQo+IA0KPiBUaGUgY2hhbmdlbG9nIHNob3VsZCBjYWxsIG91
dCB0aGF0IHN3aXRjaF9tbV9jb25kX2licGIgaXMgaW50ZW50aW9uYWxseSAiaWdub3JlZCINCj4g
Zm9yIHRoZSB2aXJ0IGNhc2UsIGFuZCBleHBsYWluIHdoeSBpdCdzIG5vbnNlbnNpY2FsIHRvIGVt
aXQgSUJQQiBpbiB0aGF0IHNjZW5hcmlvLg0KDQpPayB3aWxsIGRvLCB0aGFua3MNCg0KPiANCj4+
IEZpeCBieSB1c2luZyBpbnRlcm1lZGlhcnkgY2FsbCB0byB4ODZfdmlydF9ndWVzdF9zd2l0Y2hf
aWJwYigpLCB3aGljaA0KPj4gZ2F0ZXMgSUJQQiBNU1IgSUZGIHN3aXRjaF9tbV9hbHdheXNfaWJw
YiBpcyB0cnVlLiBUaGlzIGlzIHVzZWZ1bCBmb3INCj4+IHNlY3VyaXR5IHBhcmFub2lkIFZNTXMg
aW4gZWl0aGVyIHNpbmdsZSBwcm9jZXNzIG9yIG11bHRpLXByb2Nlc3MgVk1NDQo+PiBjb25maWd1
cmF0aW9ucy4NCj4gDQo+IE11bHRpLXByb2Nlc3MgVk1NPyAgS1ZNIGRvZXNuJ3QgYWxsb3cgInNo
YXJpbmciIGEgVk0gYWNyb3NzIHByb2Nlc3Nlcy4gIFVzZXJzcGFjZQ0KPiBjYW4gc2hhcmUgZ3Vl
c3QgbWVtb3J5IGFjcm9zcyBwcm9jZXNzZXMsIGJ1dCB0aGF0J3Mgbm90IHJlbGV2YW50IHRvIGFu
IElCUEIgb24NCj4gZ3Vlc3Qgc3dpdGNoLiAgSSBzdXNwZWN0IHlvdSdyZSBsb29zZWx5IHJlZmVy
cmluZyB0byBhbGwgb2YgdXNlcnNwYWNlIGFzIGEgc2luZ2xlDQo+IFZNTS4gIFRoYXQncyBpbmFj
Y3VyYXRlLCBvciBhdCBsZWFzdCB1bm5lY2Vzc2FyaWx5IGNvbmZ1c2luZywgZnJvbSBhIGtlcm5l
bA0KPiBwZXJzcGVjdGl2ZS4gIEkgYW0gbm90IGF3YXJlIG9mIGEgVk1NIHRoYXQgcnVucyBhcyBh
IG1vbm9saXRoaWMgImRhZW1vbiIgYW5kIGZvcmtzDQo+IGEgbmV3IHByb2Nlc3MgZm9yIGV2ZXJ5
IFZNLiAgQW5kIGV2ZW4gaW4gc3VjaCBhIGNhc2UsIEkgd291bGQgYXJndWUgdGhhdCBtb3N0DQo+
IHBlb3BsZSB3b3VsZCByZWZlciB0byBlYWNoIHByb2Nlc3MgYXMgYSBzZXBhcmF0ZSBWTU0uDQo+
IA0KPiBJZiB0aGVyZSdzIGEgYmx1cmIgYWJvdXQgdGhlIHN3aXRjaF9tbV9jb25kX2licGIgY2Fz
ZSBiZWluZyBub25zZW5zaWNhbCwgdGhlcmUncw0KPiBwcm9iYWJseSBhIGdvb2Qgc2VndWUgaW50
byBzdGF0aW5nIHRoZSBuZXcgYmVoYXZpb3IuDQoNClllYSwgdGhhdHMgd2hhdCBJIHdhcyBnZXR0
aW5nIGF0IGJ1dCBmYWlsZWQgdG8gd29yZHNtaXRoIGl0IG5pY2VseS4gSeKAmWxsIHNoYXJwZW4g
aXQgdXANCmFuZCBpbnRlZ3JhdGUgeW91ciBmZWVkYmFjayBpbnRvIGEgdjMNCg0KPiANCj4+IHN3
aXRjaF9tbV9hbHdheXNfaWJwYiBrZXkgaXMgdXNlciBjb250cm9sbGVkIHZpYSBzcGVjdHJlX3Yy
X3VzZXIgYW5kDQo+PiB3aWxsIGJlIHRydWUgZm9yIHRoZSBmb2xsb3dpbmcgY29uZmlndXJhdGlv
bnM6DQo+PiAgc3BlY3RyZV92Ml91c2VyPW9uDQo+PiAgc3BlY3RyZV92Ml91c2VyPXByY3RsLGli
cGINCj4+ICBzcGVjdHJlX3YyX3VzZXI9c2VjY29tcCxpYnBiDQo+PiANCj4+IFNpZ25lZC1vZmYt
Ynk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4NCj4+IENjOiBTZWFuIENocmlzdG9waGVy
c29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4+IENjOiBBbmRyZWEgQXJjYW5nZWxpIDxhYXJjYW5n
ZUByZWRoYXQuY29tPg0KPj4gQ2M6IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPg0K
Pj4gQ2M6IEpvc2ggUG9pbWJvZXVmIDxqcG9pbWJvZUByZWRoYXQuY29tPg0KPj4gQ2M6IFdhaW1h
biBMb25nIDxsb25nbWFuQHJlZGhhdC5jb20+DQo+PiAtLS0NCj4+IHYxIC0+IHYyOg0KPj4gLSBB
ZGRyZXNzZWQgY29tbWVudHMgb24gYXBwcm9hY2ggZnJvbSBTZWFuLg0KPj4gDQo+PiBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9zcGVjLWN0cmwuaCB8IDE1ICsrKysrKysrKysrKysrKw0KPj4gYXJjaC94
ODYva2VybmVsL2NwdS9idWdzLmMgICAgICAgfCAgNiArKysrKy0NCj4+IGFyY2gveDg2L2t2bS9z
dm0vc3ZtLmMgICAgICAgICAgIHwgIDIgKy0NCj4+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAg
ICAgICAgIHwgIDIgKy0NCj4+IDQgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMyBk
ZWxldGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Nw
ZWMtY3RybC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vc3BlYy1jdHJsLmgNCj4+IGluZGV4IDUz
OTNiYWJjMDU5OC4uMWFkMTQwYjE3YWQ3IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vc3BlYy1jdHJsLmgNCj4+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NwZWMtY3Ry
bC5oDQo+PiBAQCAtODUsNCArODUsMTkgQEAgc3RhdGljIGlubGluZSB2b2lkIHNwZWN1bGF0aXZl
X3N0b3JlX2J5cGFzc19odF9pbml0KHZvaWQpIHsgfQ0KPj4gZXh0ZXJuIHZvaWQgc3BlY3VsYXRp
b25fY3RybF91cGRhdGUodW5zaWduZWQgbG9uZyB0aWYpOw0KPj4gZXh0ZXJuIHZvaWQgc3BlY3Vs
YXRpb25fY3RybF91cGRhdGVfY3VycmVudCh2b2lkKTsNCj4+IA0KPj4gKy8qDQo+PiArICogSXNz
dWUgSUJQQiB3aGVuIHN3aXRjaGluZyBndWVzdCB2Q1BVcyBJRkYgaWYgc3dpdGNoX21tX2Fsd2F5
c19pYnBiLg0KPiANCj4gRXh0cmEgImlmIiB0aGVyZS4NCj4gDQo+PiArICogUHJpbWFyaWx5IHVz
ZWZ1bCBmb3Igc2VjdXJpdHkgcGFyYW5vaWQgKG9yIG5haXZlKSB1c2VyIHNwYWNlIFZNTXMNCj4+
ICsgKiB0aGF0IG1heSBydW4gbXVsdGlwbGUgVk1zIHdpdGhpbiBhIHNpbmdsZSBwcm9jZXNzLg0K
Pj4gKyAqIEZvciBtdWx0aS1wcm9jZXNzIFZNTXMsIHN3aXRjaGluZyB2Q1BVcywgaS5lLiBzd2l0
Y2hpbmcgdGFza3MsDQo+IA0KPiBBcyBhYm92ZSwgIm11bHRpLXByb2Nlc3MgVk1NcyIgaXMgdmVy
eSBjb25mdXNpbmcsIHRoZXkncmUgcmVhbGx5IGp1c3Qgc2VwYXJhdGUgVk1Ncy4NCj4gU29tZXRo
aW5nIGxpa2UgdGhpcz8NCj4gDQo+ICogRm9yIHRoZSBtb3JlIGNvbW1vbiBjYXNlIG9mIHJ1bm5p
bmcgVk1zIGluIHRoZWlyIG93biBkZWRpY2F0ZWQgcHJvY2VzcywNCj4gKiBzd2l0Y2hpbmcgdkNQ
VXMgdGhhdCBiZWxvbmcgdG8gZGlmZmVyZW50IFZNcywgaS5lLiBzd2l0Y2hpbmcgdGFza3MsIHdp
bGwgYWxzbw0KPiAqIC4uLg0KPiANCj4+ICsgKiB3aWxsIGFsc28gc3dpdGNoIG1tX3N0cnVjdHMg
YW5kIHRodXMgZG8gSVBCUCB2aWEgY29uZF9taXRpZ2F0aW9uKCk7DQo+PiArICogaG93ZXZlciwg
aW4gdGhlIGFsd2F5c19pYnBiIGNhc2UsIHRha2UgYSBwYXJhbm9pZCBhcHByb2FjaCBhbmQgaXNz
dWUNCj4+ICsgKiBJQlBCIG9uIGJvdGggc3dpdGNoX21tKCkgYW5kIHZDUFUgc3dpdGNoLg0KPj4g
KyAqLw0KPj4gK3N0YXRpYyBpbmxpbmUgdm9pZCB4ODZfdmlydF9ndWVzdF9zd2l0Y2hfaWJwYih2
b2lkKQ0KPj4gK3sNCj4+ICsJaWYgKHN0YXRpY19icmFuY2hfdW5saWtlbHkoJnN3aXRjaF9tbV9h
bHdheXNfaWJwYikpDQo+PiArCQlpbmRpcmVjdF9icmFuY2hfcHJlZGljdGlvbl9iYXJyaWVyKCk7
DQo+PiArfQ0KPj4gKw0KPj4gI2VuZGlmDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVs
L2NwdS9idWdzLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYw0KPj4gaW5kZXggNjI5NmUx
ZWJlZDFkLi42YWFmYjAyNzljYmMgMTAwNjQ0DQoNCg==
