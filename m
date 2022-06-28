Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE5955EB8D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 19:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiF1R5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 13:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiF1R5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 13:57:46 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B140B64FC;
        Tue, 28 Jun 2022 10:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ep5l1oq1yhBb+WU7NDLuGlv4aCwUVX/ODIGkv6/CDDqUq/mVOaddDrhfDGnhazuVoEIc9r6iD48Uru0Z6s4A4n8URC4n9GBxqKzAYMU+7jskxIAp2AzvrXWMV/uyyjzp96tRx9SulceWlgw2hvgoxi4PRAdGt5k157LaP0Gl1/xFX7yF4vnvYUHimmppVcUcnjkFfdI8/A01VHnGym82XFTQBSnLLszPLJyxGj2oCDcaC0uzhIF6ST7Ir7wx8eX3jT5vKbSWWuaC75ocbR60crkc80u/7R/IBJcsmsO7jorDtbEbz5rzlbXBL05SRIhb9emgfQkZ3rrSbsu7O6+u5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfjK6teZjOc6AUQwfjsBUHZ+3rTSF4jj8qciTFjfqjk=;
 b=kax9MbYMjvDWHoVUdirxhkoSOoKK/kXlf0r6nRutD0LHcn3/rboyI5gqCEhwU6sg0C7unrmPWqEU8svcf+y+nnTQdM/rE2u5+pSqYb1F5qemk474hujUaEbcJiPkU0fVBXiHEvJMIA52cbU92RubEfYR9K4u+ukdDaJlI8mjY7rILWbMaSZsStySTpi6awfQu1ppbdHV6qRnZt+CgfApoe+IHelzB1n9bqfHtmIUCwLXjlzjneCgi2Tl991lKd3zJvTCPPkEEEAYNrdDSrbrNye+J2qN2pFCKdKwX+DPkIUZNLoqq+dEx9klRROzMrcm67xR96RGkKKHA//A27U8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfjK6teZjOc6AUQwfjsBUHZ+3rTSF4jj8qciTFjfqjk=;
 b=V6Zxhd6Zvh4fbEytDmBMP15JolIO2tfnMVzzr54o6ciC9w5LskIYgC1W203zU7PfI26cLVxIuMDz/a68hsMy5SeQxApafQw+2cvRsWIBF4P05qkI9wlayQoalWLiQuxjuYrQlJtKTreOLMOmGuSJbIzw2f9lwprj+HaBdT8pml0=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BYAPR12MB4792.namprd12.prod.outlook.com (2603:10b6:a03:108::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 28 Jun
 2022 17:57:42 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5373.022; Tue, 28 Jun 2022
 17:57:41 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
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
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Topic: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Index: AQHYhY2kulHh/HmbIUq97K70l/FApa1aH19QgAGdtQCACPGfgIAAdLzQ
Date:   Tue, 28 Jun 2022 17:57:41 +0000
Message-ID: <SN6PR12MB27677062FBBF9D62C7BF41D88EB89@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <YrH0ca3Sam7Ru11c@work-vm>
 <SN6PR12MB2767FBF0848B906B9F0284D28EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
 <BYAPR12MB2759910E715C69D1027CCE678EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <Yrrc/6x70wa14c5t@work-vm>
In-Reply-To: <Yrrc/6x70wa14c5t@work-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-28T17:48:27Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=46f29bd8-1585-495e-83b5-e58dfb002f98;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-28T17:57:39Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: e25f21d7-47a8-4fea-8c79-95c19848ca4a
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7b99f7f-9c92-46f3-92d3-08da592fb27f
x-ms-traffictypediagnostic: BYAPR12MB4792:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: peOWbw5o7QIaJ10c592rrpvQ82aInVzTe63b42ELDVlb4isRlARpTXvTVmq8q7PQpSvLDVXfTID4utTcaDblqjFdnk1PPBb5fC/FMfr6JXBvZvcMtxSD3tioEd/MTTMnGKIZ0RbLYJe6gLXgsXq+ztVZy6b+GhCRO/UyMJjqJfrvZUkO1ZoTNxdGHMV3gK6Kl9UjXzZlAi2dwPmoF1T4/hnvhpkBVBIWaacrmmBcJ2u8MkKzoa36Zcq1KDCabPNZ4a8EldrTlYoRyf8+m5Rq4lAR7fLX3zRT3KR9ztNI6jeLhq/NzmQ8OB7P3LgV4x/Sg7MPKx6QTaA8obd6Cu77MArZSjgFJqca/81W7cqYMsmj/B/TDI7RpcOAl9L+84v1T+duVRXeOr6rNkPdG343v9n3pODH+a3Q2V1T9BOkgAB7MhD4kxAxFPD0G+O99V5lJeg2RAsTrsl8p4GF/JJf+T80w45ArPXdsOxyvk8I6bH5lc0V59oKFIZdEseon3LTM+Fo5/pvI4OFkcAfcWqkSyiz3xLbKeRdzDsNTPPl1XPVi5MG0VLzapEyRSltdo5twtHAWSp/spid7oS+fqqMQ3gQeVL1UEpyGHxfvTVuVj9HKxm0lvcoXchAncnnMqBtMYVvOw5RsOSy3y0mfbF9HxOwiPrUpmQR42FzZBKC58tlVsqKe+vd2OADLFtSUtS3NmzjdWuXG1zDcpg5DUuAGXUCHw9Kcshbr0MUS9T2al7yRnn0kGZbXZ0N9eAaRdmBRW5Hm8oBgaJ3Crwuvbs9/9eJboaNJoz/c2cQOPwpsbQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(53546011)(186003)(7696005)(41300700001)(6506007)(26005)(9686003)(66556008)(66476007)(38100700002)(83380400001)(38070700005)(55016003)(122000001)(8936002)(5660300002)(7406005)(7416002)(316002)(52536014)(33656002)(2906002)(54906003)(64756008)(6916009)(4326008)(86362001)(478600001)(71200400001)(66446008)(8676002)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J3AW/VS9SEHMjjFv5TD9Z+yY27VxOlbv/BXnvDwAC75saj/TALj/DCK9/ljl?=
 =?us-ascii?Q?PDjvxBnJvunExv9/WfMwdn0LDVfAnljValAKEIsQ12rtkxHyUkvQsCh8UWTY?=
 =?us-ascii?Q?h2NpiQvQRz3NkCtD8TcDl6Fj0CeDq4PK7RPnQDefxP65sXddFOGvTUrbHyK3?=
 =?us-ascii?Q?dAkAr2ISD0iRIwnN5HGcTCJnvbWj2NBjoRBMNFElOMDoyVHJk2RIb87UXURx?=
 =?us-ascii?Q?bvofu5KR2HLzTs1do/CEaxRL5A7CDNzbgqlalCGfDcMteD+QGQsS/wky2Rsl?=
 =?us-ascii?Q?RImUfB3eap7Ncjmlg+mZs+K903/8oX2x2nbbmjUTuuDoXnaiSvFZst0P9Clm?=
 =?us-ascii?Q?oEvWnxag35wStoAnhnGm21ZBodrKfxO9dBJUVNKdo3gaSFtqrgWNb4oj+7pu?=
 =?us-ascii?Q?dGedvisbRyoQhuM8B4pn2cuVtvM+RF1/C/qO68tQVOp4WHvuW8jqyMGVYa7J?=
 =?us-ascii?Q?gNOcjZopB+hD/oEkK+9IPf36Mcw8LbHWN07hlvW6gaTqkzn9xP+6uwH/CPrL?=
 =?us-ascii?Q?D5G6UW7BQUDGcPvV8lVwi0qLS4tsso4wMdjF0nvrwGgMAX62uJipxeq0aSTy?=
 =?us-ascii?Q?OO4O+8HyNZjajlRB0/boFVhRwoXm8SMPyghwEqtsm3Mm35EvRwx+P9hPB4EH?=
 =?us-ascii?Q?YMTMRqCPMFcc9lqOdcxNuJm0XgEewLdw28vlQztRssm9mlMO9MOZ75Nn2Inl?=
 =?us-ascii?Q?OFpm0+y/YhGkSIv2OnWN6ob4/kVEqnF2buavPK1r1Am5xboTHOQQU2aVcizX?=
 =?us-ascii?Q?egQ+7lO5Nzqjix2De0xcQb5nrTWeeIeLVf+FtOgV6wH7922Y4ZrCmB+w2KQ3?=
 =?us-ascii?Q?DWawUqHsUlVqfy02KtzbiBU7E6Ow8x1HSPCLf0A+o2E9Bu8S0XS7c2woJGCX?=
 =?us-ascii?Q?23pg4r4mwq0tg3Ztq0Rtc7fOV68nCqnsC3XvjCyoatnmPwUh+BJsjQ7vgAJY?=
 =?us-ascii?Q?JLg+Bir+fHDk2Gx0Yab2yDnZ2U36K5wPNgEFm1zsAi0xeLdh3EKEnyrVqesL?=
 =?us-ascii?Q?1GaasSpwwuQqEFF2xisu0IHe3klgPKunngF4hgJ5uZaJEG0Z/vNfmMMaxTWN?=
 =?us-ascii?Q?gogZwQOVI4ksY7GuEWkdNNIN3QFWVvTYY8lMztI0kZ+4VVO/6XQVk5/mCSBh?=
 =?us-ascii?Q?x5R6kxc5hNFY7tJvZaS2KRCTHmgH3F1bd5LAg8B2xilM6dkumf2mt7zFIHn/?=
 =?us-ascii?Q?5qJZ1/1OIbiRd7vIgICrD1WzS2X8B4+rWRSIb5ZPQ5KUXWOv88MWtk5Ie5vH?=
 =?us-ascii?Q?oNbEMCZtBbnNIkHO6Gz9G/tZlWoX5zcWPl1ilMNWsnAlw8DQzSD6awe+NWqU?=
 =?us-ascii?Q?2y6ciC6pFaa5D/8/YtOMGncae/kdyleuTd36AaX11dCqrkMDAKkZXFFmcPr0?=
 =?us-ascii?Q?p0xpgTQCJ9h+uPLSucfufVJkTzKOBsgFBWXNhXp/W/1bDU/LxkuVbw2H205w?=
 =?us-ascii?Q?PiN1N3gneg+Ph6ulqIPlmEBVAsBEnI90pE+VbCCFwsVUpBCLvnjoDsWvU9DS?=
 =?us-ascii?Q?cPFT94PlDHDDdCiZbwDVXTL7O+QpFFeOs/0XufiEqbVig/FwDQcepOe5dE0r?=
 =?us-ascii?Q?Z1ZTQvIIE20xd4zmBhs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b99f7f-9c92-46f3-92d3-08da592fb27f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 17:57:41.8761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K3hJI7dQImR0CTHDiN2DG976gCqjqZcBgsjF8V8LV2PhjoEDPF/nSDJGQKV6ElA5GoOJTmE2ERXXegqf2UwgMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4792
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hello Dave,

-----Original Message-----
From: Dr. David Alan Gilbert <dgilbert@redhat.com>=20
Sent: Tuesday, June 28, 2022 5:51 AM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; linu=
x-coco@lists.linux.dev; linux-mm@kvack.org; linux-crypto@vger.kernel.org; t=
glx@linutronix.de; mingo@redhat.com; jroedel@suse.de; Lendacky, Thomas <Tho=
mas.Lendacky@amd.com>; hpa@zytor.com; ardb@kernel.org; pbonzini@redhat.com;=
 seanjc@google.com; vkuznets@redhat.com; jmattson@google.com; luto@kernel.o=
rg; dave.hansen@linux.intel.com; slp@redhat.com; pgonda@google.com; peterz@=
infradead.org; srinivas.pandruvada@linux.intel.com; rientjes@google.com; do=
vmurik@linux.ibm.com; tobin@ibm.com; bp@alien8.de; Roth, Michael <Michael.R=
oth@amd.com>; vbabka@suse.cz; kirill@shutemov.name; ak@linux.intel.com; ton=
y.luck@intel.com; marcorr@google.com; sathyanarayanan.kuppuswamy@linux.inte=
l.com; alpergun@google.com; jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for RMPUP=
DATE and PSMASH instruction

* Kalra, Ashish (Ashish.Kalra@amd.com) wrote:
> [AMD Official Use Only - General]
>=20
> >>>  /*
> >>>   * The RMP entry format is not architectural. The format is=20
> >>> defined in PPR @@ -126,6 +128,15 @@ struct snp_guest_platform_data {
> >>>  	u64 secrets_gpa;
> >>>  };
> >>> =20
> >>> +struct rmpupdate {
> >>> +	u64 gpa;
> >>> +	u8 assigned;
> >>> +	u8 pagesize;
> >>> +	u8 immutable;
> >>> +	u8 rsvd;
> >>> +	u32 asid;
> >>> +} __packed;
>=20
> >>I see above it says the RMP entry format isn't architectural; is this '=
rmpupdate' structure? If not how is this going to get handled when we have =
a couple >of SNP capable CPUs with different layouts?
>=20
> >Architectural implies that it is defined in the APM and shouldn't change=
 in such a way as to not be backward compatible.=20
> >I probably think the wording here should be architecture independent or =
more precisely platform independent.
>=20
> Some more clarity on this:=20
>=20
> Actually, the PPR for family 19h Model 01h, Rev B1 defines the RMP entry =
format as below:
>=20
> 2.1.4.2 RMP Entry Format
> Architecturally the format of RMP entries are not specified in APM. In or=
der to assist software, the following table specifies select portions of th=
e RMP entry format for this specific product. Each RMP entry is 16B in size=
 and is formatted as follows. Software should not rely on any field definit=
ions not specified in this table and the format of an RMP entry may change =
in future processors.=20
>=20
> Architectural implies that it is defined in the APM and shouldn't change =
in such a way as to not be backward compatible. So non-architectural in thi=
s context means that it is only defined in our PPR.
>=20
> So actually this RPM entry definition is platform dependent and will need=
 to be changed for different AMD processors and that change has to be handl=
ed correspondingly in the dump_rmpentry() code.=20

> You'll need a way to make that fail cleanly when run on a newer CPU with =
different layout, and a way to build kernels that can handle more than one =
layout.

Yes, I will be adding a check for CPU family/model as following :

static int __init snp_rmptable_init(void)
{
+       int family, model;

      if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
               return 0;

+       family =3D boot_cpu_data.x86;
+       model  =3D boot_cpu_data.x86_model;

+       /*
+        * RMP table entry format is not architectural and it can vary by p=
rocessor and
+        * is defined by the per-processor PPR. Restrict SNP support on the=
 known CPU
+        * model and family for which the RMP table entry format is current=
ly defined for.
+        */
+       if (family !=3D 0x19 || model > 0xaf)
+               goto nosnp;
+

This way SNP will only be enabled specifically on the platforms for which t=
his RMP entry
format is defined in those processor's PPR. This will work for Milan and Ge=
noa as of now.

Additionally as per Sean's suggestion, I will be moving the RMP structure d=
efinition to sev.c,
which will make it a private structure and not exposed to other parts of th=
e kernel.

Also in the future we will have an architectural interface to read the RMP =
table entry,
we will first check for it's availability and if not available fall back to=
 the RMP table
entry structure definition.

 Thanks,
 Ashish
