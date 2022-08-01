Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A655873F2
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 00:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiHAWbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 18:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiHAWba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 18:31:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA651137;
        Mon,  1 Aug 2022 15:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kd4u44E1uD0WjF9wsZHVD+LB6A0ZYfrDQ86uWMIj+rlQUTrdXZT8wkk8L73NZsIOgCegJRwB/ov/dWq//tfBAofW92iDQEpjxGaLvo3QUURMni9cZzVREUxsSZUQn+dd7L+RBgctCDWEiiSQsHE3pLHugasOimgeCT+xCdnyh1ZfP5WmAlMXrRpaNCUsNhddp1Ng7jAjen2G7l9e+I1sLcGkrPxYG+oNYX/2q1FtpDMkZr7XoF5N6/UeFi5dgfEQptSOY9RiIYJ6vXxVXcHKiYg1U6Gd0XTQ7jZOgNj+Jm9hGLm2cU0JRHSegzYlN8oNHZcK+wNwQPeN3VnEGahmnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWSGKpvGkFcO/0jvufZiFG2ETT12MwGKKKv4QDJq7n0=;
 b=eYWsRO8ue/bQyjTx6doZ/cy00d3tWrEydeIJKi7YsrhafN9LQhvIYC3KuAXKrnDpPGtO49hRpo/TcocVWHQbwOVgQjrejEVc+fIll5Bly5dq7YUalhodrAjHR5046NDB5jCyTyPQ1Rtu4pvTZKqFq8KkjP2YB/P4kAdZDRZSstLp3DWYh5FNgQGkcyq8VvaqsHcp+VUyFk+HyJmBM19/Fv8GCzEjkWE6PRnF/sd/GMNJtkSzZTS6wUyELWJf287fgjifbqnW49bZyJhLe33xdSPn01SPWaiiH4Gx96OKnTMsnOQfpIvgR1kIKxfWp5Rkxu9CW5ZqxLBsMXaOxAGfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWSGKpvGkFcO/0jvufZiFG2ETT12MwGKKKv4QDJq7n0=;
 b=JTE/A1NEBKB3uDNMxYtWfJa6XndmDbUlCIKaxw3nxuA6R543K8I+Do8+qzANQZYnOSMqRR8uoeQBK2yGbDy0thw+ASPt43a0pO3B+Nc/YbRS/yQNv2n0A8Rw52J2WRgkAwDqK2mNA2+1G8EKGWKitfkxVYX0vC1fAV0mgyJQlNk=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CY4PR1201MB0024.namprd12.prod.outlook.com (2603:10b6:910:1b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Mon, 1 Aug
 2022 22:31:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 22:31:27 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
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
        "tobin@ibm.com" <tobin@ibm.com>,
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
Thread-Index: AQHYoDP+ulHh/HmbIUq97K70l/FApa2aqV5g
Date:   Mon, 1 Aug 2022 22:31:26 +0000
Message-ID: <SN6PR12MB2767A5C613388594D7EAD3528E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <Yt6qit4al5/eM7YO@zn.tnic>
In-Reply-To: <Yt6qit4al5/eM7YO@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T22:20:21Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=b0f0cfce-9c30-4490-bf8a-ba7bd4d8db07;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T22:31:25Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: e8caff76-2f36-4003-be50-79ad439eec77
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76e7d27c-0287-48fa-8aca-08da740d92a5
x-ms-traffictypediagnostic: CY4PR1201MB0024:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qoTTJiTYrES1fpwEGwyfUKDPnaDyfiOaYpcyNslXIA1QafYaJvaXCXUuVqeSgICvBBrHd5sCeLB7934dAoCIR0jyHFaw77/jFpIoSKQTxuv+00wKJTy2sq38UrJ/9l/CrOAp9Lrc5XCJv2g2RPpkQbemrRtJRgduSegsthHECj1mkNutCc3IfJy7cOVI28Tk2ayyTcJW62toWF33d9y6R6DPcuNeEG/Ga1sU2jqLO0D0ft0rjSwXuKHQscFIG8GUSt/z4lvPvX96cqqZGapR4Qa0Jz2gLQHX9SQupG0SnKrYL0iSWqs1MS3dzje3Juv/OaApWmz26577hC8fr7YrgpDqSNqGtVlaHQ09jxWnp83BYl3DaIOJ2FyTEs8jXmr+KZJh+uuWQevsu9gquRW84zUn8KTGqybIG8LWIzCm6N2fEGU7oJZDbyTXzhpPJvwnVxu1kGDgeQltqgF5poIw7S9BDrtwK5jIslF+CPx/ZCqHP3w/i9kBjD+lGuvWePMWjYa4qNa70l+K0XTF6EEQsRde4MCXRiELmXfgrGwtYidbJydvgblj7TdvI01oscueWd47UhsMNf2p1JP7ec7Gs+0JhOePXSNF4Y0DtCG8dlkr3tVQvWjIv66DAu3CPNa7vK7UldR6+RfgVmZAnG3ohDjQgQMrakImKr/6Paa2P9ibZVmatKYHe7EBk5ZL5Viq7k/ZJiL7EhJeNh87dj05Ka3Vhrl5MNF7IGvnHlX1alB21DVw24cWWfNNvHkVa4e7vC5H/Ux1HujaGdsIRvXnPKXczQkk71slVQlP+W9Cmv0egTI87/7iImX8u5LvIT9H
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(4744005)(66446008)(55016003)(66946007)(2906002)(5660300002)(7406005)(33656002)(7416002)(66476007)(76116006)(8936002)(8676002)(64756008)(66556008)(4326008)(54906003)(41300700001)(316002)(6916009)(6506007)(7696005)(71200400001)(478600001)(38100700002)(122000001)(38070700005)(9686003)(86362001)(26005)(83380400001)(186003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XZAbQO5vVfnBHLUnVfWxV4YiMpjtWez84W/6HX2SsxxOBiM2KkwISHwKDTF6?=
 =?us-ascii?Q?4lfXvW+bSPewuM8ImsBl+VyGx2Vx+04+HFIqjOGwMu78FVnn3EoFTFMHPVIB?=
 =?us-ascii?Q?6t6XavQ+DYu60E5fOxetaKht5xeW568NnjyIXMpZhXDSh0jSyqTeYW4ScC+H?=
 =?us-ascii?Q?PfJumzO3F2kvZTC4l8P3KKXyU3epOV618r3izED9JDOUm+v48TUbvLtW+XBU?=
 =?us-ascii?Q?1i2B9+R14pUEBhbzgar2RPGEF7zFiCtWRLYwi8Kovj0h98CpYYBSxPnD9W75?=
 =?us-ascii?Q?IKGSXlhK7hRkA2obkB+BblYZdBS1bZtvzRf/OgFt6Iv7HF0d8VQEREsXe51U?=
 =?us-ascii?Q?2QtCVIq6ArHWnQVurekeNJGnm6VXtmGPJgDdfj95JRqEAeSma5p3V+LldwmE?=
 =?us-ascii?Q?ovWju+fT0aPaBIyMJ+20buAfi272J4PaDneNiUeLJ9GxF5mBEAglM3cBbNjM?=
 =?us-ascii?Q?7vc2TLyHEw2D6obTiCRoxOY3CT676JqKntszmWkxJxwp9LHFpkDrcQnDFBSn?=
 =?us-ascii?Q?zfNjPTRFoHjCFXWMQ4DCaSQ+K00JnEnRv/C25BLaL60r9mlfstSSSM0k4NoR?=
 =?us-ascii?Q?7Zq2xa7iGquzR2Ae3wFFd5REdyhRnP1o2ySzFisnj/8BHu80Gc1J0GAo3sR9?=
 =?us-ascii?Q?fLDNm5Kglxb3UWkat2R0nTAJ7VHn3q/abyCsq0ECDXAyVwil1ODuz92IEdsr?=
 =?us-ascii?Q?244bqiMxmQKYoXlsr3L4pYYL/VY1ukFC0HhevrRFpET28QmnOy6ATlKarOwH?=
 =?us-ascii?Q?tO8kElCu6cHwoeLeo/NVZ7qLdbWm3uSWwKkXpwIDpNSZW241PayxJBC3mo0q?=
 =?us-ascii?Q?w7uNfxNeRDA94+F/UU1wn4ZJTT/Ki/vtkbR5Xg3Po0xWLdPWS90lKZ+VwyXn?=
 =?us-ascii?Q?gk6WuKEYKt0rwMurVO6pV5RadtNj/q7h4Sy48YySSE3bVNdPiNAAFEmxClHU?=
 =?us-ascii?Q?3vGnLaVKRKZnTKymD1Ixp3wZaVEUv4tHV+pS127Vp9fVC3RiMtkdzldGrTRs?=
 =?us-ascii?Q?Ubc/PGGmbSnMuP9TDzU8b4leT/0uusPW1zUadoo3Bv2pbObB09YCGl3gNcCj?=
 =?us-ascii?Q?aHB54j0ntXrSVtFjzWFs+lmASN/W7RIpiqqkTGx8JdV6ax4nRGXB0dL4DN4Z?=
 =?us-ascii?Q?LbtXXkVFKUjAygkXyEgRzvTP1IuJ/td3s2RAFHg6itzed3HKJWTRF584hfqX?=
 =?us-ascii?Q?XzyBEjGlccwfApygp62u9MgrFXDyxnno41J3X4coL+aZykkEZh+qoGQYYrky?=
 =?us-ascii?Q?UiNFislVpo/nPWl4c5p/5yfyy2YQeO9CK1cFriH2hxQ9rEYaJcWT28O8QduM?=
 =?us-ascii?Q?aSzfXty5kGta/CdY9yBflFNidnOur5a2UoQB6pkAKzG7yiO5a8LSp8dXzDgP?=
 =?us-ascii?Q?DFe5u204qQyeFIcODH64TZtkDSKA+Qk85d5m+cUBVh/a7jc4U+pugzi4uWeF?=
 =?us-ascii?Q?PkythWzKU0Zr+y7VeP+u/CRc8znnlC9/lbcTH3vSfwgIP0HtcpXcs+8heoJO?=
 =?us-ascii?Q?aCkF9Qd8B936fL/X095zPh9Efb9zAmcEvXKJRxDBdaIahOQLVUxkI8m5/c1f?=
 =?us-ascii?Q?YmVESNjBagQoX7RBa1I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e7d27c-0287-48fa-8aca-08da740d92a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 22:31:26.9909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kNBGlzOJSUmuE/WK2f9nHncKTMOSTyudGC9uy5vZ0NTnvZtqH+nkhY6IhbU8c9lSlIxFQutqH+kyIN+bhwv/6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0024
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hello Boris,

>> +struct rmpupdate {

Why is there a struct rmpupdate *and* a struct rmpentry?!

The struct rmpentry is the raw layout of the RMP table entry while struct r=
mpupdate is the structure
expected by the rmpupdate instruction for programming the RMP table entries=
.

Arguably, we can program a struct rmpupdate internally from a struct rmpent=
ry.

But we will still need struct rmpupdate for issuing the rmpupdate instructi=
on, so it is probably cleaner
to keep it this way, as it only has two main callers - rmp_make_private() a=
nd rmp_make_shared(). =09

Also due to non-architectural aspect of struct rmpentry, the above function=
s may need to be modified
If there are changes in struct rmpentry, while struct rmpupdate remains con=
sistent and persistent.=20
=20
>One should be enough.

>> +	u64 gpa;
>> +	u8 assigned;
>> +	u8 pagesize;
>> +	u8 immutable;
>> +	u8 rsvd;
>> +	u32 asid;
>> +} __packed;
>> +

Thanks,
Ashish
