Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84DA4FE7B4
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358662AbiDLSQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 14:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiDLSQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 14:16:02 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857774EA0A;
        Tue, 12 Apr 2022 11:13:43 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23CDwM5t013723;
        Tue, 12 Apr 2022 11:12:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=nbGGBdo2MNicY5nMjYC34i7n1LtEw4mT5rCPMN0XmcM=;
 b=cOBAM/5Hdfb/hhYhmav903quaB2dt0iJ7P9QJHxlIoOdbv1YofyOcZzkzw3lWXhoXmTX
 AoqJk6DYiTcC6hWFbUCveXC0/w0vwGGeGnnlLRGk31GRJZp6ZWdBvRZzjGKtuWrfp6kY
 MobuK6C/1/pAHPPLpqXShAZoKutZbTDKnrAosbdrCKCi4v7lNpHjZ2gUj/lWpuPG1gIU
 5SR/W/m4VUq4ZmbM9rx34A7LOHiZI0QYx3ASzjEm6t5sVo3LkQpaRSbhP7w5nlhjsL4L
 xG67r34pe1Fu4JuETw10a1KHyqN3T+WbRDP7iB5CEoKBlu2G+neVMjx/zy1tNC0k8hoo 0w== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fdas9gmdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:12:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKQ6Tn0huynMfe20HKGW12tRhywWBeaZ+zTCuzvY0hFlXHH3xCjXU/SwDiZlh19Mhupny6nEldagjvGN1o6IcJHrWabuwo5jYisK4zfO5DqjhOC5aW0KkMoNIanUrPqvy1WgsleQBzkWVNevJVFhHuGIATKVnbA4dNE4GoM9mtOsNcFbo06J9TvreAvIpXjPpK4+QRaxy0YsiDYi9mgveObsLU8EMmGqpNkMTcr7/SCLWf7xQQX8g//AaRVMF2NE0VKpcadiJY2mpcI/JDBCDks5uJQhv2rVub5tLwetjU+3CGq/AgIDQ/D268yCK2waaI1pA+lRzuyA0oQvkmZSUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbGGBdo2MNicY5nMjYC34i7n1LtEw4mT5rCPMN0XmcM=;
 b=Ha6l5ZrnpnqTcKINFaE8g20gpl8ZuQQUJ/Qb3DsaZ7UMObkzBas/1hLGNjvLKGojja9h3OXLLsKyOAHjeVY8/w8XJfVRH2Hh3ywGzUO6eaKs9wLylV1kFqzyYt4Prkrmn0KX6q59PKE1P76X7YwJbxiJ6YQ9RIgrs4GvpE+n+kItjViILuxTtngM9gDh/wK6A6hkDyHks3Rj8BFWBPCPgJLANlG248eWD4SmT+qM8Wuk5mjJc6MSkeSpirDNCtDFmmnrLbMO3qxAoolSyEjpqXT2uRz823lIIgp0UNvdsVLa0hKr0L9F+txpedXy0ngwoQWjsNsJGjJJ7nagk5a1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BYAPR02MB5240.namprd02.prod.outlook.com (2603:10b6:a03:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 18:12:00 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 18:12:00 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Jon Kohler <jon@nutanix.com>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Topic: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Index: AQHYTc5N3PtRLPD03UaoXnwsq2NUS6zrGJQAgAACcQCAAEXKgIAA6CmAgAAmhACAAAQCgIAAIIIAgAAB/YA=
Date:   Tue, 12 Apr 2022 18:12:00 +0000
Message-ID: <94C77C88-D65B-445B-B462-4FB677C99F8C@nutanix.com>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
 <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
 <90457491-1ac3-b04a-856a-25c6e04d429a@intel.com>
 <28C45B75-7FE3-4C79-9A29-F929AF9BC5A8@nutanix.com>
 <20220412180452.ityo3o3eoxh3iul7@guptapa-desk>
In-Reply-To: <20220412180452.ityo3o3eoxh3iul7@guptapa-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e69eaf5-b329-4276-2bf7-08da1caff0a3
x-ms-traffictypediagnostic: BYAPR02MB5240:EE_
x-microsoft-antispam-prvs: <BYAPR02MB5240465212F13720A51E8721AFED9@BYAPR02MB5240.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sjp+3M46PzvuEMHvrPaKym3dqu+1zN3fZkxHxFoxNqjlt+FspDbqq6aoy6fvCAQckxMd8xVABrj9k6epJFxLkJYJ7B55Gu61q28GLc/H+wI3/nLObcVT7oqQa3BUagCIbsRPwVPXxK/kraKto+dShHko+1vroKrEv1mRP8Lmv4HUPuzIJX1Xns8Wjsz+3lsJSGWAxIzy70/6+Oc5nsqX8RNqMsvP6H/OUDaO14ZXIqm12ZJlOniBokiVcSl/geHa3MafGUdulL2BuJm8PpQGdR0/B43jxDWlmD0ecyTyS8i5Ixt89LMUheEK8euiEWk5M92eawxE8bj/g+wvs/143CuD6O9qPJ4AIq/upPWKrESd4PzraImlCCmuDkkXXUP/ahSJzRW4YQ8qSXUxQfPrfVTJRepfHe7y9OIyE/+H6kFd8bvXnf7Ee+IWhohT9ARy0ftTC8ethwF1FAMP+AKfHrvpTsSEDxB4Xt8Qj4WhiV8I9Qm2ngdIq7XVhhhKUOpc7JS8HjWe3ysTqp3/2aGuQtK3A6HwU7YBtZuKSQaF+p9GVmY5xKLigjQIsUmQX/DBO9AQ3fg7VY/MNfNxsNrx0tzDbrphu7C26NJNmhjv6tljNn8DzFF6voPzmZllsjbAYw8dMizW65S4aVT+W6EoACN24QJch9ufTG+5PFvkzcftHqw98NsspW64kGN8eYA9TtiobwuWgkZ4PUNspXjW0t7VUq7coXt1cLzXsaLJoCCuyNWziXS9bkjY9qaBQaxkSxYJXPkOUFH6WGZxqF8vX2cRc31wC8BNnzFXIR+hKXNCZnaCwUFWPF5whVmFlCA4gCGxtDfDGOIK5uDZtVUwNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(8936002)(2906002)(36756003)(53546011)(4326008)(86362001)(186003)(66946007)(66446008)(64756008)(8676002)(66556008)(76116006)(66476007)(91956017)(6506007)(316002)(6486002)(966005)(71200400001)(5660300002)(7416002)(38100700002)(38070700005)(508600001)(6916009)(6512007)(54906003)(122000001)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDhlRmNXU2NGU1kvSUoyWVM1NjlUQy9oVHJvWHZ1ZmVvc2EreEw5R0ozZDVW?=
 =?utf-8?B?Z2psUU1pOXFRVU8zRmdFelNmUFlNMitzeXIvcXY3eVZGeFpqMmNBS3pwTCtk?=
 =?utf-8?B?WFhHL2hQZysvazZiNnRPTWpyamJUZ1Vsby9jRTJLUGxldFd1c2MyeGxVODFW?=
 =?utf-8?B?cEdzc3Brc1ZZRHpscE5Bb1lhTHNEaHl3d1R1ZG5zZ0xRQjJuTitmV1BvQ1R5?=
 =?utf-8?B?Z0dFS2sraUhKRUZBRmt4TUVVWCtJMzZ5dHNwWmdhT09tRmo3dFFNeWJ5KzBK?=
 =?utf-8?B?ODVoYUpaQTVWbTNTWDZkOVUxaW15NnJGbG5kSFlpNUxlSC96T1dud2wzNlhq?=
 =?utf-8?B?TlQ1MTB5OXFpRzU4WXFheHhWcWdMSTNPUW9rNkI1VlZUbG0wakIzd3pqRzRH?=
 =?utf-8?B?cVo3SG1vRHpqQk5qU2x1SkFhZnNhWUlqS2tUa1VmTitDaUx2UWw0V3Q1VmxO?=
 =?utf-8?B?VnovWmJoWk9xcitmMGNGVndTS0FzRzZ4ajRHV1BuQThxcFVSKzNBblVGU0Nh?=
 =?utf-8?B?T3dmMkRDcXQyTWx3MlJ3d2FYQ2V3eERrckQvdnJlR2QwVEFlTlM5Z0dxRER4?=
 =?utf-8?B?alBqYmtBZDJUV1F1dFl3dE8xV0ZtQnNldTd6ZndQNEMzcDZJTFI0WEtJWkxr?=
 =?utf-8?B?Vm16NUJkTDQrcnNTOEFUM3h0M2J4VFN2YlhodGZWTWNEczV4Y3JxV05NMkRx?=
 =?utf-8?B?eEhPYXVtck9FdEFIRm5LbVF0V1hCTjBMWm1hclhzRHJock1FcUN1Rkpib3hL?=
 =?utf-8?B?d043K0ZuQUNROXh2MVZ6cUY2cWt0RWIrSlZmYWw0Q09VQmRDQng2a0JVZ0lZ?=
 =?utf-8?B?elBML056TDl5VVFlQzVHOUp0azhWL0NKTjhCbkVXc2NTK3VaQnJvYVdjekxL?=
 =?utf-8?B?Tm00ZEswUlZvWFhGRzE0N1dndlUyREh4alZMSnlqOGtMTXFJaEo4Ykhjd3N1?=
 =?utf-8?B?Y0kzL3dqWHJTd1BvQzlydFV6VEUyRU1abUt3MlptMXprYUk0RW92L3dYYjVt?=
 =?utf-8?B?NzNxakRlcHpteEhHeDlMaXhNS0h1R05DZHAyUGQwdVAvRXZ3S2hrNHRsRlFX?=
 =?utf-8?B?UVVlZWZCR08vdzl6WW1OUFBZbERHSUlDdVpJTXZ2UGd5YVIrMVJ5SWIrRGNW?=
 =?utf-8?B?NWJ2NXc3YjFUVkNkS2QyUmN6OEdXN29uRFZhRFFNc3l5bzVlczRSUk5NNVE3?=
 =?utf-8?B?WUpDS2lMZldFSUF0OWhTZ04zM2xYdmgxOFZuejhNWEFnS3BmbSthSFRBQTFt?=
 =?utf-8?B?Ujl6dCtuemxuZktZSHBJUmNaTWdQdndJb2ozK3hCcVlzcklSTFN2b2hMcVRi?=
 =?utf-8?B?QkhKdHJHcUpoSzhDK0NtLy90YkJ2TTY4Uk93WW9oT3NYRHpNUjJrVFFVWlVv?=
 =?utf-8?B?eklTMnlJa3QvR0F4MzZHVEYrSTg3L3hRdTIxUzVDTEN0OVFmZGt0Q2E1QWp1?=
 =?utf-8?B?alhWNlVEc3ZDYTJVWXZubGV2Q2xCNTFmdjZkUkhTcnZJY0VybEJOVEdZVW9Y?=
 =?utf-8?B?a2xzeTh6VE5INFpWb2xaaDVGMXJ4cTFkbklvMEVwSDNvL1h0NEU2UWFlM0VV?=
 =?utf-8?B?d0k4aURkNEQrbVVDSWlCWUFxUnQrVzR2M0R3V1BOQlpicGJ3NkJORi9JOTZR?=
 =?utf-8?B?blZ4amFJbi91bDZ4c083SEc0eVlMNjA5ODJSd2JGbFJGZDB5am1sMlJHVmcw?=
 =?utf-8?B?UW5QSmhrTG92U3FmV092ZjVMcmNQSmw0ZFl1YjRQbEtDK0xwQXE0NDFEbnZw?=
 =?utf-8?B?MnJoQUovZHNSOTBWSFBIQ1Y4ZnA2MHVzRXNtckxIUDJMNzBQREQvYzhFQ2tJ?=
 =?utf-8?B?dlJIUG4xblRqbE84ZlpVcnRMZEJrcHFMVktZaVVvRDQ3cDhGenpnUGdaTEh3?=
 =?utf-8?B?d21zK0RkejNlU0tGVVR3UmpuUlJ3aFJjQWlNUzUyeFNLQmF5ZjNVdTFzZUk3?=
 =?utf-8?B?NGdmclRUSDFCVHhLS0NvVEZJZk9zS3BvRm5VbUJDWk9EaUwyYnVMb0QzTkFk?=
 =?utf-8?B?cGl2RTA0clZQVUlReGZGK0pBYlVPRGRCNzF2MU1OeTVwTndrSGt3eWJ6bHR6?=
 =?utf-8?B?NU1PL2JLV3ZaLzd1T0g4OUtnc05IR1N2eUtWU1pGdVQ4WGdZLzVUMzNwc2Zk?=
 =?utf-8?B?bWloK2FqYnJHZjhyRmY1WVR3RlpUL0MrMnFQbm1TMCtnSkwva1VDeHJyeE10?=
 =?utf-8?B?QmZFc2NtNzEyVGdvQjhlVmFtNm5VVnJ6eDRyU2JsSE1Hank5TTd3S3NHSVNR?=
 =?utf-8?B?a0xoakVBWnpVSjI1UEtKRkVUcis0WGQ5UVJNejdxL3p0a0syWVdBWk9iOFp5?=
 =?utf-8?B?Tk16alZSUENsSDgvK1lnY0tuWkxkMlFSbC9NSlhqOFc2TzVTN1ZXSWhHRnRC?=
 =?utf-8?Q?2bb6tZjzqoU/Bf+1mPH7ClZOqzTOTTIpEWT0TbKtq8d8V?=
x-ms-exchange-antispam-messagedata-1: lL1gh3UUhB+7AunjCyXap+nhYtJXA3/4OEnnklL31697+AGfOM3UqwrR
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD9AC28F9B20384086A2DFF04E2C3A7D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e69eaf5-b329-4276-2bf7-08da1caff0a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 18:12:00.7489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NqExztpwGpWCYVgkczI8742qdaI043qsrOyXa0uUmxq4UWGhou67j0Tf3LyssEPUecIl/6VTzK9XPhgJWj9kZkPe+iFSN8/AzbNgdXC6pzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5240
X-Proofpoint-ORIG-GUID: mTIw93270Lg4gQ-ETntGHm9lrP-ra3IW
X-Proofpoint-GUID: mTIw93270Lg4gQ-ETntGHm9lrP-ra3IW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
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

DQoNCj4gT24gQXByIDEyLCAyMDIyLCBhdCAyOjA0IFBNLCBQYXdhbiBHdXB0YSA8cGF3YW4ua3Vt
YXIuZ3VwdGFAbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgQXByIDEyLCAy
MDIyIGF0IDA0OjA4OjMyUE0gKzAwMDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiANCj4+IA0KPj4+
IE9uIEFwciAxMiwgMjAyMiwgYXQgMTE6NTQgQU0sIERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBp
bnRlbC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIDQvMTIvMjIgMDY6MzYsIEpvbiBLb2hsZXIg
d3JvdGU6DQo+Pj4+IFNvIG15IHRoZW9yeSBoZXJlIGlzIHRvIGV4dGVuZCB0aGUgbG9naWNhbCBl
ZmZvcnQgb2YgdGhlIG1pY3JvY29kZSBkcml2ZW4NCj4+Pj4gYXV0b21hdGljIGRpc2FibGVtZW50
IGFzIHdlbGwgYXMgdGhlIHRzeD1hdXRvIGF1dG9tYXRpYyBkaXNhYmxlbWVudCBhbmQNCj4+Pj4g
aGF2ZSB0c3g9b24gZm9yY2UgYWJvcnQgYWxsIHRyYW5zYWN0aW9ucyBvbiBYODZfQlVHX1RBQSBT
S1VzLCBidXQgbGVhdmUNCj4+Pj4gdGhlIENQVSBmZWF0dXJlcyBlbnVtZXJhdGVkIHRvIG1haW50
YWluIGxpdmUgbWlncmF0aW9uLg0KPj4+PiANCj4+Pj4gVGhpcyB3b3VsZCBzdGlsbCBsZWF2ZSBU
U1ggdG90YWxseSBnb29kIG9uIEljZSBMYWtlIC8gbm9uLWJ1Z2d5IHN5c3RlbXMuDQo+Pj4+IA0K
Pj4+PiBJZiBpdCB3b3VsZCBoZWxwLCBJJ20gd29ya2luZyB1cCBhbiBSRkMgcGF0Y2gsIGFuZCB3
ZSBjb3VsZCBkaXNjdXNzIHRoZXJlPw0KPj4+IA0KPj4+IFN1cmUuICBCdXQsIGl0IHNvdW5kcyBs
aWtlIHlvdSByZWFsbHkgd2FudCBhIG5ldyB0ZHg9c29tZXRoaW5nIHJhdGhlcg0KPj4+IHRoYW4g
dG8gbXVjayB3aXRoIHRzeD1vbiBiZWhhdmlvci4gIFN1cmVseSBzb21lb25lIGVsc2Ugd2lsbCBj
b21lIGFsb25nDQo+Pj4gYW5kIGNvbXBsYWluIHRoYXQgd2UgYnJva2UgdGhlaXIgVERYIHNldHVw
IGlmIHdlIGNoYW5nZSBpdHMgYmVoYXZpb3IuDQo+PiANCj4+IEdvb2QgcG9pbnQsIHRoZXJlIHdp
bGwgYWx3YXlzIGJlIGEgc3F1ZWFreSB3aGVlbC4gSeKAmWxsIHdvcmsgdGhhdCBpbnRvIHRoZSBS
RkMsDQo+PiBJ4oCZbGwgZG8gc29tZXRoaW5nIGxpa2UgdHN4PWNvbXBhdCBhbmQgc2VlIGhvdyBp
dCBzaGFwZXMgdXAuDQo+IA0KPiBGWUksIHRoZSBvcmlnaW5hbCBzZXJpZXMgaGFkIHRzeD1mYWtl
LCB0aGF0IHdvdWxkIGhhdmUgdGFrZW4gY2FyZSBvZg0KPiB0aGlzIGJyZWFrYWdlLg0KDQpGYWtl
IHNvdW5kcyB3YXkgYmV0dGVyIHRoYW4gY29tcGF0LCB3aGljaCBpcyB3aGF0IEkgaGFkIDopIA0K
DQpNeSBSRkMgY29kZSBsb29rcyBzaW1pbGFyIHRvIHlvdXIgcGF0Y2gsIEnigJlsbCBjb21iaW5l
IHRoZQ0KYXBwcm9hY2hlcyBhbmQgc2VuZCBpdCBvdXQgc2hvcnRseSwgYWxtb3N0IGRvbmUNCg0K
PiANCj4gIGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0z
QV9fbG9yZS5rZXJuZWwub3JnX2xrbWxfZGU2Yjk3YTU2N2UyNzNhZGZmMWY1MjY4OTk4NjkyYmFk
NTQ4YWExMC4xNjIzMjcyMDMzLmdpdC0yRHNlcmllcy5wYXdhbi5rdW1hci5ndXB0YS00MGxpbnV4
LmludGVsLmNvbV8mZD1Ed0lEYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9TkdQUkdHbzM3
bVFpU1hnSEttNXJDUSZtPUFnUFdIekNPUmRuNXg1cllYRTBRZUoyeWYxNThIT2pEQTVCbjh1ZHpw
LW02aTlWOXM3U19qdFNpTG9nLWRrOTMmcz1rUjc0a2ZvdnBhMHpPSzB0WjJTczl4YmcyYVJMSTVv
b2NCX2NwXzZETGtnJmU9IA0KPiBGb3IgdGhlIGxhY2sgb2YgcmVhbCB3b3JsZCB1c2UtY2FzZXMg
YXQgdGhhdCB0aW1lLCB0aGlzIHBhdGNoIHdhcyBkcm9wcGVkLg0KPiANCj4gVGhhbmtzLA0KPiBQ
YXdhbg0KDQo=
