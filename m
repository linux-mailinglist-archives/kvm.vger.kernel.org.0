Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89A553B54
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353711AbiFUURV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 16:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiFUURT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 16:17:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0024F2A70D;
        Tue, 21 Jun 2022 13:17:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctVlgznizxfgVoD8+tJ7yYEftRN06MbFf9yNEoMM4f2D/g35ksmrGKxdiDKHFhbrP77YyF3xYUdYmuwNymsWYJlUPCEptAUkZzmR5ip8pfR15W1XYX3XNo3x0j5IL2IjovRFBZbunPDu0ZNRFdtvQQTk9z1dcUbCWSPh50oGKcyXYEIwDXPletXIw3045xOGKUdKIiDObNrIKFrBzrP8h5UwjWzSYR+KBuFPz7kE0W9thp2AUgb8czxXlGrJF7EHSj71be1HPiNjEKL9X46H/EtXNkfl9ohHEOM8IKdy+y+NtqoPI3gF0eOPpPOTSotPHcpKwn0hD9lIKr0Zg3d0/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkOlL6k/8gXpWMU958lgZu4PhxJ57T5r9KoyhnsKKJg=;
 b=JygLAZ0TQpqygaTkBzolOAhom4A6kGfKXV1vxWF96jL+x7XtXD3xYxbVsk3VB0GpCxSYuLPrJ9JJbYO1Dyhbg5sd4RWBCLf4WJZoG1O0lpaMDdptM3JNjKWua2nhjLGSnIsTLViWBZ+aQYPrS0w5abICW/Mf3h+dvzw/YHfJZzteJ9omyddQhGcv2QZSoomMamKZeOeWfM0Cklh/GPrrlm/XHw1bAEVYmZ8B8LdHse9vlbAwDaKgiFTfS6JEREt+G3dJTh33U3XNDt2OQoPBL8jF3J3mCZYlqjuWYwDNl/io5yfvQdHlBm9oWtOrDZkw3IeK75tlVcQaFh8jQqez+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkOlL6k/8gXpWMU958lgZu4PhxJ57T5r9KoyhnsKKJg=;
 b=wnM71+eXDJ4dk6c0D/f/i2i5+7rnT4M0OO3y9tbUUx8fWIIlFxuWMyMR6NCDi4Or2oe0bWPMc7vHT1K08gK8e7PKcBLir3mnfLIY0k8skzEtMIHaMWMRqIilVB3hIPdIGr20AEB41K8HXH2bkO8KYiPTyZQc2RXQdjjDol4tg0w=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5052.namprd12.prod.outlook.com (2603:10b6:408:135::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 20:17:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 20:17:15 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Thread-Topic: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Thread-Index: AQHYhZpY+tOs5rhl/E63aZQgkZ9Qqa1aQYRA
Date:   Tue, 21 Jun 2022 20:17:15 +0000
Message-ID: <SN6PR12MB276722570164ECD120BA4D628EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6ruxMazN3NmWHsemDNQj6Uj0PhCVeaxw2unCxU=YZFRWw@mail.gmail.com>
In-Reply-To: <CAMkAt6ruxMazN3NmWHsemDNQj6Uj0PhCVeaxw2unCxU=YZFRWw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-21T19:40:20Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=25b415e6-13f3-4207-9342-ca3d7c21768e;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-21T20:17:13Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: cc1f3d52-50cb-4506-9c6d-af57c945b07d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65f7ffdf-7775-43d4-04de-08da53c308cc
x-ms-traffictypediagnostic: BN9PR12MB5052:EE_
x-microsoft-antispam-prvs: <BN9PR12MB5052DED06A26991D4ACB3DD38EB39@BN9PR12MB5052.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwP/8ofCPxXWDOvivGng4TdCeO9ljkzLjhySESYbS5W98ytEVG6j6NCHwm0oJVeFsC+NCo38Oq59xjuklpkWCIn+8GKONNdMVkFG6/ZumdnIME213SbwFUdWOrqzHbdDbq45wPWkz+ITjPUhH287QSn67g5Xrh1yyeqi+ropyjZVxB+UzZ8m/TbcmCG0WSPf38PBhyFLxclDwAbe4AjBzZegk80DQArSv3k6uvfSb9FjJ7wfWzGr094CwTBs9P1ipCwac5FkmqcYNoDxGd5X1xBfkwEaVBXKyhIulJ9+3nSZeGJbkg3BwlJAX/oALTm1uP7zbi8kU2g/uAlE/ow6ZHmFqaF6XW11x7CDUFiEoF10PJ1DZQAy7QKfbY/gDSsD0yK8yl0DPGTtilgTtmW/776ac/YSbjsMyfk5y83xWZKZWNbglOdCOLg+O/Ah7iR41zcuUHVqY2ek+5iwePNPiJKzM7XTjYdOPFFF7KXp/PnYg/46tYfV5AY0m/2HGqP9GEuXHHtLkyhCKz44pZ+sh5lYgAyZviv6ciF7Oxj2qjp5BeH1aZsqhyMEcs+xVtepyfg4W4zbRBlF7uHuox7U1PG3vpm56CS7f7EshlmViIO0lYeZl6sGl2ucevtgk4SRFk0+CRk9daJzX+vcVw4hbDrvhAMckVgjJMP6G30J3t3bp4Yo3yxG+qZ6eppywfdU4oOKAzWoASyoA+ub1uCXSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(4326008)(66556008)(71200400001)(66446008)(122000001)(54906003)(478600001)(316002)(64756008)(38070700005)(6916009)(8676002)(76116006)(66476007)(66946007)(186003)(83380400001)(86362001)(26005)(41300700001)(33656002)(9686003)(7696005)(38100700002)(5660300002)(7416002)(8936002)(55016003)(52536014)(6506007)(2906002)(7406005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEp3bFR6V3ZTcTNPenhycWlad2FJVVFKWUpWb3g5YzZJbmdrcWZvaDg2RldM?=
 =?utf-8?B?ZERabzFqeEVwNE85NHJNNURZQ1ZTZWh6b3lRSVkvbExORVF4dWR6alN0QVc4?=
 =?utf-8?B?anBwWlU3R3ZCQkNReThKalc1MTJkNGU0eGhEeXJyYU8zRDNMQ2x0WmNCeTZy?=
 =?utf-8?B?cWQ4Q01sVlJ0djJSWVZFa2NldlBsbDhkenZTMTJiT09uVDRMUjBRM04xL0JK?=
 =?utf-8?B?UGxOT2lwN2orMGtwNm8zb25wOUVBT01PRGd3U0NaeVJWWWtUYU5SSnJLeUVO?=
 =?utf-8?B?b3JrNU9IL2tQcWV4U2lxVHhkVm5HUWw4R25haVdNQ1RoRS8rUEI2enZxR3Uw?=
 =?utf-8?B?R2FVUHV6cGoxMjFLNWVGbnk3Q0hNOEx0Q2ZHeVZtQUtCYzJFRGdWakdKUVJm?=
 =?utf-8?B?NVZHZk9iU0xSOHRVUTl6YmJRV2xVOWptOXdLVFJpUWRnRDVEOURIRlU2Rm44?=
 =?utf-8?B?UnU4ckZJbys0Vzd4VGt1VW4rWm4xenJST1V2L1FDb3JpZ0JxcitlYmNUNHA4?=
 =?utf-8?B?RUMrZDZURkJSZzdMazBFYzNMbnZobUNUOWhJSUE1OFZ5MXJNZytmVlVYRWYw?=
 =?utf-8?B?NElidy9mY3V3STNJSHM2RVRGZW1VVVVsQUZ0cHJ2TUhETy9Zb1hjQ3pHdEdF?=
 =?utf-8?B?OUdGZHhTR1lzRUVWYzBvdzNxZlJFS2wyZzhrYnBuUWIxd3lpcW45bU1hYVNs?=
 =?utf-8?B?TElYSEs5SnBLaWRlYjFlSmtsVlFPZ1MxZUR4NDhMSDVRLzF2QktnTCtVOXFq?=
 =?utf-8?B?aWJ0Qk5mcjQ1RWYrSVRGMTZ6dlhFclBJQ3JVWndWWFBCdXIzb0dkU3granFR?=
 =?utf-8?B?ZUpsZzd4NURlSVZPekZhV2pYbDNtQUJoZkpWRDFSOGQvYzA1djhzOCtOOUxE?=
 =?utf-8?B?M3oyNW9McUxVbkpXdFh2aG14TURLUWpJemU3c1gyY0R5anA5SERyN2NrREpN?=
 =?utf-8?B?bDdtY1Y5Y3VublU4Z3l5OExDVkt4cmg2NGJ6ZUIwa2Uxdjl3dnZqK1NoLy81?=
 =?utf-8?B?dnlZNlowdGliZ2ZSc3RpOFJIRWxwS0dvQWNsS1dCRTBqTmROQU5naW5GcEQx?=
 =?utf-8?B?N1k0d0lxeTM1aiswNmo1NjB1YS96UW11ZDh4L29wWTl4cFZmQ3dQdG9xbUJ2?=
 =?utf-8?B?NGt3S3F3QUZKU1UzaVA4WWJkT1VmUVgrcmZ3aTJndUxCSUVFdDU4M054Q2Nq?=
 =?utf-8?B?d1NOQzVHZDJoY3JFZmIxKzNGcEJZSWRiT044ZTB3MzNOK2dQb0VBK3dPaXlq?=
 =?utf-8?B?Mk5Wb05wWHFLYkdJUDF6MEc4MTNZNGxka2xBUllyVHV2Y2JwUmtjWld5RDZZ?=
 =?utf-8?B?dUN4NDhBV3lPK0VJcjFCNVhib1RjaXBVeEhsdkZLK3NrU01RanY4SkdxRWp3?=
 =?utf-8?B?c0tzTjlLL2xaMW13dk5SbG9ZL05QcUR6Q2RYbHNaQVZVNnVudFFhRUpnRHdJ?=
 =?utf-8?B?bGJFT2haMkI3U2p3akVrKzdUSVBBbytTcEk2dktndEpkb3lvTWlMaXdjZzBj?=
 =?utf-8?B?TVhIWTNkb3hNMTlyRnNTTkRKeStoUnZSVGgyZjdJbXhQMm94QlFzZFlQajhz?=
 =?utf-8?B?bDBKZkdpeHgxL1ZHVHp2MHR6K01EWnRuVS8wSk9wQ2R0WXErdGE4Znp0U2Z2?=
 =?utf-8?B?WVZIS0FiWjR1TVNjU3JRVzgrbHBybHp2ZHlGekNCVWp1NGx0R0lLOVJqOFVl?=
 =?utf-8?B?TkJ1STlUU3FyaUZDOFJxVi91VmNwL2JqY1NYelNnbnc4VS9vUXJWQnRLazZV?=
 =?utf-8?B?ZkZjb0toZGgxcnhBcktkN2RKbWt3WXhQSkw2RmZmb0tCWU5RU3ROa2xNWDZW?=
 =?utf-8?B?dm80anpVQUVEVHg1SFNyYWViOWlEQVVoWDYzMHdRZVZvSnplRlNCb2hsNk45?=
 =?utf-8?B?b1NHTnBpRzcwUUtlellob0NrUGJ3dFJJWElha05odnVocHh0ZEx6NTdER01h?=
 =?utf-8?B?QVpyWkFwTjFrb2lCb0t0UDJmdDMxQ25zODJsZElmeTAzMGV3bDNpYnlCZUFH?=
 =?utf-8?B?U0MvYXRTaWl2MGdVZVIvZVFzR2lpZTl2OHhGdjlWV0JTUVEzaWpKUTFOaXU3?=
 =?utf-8?B?UktQZC95UktueStqQWNiNnJDd255ZWJ5dDFMSlQ3aHVDYldjajNGYzZmOERN?=
 =?utf-8?B?SDB6YURZUjZQSXlxbkQyTFJ2YlJmajh5SzFKbmd4c1JPMmZ6RTBSaXU2VC9k?=
 =?utf-8?B?Q0g5RnF4ZWhUckNDd24wVmJNVnBZQmNNUjdoMG5EVGlTWWZveXFtMzJZclFQ?=
 =?utf-8?B?ODdLak9ZVGU3Qklhay9iS3NhaVlpZGxJMitxZTVHakVpcXF0d2p6UFJuVEdN?=
 =?utf-8?Q?qopmJDbH8aGA/LqXHb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f7ffdf-7775-43d4-04de-08da53c308cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 20:17:15.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4b/+SVDMzB4L3GCh3Lo3cBR930j9t3HShUZ2RiauQnK0bCXIOlPALQy/+QGQL0z2IUquwuthA2iSjU/G4+cMWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KSGVsbG8gUGV0ZXIsDQoNCj4+ICtzdGF0aWMgaW50IHNucF9yZWNsYWltX3Bh
Z2VzKHVuc2lnbmVkIGxvbmcgcGZuLCB1bnNpZ25lZCBpbnQgbnBhZ2VzLCANCj4+ICtib29sIGxv
Y2tlZCkgew0KPj4gKyAgICAgICBzdHJ1Y3Qgc2V2X2RhdGFfc25wX3BhZ2VfcmVjbGFpbSBkYXRh
Ow0KPj4gKyAgICAgICBpbnQgcmV0LCBlcnIsIGksIG4gPSAwOw0KPj4gKw0KPj4gKyAgICAgICBm
b3IgKGkgPSAwOyBpIDwgbnBhZ2VzOyBpKyspIHsNCg0KPldoYXQgYWJvdXQgc2V0dGluZyB8bnwg
aGVyZSB0b28sIGFsc28gdGhlIG90aGVyIGluY3JlbWVudHMuDQoNCj5mb3IgKGkgPSAwLCBuID0g
MDsgaSA8IG5wYWdlczsgaSsrLCBuKyssIHBmbisrKQ0KDQpZZXMgdGhhdCBpcyBzaW1wbGVyLg0K
DQo+PiArICAgICAgICAgICAgICAgbWVtc2V0KCZkYXRhLCAwLCBzaXplb2YoZGF0YSkpOw0KPj4g
KyAgICAgICAgICAgICAgIGRhdGEucGFkZHIgPSBwZm4gPDwgUEFHRV9TSElGVDsNCj4+ICsNCj4+
ICsgICAgICAgICAgICAgICBpZiAobG9ja2VkKQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAg
cmV0ID0gX19zZXZfZG9fY21kX2xvY2tlZChTRVZfQ01EX1NOUF9QQUdFX1JFQ0xBSU0sICZkYXRh
LCAmZXJyKTsNCj4+ICsgICAgICAgICAgICAgICBlbHNlDQo+PiArICAgICAgICAgICAgICAgICAg
ICAgICByZXQgPSBzZXZfZG9fY21kKFNFVl9DTURfU05QX1BBR0VfUkVDTEFJTSwgDQo+PiArICZk
YXRhLCAmZXJyKTsNCg0KPiBDYW4gd2UgY2hhbmdlIGBzZXZfY21kX211dGV4YCB0byBzb21lIHNv
cnQgb2YgbmVzdGluZyBsb2NrIHR5cGU/IFRoYXQgY291bGQgY2xlYW4gdXAgdGhpcyBpZiAobG9j
a2VkKSBjb2RlLg0KDQo+ICtzdGF0aWMgaW5saW5lIGludCBybXBfbWFrZV9maXJtd2FyZSh1bnNp
Z25lZCBsb25nIHBmbiwgaW50IGxldmVsKSB7DQo+ICsgICAgICAgcmV0dXJuIHJtcF9tYWtlX3By
aXZhdGUocGZuLCAwLCBsZXZlbCwgMCwgdHJ1ZSk7IH0NCj4gKw0KPiArc3RhdGljIGludCBzbnBf
c2V0X3JtcF9zdGF0ZSh1bnNpZ25lZCBsb25nIHBhZGRyLCB1bnNpZ25lZCBpbnQgbnBhZ2VzLCBi
b29sIHRvX2Z3LCBib29sIGxvY2tlZCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICBi
b29sIG5lZWRfcmVjbGFpbSkNCg0KPlRoaXMgZnVuY3Rpb24gY2FuIGRvIGEgbG90IGFuZCB3aGVu
IEkgcmVhZCB0aGUgY2FsbCBzaXRlcyBpdHMgaGFyZCB0byBzZWUgd2hhdCBpdHMgZG9pbmcgc2lu
Y2Ugd2UgaGF2ZSBhIGNvbWJpbmF0aW9uIG9mIGFyZ3VtZW50cyB3aGljaCB0ZWxsIHVzIHdoYXQg
YmVoYXZpb3IgaXMgaGFwcGVuaW5nLCBzb21lIG9mIHdoaWNoIGFyZSBub3QgdmFsaWQgKGV4OiB0
b19mdyA9PSB0cnVlIGFuZCBuZWVkX3JlY2xhaW0gPT0gdHJ1ZSBpcyBhbiA+aW52YWxpZCBhcmd1
bWVudCBjb21iaW5hdGlvbikuDQoNCnRvX2Z3IGlzIHVzZWQgdG8gbWFrZSBhIGZpcm13YXJlIHBh
Z2UgYW5kIG5lZWRfcmVjbGFpbSBpcyBmb3IgZnJlZWluZyB0aGUgZmlybXdhcmUgcGFnZSwgc28g
dGhleSBhcmUgZ29pbmcgdG8gYmUgbXV0dWFsbHkgZXhjbHVzaXZlLiANCg0KSSBhY3R1YWxseSBj
YW4gY29ubmVjdCB3aXRoIGl0IHF1aXRlIGxvZ2ljYWxseSB3aXRoIHRoZSBjYWxsZXJzIDoNCnNu
cF9hbGxvY19maXJtd2FyZV9wYWdlcyB3aWxsIGNhbGwgd2l0aCB0b19mdyA9IHRydWUgYW5kIG5l
ZWRfcmVjbGFpbSA9IGZhbHNlDQphbmQgc25wX2ZyZWVfZmlybXdhcmVfcGFnZXMgd2lsbCBkbyB0
aGUgb3Bwb3NpdGUsIHRvX2Z3ID0gZmFsc2UgYW5kIG5lZWRfcmVjbGFpbSA9IHRydWUuDQoNClRo
YXQgc2VlbXMgc3RyYWlnaHRmb3J3YXJkIHRvIGxvb2sgYXQuDQoNCj5BbHNvIHRoaXMgZm9yIGxv
b3Agb3ZlciB8bnBhZ2VzfCBpcyBkdXBsaWNhdGVkIGZyb20gc25wX3JlY2xhaW1fcGFnZXMoKS4g
T25lIGltcHJvdmVtZW50IGhlcmUgaXMgdGhhdCBvbiB0aGUgY3VycmVudA0KPnNucF9yZWNsYWlt
X3BhZ2VzKCkgaWYgd2UgZmFpbCB0byByZWNsYWltIGEgcGFnZSB3ZSBhc3N1bWUgd2UgY2Fubm90
IHJlY2xhaW0gdGhlIG5leHQgcGFnZXMsIHRoaXMgbWF5IGNhdXNlIHVzIHRvIHNucF9sZWFrX3Bh
Z2VzKCkgbW9yZSBwYWdlcyB0aGFuIHdlIGFjdHVhbGx5IG5lZWQgdG9vLg0KDQpZZXMgdGhhdCBp
cyB0cnVlLg0KDQo+V2hhdCBhYm91dCBzb21ldGhpbmcgbGlrZSB0aGlzPw0KDQo+c3RhdGljIHNu
cF9sZWFrX3BhZ2UodTY0IHBmbiwgZW51bSBwZ19sZXZlbCBsZXZlbCkgew0KPiAgIG1lbW9yeV9m
YWlsdXJlKHBmbiwgMCk7DQo+ICAgZHVtcF9ybXBlbnRyeShwZm4pOw0KPn0NCg0KPnN0YXRpYyBp
bnQgc25wX3JlY2xhaW1fcGFnZSh1NjQgcGZuLCBlbnVtIHBnX2xldmVsIGxldmVsKSB7DQo+ICBp
bnQgcmV0Ow0KPiAgc3RydWN0IHNldl9kYXRhX3NucF9wYWdlX3JlY2xhaW0gZGF0YTsNCg0KPiAg
cmV0ID0gc2V2X2RvX2NtZChTRVZfQ01EX1NOUF9QQUdFX1JFQ0xBSU0sICZkYXRhLCAmZXJyKTsN
Cj4gIGlmIChyZXQpDQo+ICAgIGdvdG8gY2xlYW51cDsNCg0KPiAgcmV0ID0gcm1wX21ha2Vfc2hh
cmVkKHBmbiwgbGV2ZWwpOw0KPiAgaWYgKHJldCkNCj4gICAgZ290byBjbGVhbnVwOw0KDQo+IHJl
dHVybiAwOw0KDQo+Y2xlYW51cDoNCj4gICAgc25wX2xlYWtfcGFnZShwZm4sIGxldmVsKQ0KPn0N
Cg0KPnR5cGVkZWYgaW50ICgqcm1wX3N0YXRlX2NoYW5nZV9mdW5jKSAodTY0IHBmbiwgZW51bSBw
Z19sZXZlbCBsZXZlbCk7DQoNCj5zdGF0aWMgaW50IHNucF9zZXRfcm1wX3N0YXRlKHVuc2lnbmVk
IGxvbmcgcGFkZHIsIHVuc2lnbmVkIGludCBucGFnZXMsIHJtcF9zdGF0ZV9jaGFuZ2VfZnVuYyBz
dGF0ZV9jaGFuZ2UsIHJtcF9zdGF0ZV9jaGFuZ2VfZnVuYyBjbGVhbnVwKSB7DQo+ICBzdHJ1Y3Qg
c2V2X2RhdGFfc25wX3BhZ2VfcmVjbGFpbSBkYXRhOw0KPiAgaW50IHJldCwgZXJyLCBpLCBuID0g
MDsNCg0KPiAgZm9yIChpID0gMCwgbiA9IDA7IGkgPCBucGFnZXM7IGkrKywgbisrLCBwZm4rKykg
ew0KPiAgICByZXQgPSBzdGF0ZV9jaGFuZ2UocGZuLCBQR19MRVZFTF80SykNCj4gICAgaWYgKHJl
dCkNCj4gICAgICBnb3RvIGNsZWFudXA7DQo+ICB9DQoNCj4gIHJldHVybiAwOw0KDQo+IGNsZWFu
dXA6DQo+ICBmb3IgKDsgaT49IDA7IGktLSwgbi0tLCBwZm4tLSkgew0KPiAgICBjbGVhbnVwKHBm
biwgUEdfTEVWRUxfNEspOw0KPiAgfQ0KDQo+ICByZXR1cm4gcmV0Ow0KPn0NCg0KPlRoZW4gaW5z
aWRlIG9mIF9fc25wX2FsbG9jX2Zpcm13YXJlX3BhZ2VzKCk6DQoNCj5zbnBfc2V0X3JtcF9zdGF0
ZShwYWRkciwgbnBhZ2VzLCBybXBfbWFrZV9maXJtd2FyZSwgc25wX3JlY2xhaW1fcGFnZSk7DQoN
Cj5BbmQgaW5zaWRlIG9mIF9fc25wX2ZyZWVfZmlybXdhcmVfcGFnZXMoKToNCg0KPnNucF9zZXRf
cm1wX3N0YXRlKHBhZGRyLCBucGFnZXMsIHNucF9yZWNsYWltX3BhZ2UsIHNucF9sZWFrX3BhZ2Up
Ow0KDQo+SnVzdCBhIHN1Z2dlc3Rpb24gZmVlbCBmcmVlIHRvIGlnbm9yZS4gVGhlIHJlYWRhYmls
aXR5IGNvbW1lbnQgY291bGQgYmUgYWRkcmVzc2VkIG11Y2ggbGVzcyBpbnZhc2l2ZWx5IGJ5IGp1
c3QgbWFraW5nIHNlcGFyYXRlIGZ1bmN0aW9ucyBmb3IgZWFjaCB2YWxpZCBjb21iaW5hdGlvbiBv
ZiBhcmd1bWVudHMgaGVyZS4gTGlrZSBzbnBfc2V0X3JtcF9md19zdGF0ZSgpLCBzbnBfc2V0X3Jt
cF9zaGFyZWRfc3RhdGUoKSwNCj5zbnBfc2V0X3JtcF9yZWxlYXNlX3N0YXRlKCkgb3Igc29tZXRo
aW5nLg0KDQo+PiArc3RhdGljIHN0cnVjdCBwYWdlICpfX3NucF9hbGxvY19maXJtd2FyZV9wYWdl
cyhnZnBfdCBnZnBfbWFzaywgaW50IA0KPj4gK29yZGVyLCBib29sIGxvY2tlZCkgew0KPj4gKyAg
ICAgICB1bnNpZ25lZCBsb25nIG5wYWdlcyA9IDF1bCA8PCBvcmRlciwgcGFkZHI7DQo+PiArICAg
ICAgIHN0cnVjdCBzZXZfZGV2aWNlICpzZXY7DQo+PiArICAgICAgIHN0cnVjdCBwYWdlICpwYWdl
Ow0KPj4gKw0KPj4gKyAgICAgICBpZiAoIXBzcF9tYXN0ZXIgfHwgIXBzcF9tYXN0ZXItPnNldl9k
YXRhKQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPj4gKw0KPj4gKyAgICAgICBw
YWdlID0gYWxsb2NfcGFnZXMoZ2ZwX21hc2ssIG9yZGVyKTsNCj4+ICsgICAgICAgaWYgKCFwYWdl
KQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPj4gKw0KPj4gKyAgICAgICAvKiBJ
ZiBTRVYtU05QIGlzIGluaXRpYWxpemVkIHRoZW4gYWRkIHRoZSBwYWdlIGluIFJNUCB0YWJsZS4g
Ki8NCj4+ICsgICAgICAgc2V2ID0gcHNwX21hc3Rlci0+c2V2X2RhdGE7DQo+PiArICAgICAgIGlm
ICghc2V2LT5zbnBfaW5pdGVkKQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiBwYWdlOw0KPj4g
Kw0KPj4gKyAgICAgICBwYWRkciA9IF9fcGEoKHVuc2lnbmVkIGxvbmcpcGFnZV9hZGRyZXNzKHBh
Z2UpKTsNCj4+ICsgICAgICAgaWYgKHNucF9zZXRfcm1wX3N0YXRlKHBhZGRyLCBucGFnZXMsIHRy
dWUsIGxvY2tlZCwgZmFsc2UpKQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KDQo+
U28gd2hhdCBhYm91dCB0aGUgY2FzZSB3aGVyZSBzbnBfc2V0X3JtcF9zdGF0ZSgpIGZhaWxzIGJ1
dCB3ZSB3ZXJlIGFibGUgdG8gcmVjbGFpbSBhbGwgdGhlIHBhZ2VzPyBTaG91bGQgd2UgYmUgYWJs
ZSB0byBzaWduYWwgdGhhdCB0byBjYWxsZXJzIHNvIHRoYXQgd2UgY291bGQgZnJlZSB8cGFnZXwg
aGVyZT8gQnV0IGdpdmVuIHRoaXMgaXMgYW4gZXJyb3IgcGF0aCBhbHJlYWR5IG1heWJlIHdlIGNh
biBvcHRpbWl6ZSB0aGlzIGluIGEgPmZvbGxvdyB1cCBzZXJpZXMuDQoNClllcywgd2Ugc2hvdWxk
IGFjdHVhbGx5IHRpZSBpbiB0byBzbnBfcmVjbGFpbV9wYWdlcygpIHN1Y2Nlc3Mgb3IgZmFpbHVy
ZSBoZXJlIGluIHRoZSBjYXNlIHdlIHdlcmUgYWJsZSB0byBzdWNjZXNzZnVsbHkgdW5yb2xsIHNv
bWUgb3IgYWxsIG9mIHRoZSBmaXJtd2FyZSBzdGF0ZSBjaGFuZ2UuDQoNCj4gKw0KPiArICAgICAg
IHJldHVybiBwYWdlOw0KPiArfQ0KPiArDQo+ICt2b2lkICpzbnBfYWxsb2NfZmlybXdhcmVfcGFn
ZShnZnBfdCBnZnBfbWFzaykgew0KPiArICAgICAgIHN0cnVjdCBwYWdlICpwYWdlOw0KPiArDQo+
ICsgICAgICAgcGFnZSA9IF9fc25wX2FsbG9jX2Zpcm13YXJlX3BhZ2VzKGdmcF9tYXNrLCAwLCBm
YWxzZSk7DQo+ICsNCj4gKyAgICAgICByZXR1cm4gcGFnZSA/IHBhZ2VfYWRkcmVzcyhwYWdlKSA6
IE5VTEw7IH0gDQo+ICtFWFBPUlRfU1lNQk9MX0dQTChzbnBfYWxsb2NfZmlybXdhcmVfcGFnZSk7
DQo+ICsNCj4gK3N0YXRpYyB2b2lkIF9fc25wX2ZyZWVfZmlybXdhcmVfcGFnZXMoc3RydWN0IHBh
Z2UgKnBhZ2UsIGludCBvcmRlciwgDQo+ICtib29sIGxvY2tlZCkgew0KPiArICAgICAgIHVuc2ln
bmVkIGxvbmcgcGFkZHIsIG5wYWdlcyA9IDF1bCA8PCBvcmRlcjsNCj4gKw0KPiArICAgICAgIGlm
ICghcGFnZSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gKw0KPiArICAgICAgIHBhZGRy
ID0gX19wYSgodW5zaWduZWQgbG9uZylwYWdlX2FkZHJlc3MocGFnZSkpOw0KPiArICAgICAgIGlm
IChzbnBfc2V0X3JtcF9zdGF0ZShwYWRkciwgbnBhZ2VzLCBmYWxzZSwgbG9ja2VkLCB0cnVlKSkN
Cj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCg0KPiBIZXJlIHdlIG1heSBiZSBhYmxlIHRvIGZy
ZWUgc29tZSBvZiB8cGFnZXwgZGVwZW5kaW5nIGhvdyB3aGVyZSBpbnNpZGUgb2Ygc25wX3NldF9y
bXBfc3RhdGUoKSB3ZSBmYWlsZWQuIEJ1dCBhZ2FpbiBnaXZlbiB0aGlzIGlzIGFuIGVycm9yIHBh
dGggYWxyZWFkeSBtYXliZSB3ZSBjYW4gb3B0aW1pemUgdGhpcyBpbiBhIGZvbGxvdyB1cCBzZXJp
ZXMuDQoNClllcywgd2UgcHJvYmFibHkgc2hvdWxkIGJlIGFibGUgdG8gZnJlZSBzb21lIG9mIHRo
ZSBwYWdlKHMpIGRlcGVuZGluZyBvbiBob3cgbWFueSBwYWdlKHMpIGdvdCByZWNsYWltZWQgaW4g
c25wX3NldF9ybXBfc3RhdGUoKS4NCkJ1dCB0aGVzZSByZWNsYW1hdGlvbiBmYWlsdXJlcyBtYXkg
bm90IGJlIHZlcnkgY29tbW9uLCBzbyBhbnkgZmFpbHVyZSBpcyBpbmRpY2F0aXZlIG9mIGEgYmln
Z2VyIGlzc3VlLCBpdCBtaWdodCBiZSB0aGUgY2FzZSB3aGVuIHRoZXJlIGlzIGEgc2luZ2xlIHBh
Z2UgcmVjbGFtYXRpb24gZXJyb3IgaXQgbWlnaHQgaGFwcGVuIHdpdGggYWxsIHRoZSBzdWJzZXF1
ZW50DQpwYWdlcyBhbmQgc28gZm9sbG93IGEgc2ltcGxlIHJlY292ZXJ5IHByb2NlZHVyZSwgdGhl
biBoYW5kbGluZyBhIG1vcmUgY29tcGxleCByZWNvdmVyeSBmb3IgYSBjaHVuayBvZiBwYWdlcyBi
ZWluZyByZWNsYWltZWQgYW5kIGFub3RoZXIgY2h1bmsgbm90LiANCg0KVGhhbmtzLA0KQXNoaXNo
DQoNCg0KDQo=
