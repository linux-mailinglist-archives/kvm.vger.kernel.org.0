Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DAF571C89
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 16:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiGLO3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 10:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGLO3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 10:29:21 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BDAC7F;
        Tue, 12 Jul 2022 07:29:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiFfJ5uZ4Z5yzIH+GPVKxgVGCY0VtQylHF41m8ebGK5rP4vU+2HEERDx0J1BLNOroG09Bm6z5EFIM6lfDVAZqQwKZTxHwmgcmXLYMt+AAvC5IAMP+1TsbObzzhgcmEJ0Cbd9UA7Tr9tyH1/tRQfF4eWb/adupNvTQ3uCghDQsBU2p9gVYbvnIi5iQAMehwaDVVav3nyjfB0ivYvt53w6tXvjMVlTvxU513liK+ANQnB6R7XExOyGItQXda38nbd10gbAGN3DAidCSO/PVIoSPN9xqlGbf2auepC1jgZENvAu+u6ymKV73AeUS0rvGA+YnrmVZbIWTSJfE008LAFBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7p/Xda1Fg8G6xZQPw0gRIGnCBKePBQWpRTxy73vWBI=;
 b=G3IhC9NRETmb0Q2IOzH6mBtLULA3dYHVF/hQBxOfSC311SrsOL1rHe3nVfX1ojUSn0VJ7EFM5IkiujgIFCQaAwnd4BRPer4u2kxZ5GcKJMMzpY2fTrTwBmPefV7gOcw3e+HmFr2zOPGTm0Y4HeC3id/04jsEECed+ET9fl/qA6j2uJSTV0HU4Q+ua86cUP4QNwRIW+RqQ+pzCkAJ+GhsIm62OBS8sNI17huIRK/TdBX8RW3Opqx1kKmx7XzWv3MUtGp1x8Qmpl5QMQhp90f1R2+ADHqpG8gUZfbtquJC/cs8pEm0IqETjMhB/aPpgaA/FYvZ7Iyv4oUdI10lvliM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7p/Xda1Fg8G6xZQPw0gRIGnCBKePBQWpRTxy73vWBI=;
 b=PBg4Wf17E35UMBiiq1nhEDLRo8acBIStsutSR8lJf43CTGIexe8S6j/GTA97bwq7u8Qxi3D8BJ2M8FRT3SSqQ639u1VG1FAHW3ArHs/XPfMJJO0+Ux0pUSnuQ4VmcCyK7WtG9osunQHdpL4ZrqOLvRymeZIQpsBhUKkHiSUa/hg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Tue, 12 Jul
 2022 14:29:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 14:29:18 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
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
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYleaS30zm/ve2UUW13wSedLDd3a16xpjA
Date:   Tue, 12 Jul 2022 14:29:18 +0000
Message-ID: <SN6PR12MB27676FD80E6B20D6B8459EC28E869@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <Ys1hrq+vFbxRJbra@kernel.org>
In-Reply-To: <Ys1hrq+vFbxRJbra@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-12T14:10:54Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=96d1eca0-a910-43da-bcf9-40cd89542c73;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-12T14:29:16Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: dcba19ae-c1b4-4994-9def-f0e52b00c1f7
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43233e12-bf9d-4309-4cd6-08da6412e780
x-ms-traffictypediagnostic: DM6PR12MB5549:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CBwzz9W1mkKDGoJK4OYW51rKTDYxGMM0IbUF/3Znm/qwqJP75YybxTVtnOLQdpkOSqoXUgKRF73KGTpcpOYQmez9TlbKUFpmFB+PiPH7Xtkm52NQsJX1E7WhEjqlCVN+Q2+AElq95yMitoUEdNW6hvojmtdpzPt8AzbMmY65MpiynWapF5fqUmB7Ii84I5zJP5JWyeM2/NwM+EwmNg5oItN5qxjykf+syX269XP1FbDb4Aoqah0lqKBiGAaAtCj5GhzesCgHyrS8vUWaw+INchVMvl1z34Hme9uP/oaqYYAX+8yqhzgXk3Ks7vPpDPzHKUZLlhc+CdNV6rMuOv6uksJHMcyeF2mW/wcrwowDm4bUzQAQyia3FsgoADRIHjfTVbQIWYbJpDwtDWxlDu7tlrOElROWwO/yxp4eMWNrVsiaTqO4s5tm4UzSVJF+0Jy0uLHkJ89aP2c5oZuDTrv1qRyiSe6lmZNsdgJGmclr60xefOJmM3JQP0xCc9yxHPr3DdCYOBVRfcgKLP0r6m6/pT26m4z4QaAQneO5Ukb/MfKzkhihhMYhfOMuKkqjh3+GO0HBg+PyyaHPpwfn4szj4XIPGtsh5aSwkbajTcAhzNVv2P4feRlM5iHYJeqEhEqz04PDSt4P+J4znmgT8wS5KN2RFT654FxMD5L//yPyhWEJoLT2F6QrKSnDI0ek8GC2SBKzZFLCdbsQhGCFtx2IB5FACG33HinUKTvD9OoFgus53SA3Tpg6IqZPUTAfcETeZdR1NI1Ju5X5EqBHK1rZ3E/uh57RJE/7xyyTQwF3+bIY8KeHdBzYzC14fcRRWO9qwGlj6ES++ZfGGBzka+RETQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(66476007)(66446008)(8676002)(66556008)(64756008)(66946007)(38070700005)(71200400001)(45080400002)(186003)(83380400001)(966005)(4326008)(478600001)(76116006)(316002)(41300700001)(122000001)(54906003)(7696005)(6506007)(6916009)(26005)(86362001)(33656002)(55016003)(5660300002)(2906002)(9686003)(38100700002)(7406005)(52536014)(8936002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ei/J4p38OCUDjfBGnSpXj+B2jI+WAC+Yb7JPZX9DFfseDUcE2+j4TApMOotW?=
 =?us-ascii?Q?KhySr+1i4n61vuEvIZE5nzHzADJs/5nh1w7QaYNjK0WAUou/GmZTbgboLA1k?=
 =?us-ascii?Q?4xvZcmhGFkzctkI0g/AiyXf9zQAaeWqNg+tv+oBbwXG34XoCqkDm1uu3cuRO?=
 =?us-ascii?Q?+hT97457WaUecCjPt0zarGriNpNsN9HrEHJVMhQQzpS9zNzjotTfYgQbmnHH?=
 =?us-ascii?Q?iL/CbQ49IxlRb21jmR209QCKFr4Z3aPITlrS6PobvbeulCIMxnkDSJZ1wiGQ?=
 =?us-ascii?Q?/HULZec2V0ZJW+aioOZODBc1e1tgW8ZbLhEZAJSO18MtCAPfPgS/1StWShpR?=
 =?us-ascii?Q?XtyKRAzAOe5mndyuDNxVvfRHNGfJmEVnl7M07fRk84jo6Z0ISNL1agwwSfoZ?=
 =?us-ascii?Q?J56tSZeOE46XRnOayLppb5NZY61fm9By0ZtnKksSlJecrJ/GZq6A11bkBOFc?=
 =?us-ascii?Q?6D/9DuQVrX5ZWixI6Db7FZwHtpyPyXtcO5p0mJK5Q1p6MKIs6jU0KLEfxMlG?=
 =?us-ascii?Q?7S3qDC2yextAx3MU4tRemY0+9eFI+xlUjmVR5n9bon2fIYxAg+Eci97eD53r?=
 =?us-ascii?Q?tKO/q25WeJN1vM/SB46JUlSKrU1l/4dZC7iTgoDBODuQjVZ/kK6CkpuX75EF?=
 =?us-ascii?Q?Ce/n3Qvx4gy2k7NQd9p9IQ5ONr4prM5bsnuvr1ARqxhZZMOuBoYNL+iRj8Mk?=
 =?us-ascii?Q?XcXQC940ZHpsY08aF0LalIKTfSg/7WZPY8aHjUY1aArjcrSOVxNLL9xrhz6U?=
 =?us-ascii?Q?JdeFM/VWukHohCycH70Bpz7kJtNclw7MIY9F2P/+XH8PYbHbbicDmPFTydMM?=
 =?us-ascii?Q?bY4f0fuY0Sra/JjgdGiSZhKO/WvI/RQPc8t2PLMJI6Yq3m2KPcVaxidxXB3t?=
 =?us-ascii?Q?jn1slbJ97i5U1ckvVeX1/39v9Dv+12OUgZ5nKVtb0GGcvkVt1LrBdjyewCdN?=
 =?us-ascii?Q?yh7uoKKgFZwwZ/avFVunG8SF7zIXiohXU/l5Jn9dr4dQrq6r1WHoydFpkoUu?=
 =?us-ascii?Q?V04/mFYwRN3JRaKHTsuMDb3pBnC7gued0WJbahSufos5z0psoFB9gvywspGJ?=
 =?us-ascii?Q?5Do2m9IxXYoYRxiVrZ/d5FfhIdKnvMOtdv1/sVBmoGixgZNdvghutGroM8b3?=
 =?us-ascii?Q?tOoIPuH69bWrvgnotdYIccx6af4FVlSMJ1DGORQA2reT+SN5qhqa6s0g/AV2?=
 =?us-ascii?Q?bDwaCZWiS+BG/zACVmUqXbkvJwAkankXR5T4tI7QIwrb479pjBUMVuX26141?=
 =?us-ascii?Q?7ptLo17qtWHjd3AzMvpKUFyNR+KSRGGdlJrG41p7IbJPkO4kWbkZ28C8wtrU?=
 =?us-ascii?Q?WQ8F4PFmkVmlZ0T+3YzAeamtcfr5GJtFy5000qnCwXSxm7Z0ZMfAoBhWSdl4?=
 =?us-ascii?Q?bniX+t6vAWQWlrXmReVXKg87hB8rd1+ud+xvBbBjlsChgG9pRFDixZssa2++?=
 =?us-ascii?Q?Kl6LNXk6cy0u1YZsvSKf9w8fky6SExss+U0nirYyVQfjmN4RKADLZK1pRBHT?=
 =?us-ascii?Q?69geZ/x+/gstufLrUNMNbCWjXS3WJrttrHwwSlFF8IUCSa6Azn8D6UIHf3/h?=
 =?us-ascii?Q?DZ3BhDyEVTqo+/huaBU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43233e12-bf9d-4309-4cd6-08da6412e780
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 14:29:18.2011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vkgqBLw3sKwmPZfLuF/OXABhUazoRT5puaZI+lOLzYh9Zi4ATIuzHxZsSAHHsDfBo0SQ0JJ/hH/9I8D4XT5fbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
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

>> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned lo=
ng error_code,
>> +				      unsigned long address)
>> +{
>> +	int rmp_level, level;
>> +	pte_t *pte;
>> +	u64 pfn;
>> +
>> +	pte =3D lookup_address_in_mm(current->mm, address, &level);

>As discussed in [1], the lookup should be done in kvm->mm, along the lines=
 of host_pfn_mapping_level().

With lookup_address_in_mm() now removed in 5.19, this is now using lookup_a=
ddress_in_pgd() though still using non init-mm, and as mentioned here in [1=
], it makes sense to
not use lookup_address_in_pgd() as it does not play nice with userspace map=
pings, e.g. doesn't disable IRQs to block TLB shootdowns and doesn't use RE=
AD_ONCE()
to ensure an upper level entry isn't converted to a huge page between check=
ing the PAGE_SIZE bit and grabbing the address of the next level down.

But is KVM going to provide its own variant of lookup_address_in_pgd() that=
 is safe for use with user addresses, i.e., a generic version of lookup_add=
ress() on kvm->mm or we need to
duplicate page table walking code of host_pfn_mapping_level() ?

Thanks,
Ashish

>[1] https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flo=
re.kernel.org%2Fkvm%2FYmwIi3bXr%252F1yhYV%252F%40google.com%2F&amp;data=3D0=
5%7C01%7CAshish.Kalra%40amd.com%>7Ce300014162fc4d8b452708da63fdb970%7C3dd89=
61fe4884e608e11a82d994e183d%7C0%7C0%7C637932238689925974%7CUnknown%7CTWFpbG=
Zsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C=
3000%>7C%7C%7C&amp;sdata=3DGxPrEUxuVNEm6COdfHCILOwp9yuX48gpoYmtrOwMx8Q%3D&a=
mp;reserved=3D0=20
