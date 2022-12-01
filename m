Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1C763F340
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiLAO6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiLAO6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:58:20 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DB71A054;
        Thu,  1 Dec 2022 06:58:18 -0800 (PST)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B19LDAl030769;
        Thu, 1 Dec 2022 06:57:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=sfWW08dXcbNt0cV4t/ANLDDCYfh+tPIQKDrsm1upjkI=;
 b=OTBIT5H0XM5P0Y+hZzBHUWVtvsOYzQFx+cZmWiN7KSOaDeP1SgxmZNMyHde4/GdzzLaK
 r5YGFQdbkX9Gqr7FxTdMmkPrmvtck3sJKteLE4xUgJl7qUuKZxkekvMXyM9/RL4TOoBa
 1s6RpxJeo8nEcPuFnCvguwqVOQyw2tchNVHk9QvP11F0H0LRfh4wf9snz486cnKa9gr4
 PWrMHLAJR3ejCkrnkCRVBB8iwhtFxOC/WBaFi23tlWotwAkJSLQh1f/NmOB03GFHh1Mq
 sctWTGIR7QpuyHznp7m+J4Hs+dXWZ8t7OhaBp6GPJPfVxU0+ClWIKAOh46uRnWnVORNH Ug== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2049.outbound.protection.outlook.com [104.47.73.49])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3m6k5nsamb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 06:57:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ae3OTPCLRUbJdyQDza9EmFGdwBum46X/o95J7Bw2xsg2P12OjK4xyS6MGH7cnJpjt1z6GR1NvBvNej/Yr/2KYAl2moE1l4Y8wkLcMHRcJotDp+wlFI7e3VZB3ZZPtOpDNvzr0y0AecNiK4koBJTPn46Mfzj3h++a6IZpw/AELnKuukDkUjttj2G2qkxadeq49cV7OyXzVtKTi5m5lmhtozy0umqL+xJQiguFpG/OJVQMqGIl+TtKAZsAuGEbsWFz5OL4N26fCtqUrZKocGKIrLtaB82wOPJtdAoDCNvWHI8HOx2PKUMXUFG1G1uHnsQACjN2V6EH5x4Gsg/QgB3yNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfWW08dXcbNt0cV4t/ANLDDCYfh+tPIQKDrsm1upjkI=;
 b=ZofbJ9JpW3vI6yTiWRef6b+IeriXsdFxYFPHRqI1i35ux7iOnSnfZeLDZ4kX8zZXgeARIY+XJ5QdoGnZZsl6BDk28i/enEoQs2J6lfk599fMY7MmdLchV1iQsbuu5a1GQcYBVHoBe+JVZ6vsrGjkWdIQTgOK1RI1Ba3cXFEMMTiOc/mKuuMtzEQH+tnPHVq8vVGEbWUInVOZ/G2m+bE6mq4ZOLy5CGqKErz6NCbvM8dnQB3DPJP7mSs8Akqwyiceg56sb3gtZ4bxnzZNX0cyM08DE8es6IJBCOt+4DIHR/FnV6/FZKhXrWHKkC2OftvFk8S2NzVzxvtenzyB6zWltg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfWW08dXcbNt0cV4t/ANLDDCYfh+tPIQKDrsm1upjkI=;
 b=O2Mes+0LagS7MrTI9zyEeUUc8bRhjQ3zBqfqGBLAn4y4Uu7UH3qqnfXIAqAXjuHcnfwfVRPOvfi3skMR7YNUW56MO7zg6wbHvebkVs6k4UdsO2cBhPQTU2nNgUleCO4R3ZpWYtLcBnaFXYcbOM6xcw8z/CkDcXuA7HWJyesjCwOp/unlu75WkJkFXvhvmoSJ/DsfYFjZgUDJucVcJMVqAmc7kJ7PsYp/+a1zDgIl98S/TMpsLClEseNcBeu2JIyQvE2MQi4VAD5Q5bmJEtlQcKDNhn8VTgAbZ8s2dHKIpHRISrFX33IU4tF6eiPLMvK0rW+p5Szj4UCXRuptRFMl8w==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BN0PR02MB7999.namprd02.prod.outlook.com (2603:10b6:408:16c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 14:57:31 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::ea4d:10a4:a7a4:9567%6]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 14:57:30 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Chao Gao <chao.gao@intel.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Topic: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Thread-Index: AQHZBB+UbwHM6Ykv6ESmts8I/MP46K5XAf2AgACAD4CAAPgOgIAAqB2A
Date:   Thu, 1 Dec 2022 14:57:30 +0000
Message-ID: <AF395934-3758-4A1C-A47A-C51F01A83A8A@nutanix.com>
References: <20221129182226.82087-1-jon@nutanix.com>
 <Y4b4UURccshroVV9@gao-cwp> <7248AC8C-FB3A-48D0-8DB2-F96CB6C15C17@nutanix.com>
 <Y4gz02jGZpNFbnAE@gao-cwp>
In-Reply-To: <Y4gz02jGZpNFbnAE@gao-cwp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|BN0PR02MB7999:EE_
x-ms-office365-filtering-correlation-id: 82e6c207-0c88-46c8-1e21-08dad3ac5ef3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j0cKbaMEFyM/mWfzH8cOGVO3HO6s4I8kNFMV5yOxFh5mjI3p9Jhcu7g0lYJOzFhe1pt50c6T6/E7ZbUyWlfiWmbQlZLzFKp2t8odj60uXHpBAeQIcZiwdS4sCpxSwrBVMYIgsrxoTD9fe2eFDf7LxMftAmNWnG2v09us1/k0hgjYUSuEDn1L/yD74oEn4vBIftcU7Tob1IMzjVqyPBUj5f8UAWsqZV5UkfsRb3jsCAgEMUUqcNQgX/jXMITEXtRsuR7hh0KvfIVnDnaZY6IlQfdED+EV6rIuPPcvm90lKLJTgu7SHYyx6X2gQYCGR1nT5246S6UcnRDuB8yQzTMhF/CTZrRCPQhvIp3aKiPifYVM1XsovPmX0c7xFJUg0RXVUqXSwZut5YFarJSsp73vWkZ3lUAmWGkEVIKod9tudqdHC8vS6zy5qxsrCFnRGjSFBSWOyKNN32OUQwGi4YK91yBOWKSJuRAiNJ0zgUZsGnX14OeAy/+0fz48OLTcSNqMElt2mC6FMaOZUuvlwE6s5JhVm8qJ1ZR6enWcOtMO7WqtOvz9FxeSph6FrCOMgxX1rVv7ULcrwojfLDdDebSSOjyU+8uI0ftGo8M8Rpno1fbqde2Tvok4Yn3CT4onzu67RqtzfHpBhDQT2Qwhm68RmGXZfGSOY//QKMkX8E5bQVh2p8hq0Hmdt6dK5bKzA781swk6nQACDSN7FTgMUcZj5WZywWN7AKeT9Uyxp6+Am7k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(6506007)(6486002)(478600001)(86362001)(83380400001)(33656002)(2906002)(53546011)(71200400001)(66899015)(64756008)(7416002)(54906003)(41300700001)(6916009)(66556008)(66446008)(8676002)(66946007)(66476007)(76116006)(4326008)(186003)(36756003)(8936002)(316002)(5660300002)(2616005)(6512007)(91956017)(122000001)(38070700005)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZllQQmt3NWpIV1RJcGl0UTVJMDhHelJLV3ZkaFNjQ3dmOEI0OEx2c0k2WHpw?=
 =?utf-8?B?eEkxeEdjRVhHYmRCY3E3eWlMc0U5emxvVWMvN2dWVitrdmFlZDc3ak4vaDUz?=
 =?utf-8?B?dThpWjRuWFdibDA5Y1JVajJXQTRNcWNkbnFGcC95QTJUWUFLajRiZERieUl6?=
 =?utf-8?B?aDNxTFF3VG9MUlVaVkpIckdmdkpjTG9FbmRsaDVQUWhsMWtoSjlMSlFBSGFB?=
 =?utf-8?B?U0pBU0ZzczlwMDFKOFB3MkhVVDhTZUtObVhJQStHSzRqTHRNQjY2bS8vdE5i?=
 =?utf-8?B?bUVxS2kzZ3lYa3hhcm1WK1ZHYmhGVkdTYzlZb05TQS9SSGhwMFZ1T3A5QnFR?=
 =?utf-8?B?b2c3L3JPb0RuYW9aTnovNEY1WjRvTkJIdHl3QW9mdmpKRDJ5Q2ExWWFSdTAz?=
 =?utf-8?B?UTlITnUrZk5SSUYydENVYVNGTmREcHZpdzZQZm93RWFXMkpYcWIxZGI0OXQ5?=
 =?utf-8?B?ejN0RlI1cjI3TWxpb2tMNlNPa3JweFBqWDN4YkQ1bnNBTS9iNEVYcmVsdUQ5?=
 =?utf-8?B?ZTNlaWZQOU54YkVRRXN4dGl1a2QvYlEwdE0vNjZkN2I3RytQTTB4M3dZaDg1?=
 =?utf-8?B?NWxuZmhDdGFEbmxwb2FQS1VlOWhmRm9Xb285cUxjMnFZVWdmS2ZoaWx5Zi8x?=
 =?utf-8?B?UWJqa1ZJTTE2bUFkRjY0RXRTaXUrMFR4QTgrY1JQODRwamY1dGhRSnlXazJM?=
 =?utf-8?B?RHRrZC96R2s5bFk0VnM2UnVzTElCa1ZlNDhtdklIa295WjZPak9YdGVDTTNT?=
 =?utf-8?B?cGFFWGdzRk03MWRjdWs1bmY5bVZQNDFXNG1FZTBUUHpuNkllSk1RSjFwQnRQ?=
 =?utf-8?B?MEF4Y3g4UXprRC84c2FrL2tOc0pzMXFRaHZhbW1yQkRSMng0d0lBclM2SDg2?=
 =?utf-8?B?YVZKcVA4YU5vbzREOFFBR0pUbEtuZWt6S01ITm9mVU9iWlE0TWNqTXhlZFdB?=
 =?utf-8?B?dHpad1pVSUEyM2xmL3JiTmFwUWc3L3FZb0FjT1dvR1BjeENlMVNNd2lERFFx?=
 =?utf-8?B?MTJjdVJJWmNrWkpzemp1aEJiK3lmdUg3M21wNTRzSFg4bVZXT1VpUWdyZklp?=
 =?utf-8?B?QVVXN2d2bUpGVU5UaEJLTmlHa3FtbHVJdjEwWG04NW9QWXdjRy8zenE1NW5G?=
 =?utf-8?B?dHNIc3dsazRJYWJJcUZaR01xRDBMazRuQVJyVzJhYll6cjh1cHpGTkFUZ1pE?=
 =?utf-8?B?ZWxBY1JHSUovcnpTcEpuRmFqR2lwdnN3RnhQWitLK0ZsamZvOElvRjYvK1Y0?=
 =?utf-8?B?QUZia2Zod2hZWnZXMklRR2lNTjJPQXZWaWVuc2NBZzV5U1M4cTFobzBOZlNE?=
 =?utf-8?B?U2ZmQlhGOG10aEJ1eVVYNFVkWkpERENmNFRNNnNVTkZ0a1cyMVpqcnRaTVJG?=
 =?utf-8?B?ajVnNE5CWUkxUVpySzY1Zk1hOEorb0NzaHYvSXh0NElPdWZwMDQ4SW9ieUNu?=
 =?utf-8?B?bUFTVjBBSjY1ZmxrNzJSS2NtRE1DZTcrTXkvQjFXeEZiWUNnR0E0ZXNkaGRZ?=
 =?utf-8?B?ZE9HVkdtVDBDcTZuRHFRK3BNR0hxUytHSGdWd240L3Z0NHhiVndZYmpCQ3dV?=
 =?utf-8?B?aGpSNXZhRnBQdmVtVXlxSzMrNHo4SU5rc1hNbFFTQVVUdlk0MEtmSlV6U0th?=
 =?utf-8?B?T3g0RThpdHZ3TGZlQS9UcnhtbVR1eVFBdlhyMTkvejlWNGxUZmxrUmxxS3Ez?=
 =?utf-8?B?aXBaOUNRRHo4UnhwV084SEkrbVd0WTR2L083d0V1VGFHaHRpcTUveGlCdlEx?=
 =?utf-8?B?ZVNaMDJncEZiWDkrako4S1NsWDd2L2JaUGJhQ2JkZVdGYmZ4Nno3Y00zYUpu?=
 =?utf-8?B?WmJzODRtVTMwWnZPRlk0M2JEbXZZOXZBd3VXd3VGcmhpUDVmcVp4MHN5Qkwv?=
 =?utf-8?B?RlZQK0xMdExBNit1RnFqUmlkbUE5VEJtUnVvbVpsUzQ3UzVFeHl2SWRWK0xi?=
 =?utf-8?B?OXFJb011emhxMml6c1hqSEkrODdQT0p4ZjNrUEUwbDRvN2lKQzlHWXZmREZO?=
 =?utf-8?B?bmY1b3RkS3JISWh0MW5xWjd3ZTg1VHpnSy8zejF1LzZCdXhZbmVDVG1Vc1lr?=
 =?utf-8?B?S2JrcURLSXpQYUxyWXlpd3oyT2VmT3EzMVFZM0Zyb0xpSXU0WUFPVmlzUWxw?=
 =?utf-8?B?M2w0alRKL2I2c1p6c0wwQkttaEhOR1BaTnNKa3dsZ1c2RlQzeXZEK2FJRTVQ?=
 =?utf-8?B?eGVFVjh2S3JHdUdRRlpSeUFkWWhzT25ieDBlS2NCaS9MQk1vL2RtYjlHcUUv?=
 =?utf-8?B?REFtU2pTbGtOU1BvdHROMTNqVVRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47F37A740D94F1409B5F378029695DDD@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e6c207-0c88-46c8-1e21-08dad3ac5ef3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 14:57:30.6548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xr/uquc7fboQTuHoF5jU+cDx50KdEBSYUj9t7W2D1r7gACeYlXo0upRS/SCsVQZ7QEhoJ5vlbUsKqXmh2A1AH+wWE0J8sEODYxHvP/EbGRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB7999
X-Proofpoint-GUID: rbhYiXqstwsyEN-QFAKnc7RKkbdB08fn
X-Proofpoint-ORIG-GUID: rbhYiXqstwsyEN-QFAKnc7RKkbdB08fn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_11,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTm92IDMwLCAyMDIyLCBhdCAxMTo1NSBQTSwgQ2hhbyBHYW8gPGNoYW8uZ2FvQGlu
dGVsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE5vdiAzMCwgMjAyMiBhdCAwMjowNzo1N1BN
ICswMDAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBOb3YgMzAsIDIwMjIs
IGF0IDE6MjkgQU0sIENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+IHdyb3RlOg0KPj4+IA0K
Pj4gDQo+PiBDaGFvIHdoaWxlIEnigJl2ZSBnb3QgeW91IGhlcmUsIEkgd2FzIGluc3BpcmVkIHRv
IHR1bmUgdXAgdGhlIHNvZnR3YXJlIHNpZGUgaGVyZSBiYXNlZA0KPj4gb24gdGhlIFZURCBzdXBw
cmVzcyBub3RpZmljYXRpb25zIGNoYW5nZSB3ZSBoYWQgYmVlbiB0YWxraW5nIGFib3V0LiBBbnkg
Y2hhbmNlDQo+PiB3ZSBjb3VsZCBnZXQgdGhlIHY0IG9mIHRoYXQ/IFNlZW1lZCBsaWtlIGl0IHdh
cyBhbG1vc3QgZG9uZSwgeWVhPyBXb3VsZCBsb3ZlIHRvIA0KPiANCj4gSSBkaWRuJ3QgcG9zdCBh
IG5ldyB2ZXJzaW9uIGJlY2F1c2UgdGhlcmUgaXMgbm8gZmVlZGJhY2sgb24gdjMuIEJ1dA0KPiBj
b25zaWRlcmluZyB0aGVyZSBpcyBhIG1pc3Rha2UgaW4gdjMsIEkgd2lsbCBmaXggaXQgYW5kIHBv
c3QgdjQuDQoNCk9rIFRoYW5rcyEgTG9va2luZyBmb3J3YXJkIHRvIHRoYXQuIEluIGJldHdlZW4g
dGhhdCBwYXRjaCBhbmQgdGhpcyBvbmUsIHNob3VsZCBiZSBhIGdyZWF0DQpjb21iaW5lZCBpbXBh
Y3QuIEFueSBjaGFuY2UgeW91IGNhbiBhcHBseSBteSBwYXRjaCBhbmQgeW91cnMgdG9nZXRoZXIg
YW5kIHNlZSBob3cNCml0IHdvcmtzPyBJ4oCZZCBpbWFnaW5lIGl0IGlzbuKAmXQgYXMgYXBwbGlj
YWJsZSB3aXRoIElQSS12LCBidXQgaXTigJlkIHN0aWxsIGJlIGludGVyZXN0aW5nIHRvIHNlZQ0K
aG93IHRoZSB0ZXN0IG51bWJlcnMgd29yayBvdXQgd2l0aCB5b3VyIGJlbmNobWFyayB3aXRoL3dp
dGhvdXQgSVBJLXYgdG8gc2VlIGlmIHlvdXINCnRlc3Qgc2VlcyBhIHNwZWVkdXAgaGVyZSB0b28u
DQoNCj4gDQo+PiBnZXQgb3VyIGhhbmRzIG9uIHRoYXQgdG8gaGVscCBhY2NlbGVyYXRlIHRoZSBW
VEQgcGF0aC4NCj4+IA0KPj4gDQo+Pj4gT24gVHVlLCBOb3YgMjksIDIwMjIgYXQgMDE6MjI6MjVQ
TSAtMDUwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+Pj4gQEAgLTcwMzEsNiArNzA0MiwxOCBAQCB2
b2lkIG5vaW5zdHIgdm14X3VwZGF0ZV9ob3N0X3JzcChzdHJ1Y3QgdmNwdV92bXggKnZteCwgdW5z
aWduZWQgbG9uZyBob3N0X3JzcCkNCj4+Pj4gdm9pZCBub2luc3RyIHZteF9zcGVjX2N0cmxfcmVz
dG9yZV9ob3N0KHN0cnVjdCB2Y3B1X3ZteCAqdm14LA0KPj4+PiAJCQkJCXVuc2lnbmVkIGludCBm
bGFncykNCj4+Pj4gew0KPj4+PiArCXN0cnVjdCBrdm1fdmNwdSAqdmNwdSA9ICZ2bXgtPnZjcHU7
DQo+Pj4+ICsNCj4+Pj4gKwkvKiBPcHRpbWl6ZSBJUEkgcmVkdWN0aW9uIGJ5IHNldHRpbmcgbW9k
ZSBpbW1lZGlhdGVseSBhZnRlciB2bWV4aXQNCj4+Pj4gKwkgKiB3aXRob3V0IGEgbWVtbW9yeSBi
YXJyaWVyIGFzIHRoaXMgYXMgbm90IHBhaXJlZCBhbnl3aGVyZS4gdmNwdS0+bW9kZQ0KPj4+PiAr
CSAqIGlzIHdpbGwgYmUgc2V0IHRvIE9VVFNJREVfR1VFU1RfTU9ERSBpbiB4ODYgY29tbW9uIGNv
ZGUgd2l0aCBhIG1lbW9yeQ0KPj4+PiArCSAqIGJhcnJpZXIsIGFmdGVyIHRoZSBob3N0IGlzIGRv
bmUgZnVsbHkgcmVzdG9yaW5nIHZhcmlvdXMgaG9zdCBzdGF0ZXMuDQo+Pj4+ICsJICogU2luY2Ug
dGhlIHJkbXNyIGFuZCB3cm1zciBiZWxvdyBhcmUgZXhwZW5zaXZlLCB0aGlzIG11c3QgYmUgZG9u
ZQ0KPj4+PiArCSAqIGZpcnN0LCBzbyB0aGF0IHRoZSBJUEkgc3VwcHJlc3Npb24gd2luZG93IGNv
dmVycyB0aGUgdGltZSBkZWFsaW5nDQo+Pj4+ICsJICogd2l0aCBmaXhpbmcgdXAgU1BFQ19DVFJM
Lg0KPj4+PiArCSAqLw0KPj4+PiArCXZjcHUtPm1vZGUgPSBFWElUSU5HX0dVRVNUX01PREU7DQo+
Pj4gDQo+Pj4gRG9lcyB0aGlzIGJyZWFrIGt2bV92Y3B1X2tpY2soKT8gSUlVQywga3ZtX3ZjcHVf
a2ljaygpIGRvZXMgbm90aGluZyBpZg0KPj4+IHZjcHUtPm1vZGUgaXMgYWxyZWFkeSBFWElUSU5H
X0dVRVNUX01PREUsIGV4cGVjdGluZyB0aGUgdkNQVSB3aWxsIGV4aXQNCj4+PiBndWVzdCBtb2Rl
LiBCdXQgLi4uDQo+PiANCj4+IElJUkMgdGhhdOKAmWQgb25seSBiZSBhIHByb2JsZW0gZm9yIGZh
c3QgcGF0aCBleGl0cyB0aGF0IHJlZW50ZXIgZ3Vlc3QgKGxpa2UgVFNDIERlYWRsaW5lKQ0KPj4g
ZXZlcnl0aGluZyBlbHNlICp3aWxsKiBldmVudHVhbGx5IGV4aXQgb3V0IHRvIGtlcm5lbCBtb2Rl
IHRvIHBpY2t1cCB3aGF0ZXZlciBvdGhlcg0KPj4gcmVxdWVzdHMgbWF5IGJlIHBlbmRpbmcuIElu
IHRoaXMgc2Vuc2UsIHRoaXMgcGF0Y2ggaXMgYWN0dWFsbHkgZXZlbiBiZXR0ZXIgZm9yIGtpY2sN
Cj4+IGJlY2F1c2Ugd2Ugd2lsbCBzZW5kIGluY3JlbWVudGFsbHkgbGVzcyBzcHVyaW91cyBraWNr
cy4NCj4gDQo+IFllcy4gSSBhZ3JlZS4NCj4gDQo+PiANCj4+IEV2ZW4gdGhlbiwgZm9yIGZhc3Qg
cGF0aCByZWVudHJ5IGV4aXRzLCBhIGd1ZXN0IGlzIGxpa2VseSB0byBleGl0IGFsbCB0aGUgd2F5
IG91dCBldmVudHVhbGx5DQo+PiBmb3Igc29tZXRoaW5nIGVsc2Ugc29vbiBlbm91Z2gsIHNvIHdv
cnN0IGNhc2Ugc29tZXRoaW5nIGdldHMgYSB3ZWUgYml0IG1vcmUgZGVsYXllZA0KPj4gdGhhbiBp
dCBzaG91bGQuIFNtYWxsIHByaWNlIHRvIHBheSBmb3IgY2xhd2luZyBiYWNrIGN5Y2xlcyBvbiB0
aGUgSVBJIHNlbmQgc2lkZSBJIHRoaW5rLg0KPiANCj4gVGhhbmtzIGZvciBhYm92ZSBjbGFyaWZp
Y2F0aW9uLiBPbiBzZWNvbmQgdGhvdWdodHMsIGZvciBmYXN0cGF0aCwgdGhlcmUgaXMgYQ0KPiBj
YWxsIG9mIGt2bV92Y3B1X2V4aXRfcmVxdWVzdCgpIGJlZm9yZSByZS1lbnRyeS4gVGhpcyBjYWxs
IGd1YXJhbnRlZXMgdGhhdA0KPiB2Q1BVcyB3aWxsIGV4aXQgZ3Vlc3QgbW9kZSBpZiBhbnkgcmVx
dWVzdCBwZW5kaW5nLiBTbywgdGhpcyBjaGFuZ2UgYWN0dWFsbHkNCj4gd29uJ3QgbGVhZCB0byBh
IGRlbGF5IGluIGhhbmRsaW5nIHBlbmRpbmcgZXZlbnRzLg0KDQpPayB0aGFua3MuIEkga25vdyB0
aGlzIHdlZWsgdGVuZHMgdG8gYmUgYSBzbG93KGVyKSB3ZWVrIGluIHRoZSBVUyBjb21pbmcgYmFj
ayBmcm9tIHRoZQ0KSG9saWRheXMsIHNvIHdpbGwgd2FpdCBmb3IgYWRkaXRpb25hbCByZXZpZXcg
LyBjb21tZW50cyBoZXJlDQoNCg==
