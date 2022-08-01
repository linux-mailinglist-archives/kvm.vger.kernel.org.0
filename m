Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39585872F7
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 23:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiHAVRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 17:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiHAVRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 17:17:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3821EBA8;
        Mon,  1 Aug 2022 14:17:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U87ljznhDGPVTKJwI9LxlGuoTDdDwR6gW8OkRGMnAei4MmERwVnU+73o7Kb7VFycsPgus2LUuvl9QHVbWWiw2ag9/S5InwKsM0FaN5g2tmzmYTT1dTTETO3bfU7QdKfEAYHQWSNbmwGtcsKIAZBXIHEy1f8n+EZcaJQAtQxN4R1ioTCM/siNFv8I3kJdXHrun/G0pNw5mecrb+Zr2jqabqAG/H84fA4WmnchVI85HkvckuVQ5P71EANrELuZarCzSwf2010mnHpvHM3g8Q5jJx4m8DfvYrYyoNLz8bK39G48kj2CesdtMDpS62qiR9iCFbj65zCJAC+Z5WKOSzIFzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpqQd22bqrTvEROt+OEccsZUZ8yQcjTls+8kkrcp0rM=;
 b=hVGtwpenp1sWIe8hLMoMFhME5pXVT0IpqAVK6ntLKquLzZA0GmW2pKjoC9ZD56SSPI1GXyCKgnH5MKVWuG2fM7GEQlrKJBc8rijdnY0NaZHfTXZvU2G2j/asRo9jGmahU3yjZel8EdBQS96+BQyHEli6GI2MH4KUskqCYNsLlSE/lvHMoeT5PwF399UNBhQA33WWJZpo7NxSwePCMLMwVMg6//MsqYGG2IzaF4s2xoOiDj06OMLjpgJkvzicxhfnEFqPpxqz4fLgO+kg0qaQj/Yjk15gAKjqcLiXLGxg4eBklYH0pJnvTMaPcNy3So8F1PdNrlOPWbgQeBNGTzgcHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpqQd22bqrTvEROt+OEccsZUZ8yQcjTls+8kkrcp0rM=;
 b=wR8HIxJA4V8YKIbM2IIr0N5bkuJnnjChsQHC84Fq8JwLJRbUZ1v1OJBaNZG+NYzY34AgX5kbXhWJBN67h0oAs/mo/jFhqCaddGfZRe7YhuJJvoZinsIJ1jcmzeNrgX9yUUm69LnhrLnuMX1MDrIuKAiDoIh3rFydGiJDQvdfuXI=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM5PR12MB2582.namprd12.prod.outlook.com (2603:10b6:4:b5::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 21:16:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 21:16:59 +0000
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
Subject: RE: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD
Thread-Topic: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD
Thread-Index: AQHYnPUTHKwH72twn0SonkZJNWcjVa2anSoQ
Date:   Mon, 1 Aug 2022 21:16:59 +0000
Message-ID: <SN6PR12MB276752B7FA83BC454F0C3CAA8E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <c933e87762d78e5dce78e9bbf9c41aa0b30ddba2.1655761627.git.ashish.kalra@amd.com>
 <Ytk4fWCC3feXdAPW@zn.tnic>
In-Reply-To: <Ytk4fWCC3feXdAPW@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T21:13:27Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=7c8e1507-c73c-4d53-930a-7390f7667733;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T21:16:58Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: c264213b-7005-471d-8b86-69a196b44eac
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffe6f863-fe81-4bd6-5a84-08da74032be0
x-ms-traffictypediagnostic: DM5PR12MB2582:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3nPnNHdT0hTJG3T+CvLnRvyR8A06pKFnxvVTr43Klj0l/sPH2CM6blWo889sfYywczdqYYB7g37v6/X3b/FZ5eQnGB76nL5tsdqDo10t273GJl17JRml8lBot6yzPU5UH3TbL8lAHfdu9hiS+fimodAz1avn1trs155RByuQ1Jp9Be5CDutNttTYYECTY8I5CDtxUpxx4ROSytsVOPPG+MCGNlLZQNO3HvLdPxGeGVqV11r55kohdUxZGokQ0b8enuYIis80Qk6f2x9l7J9uWl4tb7IqYpv3Q7b/ak/YyBRy3Soc2a+ORaY4Lu5Dbz0TP+seBrPozoxT02OYN5CQ2COhi4q0GupeP+QjfhN7X3npdFa6qz6xIZeDHRBjEpuzZFLYMCaIhfr/6heXW88A/r4wdalyTefXX9+SU0smu3kDv4GNRi/EwHwV+Drf+0Lk1p5NDaj/RH3H97FzaR9Mwuve1RneKxfsCFaFOc3EMnjRxC6yGmJfR1usWXs9hgr/yv1W/OpRx6qJgn+hqbZt1YJtJywe/YEMFlFtV59Q11aJtBOyRVFYe6uk0JEptViuj+pbsq3/CRk8vQ/UuV7Y6+lMtHqfV+aHpPmsebwDjKhqNCFawsEMboQr9JSOCBHc718WhIMWLi0h9Bqp5DigGLA4eYZmrpkFUzb5t2lo7K3a64AFCjOxM6lv+LPdb77e3z51jJTzmRrf/1ikIdZDl1dSWJzX7o0QaNhW6jjV9zx973AoKXhHyvXYssBRKe+KhnWZVInWe/rNir/Biy9JDUC5DXbnVz6BQW+yZjqEIy3ljKLJyynrubWB9ci+6an1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(33656002)(38100700002)(8676002)(4326008)(478600001)(86362001)(7696005)(6506007)(2906002)(71200400001)(55016003)(41300700001)(54906003)(6916009)(5660300002)(52536014)(7416002)(7406005)(4744005)(9686003)(26005)(8936002)(316002)(38070700005)(186003)(122000001)(83380400001)(66946007)(76116006)(66476007)(66446008)(64756008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ylOO3wyrAz5VgpK8dICy6D/QdTY/RMyFZjc26caj3mmrfeoWZk/S1gPccStV?=
 =?us-ascii?Q?KeQUJgwZEGUsOmMteRfNhu2RwQ0L2jfI2fSXlKHnUHT0/oezPFgBUNTXKCS/?=
 =?us-ascii?Q?ELXWIHYdv0ck2sgnfE7aYh01I5yNdgGc1hbZT85AVMpu73FZ2uptYXX4y2Om?=
 =?us-ascii?Q?ztcLH2wknk7qPDOrOIxla9lz3iilwLTYmli3e2lWkQ9oRVxs5c7vkS922mPo?=
 =?us-ascii?Q?ltNo7ysg2HIpvP/YNgqC6NyIXFUlj4OqPdnUP5eD1SSmORnN4Xd02iaHrlSH?=
 =?us-ascii?Q?7cafMJVtyUWXfjtN7lAPiS7zuJQwtf+2CTyrKF2BkvD76aQ7PdOYUCwzF+Em?=
 =?us-ascii?Q?tjdWId79K3nQZSJRnxdHa97r/eNI84PdmmsCmbS97CkFGJiVr22ChqbcI0xC?=
 =?us-ascii?Q?y0IfglczJOuwdg6JVR68myFRTAoKO3BQ9DXks1F8rKKzxT7nEZSfR7/xogIC?=
 =?us-ascii?Q?0WNZ8TbuY7Z5h7gKrnar3iakm1Zct8WJT29FLyD5V8+PvSKD5PREN+Zl5z6E?=
 =?us-ascii?Q?6aHhN2h46rJTgyg0bXdqQYpgrNha+WYI1iujp5BM055hxyHdJoQNpXjOSHps?=
 =?us-ascii?Q?isTYBXIeylF4D8uQF0aq7yKXHDhZ2ML98QHPhJxRgGVtTko7YGnnlKap+AIe?=
 =?us-ascii?Q?Vkg8ydv5DSNMNRAPpV8rhuPWGEqIqpbx8FgTiutkXBemdvjsxcAXFmTvOwn7?=
 =?us-ascii?Q?jscMr/lokBwAEhL9FokhJ3xHaVInIoRaoG6anQ2pTnIAM+VFEiLaCLz73RCz?=
 =?us-ascii?Q?npuaspCLy9Tu20eVFgJnVhS1qulJjFhvI4MTx34lD/H1WPquQvI8yt/GaR5k?=
 =?us-ascii?Q?r4phh/2GnDrAnAhukxzI1t0WKC6GKr/SC7tbSMrg7ux9haq0sL+qXUBl5/Af?=
 =?us-ascii?Q?D30bNzg0z5uWpDzq4rCcD9Ac++tuNdqMMzXkLhzAjdWlgMsE0e/yE7aARwcD?=
 =?us-ascii?Q?OOuVHmXguG/WeiXdST1kLzStLA7VvfW3BbvaV67yUHTb9k5wY7AWkRkOGaiV?=
 =?us-ascii?Q?0fZvNTjA0xtOBeSBbAmeb2+gCV6J6l9m+RH7h9xO1WMrJWFas74EkXqX2CmW?=
 =?us-ascii?Q?SDP2zz7u0V1Pq4UXtYmbI90kP3oQcSpCgzeZYD5QrWGqy8+x7au0YuD01lq6?=
 =?us-ascii?Q?r3TTRjTcmqi1k8nvJEf+Wn6w9zN2a7lUGdsuqFkG673guFlaKFFZFPoz21Pd?=
 =?us-ascii?Q?rbhLBwJWuhnrs+BNhcsAvNPJ2bkrDe3ZVHQM21u9Of0b4YDTh2zR1/5pT8Fz?=
 =?us-ascii?Q?96QPWDIcCid3Oqehmkbpm4h9d6RJVPreXhxUXIn/W+VzMb3kVz/HjbY8LqUX?=
 =?us-ascii?Q?73yGqgLC05425VBJsO06Hsc2LRII4LQzaDCxE66pnj+jfBSs0+EJoGmUnm51?=
 =?us-ascii?Q?U6WDLA0px5HSMmyRk5J5ywoV+qu4Un7Uwz51UOYrwPExJLe/lUAl1jCyd2iB?=
 =?us-ascii?Q?d+yKrFCy2Kg2cjZ/gq+NOYWz8qp9SZAZahrotXd3s2PhY22QBPODKafxJLZO?=
 =?us-ascii?Q?TbDnP85+3l+buZ2JuVh069jv+u0wrQJ5re0fSndBh/O1jpkNF8V6ZDT0VKKY?=
 =?us-ascii?Q?OWL8XQh9NzH+nHbvw84=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe6f863-fe81-4bd6-5a84-08da74032be0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 21:16:59.5725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EXdQpSkzeeqihVpNCdRUlEehXYhM0Fw/c852HFGnUX0XjXMojPBflQTChRv4KyZ1gzNAEUvOw8e1s+4V0TXwkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2582
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

>> Subject: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD

>That subject title needs to be made human readable.
Ok.

>> SEV-SNP FW >=3D 1.51 requires that SYSCFG.MFMD must be set.

>Because?
This is a FW requirement.

>Also, commit message needs to be human-readable and not pseudocode.

>> @@ -2325,6 +2346,9 @@ static __init int __snp_rmptable_init(void)
>>  	/* Flush the caches to ensure that data is written before SNP is enabl=
ed. */
>>  	wbinvd_on_all_cpus();
>> =20
>> +	/* MFDM must be enabled on all the CPUs prior to enabling SNP. */
>> +	on_each_cpu(mfdm_enable, NULL, 1);
>> +
>>  	/* Enable SNP on all CPUs. */
>>  	on_each_cpu(snp_enable, NULL, 1);

>No, not two IPI generating function calls - one and do everything in it.
>I.e., what Marc said.

Ok got that.

Thanks,
Ashish
