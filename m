Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2E5608CC
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiF2SOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 14:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiF2SOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 14:14:10 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D262F388;
        Wed, 29 Jun 2022 11:14:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YowDV8ozKBJftdUN91Z06JgYhkX/OYBRKeZEiuhHpQiWEOawfZIoOANOHm4GwJjDVJGfAQ+G6YWOupPGj6d5ex7J4qOBldYNC5YRSFRU80zrTQ4O0rrMx0IXsOCZkHTcJVOjrqAq61qwPGGGvBUSUK+s02CJcBaos+TcaoyeNcEFJ1WAHlYI5zldItOIMXPgAPMdwWidJ6EGGvV/+/TO7LbQn0CG+jrrBgQn+Ozg8Iq/KhOjkbgNQ5IFTsJWUcbRboVvio6dtUUXKKdMgzA0ZddngSIDx8I3+LgTaEILuuo5Q65/b5cuCj9OZAWqIiWQARzsYFvsvx+Sr4s9u6iP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1L8mMvX+7ycTBgkBMqN497C5vu+/J23Pf1RQSwTKIlo=;
 b=L2YLzVm2mWRK085H4QNoqy8fD/N3CLsH9EAYUnQJOY4T2TvRWwc9lmz17Zk35SxTRIsP0cs+fcMNJmm9Dq+eRFd74iTFzZsvW78eeL63jKkxv1x3/0jJtV/me1NIDBiqmbWUfz8Rv+xqBt98tacJ94VnWT0Jna24x05XbeQvOq6SqeNogtL/L860gB9yZCP6HNJjK9X05UbEycu0fFqK8SmjYpJtp4qZhY+6xpdUyOlsmC93DBjBqYg4U6RMV1s7mGmnmG4JRfimZttDPcN4YrkbvzVQpTF+IEPIBoTg3kRb1tE9Mwp0cmcYjguKUpDjr4Qr3to4sgO4LnL4fErW6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1L8mMvX+7ycTBgkBMqN497C5vu+/J23Pf1RQSwTKIlo=;
 b=GdQutGsF2xdH8nD/XY9dXThgFBkmBzn4glk9g11TCwHxHoPNu84O04HboaVKv10IyT0lVEWw8zd6shXHN2A1ClANLXZ1VeM2d8ByXl4DSGnFE2DXvCwq8NMHRihvtfJAFVRi93kkm14bBIoECNY8ZyznL8iMxRmtd+dmGJ9WMc4=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2573.namprd12.prod.outlook.com (2603:10b6:802:2b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 18:14:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 18:14:05 +0000
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
Subject: RE: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command
Thread-Topic: [PATCH Part2 v6 26/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE
 command
Thread-Index: AQHYh9dobrA/tNMTEkWfixyjU6IYYa1msGbw
Date:   Wed, 29 Jun 2022 18:14:05 +0000
Message-ID: <SN6PR12MB2767A2C2DE2AD9E4F764CAFD8EBB9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <fdf036c1e2fdf770da8238b31056206be08a7c1b.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6o2cQPAAzYK31myzBQWckUSQWVOOV2+-5VpnTym-wN7sA@mail.gmail.com>
In-Reply-To: <CAMkAt6o2cQPAAzYK31myzBQWckUSQWVOOV2+-5VpnTym-wN7sA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-29T17:45:44Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=ef421864-6c47-4782-9282-98ed775b15ea;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-29T18:14:03Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 07d01f16-d348-4eeb-8c6d-9236031b9c65
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cdf840f-76b7-4721-da07-08da59fb2731
x-ms-traffictypediagnostic: SN1PR12MB2573:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N4bRUshCTuEQtx/Du3bx4JomvphcNQrjS5x0PVQ0JcBNxEcbUOUGquq7NhsAiyKTcG8LCZcW81HOsXkayStyYeZAvFz4m8kSBAA0Ug36swx0Tz1/WdoXWzuDuYVmef0kOxgxpdue6r2Y0mpIX60Y4sAW3wx/pdxg+TAC8HtdlJ5SuzEdFS+YtfuxYSx+outWo/9Ot5b7KgUZJHnfmGU7Bg+z+GO94TldUkCdbeIZJDQBpJPwsJjF5AHYcIDAXcjnLchxzNWaJQURx5td5o+AB35p6lfDBoQsMXcI3odMdw5ZoEdvdQtOzLM+uTx9Zyq0FVu0NTIS1Sn9QTzA/XV0UM+JZVjxEquReJ7IK0gOBFqOGips2sY05kCB80Xoj6kzcea0DVsZQsuEQfzgYA4b6qfNhyZKMsdjIMGU+2Up7KZ9ZRIqDKeEJIApyy95h1UmsjDQwFt89XDJ5FoQwGt1BwftuSeNE1nkMHHYGe3pb17msxB9JExFTZ1WeIln/MZZCA+YWmfXG/foWcYVoPq6Hh86RgEdFQiwt0/PzA77vyzcj0LJ8Y/QdQ7MLPScYA5Vj7feXPRtFaM5Dr7z635jLTwFUH/9cDSCg5dAnOGnZb2n7IcSqQawuzqj82MCPsP3XMw4IyrbrRcPqTaR7vQgOf0xv8ZlXMtjg+HJnVtDspHoFlFSNY1481FdnbA9D7djpM8y8Xa19UhfzSjZj5o7tbr1lMAwNpjRvdGkB3aOp2yZCQsQOedOLicjRDCarlsdAWcnPRUzgpvpd/hOHvJ00muqZPRkAlRPohQ/P+KeKos=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(26005)(8936002)(66556008)(9686003)(66446008)(6506007)(186003)(71200400001)(76116006)(8676002)(83380400001)(41300700001)(7696005)(33656002)(86362001)(55016003)(66946007)(4326008)(38100700002)(54906003)(64756008)(38070700005)(478600001)(66476007)(6916009)(52536014)(5660300002)(7406005)(316002)(7416002)(2906002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXBVZUhSOHQydWI3allRNmVaNDdlTzArS3pXV1N6aUZ5YzVxNExIT3JmS2xS?=
 =?utf-8?B?WHdUZUczcjJwYlRvRlExa25EUTdiemlsVUkvVHQyK3hjWGtTL3N4bi9zVzZw?=
 =?utf-8?B?UHQwb24rdkw5bUQxNERFdEUvSUxsQVRVazRSemhsVTZBV21GTmFJcGRlRGNo?=
 =?utf-8?B?VVlGOTc5SU9BNjlWV1hxalYzWkh5enZnaHU2cmgvd1hsWjNQQmtPdk1EVGZI?=
 =?utf-8?B?REY2RFF0dGNDRm5GTktqMllicWVaWG45cjBSMTNzajVXb2s5MkpwQWNLdGwy?=
 =?utf-8?B?UVRXOXZoSVFXdmhUMzRhVWhrcUFEcVJHQVkyT1AxbHloRm9HK3FnNCtlN2hG?=
 =?utf-8?B?eEdzbXF3TFFNU2JSaHJEWkVTaEl5QUdyL0RzOXVuTU1wZEUyVHZ1djdtUmp2?=
 =?utf-8?B?Ujl4WmhvLzVZSEF6THFLdmdMdmF2aTZlbVBEeWYzbnJJR0JjVk5HQjhxYmZ6?=
 =?utf-8?B?Um50M2d4ODBHWG91QjdpU0VHbURYYVM0NnFkUFRmd2pZNEsrMGRTS0lnSlJ6?=
 =?utf-8?B?ZkZ5N0d3RG5SaUNiQUpVZkd0VmlZb1IzSW1ucFBnczhmVHBqM0JQQks1STNE?=
 =?utf-8?B?SXpsbDJ4UTlmMkhWUWhwR3YrUTR2eElTSnFaRlZEbFB6bEhGOTMwbU43WEFv?=
 =?utf-8?B?dU5GdFRSQ3VQcG8zU1VEUndjZE1RVFZDaTdkRUUzK0d2Rlo4ZDV5UUtwaS83?=
 =?utf-8?B?QzVIcVNOcVAzeTdkWXZWUEF6dDdUY0MzZUVPUFNteUVucGo5eTY1V2RWUjJy?=
 =?utf-8?B?WThaakxmZFhadzV4S09nWUZ3a0pzOTBTbFV6WEwxelV6MWlnTXlTQ2VVZE9z?=
 =?utf-8?B?RTZHOFpPcWlaOHpyc3NOUnl1aFFZdnkvSTNTcENwMm14cmp3WjkyM21xSVhi?=
 =?utf-8?B?MHlVNzlwSjd0WWpWdkNISXAvcktsRFVuc2IyTTRYS1NoTTY1TlpobWNpWjc1?=
 =?utf-8?B?Y08yL21FN0dUQ21GakthTDNnRUpFNzJ4MmVXN0ZYN2VKcGROSStUWEhNTnhp?=
 =?utf-8?B?d2FlL1BLWmYxMEY0MFNGM3JBZ3YvTjAzTnc0ZmxEYldpWWFlQVQzK3ozc3VU?=
 =?utf-8?B?cjE4aEFUeE1PdzIzZkorN1ExOHhRVkFmSW1rOXlnR1p6bXNQZmxkYlhGdGtv?=
 =?utf-8?B?ak85L0UwZGRzbVA5RTJwNGpBM1lkVlQrcVNGVHp2czExczdXSlFhTkhpVzBS?=
 =?utf-8?B?QXNkZmZ5R2lCSVU5YUYyVDlGU1RMZHdLSTBTaVNEdzdvRmVDUFdXQ3liR3Bs?=
 =?utf-8?B?REpBSVA4aWdxT1Zrd0V2R2JUQnlTVWYzZzcrUDdaS2RtUXlPNlVGclRYQ083?=
 =?utf-8?B?QW4xQXF3SzlMbWhicmQrMVBlc2tQS0RDWEpVcGZDRDFDd3F3NkdhMy9SK1Zj?=
 =?utf-8?B?TklvWmhPUmk1YlU1VUlzb2lTSUp3T2hjV0NIaFNldEt0V0NheG1wMWJ3WGNr?=
 =?utf-8?B?Y3IvSVVuTEhTMUdHZ0Z6VzdZb0Z4dkJVL3VoSXV2c0VLaDBHNVVLZkFxbHZt?=
 =?utf-8?B?dnhNZit6UmhiV1NoeWxvMnBCRWFocW5XMWdVdVl5ay8wem1xdEZad010TXJC?=
 =?utf-8?B?Y2FhMUhuU0xuVEJRY1N2cHIyVUJBV0ZTR2V6NkJVZmJEaEl4TFdWVXlyamdm?=
 =?utf-8?B?Z0cyVmNTUjArUmx2MFJaNzlXbW83OEpWTno4SFd1SWFlaHlIbHMyd0Z4UEVQ?=
 =?utf-8?B?RjdwdTdzNXNnTFJRWStLYVd4ZHpNY0xRdDZ0L1NtZ1pvekFiRmE1czN0UzZK?=
 =?utf-8?B?RjkrN01qMW5SdGRVZnZlcUJ4M01Rc1FjMVBNSlNXaUlwVlJLc21mZGs5RGFM?=
 =?utf-8?B?N3dyQlFnZXZDRDZkeWFiTWQxNjJLUi95VVhpWURjK1VsVXQrYmxsWnBYRHI5?=
 =?utf-8?B?WjZTTndQZE9Lbm5ROXExcjBIK2hrRG0zcWlPcmZDWDc1eUtFN1R5MnpJak56?=
 =?utf-8?B?RWNEVmRFL2RCeU1vSmRpZ0l2d3lLcjlhMUNMa0lCdVVXcW4wMWRXTDdPcHMr?=
 =?utf-8?B?ZFdpREhFWXRLUC9oSGJnWmZzOHhBS1Z0aDJmMFJ0Q1F3SzQzZHVJOXhjb1dB?=
 =?utf-8?B?SGtJWk1hWk1XM3QveVBueG1qYXFsV2M3SE1mcjhpeVNmY0EzUmVVT3VBdW84?=
 =?utf-8?Q?JLqg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdf840f-76b7-4721-da07-08da59fb2731
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 18:14:05.4963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZOqQL2NJgbNurzZ6uAdNMBTvvQ7iJHtnbv9GO+x+NR/DWZUWAJ6h28koEL0D/wdtsm+mCMj83J9Yg1WOw+ptA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2573
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W1B1YmxpY10NCg0KPj4gK3N0YXRpYyBpbmxpbmUgdm9pZCBzbnBfbGVha19wYWdlcyh1NjQgcGZu
LCBlbnVtIHBnX2xldmVsIGxldmVsKSB7DQo+PiArICAgICAgIHVuc2lnbmVkIGludCBucGFnZXMg
PSBwYWdlX2xldmVsX3NpemUobGV2ZWwpID4+IFBBR0VfU0hJRlQ7DQo+PiArDQo+PiArICAgICAg
IFdBUk4oMSwgInBzYyBmYWlsZWQgcGZuIDB4JWxseCBwYWdlcyAlZCAobGVha2luZylcbiIsIHBm
biwgDQo+PiArIG5wYWdlcyk7DQo+PiArDQo+PiArICAgICAgIHdoaWxlIChucGFnZXMpIHsNCj4+
ICsgICAgICAgICAgICAgICBtZW1vcnlfZmFpbHVyZShwZm4sIDApOw0KPj4gKyAgICAgICAgICAg
ICAgIGR1bXBfcm1wZW50cnkocGZuKTsNCj4+ICsgICAgICAgICAgICAgICBucGFnZXMtLTsNCj4+
ICsgICAgICAgICAgICAgICBwZm4rKzsNCj4+ICsgICAgICAgfQ0KPj4gK30NCg0KPlNob3VsZCB0
aGlzIGJlIGRlZHVwbGljYXRlZCB3aXRoIHRoZSBzbnBfbGVha19wYWdlcygpIGluICJjcnlwdG86
IGNjcDoNCj5IYW5kbGUgdGhlIGxlZ2FjeSBUTVIgYWxsb2NhdGlvbiB3aGVuIFNOUCBpcyBlbmFi
bGVkIiA/DQoNClllcywgcHJvYmFibHkgc2hvdWxkLg0KDQo+PiArc3RhdGljIGJvb2wgaXNfaHZh
X3JlZ2lzdGVyZWQoc3RydWN0IGt2bSAqa3ZtLCBodmFfdCBodmEsIHNpemVfdCBsZW4pIA0KPj4g
K3sNCj4+ICsgICAgICAgc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0oa3Zt
KS0+c2V2X2luZm87DQo+PiArICAgICAgIHN0cnVjdCBsaXN0X2hlYWQgKmhlYWQgPSAmc2V2LT5y
ZWdpb25zX2xpc3Q7DQo+PiArICAgICAgIHN0cnVjdCBlbmNfcmVnaW9uICppOw0KPj4gKw0KPj4g
KyAgICAgICBsb2NrZGVwX2Fzc2VydF9oZWxkKCZrdm0tPmxvY2spOw0KPj4gKw0KPj4gKyAgICAg
ICBsaXN0X2Zvcl9lYWNoX2VudHJ5KGksIGhlYWQsIGxpc3QpIHsNCj4+ICsgICAgICAgICAgICAg
ICB1NjQgc3RhcnQgPSBpLT51YWRkcjsNCj4+ICsgICAgICAgICAgICAgICB1NjQgZW5kID0gc3Rh
cnQgKyBpLT5zaXplOw0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgIGlmIChzdGFydCA8PSBodmEg
JiYgZW5kID49IChodmEgKyBsZW4pKQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJu
IHRydWU7DQo+PiArICAgICAgIH0NCg0KPkdpdmVuIHRoYXQgdXNlcnNhcGNlIGNvdWxkIGxvYWQg
c2V2LT5yZWdpb25zX2xpc3Qgd2l0aCBhbnkgIyBvZiBhbnkgc2l6ZWQgcmVnaW9ucy4gU2hvdWxk
IHdlIGFkZCBhICBjb25kX3Jlc2NoZWQoKSBsaWtlIGluIHNldl92bV9kZXN0cm95KCk/DQoNCkFj
dHVhbGx5LCBpc19odmFfcmVnaXN0ZXJlZCgpIGlzIGFsc28gY2FsbGVkIGZyb20gUFNDIGhhbmRs
ZXIgd2l0aCBrdm0tPmxvY2sgbXV0ZXggaGVsZC4gRXZlbiB0aG91Z2ggaXQgaXMgYSBtdXRleCwg
SSBhbSBub3QgcmVhbGx5IHN1cmUgaWYNCml0IGlzIGEgZ29vZCBpZGVhIHRvIGRvIGNvbmRfcmVz
Y2hlZCgpIHdpdGggdGhlIGt2bS0+bG9jayBtdXRleCBoZWxkID8NCg0KPj4gK2VfdW5waW46DQo+
PiArICAgICAgIC8qIENvbnRlbnQgb2YgbWVtb3J5IGlzIHVwZGF0ZWQsIG1hcmsgcGFnZXMgZGly
dHkgKi8NCj4+ICsgICAgICAgZm9yIChpID0gMDsgaSA8IG47IGkrKykgew0KDQo+U2luY2UgfG58
IGlzIG5vdCBvbmx5IGEgbG9vcCB2YXJpYWJsZSBidXQgYWN0dWFsbHkgY2FycmllcyB0aGUgbnVt
YmVyIG9mIHByaXZhdGUgcGFnZXMgb3ZlciB0byBlX3VucGluIGNhbiB3ZSB1c2UgYSBtb3JlIGRl
c2NyaXB0aXZlIG5hbWU/DQo+SG93IGFib3V0IHNvbWV0aGluZyBsaWtlICducHJpdmF0ZV9wYWdl
cyc/DQoNClllcy4NCg0KVGhhbmtzLA0KQXNoaXNoDQo=
