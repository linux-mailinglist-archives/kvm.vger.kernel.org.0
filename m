Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C9A587675
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 06:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiHBEt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 00:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiHBEtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 00:49:55 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2066.outbound.protection.outlook.com [40.107.96.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1CDE010;
        Mon,  1 Aug 2022 21:49:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M47BQ6GRwpHIxuLzXuZxnvVTKIGvEmeUz3o9YUKgkKDxjYHExCUSJIBugBpLoFtljeQ6EhMZoGqZFzn7l3Aqp5xCNyCUz/wiGkmCNXJ2iV1VrIAKy23FZagjjWc8Y2o+3DRGnr+sejkkliQj5JnTw+ANuJ4WDrS3UPTN3PTCn7dlpfZvL32vSsaXXfNKLm6nRhgqqlbIljtjvxhQpPkiY6KO0gDA2Cjfa82WeKE92EhB3WIMKGIt7gpqDYk851ovkqWVvafr9LVI4Ft+1Gwt4XlAXtvZQL18L4uS8jzI5z2yJr71Ci2nzlgxKa1WL7gTr4h8ZnlvRySo9kqMeM8yNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NQnlLGcnbLi0PZ/mAz+2YuQwonRi1UV0y7n2VcX896I=;
 b=j0HGpB3nyJds3Kff8NkaCAHEV5avQ3wQZf7BB9AHWffIjyEpW73NsJIJQT26AuNn7d+uVAK8ZwabPq6jyqcSm/KQ1Tu2/iL5KlO0iWkxtub+lDAK03KxCPY8yoTeECLZ4seizXCcBVXidJa25vCbzk69Y8Q3j2U5mSF/0JdFYX9koMdBXiuwBOibmvirNFMSqMaTxxx2Ga5lIvjiruOXftCS21EwRKWG9Z4YravMYJ6xQDdFvrLnOxqGVDS37EhWl6PMr8TJlbmUlwGnQqsYvoJhkK7X+z6tHq5HBsyvDO+bzRmw/HAME7Jpg+xIFP7G7B7WyuoySjD04GNA7fyeDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQnlLGcnbLi0PZ/mAz+2YuQwonRi1UV0y7n2VcX896I=;
 b=XpZBHuRsmtv+0Z8fWX2xqECjvQmTohbs2f52WS1rQu/xPIWwHSfQ73LyqQloQCQRdcFWEpdn5GqZnwLaDILU/iXv+zbB0OL1UnyAZrbNGRxy4h/O++gYgWt2Q+oSAy6KzXoLM4BSGtVbevD6LgR/TyZ4oQp71QhBjgr/oYc3rG8=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BYAPR12MB3094.namprd12.prod.outlook.com (2603:10b6:a03:db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Tue, 2 Aug
 2022 04:49:51 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 04:49:51 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Dov Murik <dovmurik@linux.ibm.com>,
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
Thread-Index: AQHYn4NDulHh/HmbIUq97K70l/FApa2bEhKQ
Date:   Tue, 2 Aug 2022 04:49:51 +0000
Message-ID: <SN6PR12MB27675C337244C0A6848167AA8E9D9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <240cc182-4628-bef4-2b99-47331b0874f1@linux.ibm.com>
In-Reply-To: <240cc182-4628-bef4-2b99-47331b0874f1@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-02T04:30:09Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=81a38740-f7c5-45b3-ad39-f83b7a883699;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-02T04:49:49Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 36b52632-7cc0-428f-bb24-33e8cc8e3cea
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e998ef02-cb06-4edd-03f2-08da74426f8e
x-ms-traffictypediagnostic: BYAPR12MB3094:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wwv2dtFwy0UVd1ZcSH9jmM/yHQ6h6UcZp5R2U6UIfqwVxUjxPwI6+fe2QubJHMkV1Y0QdhX2xBMdqrpoM48YWwLRWc/RX2PsM6g7m8EHsa1uizjlsQVyv7JBQ9FCUtehF32REEDPThZ13HQ7PUVkCI/GvLw184oJoC60TU0u9U477bCuu6EEoIgPh+QMB+DUGUqTXufHr/rFlmXI/M14RDbr7AYRFR12rA9lDBbV7NGiYv2K6O2QakH7oNefz4PSqmy4uBAj0OHhwbarzmlfj8iv0SkiWtGZ9pYoTafzQXzSTU/T52FWXo6PBEoSeUawhMQRmzKTRhj30o+wYzgQlKtnyw/rxQncc3QNfAFw4MMSSIMwaKux0WYI/1iKPwK/p1N1rhH40VfbIdUoZzWQ7r0wq5yjgjuWde9IdJhtL2B1Dboc5k5/zD2ZBLXMtxaCjQoH1Y01Cl5+xD+vph7Zvv1JOJ/LiPsR8L7fPjFl27XVWfzta/0eh8BJnu2Rx8ZaamrS3VV4CzgCuGDC3K1qHuOLXI2JT6sUTplN2F6HiDnmm3a2Cm6sWPcTMNQfsRpAwwo98H1F1LtXLv3tlGccEJUsoJ/dS2BXEpkNVFfLazbntC90inXuVfjuhMNrAC9pwnL5a19oDYK8syXff3qpEUpO2tBMkh5vlDRM5fsQi4AnC28+UjUySqBQSOiQkUkEWeLbcDeWYTCOoyocOR+Y5W56YwnWRrFRolPk21sDq5lnc6iiBeQ9q/wjMbq5o/tsW6TToMrQn+r/ztKZ2LNhzJcIJRU5sXyqWORuLzMGcFArDgeAA24BKTcfMy0MXinQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(26005)(7406005)(5660300002)(186003)(38100700002)(7696005)(9686003)(7416002)(86362001)(6506007)(122000001)(41300700001)(316002)(38070700005)(71200400001)(66446008)(64756008)(52536014)(66476007)(76116006)(55016003)(110136005)(66946007)(66556008)(33656002)(54906003)(4326008)(8676002)(8936002)(2906002)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G9ii9+fs6lVUkYe6L+67EF5om4BSql4zhHb7o7DtMYZQ6gtGOjhqnzU3M/IB?=
 =?us-ascii?Q?cPnK4CsnWCf7pYZbkq8V9mCgPSAMuZHajX0YXAFs7drb7+95WQy+1GMby7Ii?=
 =?us-ascii?Q?pa/lMeFnEJJRVMKRB1oCuQmdaoY8sjP94chMmRWnd+buNI1rhk/PGGV+V8RO?=
 =?us-ascii?Q?oms9gTjmlBRFG893GkBEieZH8p37LgmGt7KExleOW9YO/zTbAyni93//NWHY?=
 =?us-ascii?Q?TnH7VDO3kp2LHQl8eHInAtl+++mAsNrpPekBWbrqkP45YoMb6ERY7gSbtBq4?=
 =?us-ascii?Q?geTnqN9q4Spjxp1kVvRvZjxuMzJ/JlkNme7dIuqqwQI71z0ABDHnDh8LJiVJ?=
 =?us-ascii?Q?ZR11as4H8dn3AplebVL0z9Zo7BUxZf1UCfH+WfmJZZ6+NZ3uBZlghrYCMVEI?=
 =?us-ascii?Q?cH38zJccwC/vC4zBpF1ueCLys9h+W6jH46Sv342WWJ8huYaqj7JfF3qwpCg6?=
 =?us-ascii?Q?HDXB5pDQomyFSrv87FPkrp55r98OciaLpNQ6hvg8r08bKKi0SB407eAEljql?=
 =?us-ascii?Q?GB9UTsLJnsG/Ga8hsYV6JiKvJpyGOy/6/XGkaI21yTcg8AjafB4x0LeGjB/n?=
 =?us-ascii?Q?1AMF5+NcBHcA/Tlp6glDi3xZnP6d1XSjeURqA8GaIv72xdYpl82kZb9X0/en?=
 =?us-ascii?Q?s27+iCM5Tlsn3GD28QURO+aQSS0F6JchRos3lev7f8FkCRLyNR1cQbCuKYOp?=
 =?us-ascii?Q?/lmVCKo5HP3qYrKQ/Qs+dUoxOOw2Fq22ioPNY06B8alWIq1emIlcsH78uLFy?=
 =?us-ascii?Q?iriX06FsoYI5sVT5EjsVIG0wHReEXU52fllbDbKjiXCqKFqQeQ+G4K7Z3qGb?=
 =?us-ascii?Q?tzIjULH5zUnaRrVqa9+o7WeD+M3fvh6oGefS0UC/bH1pp5Ql08OYpbZtu3rH?=
 =?us-ascii?Q?YVkPrxiI7Nqr+zIc0fOlCxieEp30IB9j1iJlpGvxqiHOEYOktxl19y1etmQo?=
 =?us-ascii?Q?ZNZQEJht6Z2JxqM6xSsih4v0bBNmqO9xbuB2+7PC3+iKWxmYa9vNvW7kA8Rg?=
 =?us-ascii?Q?sS/xhrBoUoD8qJcB9zAN3A+2NSlY4HWrX6PlsKqwHuOGMbLg9VwYV5FIlnG1?=
 =?us-ascii?Q?XYMY6uj8PODIXafkHsFU3kypvJarcKFlmWoW4jIoIx/Af87WnZ2vAS2PwZTC?=
 =?us-ascii?Q?w35sAqw3VHJtG7bG1td9j2huIToK2JTEBxbm4p1thWjJQACLd4eXaiXuPahE?=
 =?us-ascii?Q?oVS/8isVvtPXTX+PQEzWhoFZV8KHFfEmdaPzUWnHXFkOzVt3SjX28DURrE53?=
 =?us-ascii?Q?/x15nzOLvf49EBTYy4LqHwqUdqA3OztATcex1abKsmZjDGo3Qclwauw1Zfzs?=
 =?us-ascii?Q?AuBeOx/QAR90uXIkhiJI1/EHjh0Aj7CcmnxWOYlw3LzMoGO56rztTMoFewTY?=
 =?us-ascii?Q?RSR9CbZ2J03JzgOo8VcsN9AmwcEblSWLWb0dZK+7BmBMED7OSGAdHocPNzAI?=
 =?us-ascii?Q?Kku5c2Rl8Mo1pHyRvWKL9sDBvvZ5L8DAPhy2yiVzgpqsQ2X9itSJr4yCb31H?=
 =?us-ascii?Q?WpHhBrkLzIrV+onQ6G/Tk87uZgYFcKBDNleR2/fNMtH5GSTge86te7h0/ihF?=
 =?us-ascii?Q?c//fdeOvGs9QN0XfVok=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e998ef02-cb06-4edd-03f2-08da74426f8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 04:49:51.4275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ZoXLPfC6iJCdXJslA/uTqIJuD+9JtWLOKdnDaSnLpnYM6S585PxwILptKTPru7Cr/FVASL2V65R9XxcWSg3SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3094
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

Hello Dov,

>> +int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid,=20
>> +bool immutable) {
>> +	struct rmpupdate val;
>> +
>> +	if (!pfn_valid(pfn))
>> +		return -EINVAL;
>> +

>Should we add more checks on the arguments?

>1. asid must be > 0
>2. gpa must be aligned according to 'level'
>3. gpa must be below the maximal address for the guest

Ok, yes it surely makes sense to add more checks on the arguments.

>"Note that the guest physical address space is limited according to CPUID =
Fn80000008_EAX and thus the GPAs used by the firmware in measurement calcul=
ation are equally limited. Hypervisors should not attempt to map pages outs=
ide of this limit."
>(-SNP ABI spec page 86, section 8.17 SNP_LAUNCH_UPDATE)


>But note that in patch 28 of this series we have:

>+		/* Transition the VMSA page to a firmware state. */
>+		ret =3D rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);

>That (u64)(-1) value for the gpa argument violates conditions 2 and 3 from=
 my list above.

>And indeed when calculating measurements we see that the GPA value for the=
 VMSA pages is 0x0000FFFF_FFFFF000, and not (u64)(-1). [1] [2]

>Instead of checks, we can mask the gpa argument so that rmpupdate will get=
 the correct value.  Not sure which approach is preferable.

Well, the firmware is anyway masking the gpa argument as you observe in the=
 launch digest, so probably we should do the same here too.

Thanks,
Ashish
