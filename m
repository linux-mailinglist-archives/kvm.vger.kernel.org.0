Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C7E5EED46
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 07:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiI2Fgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 01:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiI2Fgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 01:36:49 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE1E12AEF0;
        Wed, 28 Sep 2022 22:36:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jqq/4fs061YDqJQYDt4F8La3HQDB7hmUmqFGU3YS1pN/wDmqzdfHRZl/35PwnWEk7CEZCph0yXq9Ebyss3OacDFylcvO48kaJ6Y+ZDYjiQlnnleaxkgF9qfSaXx2uIpCGFoKmpAIXp3eE238W05sGQEXrotCJ7gCKwmFUtrnJgNuXd3YKJ/bRXKNwqvokvT1c0LiwV3oFx1n8rCKxrd2D0R3R6yDcbRqQJ8VVIENwkgMw/RQvP5Rx0Bm06/5sX2w4Yo9r7YIoaSwjruu77OUOgEfCXq6NbVd+R20I7to87pZBuEaXwirO9ySRuv+EBIdnQc/fM6VTxVsM6/TVqXukg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrOWv1ag1dIuCL8Q4/wZnOS4WGDDMGPvVBZRFbKA9p8=;
 b=QZEZGuicSbEFX97REXsixki3gZOWSqNKVtadELYf9V7LNC8N6PreYqNhgG4e6ct8TfaQv31d80/yYy99yiwPd6VFPdzbue9hGX7wKx6nNcsfYhlfU5oANJHqeA+YcSmiEiX6FcKyd+VMNpS66iTlPdyzw5JB/2358TdyBQpTwTeI4W4+G/jOBKZa7Xt+kFjALRG1p+Z3YdAWdxeZyZW/MWjH/TYeZE0trK3R8ipjNwART62N8HIWfd/ib9hZml1z60tMcJlBQmdegti5Ed0xA1Ej8XY5NalaJVlrB/HHQcamwnbjZmyCSZm8swnQyv2RendvPgIcjTnHWdWdURM3sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrOWv1ag1dIuCL8Q4/wZnOS4WGDDMGPvVBZRFbKA9p8=;
 b=H5RxDyJh/zAHizW6UFPXFQyFFdVsnRnEJZDyTxTkUUOFnFAgir8/aaVMZ8Z6BQPes3K4qxChWQB8ZbV63RNWMDCW6MXR4wOfSSz0G4fgPcjkgjTxCAENAHKIowrGWUJ+OO9sb8lpfZ0/DGlAPzSe8/WjuqD+wHCIwbaZCJzH7Gs=
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by DM4PR05MB9086.namprd05.prod.outlook.com (2603:10b6:8:b7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 05:36:46 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::ae59:5c22:5ddd:bec8]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::ae59:5c22:5ddd:bec8%8]) with mapi id 15.20.5676.017; Thu, 29 Sep 2022
 05:36:46 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        Nadav Amit <namit@vmware.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "acrn-dev@lists.projectacrn.org" <acrn-dev@lists.projectacrn.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Topic: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUK3dXFQAgBj77YA=
Date:   Thu, 29 Sep 2022 05:36:46 +0000
Message-ID: <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com>
In-Reply-To: <87zgf3pfd1.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.61.22050700
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR05MB8703:EE_|DM4PR05MB9086:EE_
x-ms-office365-filtering-correlation-id: d3fcc232-4650-4a4b-8d90-08daa1dc9995
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AEvJCC9vSC4rRmYjtidDq/0soFb/XPk66LUpYD/Vq9pALypDD7Rmd4TYS0AF9befxPoQGY4S+qyYOKjCTtoAlqlO0Z1z/WhXm+SEfYODDFLRJPNA5YrBdFrvmbTpjqSUl7gjcuAIwisncPZfe8FeSWh4nNkUREAoMA3iqvKSgIk7Yw7GElMgqKZI1x3HlYIHktV/3wpw9Uq7+9o/zCQVchDCKe+yI32glG/7fSfSYK3OUIUw5j8d55UpxkAmxQcE9lMkMgc5rCm5Ouc/wqt995rMQ8TfucT3eXbDzOhcjklbaWkg9drOblzP0+YAxKv6BGXs4mMhX/LdpGxz3krNGpoWiNe/LWvIcK5PmChiqpGLCgxVAGrxuDkq3T4f3+/op3ff19KkV3mghopo+uInLzaygJN6sE7kg9LL1M4blJOg6n1CxgbAZPdPKE/VrArKjP/EuLLSRW0ATHuo+yhh/j2iiFaTNtnd6Tu/22F5nolgT7/Uf3FZsweMqoxMXtJvr/8PARn68C8E9ZjuKIVCaP5QooQaSuJdD0IwPfPZvnuoRFc8u52u/u1yaJFSGjiErtxe2p2u8bjI7BsgAKIszpVVkSA9FqOtCbj0hmExfETF4kirgL/Ee8Y1eKlA6YUPe99ehQg2mXydyeLA8DwjHItoyS7TqF9JvWnOM2s/eZ8CDcCaOmWYB0V9tPtuekZi2a3JFTAV0hoWj8CCn03c1FqqA8qw7/nYXOabil6KXHzjFAgkUW9LgMldROoO/eaXQ9sRtTUQdPeEEKkChRk5EylB0ugm7JLEbsLwRKY+19M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199015)(316002)(7416002)(6916009)(5660300002)(2906002)(66946007)(8936002)(36756003)(86362001)(38070700005)(4326008)(33656002)(54906003)(91956017)(76116006)(66446008)(66556008)(64756008)(66476007)(2616005)(186003)(478600001)(41300700001)(26005)(6486002)(6512007)(6506007)(71200400001)(38100700002)(8676002)(122000001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVc1dktDaWVNVUJlRGY1MEFCYm5JbFhLejhOc3Vjd0hDZXhMUXVmRHNPS2Vy?=
 =?utf-8?B?SGpGeTdqNHJIRU9sczF2cHQrNTVJNTdJSlBzVW5GdUZNanZqTjROMTFLeU9M?=
 =?utf-8?B?NHE5bmZWd1h6eDE5UUQvdmRpVnRFNlhoeHBob3FDbWM3bTBBT1VHWVNmWGkv?=
 =?utf-8?B?bERZSUl2ZitZdnNkWUgvTmZOYlR0UGtiWWdRamhvNytJbktEUnZmeFpBT3dl?=
 =?utf-8?B?cFdLcjVsWk12ejI5QjBMK1FqdlBqVndvWlkyZUFKaDRqR04zNWNVOEEybTh4?=
 =?utf-8?B?Tkp6UEtIUkFCd2h4RGttY3ZVdWo5d2swYkZFNkNiNk4wUm9Ha254aEJhbFFH?=
 =?utf-8?B?RnYvbDYwanoyYWNmaEtQR0JCUnlHTHlDV0lYc3hwREw1UGRTV0ljaG8zR0RM?=
 =?utf-8?B?dkpkU1N6UzUvb2hzYm55ODVKT0FwZlRmNVVrd2RaTnhoSlJ1R3p0WEtLQW9r?=
 =?utf-8?B?T0tnMDd4ZlppQTdFL1JqNnhoMzFHSkJVYlZJSTBPTjB6bVcyS1E4ek5adXk5?=
 =?utf-8?B?WDZKalNhOWxwcERRczMzZ1czRkc5KzJVSmk5N285QUNBc3V1RnZDbjFFZUVl?=
 =?utf-8?B?OVVmWlRFdEdyaU1GWHB2YVRITS9HeCt2eURnOTRuTG1taHk1NjFEVk4rS0Ru?=
 =?utf-8?B?V2EwUEhtV01RN2ZieFUzcm1rRHhFd1NWT0NsUkNHS3VkcENoaVpGRkg2YWVo?=
 =?utf-8?B?NVF2dXdHU0FSQU0vVU9BNm90L09MdWFJcllmaEVEVFRBMkh3d2lLZUplR050?=
 =?utf-8?B?L3pCNVZQWnk2ZGxVS1JCcFRsMUpyY3Q3NEdNWVhSaTIzZkZ0VGhTSmFvQVBa?=
 =?utf-8?B?d0VyUm9qU1pHSkZ6RGl2d0NKSnMvb3JzTm9ncU44NkRKM3BiK3ZMdVRqeU9s?=
 =?utf-8?B?Wi95VW4zUmwwSkpVLytIWUFLK1BUUk44MHp1WGY0OXJpcG1ZaGJOZGh5enE2?=
 =?utf-8?B?S0pJYnIzQUp6cXRKT2RQTEFVSWxiR3dJWmd4TTBsMVZ1c2VYc0J4U2tLNkVp?=
 =?utf-8?B?OXlOd0hwbXlidjVTd0x1elFEUUpVSUd2U0xmVUVCU2JjQ2xKNjJTNUFGT3Vs?=
 =?utf-8?B?UWpUL1BrSDRnZUZ2bGZuTTVURXNhUjIyWDNQRU1HUzF5OE5JVThjSXNRY0Jr?=
 =?utf-8?B?TWJ3YnlTOW11K0ZQWWpBVXNmY2NGNU5FK3pSY1E0R2VReWFmMHZxdm5RVDQw?=
 =?utf-8?B?NUwxMFJHVTdFM3JyNk9xc0xDenQvTzlZK2IvSFd3WUFMZ1pxRWFqWWpidmVF?=
 =?utf-8?B?SHJyWDJDbHh4cEFqbnZBSUxSQnZnakQ0ZkM0c2liREVqRnM2SXpEY3RNTjdH?=
 =?utf-8?B?ZytINWNPUTdoakpNbVpCRzIwWXNqSTZpajF0N0wzbHpyRWZYbitsYU1xTmdP?=
 =?utf-8?B?azQwL01iRmZTdXE2eTluQVBsZnVYUGFvV25ubUxzY1dMd1ZlYldTdGFkL1VW?=
 =?utf-8?B?S1UyRUdocG9IZ0pNZi82ejJaV3VNOXN3TlFJbEZhdFd6S2o0a0R0UUVyRVJm?=
 =?utf-8?B?TW5qaE5VVXFUdGc4ZHJOYnljQXBNcEtFOGMvMFZIenlEQ3F2UDZoQzJ0ODJF?=
 =?utf-8?B?OVN1MG5obDYzd1ZVVHpPWE1NUGhHWVF2K2orSENHRUZYUGNTZ3RaM2JrTEho?=
 =?utf-8?B?RGh2bUQxVWNZdmNrbmZtZlVGbDdhTlNveThIc0NJcG55TkRGMVJ6SnpBSDB3?=
 =?utf-8?B?Smdvc29GekRxRHU1VkxPb0Z6NTh3MzRMQnJMK0hIMG1pYjBWSHNJa3ZVTFlT?=
 =?utf-8?B?dUVOWVUzZDlBVzI5Y3dCcnpNNk9oV2dlTDdkbEMwOGtacDN6Nlh6cjVPaUpt?=
 =?utf-8?B?MjBZc01qeFpYdCt1UW5iRWVkcUpKbW4zRXVVL24xSmJ5ZlpZMDlFQ0V0cGhL?=
 =?utf-8?B?QkJtZDIzSG1pUzdJM0JLNER6dHFvUjlvOGtyQ0JEWk1wcDJpUDVXWERKODhh?=
 =?utf-8?B?L1RydnhiUEI3dTkycG1LekRJRHVTd25kYUEyT0ZGaEcwRE9QcjVQLzVIOWE1?=
 =?utf-8?B?cmVrUVRpTTh5OFJyT2FRdTFYY0szSWF1YzRDdnNGQlgxZFYwb2RNRnBTZjUv?=
 =?utf-8?B?UDBvMEFXNlM2R0tEN20zdzBRV2VxZW05TUpPcUR2QWJYV2NzQWRDMjEzdVJD?=
 =?utf-8?Q?0kon8D7pY7xbbzbxEgfirVXwz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D3D0A98AAD0B3469FE6F3A222912A7E@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB8703.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fcc232-4650-4a4b-8d90-08daa1dc9995
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 05:36:46.7470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKFRoiPk40nURvziT0fHiKYyP9eTOrRz5hYw/BbHB+Wa0agaBFKl4pb0t8hGKCKQ1jNOfk6z9Z98YzaqyV00dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR05MB9086
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IO+7v09uIDEzLzA5LzIyLCA3OjA1IFBNLCAiVml0YWx5IEt1em5ldHNvdiIgPHZrdXpuZXRz
QHJlZGhhdC5jb20+IHdyb3RlOg0KPj4NCj4+IFRoYW5rcyBWaXRhbHkgZm9yIHlvdXIgcmVzcG9u
c2UuDQo+Pg0KPj4gMS4gd2UgaGF2ZSBtdWx0aXBsZSBvYmplY3RzIG9mIHN0cnVjdCBwY2lfcmF3
X29wcywgMi4gYWRkaW5nICdwcmlvcml0eScgZmllbGQgdG8gc3RydWN0IHBjaV9yYXdfb3BzDQo+
PiBkb2Vzbid0IHNlZW1zIHRvIGJlIGFwcHJvcHJpYXRlIGFzIG5lZWQgdG8gdGFrZSBkZWNpc2lv
biB3aGljaCBvYmplY3Qgb2Ygc3RydWN0IHBjaV9yYXdfb3BzIGhhcw0KPj4gdG8gYmUgdXNlZCwg
bm90IHNvbWV0aGluZyB3aXRoLWluIHN0cnVjdCBwY2lfcmF3X29wcy4NCj4NCj4gSSdtIG5vdCBz
dXJlIEkgZm9sbG93LCB5b3UgaGF2ZSB0d28gaW5zdGFuY2VzIG9mICdzdHJ1Y3QgcGNpX3Jhd19v
cHMnDQo+IHdoaWNoIGFyZSBjYWxsZWQgJ3Jhd19wY2lfb3BzJyBhbmQgJ3Jhd19wY2lfZXh0X29w
cycuIFdoYXQgaWYgeW91IGRvDQo+IHNvbWV0aGluZyBsaWtlIChjb21wbGV0ZWx5IHVudGVzdGVk
KToNCj4NCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BjaV94ODYuaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3BjaV94ODYuaA0KPiBpbmRleCA3MDUzM2ZkY2JmMDIuLmZiODI3
MGZhNmM3OCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGNpX3g4Ni5oDQo+
ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BjaV94ODYuaA0KPiBAQCAtMTE2LDYgKzExNiw3
IEBAIGV4dGVybiB2b2lkICgqcGNpYmlvc19kaXNhYmxlX2lycSkoc3RydWN0IHBjaV9kZXYgKmRl
dik7DQo+IGV4dGVybiBib29sIG1wX3Nob3VsZF9rZWVwX2lycShzdHJ1Y3QgZGV2aWNlICpkZXYp
Ow0KPg0KPiBzdHJ1Y3QgcGNpX3Jhd19vcHMgew0KPiArICAgICAgIGludCByYXRpbmc7DQo+ICAg
ICAgICAgIGludCAoKnJlYWQpKHVuc2lnbmVkIGludCBkb21haW4sIHVuc2lnbmVkIGludCBidXMs
IHVuc2lnbmVkIGludCBkZXZmbiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBpbnQgcmVnLCBpbnQgbGVuLCB1MzIgKnZhbCk7DQo+ICAgICAgICAgIGlu
dCAoKndyaXRlKSh1bnNpZ25lZCBpbnQgZG9tYWluLCB1bnNpZ25lZCBpbnQgYnVzLCB1bnNpZ25l
ZCBpbnQgZGV2Zm4sDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9wY2kvY29tbW9uLmMgYi9hcmNo
L3g4Ni9wY2kvY29tbW9uLmMNCj4gaW5kZXggZGRiNzk4NjAzMjAxLi5lOTk2NWZkMTE1NzYgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L3BjaS9jb21tb24uYw0KPiArKysgYi9hcmNoL3g4Ni9wY2kv
Y29tbW9uLmMNCj4gQEAgLTQwLDcgKzQwLDggQEAgY29uc3Qgc3RydWN0IHBjaV9yYXdfb3BzICpf
X3JlYWRfbW9zdGx5IHJhd19wY2lfZXh0X29wczsNCj4gIGludCByYXdfcGNpX3JlYWQodW5zaWdu
ZWQgaW50IGRvbWFpbiwgdW5zaWduZWQgaW50IGJ1cywgdW5zaWduZWQgaW50IGRldmZuLA0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgcmVnLCBp
bnQgbGVuLCB1MzIgKnZhbCkNCj4gew0KPiAtICAgICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcg
PCAyNTYgJiYgcmF3X3BjaV9vcHMpDQo+ICsgICAgICAgaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8
IDI1NiAmJiByYXdfcGNpX29wcyAmJg0KPiArICAgICAgICAgICAoIXJhd19wY2lfZXh0X29wcyB8
fCByYXdfcGNpX2V4dF9vcHMtPnJhdGluZyA8PSByYXdfcGNpX29wcy0+cmF0aW5nKSkNCj4gICAg
ICAgICAgICAgICAgIHJldHVybiByYXdfcGNpX29wcy0+cmVhZChkb21haW4sIGJ1cywgZGV2Zm4s
IHJlZywgbGVuLCB2YWwpOw0KPiAgICAgICAgIGlmIChyYXdfcGNpX2V4dF9vcHMpDQo+ICAgICAg
ICAgICAgICAgICByZXR1cm4gcmF3X3BjaV9leHRfb3BzLT5yZWFkKGRvbWFpbiwgYnVzLCBkZXZm
biwgcmVnLCBsZW4sIHZhbCk7DQo+IEBAIC01MCw3ICs1MSw4IEBAIGludCByYXdfcGNpX3JlYWQo
dW5zaWduZWQgaW50IGRvbWFpbiwgdW5zaWduZWQgaW50IGJ1cywgdW5zaWduZWQgaW50IGRldmZu
LA0KPiAgaW50IHJhd19wY2lfd3JpdGUodW5zaWduZWQgaW50IGRvbWFpbiwgdW5zaWduZWQgaW50
IGJ1cywgdW5zaWduZWQgaW50IGRldmZuLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBpbnQgcmVnLCBpbnQgbGVuLCB1MzIgdmFsKQ0KPiB7DQo+IC0g
ICAgICAgaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNpX29wcykNCj4gKyAg
ICAgICBpZiAoZG9tYWluID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzICYmDQo+ICsg
ICAgICAgICAgICghcmF3X3BjaV9leHRfb3BzIHx8IHJhd19wY2lfZXh0X29wcy0+cmF0aW5nIDw9
IHJhd19wY2lfb3BzLT5yYXRpbmcpKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHJhd19wY2lf
b3BzLT53cml0ZShkb21haW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVuLCB2YWwpOw0KPiAgICAgICAg
ICBpZiAocmF3X3BjaV9leHRfb3BzKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIHJhd19wY2lf
ZXh0X29wcy0+d3JpdGUoZG9tYWluLCBidXMsIGRldmZuLCByZWcsIGxlbiwgdmFsKTsNCj4NCj4g
YW5kIHRoZW4gc29tZXdoZXJlIGluIFZtd2FyZSBoeXBlcnZpc29yIGluaXRpYWxpemF0aW9uIGNv
ZGUNCj4gKGFyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMpIHlvdSBkbw0KPg0KPiAgcmF3X3Bj
aV9leHRfb3BzLT5yYXRpbmcgPSAxMDA7DQoNClRoYW5rcyBWaXRhbHksIGZvciB5b3VyIHJldmll
dyBhbmQgaGVscGluZyB1cyB0byBpbXByb3ZlIHRoZSBjb2RlLg0KDQpJIHdhcyB3b3JraW5nIHRv
IG1ha2UgY2hhbmdlcyBhcyB5b3Ugc3VnZ2VzdGVkLCBidXQgYmVmb3JlIHNlbmRpbmcgdjMgd291
bGQgbGlrZSB0bw0KZGlzY3VzcyBvbiBmb2xsb3dpbmc6DQoNCklmIHdlIGFkZCByYXRpbmcgd2l0
aC1pbiBzdHJ1Y3QgcGNpX3Jhd19vcHMgdGhlbiB3ZSBjYW4ndCBoYXZlIHBjaV9tbWNmZyBhcyBj
b25zdCwNCmFuZCBmb2xsb3dpbmcgY2hhbmdlIGlzIG11c3QgaW4gYXJjaC94ODYvcGNpL21tY29u
ZmlnXzY0LmM6DQoNCi1jb25zdCBzdHJ1Y3QgcGNpX3Jhd19vcHMgcGNpX21tY2ZnID0gew0KK3N0
cnVjdCBwY2lfcmF3X29wcyBwY2lfbW1jZmcgPSB7DQogCS5yZWFkID0JCXBjaV9tbWNmZ19yZWFk
LA0KIAkud3JpdGUgPQlwY2lfbW1jZmdfd3JpdGUsDQp9Ow0KDQpTbyB0byBhdm9pZCB0aGlzIGNo
YW5nZSwgaXMgaXQgZmluZSB0byBoYXZlIGdsb2JhbCBib29sIHByZWZlcl9yYXdfcGNpX2V4dF9v
cHM/DQoNCkFuZCByYXdfcGNpX3JlYWQoKSB3aWxsIGhhdmUgZm9sbG93aW5nIGNoYW5nZToNCg0K
LQlpZiAoZG9tYWluID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzKQ0KKwlpZiAoZG9t
YWluID09IDAgJiYgcmVnIDwgMjU2ICYmIHJhd19wY2lfb3BzICYmDQorCSAgICAgKCFwcmVmZXJf
cmF3X3BjaV9leHRfb3BzIHx8ICAhcmF3X3BjaV9leHRfb3BzKQ0KDQo+DQo+IHdoeSB3b3VsZG4n
dCBpdCB3b3JrPw0KPg0KPiAoZGljbGFpbWVyOiBjb21wbGV0ZWx5IHVudGVzdGVkLCByYXdfcGNp
X29wcy9yYXdfcGNpX2V4dF9vcHMNCj4gaW5pdGlhbGl6YXRpb24gaGFzIHRvIGJlIGNoZWNrZWQg
c28gJ3JhdGluZycgaXMgbm90IGdhcmJhZ2UpLg0KPg0KPj4NCj4+IEl0J3MgYSBnZW5lcmljIHNv
bHV0aW9uIGZvciBhbGwgaHlwZXJ2aXNvciAoc29ycnkgZm9yIGVhcmxpZXIgd3JvbmcNCj4+IFN1
YmplY3QpLCBub3Qgc3BlY2lmaWMgdG8gVk13YXJlLiBGdXJ0aGVyIGxvb2tpbmcgZm9yIGZlZWRi
YWNrIGlmIGl0J3MNCj4+IGltcGFjdGluZyB0byBhbnkgaHlwZXJ2aXNvci4NCj4NCj4gVGhhdCdz
IHRoZSB0cmlja3kgcGFydC4gV2UgY2FuIGNoZWNrIG1vZGVybiBoeXBlcnZpc29yIHZlcnNpb25z
LCBidXQNCj4gd2hhdCBhYm91dCBhbGwgb3RoZXIgdmVyc2lvbnMgaW4gZXhpc3RlbmNlPyBIb3cg
Y2FuIHdlIGtub3cgdGhhdCB0aGVyZSdzDQo+IG5vIFFFTVUvSHlwZXItVi8uLi4gdmVyc2lvbiBv
dXQgdGhlcmUgd2hlcmUgTU1JTyBwYXRoIGlzIGJyb2tlbj8gSSdkDQo+IHN1Z2dlc3Qgd2UgbGlt
aXQgdGhlIGNoYW5nZSB0byBWbXdhcmUgaHlwZXJ2aXNvciwgb3RoZXIgaHlwZXJ2aXNvcnMgbWF5
DQo+IHVzZSB0aGUgc2FtZSBtZWNoYW5pc20gKGxpa2UgdGhlIG9uZSBhYm92ZSkgbGF0ZXIgKGJ1
dCB0aGUgcGVyc29uDQo+IHN1Z2dlc3RpbmcgdGhlIHBhdGNoIGlzIGFsd2F5cyByZXNwb25zaWJs
ZSBmb3IgdGhlIHJlc2VhcmNoIHdoeSBpdCBpcw0KPiBzYWZlIHRvIGRvIHNvKS4NCg0KT2ssIGFz
IG9mIG5vdyB3ZSB3aWxsIG1ha2UgdGhpcyBjaGFuZ2Ugc3BlY2lmaWMgdG8gVk13YXJlIGh5cGVy
dmlzb3IuDQoNCi0gQWpheQ0KDQoNCg0K
