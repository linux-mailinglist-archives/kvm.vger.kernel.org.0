Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690F15BE779
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiITNqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiITNqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:46:31 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2055.outbound.protection.outlook.com [40.107.101.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197356BB0;
        Tue, 20 Sep 2022 06:46:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3g40jHK9q57xIINqbPLWzepMFJrphhkmXokYV0q8JJX84eDxzxBZPL3jsWbfJLPJgjVMPVR883Ia4LLefj6qHG8v+9Rdyr+v6dzoLHwI75F5Gpk2feVx+pMGidA/OZMKRT7xe/y0B1009B5kWFytndIVuJjB9d3xHxHcScdyEIQNIQ62unQ+5fIt2C/xg3HGJWI5UoQKA44LzxkuWTtZB6nQNrlVTgGfq+5WxKpY2PUsaI3JvDXhGwAbgS9aaqYwcbGUxcMXzpeW/+N9Ey6Y5wcWvMXsNEWFZzr+PVf/YfJaVGFjU/mZkutp4bVVle/44Uj51xyqLL4wMnO/+YKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73FCaBfII5fhDpD6TRa6T8KOvq4EsVROxzG32h6s0Y4=;
 b=A9Nz8MskC66dbbTyjrZ/w6G+1Ex1oONAgR4xBHNi7jV4JRrMM3wCi28qOUnFbz5mQSy72XlfdAIog7ZAubiPici0Nkrb6cEQj2uv9ugnIym4A6+uPVoHEW4tB1dFgXbFvEyHaHLApIo23e7Dk7WQuwyCM4Svjjj/RDVPADO5h3M0N6Z42AWKznPU6oe9hzJ8rihKKNY2bZpCX7WQgtaSZUtlkVaCqI2vxutvqhBGDgBYHWoryPHjDPx0YU04UZyH3tY+JS/GYvm1wxF0cFwrA/WbTOlBzCM+t/hV0R64ZaGjprSBh9fvEU+khmvJ//z7w8J3GX/J50fsbjxT/cCM9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73FCaBfII5fhDpD6TRa6T8KOvq4EsVROxzG32h6s0Y4=;
 b=HFSBEkGSGQFtyl+y4gyE6z7bGn0GkK3leMFJ3o+d44vH+9KryYfhTsy1Jh3ffAwS8kRV80/S15bFXcBX7jPvvnfdHQQbQSfRC5ADHYaNgwZBEvUXtIHuTYD/gmLkbjfmbRsrAOAUc1jaej0lhUIRQRrZmIVya7gV9rLhGlRXC3k=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CY5PR12MB6645.namprd12.prod.outlook.com (2603:10b6:930:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Tue, 20 Sep
 2022 13:46:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021%4]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 13:46:25 +0000
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
Subject: RE: [PATCH Part2 v6 11/49] crypto:ccp: Define the SEV-SNP commands
Thread-Topic: [PATCH Part2 v6 11/49] crypto:ccp: Define the SEV-SNP commands
Thread-Index: AQHYzPF6nAnMhnAyzEyIBLkI9xAtX63oSy3w
Date:   Tue, 20 Sep 2022 13:46:25 +0000
Message-ID: <SN6PR12MB2767213C998077DFE8D52CAE8E4C9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <f5dec307d246096768afd770d16a26be25fa28b3.1655761627.git.ashish.kalra@amd.com>
 <Yym6Ob2tPYeb0Kq1@zn.tnic>
In-Reply-To: <Yym6Ob2tPYeb0Kq1@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-20T13:11:45Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=0f747027-2dfb-4144-95fe-dc5547ab01d9;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-20T13:46:19Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 69296c3b-2c28-45c0-9598-8f66975b91f9
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2767:EE_|CY5PR12MB6645:EE_
x-ms-office365-filtering-correlation-id: d93ab987-e723-4cf2-05ac-08da9b0e8327
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UxR+Z7MpZlRmOZ0ARbY7Y9Q4KlXQc0sDpRvdIFGOXGmLwJMwBhen+zZ/LzuuMPKizxH4ghsXESmPlmvN+doNdiCb6PF6f22QUjnL6ZngPbo61ewpXDb3ydDsA1ZSfgIKgPgofdyQLmApK91q0eg8TmgFAmbXaWANMyIa2vbHxu+w9c6ElXdv7yw4JllUn3F1NWs/OxHt3ne5UafQuzl2W/T6CVDVaWJzIoNCvgj5aDs7HN6Y3EUPNkpGfFxsJotXa0folBNCmY7Bna1FWZR9zivVukI3yYVBEeTQG4vs0FuX+sGCNWH+plgSBWoiIIydmR634Z4kd1bZnpXpqha0NkgGmO5MRxGBXU8W/wyHsp8pMZHka1jnxYGu8u78kpf3Q0kSATsbFkIVKmknCdtuXou88mnToI/TdTTEvuD8DPSDSzJ701KzMWL0aTV0n1lje5Rz+x735+K4CKax0Uf/g1WICByapgDSLpqeb6pP0SyCc0yUgune1+6/gYrPz0FMbnEy18z/rcj3aMYtqcfVXVk+iVL65/p2Z9aoYGLykXjhNk+GYUAX2EikmQ0PcuYJ4MNffjpxXj/j7C4X814SEc/iXb2xsZqYpB9Qow0yC0LV66ruQC6wR4MPo+R/ScfbmeRgRneEuR5lnY83MNEQ+nxSsUd5smqqqXPj4vjtI5UpYT+5+xGERHd3KyYbd86iqpHJEDGSv4nulePdLIK0yfFBcMLFJldJKoTrMv8KhYYlLtbNX/lEPEpO7c1kLm8bqWTrNNW/4X8x9yP/UTVzPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199015)(7696005)(26005)(9686003)(38070700005)(38100700002)(478600001)(7406005)(7416002)(2906002)(5660300002)(66446008)(66476007)(122000001)(64756008)(6506007)(86362001)(33656002)(186003)(55016003)(83380400001)(71200400001)(41300700001)(66946007)(4326008)(76116006)(66556008)(6916009)(316002)(8676002)(8936002)(54906003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vayyNxnXOlkX/5MhJt+3eDTiazbHS5W0MUeRO2f1nONFhepBpKUn0JpRUU7K?=
 =?us-ascii?Q?dgl8Z41F8xaOrN49OxYthVfvUmvdeDrHhOk2O5DNJVPtIozJvb1m0cNxHdek?=
 =?us-ascii?Q?AjoKvEqvfflHDhzMU6N9tDo6YjwGkbh8WfLMyXLsNYmWHvv/a4S8DXZiT5Hp?=
 =?us-ascii?Q?BLeIdhK4aJs5ov/1oa96j2CAU3YAyj6/BIglnxOJAzMCmfjKlhYjGeoceOAJ?=
 =?us-ascii?Q?B41BeiS7WAWc/sujAUoH1vMmcWQc+++dVjA0D0PJ0PrsKYNb3Ta/2x3QDc/B?=
 =?us-ascii?Q?nt54a+CtQ8ABobqsIjUptCCuO+15RC0r460kjEMqY1oPONGVb6ihN2U607he?=
 =?us-ascii?Q?QDD1lDjTUCc2mzQsf213VeC8tyz7h2iV5WF7poQVhok9JEY/LpUEMBMqA0aO?=
 =?us-ascii?Q?6rxTXOlhmWd6fhl+ssD/LDt/lyWod/xrrSGFTd0uzkRrRNb/KjDRicazPcXc?=
 =?us-ascii?Q?wWPSECX+u/Ot7OyVAG/HIDTuU/mleiYrdRR4LX/iiDTih5BW8iXlhb/5rKNA?=
 =?us-ascii?Q?Z0r0zSgTsNj1DKWaAx8pHn+jCONy7Wjwrg44GqCDWgZwURS8ratp5hI4VwKt?=
 =?us-ascii?Q?zpfgQWrjYugpbpDSYn5B6oo1n6oFky9u9yjmNWuKqGt+D/U8mpP03VPV6bq9?=
 =?us-ascii?Q?2u7Abq9M0mbo2yYgt6cx15LjUxVo3X7gLp5kh3t1LlnOSVhBv77gGKiNj63a?=
 =?us-ascii?Q?T5C+AMgQtTu0qKOfLHbyxHKrOpl6FKqOzwCcROW10RC27Sii2m+ll35w9DlT?=
 =?us-ascii?Q?j9ddU7j62DQA1ZD+9G6oS5FuvNFpLYeY3nxuVjHILFKv88Yeu7qBpaCxOkS+?=
 =?us-ascii?Q?JnboITythJXx4vJk5ilatF38g8VOSe9NsoYsHXQPGAR4RsXAtdCUQU6u7xsI?=
 =?us-ascii?Q?QVgYUTEECrm0yBVNtrwPHUK5k4cQZNm6q7h+/JRh8OeJwCPzvUI1zMlJRxF1?=
 =?us-ascii?Q?BL+xqw12SIBVIp5JqkIJv76s27Tnjh+gC35nYO/T5bjkLjdInpwODsFIvALy?=
 =?us-ascii?Q?CGd/aUAzAlOQAf82BZLwgM6MZX3gObEp1aoKcz9atb6k2FGfFCY4DXFgMCjN?=
 =?us-ascii?Q?MgN3zVWUjBMssfW08Kta35r1bM+hg2TJg8D7J3lSQmqBbrHYBQDQY3L6DD0K?=
 =?us-ascii?Q?cCD10/RUO3vXDJ6mEtnjQjTmXuWtAtxE6KcsDnFmmUoB3ouzxPWqYBx4f6OE?=
 =?us-ascii?Q?5Kd42eZE977DkeERLWlyey2u8UmQfjHktUZBwcA7UZLozzlaYJBPqwDx+/Uv?=
 =?us-ascii?Q?2EK8uyVtCzeWn9McPX7LW5iR7GvehxsEYRjASrrK825NhADOMAmGQwQHZBZy?=
 =?us-ascii?Q?FAoEEM2atsQFFYTg3iuy9Il4c41uRtTGzz/Xn9TYFBtsUZ/7WojQYZc9msT7?=
 =?us-ascii?Q?zAYShS4zTKV7sftyMnpAM4cQQfwQ3iGUAUGMBIwr18AESgXciCLQ/LYnyvGe?=
 =?us-ascii?Q?GNJ7ZDGvITOp6KE4fpKWs2Jh09XswqwV0FhPCJiOXR7TvxVGR/l9YppJNb2w?=
 =?us-ascii?Q?2rRgboM9euMFTWSbyWeQbSCQgCPloN5/o0sFK3qS5rVs5briGfwVat1cDuhX?=
 =?us-ascii?Q?eCgz8RhU77Z4VpwKHVA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93ab987-e723-4cf2-05ac-08da9b0e8327
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 13:46:25.7941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VVswLz+iX4uOggK2lEySxRoDEEXNKvykDOR07xh9z45M1sfvK25dhHwW6mKvYwnBG+Bo8yxyxUwsxz8CnXEr/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6645
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

>> +/**
>> + * struct sev_data_snp_platform_status_buf - SNP_PLATFORM_STATUS=20
>> +command params
>> + *
>> + * @address: physical address where the status should be copied  */=20
>> +struct sev_data_snp_platform_status_buf {
>> +	u64 status_paddr;			/* In */
>> +} __packed;
>> +
>> +/**
>> + * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE=20
>> +command params
>> + *
>> + * @address: physical address of firmware image
>> + * @len: len of the firmware image
>> + */
>> +struct sev_data_snp_download_firmware {
>> +	u64 address;				/* In */
>> +	u32 len;				/* In */
>> +} __packed;
>> +
>> +/**
>> + * struct sev_data_snp_gctx_create - SNP_GCTX_CREATE command params
>> + *
>> + * @gctx_paddr: system physical address of the page donated to firmware=
 by
>> + *		the hypervisor to contain the guest context.
>> + */
>> +struct sev_data_snp_gctx_create {
>> +	u64 gctx_paddr;				/* In */
>> +} __packed;

>So some of those structs have the same layout. Let's unify them pls.
>I.e., for

>sev_data_send_finish, sev_data_send_cancel, sev_data_receive_finish

>you do

>struct sev_data_tx {
>	u32 handle;				/* In */
>} __packed;

>For sev_data_snp_platform_status_buf, sev_data_snp_gctx_create, sev_data_s=
np_decommission and all those others who are a single u64, you use a single

>struct sev_data_addr {
>	u64 gctx_paddr;				/* In */
>} __packed;

>so that we don't have gazillion structs all of different names but a lot o=
f them identical in content.

These are structure definitions as per SNP Firmware API specifications, and=
 they match the SNP Firmware commands and required arguments.

As an example below:

8.12 SNP_DECOMMISSION
This command destroys a guest context. After this command successfully comp=
letes, the guest=20
will not long be runnable.
8.12.1 Parameters
Table 55. Layout of the CMDBUF_SNP_DECOMMISSION Structure
GCTX_PADDR Bits 63:12 of the sPA of the guest's=20
context page

Isn't it better to have 1:1 mapping between specification and structure def=
initions here ?

Thanks,
Ashish
