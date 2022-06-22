Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50FF75552F1
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376358AbiFVSEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiFVSEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:04:45 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD253389A;
        Wed, 22 Jun 2022 11:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMhZka+qkzeK2jmg5G4ONPXC0zy7yNolgDWsOUJgyZaYisIRDP6gi//sxmYpVI3hVabJwRlTIhKIjIGIifqQzduB+w2g96SeRCkBc2DoGuQRawlsaDeiDMb9KxEt+gAdZnPLNkSbqoZCwZiLhC8NetEy5crGLHJ5JW2EyInoLUU5HKniYNdcw3s5KN4//Ga7uLS/7dHZ8mWDW3iH4WiGRLdMszFTQibkOQjmank9yAvBfzuGq4TpjjPYcyuLOCAgY7nDvu8K/5IhLOEt9HDB9bRoRz1dwQAQAUZh1cS/U8+gl6abG1o/SUIoHkIF5beYPkvo85lFbMsv+48YRfbuGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7wCI4PkoDJydKuKDSHeTV5Lr8aQfPIKL+jScXwD9Pk=;
 b=fVNTVlVpR+KNdRP2es9aenUTwpWMBUUcnHCeZtPqz/HNyJrCJABWmYsOveTyOr40J/td3uqK77W4hDH6PXLSnQrojkTQCUzhB4+gYcWLh2ks/+vYh28zxHxMofp8su2deI+Xd98jwNrmy5/82bi0yCKTICyySM4Qt35wm73FY5dorc3wn0Cj88BVkgdzyNj33Y+OVG9xow/0w266zqcVnsU5WH7n00eWUEk6lzAdpXQ0JwYwBVlS0vNyj9/63BMAQ+7a3NqRJVpurBkBsiwWdnfH5lJhT8P2uLky6TmujEPxt2wKLdztVuntQe5awQGI+opByTu0ysSI8RRohiECQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7wCI4PkoDJydKuKDSHeTV5Lr8aQfPIKL+jScXwD9Pk=;
 b=hjnzAEJ+T3mA3ic+FmkVTw8X9iROZjnVCzeDuXEPcmrsSV/whDW38S35dmu55CWmS3z9rvhY8Wgh8zhuPiBU6wl4F8wwpxhoEG9am1fdDWeNYnnerxrOTju1fJ236RmHCeBGi7mjSALeOC5XF9bwKykNS8jPddKTE9bk7HqyjsI=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by CH2PR12MB3847.namprd12.prod.outlook.com (2603:10b6:610:2f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 18:04:40 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 18:04:40 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Topic: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Index: AQHYhkQRulHh/HmbIUq97K70l/FApa1bt/Ag
Date:   Wed, 22 Jun 2022 18:04:40 +0000
Message-ID: <BYAPR12MB27599015C77E3F1E164C01F48EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <d89c695e-7d45-160f-5e28-fee5ee576104@intel.com>
In-Reply-To: <d89c695e-7d45-160f-5e28-fee5ee576104@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T18:02:29Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=cd616676-b5d1-4f33-8618-61bf6ccaa0ef;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T18:04:37Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 6c98adc2-3ee7-4516-aac8-f296d0849895
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c517c317-ec30-44ff-f207-08da5479ad69
x-ms-traffictypediagnostic: CH2PR12MB3847:EE_
x-microsoft-antispam-prvs: <CH2PR12MB3847392472478874B215B8BB8EB29@CH2PR12MB3847.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kkUjkF7RMjvVn7N4RHI/P1fJ+1eTtPi6Pq3D/FnjNNP6Fra6cpRuY2xx8ooJ6a18ohXNruDsK2zc3YzHcesGt9KVu0wlyqY8hFw57W+kB7/tEi6BlfJKK9Ex08jgpoJkBq7qE/nmff8PETJWsCSlGEMw/MEplysw4bXPP/JsVZqTicitsKb4Imfn1kgf01RP7h1eNN2b9Nm/FMo/t47oAjmxHJyqGQjCFuCiRpXZh4bNRSM7+cuHFvatzu5WH9eBihADQtV5df/wvTeJOMjL1cuevqRu2JlHu4N3C3HsbzzV8Ea2wgNIjfd2odqHMBkMrp63E6Ze1yl2VIYhRvHawM8xmhvfQ0XsS2vgaQhS2JOn/wTyM61EE66L62i53dyqiK+HnWH1mE1XHiiFo7y1C7cJrOlQCM7DG8cJNooqRCN10QVmHTVX43DOTRShubiOHOYkD0kYNpGkCkF4QyjLPJ4PjvNgWXlouXqWGmgiDX5s9YLZhVDJSDnOvZhPzmKnHxNuOKG060xKdFFLbzB83WsRvUikSsFXPr33diqt2A5SBxwYwTQEidsS0oJ+UALIjc1ccLrbZdHAoYnaBlH24Zty6EHcysdw6wVy3dXk5Jwi3rvP+eeSPbqNJwRkirEGRiitG/4gTSjMIZFXY/c4dXOim09CLbFkCMwM7D/lfGAslCG06Lf+vxav9mflV4Un+3KbvmJNvmKk/IVdeXlv6A16RHUHy2FTBAW5U4KDABYVYmDvUgW8oOI+TBIgd1rqF/V+uGAROx2Q7Bq2UioZAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(71200400001)(478600001)(83380400001)(8936002)(316002)(9686003)(52536014)(33656002)(54906003)(186003)(110136005)(86362001)(41300700001)(38070700005)(26005)(5660300002)(2906002)(6506007)(4326008)(8676002)(66556008)(64756008)(66446008)(76116006)(66946007)(66476007)(7696005)(55016003)(122000001)(7406005)(7416002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGMvbit3ZC9qeW9NOG5GSUJJSE1lTlR5bWVzS0dERDBKQ1k2clg0UE9XdWRp?=
 =?utf-8?B?eWM1WmEvc0V6UUVTdkJycytGL21Eb1FDYm5nUXhZWE4zMkVzT3RNaFRjTUVz?=
 =?utf-8?B?S0JIOEJ5M01GOFQwQmhqZ1FXY3NDRkNtYmE3akJXVmlSUyszaUwyWEphczdL?=
 =?utf-8?B?Ylp5b1BvVm1kalFUTDQ1eTkzYUNhdWovTy9TK01Wa0ZTTmx6bExCRDFTclpp?=
 =?utf-8?B?a3h1RjdkeEIwN0s5eXZ1bmMzbUJIb0pYdjhEbS92cDFLcGxWQndENlBsWWx1?=
 =?utf-8?B?UWt4MUJNaEF0RmlFdzBPblg2TjlzcmNlMjhIOUt2WWx4UkF4ZjFoOXBSR25P?=
 =?utf-8?B?cHR2SGpUUWdOS0dsMWR5VWZ2ZUpiVjkrd3ZzNnU1bjU3cHRvc2pMVkR1eStK?=
 =?utf-8?B?U1A2dEZac21hLzZqcEIraU9jTDNqcFBYc3V0bGY2d1dzRWdDMVBGZWN0OUFE?=
 =?utf-8?B?bG45Zm8yZzM1UWdVNlhHWXlUT3o1RnpmczNISUZ1RHBuSzU2QXRBTWpSS0Zv?=
 =?utf-8?B?S0RJUVpycWd3YVRteGlqa2JFTmJNT2JpMlEwQmhtRlEyNHAyRnl0cFI2TTJv?=
 =?utf-8?B?VmhFUlJvbmp3ZWdsVTFpYkphbU1jSFFTcE5QbEE2QVh5blZyTGNGallVQXh0?=
 =?utf-8?B?S1ZRRWhlM3llcmZ3SE1YTGhqSE9lMUpVdEVGNllxRUlVeGIxbUJOY0J3bzJk?=
 =?utf-8?B?WjJCeXZ4ZVlZUXRJZkthakg5cXpkYVNQU2JmZ3R4ZG1lZW1odHVUT2ViNUJQ?=
 =?utf-8?B?bzczVTBFdnVUak5BSUtLbjM2ZmFIaVY4OVZybzNNeDN2TlZEQWpONDlxWjJr?=
 =?utf-8?B?VThQSzg0UzUrSGFpZG5FMFpPV1U1UmdTYU5hcFBLSzRiOXlDMm5nTGdsRXNE?=
 =?utf-8?B?QVRWZSs0Ykd0SVFMcEN1T05NU2FjK1hpVXJJUktWMmFScXZzeFJzeEJrejZj?=
 =?utf-8?B?UUc5SHBIaW55NUFOUHBJOVhrZTEzeHFvL1ErRjFpQ1RHckxXTXJ5UUZCU0Ex?=
 =?utf-8?B?TzA4a1hKTkpJYWhzdVJoWjlHeFl6VTdmRzAzQ0VobVQ2cDlJcHpFdUpGUXM2?=
 =?utf-8?B?aFV2QW5zaXJDb0h4cHVLWVYvV0NOdkpWczBMVC9FalNRQ205anRKeHJoODM0?=
 =?utf-8?B?eStLTWJBdVFYQmJWck1iL1k2dkZNYUxjWS84MVZmR3JjOGliSlNEYWNjNlFW?=
 =?utf-8?B?MFdnTzVYeEY1VHJub2JoNW5udG5zeTEvUkZtR1kzcWxoQUFlbERSRkdXd2lX?=
 =?utf-8?B?eVNRN0d6bXNmNWZsQkRpSGd5MTBINWJnai84Tm53UkRyUlhibDdTcHJvNlRq?=
 =?utf-8?B?elJoSHpKSWpWUFFMM1U0QTZnandBYUV4bVltTU5nZFIxdC83NWpQM1hLaVlI?=
 =?utf-8?B?UlV1cVhuM0U1V0REczVKcUxBTmFlaGZBN2JMZ1p6TEJmRko3NDdQUTFlNVhz?=
 =?utf-8?B?SklhbzUxSzA2dEorQWJPbzNGdzQwd1paekQ0anNnMzM4RkFvVDJJQk1WVGJo?=
 =?utf-8?B?dEpDRUJGZzV2Qi80WGYwQnZHeXp0eEdFSXl0eDh1VFlyU29GYWwwS0xGNkcz?=
 =?utf-8?B?c21uVzI0dkVIOEtRMHFCVGxhT2VhQkJUdXBjV3AxUDRDYURqSG5UVFFBaVFQ?=
 =?utf-8?B?QVpzNFVJR05aOVVsSEh4RW1yZUE5WU5pSDBabWFVWWdvSFhmT0ZSMG9sbnRO?=
 =?utf-8?B?b1Fqd253dTR1L05hZXJnYjNEbUkrSE5FVG9reU9NMVhvUzdxRVBxRUY4UTZE?=
 =?utf-8?B?MEd5QUUrS2g3WWJ5YWg1Y0R2cnlZOGxYQmlMM1JqblNMQTFvL1FWalBtL2F5?=
 =?utf-8?B?U3RIaGJQOFlJZTVTMy84NkNSYUhLUXBURjFXZ1dJNVcwT2kxRVdiK2loRGJP?=
 =?utf-8?B?VnZNS0VQK0dJTlorazdvdlFmQURiZHBDdjVsRGdkK2s0RVVOZGtyTkhGRlVt?=
 =?utf-8?B?OVlWWDF1QkN0ZHBVZHJ2dW9WWjEvQUlJc1FlUTh1Mm1ZWTlYbnpJbFI3ZGta?=
 =?utf-8?B?QmNocFVYTlJZZ1lZc00vMkZ5VEpZZnduL0NlcEVWbUFOUWF3TzZ2NitqYzc4?=
 =?utf-8?B?SFdDaXlSRUtRckw1UU1tN3dCZTJneHZhUXlmMWhyOUxXTlVNc1hyOU0rVnZB?=
 =?utf-8?B?aFZtREFjZDhpVTFXbWVUbFB0ZDBTTlYrandsOGd4eFJnK0tRb3J1Mms4WCtB?=
 =?utf-8?B?MTV6RHZLNmJncGZYM1lXaFIvVjdZV0QvY3crcE9STVpjT1pyT3pFTUgxY1Zo?=
 =?utf-8?B?a0lmMDR2Mzc2S3oxRUVlUGlIenl4TEx3aW5rSkZsY0h1V1U1T01IYXVmb3VW?=
 =?utf-8?Q?7brjrOsIQ/kOppATB7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c517c317-ec30-44ff-f207-08da5479ad69
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 18:04:40.3367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSdif/BpCLND6CO0+FE/xt3+1Upgv6STfNHPDDAFK/n2w1C3Hb3OYcHavpY6CEKFlK8sv32QiFs28wD3dTB7Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3847
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4+ICtpbnQgcHNtYXNoKHU2NCBw
Zm4pDQo+PiArew0KPj4gKwl1bnNpZ25lZCBsb25nIHBhZGRyID0gcGZuIDw8IFBBR0VfU0hJRlQ7
DQo+PiArCWludCByZXQ7DQo+PiArDQo+PiArCWlmICghcGZuX3ZhbGlkKHBmbikpDQo+PiArCQly
ZXR1cm4gLUVJTlZBTDsNCj4+ICsNCj4+ICsJaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9G
RUFUVVJFX1NFVl9TTlApKQ0KPj4gKwkJcmV0dXJuIC1FTlhJTzsNCj4+ICsNCj4+ICsJLyogQmlu
dXRpbHMgdmVyc2lvbiAyLjM2IHN1cHBvcnRzIHRoZSBQU01BU0ggbW5lbW9uaWMuICovDQo+PiAr
CWFzbSB2b2xhdGlsZSgiLmJ5dGUgMHhGMywgMHgwRiwgMHgwMSwgMHhGRiINCj4+ICsJCSAgICAg
IDogIj1hIihyZXQpDQo+PiArCQkgICAgICA6ICJhIihwYWRkcikNCj4+ICsJCSAgICAgIDogIm1l
bW9yeSIsICJjYyIpOw0KPj4gKw0KPj4gKwlyZXR1cm4gcmV0Ow0KPj4gK30NCj4+ICtFWFBPUlRf
U1lNQk9MX0dQTChwc21hc2gpOw0KDQo+SWYgYSBmdW5jdGlvbiBnZXRzIGFuIEVYUE9SVF9TWU1C
T0xfR1BMKCksIHRoZSBsZWFzdCB3ZSBjYW4gZG8gaXMgcmVhc29uYWJseSBkb2N1bWVudCBpdC4g
IFdlIGRvbid0IG5lZWQgZnVsbCBrZXJuZWxkb2Mgbm9uc2Vuc2UsIGJ1dCBhIG9uZS1saW5lIGFi
b3V0IHdoYXQgdGhpcyBkb2VzIHdvdWxkIGJlIHF1aXRlIGhlbHBmdWwuICBUaGF0IGdvZXMgZm9y
IGFsbCB0aGUgZnVuY3Rpb25zIGhlcmUuDQoNCj5JdCB3b3VsZCBhbHNvIGJlIGV4dHJlbWVseSBo
ZWxwZnVsIHRvIGhhdmUgdGhlIGNoYW5nZWxvZyBleHBsYWluIHdoeSB0aGVzZSBmdW5jdGlvbnMg
YXJlIGV4cG9ydGVkIGFuZCBob3cgdGhlIGV4cG9ydHMgd2lsbCBiZSB1c2VkLg0KDQpJIHdpbGwg
YWRkIGJhc2ljIGRlc2NyaXB0aW9ucyBmb3IgYWxsIHRoZXNlIGV4cG9ydGVkIGZ1bmN0aW9ucy4N
Cg0KVGhhbmtzLA0KQXNoaXNoDQoNCj5BcyBhIGdlbmVyYWwgcnVsZSwgcGxlYXNlIHB1c2ggY3B1
X2ZlYXR1cmVfZW5hYmxlZCgpIGNoZWNrcyBhcyBlYXJseSBhcyB5b3UgcmVhc29uYWJseSBjYW4u
ICBUaGV5IGFyZSAqVkVSWSogY2hlYXAgYW5kIGNhbiBldmVuIGVuYWJsZSB0aGUgY29tcGlsZXIg
dG8gY29tcGxldGVseSB6YXAgY29kZSBsaWtlIGFuICNpZmRlZi4NCg0KVGhlcmUgYWxzbyBzZWVt
IHRvIGJlIGEgbG90IG9mIHBmbl92YWxpZCgpIGNoZWNrcyBpbiBoZXJlIHRoYXQgYXJlbid0IHZl
cnkgd2VsbCB0aG91Z2h0IG91dC4gIEZvciBpbnN0YW5jZSwgdGhlcmUncyBhIHBmbl92YWxpZCgp
IGNoZWNrIGhlcmU6DQoNCg0KK2ludCBybXBfbWFrZV9zaGFyZWQodTY0IHBmbiwgZW51bSBwZ19s
ZXZlbCBsZXZlbCkgew0KKwlzdHJ1Y3Qgcm1wdXBkYXRlIHZhbDsNCisNCisJaWYgKCFwZm5fdmFs
aWQocGZuKSkNCisJCXJldHVybiAtRUlOVkFMOw0KLi4uDQorCXJldHVybiBybXB1cGRhdGUocGZu
LCAmdmFsKTsNCit9DQoNCmFuZCBpbiBybXB1cGRhdGUoKToNCg0KK3N0YXRpYyBpbnQgcm1wdXBk
YXRlKHU2NCBwZm4sIHN0cnVjdCBybXB1cGRhdGUgKnZhbCkgew0KKwl1bnNpZ25lZCBsb25nIHBh
ZGRyID0gcGZuIDw8IFBBR0VfU0hJRlQ7DQorCWludCByZXQ7DQorDQorCWlmICghcGZuX3ZhbGlk
KHBmbikpDQorCQlyZXR1cm4gLUVJTlZBTDsNCi4uLg0KDQoNClRoaXMgaXMgKGF0IGJlc3QpIHdh
c3RlZnVsLiAgQ291bGQgaXQgYmUgcmVmYWN0b3JlZD8NCg==
